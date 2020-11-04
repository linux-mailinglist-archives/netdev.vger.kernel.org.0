Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1464E2A65BA
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKDOA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:00:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:26915 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbgKDOAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:00:40 -0500
IronPort-SDR: YnYIHzJtxFBAWtAO+qBrLeJ2uJja5WRy1Cw5iTjPDztqErsKZPD2X15Mn4LYZ/SNYFma5NvIMg
 w11dNDwnYq3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="233379916"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="233379916"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 06:00:37 -0800
IronPort-SDR: E08XnRhgs7DIt4N3u2GIuJUM9WT0vWpvjZ+hBJLS2tboRkw9HSK9CVvnRvAEMrWV2wyvUc7hZv
 jhGVm0VsyO0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="527585247"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 04 Nov 2020 06:00:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 188E989F; Wed,  4 Nov 2020 16:00:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 06/10] thunderbolt: Create debugfs directory automatically for services
Date:   Wed,  4 Nov 2020 17:00:26 +0300
Message-Id: <20201104140030.6853-7-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows service drivers to use it as parent directory if they need
to add their own debugfs entries.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/debugfs.c | 24 ++++++++++++++++++++++++
 drivers/thunderbolt/tb.h      |  4 ++++
 drivers/thunderbolt/xdomain.c |  3 +++
 include/linux/thunderbolt.h   |  4 ++++
 4 files changed, 35 insertions(+)

diff --git a/drivers/thunderbolt/debugfs.c b/drivers/thunderbolt/debugfs.c
index ed65d2b13964..a80278fc50af 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -691,6 +691,30 @@ void tb_switch_debugfs_remove(struct tb_switch *sw)
 	debugfs_remove_recursive(sw->debugfs_dir);
 }
 
+/**
+ * tb_service_debugfs_init() - Add debugfs directory for service
+ * @svc: Thunderbolt service pointer
+ *
+ * Adds debugfs directory for service.
+ */
+void tb_service_debugfs_init(struct tb_service *svc)
+{
+	svc->debugfs_dir = debugfs_create_dir(dev_name(&svc->dev),
+					      tb_debugfs_root);
+}
+
+/**
+ * tb_service_debugfs_remove() - Remove service debugfs directory
+ * @svc: Thunderbolt service pointer
+ *
+ * Removes the previously created debugfs directory for @svc.
+ */
+void tb_service_debugfs_remove(struct tb_service *svc)
+{
+	debugfs_remove(svc->debugfs_dir);
+	svc->debugfs_dir = NULL;
+}
+
 void tb_debugfs_init(void)
 {
 	tb_debugfs_root = debugfs_create_dir("thunderbolt", NULL);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index aa7e2dc66059..08af4fe642c0 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1029,11 +1029,15 @@ void tb_debugfs_init(void);
 void tb_debugfs_exit(void);
 void tb_switch_debugfs_init(struct tb_switch *sw);
 void tb_switch_debugfs_remove(struct tb_switch *sw);
+void tb_service_debugfs_init(struct tb_service *svc);
+void tb_service_debugfs_remove(struct tb_service *svc);
 #else
 static inline void tb_debugfs_init(void) { }
 static inline void tb_debugfs_exit(void) { }
 static inline void tb_switch_debugfs_init(struct tb_switch *sw) { }
 static inline void tb_switch_debugfs_remove(struct tb_switch *sw) { }
+static inline void tb_service_debugfs_init(struct tb_service *svc) { }
+static inline void tb_service_debugfs_remove(struct tb_service *svc) { }
 #endif
 
 #ifdef CONFIG_USB4_KUNIT_TEST
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 63889fbd8156..c36b29736cd0 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -777,6 +777,7 @@ static void tb_service_release(struct device *dev)
 	struct tb_service *svc = container_of(dev, struct tb_service, dev);
 	struct tb_xdomain *xd = tb_service_parent(svc);
 
+	tb_service_debugfs_remove(svc);
 	ida_simple_remove(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
@@ -891,6 +892,8 @@ static void enumerate_services(struct tb_xdomain *xd)
 		svc->dev.parent = &xd->dev;
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
+		tb_service_debugfs_init(svc);
+
 		if (device_register(&svc->dev)) {
 			put_device(&svc->dev);
 			break;
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 0a747f92847e..a844fd5d96ab 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -350,6 +350,9 @@ void tb_unregister_protocol_handler(struct tb_protocol_handler *handler);
  * @prtcvers: Protocol version from the properties directory
  * @prtcrevs: Protocol software revision from the properties directory
  * @prtcstns: Protocol settings mask from the properties directory
+ * @debugfs_dir: Pointer to the service debugfs directory. Always created
+ *		 when debugfs is enabled. Can be used by service drivers to
+ *		 add their own entries under the service.
  *
  * Each domain exposes set of services it supports as collection of
  * properties. For each service there will be one corresponding
@@ -363,6 +366,7 @@ struct tb_service {
 	u32 prtcvers;
 	u32 prtcrevs;
 	u32 prtcstns;
+	struct dentry *debugfs_dir;
 };
 
 static inline struct tb_service *tb_service_get(struct tb_service *svc)
-- 
2.28.0

