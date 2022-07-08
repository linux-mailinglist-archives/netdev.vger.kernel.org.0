Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4E956AFA4
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbiGHBDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236792AbiGHBDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E758EAE54
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E85D61830
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D944EC341D2;
        Fri,  8 Jul 2022 01:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242208;
        bh=FLDBwS2BroDjFIqB2TVNo37p/JOsqM0xAWM01qspOWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7QaVts1Q01kdrDBH2F4yfjVVIRT5NaOJFRFWuKAhV6N+wmljb0E+1m1hHRN2B/lr
         gP3ba7c/LTHt/BbGJW/TRsC9Luo6ZHhgPuCm24U30BZP8wvUXqanmVif7yzlslZNj1
         YdgzjdCTQIrbHAoYjTY3QcTQJU+C5LBNjNbAQgqlHfPAc1UBdfNWLRCFjplB/r4Rwp
         m2E1W0sNDfIzjaHyXXkiQ1WYd0f2YQrl8gvm9P/abQ1cMlgcrRIG08tc+nTowo3smD
         xXuC4WglaUJR6MPPwN5VCZc+53ZgIuV2cb8kS31J/VANIwXAhZ401/neBjDCEdRJ9C
         wbSpdpKcmUnmg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/6] tls: create an internal header
Date:   Thu,  7 Jul 2022 18:03:13 -0700
Message-Id: <20220708010314.1451462-6-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708010314.1451462-1-kuba@kernel.org>
References: <20220708010314.1451462-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

include/net/tls.h is getting a little long, and is probably hard
for driver authors to navigate. Split out the internals into a
header which will live under net/tls/. While at it move some
static inlines with a single user into the source files, add
a few tls_ prefixes and fix spelling of 'proccess'.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: fix build

 include/net/tls.h             | 277 +-------------------------------
 net/tls/tls.h                 | 290 ++++++++++++++++++++++++++++++++++
 net/tls/tls_device.c          |   3 +-
 net/tls/tls_device_fallback.c |   2 +
 net/tls/tls_main.c            |  23 ++-
 net/tls/tls_proc.c            |   2 +
 net/tls/tls_sw.c              |  22 ++-
 net/tls/tls_toe.c             |   2 +
 8 files changed, 338 insertions(+), 283 deletions(-)
 create mode 100644 net/tls/tls.h

diff --git a/include/net/tls.h b/include/net/tls.h
index 9394c0459fe8..8742e13bc362 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -39,7 +39,6 @@
 #include <linux/crypto.h>
 #include <linux/socket.h>
 #include <linux/tcp.h>
-#include <linux/skmsg.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/rcupdate.h>
@@ -50,6 +49,7 @@
 #include <crypto/aead.h>
 #include <uapi/linux/tls.h>
 
+struct tls_rec;
 
 /* Maximum data size carried in a TLS record */
 #define TLS_MAX_PAYLOAD_SIZE		((size_t)1 << 14)
@@ -78,13 +78,6 @@
 #define TLS_AES_CCM_IV_B0_BYTE		2
 #define TLS_SM4_CCM_IV_B0_BYTE		2
 
