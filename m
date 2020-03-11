Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4B61824FA
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbgCKWd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387418AbgCKWdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:19 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B162074B;
        Wed, 11 Mar 2020 22:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965999;
        bh=PM0pe/qU+MK7PQ2Ltv8yLU04UK/Y17GUtAvHwxgTVV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bG5cyukxXlG3t+rVCddwKFZUEudemcjSYGWgzLyZcjmXd6f6fWjT936pQoZVmkBux
         AmedUK8EBtLzdrRk5xloHE51xxtFSIto5MNf0SI3oykR/00vD3tLnVWA2fiZAmdAOm
         TsCPGuljHWhk3hqTmkYitVXQEWCR/wl3vDJKqfJQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/15] net: igb: let core reject the unsupported coalescing parameters
Date:   Wed, 11 Mar 2020 15:32:58 -0700
Message-Id: <20200311223302.2171564-12-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311223302.2171564-1-kuba@kernel.org>
References: <20200311223302.2171564-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver was rejecting almost all unsupported
parameters already, it was only missing a check
for tx_max_coalesced_frames_irq.

As a side effect of these changes the error code for
unsupported params changes from ENOTSUPP to EOPNOTSUPP.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 22 +-------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index f96ffa83efbe..39d3b76a6f5d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2183,27 +2183,6 @@ static int igb_set_coalesce(struct net_device *netdev,
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	int i;
 
-	if (ec->rx_max_coalesced_frames ||
-	    ec->rx_coalesce_usecs_irq ||
-	    ec->rx_max_coalesced_frames_irq ||
-	    ec->tx_max_coalesced_frames ||
-	    ec->tx_coalesce_usecs_irq ||
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
-		return -ENOTSUPP;
-
 	if ((ec->rx_coalesce_usecs > IGB_MAX_ITR_USECS) ||
 	    ((ec->rx_coalesce_usecs > 3) &&
 	     (ec->rx_coalesce_usecs < IGB_MIN_ITR_USECS)) ||
@@ -3477,6 +3456,7 @@ static int igb_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 }
 
 static const struct ethtool_ops igb_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo		= igb_get_drvinfo,
 	.get_regs_len		= igb_get_regs_len,
 	.get_regs		= igb_get_regs,
-- 
2.24.1

