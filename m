Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF46575AE7
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiGOFXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiGOFW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AF2796AA
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32DBF62258
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AD1C341CA;
        Fri, 15 Jul 2022 05:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862569;
        bh=Fa5xyfp0+fe3hdZxlix6dk4oHTod9QibTKYIf5NDHTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8olphmn+8fjFWG+CC7pGZzTCRFxs9fXZqYmoJ5BwdRBloN0hP5quVItG6HhxeyNq
         ZlAWgbcfutxy1NPVHq2AauGCq9hkjYFMGGsDQPJQc0dDY35qVVEVKMWjtMmtEmEdmY
         Nb8jwQODRc/4k1H+gn8AftlzIhwTyNjH+K2t3/SpjzPRtduMRP37E5L2g0wXWaMW3F
         y7wykCCwhi8gjnrF03ALNMt63KfSpSFt8on7fCZ0p6A5or8lrwF3yEnLWJY+WhzHZP
         FonN2zbBiOwBEG5EE1PFPLcJgJhJm9I1RDDVn9Xw2EGHfP1PAeW9KNXmDsqdnvQHcW
         xq1DnpjSMoaAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 11/11] tls: rx: decrypt into a fresh skb
Date:   Thu, 14 Jul 2022 22:22:35 -0700
Message-Id: <20220715052235.1452170-12-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715052235.1452170-1-kuba@kernel.org>
References: <20220715052235.1452170-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently CoW Rx skbs whenever we can't decrypt to a user
space buffer. The skbs can be enormous (64kB) and CoW does
a linear alloc which has a strong chance of failing under
memory pressure. Or even without, skb_cow_data() assumes
GFP_ATOMIC.

Allocate a new frag'd skb and decrypt into it. We finally
take advantage of the decrypted skb getting returned via
darg.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls.h    |   3 ++
 net/tls/tls_sw.c | 106 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 72 insertions(+), 37 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index c818dc68955d..3740740504e3 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -39,6 +39,9 @@
 #include <linux/skmsg.h>
 #include <net/tls.h>
 
+#define TLS_PAGE_ORDER	(min_t(unsigned int, PAGE_ALLOC_COSTLY_ORDER,	\
+			       TLS_MAX_PAYLOAD_SIZE >> PAGE_SHIFT))
+
 #define __TLS_INC_STATS(net, field)				\
 	__SNMP_INC_STATS((net)->mib.tls_statistics, field)
 #define TLS_INC_STATS(net, field)				\
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1c9a0705ee63..859ea02022c0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1383,6 +1383,29 @@ static int tls_setup_from_iter(struct iov_iter *from,
 	return rc;
 }
 
+static struct sk_buff *
+tls_alloc_clrtxt_skb(struct sock *sk, struct sk_buff *skb,
+		     unsigned int full_len)
+{
+	struct strp_msg *clr_rxm;
+	struct sk_buff *clr_skb;
+	int err;
+
+	clr_skb = alloc_skb_with_frags(0, full_len, TLS_PAGE_ORDER,
+				       &err, sk->sk_allocation);
+	if (!clr_skb)
+		return NULL;
+
+	skb_copy_header(clr_skb, skb);
+	clr_skb->len = full_len;
+	clr_skb->data_len = full_len;
+
+	clr_rxm = strp_msg(clr_skb);
+	clr_rxm->offset = 0;
+
+	return clr_skb;
+}
+
 /* Decrypt handlers
  *
  * tls_decrypt_sg() and tls_decrypt_device() are decrypt handlers.
@@ -1410,34 +1433,40 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	int n_sgin, n_sgout, aead_size, err, pages = 0;
 	struct sk_buff *skb = tls_strp_msg(ctx);
-	struct strp_msg *rxm = strp_msg(skb);
-	struct tls_msg *tlm = tls_msg(skb);
+	const struct strp_msg *rxm = strp_msg(skb);
+	const struct tls_msg *tlm = tls_msg(skb);
 	struct aead_request *aead_req;
-	struct sk_buff *unused;
 	struct scatterlist *sgin = NULL;
 	struct scatterlist *sgout = NULL;
 	const int data_len = rxm->full_len - prot->overhead_size;
 	int tail_pages = !!prot->tail_size;
 	struct tls_decrypt_ctx *dctx;
+	struct sk_buff *clear_skb;
 	int iv_offset = 0;
 	u8 *mem;
 
+	n_sgin = skb_nsg(skb, rxm->offset + prot->prepend_size,
+			 rxm->full_len - prot->prepend_size);
+	if (n_sgin < 1)
+		return n_sgin ?: -EBADMSG;
+
 	if (darg->zc && (out_iov || out_sg)) {
+		clear_skb = NULL;
+
 		if (out_iov)
 			n_sgout = 1 + tail_pages +
 				iov_iter_npages_cap(out_iov, INT_MAX, data_len);
 		else
 			n_sgout = sg_nents(out_sg);
-		n_sgin = skb_nsg(skb, rxm->offset + prot->prepend_size,
-				 rxm->full_len - prot->prepend_size);
 	} else {
-		n_sgout = 0;
 		darg->zc = false;
-		n_sgin = skb_cow_data(skb, 0, &unused);
-	}
 
-	if (n_sgin < 1)
-		return -EBADMSG;
+		clear_skb = tls_alloc_clrtxt_skb(sk, skb, rxm->full_len);
+		if (!clear_skb)
+			return -ENOMEM;
+
+		n_sgout = 1 + skb_shinfo(clear_skb)->nr_frags;
+	}
 
 	/* Increment to accommodate AAD */
 	n_sgin = n_sgin + 1;