-#define __TLS_INC_STATS(net, field)				\
-	__SNMP_INC_STATS((net)->mib.tls_statistics, field)
-#define TLS_INC_STATS(net, field)				\
-	SNMP_INC_STATS((net)->mib.tls_statistics, field)
-#define TLS_DEC_STATS(net, field)				\
-	SNMP_DEC_STATS((net)->mib.tls_statistics, field)
-
 enum {
 	TLS_BASE,
 	TLS_SW,
@@ -93,32 +86,6 @@ enum {
 	TLS_NUM_CONFIG,
 };
 
-/* TLS records are maintained in 'struct tls_rec'. It stores the memory pages
- * allocated or mapped for each TLS record. After encryption, the records are
- * stores in a linked list.
- */
-struct tls_rec {
-	struct list_head list;
-	int tx_ready;
-	int tx_flags;
-
-	struct sk_msg msg_plaintext;
-	struct sk_msg msg_encrypted;
-
-	/* AAD | msg_plaintext.sg.data | sg_tag */
-	struct scatterlist sg_aead_in[2];
-	/* AAD | msg_encrypted.sg.data (data contains overhead for hdr & iv & tag) */
-	struct scatterlist sg_aead_out[2];
-
-	char content_type;
-	struct scatterlist sg_content_type;
-
-	char aad_space[TLS_AAD_SPACE_SIZE];
-	u8 iv_data[MAX_IV_SIZE];
-	struct aead_request aead_req;
-	u8 aead_req_ctx[];
-};
-
 struct tx_work {
 	struct delayed_work work;
 	struct sock *sk;
@@ -349,44 +316,6 @@ struct tls_offload_context_rx {
 #define TLS_OFFLOAD_CONTEXT_SIZE_RX					\
 	(sizeof(struct tls_offload_context_rx) + TLS_DRIVER_STATE_SIZE_RX)
 
-struct tls_context *tls_ctx_create(struct sock *sk);
-void tls_ctx_free(struct sock *sk, struct tls_context *ctx);
-void update_sk_prot(struct sock *sk, struct tls_context *ctx);
-
-int wait_on_pending_writer(struct sock *sk, long *timeo);
-int tls_sk_query(struct sock *sk, int optname, char __user *optval,
-		int __user *optlen);
-int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
-		  unsigned int optlen);
-void tls_err_abort(struct sock *sk, int err);
-
-int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
-void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
-void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
-void tls_sw_strparser_done(struct tls_context *tls_ctx);
-int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
-int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
-			   int offset, size_t size, int flags);
-int tls_sw_sendpage(struct sock *sk, struct page *page,
-		    int offset, size_t size, int flags);
-void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
-void tls_sw_release_resources_tx(struct sock *sk);
-void tls_sw_free_ctx_tx(struct tls_context *tls_ctx);
-void tls_sw_free_resources_rx(struct sock *sk);
-void tls_sw_release_resources_rx(struct sock *sk);
-void tls_sw_free_ctx_rx(struct tls_context *tls_ctx);
-int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		   int flags, int *addr_len);
-bool tls_sw_sock_is_readable(struct sock *sk);
-ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
-			   struct pipe_inode_info *pipe,
-			   size_t len, unsigned int flags);
-
-int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
-int tls_device_sendpage(struct sock *sk, struct page *page,
-			int offset, size_t size, int flags);
-int tls_tx_records(struct sock *sk, int flags);
-
 struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 				       u32 seq, u64 *p_record_sn);
 
@@ -400,58 +329,6 @@ static inline u32 tls_record_start_seq(struct tls_record_info *rec)
 	return rec->end_seq - rec->len;
 }
 
-int tls_push_sg(struct sock *sk, struct tls_context *ctx,
-		struct scatterlist *sg, u16 first_offset,
-		int flags);
-int tls_push_partial_record(struct sock *sk, struct tls_context *ctx,
-			    int flags);
-void tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
-
-static inline struct tls_msg *tls_msg(struct sk_buff *skb)
-{
-	struct sk_skb_cb *scb = (struct sk_skb_cb *)skb->cb;
-
-	return &scb->tls;
-}
-
-static inline bool tls_is_partially_sent_record(struct tls_context *ctx)
-{
-	return !!ctx->partially_sent_record;
-}
-
-static inline bool tls_is_pending_open_record(struct tls_context *tls_ctx)
-{
-	return tls_ctx->pending_open_record_frags;
-}
-
-static inline bool is_tx_ready(struct tls_sw_context_tx *ctx)
-{
-	struct tls_rec *rec;
-
-	rec = list_first_entry(&ctx->tx_list, struct tls_rec, list);
-	if (!rec)
-		return false;
-
-	return READ_ONCE(rec->tx_ready);
-}
-
-static inline u16 tls_user_config(struct tls_context *ctx, bool tx)
-{
-	u16 config = tx ? ctx->tx_conf : ctx->rx_conf;
-
-	switch (config) {
-	case TLS_BASE:
-		return TLS_CONF_BASE;
-	case TLS_SW:
-		return TLS_CONF_SW;
-	case TLS_HW:
-		return TLS_CONF_HW;
-	case TLS_HW_RECORD:
-		return TLS_CONF_HW_RECORD;
-	}
-	return 0;
-}
-
 struct sk_buff *
 tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
 		      struct sk_buff *skb);
@@ -470,31 +347,6 @@ static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 #endif
 }
 
