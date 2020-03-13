Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BFE183FF0
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgCMEIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgCMEIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5102074C;
        Fri, 13 Mar 2020 04:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072490;
        bh=n2eivnnlYgl+7pmU8xbyWo8fcEbCzETgRFg4nEPtLho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFPaViOh270LPvtiFYlSecoK4cA0XlnTCSbQLMRC36FjwOE2rpvViUd+Wb2c2+fH4
         gC9VmMcl82dfRkC2uLy39mzx1dAeYPAxzKv1O81w10x/NtTurucYUu1YMepiGyi7WI
         2SIYDLe9288PpH7YlLJU6FDjBzbWut4wuN9iiA54=
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
Subject: [PATCH net-next 05/15] net: octeontx2-pf: let core reject the unsupported coalescing parameters
Date:   Thu, 12 Mar 2020 21:07:53 -0700
Message-Id: <20200313040803.2367590-6-kuba@kernel.org>
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
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c   | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index f450111423a8..017a295f568f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -368,17 +368,6 @@ static int otx2_set_coalesce(struct net_device *netdev,
 	struct otx2_hw *hw = &pfvf->hw;
 	int qidx;
 
-	if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
-	    ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
-	    ec->tx_coalesce_usecs_irq || ec->tx_max_coalesced_frames_irq ||
-	    ec->stats_block_coalesce_usecs || ec->pkt_rate_low ||
-	    ec->rx_coalesce_usecs_low || ec->rx_max_coalesced_frames_low ||
-	    ec->tx_coalesce_usecs_low || ec->tx_max_coalesced_frames_low ||
-	    ec->pkt_rate_high || ec->rx_coalesce_usecs_high ||
-	    ec->rx_max_coalesced_frames_high || ec->tx_coalesce_usecs_high ||
-	    ec->tx_max_coalesced_frames_high || ec->rate_sample_interval)
-		return -EOPNOTSUPP;
-
 	if (!ec->rx_max_coalesced_frames || !ec->tx_max_coalesced_frames)
 		return 0;
 
@@ -674,6 +663,8 @@ static u32 otx2_get_link(struct net_device *netdev)
 }
 
 static const struct ethtool_ops otx2_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_link		= otx2_get_link,
 	.get_drvinfo		= otx2_get_drvinfo,
 	.get_strings		= otx2_get_strings,
-- 
2.24.1

