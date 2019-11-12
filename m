Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28450F9B97
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfKLVMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:12:32 -0500
Received: from orthanc.universe-factory.net ([104.238.176.138]:40928 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726936AbfKLVMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:12:32 -0500
Received: from localhost.localdomain (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id 9BB231F570;
        Tue, 12 Nov 2019 22:12:30 +0100 (CET)
From:   Matthias Schiffer <mschiffer@universe-factory.net>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCH net-next v2 2/2] bridge: implement get_link_ksettings ethtool method
Date:   Tue, 12 Nov 2019 22:12:25 +0100
Message-Id: <fc58a0e14bb27737cfbf0c6e0d49a734ec1ec6e4.1573591594.git.mschiffer@universe-factory.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1573591594.git.mschiffer@universe-factory.net>
References: <cover.1573591594.git.mschiffer@universe-factory.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We return the maximum speed of all active ports. This matches how the link
speed would give an upper limit for traffic to/from any single peer if the
bridge were replaced with a hardware switch.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
v2: code style

 net/bridge/br_device.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index e804a3016902..434effde02c3 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -263,6 +263,37 @@ static void br_getinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	strlcpy(info->bus_info, "N/A", sizeof(info->bus_info));
 }
 
+static int br_get_link_ksettings(struct net_device *dev,
+				 struct ethtool_link_ksettings *cmd)
+{
+	struct net_bridge *br = netdev_priv(dev);
+	struct net_bridge_port *p;
+
+	cmd->base.duplex = DUPLEX_UNKNOWN;
+	cmd->base.port = PORT_OTHER;
+	cmd->base.speed = SPEED_UNKNOWN;
+
+	list_for_each_entry(p, &br->port_list, list) {
+		struct ethtool_link_ksettings ecmd;
+		struct net_device *pdev = p->dev;
+
+		if (!netif_running(pdev) || !netif_oper_up(pdev))
+			continue;
+
+		if (__ethtool_get_link_ksettings(pdev, &ecmd))
+			continue;
+
+		if (ecmd.base.speed == (__u32)SPEED_UNKNOWN)
+			continue;
+
+		if (cmd->base.speed == (__u32)SPEED_UNKNOWN ||
+		    cmd->base.speed < ecmd.base.speed)
+			cmd->base.speed = ecmd.base.speed;
+	}
+
+	return 0;
+}
+
 static netdev_features_t br_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
@@ -365,8 +396,9 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
 }
 
 static const struct ethtool_ops br_ethtool_ops = {
-	.get_drvinfo    = br_getinfo,
-	.get_link	= ethtool_op_get_link,
+	.get_drvinfo		 = br_getinfo,
+	.get_link		 = ethtool_op_get_link,
+	.get_link_ksettings	 = br_get_link_ksettings,
 };
 
 static const struct net_device_ops br_netdev_ops = {
-- 
2.24.0

