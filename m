Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C63517894B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgCDD4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbgCDD4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 22:56:02 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C336721556;
        Wed,  4 Mar 2020 03:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294162;
        bh=A2nLRdbpx5zpOxHK5my7qpjZdjz9Rc+1Y5V02visWvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTdia89/iq4atNrzaSVzgaaHwdYml6R8lSFqEef+DkyCuzkxRHKnwLGtZW0mrbhF7
         ePJhb1VSNj4hVV3Xyf+am7avVxg9wm/IVIu3g/AJsJ/kRXgUvcHvx7HP/3TwwIm+aU
         mD5mHGqIyGeErcaZo9b6BCmwXAqNytFrTus7q248=
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
Subject: [PATCH net-next 06/12] ionic: let core reject the unsupported coalescing parameters
Date:   Tue,  3 Mar 2020 19:54:55 -0800
Message-Id: <20200304035501.628139-7-kuba@kernel.org>
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
No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 23 +------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index f778fff034f5..83ea35715533 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -412,28 +412,6 @@ static int ionic_set_coalesce(struct net_device *netdev,
 	unsigned int i;
 	u32 coal;
 
-	if (coalesce->rx_max_coalesced_frames ||
-	    coalesce->rx_coalesce_usecs_irq ||
-	    coalesce->rx_max_coalesced_frames_irq ||
-	    coalesce->tx_max_coalesced_frames ||
-	    coalesce->tx_coalesce_usecs_irq ||
-	    coalesce->tx_max_coalesced_frames_irq ||
-	    coalesce->stats_block_coalesce_usecs ||
-	    coalesce->use_adaptive_rx_coalesce ||
-	    coalesce->use_adaptive_tx_coalesce ||
-	    coalesce->pkt_rate_low ||
-	    coalesce->rx_coalesce_usecs_low ||
-	    coalesce->rx_max_coalesced_frames_low ||
-	    coalesce->tx_coalesce_usecs_low ||
-	    coalesce->tx_max_coalesced_frames_low ||
-	    coalesce->pkt_rate_high ||
-	    coalesce->rx_coalesce_usecs_high ||
-	    coalesce->rx_max_coalesced_frames_high ||
-	    coalesce->tx_coalesce_usecs_high ||
-	    coalesce->tx_max_coalesced_frames_high ||
-	    coalesce->rate_sample_interval)
-		return -EINVAL;
-
 	ident = &lif->ionic->ident;
 	if (ident->dev.intr_coal_div == 0) {
 		netdev_warn(netdev, "bad HW value in dev.intr_coal_div = %d\n",
@@ -784,6 +762,7 @@ static int ionic_nway_reset(struct net_device *netdev)
 }
 
 static const struct ethtool_ops ionic_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo		= ionic_get_drvinfo,
 	.get_regs_len		= ionic_get_regs_len,
 	.get_regs		= ionic_get_regs,
-- 
2.24.1

