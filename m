Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C3D4F9CCA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbiDHSeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiDHSeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90526EE4C5
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED7162248
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413E3C385AB;
        Fri,  8 Apr 2022 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442703;
        bh=Mmze7BMRZqKh1t59D/4Kqh/U2BCdjga2yQDGpFqzRDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vpe7WbCeLPrE3PQ0INrMkf+3hXC28RPOhRARnCam3sONG321/uQ7mbPXtu6u32ii3
         1p+m322efgQlvR2ch8jjaD29AK2PsfaDM0jN9LpCVpv4Ow9eG6gxLp/bgCGAvwSc7s
         DzFC/3KulJFjFxavVAenG6k1FGVQwfpsZjainTd/vxGuGa2xFXFr9vJ4HJcgq6fedn
         +/L+6jfahbYhPMN3pJaE6G71INzfTeP6aRsrUtfCeIR0rie5uY/EJTHfEID4C9btos
         ImKywW7cFtgO54evOIqQuFBh/nqAl/mtP+8QlcG8QVIBDTjqvs9ZaxEuTfSbhhlrck
         SPklg24xMeFdg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/11] tls: rx: clear ctx->recv_pkt earlier
Date:   Fri,  8 Apr 2022 11:31:33 -0700
Message-Id: <20220408183134.1054551-11-kuba@kernel.org>
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

Whatever we do in the loop the skb should not remain on as
ctx->recv_pkt afterwards. We can clear that pointer and
restart strparser earlier.

This adds overhead of extra linking and unlinking to rx_list
but that's not large (upcoming change will switch to unlocked
skb list operations).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 3aa8fe1c6e77..71d8082647c8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1826,6 +1826,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		if (err <= 0)
 			goto recv_end;
 
+		ctx->recv_pkt = NULL;
+		__strp_unpause(&ctx->strp);
+		skb_queue_tail(&ctx->rx_list, skb);
+
 		if (async) {
 			/* TLS 1.2-only, to_decrypt must be text length */
 			chunk = min_t(int, to_decrypt, len);
@@ -1840,10 +1844,9 @@ int tls_sw_recvmsg(struct sock *sk,
 				if (err != __SK_PASS) {
 					rxm->offset = rxm->offset + rxm->full_len;
 					rxm->full_len = 0;
+					skb_unlink(skb, &ctx->rx_list);
 					if (err == __SK_DROP)
 						consume_skb(skb);
-					ctx->recv_pkt = NULL;
-					__strp_unpause(&ctx->strp);
 					continue;
 				}
 			}
@@ -1869,14 +1872,9 @@ int tls_sw_recvmsg(struct sock *sk,
 		len -= chunk;
 
 		/* For async or peek case, queue the current skb */
-		if (async || is_peek || retain_skb) {
-			skb_queue_tail(&ctx->rx_list, skb);
-			ctx->recv_pkt = NULL;
-			__strp_unpause(&ctx->strp);
-		} else {
+		if (!(async || is_peek || retain_skb)) {
+			skb_unlink(skb, &ctx->rx_list);
 			consume_skb(skb);
-			ctx->recv_pkt = NULL;
-			__strp_unpause(&ctx->strp);
 
 			/* Return full control message to
 			 * userspace before trying to parse
-- 
2.34.1

