Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD92AD242
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgKJJUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:20:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:23648 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbgKJJUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:20:04 -0500
IronPort-SDR: QRLqcfc18pw9WlvDT494DfsrarOyFi3H0gjjBIG1hU2Kn36D7KHjVant3+VzGpQoeW2O45jyu6
 iNZSXVAJPPlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="234110526"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="234110526"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 01:20:03 -0800
IronPort-SDR: 5eo22GK8LDiwSz4SCq2q/3H1mlF2mKTFFjCcZO1EaGfCEP2A5N5q6Tp2zzBpPiGwLX19eE3A/8
 Q+afRafzAvmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="360039274"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2020 01:20:01 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 735FA56E; Tue, 10 Nov 2020 11:19:57 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 05/10] thunderbolt: Add functions for enabling and disabling lane bonding on XDomain
Date:   Tue, 10 Nov 2020 12:19:52 +0300
Message-Id: <20201110091957.17472-6-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Isaac Hazan <isaac.hazan@intel.com>

These can be used by service drivers to enable and disable lane bonding
as needed.

Signed-off-by: Isaac Hazan <isaac.hazan@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
---
 drivers/thunderbolt/switch.c  | 24 +++++++++++--
 drivers/thunderbolt/tb.h      |  3 ++
 drivers/thunderbolt/xdomain.c | 66 +++++++++++++++++++++++++++++++++++
 include/linux/thunderbolt.h   |  2 ++
 4 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 05a360901790..cdfd8cccfe19 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -503,12 +503,13 @@ static void tb_dump_port(struct tb *tb, struct tb_regs_port_header *port)
 
 /**
  * tb_port_state() - get connectedness state of a port
+ * @port: the port to check
  *
  * The port must have a TB_CAP_PHY (i.e. it should be a real port).
  *
  * Return: Returns an enum tb_port_state on success or an error code on failure.
  */
-static int tb_port_state(struct tb_port *port)
+int tb_port_state(struct tb_port *port)
 {
 	struct tb_cap_phy phy;
 	int res;
@@ -1008,7 +1009,16 @@ static int tb_port_set_link_width(struct tb_port *port, unsigned int width)
 			     port->cap_phy + LANE_ADP_CS_1, 1);
 }
 
-static int tb_port_lane_bonding_enable(struct tb_port *port)
+/**
+ * tb_port_lane_bonding_enable() - Enable bonding on port
+ * @port: port to enable
+ *
+ * Enable bonding by setting the link width of the port and the
+ * other port in case of dual link port.
+ *
+ * Return: %0 in case of success and negative errno in case of error
+ */
+int tb_port_lane_bonding_enable(struct tb_port *port)
 {
 	int ret;
 
@@ -1038,7 +1048,15 @@ static int tb_port_lane_bonding_enable(struct tb_port *port)
 	return 0;
 }
 
-static void tb_port_lane_bonding_disable(struct tb_port *port)
+/**
+ * tb_port_lane_bonding_disable() - Disable bonding on port
+ * @port: port to disable
+ *
+ * Disable bonding by setting the link width of the port and the
+ * other port in case of dual link port.
+ *
+ */
+void tb_port_lane_bonding_disable(struct tb_port *port)
 {
 	port->dual_link_port->bonded = false;
 	port->bonded = false;
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 3a826315049e..e98d3561648d 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -863,6 +863,9 @@ struct tb_port *tb_next_port_on_path(struct tb_port *start, struct tb_port *end,
 
 int tb_port_get_link_speed(struct tb_port *port);
 int tb_port_get_link_width(struct tb_port *port);
+int tb_port_state(struct tb_port *port);
+int tb_port_lane_bonding_enable(struct tb_port *port);
+void tb_port_lane_bonding_disable(struct tb_port *port);
 
 int tb_switch_find_vse_cap(struct tb_switch *sw, enum tb_switch_vse_cap vsec);
 int tb_switch_find_cap(struct tb_switch *sw, enum tb_switch_cap cap);
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 83a315f96934..65108216bfe3 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/delay.h>
 #include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
@@ -21,6 +22,7 @@
 #define XDOMAIN_UUID_RETRIES			10
 #define XDOMAIN_PROPERTIES_RETRIES		60
 #define XDOMAIN_PROPERTIES_CHANGED_RETRIES	10
+#define XDOMAIN_BONDING_WAIT			100  /* ms */
 
 struct xdomain_request_work {
 	struct work_struct work;
@@ -1443,6 +1445,70 @@ void tb_xdomain_remove(struct tb_xdomain *xd)
 		device_unregister(&xd->dev);
 }
 
+/**
+ * tb_xdomain_lane_bonding_enable() - Enable lane bonding on XDomain
+ * @xd: XDomain connection
+ *
+ * Lane bonding is disabled by default for XDomains. This function tries
+ * to enable bonding by first enabling the port and waiting for the CL0
+ * state.
+ *
+ * Return: %0 in case of success and negative errno in case of error.
+ */
+int tb_xdomain_lane_bonding_enable(struct tb_xdomain *xd)
+{
+	struct tb_port *port;
+	int ret;
+
+	port = tb_port_at(xd->route, tb_xdomain_parent(xd));
+	if (!port->dual_link_port)
+		return -ENODEV;
+
+	ret = tb_port_enable(port->dual_link_port);
+	if (ret)
+		return ret;
+
+	ret = tb_wait_for_port(port->dual_link_port, true);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -ENOTCONN;
+
+	ret = tb_port_lane_bonding_enable(port);
+	if (ret) {
+		tb_port_warn(port, "failed to enable lane bonding\n");
+		return ret;
+	}
+
+	tb_xdomain_update_link_attributes(xd);
+
+	dev_dbg(&xd->dev, "lane bonding enabled\n");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tb_xdomain_lane_bonding_enable);
+
+/**
+ * tb_xdomain_lane_bonding_disable() - Disable lane bonding
+ * @xd: XDomain connection
+ *
+ * Lane bonding is disabled by default for XDomains. If bonding has been
+ * enabled, this function can be used to disable it.
+ */
+void tb_xdomain_lane_bonding_disable(struct tb_xdomain *xd)
+{
+	struct tb_port *port;
+
+	port = tb_port_at(xd->route, tb_xdomain_parent(xd));
+	if (port->dual_link_port) {
+		tb_port_lane_bonding_disable(port);
+		tb_port_disable(port->dual_link_port);
+		tb_xdomain_update_link_attributes(xd);
+
+		dev_dbg(&xd->dev, "lane bonding disabled\n");
+	}
+}
+EXPORT_SYMBOL_GPL(tb_xdomain_lane_bonding_disable);
+
 /**
  * tb_xdomain_enable_paths() - Enable DMA paths for XDomain connection
  * @xd: XDomain connection
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index e441af88ed77..0a747f92847e 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -247,6 +247,8 @@ struct tb_xdomain {
 	u8 depth;
 };
 
+int tb_xdomain_lane_bonding_enable(struct tb_xdomain *xd);
+void tb_xdomain_lane_bonding_disable(struct tb_xdomain *xd);
 int tb_xdomain_enable_paths(struct tb_xdomain *xd, u16 transmit_path,
 			    u16 transmit_ring, u16 receive_path,
 			    u16 receive_ring);
-- 
2.28.0

