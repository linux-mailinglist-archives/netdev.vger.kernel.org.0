Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9242C17894C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCDD4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:56:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbgCDD4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 22:56:02 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A21217F4;
        Wed,  4 Mar 2020 03:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294161;
        bh=ufkxPWFu96OBTRqbD6kMma2pWkaOjcQjvt2t56RdD+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEsnf1Wwdt+rEMcmtOt0ts64ao4kAKLS6aQ5LhI/+7/5L6z4DqSDsHp6blaimPS8Y
         eYJ8bQvKQoHgezgwLH15M/veE4ZuvViQ72zLYGgOh43aV7u5TSDzyAx3XcC/RGaWPB
         QAWmXIcsc0xnfG6C/uSqzdpi99Q87z2GDQoriOTI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/12] nfp: let core reject the unsupported coalescing parameters
Date:   Tue,  3 Mar 2020 19:54:54 -0800
Message-Id: <20200304035501.628139-6-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304035501.628139-1-kuba@kernel.org>
References: <20200304035501.628139-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->coalesce_types to let the core reject
unsupported coalescing parameters.

This driver correctly rejects all unsupported parameters.
As a side effect of these changes the error code for
unsupported params changes from EOPNOTSUPP to EINVAL.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 22 ++-----------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index d648e32c0520..71354ff2fe7d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1343,26 +1343,6 @@ static int nfp_net_set_coalesce(struct net_device *netdev,
 	struct nfp_net *nn = netdev_priv(netdev);
 	unsigned int factor;
 
-	if (ec->rx_coalesce_usecs_irq ||
-	    ec->rx_max_coalesced_frames_irq ||
-	    ec->tx_coalesce_usecs_irq ||
-	    ec->tx_max_coalesced_frames_irq ||
-	    ec->stats_block_coalesce_usecs ||
-	    ec->use_adaptive_rx_coalesce ||
-	    ec->use_adaptive_tx_coalesce ||
-	    ec->pkt_rate_low ||
-	    ec->rx_coalesce_usecs_low ||
-	    ec->rx_max_coalesced_frames_low ||
-	    ec->tx_coalesce_usecs_low ||
-	    ec->tx_max_coalesced_frames_low ||
-	    ec->pkt_rate_high ||
-	    ec->rx_coalesce_usecs_high ||
-	    ec->rx_max_coalesced_frames_high ||
-	    ec->tx_coalesce_usecs_high ||
-	    ec->tx_max_coalesced_frames_high ||
-	    ec->rate_sample_interval)
-		return -EOPNOTSUPP;
-
 	/* Compute factor used to convert coalesce '_usecs' parameters to
 	 * ME timestamp ticks.  There are 16 ME clock cycles for each timestamp
 	 * count.
@@ -1476,6 +1456,8 @@ static int nfp_net_set_channels(struct net_device *netdev,
 }
 
 static const struct ethtool_ops nfp_net_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS |
+			  ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo		= nfp_net_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_ringparam		= nfp_net_get_ringparam,
-- 
2.24.1

