Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A256D2AD251
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbgKJJUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:20:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:25391 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbgKJJUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:20:04 -0500
IronPort-SDR: +RsYiMaDR7V2l1CYZHWRNX7+qeFT2gbPzGvjnuMcJJbf+mQTJrbK5O3cJEuYJoMjIwNLPeLI6M
 RUDStWmPQtfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="169160559"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="169160559"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 01:20:03 -0800
IronPort-SDR: 6xDOf5lHIbvfqoQiGZzOWvt70OPWS0XNL0bauX8LRe0IHyD3hgksuWj5UFV4j8dYL38qNoVtJG
 HDGpHemAy1Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="356068336"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 10 Nov 2020 01:20:01 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 7BA9B44A; Tue, 10 Nov 2020 11:19:57 +0200 (EET)
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
Subject: [PATCH v2 06/10] thunderbolt: Create debugfs directory automatically for services
Date:   Tue, 10 Nov 2020 12:19:53 +0300
Message-Id: <20201110091957.17472-7-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows service drivers to use it as parent directory if they need
to add their own debugfs entries.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
---
 drivers/thunderbolt/debugfs.c | 24 ++++++++++++++++++++++++
 drivers/thunderbolt/tb.h      |  4 ++++
 drivers/thunderbolt/xdomain.c |  3 +++
 include/linux/thunderbolt.h   |  4 ++++
 4 files changed, 35 insertions(+)

diff --git a/drivers/thunderbolt/debugfs.c b/drivers/thunderbolt/debugfs.c
index 3680b2784ea1..e53ca8270acd 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -690,6 +690,30 @@ void tb_switch_debugfs_remove(struct tb_switch *sw)
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
+	debugfs_remove_recursive(svc->debugfs_dir);
+	svc->debugfs_dir = NULL;
+}
+
 void tb_debugfs_init(void)
 {
 	tb_debugfs_root = debugfs_create_dir("thunderbolt", NULL);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index e98d3561648d..a21000649009 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1027,11 +1027,15 @@ void tb_debugfs_init(void);
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
index 65108216bfe3..1a0491b461fd 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -779,6 +779,7 @@ static void tb_service_release(struct device *dev)
 	struct tb_service *svc = container_of(dev, struct tb_service, dev);
 	struct tb_xdomain *xd = tb_service_parent(svc);
 
+	tb_service_debugfs_remove(svc);
 	ida_simple_remove(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
@@ -892,6 +893,8 @@ static void enumerate_services(struct tb_xdomain *xd)
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

