Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2861E26768D
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgIKX3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgIKX3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:29:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AEEF22228;
        Fri, 11 Sep 2020 23:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599866941;
        bh=9bneeZCW5YTVSRX4c5aCNZxw/UZfCUpfranS34vb+Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu5S3ILPMtwXygc+TRBj1W3FIQwfCZqixEkndg+HUxMRB/ZFc+Yjt8TkWenARc2CD
         xKuGoBglLGfuMH+JvFUq9xUDwW3B3YV2aY6DvLUHoQEztS9F3VNAFX36SaOvoBjvnv
         cQB0dmbGQpZThTbYsUrdEVT0VRJW1v4B9W1T+laU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/8] bnxt: add pause frame stats
Date:   Fri, 11 Sep 2020 16:28:50 -0700
Message-Id: <20200911232853.1072362-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911232853.1072362-1-kuba@kernel.org>
References: <20200911232853.1072362-1-kuba@kernel.org>
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

