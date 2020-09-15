Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CE1269A35
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgIOANU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgIOANL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 20:13:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E7821974;
        Tue, 15 Sep 2020 00:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600128791;
        bh=BURW2NOcDEFABePQdvSyR98WCw+B/RY7cx7e+F8xCXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkBMxRXFYxWt/2HP8GYbZxMcH614DOmEe1NGpaILUwnKBsSoFkNrF0XBAtE7PYdMo
         KsGXELkjLPPjWq8UaMMEu1gjFnJYukDOB67VCZtLOOk4OmnGNGlUC85WWtJmjzs19U
         GpWaaAhAIX6WttI7oPjscqe4u+8LCVqd7QNhBen4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, michael.chan@broadcom.com, saeedm@nvidia.com,
        tariqt@nvidia.com, andrew@lunn.ch, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 5/8] bnxt: add pause frame stats
Date:   Mon, 14 Sep 2020 17:11:56 -0700
Message-Id: <20200915001159.346469-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915001159.346469-1-kuba@kernel.org>
References: <20200915001159.346469-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These stats are already reported in ethtool -S.
Michael confirms they are equivalent to standard stats.

v2: - fix sparse warning about endian by using the macro
    - use u64 for pointer type

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index d0928334bdc8..5a65f28ef771 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1778,6 +1778,22 @@ static void bnxt_get_pauseparam(struct net_device *dev,
 	epause->tx_pause = !!(link_info->req_flow_ctrl & BNXT_LINK_PAUSE_TX);
 }
 
+static void bnxt_get_pause_stats(struct net_device *dev,
+				 struct ethtool_pause_stats *epstat)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u64 *rx, *tx;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
+		return;
+
+	rx = bp->port_stats.sw_stats;
+	tx = bp->port_stats.sw_stats + BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+
+	epstat->rx_pause_frames = BNXT_GET_RX_PORT_STATS64(rx, rx_pause_frames);
+	epstat->tx_pause_frames = BNXT_GET_TX_PORT_STATS64(tx, tx_pause_frames);
+}
+
 static int bnxt_set_pauseparam(struct net_device *dev,
 			       struct ethtool_pauseparam *epause)
 {
@@ -3645,6 +3661,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
+	.get_pause_stats	= bnxt_get_pause_stats,
 	.get_pauseparam		= bnxt_get_pauseparam,
 	.set_pauseparam		= bnxt_set_pauseparam,
 	.get_drvinfo		= bnxt_get_drvinfo,
-- 
2.26.2