-static inline bool tls_bigint_increment(unsigned char *seq, int len)
-{
-	int i;
-
-	for (i = len - 1; i >= 0; i--) {
-		++seq[i];
-		if (seq[i] != 0)
-			break;
-	}
-
-	return (i == -1);
-}
-
-static inline void tls_bigint_subtract(unsigned char *seq, int  n)
-{
-	u64 rcd_sn;
-	__be64 *p;
-
-	BUILD_BUG_ON(TLS_MAX_REC_SEQ_SIZE != 8);
-
-	p = (__be64 *)seq;
-	rcd_sn = be64_to_cpu(*p);
-	*p = cpu_to_be64(rcd_sn - n);
-}
-
 static inline struct tls_context *tls_get_ctx(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -505,82 +357,6 @@ static inline struct tls_context *tls_get_ctx(const struct sock *sk)
 	return (__force void *)icsk->icsk_ulp_data;
 }
 
-static inline void tls_advance_record_sn(struct sock *sk,
-					 struct tls_prot_info *prot,
-					 struct cipher_context *ctx)
-{
-	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
-		tls_err_abort(sk, -EBADMSG);
-
-	if (prot->version != TLS_1_3_VERSION &&
-	    prot->cipher_type != TLS_CIPHER_CHACHA20_POLY1305)
-		tls_bigint_increment(ctx->iv + prot->salt_size,
-				     prot->iv_size);
-}
-
-static inline void tls_fill_prepend(struct tls_context *ctx,
-			     char *buf,
-			     size_t plaintext_len,
-			     unsigned char record_type)
-{
-	struct tls_prot_info *prot = &ctx->prot_info;
-	size_t pkt_len, iv_size = prot->iv_size;
-
-	pkt_len = plaintext_len + prot->tag_size;
-	if (prot->version != TLS_1_3_VERSION &&
-	    prot->cipher_type != TLS_CIPHER_CHACHA20_POLY1305) {
-		pkt_len += iv_size;
-
-		memcpy(buf + TLS_NONCE_OFFSET,
-		       ctx->tx.iv + prot->salt_size, iv_size);
-	}
-
-	/* we cover nonce explicit here as well, so buf should be of
-	 * size KTLS_DTLS_HEADER_SIZE + KTLS_DTLS_NONCE_EXPLICIT_SIZE
-	 */
-	buf[0] = prot->version == TLS_1_3_VERSION ?
-		   TLS_RECORD_TYPE_DATA : record_type;
-	/* Note that VERSION must be TLS_1_2 for both TLS1.2 and TLS1.3 */
-	buf[1] = TLS_1_2_VERSION_MINOR;
-	buf[2] = TLS_1_2_VERSION_MAJOR;
-	/* we can use IV for nonce explicit according to spec */
-	buf[3] = pkt_len >> 8;
-	buf[4] = pkt_len & 0xFF;
-}
-
-static inline void tls_make_aad(char *buf,
-				size_t size,
-				char *record_sequence,
-				unsigned char record_type,
-				struct tls_prot_info *prot)
-{
-	if (prot->version != TLS_1_3_VERSION) {
-		memcpy(buf, record_sequence, prot->rec_seq_size);
-		buf += 8;
-	} else {
-		size += prot->tag_size;
-	}
-
-	buf[0] = prot->version == TLS_1_3_VERSION ?
-		  TLS_RECORD_TYPE_DATA : record_type;
-	buf[1] = TLS_1_2_VERSION_MAJOR;
-	buf[2] = TLS_1_2_VERSION_MINOR;
-	buf[3] = size >> 8;
-	buf[4] = size & 0xFF;
-}
-
-static inline void xor_iv_with_seq(struct tls_prot_info *prot, char *iv, char *seq)
-{
-	int i;
-
-	if (prot->version == TLS_1_3_VERSION ||
-	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305) {
-		for (i = 0; i < 8; i++)
-			iv[i + 4] ^= seq[i];
-	}
-}
-
-
 static inline struct tls_sw_context_rx *tls_sw_ctx_rx(
 		const struct tls_context *tls_ctx)
 {
@@ -617,9 +393,6 @@ static inline bool tls_sw_has_ctx_rx(const struct sock *sk)
 	return !!tls_sw_ctx_rx(ctx);
 }
 
