Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E22E17899C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgCDEe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgCDEe3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 23:34:29 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD6C21775;
        Wed,  4 Mar 2020 04:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583296468;
        bh=9tlODLwVl4B8kWSCDgSAlayVxTkBmbYIA4vvvylHZ0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0H/NZCTmetrAT9KpeVHHb5sO1Cb+LDnTZfk0wFTGElMtXl1eJMay7/rJfdKtlJRw
         36OudadQUA2gkPHkxl+G/gBPuxOutN53OEy7Hr+aWBV92GkBguK153pdKY1YLb2QYq
         7ljp0MZVNcIRlkGN9Ma8CJ/dlPbAs+QDttv/YAY4=
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
Subject: [PATCH net-next v2 03/12] enic: let core reject the unsupported coalescing parameters
Date:   Tue,  3 Mar 2020 20:33:45 -0800
Message-Id: <20200304043354.716290-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304043354.716290-1-kuba@kernel.org>
References: <20200304043354.716290-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->coalesce_types to let the core reject
unsupported coalescing parameters.

This driver correctly rejects all unsupported parameters.
No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/cisco/enic/enic_ethtool.c    | 23 ++++---------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index ebd5c2cf1efe..bff487a2c5be 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -324,25 +324,6 @@ static int enic_coalesce_valid(struct enic *enic,
 	u32 rx_coalesce_usecs_low = min_t(u32, coalesce_usecs_max,
 					  ec->rx_coalesce_usecs_low);
 
-	if (ec->rx_max_coalesced_frames		||
-	    ec->rx_coalesce_usecs_irq		||
-	    ec->rx_max_coalesced_frames_irq	||
-	    ec->tx_max_coalesced_frames		||
-	    ec->tx_coalesce_usecs_irq		||
-	    ec->tx_max_coalesced_frames_irq	||
-	    ec->stats_block_coalesce_usecs	||
-	    ec->use_adaptive_tx_coalesce	||
-	    ec->pkt_rate_low			||
-	    ec->rx_max_coalesced_frames_low	||
-	    ec->tx_coalesce_usecs_low		||
-	    ec->tx_max_coalesced_frames_low	||
-	    ec->pkt_rate_high			||
-	    ec->rx_max_coalesced_frames_high	||
-	    ec->tx_coalesce_usecs_high		||
-	    ec->tx_max_coalesced_frames_high	||
-	    ec->rate_sample_interval)
-		return -EINVAL;
-
 	if ((vnic_dev_get_intr_mode(enic->vdev) != VNIC_DEV_INTR_MODE_MSIX) &&
 	    ec->tx_coalesce_usecs)
 		return -EINVAL;
@@ -636,6 +617,10 @@ static int enic_get_ts_info(struct net_device *netdev,
 }
 
 static const struct ethtool_ops enic_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS |
+			  ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
+			  ETHTOOL_COALESCE_RX_USECS_LOW |
+			  ETHTOOL_COALESCE_RX_USECS_HIGH,
 	.get_drvinfo = enic_get_drvinfo,
 	.get_msglevel = enic_get_msglevel,
 	.set_msglevel = enic_set_msglevel,
-- 
2.24.1

