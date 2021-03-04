Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686DD32D329
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240839AbhCDMdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:47218 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240795AbhCDMdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:17 -0500
IronPort-SDR: 1LokIG9WDc1nY/Pngc4SlwXO7RFScTUXSo7OVzryNA+iywqfFmsI1Lim5cXMhfY5sz145YVNu/
 FdQ+6TQoArdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="251444259"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="251444259"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:32 -0800
IronPort-SDR: OG4/PFjM71UZlrAoJxFahoECFI/eAaZS72wRmEHJiqfVkSbPL3u5lAxs2eN84VW3AiCw6lHEmf
 gRFV479VVxIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="368170056"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 04 Mar 2021 04:31:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 6126B39E; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 05/18] thunderbolt: Add more logging to XDomain connections
Date:   Thu,  4 Mar 2021 15:31:12 +0300
Message-Id: <20210304123125.43630-6-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the driver is pretty quiet when another host is connected
which makes debugging possible issues harder. For this reason add more
logging on debug level that can be turned on as needed.

While there log the host-to-host connection on info level analogous to
routers and retimers.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/xdomain.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 7cf8b9c85ab7..584bb5ec06f8 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -591,6 +591,8 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
 	finalize_property_block();
 
+	tb_dbg(tb, "%llx: received XDomain request %#x\n", route, pkg->type);
+
 	switch (pkg->type) {
 	case PROPERTIES_REQUEST:
 		ret = tb_xdp_properties_response(tb, ctl, route, sequence, uuid,
@@ -1002,9 +1004,12 @@ static void tb_xdomain_get_uuid(struct work_struct *work)
 	uuid_t uuid;
 	int ret;
 
+	dev_dbg(&xd->dev, "requesting remote UUID\n");
+
 	ret = tb_xdp_uuid_request(tb->ctl, xd->route, xd->uuid_retries, &uuid);
 	if (ret < 0) {
 		if (xd->uuid_retries-- > 0) {
+			dev_dbg(&xd->dev, "failed to request UUID, retrying\n");
 			queue_delayed_work(xd->tb->wq, &xd->get_uuid_work,
 					   msecs_to_jiffies(100));
 		} else {
@@ -1013,6 +1018,8 @@ static void tb_xdomain_get_uuid(struct work_struct *work)
 		return;
 	}
 
+	dev_dbg(&xd->dev, "got remote UUID %pUb\n", &uuid);
+
 	if (uuid_equal(&uuid, xd->local_uuid))
 		dev_dbg(&xd->dev, "intra-domain loop detected\n");
 
@@ -1052,11 +1059,15 @@ static void tb_xdomain_get_properties(struct work_struct *work)
 	u32 gen = 0;
 	int ret;
 
+	dev_dbg(&xd->dev, "requesting remote properties\n");
+
 	ret = tb_xdp_properties_request(tb->ctl, xd->route, xd->local_uuid,
 					xd->remote_uuid, xd->properties_retries,
 					&block, &gen);
 	if (ret < 0) {
 		if (xd->properties_retries-- > 0) {
+			dev_dbg(&xd->dev,
+				"failed to request remote properties, retrying\n");
 			queue_delayed_work(xd->tb->wq, &xd->get_properties_work,
 					   msecs_to_jiffies(1000));
 		} else {
@@ -1123,6 +1134,11 @@ static void tb_xdomain_get_properties(struct work_struct *work)
 			dev_err(&xd->dev, "failed to add XDomain device\n");
 			return;
 		}
+		dev_info(&xd->dev, "new host found, vendor=%#x device=%#x\n",
+			 xd->vendor, xd->device);
+		if (xd->vendor_name && xd->device_name)
+			dev_info(&xd->dev, "%s %s\n", xd->vendor_name,
+				 xd->device_name);
 	} else {
 		kobject_uevent(&xd->dev.kobj, KOBJ_CHANGE);
 	}
@@ -1143,13 +1159,19 @@ static void tb_xdomain_properties_changed(struct work_struct *work)
 					     properties_changed_work.work);
 	int ret;
 
+	dev_dbg(&xd->dev, "sending properties changed notification\n");
+
 	ret = tb_xdp_properties_changed_request(xd->tb->ctl, xd->route,
 				xd->properties_changed_retries, xd->local_uuid);
 	if (ret) {
-		if (xd->properties_changed_retries-- > 0)
+		if (xd->properties_changed_retries-- > 0) {
+			dev_dbg(&xd->dev,
+				"failed to send properties changed notification, retrying\n");
 			queue_delayed_work(xd->tb->wq,
 					   &xd->properties_changed_work,
 					   msecs_to_jiffies(1000));
+		}
+		dev_err(&xd->dev, "failed to send properties changed notification\n");
 		return;
 	}
 
@@ -1390,6 +1412,10 @@ struct tb_xdomain *tb_xdomain_alloc(struct tb *tb, struct device *parent,
 	xd->dev.groups = xdomain_attr_groups;
 	dev_set_name(&xd->dev, "%u-%llx", tb->index, route);
 
+	dev_dbg(&xd->dev, "local UUID %pUb\n", local_uuid);
+	if (remote_uuid)
+		dev_dbg(&xd->dev, "remote UUID %pUb\n", remote_uuid);
+
 	/*
 	 * This keeps the DMA powered on as long as we have active
 	 * connection to another host.
@@ -1452,10 +1478,12 @@ void tb_xdomain_remove(struct tb_xdomain *xd)
 	pm_runtime_put_noidle(&xd->dev);
 	pm_runtime_set_suspended(&xd->dev);
 
-	if (!device_is_registered(&xd->dev))
+	if (!device_is_registered(&xd->dev)) {
 		put_device(&xd->dev);
-	else
+	} else {
+		dev_info(&xd->dev, "host disconnected\n");
 		device_unregister(&xd->dev);
+	}
 }
 
 /**
-- 
2.30.1