-void tls_sw_write_space(struct sock *sk, struct tls_context *ctx);
-void tls_device_write_space(struct sock *sk, struct tls_context *ctx);
-
 static inline struct tls_offload_context_rx *
 tls_offload_ctx_rx(const struct tls_context *tls_ctx)
 {
@@ -694,31 +467,11 @@ static inline bool tls_offload_tx_resync_pending(struct sock *sk)
 	return ret;
 }
 
-int __net_init tls_proc_init(struct net *net);
-void __net_exit tls_proc_fini(struct net *net);
-
-int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
-		      unsigned char *record_type);
-int decrypt_skb(struct sock *sk, struct sk_buff *skb,
-		struct scatterlist *sgout);
 struct sk_buff *tls_encrypt_skb(struct sk_buff *skb);
 
-int tls_sw_fallback_init(struct sock *sk,
-			 struct tls_offload_context_tx *offload_ctx,
-			 struct tls_crypto_info *crypto_info);
-
 #ifdef CONFIG_TLS_DEVICE
-void tls_device_init(void);
-void tls_device_cleanup(void);
 void tls_device_sk_destruct(struct sock *sk);
-int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
-void tls_device_free_resources_tx(struct sock *sk);
-int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
-void tls_device_offload_cleanup_rx(struct sock *sk);
-void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
 void tls_offload_tx_resync_request(struct sock *sk, u32 got_seq, u32 exp_seq);
-int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
-			 struct sk_buff *skb, struct strp_msg *rxm);
 
 static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 {
@@ -727,33 +480,5 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 		return false;
 	return tls_get_ctx(sk)->rx_conf == TLS_HW;
 }
-#else
-static inline void tls_device_init(void) {}
-static inline void tls_device_cleanup(void) {}
-
-static inline int
-tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void tls_device_free_resources_tx(struct sock *sk) {}
-
-static inline int
-tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void tls_device_offload_cleanup_rx(struct sock *sk) {}
-static inline void
-tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq) {}
-
-static inline int
-tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
-		     struct sk_buff *skb, struct strp_msg *rxm)
-{
-	return 0;
-}
 #endif
 #endif /* _TLS_OFFLOAD_H */
