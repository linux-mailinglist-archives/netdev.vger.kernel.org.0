Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0494B15FA6A
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgBNXXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:23:15 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:17213 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbgBNXXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:23:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581722593; x=1613258593;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=j3Iz4zet15tTZehEn1q0m7zvUCktveIQzobSO7Tbh5A=;
  b=h8uRaeIRKXw3Vk0FQN9W2P2da1CbF74prdqapqBbBhtVYsC9992I310a
   wMJxPCwkWnUFYYSZK2nbw+nIlxOYkv9nRXm2y0USMZpaa4MyhhAioNI6T
   Arg+49/vtVUWGQJULIGbSS+5QZLrLpIfu9yzt2e30izmohytApurhIg4o
   8=;
IronPort-SDR: XqbB6njxZYLKkIjkrKS2XRIKw7AMuDayPVSyoFyViFpl0hxCLi0sqh45jyTtWEAAW59D1maMOt
 C5x6jnIh1OpA==
X-IronPort-AV: E=Sophos;i="5.70,442,1574121600"; 
   d="scan'208";a="25191815"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 14 Feb 2020 23:23:11 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 48800A2065;
        Fri, 14 Feb 2020 23:23:09 +0000 (UTC)
Received: from EX13D10UWA002.ant.amazon.com (10.43.160.228) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:23:01 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA002.ant.amazon.com (10.43.160.228) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:23:00 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Fri, 14 Feb 2020 23:23:00 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id E28634028E; Fri, 14 Feb 2020 23:23:00 +0000 (UTC)
Date:   Fri, 14 Feb 2020 23:23:00 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <fllinden@amaozn.com>, <benh@kernel.crashing.org>
Subject: [RFC PATCH v3 02/12] xenbus: add freeze/thaw/restore callbacks
 support
