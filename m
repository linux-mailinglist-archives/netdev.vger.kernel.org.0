Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7BD1F97C0
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgFONCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:02:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:32202 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbgFONCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 09:02:17 -0400
IronPort-SDR: rpEVyYBoKGNk9LGUUZytmYIEA4dAnPNZgliRQDnvfYnonQb+mtoEQqEezs2fdqBuIbErCGvNKr
 RByVGffnc8SQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 06:01:43 -0700
IronPort-SDR: IEr0IhBJlNYC7BzNui72Ki9ZH/4BfP0X2ShqpaodjQ27tmLuqfK+/htKqewuImqRqiBggHiHbS
 VYH7ZPR3DToQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="298509543"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2020 06:01:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id AF5B8109; Mon, 15 Jun 2020 16:01:39 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH 1/4] thunderbolt: Build initial XDomain property block upon first connect
Date:   Mon, 15 Jun 2020 16:01:36 +0300
Message-Id: <20200615130139.83854-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a systems where the Thunderbolt controller is present all the time
the kernel nodename may not yet set by the userspace when the driver is
loaded. This means when another host is connected it may see the default
"(none)" hostname instead of the system real hostname.

For this reason build the initial XDomain property block only upon first
connect. This should make sure the userspace has had chance to set it up.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/xdomain.c | 94 ++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 053f918e00e8..48907853732a 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -501,6 +501,55 @@ void tb_unregister_protocol_handler(struct tb_protocol_handler *handler)
 }
 EXPORT_SYMBOL_GPL(tb_unregister_protocol_handler);
 
+static int rebuild_property_block(void)
+{
+	u32 *block, len;
+	int ret;
+
+	ret = tb_property_format_dir(xdomain_property_dir, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	len = ret;
+
+	block = kcalloc(len, sizeof(u32), GFP_KERNEL);
+	if (!block)
+		return -ENOMEM;
+
+	ret = tb_property_format_dir(xdomain_property_dir, block, len);
+	if (ret) {
+		kfree(block);
+		return ret;
+	}
+
+	kfree(xdomain_property_block);
+	xdomain_property_block = block;
+	xdomain_property_block_len = len;
+	xdomain_property_block_gen++;
+
+	return 0;
+}
+
+static void finalize_property_block(void)
+{
+	const struct tb_property *nodename;
+
+	/*
+	 * On first XDomain connection we set up the the system
+	 * nodename. This delayed here because userspace may not have it
+	 * set when the driver is first probed.
+	 */
+	mutex_lock(&xdomain_lock);
+	nodename = tb_property_find(xdomain_property_dir, "deviceid",
+				    TB_PROPERTY_TYPE_TEXT);
+	if (!nodename) {
+		tb_property_add_text(xdomain_property_dir, "deviceid",
+				     utsname()->nodename);
+		rebuild_property_block();
+	}
+	mutex_unlock(&xdomain_lock);
+}
+
 static void tb_xdp_handle_request(struct work_struct *work)
 {
 	struct xdomain_request_work *xw = container_of(work, typeof(*xw), work);
@@ -529,6 +578,8 @@ static void tb_xdp_handle_request(struct work_struct *work)
 		goto out;
 	}
 
+	finalize_property_block();
+
 	switch (pkg->type) {
 	case PROPERTIES_REQUEST:
 		ret = tb_xdp_properties_response(tb, ctl, route, sequence, uuid,
@@ -1569,35 +1620,6 @@ bool tb_xdomain_handle_request(struct tb *tb, enum tb_cfg_pkg_type type,
 	return ret > 0;
 }
 
-static int rebuild_property_block(void)
-{
-	u32 *block, len;
-	int ret;
-
-	ret = tb_property_format_dir(xdomain_property_dir, NULL, 0);
-	if (ret < 0)
-		return ret;
-
-	len = ret;
-
-	block = kcalloc(len, sizeof(u32), GFP_KERNEL);
-	if (!block)
-		return -ENOMEM;
-
-	ret = tb_property_format_dir(xdomain_property_dir, block, len);
-	if (ret) {
-		kfree(block);
-		return ret;
-	}
-
-	kfree(xdomain_property_block);
-	xdomain_property_block = block;
-	xdomain_property_block_len = len;
-	xdomain_property_block_gen++;
-
-	return 0;
-}
-
 static int update_xdomain(struct device *dev, void *data)
 {
 	struct tb_xdomain *xd;
@@ -1702,8 +1724,6 @@ EXPORT_SYMBOL_GPL(tb_unregister_property_dir);
 
 int tb_xdomain_init(void)
 {
-	int ret;
-
 	xdomain_property_dir = tb_property_create_dir(NULL);
 	if (!xdomain_property_dir)
 		return -ENOMEM;
@@ -1712,22 +1732,16 @@ int tb_xdomain_init(void)
 	 * Initialize standard set of properties without any service
 	 * directories. Those will be added by service drivers
 	 * themselves when they are loaded.
+	 *
+	 * We also add node name later when first connection is made.
 	 */
 	tb_property_add_immediate(xdomain_property_dir, "vendorid",
 				  PCI_VENDOR_ID_INTEL);
 	tb_property_add_text(xdomain_property_dir, "vendorid", "Intel Corp.");
 	tb_property_add_immediate(xdomain_property_dir, "deviceid", 0x1);
-	tb_property_add_text(xdomain_property_dir, "deviceid",
-			     utsname()->nodename);
 	tb_property_add_immediate(xdomain_property_dir, "devicerv", 0x80000100);
 
-	ret = rebuild_property_block();
-	if (ret) {
-		tb_property_free_dir(xdomain_property_dir);
-		xdomain_property_dir = NULL;
-	}
-
-	return ret;
+	return 0;
 }
 
 void tb_xdomain_exit(void)
-- 
2.27.0.rc2