diff --git a/net/tls/tls.h b/net/tls/tls.h
new file mode 100644
index 000000000000..8005ee25157d
--- /dev/null
+++ b/net/tls/tls.h
@@ -0,0 +1,290 @@
+/*
+ * Copyright (c) 2016-2017, Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016-2017, Dave Watson <davejwatson@fb.com>. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _TLS_INT_H
+#define _TLS_INT_H
+
+#include <asm/byteorder.h>
+#include <linux/types.h>
+#include <linux/skmsg.h>
+#include <net/tls.h>
+
+#define __TLS_INC_STATS(net, field)				\
+	__SNMP_INC_STATS((net)->mib.tls_statistics, field)
+#define TLS_INC_STATS(net, field)				\
+	SNMP_INC_STATS((net)->mib.tls_statistics, field)
+#define TLS_DEC_STATS(net, field)				\
+	SNMP_DEC_STATS((net)->mib.tls_statistics, field)
+
+/* TLS records are maintained in 'struct tls_rec'. It stores the memory pages
+ * allocated or mapped for each TLS record. After encryption, the records are
+ * stores in a linked list.
+ */
+struct tls_rec {
+	struct list_head list;
+	int tx_ready;
+	int tx_flags;
+
+	struct sk_msg msg_plaintext;
+	struct sk_msg msg_encrypted;
+
+	/* AAD | msg_plaintext.sg.data | sg_tag */
+	struct scatterlist sg_aead_in[2];
+	/* AAD | msg_encrypted.sg.data (data contains overhead for hdr & iv & tag) */
+	struct scatterlist sg_aead_out[2];
+
+	char content_type;
+	struct scatterlist sg_content_type;
+
+	char aad_space[TLS_AAD_SPACE_SIZE];
+	u8 iv_data[MAX_IV_SIZE];
+	struct aead_request aead_req;
+	u8 aead_req_ctx[];
+};
+
+int __net_init tls_proc_init(struct net *net);
+void __net_exit tls_proc_fini(struct net *net);
+
+struct tls_context *tls_ctx_create(struct sock *sk);
+void tls_ctx_free(struct sock *sk, struct tls_context *ctx);
+void update_sk_prot(struct sock *sk, struct tls_context *ctx);
+
+int wait_on_pending_writer(struct sock *sk, long *timeo);
+int tls_sk_query(struct sock *sk, int optname, char __user *optval,
+		 int __user *optlen);
+int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
+		  unsigned int optlen);
+void tls_err_abort(struct sock *sk, int err);
+
+int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
+void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
+void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
+void tls_sw_strparser_done(struct tls_context *tls_ctx);
+int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
+			   int offset, size_t size, int flags);
+int tls_sw_sendpage(struct sock *sk, struct page *page,
+		    int offset, size_t size, int flags);
+void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
+void tls_sw_release_resources_tx(struct sock *sk);
+void tls_sw_free_ctx_tx(struct tls_context *tls_ctx);
+void tls_sw_free_resources_rx(struct sock *sk);
+void tls_sw_release_resources_rx(struct sock *sk);
+void tls_sw_free_ctx_rx(struct tls_context *tls_ctx);
+int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+		   int flags, int *addr_len);
+bool tls_sw_sock_is_readable(struct sock *sk);
+ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
+			   struct pipe_inode_info *pipe,
+			   size_t len, unsigned int flags);
+
+int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int tls_device_sendpage(struct sock *sk, struct page *page,
+			int offset, size_t size, int flags);
+int tls_tx_records(struct sock *sk, int flags);
+
+void tls_sw_write_space(struct sock *sk, struct tls_context *ctx);
+void tls_device_write_space(struct sock *sk, struct tls_context *ctx);
+
+int tls_process_cmsg(struct sock *sk, struct msghdr *msg,
+		     unsigned char *record_type);
+int decrypt_skb(struct sock *sk, struct sk_buff *skb,
+		struct scatterlist *sgout);
+
+int tls_sw_fallback_init(struct sock *sk,
+			 struct tls_offload_context_tx *offload_ctx,
+			 struct tls_crypto_info *crypto_info);
+
+static inline struct tls_msg *tls_msg(struct sk_buff *skb)
+{
+	struct sk_skb_cb *scb = (struct sk_skb_cb *)skb->cb;
+
+	return &scb->tls;
+}
+
+#ifdef CONFIG_TLS_DEVICE
+void tls_device_init(void);
+void tls_device_cleanup(void);
+int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
+void tls_device_free_resources_tx(struct sock *sk);
+int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
+void tls_device_offload_cleanup_rx(struct sock *sk);
+void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
+int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
+			 struct sk_buff *skb, struct strp_msg *rxm);
+#else
+static inline void tls_device_init(void) {}
+static inline void tls_device_cleanup(void) {}
+
+static inline int
+tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void tls_device_free_resources_tx(struct sock *sk) {}
+
+static inline int
+tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void tls_device_offload_cleanup_rx(struct sock *sk) {}
+static inline void
+tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq) {}
+
+static inline int
+tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
+		     struct sk_buff *skb, struct strp_msg *rxm)
+{
+	return 0;
+}
+#endif
+
+int tls_push_sg(struct sock *sk, struct tls_context *ctx,
+		struct scatterlist *sg, u16 first_offset,
+		int flags);
+int tls_push_partial_record(struct sock *sk, struct tls_context *ctx,
+			    int flags);
+void tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
+
+static inline bool tls_is_partially_sent_record(struct tls_context *ctx)
+{
+	return !!ctx->partially_sent_record;
+}
+
+static inline bool tls_is_pending_open_record(struct tls_context *tls_ctx)
+{
+	return tls_ctx->pending_open_record_frags;
+}
+
+static inline bool tls_bigint_increment(unsigned char *seq, int len)
+{
+	int i;
+
+	for (i = len - 1; i >= 0; i--) {
+		++seq[i];
+		if (seq[i] != 0)
+			break;
+	}
+
+	return (i == -1);
+}
+
+static inline void tls_bigint_subtract(unsigned char *seq, int  n)
+{
+	u64 rcd_sn;
+	__be64 *p;
+
+	BUILD_BUG_ON(TLS_MAX_REC_SEQ_SIZE != 8);
+
+	p = (__be64 *)seq;
+	rcd_sn = be64_to_cpu(*p);
+	*p = cpu_to_be64(rcd_sn - n);
+}
+
+static inline void
+tls_advance_record_sn(struct sock *sk, struct tls_prot_info *prot,
+		      struct cipher_context *ctx)
+{
+	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
+		tls_err_abort(sk, -EBADMSG);
+
+	if (prot->version != TLS_1_3_VERSION &&
+	    prot->cipher_type != TLS_CIPHER_CHACHA20_POLY1305)
+		tls_bigint_increment(ctx->iv + prot->salt_size,
+				     prot->iv_size);
+}
+
+static inline void
+tls_xor_iv_with_seq(struct tls_prot_info *prot, char *iv, char *seq)
+{
+	int i;
+
+	if (prot->version == TLS_1_3_VERSION ||
+	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305) {
+		for (i = 0; i < 8; i++)
+			iv[i + 4] ^= seq[i];
+	}
+}
+
+static inline void
+tls_fill_prepend(struct tls_context *ctx, char *buf, size_t plaintext_len,
+		 unsigned char record_type)
+{
+	struct tls_prot_info *prot = &ctx->prot_info;
+	size_t pkt_len, iv_size = prot->iv_size;
+
+	pkt_len = plaintext_len + prot->tag_size;
+	if (prot->version != TLS_1_3_VERSION &&
+	    prot->cipher_type != TLS_CIPHER_CHACHA20_POLY1305) {
+		pkt_len += iv_size;
+
+		memcpy(buf + TLS_NONCE_OFFSET,
+		       ctx->tx.iv + prot->salt_size, iv_size);
+	}
+
+	/* we cover nonce explicit here as well, so buf should be of
+	 * size KTLS_DTLS_HEADER_SIZE + KTLS_DTLS_NONCE_EXPLICIT_SIZE
+	 */
+	buf[0] = prot->version == TLS_1_3_VERSION ?
+		   TLS_RECORD_TYPE_DATA : record_type;
+	/* Note that VERSION must be TLS_1_2 for both TLS1.2 and TLS1.3 */
+	buf[1] = TLS_1_2_VERSION_MINOR;
+	buf[2] = TLS_1_2_VERSION_MAJOR;
+	/* we can use IV for nonce explicit according to spec */
+	buf[3] = pkt_len >> 8;
+	buf[4] = pkt_len & 0xFF;
+}
+
+static inline
+void tls_make_aad(char *buf, size_t size, char *record_sequence,
+		  unsigned char record_type, struct tls_prot_info *prot)
+{
+	if (prot->version != TLS_1_3_VERSION) {
+		memcpy(buf, record_sequence, prot->rec_seq_size);
+		buf += 8;
+	} else {
+		size += prot->tag_size;
+	}
+
+	buf[0] = prot->version == TLS_1_3_VERSION ?
+		  TLS_RECORD_TYPE_DATA : record_type;
+	buf[1] = TLS_1_2_VERSION_MAJOR;
+	buf[2] = TLS_1_2_VERSION_MINOR;
+	buf[3] = size >> 8;
+	buf[4] = size & 0xFF;
+}
+
+#endif
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index ec6f4b699a2b..227b92a3064a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -38,6 +38,7 @@
 #include <net/tcp.h>
 #include <net/tls.h>
 
