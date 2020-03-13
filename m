Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71385183FF1
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCMEIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbgCMEIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:15 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39947206FA;
        Fri, 13 Mar 2020 04:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072495;
        bh=Z+V+dl+MRWFmWuHV02qUxPlB1A9sJvhO1E4ty2SyUHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoC3eqdezF0y184JY4YhttD5j7cmwdfaE1x/jhaJ92f3iaDTgXxXvyAbw8f891JqC
         GsZvAD7jS6Rx9srfr3O/QxOcJGlIFlaesdvfWR/BWLrOHxXKawDXRMvLoIXGvG+n3h
         ImeTc8Ud+0TZ4HXK+up7ZFlgv8Wu6WQfb03Z3vRQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        cooldavid@cooldavid.org, sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        rmk+kernel@armlinux.org.uk, mcroce@redhat.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, mlindner@marvell.com,
        stephen@networkplumber.org, christopher.lee@cspi.com,
        manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        nic_swsd@realtek.com, hkallweit1@gmail.com, bh74.an@samsung.com,
        romieu@fr.zoreil.com
Subject: [PATCH net-next 09/15] net: nixge: let core reject the unsupported coalescing parameters
Date:   Thu, 12 Mar 2020 21:07:57 -0700
Message-Id: <20200313040803.2367590-10-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313040803.2367590-1-kuba@kernel.org>
References: <20200313040803.2367590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver correctly rejects all unsupported
parameters, no functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/ni/nixge.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 49c7987c2abd..2fdd0753b3af 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1019,27 +1019,6 @@ static int nixge_ethtools_set_coalesce(struct net_device *ndev,
 		return -EBUSY;
 	}
 
-	if (ecoalesce->rx_coalesce_usecs ||
-	    ecoalesce->rx_coalesce_usecs_irq ||
-	    ecoalesce->rx_max_coalesced_frames_irq ||
-	    ecoalesce->tx_coalesce_usecs ||
-	    ecoalesce->tx_coalesce_usecs_irq ||
-	    ecoalesce->tx_max_coalesced_frames_irq ||
-	    ecoalesce->stats_block_coalesce_usecs ||
-	    ecoalesce->use_adaptive_rx_coalesce ||
-	    ecoalesce->use_adaptive_tx_coalesce ||
-	    ecoalesce->pkt_rate_low ||
-	    ecoalesce->rx_coalesce_usecs_low ||
-	    ecoalesce->rx_max_coalesced_frames_low ||
-	    ecoalesce->tx_coalesce_usecs_low ||
-	    ecoalesce->tx_max_coalesced_frames_low ||
-	    ecoalesce->pkt_rate_high ||
-	    ecoalesce->rx_coalesce_usecs_high ||
-	    ecoalesce->rx_max_coalesced_frames_high ||
-	    ecoalesce->tx_coalesce_usecs_high ||
-	    ecoalesce->tx_max_coalesced_frames_high ||
-	    ecoalesce->rate_sample_interval)
-		return -EOPNOTSUPP;
 	if (ecoalesce->rx_max_coalesced_frames)
 		priv->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
 	if (ecoalesce->tx_max_coalesced_frames)
@@ -1083,6 +1062,7 @@ static int nixge_ethtools_set_phys_id(struct net_device *ndev,
 }
 
 static const struct ethtool_ops nixge_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo    = nixge_ethtools_get_drvinfo,
 	.get_coalesce   = nixge_ethtools_get_coalesce,
 	.set_coalesce   = nixge_ethtools_set_coalesce,
-- 
2.24.1

