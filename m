Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9684F9CC8
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiDHSeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238753AbiDHSds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FDAED92B
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 536C3B82CF7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2504C385AA;
        Fri,  8 Apr 2022 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442701;
        bh=Q5b0dlXtEp0OfTcSvSdS/6l9/xq8LyxGqNsIUhjuyWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0FJTNK35GQ4Sefa1uNIok+2Lq8sfw0uKm8K2dl2izU9a9E0gWoXYlVpWmYwB5Hxd
         NfRto0xJvci5haYIXNixXSZ7qalR9M7kMrhjU992qdNfDanFPTIzTa44aFq9OSGFr5
         9ve+E6ld7W0LTQ0pizukH8fdP5JdjRYAt26Ri5uaHbj5Vjjer5/+vuVYszrDgrG+f5
         IA4CmY2HsSSL6wyQvRx5jzt5AUx2Nj0z3J3vf+sBwvljqvgqremqGJydU7uhnhy7+r
         W0iZ/JjJ/rzCIcvl+FvRBNxfwFA9qSbQqCkPcOjmrSQTMpqhNdJ7dUwtCXhjIgL6+a
         x+69Hh4+M19vg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/11] tls: rx: factor out writing ContentType to cmsg
Date:   Fri,  8 Apr 2022 11:31:28 -0700
Message-Id: <20220408183134.1054551-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408183134.1054551-1-kuba@kernel.org>
References: <20220408183134.1054551-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cmsg can be filled in during rx_list processing or normal
receive. Consolidate the code.

We don't need to keep the boolean to track if the cmsg was
created. 0 is an invalid content type.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 91 +++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 55 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 003f7c178cde..103a1aaca934 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1635,6 +1635,29 @@ static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
 	return true;
 }
 
+static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
+				   u8 *control)
+{
+	int err;
+
+	if (!*control) {
+		*control = tlm->control;
+		if (!*control)
+			return -EBADMSG;
+
+		err = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
+			       sizeof(*control), control);
+		if (*control != TLS_RECORD_TYPE_DATA) {
+			if (err || msg->msg_flags & MSG_CTRUNC)
+				return -EIO;
+		}
+	} else if (*control != tlm->control) {
+		return 0;
+	}
+
+	return 1;
+}
+
 /* This function traverses the rx_list in tls receive context to copies the
  * decrypted records into the buffer provided by caller zero copy is not
  * true. Further, the records are removed from the rx_list if it is not a peek
@@ -1643,31 +1666,23 @@ static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
 static int process_rx_list(struct tls_sw_context_rx *ctx,
 			   struct msghdr *msg,
 			   u8 *control,
-			   bool *cmsg,
 			   size_t skip,
 			   size_t len,
 			   bool zc,
 			   bool is_peek)
 {
 	struct sk_buff *skb = skb_peek(&ctx->rx_list);
-	u8 ctrl = *control;
-	u8 msgc = *cmsg;
 	struct tls_msg *tlm;
 	ssize_t copied = 0;
-
-	/* Set the record type in 'control' if caller didn't pass it */
-	if (!ctrl && skb) {
-		tlm = tls_msg(skb);
-		ctrl = tlm->control;
-	}
+	int err;
 
 	while (skip && skb) {
 		struct strp_msg *rxm = strp_msg(skb);
 		tlm = tls_msg(skb);
 
-		/* Cannot process a record of different type */
-		if (ctrl != tlm->control)
-			return 0;
+		err = tls_record_content_type(msg, tlm, control);
+		if (err <= 0)
+			return err;
 
 		if (skip < rxm->full_len)
 			break;
@@ -1683,27 +1698,12 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		tlm = tls_msg(skb);
 
-		/* Cannot process a record of different type */
-		if (ctrl != tlm->control)
-			return 0;
-
-		/* Set record type if not already done. For a non-data record,
-		 * do not proceed if record type could not be copied.
-		 */
-		if (!msgc) {
-			int cerr = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
-					    sizeof(ctrl), &ctrl);
-			msgc = true;
-			if (ctrl != TLS_RECORD_TYPE_DATA) {
-				if (cerr || msg->msg_flags & MSG_CTRUNC)
-					return -EIO;
-
-				*cmsg = msgc;
-			}
-		}
+		err = tls_record_content_type(msg, tlm, control);
+		if (err <= 0)
+			return err;
 
 		if (!zc || (rxm->full_len - skip) > len) {
-			int err = skb_copy_datagram_msg(skb, rxm->offset + skip,
+			err = skb_copy_datagram_msg(skb, rxm->offset + skip,
 						    msg, chunk);
 			if (err < 0)
 				return err;
@@ -1740,7 +1740,6 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 		skb = next_skb;
 	}
 
-	*control = ctrl;
 	return copied;
 }
 
@@ -1762,7 +1761,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
-	bool cmsg = false;
 	int target, err = 0;
 	long timeo;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
@@ -1779,8 +1777,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
 	/* Process pending decrypted records. It must be non-zero-copy */
-	err = process_rx_list(ctx, msg, &control, &cmsg, 0, len, false,
-			      is_peek);
+	err = process_rx_list(ctx, msg, &control, 0, len, false, is_peek);
 	if (err < 0) {
 		tls_err_abort(sk, err);
 		goto end;
@@ -1852,26 +1849,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		 * is known just after record is dequeued from stream parser.
 		 * For tls1.3, we disable async.
 		 */
-
-		if (!control)
-			control = tlm->control;
-		else if (control != tlm->control)
+		err = tls_record_content_type(msg, tlm, &control);
+		if (err <= 0)
 			goto recv_end;
 
-		if (!cmsg) {
-			int cerr;
-
-			cerr = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
-					sizeof(control), &control);
-			cmsg = true;
-			if (control != TLS_RECORD_TYPE_DATA) {
-				if (cerr || msg->msg_flags & MSG_CTRUNC) {
-					err = -EIO;
-					goto recv_end;
-				}
-			}
-		}
-
 		if (async) {
 			/* TLS 1.2-only, to_decrypt must be text length */
 			chunk = min_t(int, to_decrypt, len);
@@ -1953,10 +1934,10 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		/* Drain records from the rx_list & copy if required */
 		if (is_peek || is_kvec)
-			err = process_rx_list(ctx, msg, &control, &cmsg, copied,
+			err = process_rx_list(ctx, msg, &control, copied,
 					      decrypted, false, is_peek);
 		else
-			err = process_rx_list(ctx, msg, &control, &cmsg, 0,
+			err = process_rx_list(ctx, msg, &control, 0,
 					      decrypted, true, is_peek);
 		if (err < 0) {
 			tls_err_abort(sk, err);
-- 
2.34.1

