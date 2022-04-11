Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412994FC4EF
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344348AbiDKTVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbiDKTVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8496103F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 528D0B8187E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA325C385A9;
        Mon, 11 Apr 2022 19:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704762;
        bh=zoLTMHqh5Vci5uTVwE6hQBdGIpgmmvsjSyDdJqLRT+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5P+RuEg+H6mwSfpMNj0GR99K0EtMgok7JH+Co2tpHxNbywGzTFv4qJzDFvHLZrnW
         kStJrfAiHOll8hvip1WcREGrNqdVrp8iiiaw37DeQUyxYGjcWpQ2Lv4cHtq+2QYCyr
         wcBYWgnQ2xTdquVFOzHwXw4G8FEUmN/64F4Xtqs9vLEPuFlgYoE8AKlVJRK0E+eF0c
         X6TdgTF2mCiE8gO86XQAnaM/9uAiwNvCfLt4EYkumiXH8f1s959s6KC9gbh6oWnp8K
         7m7tguAEfMuxdb68LwcfdAAOeIPdWexmWcfypZuSWvMTT1rC7UDLhSPCrEa21eDTIf
         PqOxgOEiAiKug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/10] tls: rx: consistently use unlocked accessors for rx_list
Date:   Mon, 11 Apr 2022 12:19:08 -0700
Message-Id: <20220411191917.1240155-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220411191917.1240155-1-kuba@kernel.org>
References: <20220411191917.1240155-1-kuba@kernel.org>
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

rx_list is protected by the socket lock, no need to take
the built-in spin lock on accesses.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2e8a896af81a..e176549216ac 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1709,7 +1709,7 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 		next_skb = skb_peek_next(skb, &ctx->rx_list);
 
 		if (!is_peek) {
-			skb_unlink(skb, &ctx->rx_list);
+			__skb_unlink(skb, &ctx->rx_list);
 			consume_skb(skb);
 		}
 
@@ -1827,7 +1827,7 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		ctx->recv_pkt = NULL;
 		__strp_unpause(&ctx->strp);
-		skb_queue_tail(&ctx->rx_list, skb);
+		__skb_queue_tail(&ctx->rx_list, skb);
 
 		if (async) {
 			/* TLS 1.2-only, to_decrypt must be text length */
@@ -1848,7 +1848,7 @@ int tls_sw_recvmsg(struct sock *sk,
 				if (err != __SK_PASS) {
 					rxm->offset = rxm->offset + rxm->full_len;
 					rxm->full_len = 0;
-					skb_unlink(skb, &ctx->rx_list);
+					__skb_unlink(skb, &ctx->rx_list);
 					if (err == __SK_DROP)
 						consume_skb(skb);
 					continue;
@@ -1876,7 +1876,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		decrypted += chunk;
 		len -= chunk;
 
-		skb_unlink(skb, &ctx->rx_list);
+		__skb_unlink(skb, &ctx->rx_list);
 		consume_skb(skb);
 
 		/* Return full control message to userspace before trying
@@ -2176,7 +2176,7 @@ void tls_sw_release_resources_rx(struct sock *sk)
 	if (ctx->aead_recv) {
 		kfree_skb(ctx->recv_pkt);
 		ctx->recv_pkt = NULL;
-		skb_queue_purge(&ctx->rx_list);
+		__skb_queue_purge(&ctx->rx_list);
 		crypto_free_aead(ctx->aead_recv);
 		strp_stop(&ctx->strp);
 		/* If tls_sw_strparser_arm() was not called (cleanup paths)
-- 
2.34.1

