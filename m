Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE61C212C50
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 20:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgGBS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 14:26:01 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:17004 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgGBS0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 14:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593714360; x=1625250360;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=jLJQ9NuVygNNRcAPap0ICuY1A6zLkRPc2aHxxOZMLNc=;
  b=Bn04Gr3BvCal+J+zvGCbb48FgninblZOYSr/Qt1aYgQ5Nx5T/oQTfegb
   bK8rj3X+OpNHAPDrR1p7VC0yAegLkvWTtoEO5LIoWb+SMrs0Mxfw0oB5n
   tC5WGmyGyWE/Xk8fQhhzMauX7TQaiTlzzB8NRtUk/HPDwbOxjovpOsZQ4
   w=;
IronPort-SDR: 9K0UaovTj6pXWTvQUqHP8tf1CyImeNnAp5dgeU8Ek2iag7xWzdGj816eXt/y4qO4q0g3EatLKK
 YauVToN5kJOg==
X-IronPort-AV: E=Sophos;i="5.75,305,1589241600"; 
   d="scan'208";a="55693820"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jul 2020 18:25:57 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 2B3EAA1FEE;
        Thu,  2 Jul 2020 18:25:49 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:25:30 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:25:30 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 2 Jul 2020 18:25:29 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id E9DAC40844; Thu,  2 Jul 2020 18:25:29 +0000 (UTC)
Date:   Thu, 2 Jul 2020 18:25:29 +0000
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
        <benh@kernel.crashing.org>
Subject: [PATCH v2 02/11] xenbus: add freeze/thaw/restore callbacks support
Message-ID: <20200702182529.GA3908@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1593665947.git.anchalag@amazon.com>
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

[Anchal Agarwal: Changelog]:
RFC v1->v2: Refactored the callbacks code
    v1->v2: Use dev_warn instead of pr_warn, naming/initialization
            conventions
Signed-off-by: Agarwal Anchal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 drivers/xen/xenbus/xenbus_probe.c | 96 ++++++++++++++++++++++++++-----
 include/xen/xenbus.h              |  3 +
 2 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 38725d97d909..715919aacd28 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -50,6 +50,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/suspend.h>
 
 #include <asm/page.h>
 #include <asm/xen/hypervisor.h>
@@ -599,16 +600,33 @@ int xenbus_dev_suspend(struct device *dev)
 	struct xenbus_driver *drv;
 	struct xenbus_device *xdev
 		= container_of(dev, struct xenbus_device, dev);
+	bool xen_suspend = xen_is_xen_suspend();
 
 	DPRINTK("%s", xdev->nodename);
 
 	if (dev->driver == NULL)
 		return 0;
 	drv = to_xenbus_driver(dev->driver);
-	if (drv->suspend)
-		err = drv->suspend(xdev);
-	if (err)
-		dev_warn(dev, "suspend failed: %i\n", err);
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
+		dev_warn(&xdev->dev, "%s %s failed: %d\n", xen_suspend ?
+				"suspend" : "freeze", xdev->nodename, err);
+		return err;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_suspend);
@@ -619,6 +637,7 @@ int xenbus_dev_resume(struct device *dev)
 	struct xenbus_driver *drv;
 	struct xenbus_device *xdev
 		= container_of(dev, struct xenbus_device, dev);
+	bool xen_suspend = xen_is_xen_suspend();
 
 	DPRINTK("%s", xdev->nodename);
 
@@ -627,23 +646,34 @@ int xenbus_dev_resume(struct device *dev)
 	drv = to_xenbus_driver(dev->driver);
 	err = talk_to_otherend(xdev);
 	if (err) {
-		dev_warn(dev, "resume (talk_to_otherend) failed: %i\n", err);
+		dev_warn(&xdev->dev, "%s (talk_to_otherend) %s failed: %d\n",
+				xen_suspend ? "resume" : "restore",
+				xdev->nodename, err);
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
-			dev_warn(dev, "resume failed: %i\n", err);
-			return err;
-		}
+	if (err) {
+		dev_warn(&xdev->dev, "%s %s failed: %d\n",
+				xen_suspend ? "resume" : "restore",
+				xdev->nodename, err);
+		return err;
 	}
 
 	err = watch_otherend(xdev);
 	if (err) {
-		dev_warn(dev, "resume (watch_otherend) failed: %d\n", err);
+		dev_warn(&xdev->dev, "%s (watch_otherend) %s failed: %d.\n",
+				xen_suspend ? "resume" : "restore",
+				xdev->nodename, err);
+
 		return err;
 	}
 
@@ -653,8 +683,44 @@ EXPORT_SYMBOL_GPL(xenbus_dev_resume);
 
 int xenbus_dev_cancel(struct device *dev)
 {
-	/* Do nothing */
-	DPRINTK("cancel");
+	int err;
+	struct xenbus_driver *drv;
+	struct xenbus_device *xendev = to_xenbus_device(dev);
+	bool xen_suspend = xen_is_xen_suspend();
+
+	if (xen_suspend) {
+		/* Do nothing */
+		DPRINTK("cancel");
+		return 0;
+	}
+
+	DPRINTK("%s", xendev->nodename);
+
+	if (dev->driver == NULL)
+		return 0;
+	drv = to_xenbus_driver(dev->driver);
+	err = talk_to_otherend(xendev);
+	if (err) {
+		dev_warn(&xendev->dev, "thaw (talk_to_otherend) %s failed: %d.\n",
+			xendev->nodename, err);
+		return err;
+	}
+
+	if (drv->thaw) {
+		err = drv->thaw(xendev);
+		if (err) {
+			dev_warn(&xendev->dev, "thaw %s failed: %d\n", xendev->nodename, err);
+			return err;
+		}
+	}
+
+	err = watch_otherend(xendev);
+	if (err) {
+		dev_warn(&xendev->dev, "thaw (watch_otherend) %s failed: %d.\n",
+			xendev->nodename, err);
+		return err;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_cancel);
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 5a8315e6d8a6..8da964763255 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -104,6 +104,9 @@ struct xenbus_driver {
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
2.20.1

