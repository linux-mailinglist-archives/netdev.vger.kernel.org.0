Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C048640A
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403921AbfHHOLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:11:00 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41341 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389983AbfHHOKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:10:11 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 588F460010;
        Thu,  8 Aug 2019 14:10:09 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: [PATCH net-next v2 4/9] net: introduce MACsec ops and add a reference in net_device
Date:   Thu,  8 Aug 2019 16:05:55 +0200
Message-Id: <20190808140600.21477-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808140600.21477-1-antoine.tenart@bootlin.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces MACsec ops for drivers to support offloading
MACsec operations. A reference to those ops is added in net_device.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/linux/netdevice.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..59ff123d62e3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -53,6 +53,7 @@ struct netpoll_info;
 struct device;
 struct phy_device;
 struct dsa_port;
+struct macsec_context;
 
 struct sfp_bus;
 /* 802.11 specific */
@@ -910,6 +911,29 @@ struct xfrmdev_ops {
 };
 #endif
 
+#if defined(CONFIG_MACSEC)
+struct macsec_ops {
+	/* Device wide */
+	int (*mdo_dev_open)(struct macsec_context *ctx);
+	int (*mdo_dev_stop)(struct macsec_context *ctx);
+	/* SecY */
+	int (*mdo_add_secy)(struct macsec_context *ctx);
+	int (*mdo_upd_secy)(struct macsec_context *ctx);
+	int (*mdo_del_secy)(struct macsec_context *ctx);
+	/* Security channels */
+	int (*mdo_add_rxsc)(struct macsec_context *ctx);
+	int (*mdo_upd_rxsc)(struct macsec_context *ctx);
+	int (*mdo_del_rxsc)(struct macsec_context *ctx);
+	/* Security associations */
+	int (*mdo_add_rxsa)(struct macsec_context *ctx);
+	int (*mdo_upd_rxsa)(struct macsec_context *ctx);
+	int (*mdo_del_rxsa)(struct macsec_context *ctx);
+	int (*mdo_add_txsa)(struct macsec_context *ctx);
+	int (*mdo_upd_txsa)(struct macsec_context *ctx);
+	int (*mdo_del_txsa)(struct macsec_context *ctx);
+};
+#endif
+
 struct dev_ifalias {
 	struct rcu_head rcuhead;
 	char ifalias[];
@@ -1755,6 +1779,8 @@ enum netdev_priv_flags {
  *
  *	@wol_enabled:	Wake-on-LAN is enabled
  *
+ *	@macsec_ops:    MACsec offloading ops
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2036,6 +2062,11 @@ struct net_device {
 	struct lock_class_key	*qdisc_running_key;
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
2.21.0

