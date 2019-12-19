Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1150E126049
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfLSLAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:00:36 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:36421 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfLSLAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:35 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 73A5F1BF212;
        Thu, 19 Dec 2019 11:00:32 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 13/15] net: add a reference to MACsec ops in net_device
Date:   Thu, 19 Dec 2019 11:55:13 +0100
Message-Id: <20191219105515.78400-14-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219105515.78400-1-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a reference to MACsec ops to the net_device structure,
allowing net device drivers to implement offloading operations for
MACsec.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/linux/netdevice.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7a8ed11f5d45..2320105ae8ac 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -53,6 +53,8 @@ struct netpoll_info;
 struct device;
 struct phy_device;
 struct dsa_port;
+struct macsec_context;
+struct macsec_ops;
 
 struct sfp_bus;
 /* 802.11 specific */
@@ -1790,6 +1792,8 @@ enum netdev_priv_flags {
  *
  *	@wol_enabled:	Wake-on-LAN is enabled
  *
+ *	@macsec_ops:    MACsec offloading ops
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2080,6 +2084,11 @@ struct net_device {
 	struct lock_class_key	addr_list_lock_key;
 	bool			proto_down;
 	unsigned		wol_enabled:1;
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* MACsec management functions */
+	const struct macsec_ops *macsec_ops;
+#endif
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
-- 
2.24.1

