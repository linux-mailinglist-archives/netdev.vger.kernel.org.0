Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BB31789A0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgCDEef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgCDEed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 23:34:33 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04F92146E;
        Wed,  4 Mar 2020 04:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583296472;
        bh=mbvL/GVdKaVZBmyv3hwIpJzHKZ2NQWrGuiaxj3tJWqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTqLL1gQDHxKhHTpFzMOSyRrfdOYjoSZxr8LJTvpPx2HX5vPi1yMnqPu088sq91tK
         NAoSAU3ZfqcElIZTH+KKuvXxMCvRDN3BWPfQTVGDF20GCqGjGD9KWjHAhG2D+IpXye
         R2z+ZQZTYRXQbw0Wrv2U5/bSE/1E8yNoXHAPGdS0=
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
Subject: [PATCH net-next v2 07/12] hisilicon: let core reject the unsupported coalescing parameters
Date:   Tue,  3 Mar 2020 20:33:49 -0800
Message-Id: <20200304043354.716290-8-kuba@kernel.org>
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
As a side effect of these changes the error code for
unsupported params changes from EOPNOTSUPP to EINVAL.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index d9718b87279d..74d1a5778c3e 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -811,20 +811,6 @@ static int hip04_set_coalesce(struct net_device *netdev,
 {
 	struct hip04_priv *priv = netdev_priv(netdev);
 
-	/* Check not supported parameters  */
-	if ((ec->rx_max_coalesced_frames) || (ec->rx_coalesce_usecs_irq) ||
-	    (ec->rx_max_coalesced_frames_irq) || (ec->tx_coalesce_usecs_irq) ||
-	    (ec->use_adaptive_rx_coalesce) || (ec->use_adaptive_tx_coalesce) ||
-	    (ec->pkt_rate_low) || (ec->rx_coalesce_usecs_low) ||
-	    (ec->rx_max_coalesced_frames_low) || (ec->tx_coalesce_usecs_high) ||
-	    (ec->tx_max_coalesced_frames_low) || (ec->pkt_rate_high) ||
-	    (ec->tx_coalesce_usecs_low) || (ec->rx_coalesce_usecs_high) ||
-	    (ec->rx_max_coalesced_frames_high) || (ec->rx_coalesce_usecs) ||
-	    (ec->tx_max_coalesced_frames_irq) ||
-	    (ec->stats_block_coalesce_usecs) ||
-	    (ec->tx_max_coalesced_frames_high) || (ec->rate_sample_interval))
-		return -EOPNOTSUPP;
-
 	if ((ec->tx_coalesce_usecs > HIP04_MAX_TX_COALESCE_USECS ||
 	     ec->tx_coalesce_usecs < HIP04_MIN_TX_COALESCE_USECS) ||
 	    (ec->tx_max_coalesced_frames > HIP04_MAX_TX_COALESCE_FRAMES ||
@@ -845,6 +831,8 @@ static void hip04_get_drvinfo(struct net_device *netdev,
 }
 
 static const struct ethtool_ops hip04_ethtool_ops = {
+	.coalesce_types		= ETHTOOL_COALESCE_TX_USECS |
+				  ETHTOOL_COALESCE_TX_MAX_FRAMES,
 	.get_coalesce		= hip04_get_coalesce,
 	.set_coalesce		= hip04_set_coalesce,
 	.get_drvinfo		= hip04_get_drvinfo,
-- 
2.24.1

