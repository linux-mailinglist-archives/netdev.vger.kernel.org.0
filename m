Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49EE1824EE
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgCKWdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbgCKWdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:12 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B12B2074D;
        Wed, 11 Mar 2020 22:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965992;
        bh=3RRj17xijDW4xCkcqonC+maTV4I7uxdXYjKKPDRu+JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK58A1VqGWdRaLxL+8tzfXLnitz0vIKrMzYQYK9sBCZKBI1PBTJ7bYuHc0nnJoOU4
         LKOwlAcfXgZyPb8PMe2tnPBbWPK0Ir7oT5Edy/H9on6OrOKPOd7WyJdzgdO9kNVV+o
         h9tMiIxALvfbvwKEmrdPSOcvreoSlbOz1TChlBZ8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/15] net: dpaa: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:32:49 -0700
Message-Id: <20200311223302.2171564-3-kuba@kernel.org>
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

This driver did not previously reject unsupported parameters
(other than adaptive rx, which will now be rejected by core).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 6aa1fa22cd04..9db2a02fb531 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -525,7 +525,6 @@ static int dpaa_get_coalesce(struct net_device *dev,
 
 	c->rx_coalesce_usecs = period;
 	c->rx_max_coalesced_frames = thresh;
-	c->use_adaptive_rx_coalesce = false;
 
 	return 0;
 }
@@ -540,9 +539,6 @@ static int dpaa_set_coalesce(struct net_device *dev,
 	u8 thresh, prev_thresh;
 	int cpu, res;
 
-	if (c->use_adaptive_rx_coalesce)
-		return -EINVAL;
-
 	period = c->rx_coalesce_usecs;
 	thresh = c->rx_max_coalesced_frames;
 
@@ -582,6 +578,8 @@ static int dpaa_set_coalesce(struct net_device *dev,
 }
 
 const struct ethtool_ops dpaa_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_RX_MAX_FRAMES,
 	.get_drvinfo = dpaa_get_drvinfo,
 	.get_msglevel = dpaa_get_msglevel,
 	.set_msglevel = dpaa_set_msglevel,
-- 
2.24.1

