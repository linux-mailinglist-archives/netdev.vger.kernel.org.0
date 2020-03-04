Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F2E17894D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgCDD4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:56:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbgCDD4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 22:56:01 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E133921739;
        Wed,  4 Mar 2020 03:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294160;
        bh=DGPNyVxCfL6898SaFcGmYo0+khSY5CYF2tMkTP+ItbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TXX2QF7NSssIAJyi3xI3gCc0g3RR+j4tmMXwxpmRiZYKBFBbJpJGX1sQtsmkpMTC
         n0GP8aEPT68d+pJY88gzfMS01iKJSWhWXOtALmj+dmch5lhSN8AUDkyhuctN3ASclb
         qSwtC016I8MiScWMSig+AvAtmOC0IgOTyKJhPkFE=
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
Subject: [PATCH net-next 04/12] stmmac: let core reject the unsupported coalescing parameters
Date:   Tue,  3 Mar 2020 19:54:53 -0800
Message-Id: <20200304035501.628139-5-kuba@kernel.org>
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
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index b29603ec744c..6f551e75ad72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -732,20 +732,6 @@ static int stmmac_set_coalesce(struct net_device *dev,
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
 	unsigned int rx_riwt;
 
-	/* Check not supported parameters  */
-	if ((ec->rx_coalesce_usecs_irq) ||
-	    (ec->rx_max_coalesced_frames_irq) || (ec->tx_coalesce_usecs_irq) ||
-	    (ec->use_adaptive_rx_coalesce) || (ec->use_adaptive_tx_coalesce) ||
-	    (ec->pkt_rate_low) || (ec->rx_coalesce_usecs_low) ||
-	    (ec->rx_max_coalesced_frames_low) || (ec->tx_coalesce_usecs_high) ||
-	    (ec->tx_max_coalesced_frames_low) || (ec->pkt_rate_high) ||
-	    (ec->tx_coalesce_usecs_low) || (ec->rx_coalesce_usecs_high) ||
-	    (ec->rx_max_coalesced_frames_high) ||
-	    (ec->tx_max_coalesced_frames_irq) ||
-	    (ec->stats_block_coalesce_usecs) ||
-	    (ec->tx_max_coalesced_frames_high) || (ec->rate_sample_interval))
-		return -EOPNOTSUPP;
-
 	if (priv->use_riwt && (ec->rx_coalesce_usecs > 0)) {
 		rx_riwt = stmmac_usec2riwt(ec->rx_coalesce_usecs, priv);
 
@@ -914,6 +900,8 @@ static int stmmac_set_tunable(struct net_device *dev,
 }
 
 static const struct ethtool_ops stmmac_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS |
+			  ETHTOOL_COALESCE_MAX_FRAMES,
 	.begin = stmmac_check_if_running,
 	.get_drvinfo = stmmac_ethtool_getdrvinfo,
 	.get_msglevel = stmmac_ethtool_getmsglevel,
-- 
2.24.1

