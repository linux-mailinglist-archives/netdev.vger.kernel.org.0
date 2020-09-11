Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C6926693B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgIKTxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIKTxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 15:53:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 379AE2220F;
        Fri, 11 Sep 2020 19:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599853989;
        bh=9mnPGUv9uaaxuD+AUwBraGGLo2itRuGs+sBhGxoa66k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otMWIVdEZ5t7BCurqde2Q2KuPDgPURvWJWgUPkBuXhmj6Sl5BwqpInLHAeoO9NeJD
         dKb7qMGkunGa4ete85Rc4onHcgnxTuO273vX4i4hWcdNfHYqhH7iJSy+2evQlaA9Y5
         qcYmmyRz7UzqIj38s/q5Y1pMB31c1wO5X6JK9HaQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/8] bnxt: add pause frame stats
Date:   Fri, 11 Sep 2020 12:52:55 -0700
Message-Id: <20200911195258.1048468-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911195258.1048468-1-kuba@kernel.org>
References: <20200911195258.1048468-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These stats are already reported in ethtool -S.
Hopefully they are equivalent to standard stats?

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index d0928334bdc8..b5de242766e3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1778,6 +1778,24 @@ static void bnxt_get_pauseparam(struct net_device *dev,
 	epause->tx_pause = !!(link_info->req_flow_ctrl & BNXT_LINK_PAUSE_TX);
 }
 
+static void bnxt_get_pause_stats(struct net_device *dev,
+				 struct ethtool_pause_stats *epstat)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	struct rx_port_stats *rx_stats;
+	struct tx_port_stats *tx_stats;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
+		return;
+
+	rx_stats = (void *)bp->port_stats.sw_stats;
+	tx_stats = (void *)((unsigned long)bp->port_stats.sw_stats +
+			    BNXT_TX_PORT_STATS_BYTE_OFFSET);
+
+	epstat->rx_pause_frames = rx_stats->rx_pause_frames;
+	epstat->tx_pause_frames = tx_stats->tx_pause_frames;
+}
+
 static int bnxt_set_pauseparam(struct net_device *dev,
 			       struct ethtool_pauseparam *epause)
 {
@@ -3645,6 +3663,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
+	.get_pause_stats	= bnxt_get_pause_stats,
 	.get_pauseparam		= bnxt_get_pauseparam,
 	.set_pauseparam		= bnxt_set_pauseparam,
 	.get_drvinfo		= bnxt_get_drvinfo,
-- 
2.26.2