@@ -1449,8 +1478,10 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
 	mem = kmalloc(aead_size + struct_size(dctx, sg, n_sgin + n_sgout),
 		      sk->sk_allocation);
-	if (!mem)
-		return -ENOMEM;
+	if (!mem) {
+		err = -ENOMEM;
+		goto exit_free_skb;
+	}
 
 	/* Segment the allocated memory */
 	aead_req = (struct aead_request *)mem;
@@ -1499,33 +1530,31 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	if (err < 0)
 		goto exit_free;
 
-	if (n_sgout) {
-		if (out_iov) {
-			sg_init_table(sgout, n_sgout);
-			sg_set_buf(&sgout[0], dctx->aad, prot->aad_size);
+	if (clear_skb) {
+		sg_init_table(sgout, n_sgout);
+		sg_set_buf(&sgout[0], dctx->aad, prot->aad_size);
 
-			err = tls_setup_from_iter(out_iov, data_len,
-						  &pages, &sgout[1],
-						  (n_sgout - 1 - tail_pages));
-			if (err < 0)
-				goto fallback_to_reg_recv;
+		err = skb_to_sgvec(clear_skb, &sgout[1], prot->prepend_size,
+				   data_len + prot->tail_size);
+		if (err < 0)
+			goto exit_free;
+	} else if (out_iov) {
+		sg_init_table(sgout, n_sgout);
+		sg_set_buf(&sgout[0], dctx->aad, prot->aad_size);
 
-			if (prot->tail_size) {
-				sg_unmark_end(&sgout[pages]);
-				sg_set_buf(&sgout[pages + 1], &dctx->tail,
-					   prot->tail_size);
-				sg_mark_end(&sgout[pages + 1]);
-			}
-		} else if (out_sg) {
-			memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
-		} else {
-			goto fallback_to_reg_recv;
+		err = tls_setup_from_iter(out_iov, data_len, &pages, &sgout[1],
+					  (n_sgout - 1 - tail_pages));
+		if (err < 0)
+			goto exit_free_pages;
+
+		if (prot->tail_size) {
+			sg_unmark_end(&sgout[pages]);
+			sg_set_buf(&sgout[pages + 1], &dctx->tail,
+				   prot->tail_size);
+			sg_mark_end(&sgout[pages + 1]);
 		}
-	} else {
-fallback_to_reg_recv:
-		sgout = sgin;
-		pages = 0;
-		darg->zc = false;
+	} else if (out_sg) {
+		memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 	}
 
 	/* Prepare and submit AEAD request */
@@ -1534,7 +1563,8 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	if (err)
 		goto exit_free_pages;
 
-	darg->skb = tls_strp_msg(ctx);
+	darg->skb = clear_skb ?: tls_strp_msg(ctx);
+	clear_skb = NULL;
 
 	if (unlikely(darg->async)) {
 		err = tls_strp_msg_hold(sk, skb, &ctx->async_hold);
@@ -1552,6 +1582,8 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 		put_page(sg_page(&sgout[pages]));
 exit_free:
 	kfree(mem);
+exit_free_skb:
+	consume_skb(clear_skb);
 	return err;
 }
 
-- 
2.36.1

