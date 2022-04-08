Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7C4F8ED1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiDHDku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiDHDkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9A7FE400
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5902ACE29DF
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BB6C385A9;
        Fri,  8 Apr 2022 03:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389110;
        bh=/ruvqMrsmZc/18stVDHIfCWFNksjt2oi7U1njPZZy6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaILQElNpKHozuc1vLWpP7uq1Moy+pwmNUGJKpb+4kcLJ9WLzF8h397tUpx5Xiky8
         OlPFvomsDDhrKPezb92KuV1gtc8/d5OYsaJJpHeKC/SGRvuuvctCGbrBW4ilxE3XVP
         UzBCheaP0vx0ZW7QI/k+zZFdDlkjcTyTFJoH0REpsmo5PPJLGT11DK5iY/hiI/wFVa
         GMxT9lvphxrMG4X3BJFrNyypcGpbGQneWUn4zz2dTBF9ipp0sU5y05aQZxT3j69M36
         s8cIAmAbeHuUMsv0MwOIXqPf4F2tCV/aECdhNsShr9Jbv6uNBzRxqJAYMNE490emUy
         sDHNn4Yg12uxg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/10] tls: hw: rx: use return value of tls_device_decrypted() to carry status
Date:   Thu,  7 Apr 2022 20:38:23 -0700
Message-Id: <20220408033823.965896-11-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408033823.965896-1-kuba@kernel.org>
References: <20220408033823.965896-1-kuba@kernel.org>
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

Instead of tls_device poking into internals of the message
return 1 from tls_device_decrypted() if the device handled
the decryption.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_device.c | 7 ++-----
 net/tls/tls_sw.c     | 5 ++---
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 78d979e0f298..5e4bd8ba48d3 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -948,7 +948,6 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 			 struct sk_buff *skb, struct strp_msg *rxm)
 {
 	struct tls_offload_context_rx *ctx = tls_offload_ctx_rx(tls_ctx);
-	struct tls_msg *tlm = tls_msg(skb);
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
@@ -963,11 +962,9 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 				   tls_ctx->rx.rec_seq, rxm->full_len,
 				   is_encrypted, is_decrypted);
 
-	tlm->decrypted |= is_decrypted;
-
 	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
 		if (likely(is_encrypted || is_decrypted))
-			return 0;
+			return is_decrypted;
 
 		/* After tls_device_down disables the offload, the next SKB will
 		 * likely have initial fragments decrypted, and final ones not
@@ -982,7 +979,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 	 */
 	if (is_decrypted) {
 		ctx->resync_nh_reset = 1;
-		return 0;
+		return is_decrypted;
 	}
 	if (is_encrypted) {
 		tls_device_core_ctrl_rx_resync(tls_ctx, ctx, sk, skb);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d6ac9deede7b..990450ff9537 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1575,9 +1575,8 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
 		if (err < 0)
 			return err;
-
-		/* skip SW decryption if NIC handled it already */
-		if (tlm->decrypted) {
+		if (err > 0) {
+			tlm->decrypted = 1;
 			*zc = false;
 			goto decrypt_done;
 		}
-- 
2.34.1