Message-ID: <4693a477cca9a4f56ec369853b7cf982aaf30e7e.1581721799.git.anchalag@amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1581721799.git.anchalag@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Since commit b3e96c0c7562 ("xen: use freeze/restore/thaw PM events for
suspend/resume/chkpt"), xenbus uses PMSG_FREEZE, PMSG_THAW and
PMSG_RESTORE events for Xen suspend. However, they're actually assigned
to xenbus_dev_suspend(), xenbus_dev_cancel() and xenbus_dev_resume()
respectively, and only suspend and resume callbacks are supported at
driver level. To support PM suspend and PM hibernation, modify the bus
level PM callbacks to invoke not only device driver's suspend/resume but
also freeze/thaw/restore.

Note that we'll use freeze/restore callbacks even for PM suspend whereas
suspend/resume callbacks are normally used in the case, becausae the
existing xenbus device drivers already have suspend/resume callbacks
specifically designed for Xen suspend. So we can allow the device
drivers to keep the existing callbacks wihtout modification.

[Anchal Changelog: Refactored the callbacks code]
Signed-off-by: Agarwal Anchal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 drivers/xen/xenbus/xenbus_probe.c | 99 +++++++++++++++++++++++++------
 include/xen/xenbus.h              |  3 +
 2 files changed, 84 insertions(+), 18 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 5b471889d723..0fa8eeee68c2 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -49,6 +49,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/suspend.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -597,27 +598,44 @@ int xenbus_dev_suspend(struct device *dev)
 	struct xenbus_driver *drv;
 	struct xenbus_device *xdev
 		= container_of(dev, struct xenbus_device, dev);
-
+	bool xen_suspend = xen_suspend_mode_is_xen_suspend();
 	DPRINTK("%s", xdev->nodename);
 
 	if (dev->driver == NULL)
 		return 0;
 	drv = to_xenbus_driver(dev->driver);
-	if (drv->suspend)
-		err = drv->suspend(xdev);
-	if (err)
-		pr_warn("suspend %s failed: %i\n", dev_name(dev), err);
+
+	if (xen_suspend) {
+		if (drv->suspend)
+			err = drv->suspend(xdev);
+	} else {
+		if (drv->freeze) {
+			err = drv->freeze(xdev);
+			if (!err) {
+				free_otherend_watch(xdev);
+				free_otherend_details(xdev);
+				return 0;
+			}
+		}
+	}
+
+	if (err) {
+		pr_warn("%s %s failed: %i\n", xen_suspend ?
+			"suspend" : "freeze", dev_name(dev), err);
+		return err;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_suspend);
 
 int xenbus_dev_resume(struct device *dev)
 {
-	int err;
+	int err = 0;
 	struct xenbus_driver *drv;
 	struct xenbus_device *xdev
 		= container_of(dev, struct xenbus_device, dev);
-
+	bool xen_suspend = xen_suspend_mode_is_xen_suspend();
 	DPRINTK("%s", xdev->nodename);
 
 	if (dev->driver == NULL)
@@ -625,24 +643,32 @@ int xenbus_dev_resume(struct device *dev)
 	drv = to_xenbus_driver(dev->driver);
 	err = talk_to_otherend(xdev);
 	if (err) {
-		pr_warn("resume (talk_to_otherend) %s failed: %i\n",
+		pr_warn("%s (talk_to_otherend) %s failed: %i\n",
+			xen_suspend ? "resume" : "restore",
 			dev_name(dev), err);
 		return err;
 	}
 
-	xdev->state = XenbusStateInitialising;
+	if (xen_suspend) {
+		xdev->state = XenbusStateInitialising;
+		if (drv->resume)
+			err = drv->resume(xdev);
+	} else {
+		if (drv->restore)
+			err = drv->restore(xdev);
+	}
 
-	if (drv->resume) {
-		err = drv->resume(xdev);
-		if (err) {
-			pr_warn("resume %s failed: %i\n", dev_name(dev), err);
-			return err;
-		}
+	if (err) {
+		pr_warn("%s %s failed: %i\n",
+			xen_suspend ? "resume" : "restore",
+			dev_name(dev), err);
+		return err;
 	}
 
 	err = watch_otherend(xdev);
 	if (err) {
-		pr_warn("resume (watch_otherend) %s failed: %d.\n",
+		pr_warn("%s (watch_otherend) %s failed: %d.\n",
+			xen_suspend ? "resume" : "restore",
 			dev_name(dev), err);
 		return err;
 	}
@@ -653,8 +679,45 @@ EXPORT_SYMBOL_GPL(xenbus_dev_resume);
 
 int xenbus_dev_cancel(struct device *dev)
 {
-	/* Do nothing */
-	DPRINTK("cancel");
+	int err = 0;
+	struct xenbus_driver *drv;
+	struct xenbus_device *xdev
+		= container_of(dev, struct xenbus_device, dev);
+	bool xen_suspend = xen_suspend_mode_is_xen_suspend();
+
+	if (xen_suspend) {
+		/* Do nothing */
+		DPRINTK("cancel");
+		return 0;
+	}
+
+	DPRINTK("%s", xdev->nodename);
+
+	if (dev->driver == NULL)
+		return 0;
+	drv = to_xenbus_driver(dev->driver);
+	err = talk_to_otherend(xdev);
+	if (err) {
+		pr_warn("thaw (talk_to_otherend) %s failed: %d.\n",
+			dev_name(dev), err);
+		return err;
+	}
+
+	if (drv->thaw) {
+		err = drv->thaw(xdev);
+		if (err) {
+			pr_warn("thaw %s failed: %i\n", dev_name(dev), err);
+			return err;
+		}
+	}
+
+	err = watch_otherend(xdev);
+	if (err) {
+		pr_warn("thaw (watch_otherend) %s failed: %d.\n",
+			dev_name(dev), err);
+		return err;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_cancel);
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 869c816d5f8c..20261d5f4e78 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -100,6 +100,9 @@ struct xenbus_driver {
 	int (*remove)(struct xenbus_device *dev);
 	int (*suspend)(struct xenbus_device *dev);
 	int (*resume)(struct xenbus_device *dev);
+	int (*freeze)(struct xenbus_device *dev);
+	int (*thaw)(struct xenbus_device *dev);
+	int (*restore)(struct xenbus_device *dev);
 	int (*uevent)(struct xenbus_device *, struct kobj_uevent_env *);
 	struct device_driver driver;
 	int (*read_otherend_details)(struct xenbus_device *dev);
-- 
2.24.1.AMZN

