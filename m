Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2509190FED
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgCXNYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:24:10 -0400
Received: from foss.arm.com ([217.140.110.172]:34624 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbgCXNYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A88EB113E;
        Tue, 24 Mar 2020 06:24:09 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A6893F52E;
        Tue, 24 Mar 2020 06:24:08 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 10/14] net: axienet: Add mii-tool support
Date:   Tue, 24 Mar 2020 13:23:43 +0000
Message-Id: <20200324132347.23709-11-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mii-tool is useful for debugging, and all it requires to work is to wire
up the ioctl ops function pointer.
Add this to the axienet driver to enable mii-tool.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 217f58bed2c5..dc533d7a090c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1171,6 +1171,16 @@ static void axienet_poll_controller(struct net_device *ndev)
 }
 #endif
 
+static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	struct axienet_local *lp = netdev_priv(dev);
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	return phylink_mii_ioctl(lp->phylink, rq, cmd);
+}
+
 static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_open = axienet_open,
 	.ndo_stop = axienet_stop,
@@ -1178,6 +1188,7 @@ static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
+	.ndo_do_ioctl = axienet_ioctl,
 	.ndo_set_rx_mode = axienet_set_multicast_list,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = axienet_poll_controller,
-- 
2.17.1

