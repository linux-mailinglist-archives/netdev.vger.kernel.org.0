Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CE06C7F7A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjCXOF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjCXOFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:05:11 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCD1555A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 07:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ztXlxHs4JrMfjTjOUaJAK0fkNDCSnxZYyZoHRuBalrw=; b=PWQAFqoLvvL8xKpm99dvmIADh4
        VjVvMQPdBR1R+NX0bK/bZILl1+N3tiGZJQ2OYUEicwmBfctUcCQSYz/8vr4mt/LvHZTib7GBAr94v
        aLzqCS22lzF5g3Y9IQi6Y1GnVsaJIgppFQ08r2T62YmF2xukSB1r92cCP6dlrcJWlvbg=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pfi1V-006ORu-Bf; Fri, 24 Mar 2023 15:04:05 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput regression with direct 1G links
Date:   Fri, 24 Mar 2023 15:04:04 +0100
Message-Id: <20230324140404.95745-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the QDMA tx scheduler to throttle tx to line speed works fine for
switch ports, but apparently caused a regression on non-switch ports.

Based on a number of tests, it seems that this throttling can be safely
dropped without re-introducing the issues on switch ports that the
tx scheduling changes resolved.

Link: https://lore.kernel.org/netdev/trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Reported-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a94aa08515af..282f9435d5ff 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -763,8 +763,6 @@ static void mtk_mac_link_up(struct phylink_config *config,
 		break;
 	}
 
-	mtk_set_queue_speed(mac->hw, mac->id, speed);
-
 	/* Configure duplex */
 	if (duplex == DUPLEX_FULL)
 		mcr |= MAC_MCR_FORCE_DPX;
-- 
2.39.0

