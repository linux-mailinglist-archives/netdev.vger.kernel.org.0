Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2784565D4CC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbjADN5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239375AbjADN5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:57:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B72BE0
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 05:57:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3430BB81642
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0345C4339B;
        Wed,  4 Jan 2023 13:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672840652;
        bh=5oZyVv3sIxKejDrYUiT1Nu/dIoe8s5jODZGWH1lQAR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbcoZJrCFcCSAcQmVkwC04jNpXjTAOddVZeilHw9lsMgSY4Mu1kdNBHkT8aJGJ+L3
         Up+y1c5sPmr7+sDKHB7dLGzxkm4Lzue8Dg5kQ3OYu7VXc0Mx09lmvKJmWsrY82fiEu
         EuO0akueSm1zAXD1wCq/6jPRExILBSR1zCfnf2SHeu+cwVRDU6ApMxYBAa5vrrMslj
         THxVakj64gYqOmJtieivkuQlKyypPeTUmqY3PoGvDZIAMidigRZyJI7dlIHi7IfLsl
         z/lKTVVx+NrUBvDUWgf2z48r3DvQxl5P/o/bCZB+nzczU7AxZUAKFiQOtqpkzExToX
         c0aAkEWNJakDw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: [PATCH v2 net-next 2/3] net: ethernet: enetc: get rid of xdp_redirect_sg counter
Date:   Wed,  4 Jan 2023 14:57:11 +0100
Message-Id: <681a7f4f2ead18decd3841ee1b92e47ced9cab1f.1672840490.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1672840490.git.lorenzo@kernel.org>
References: <cover.1672840490.git.lorenzo@kernel.org>
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

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
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
2.39.0

