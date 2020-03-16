Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E7187437
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbgCPUrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732613AbgCPUr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:29 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA6D20753;
        Mon, 16 Mar 2020 20:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391649;
        bh=x7QquaWPZHr21v78IZRqMv5qYe3nQW2NGMORkBhObEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/yPCuHi8uTwJs2o1vU3pE9fW1mJjPMluDr1XNCBFxxvr4N6R8F2KApWwcS238U3t
         EjUExu1NuInVvsK1i6Z4X5/VbO5gYvlNlqjUpqPToV7qhz3v5+Dpn+bou5ow3J5xNz
         BoPMMcaqIu2aBwO4Z7g68kER3YZAnRI236nGp9NM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/9] net: axienet: let core reject the unsupported coalescing parameters
Date:   Mon, 16 Mar 2020 13:47:11 -0700
Message-Id: <20200316204712.3098382-9-kuba@kernel.org>
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
parameters. No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 22 +------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c2f4c5ca2e80..e2f3e2b0cec7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1309,27 +1309,6 @@ static int axienet_ethtools_set_coalesce(struct net_device *ndev,
 		return -EFAULT;
 	}
 
-	if ((ecoalesce->rx_coalesce_usecs) ||
-	    (ecoalesce->rx_coalesce_usecs_irq) ||
-	    (ecoalesce->rx_max_coalesced_frames_irq) ||
-	    (ecoalesce->tx_coalesce_usecs) ||
-	    (ecoalesce->tx_coalesce_usecs_irq) ||
-	    (ecoalesce->tx_max_coalesced_frames_irq) ||
-	    (ecoalesce->stats_block_coalesce_usecs) ||
-	    (ecoalesce->use_adaptive_rx_coalesce) ||
-	    (ecoalesce->use_adaptive_tx_coalesce) ||
-	    (ecoalesce->pkt_rate_low) ||
-	    (ecoalesce->rx_coalesce_usecs_low) ||
-	    (ecoalesce->rx_max_coalesced_frames_low) ||
-	    (ecoalesce->tx_coalesce_usecs_low) ||
-	    (ecoalesce->tx_max_coalesced_frames_low) ||
-	    (ecoalesce->pkt_rate_high) ||
-	    (ecoalesce->rx_coalesce_usecs_high) ||
-	    (ecoalesce->rx_max_coalesced_frames_high) ||
-	    (ecoalesce->tx_coalesce_usecs_high) ||
-	    (ecoalesce->tx_max_coalesced_frames_high) ||
-	    (ecoalesce->rate_sample_interval))
-		return -EOPNOTSUPP;
 	if (ecoalesce->rx_max_coalesced_frames)
 		lp->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
 	if (ecoalesce->tx_max_coalesced_frames)
@@ -1357,6 +1336,7 @@ axienet_ethtools_set_link_ksettings(struct net_device *ndev,
 }
 
 static const struct ethtool_ops axienet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo    = axienet_ethtools_get_drvinfo,
 	.get_regs_len   = axienet_ethtools_get_regs_len,
 	.get_regs       = axienet_ethtools_get_regs,
-- 
2.24.1

