Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A206178949
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCDDz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgCDDz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 22:55:59 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E31215A4;
        Wed,  4 Mar 2020 03:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294158;
        bh=1x3VIIsVVbyW/2UL+xfEkA6PkP+zVGs7t4V5UsZ+KZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQstJkud1JGxplwY3WhMb1Gfr3r+VJrsoo1qVrG/7pgZJHMew78uTpl7pJmHNQF4X
         SHE0XVeRsgF68fWomlDogsuWOiWvAkn1TayZKldTbOYWLraAWPGlGx9N0LmQ6YieCC
         ui/OUlgg88nlML+yatW5AEKzbD7/rrfj1mhiwSrk=
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
Subject: [PATCH net-next 02/12] xgbe: let core reject the unsupported coalescing parameters
Date:   Tue,  3 Mar 2020 19:54:51 -0800
Message-Id: <20200304035501.628139-3-kuba@kernel.org>
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
We are losing the print, and changing the return value
from EOPNOTSUPP to EINVAL.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c | 26 ++------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index b23c8ee24ee3..e373991c9905 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -450,30 +450,6 @@ static int xgbe_set_coalesce(struct net_device *netdev,
 	unsigned int rx_frames, rx_riwt, rx_usecs;
 	unsigned int tx_frames;
 
-	/* Check for not supported parameters  */
-	if ((ec->rx_coalesce_usecs_irq) ||
-	    (ec->rx_max_coalesced_frames_irq) ||
-	    (ec->tx_coalesce_usecs) ||
-	    (ec->tx_coalesce_usecs_irq) ||
-	    (ec->tx_max_coalesced_frames_irq) ||
-	    (ec->stats_block_coalesce_usecs) ||
-	    (ec->use_adaptive_rx_coalesce) ||
-	    (ec->use_adaptive_tx_coalesce) ||
-	    (ec->pkt_rate_low) ||
-	    (ec->rx_coalesce_usecs_low) ||
-	    (ec->rx_max_coalesced_frames_low) ||
-	    (ec->tx_coalesce_usecs_low) ||
-	    (ec->tx_max_coalesced_frames_low) ||
-	    (ec->pkt_rate_high) ||
-	    (ec->rx_coalesce_usecs_high) ||
-	    (ec->rx_max_coalesced_frames_high) ||
-	    (ec->tx_coalesce_usecs_high) ||
-	    (ec->tx_max_coalesced_frames_high) ||
-	    (ec->rate_sample_interval)) {
-		netdev_err(netdev, "unsupported coalescing parameter\n");
-		return -EOPNOTSUPP;
-	}
-
 	rx_riwt = hw_if->usec_to_riwt(pdata, ec->rx_coalesce_usecs);
 	rx_usecs = ec->rx_coalesce_usecs;
 	rx_frames = ec->rx_max_coalesced_frames;
@@ -837,6 +813,8 @@ static int xgbe_set_channels(struct net_device *netdev,
 }
 
 static const struct ethtool_ops xgbe_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_RX_USECS |
+			  ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo = xgbe_get_drvinfo,
 	.get_msglevel = xgbe_get_msglevel,
 	.set_msglevel = xgbe_set_msglevel,
-- 
2.24.1

