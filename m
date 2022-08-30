Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DFF5A6781
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiH3PdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiH3PdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:33:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E512F15C360;
        Tue, 30 Aug 2022 08:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661873578; x=1693409578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iB9Ag8rb7KjClRoQwLx7OZpAO0Tmt9GlD5TxK7reTV0=;
  b=gZQSyrVyM7aK41e7GkjytosovlefhUGl/R+OzBeXIdDk3vZo2caBjzMv
   anL7jMhbc2uMBtKgjDz3ZvoAkdmahGnnr9k14SWZux6Zm7BL129J4aaKq
   tLHMaTP0NOY7r6qj4AHrOoFDtps1CvSMPyWbbCGYgDzSSJ8oRn+IuxL1Q
   yIZTqIgmVpBKEHhz6JL/tl1P5hX15e5plvpG424JNN85+ZBCyEid9ms2I
   ahjnbyiGBlZ3mwJ5yYVoqYYRefhU00NwPv6COAJ5qPr8AB1KWGj3p96sw
   lEbGC419DEqYfjJ0Ilh1+laPTnuQ5Z6A1HLDjr2oWJprC83ECkKs8o5Sp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295990325"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295990325"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 08:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="715339372"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 30 Aug 2022 08:32:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 336CF174; Tue, 30 Aug 2022 18:32:51 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: [PATCH 2/5] thunderbolt: Show link type for XDomain connections too
Date:   Tue, 30 Aug 2022 18:32:47 +0300
Message-Id: <20220830153250.15496-3-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
References: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following what we do for routers already, extend this to XDomain
connections as well. This will show in sysfs whether the link is in USB4
or Thunderbolt mode.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/tb.c        | 8 ++++----
 drivers/thunderbolt/tb.h        | 2 +-
 drivers/thunderbolt/usb4.c      | 8 +++++---
 drivers/thunderbolt/usb4_port.c | 2 ++
 include/linux/thunderbolt.h     | 2 ++
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 583c22df4040..4a659cea26f7 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -200,10 +200,10 @@ static void tb_discover_tunnels(struct tb *tb)
 	}
 }
 
-static int tb_port_configure_xdomain(struct tb_port *port)
+static int tb_port_configure_xdomain(struct tb_port *port, struct tb_xdomain *xd)
 {
 	if (tb_switch_is_usb4(port->sw))
-		return usb4_port_configure_xdomain(port);
+		return usb4_port_configure_xdomain(port, xd);
 	return tb_lc_configure_xdomain(port);
 }
 
@@ -238,7 +238,7 @@ static void tb_scan_xdomain(struct tb_port *port)
 			      NULL);
 	if (xd) {
 		tb_port_at(route, sw)->xdomain = xd;
-		tb_port_configure_xdomain(port);
+		tb_port_configure_xdomain(port, xd);
 		tb_xdomain_add(xd);
 	}
 }
@@ -1544,7 +1544,7 @@ static void tb_restore_children(struct tb_switch *sw)
 
 			tb_restore_children(port->remote->sw);
 		} else if (port->xdomain) {
-			tb_port_configure_xdomain(port);
+			tb_port_configure_xdomain(port, port->xdomain);
 		}
 	}
 }
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 87aefac03d8a..6cca6b759c5f 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1186,7 +1186,7 @@ void usb4_switch_remove_ports(struct tb_switch *sw);
 int usb4_port_unlock(struct tb_port *port);
 int usb4_port_configure(struct tb_port *port);
 void usb4_port_unconfigure(struct tb_port *port);
-int usb4_port_configure_xdomain(struct tb_port *port);
+int usb4_port_configure_xdomain(struct tb_port *port, struct tb_xdomain *xd);
 void usb4_port_unconfigure_xdomain(struct tb_port *port);
 int usb4_port_router_offline(struct tb_port *port);
 int usb4_port_router_online(struct tb_port *port);
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 70036f3e37a5..4f90cd260996 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1115,12 +1115,14 @@ static int usb4_set_xdomain_configured(struct tb_port *port, bool configured)
 /**
  * usb4_port_configure_xdomain() - Configure port for XDomain
  * @port: USB4 port connected to another host
+ * @xd: XDomain that is connected to the port
  *
- * Marks the USB4 port as being connected to another host. Returns %0 in
- * success and negative errno in failure.
+ * Marks the USB4 port as being connected to another host and updates
+ * the link type. Returns %0 in success and negative errno in failure.
  */
-int usb4_port_configure_xdomain(struct tb_port *port)
+int usb4_port_configure_xdomain(struct tb_port *port, struct tb_xdomain *xd)
 {
+	xd->link_usb4 = link_is_usb4(port);
 	return usb4_set_xdomain_configured(port, true);
 }
 
diff --git a/drivers/thunderbolt/usb4_port.c b/drivers/thunderbolt/usb4_port.c
index 6b02945624ee..1a30c0a23286 100644
--- a/drivers/thunderbolt/usb4_port.c
+++ b/drivers/thunderbolt/usb4_port.c
@@ -53,6 +53,8 @@ static ssize_t link_show(struct device *dev, struct device_attribute *attr,
 		link = port->sw->link_usb4 ? "usb4" : "tbt";
 	else if (tb_port_has_remote(port))
 		link = port->remote->sw->link_usb4 ? "usb4" : "tbt";
+	else if (port->xdomain)
+		link = port->xdomain->link_usb4 ? "usb4" : "tbt";
 	else
 		link = "none";
 
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 9f442d73f3df..90cd08ab2f5d 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -187,6 +187,7 @@ void tb_unregister_property_dir(const char *key, struct tb_property_dir *dir);
  * @device_name: Name of the device (or %NULL if not known)
  * @link_speed: Speed of the link in Gb/s
  * @link_width: Width of the link (1 or 2)
+ * @link_usb4: Downstream link is USB4
  * @is_unplugged: The XDomain is unplugged
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
  *		queried first
@@ -234,6 +235,7 @@ struct tb_xdomain {
 	const char *device_name;
 	unsigned int link_speed;
 	unsigned int link_width;
+	bool link_usb4;
 	bool is_unplugged;
 	bool needs_uuid;
 	struct ida service_ids;
-- 
2.35.1

