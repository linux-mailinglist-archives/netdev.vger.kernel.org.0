Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676FC187434
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbgCPUr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732588AbgCPUrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:25 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ED9D2073C;
        Mon, 16 Mar 2020 20:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391644;
        bh=rQni17X/6KdO7YhjnzJvhjdjopyf0UZB/b5kVjSjs0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIGgNszuY+7+yo1GP8GuwkvjNhbXSlDg3EEBXPc8EeIY8J2FHwLN/aWtPWT19i/P9
         X0JN5n2yrrlrImNbIExLiNNRj4m39CZQ4jkWvRXnoYxYlhYoeSBgBBRuwCEzNDIAy+
         zHGyiIm2FkM9d2b+6osJJcrFU1twaJ6+4Wuu+mlo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/9] net: dwc-xlgmac: let core reject the unsupported coalescing parameters
Date:   Mon, 16 Mar 2020 13:47:06 -0700
Message-Id: <20200316204712.3098382-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316204712.3098382-1-kuba@kernel.org>
References: <20200316204712.3098382-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver already correctly rejected all unsupported
parameters.

While at it remove unnecessary zeroing on get.

No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/synopsys/dwc-xlgmac-ethtool.c  | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
index fde722136869..bc198eadfcab 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
@@ -151,7 +151,6 @@ static int xlgmac_ethtool_get_coalesce(struct net_device *netdev,
 {
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 
-	memset(ec, 0, sizeof(struct ethtool_coalesce));
 	ec->rx_coalesce_usecs = pdata->rx_usecs;
 	ec->rx_max_coalesced_frames = pdata->rx_frames;
 	ec->tx_max_coalesced_frames = pdata->tx_frames;
@@ -167,20 +166,6 @@ static int xlgmac_ethtool_set_coalesce(struct net_device *netdev,
 	unsigned int rx_frames, rx_riwt, rx_usecs;
 	unsigned int tx_frames;
 
-	/* Check for not supported parameters */
-	if ((ec->rx_coalesce_usecs_irq) || (ec->rx_max_coalesced_frames_irq) ||
-	    (ec->tx_coalesce_usecs) || (ec->tx_coalesce_usecs_high) ||
-	    (ec->tx_max_coalesced_frames_irq) || (ec->tx_coalesce_usecs_irq) ||
-	    (ec->stats_block_coalesce_usecs) ||  (ec->pkt_rate_low) ||
-	    (ec->use_adaptive_rx_coalesce) || (ec->use_adaptive_tx_coalesce) ||
-	    (ec->rx_max_coalesced_frames_low) || (ec->rx_coalesce_usecs_low) ||
-	    (ec->tx_coalesce_usecs_low) || (ec->tx_max_coalesced_frames_low) ||
-	    (ec->pkt_rate_high) || (ec->rx_coalesce_usecs_high) ||
-	    (ec->rx_max_coalesced_frames_high) ||
-	    (ec->tx_max_coalesced_frames_high) ||
-	    (ec->rate_sample_interval))
-		return -EOPNOTSUPP;
-
 	rx_usecs = ec->rx_coalesce_usecs;
 	rx_riwt = hw_ops->usec_to_riwt(pdata, rx_usecs);
 	rx_frames = ec->rx_max_coalesced_frames;
@@ -257,6 +242,8 @@ static void xlgmac_ethtool_get_ethtool_stats(struct net_device *netdev,
 }
 
 static const struct ethtool_ops xlgmac_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo = xlgmac_ethtool_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_msglevel = xlgmac_ethtool_get_msglevel,
-- 
2.24.1

