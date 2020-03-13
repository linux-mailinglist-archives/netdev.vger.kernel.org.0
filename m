Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3940B183FF8
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgCMEIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgCMEIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:19 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E512520768;
        Fri, 13 Mar 2020 04:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072498;
        bh=0xI/uHXF1lhRINtJVBujQs9WaAJjHtytOZIL9WGBnYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xb9uL6dRY/lp2l62/iYgEmyDR4yDWN/rtmsoNZuDTIU1Ih02i5Lj62sVxB3+ljBQZ
         ZbPs+SC0s7uPKA7FLCDchV1urtg330FZeQbz4pAxs4Q3D1vE4Z7zdQ8TCVVj9EZ1Yr
         jlhooGNhH8ntpipY9FBwN39fmmJvuJaTPCwW3Q0g=
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
Subject: [PATCH net-next 12/15] net: qlnic: let core reject the unsupported coalescing parameters
Date:   Thu, 12 Mar 2020 21:08:00 -0700
Message-Id: <20200313040803.2367590-13-kuba@kernel.org>
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

This driver already correctly rejected almost all
unsupported parameters (missing sample_rate_interval).

As a side effect of these changes the error code for
unsupported params changes from EINVAL to EOPNOTSUPP.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/qlogic/qlcnic/qlcnic_ethtool.c   | 23 ++++---------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index 75d83c3cbf27..5c2a3acf1e89 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1542,24 +1542,7 @@ static int qlcnic_set_intr_coalesce(struct net_device *netdev,
 	if (ethcoal->rx_coalesce_usecs > 0xffff ||
 	    ethcoal->rx_max_coalesced_frames > 0xffff ||
 	    ethcoal->tx_coalesce_usecs > 0xffff ||
-	    ethcoal->tx_max_coalesced_frames > 0xffff ||
-	    ethcoal->rx_coalesce_usecs_irq ||
-	    ethcoal->rx_max_coalesced_frames_irq ||
-	    ethcoal->tx_coalesce_usecs_irq ||
-	    ethcoal->tx_max_coalesced_frames_irq ||
-	    ethcoal->stats_block_coalesce_usecs ||
-	    ethcoal->use_adaptive_rx_coalesce ||
-	    ethcoal->use_adaptive_tx_coalesce ||
-	    ethcoal->pkt_rate_low ||
-	    ethcoal->rx_coalesce_usecs_low ||
-	    ethcoal->rx_max_coalesced_frames_low ||
-	    ethcoal->tx_coalesce_usecs_low ||
-	    ethcoal->tx_max_coalesced_frames_low ||
-	    ethcoal->pkt_rate_high ||
-	    ethcoal->rx_coalesce_usecs_high ||
-	    ethcoal->rx_max_coalesced_frames_high ||
-	    ethcoal->tx_coalesce_usecs_high ||
-	    ethcoal->tx_max_coalesced_frames_high)
+	    ethcoal->tx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
 
 	err = qlcnic_config_intr_coalesce(adapter, ethcoal);
@@ -1834,6 +1817,8 @@ qlcnic_set_dump(struct net_device *netdev, struct ethtool_dump *val)
 }
 
 const struct ethtool_ops qlcnic_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo = qlcnic_get_drvinfo,
 	.get_regs_len = qlcnic_get_regs_len,
 	.get_regs = qlcnic_get_regs,
@@ -1865,6 +1850,8 @@ const struct ethtool_ops qlcnic_ethtool_ops = {
 };
 
 const struct ethtool_ops qlcnic_sriov_vf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo		= qlcnic_get_drvinfo,
 	.get_regs_len		= qlcnic_get_regs_len,
 	.get_regs		= qlcnic_get_regs,
-- 
2.24.1