+#include "tls.h"
 #include "trace.h"
 
 /* device_offload_lock is used to synchronize tls_dev_add
@@ -562,7 +563,7 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
-		rc = tls_proccess_cmsg(sk, msg, &record_type);
+		rc = tls_process_cmsg(sk, msg, &record_type);
 		if (rc)
 			goto out;
 	}
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 3bae29ae57ca..618cee704217 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -34,6 +34,8 @@
 #include <crypto/scatterwalk.h>
 #include <net/ip6_checksum.h>
 
+#include "tls.h"
+
 static void chain_to_walk(struct scatterlist *sg, struct scatter_walk *walk)
 {
 	struct scatterlist *src = walk->sg;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 1b3efc96db0b..f3d9dbfa507e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -45,6 +45,8 @@
 #include <net/tls.h>
 #include <net/tls_toe.h>
 
+#include "tls.h"
+
 MODULE_AUTHOR("Mellanox Technologies");
 MODULE_DESCRIPTION("Transport Layer Security Support");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -164,8 +166,8 @@ static int tls_handle_open_record(struct sock *sk, int flags)
 	return 0;
 }
 
-int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
-		      unsigned char *record_type)
+int tls_process_cmsg(struct sock *sk, struct msghdr *msg,
+		     unsigned char *record_type)
 {
 	struct cmsghdr *cmsg;
 	int rc = -EINVAL;
@@ -1003,6 +1005,23 @@ static void tls_update(struct sock *sk, struct proto *p,
 	}
 }
 
+static u16 tls_user_config(struct tls_context *ctx, bool tx)
+{
+	u16 config = tx ? ctx->tx_conf : ctx->rx_conf;
+
+	switch (config) {
+	case TLS_BASE:
+		return TLS_CONF_BASE;
+	case TLS_SW:
+		return TLS_CONF_SW;
+	case TLS_HW:
+		return TLS_CONF_HW;
+	case TLS_HW_RECORD:
+		return TLS_CONF_HW_RECORD;
+	}
+	return 0;
+}
+
 static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
 {
 	u16 version, cipher_type;
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 0c200000cc45..1246e52b48f6 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -6,6 +6,8 @@
 #include <net/snmp.h>
 #include <net/tls.h>
 
+#include "tls.h"
+
 #ifdef CONFIG_PROC_FS
 static const struct snmp_mib tls_mib_list[] = {
 	SNMP_MIB_ITEM("TlsCurrTxSw", LINUX_MIB_TLSCURRTXSW),
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2afcf99105fb..337adab85037 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -44,6 +44,8 @@
 #include <net/strparser.h>
 #include <net/tls.h>
 
+#include "tls.h"
+
 struct tls_decrypt_arg {
 	bool zc;
 	bool async;
@@ -527,7 +529,8 @@ static int tls_do_encryption(struct sock *sk,
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
 	       prot->iv_size + prot->salt_size);
 
-	xor_iv_with_seq(prot, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
+	tls_xor_iv_with_seq(prot, rec->iv_data + iv_offset,
+			    tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -964,7 +967,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
-		ret = tls_proccess_cmsg(sk, msg, &record_type);
+		ret = tls_process_cmsg(sk, msg, &record_type);
 		if (ret) {
 			if (ret == -EINPROGRESS)
 				num_async++;
@@ -1498,7 +1501,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			goto exit_free;
 		memcpy(&dctx->iv[iv_offset], tls_ctx->rx.iv, prot->salt_size);
 	}
-	xor_iv_with_seq(prot, &dctx->iv[iv_offset], tls_ctx->rx.rec_seq);
+	tls_xor_iv_with_seq(prot, &dctx->iv[iv_offset], tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(dctx->aad, rxm->full_len - prot->overhead_size +
@@ -2267,12 +2270,23 @@ static void tx_work_handler(struct work_struct *work)
 	mutex_unlock(&tls_ctx->tx_lock);
 }
 
+static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
+{
+	struct tls_rec *rec;
+
+	rec = list_first_entry(&ctx->tx_list, struct tls_rec, list);
+	if (!rec)
+		return false;
+
+	return READ_ONCE(rec->tx_ready);
+}
+
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
 {
 	struct tls_sw_context_tx *tx_ctx = tls_sw_ctx_tx(ctx);
 
 	/* Schedule the transmission if tx list is ready */
-	if (is_tx_ready(tx_ctx) &&
+	if (tls_is_tx_ready(tx_ctx) &&
 	    !test_and_set_bit(BIT_TX_SCHEDULED, &tx_ctx->tx_bitmask))
 		schedule_delayed_work(&tx_ctx->tx_work.work, 0);
 }
diff --git a/net/tls/tls_toe.c b/net/tls/tls_toe.c
index 7e1330f19165..825669e1ab47 100644
--- a/net/tls/tls_toe.c
+++ b/net/tls/tls_toe.c
@@ -38,6 +38,8 @@
 #include <net/tls.h>
 #include <net/tls_toe.h>
 
+#include "tls.h"
+
 static LIST_HEAD(device_list);
 static DEFINE_SPINLOCK(device_spinlock);
 
-- 
2.36.1

