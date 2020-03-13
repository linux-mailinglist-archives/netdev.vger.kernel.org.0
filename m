Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34B8183FF5
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCMEIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgCMEIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:16 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D61D20767;
        Fri, 13 Mar 2020 04:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072496;
        bh=P7nDgmfu0Mi1kzjATtYotef52CzNEI9Oajed06rlfew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOAwt0LRGqk9fENOoVZo0hjJ2jGvWkCX6/xy/Ti9B4rTa2nEQN36lUHrGIwFtSKA3
         uo5uXFbUuTLjwDUcRM7QVfPQfnFog4/HIjQT9PfqRPNSFhcfu1TN/PNwx58zrxhFrT
         7lONlhz4HR17upSceJLS6nsT9KJw5+o+1WKNTUPA=
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
Subject: [PATCH net-next 10/15] net: netxen: let core reject the unsupported coalescing parameters
Date:   Thu, 12 Mar 2020 21:07:58 -0700
Message-Id: <20200313040803.2367590-11-kuba@kernel.org>
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

As a side effect of these changes the error code for
unsupported params changes from EINVAL to EOPNOTSUPP.

The driver was missing a check for rate_sample_interval.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../qlogic/netxen/netxen_nic_ethtool.c        | 21 +++----------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index 6a2d91d58968..66f45fce90fa 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -748,24 +748,7 @@ static int netxen_set_intr_coalesce(struct net_device *netdev,
 	if (ethcoal->rx_coalesce_usecs > 0xffff ||
 		ethcoal->rx_max_coalesced_frames > 0xffff ||
 		ethcoal->tx_coalesce_usecs > 0xffff ||
-		ethcoal->tx_max_coalesced_frames > 0xffff ||
-		ethcoal->rx_coalesce_usecs_irq ||
-		ethcoal->rx_max_coalesced_frames_irq ||
-		ethcoal->tx_coalesce_usecs_irq ||
-		ethcoal->tx_max_coalesced_frames_irq ||
-		ethcoal->stats_block_coalesce_usecs ||
-		ethcoal->use_adaptive_rx_coalesce ||
-		ethcoal->use_adaptive_tx_coalesce ||
-		ethcoal->pkt_rate_low ||
-		ethcoal->rx_coalesce_usecs_low ||
-		ethcoal->rx_max_coalesced_frames_low ||
-		ethcoal->tx_coalesce_usecs_low ||
-		ethcoal->tx_max_coalesced_frames_low ||
-		ethcoal->pkt_rate_high ||
-		ethcoal->rx_coalesce_usecs_high ||
-		ethcoal->rx_max_coalesced_frames_high ||
-		ethcoal->tx_coalesce_usecs_high ||
-		ethcoal->tx_max_coalesced_frames_high)
+		ethcoal->tx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
 
 	if (!ethcoal->rx_coalesce_usecs ||
@@ -923,6 +906,8 @@ netxen_get_dump_data(struct net_device *netdev, struct ethtool_dump *dump,
 }
 
 const struct ethtool_ops netxen_nic_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo = netxen_nic_get_drvinfo,
 	.get_regs_len = netxen_nic_get_regs_len,
 	.get_regs = netxen_nic_get_regs,
-- 
2.24.1

