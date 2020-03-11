Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26401824F7
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbgCKWdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbgCKWdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:21 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CA432074E;
        Wed, 11 Mar 2020 22:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583966001;
        bh=aNxiHOL7/w+Rd4biElDRHrvOp1wlOhTfkihJQkda8lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJGNDV4GcY/xkUxtEpQmzLxPbTONish2kRS2NaQn7BnRVa7Iqjy87IFoQwTMDupzJ
         TaJVMfX0ye/lVVAMub50o1LNxKkFGIBSMz23cxqQL8d5zdcmEZDDQv/zb2NIYMOlpz
         IG3/qPqaBNTQol27TOUgTfGw3ZrdmNRnfCW327Rg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 13/15] net: igc: let core reject the unsupported coalescing parameters
Date:   Wed, 11 Mar 2020 15:33:00 -0700
Message-Id: <20200311223302.2171564-14-kuba@kernel.org>
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
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 22 +-------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 69f50b8e2af3..f530fc29b074 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -861,27 +861,6 @@ static int igc_set_coalesce(struct net_device *netdev,
 	struct igc_adapter *adapter = netdev_priv(netdev);
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
 	if (ec->rx_coalesce_usecs > IGC_MAX_ITR_USECS ||
 	    (ec->rx_coalesce_usecs > 3 &&
 	     ec->rx_coalesce_usecs < IGC_MIN_ITR_USECS) ||
@@ -1915,6 +1894,7 @@ static int igc_set_link_ksettings(struct net_device *netdev,
 }
 
 static const struct ethtool_ops igc_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo		= igc_get_drvinfo,
 	.get_regs_len		= igc_get_regs_len,
 	.get_regs		= igc_get_regs,
-- 
2.24.1

