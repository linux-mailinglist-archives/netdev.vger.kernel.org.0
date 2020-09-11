Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D6C26693A
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgIKTxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgIKTxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 15:53:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44DE622208;
        Fri, 11 Sep 2020 19:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599853990;
        bh=CJ+BXJPTbN4lhPKNUzvHIFumfm0QMWddISQa1PlaLdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pv3PgLlp42c/v+jClJZHtibmGKu9GVNlotYCd/yUOeQBrOP4AnUNPSuYfIPQ98xbd
         vVbTCQedHyjFiHwHkfQmjeSN2i3nKXY9sSAURPtN/MlPjeOwVzqPNzECPnd74PK1FC
         RGf5QtzAKwWNe/s4/xrRl9+73jY0UgyGlCAcmZ5Y=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 7/8] ixgbe: add pause frame stats
Date:   Fri, 11 Sep 2020 12:52:57 -0700
Message-Id: <20200911195258.1048468-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911195258.1048468-1-kuba@kernel.org>
References: <20200911195258.1048468-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report standard pause frame stats. They are already aggregated
in struct ixgbe_hw_stats.

The combination of the registers is suggested as equivalent to
PAUSEMACCtrlFramesTransmitted / PAUSEMACCtrlFramesReceived
by the Intel 82576EB datasheet, I could not find any information
in the HW actually supported by ixgbe.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 71ec908266a6..a280aa34ca1d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -531,6 +531,16 @@ static int ixgbe_set_link_ksettings(struct net_device *netdev,
 	return err;
 }
 
+static void ixgbe_get_pause_stats(struct net_device *netdev,
+				  struct ethtool_pause_stats *stats)
+{
+	struct ixgbe_adapter *adapter = netdev_priv(netdev);
+	struct ixgbe_hw_stats *hwstats = &adapter->stats;
+
+	stats->tx_pause_frames = hwstats->lxontxc + hwstats->lxofftxc;
+	stats->rx_pause_frames = hwstats->lxonrxc + hwstats->lxoffrxc;
+}
+
 static void ixgbe_get_pauseparam(struct net_device *netdev,
 				 struct ethtool_pauseparam *pause)
 {
@@ -3546,6 +3556,7 @@ static const struct ethtool_ops ixgbe_ethtool_ops = {
 	.set_eeprom             = ixgbe_set_eeprom,
 	.get_ringparam          = ixgbe_get_ringparam,
 	.set_ringparam          = ixgbe_set_ringparam,
+	.get_pause_stats	= ixgbe_get_pause_stats,
 	.get_pauseparam         = ixgbe_get_pauseparam,
 	.set_pauseparam         = ixgbe_set_pauseparam,
 	.get_msglevel           = ixgbe_get_msglevel,
-- 
2.26.2

