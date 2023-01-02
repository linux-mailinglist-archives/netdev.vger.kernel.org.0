Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE865B40A
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbjABPTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236336AbjABPTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:19:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2B410B0
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61D0DB80C70
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A96C433EF;
        Mon,  2 Jan 2023 15:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672672759;
        bh=5oZyVv3sIxKejDrYUiT1Nu/dIoe8s5jODZGWH1lQAR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U21UkQCmSr6p2dYHITw1o8xh1u2yKdBk6sx4kjukjcCa/Qpgkh+krMeRSoPrbb/zL
         rdiAkjucwRI86GmPXKIkbNPQpRfODehtOk6xGy7jFIVbpV4cx1uXMUa/im1afTx4L/
         zbM0nPqkYueWLUjJNjcpPGDNLHXTo658/J9lqnthcrMgMXPwR+LVNczGw0zGqhVOAE
         gEWOwUeMH2r67r8KSKZ7/hOPhZweeqtCatpxrbn1gsq790+pxzA/mwoKZRT2bghkZp
         fuXfEVUaCuL4OxefTPqboN77dkMlxOf507SWX5GVQu1ZMhY27LvxkEOlZlmtPOnTUa
         TY+d4X0bq5Z9w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: [PATCH net-next 2/3] net: ethernet: enetc: get rid of xdp_redirect_sg counter
Date:   Mon,  2 Jan 2023 16:18:52 +0100
Message-Id: <1a6681949f1aa9271d6957bb48d2338ace454136.1672672314.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1672672314.git.lorenzo@kernel.org>
References: <cover.1672672314.git.lorenzo@kernel.org>
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

