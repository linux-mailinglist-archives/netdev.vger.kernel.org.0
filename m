Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A654069623C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 12:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBNLTt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Feb 2023 06:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbjBNLTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 06:19:48 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DE7E3BA
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 03:19:46 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-Molc4eK-OEaTT-3dYfIEDw-1; Tue, 14 Feb 2023 06:19:41 -0500
X-MC-Unique: Molc4eK-OEaTT-3dYfIEDw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60FB285A5A3;
        Tue, 14 Feb 2023 11:19:40 +0000 (UTC)
Received: from hog.localdomain (ovpn-195-113.brq.redhat.com [10.40.195.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A23940C945A;
        Tue, 14 Feb 2023 11:19:38 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH net-next v2 2/5] tls: block decryption when a rekey is pending
Date:   Tue, 14 Feb 2023 12:17:39 +0100
Message-Id: <4a9a82a0eaa47319e0e7a7fe525bd37f25b61cb5.1676052788.git.sd@queasysnail.net>
In-Reply-To: <cover.1676052788.git.sd@queasysnail.net>
References: <cover.1676052788.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a TLS handshake record carrying a KeyUpdate message is received,
all subsequent records will be encrypted with a new key. We need to
stop decrypting incoming records with the old key, and wait until
userspace provides a new key.

Make a note of this in the RX context just after decrypting that
record, and stop recvmsg/splice calls with EKEYEXPIRED until the new
key is available.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 include/net/tls.h |  4 ++++
 net/tls/tls_sw.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 154949c7b0c8..297732f23804 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -69,8 +69,11 @@ extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
 
 #define TLS_CRYPTO_INFO_READY(info)	((info)->cipher_type)
 
+#define TLS_RECORD_TYPE_HANDSHAKE	0x16
 #define TLS_RECORD_TYPE_DATA		0x17
 
+#define TLS_HANDSHAKE_KEYUPDATE		24	/* rfc8446 B.3: Key update */
+
 #define TLS_AAD_SPACE_SIZE		13
 
 #define MAX_IV_SIZE			16
@@ -145,6 +148,7 @@ struct tls_sw_context_rx {
 
 	struct tls_strparser strp;
 
+	bool key_update_pending;
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 238bd18c5eb6..149a39d9a56a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1687,6 +1687,33 @@ tls_decrypt_device(struct sock *sk, struct msghdr *msg,
 	return 1;
 }
 
+static int tls_check_pending_rekey(struct sock *sk, struct sk_buff *skb)
+{
+	const struct tls_msg *tlm = tls_msg(skb);
+	const struct strp_msg *rxm = strp_msg(skb);
+
+	if (tlm->control == TLS_RECORD_TYPE_HANDSHAKE) {
+		char hs_type;
+		int err;
+
+		if (rxm->full_len < 1)
+			return -EINVAL;
+
+		err = skb_copy_bits(skb, rxm->offset, &hs_type, 1);
+		if (err < 0)
+			return err;
+
+		if (hs_type == TLS_HANDSHAKE_KEYUPDATE) {
+			struct tls_context *ctx = tls_get_ctx(sk);
+			struct tls_sw_context_rx *rx_ctx = ctx->priv_ctx_rx;
+
+			rx_ctx->key_update_pending = true;
+		}
+	}
+
+	return 0;
+}
+
 static int tls_rx_one_record(struct sock *sk, struct msghdr *msg,
 			     struct tls_decrypt_arg *darg)
 {
@@ -1706,6 +1733,10 @@ static int tls_rx_one_record(struct sock *sk, struct msghdr *msg,
 	rxm->full_len -= prot->overhead_size;
 	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 
+	err = tls_check_pending_rekey(sk, darg->skb);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
@@ -1957,6 +1988,12 @@ int tls_sw_recvmsg(struct sock *sk,
 		struct tls_decrypt_arg darg;
 		int to_decrypt, chunk;
 
+		/* a rekey is pending, let userspace deal with it */
+		if (unlikely(ctx->key_update_pending)) {
+			err = -EKEYEXPIRED;
+			break;
+		}
+
 		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT,
 				      released);
 		if (err <= 0) {
@@ -2141,6 +2178,12 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (err < 0)
 		return err;
 
+	/* a rekey is pending, let userspace deal with it */
+	if (unlikely(ctx->key_update_pending)) {
+		err = -EKEYEXPIRED;
+		goto splice_read_end;
+	}
+
 	if (!skb_queue_empty(&ctx->rx_list)) {
 		skb = __skb_dequeue(&ctx->rx_list);
 	} else {
@@ -2526,6 +2569,7 @@ int tls_set_sw_offload(struct sock *sk, int tx)
 		skb_queue_head_init(&sw_ctx_rx->rx_list);
 		skb_queue_head_init(&sw_ctx_rx->async_hold);
 		aead = &sw_ctx_rx->aead_recv;
+		sw_ctx_rx->key_update_pending = false;
 	}
 
 	switch (crypto_info->cipher_type) {
-- 
2.38.1

