Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D3E4C48E9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242101AbiBYPar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiBYPaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:30:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FD12177D1
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F557B8324A
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 15:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3A2C340E7;
        Fri, 25 Feb 2022 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645803011;
        bh=fgGMaAAx7vCosr8kSQ/0bDtX27isSKn0YtGqCNAyquw=;
        h=From:To:Cc:Subject:Date:From;
        b=DALEe8V8lu37KzDqijJHQ75t2+ig1Lr9TyPZTSb9dMjdoki1UuqTkhfpYspvLk9Kv
         vcDhuBDjruIFzHCqz2egxT6DlIoGOH62ZD2biRaDXKtMHKPhiojWZn/l0SSGMOgf9y
         5zXdOzfio7MrMeOk4wOe3E826SwJ0eiu3rtl3jXNzJDq3Zs8pri/BVMeHd0Q4bJwN8
         TkSevxxcQq9NB6ajqzGO0uTgV89Dc52aDkY+fRE9WmnN0xxy6bCLJ0YOwK9dZGzyRH
         j+DF6hO3rRRdLb2u1gya5zaeaULNC2o6fv8soHlOrDN3McSd/GBORpD/e2UHb2ufbU
         UOlX62lTwsm6Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: netsec: enable pp skb recycling
Date:   Fri, 25 Feb 2022 16:29:51 +0100
Message-Id: <89abfd9e920d9ee4bc396a6bf94ad4c61d4ef3af.1645802768.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Similar to mvneta or mvpp2, enable page_pool skb recycling for netsec
dirver.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 556bd353dd42..b0c5a44785fa 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1044,7 +1044,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 				  "rx failed to build skb\n");
 			break;
 		}
-		page_pool_release_page(dring->page_pool, page);
+		skb_mark_for_recycle(skb);
 
 		skb_reserve(skb, xdp.data - xdp.data_hard_start);
 		skb_put(skb, xdp.data_end - xdp.data);
-- 
2.35.1

