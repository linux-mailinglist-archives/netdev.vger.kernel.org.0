Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E163F122B94
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfLQMdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:33:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:46891 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbfLQMdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 07:33:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 04:33:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="247452539"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 17 Dec 2019 04:33:46 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 7407472; Tue, 17 Dec 2019 14:33:45 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/9] thunderbolt: Make tb_find_port() available to other files
Date:   Tue, 17 Dec 2019 15:33:37 +0300
Message-Id: <20191217123345.31850-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will be needing this when adding initial USB4 support so make it
available to other files in the driver as well. We also rename it to
tb_switch_find_port() to follow conventions used in switch.c.

No functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/switch.c | 18 ++++++++++++++++++
 drivers/thunderbolt/tb.c     | 22 ++--------------------
 drivers/thunderbolt/tb.h     |  2 ++
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index ca86a8e09c77..9c72521cb298 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2517,6 +2517,24 @@ struct tb_switch *tb_switch_find_by_route(struct tb *tb, u64 route)
 	return NULL;
 }
 
+/**
+ * tb_switch_find_port() - return the first port of @type on @sw or NULL
+ * @sw: Switch to find the port from
+ * @type: Port type to look for
+ */
+struct tb_port *tb_switch_find_port(struct tb_switch *sw,
+				    enum tb_port_type type)
+{
+	struct tb_port *port;
+
+	tb_switch_for_each_port(sw, port) {
+		if (port->config.type == type)
+			return port;
+	}
+
+	return NULL;
+}
+
 void tb_switch_exit(void)
 {
 	ida_destroy(&nvm_ida);
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index ea8727f769d6..54085f67810a 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -338,24 +338,6 @@ static void tb_free_unplugged_children(struct tb_switch *sw)
 	}
 }
 
-/**
- * tb_find_port() - return the first port of @type on @sw or NULL
- * @sw: Switch to find the port from
- * @type: Port type to look for
- */
-static struct tb_port *tb_find_port(struct tb_switch *sw,
-				    enum tb_port_type type)
-{
-	struct tb_port *port;
-
-	tb_switch_for_each_port(sw, port) {
-		if (port->config.type == type)
-			return port;
-	}
-
-	return NULL;
-}
-
 /**
  * tb_find_unused_port() - return the first inactive port on @sw
  * @sw: Switch to find the port on
@@ -586,7 +568,7 @@ static int tb_tunnel_pci(struct tb *tb, struct tb_switch *sw)
 	struct tb_switch *parent_sw;
 	struct tb_tunnel *tunnel;
 
-	up = tb_find_port(sw, TB_TYPE_PCIE_UP);
+	up = tb_switch_find_port(sw, TB_TYPE_PCIE_UP);
 	if (!up)
 		return 0;
 
@@ -624,7 +606,7 @@ static int tb_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd)
 
 	sw = tb_to_switch(xd->dev.parent);
 	dst_port = tb_port_at(xd->route, sw);
-	nhi_port = tb_find_port(tb->root_switch, TB_TYPE_NHI);
+	nhi_port = tb_switch_find_port(tb->root_switch, TB_TYPE_NHI);
 
 	mutex_lock(&tb->lock);
 	tunnel = tb_tunnel_alloc_dma(tb, nhi_port, dst_port, xd->transmit_ring,
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index ec851f20c571..ade1c7c77db1 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -533,6 +533,8 @@ void tb_switch_suspend(struct tb_switch *sw);
 int tb_switch_resume(struct tb_switch *sw);
 int tb_switch_reset(struct tb *tb, u64 route);
 void tb_sw_set_unplugged(struct tb_switch *sw);
+struct tb_port *tb_switch_find_port(struct tb_switch *sw,
+				    enum tb_port_type type);
 struct tb_switch *tb_switch_find_by_link_depth(struct tb *tb, u8 link,
 					       u8 depth);
 struct tb_switch *tb_switch_find_by_uuid(struct tb *tb, const uuid_t *uuid);
-- 
2.24.0

