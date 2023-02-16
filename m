Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5C869941F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBPMQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjBPMQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:16:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D2F2940C
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676549792; x=1708085792;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=INrjCERKZzgwGLUB87PCS7hHK855KoGgEtbkeoZCZ+g=;
  b=nWPPo9tlC1z/suIa6taQD0lRm1i5vzYhLh0sJnCEv1z2re6qWEkJvuhm
   gHpnEeXW2A3Uvg0Mr+KkCP6gpAh4shSbrd5xXCfDSsd9waV7sjRz4OUbT
   rMSVxExSd3HwpULjJymnY8SG/+qYUH8Katg0tR/WlXyntL0kqwxcopkKf
   If3OFbatA/iexZE/VD0KwwkuQTihmsqExdYGK0bbUEdAMQXJrCGJlJwOf
   nq66iKvtN1hrkp3CpotNJoo2ITvd7Xnhewb8aiIGqh/jYbsb2BCn1cBwo
   yZfMU7MmUBw6mUpbfvWQfRre4khimpDi+hKC3roJD8l47evz1mQ+g8YX8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="333871576"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333871576"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 04:16:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="733849525"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733849525"
Received: from unknown (HELO localhost.igk.intel.com) ([10.211.0.37])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 04:16:30 -0800
From:   "Temerkhanov, Sergey" <sergey.temerkhanov@intel.com>
To:     netdev@vger.kernel.org
Cc:     Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Subject: [PATCH net-next] auxiliary: Implement refcounting
Date:   Thu, 16 Feb 2023 13:16:21 +0100
Message-Id: <20230216121621.37063-1-sergey.temerkhanov@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>

Implement reference counting to make it possible to synchronize
deinitialization and removal of interfaces published via aux bus
with the client modules.
Reference counting can be used in both sleeping and non-sleeping
contexts so this approach is intended to replace device_lock()
(mutex acquisition) with an additional lock on top of it
which is not always possible to take in client code.

Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
---
 drivers/base/auxiliary.c      | 18 ++++++++++++++++++
 include/linux/auxiliary_bus.h | 34 +++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index 8c5e65930617..082b3ebd143d 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -287,10 +287,28 @@ int auxiliary_device_init(struct auxiliary_device *auxdev)
 
 	dev->bus = &auxiliary_bus_type;
 	device_initialize(&auxdev->dev);
+	init_waitqueue_head(&auxdev->wq_head);
+	refcount_set(&auxdev->refcnt, 1);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(auxiliary_device_init);
 
+void auxiliary_device_uninit(struct auxiliary_device *auxdev)
+{
+	wait_event_interruptible(auxdev->wq_head,
+				 refcount_dec_if_one(&auxdev->refcnt));
+}
+EXPORT_SYMBOL_GPL(auxiliary_device_uninit);
+
+void auxiliary_device_delete(struct auxiliary_device *auxdev)
+{
+	WARN_ON(refcount_read(&auxdev->refcnt));
+
+	device_del(&auxdev->dev);
+}
+EXPORT_SYMBOL_GPL(auxiliary_device_delete);
+
 /**
  * __auxiliary_device_add - add an auxiliary bus device
  * @auxdev: auxiliary bus device to add to the bus
diff --git a/include/linux/auxiliary_bus.h b/include/linux/auxiliary_bus.h
index de21d9d24a95..0610ccee320e 100644
--- a/include/linux/auxiliary_bus.h
+++ b/include/linux/auxiliary_bus.h
@@ -10,6 +10,8 @@
 
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/wait.h>
+#include <linux/refcount.h>
 
 /**
  * DOC: DEVICE_LIFESPAN
@@ -137,7 +139,9 @@
  */
 struct auxiliary_device {
 	struct device dev;
+	refcount_t refcnt;
 	const char *name;
+	struct wait_queue_head wq_head;
 	u32 id;
 };
 
@@ -198,6 +202,25 @@ static inline void auxiliary_set_drvdata(struct auxiliary_device *auxdev, void *
 	dev_set_drvdata(&auxdev->dev, data);
 }
 
+static inline bool __must_check
+auxiliary_device_get(struct auxiliary_device *adev)
+{
+	if (!adev)
+		return false;
+
+	return refcount_inc_not_zero(&adev->refcnt);
+}
+
+static inline void auxiliary_device_put(struct auxiliary_device *adev)
+{
+	if (!adev)
+		return;
+
+	refcount_dec(&adev->refcnt);
+
+	wake_up_interruptible(&adev->wq_head);
+}
+
 static inline struct auxiliary_device *to_auxiliary_dev(struct device *dev)
 {
 	return container_of(dev, struct auxiliary_device, dev);
@@ -212,15 +235,8 @@ int auxiliary_device_init(struct auxiliary_device *auxdev);
 int __auxiliary_device_add(struct auxiliary_device *auxdev, const char *modname);
 #define auxiliary_device_add(auxdev) __auxiliary_device_add(auxdev, KBUILD_MODNAME)
 
-static inline void auxiliary_device_uninit(struct auxiliary_device *auxdev)
-{
-	put_device(&auxdev->dev);
-}
-
-static inline void auxiliary_device_delete(struct auxiliary_device *auxdev)
-{
-	device_del(&auxdev->dev);
-}
+void auxiliary_device_uninit(struct auxiliary_device *auxdev);
+void auxiliary_device_delete(struct auxiliary_device *auxdev);
 
 int __auxiliary_driver_register(struct auxiliary_driver *auxdrv, struct module *owner,
 				const char *modname);
-- 
2.35.3

