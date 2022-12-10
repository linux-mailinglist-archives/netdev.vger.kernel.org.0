Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C265F648EF8
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiLJNxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiLJNxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:53:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DEE1706D
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 05:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB24C60C01
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 13:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7FAC433EF;
        Sat, 10 Dec 2022 13:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670680426;
        bh=W9cc5B3lyI30sbvRELtApFZRccn3R4UlyQ2m+7kWX60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxifPqGII28Yq8NpCXfjs60G5H6JoB8AJPEmEjiitbLF3fBhYZPCeXGeuw++jaE8e
         JXTS/2HMAUM+eRqk2b2RRoa/KLzc9u5QdmWPio5jtUC6kvCEYi5+Z58PTo2ukrYdzO
         PWZP8AWGiSe5gm0LDo72Wux5fA7O+X8vNcrT8Y4tdoR9IHjPKS0mGlN1GXKeSSNquM
         fU8sYTOkmGu/YNNg50YWA+bAOjC/OjMp8NYcwODGPKAEWwVScWaJypdSsDkQbK5bs6
         7kGwIxK02XV3zk9ixmF212xhhhRohEaq1Ipl4ONStmmR+2ZDPNQ6jwC6uzvsS6KBtZ
         gywv2nD1NmXFw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 2/2] net: ethernet: enetc: get rid of xdp_redirect_sg counter
Date:   Sat, 10 Dec 2022 14:53:11 +0100
Message-Id: <813922f4a7e343197b4e4018fb7c5992bd45ea30.1670680119.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670680119.git.lorenzo@kernel.org>
References: <cover.1670680119.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove xdp_redirect_sg counter and the related ethtool entry since it is
no longer used.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.h         | 1 -
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index c6d8cc15c270..416e4138dbaf 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -70,7 +70,6 @@ struct enetc_ring_stats {
 	unsigned int xdp_tx_drops;
 	unsigned int xdp_redirect;
 	unsigned int xdp_redirect_failures;
-	unsigned int xdp_redirect_sg;
 	unsigned int recycles;
 	unsigned int recycle_failures;
 	unsigned int win_drop;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index c8369e3752b0..d45f305eb03c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -197,7 +197,6 @@ static const char rx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Rx ring %2d recycle failures",
 	"Rx ring %2d redirects",
 	"Rx ring %2d redirect failures",
-	"Rx ring %2d redirect S/G",
 };
 
 static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
@@ -291,7 +290,6 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 		data[o++] = priv->rx_ring[i]->stats.recycle_failures;
 		data[o++] = priv->rx_ring[i]->stats.xdp_redirect;
 		data[o++] = priv->rx_ring[i]->stats.xdp_redirect_failures;
-		data[o++] = priv->rx_ring[i]->stats.xdp_redirect_sg;
 	}
 
 	if (!enetc_si_is_pf(priv->si))
-- 
2.38.1

