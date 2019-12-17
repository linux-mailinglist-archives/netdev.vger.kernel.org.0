Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC90122CE8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfLQNcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:32:31 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:23959 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:32:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576589548; x=1608125548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=it5l6mpYZRid1aYG4+U9jyJYzX0Xra6TMdWLnJMkqQM=;
  b=SFgFV7tm+ZjDQUleane20dACYUrmWdVpmF8ce8lnKMbipqFM1JFvTRRY
   ZmEi3u8WEodHsXdhwV+zYaydAZGWD5dCbE8rHJ/NKWN6GWzQlp6qhho6S
   MhNXkNo5JyvXJ6pBDGaLCm7X2CQx/kWQS/NMyKuif785rlmafZKQPbRBL
   c=;
IronPort-SDR: /+6d9mF5v6AAess7gP70O0JF65nm7kTr8MUAi9kqTkxtmNGdDVp5rOZ124sbMmsGI20cXvDNZW
 pWUdudGuNskA==
X-IronPort-AV: E=Sophos;i="5.69,325,1571702400"; 
   d="scan'208";a="7995912"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 17 Dec 2019 13:32:27 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id D1AE8A22AF;
        Tue, 17 Dec 2019 13:32:25 +0000 (UTC)
Received: from EX13D32EUB004.ant.amazon.com (10.43.166.212) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 13:32:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D32EUB004.ant.amazon.com (10.43.166.212) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 13:32:24 +0000
Received: from u2f063a87eabd5f.cbg10.amazon.com (10.125.106.135) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Dec 2019 13:32:22 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paul Durrant <pdurrant@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        "Paul Durrant" <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/3] xen-netback: move netback_probe() and netback_remove() to the end...
Date:   Tue, 17 Dec 2019 13:32:16 +0000
Message-ID: <20191217133218.27085-2-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191217133218.27085-1-pdurrant@amazon.com>
References: <20191217133218.27085-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...of xenbus.c

This is a cosmetic function re-ordering to reduce churn in a subsequent
patch. Some style fix-up was done to make checkpatch.pl happier.

No functional change.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Paul Durrant <paul@xen.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/xen-netback/xenbus.c | 353 +++++++++++++++----------------
 1 file changed, 174 insertions(+), 179 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index f533b7372d59..bb61316d79de 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -195,185 +195,6 @@ static void xenvif_debugfs_delif(struct xenvif *vif)
 }
 #endif /* CONFIG_DEBUG_FS */
 
-static int netback_remove(struct xenbus_device *dev)
-{
-	struct backend_info *be = dev_get_drvdata(&dev->dev);
-
-	set_backend_state(be, XenbusStateClosed);
-
-	unregister_hotplug_status_watch(be);
-	if (be->vif) {
-		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
-		xen_unregister_watchers(be->vif);
-		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
-		xenvif_free(be->vif);
-		be->vif = NULL;
-	}
-	kfree(be->hotplug_script);
-	kfree(be);
-	dev_set_drvdata(&dev->dev, NULL);
-	return 0;
-}
-
-
-/**
- * Entry point to this code when a new device is created.  Allocate the basic
- * structures and switch to InitWait.
- */
-static int netback_probe(struct xenbus_device *dev,
-			 const struct xenbus_device_id *id)
-{
-	const char *message;
-	struct xenbus_transaction xbt;
-	int err;
-	int sg;
-	const char *script;
-	struct backend_info *be = kzalloc(sizeof(struct backend_info),
-					  GFP_KERNEL);
-	if (!be) {
-		xenbus_dev_fatal(dev, -ENOMEM,
-				 "allocating backend structure");
-		return -ENOMEM;
-	}
-
-	be->dev = dev;
-	dev_set_drvdata(&dev->dev, be);
-
-	be->state = XenbusStateInitialising;
-	err = xenbus_switch_state(dev, XenbusStateInitialising);
-	if (err)
-		goto fail;
-
-	sg = 1;
-
-	do {
-		err = xenbus_transaction_start(&xbt);
-		if (err) {
-			xenbus_dev_fatal(dev, err, "starting transaction");
-			goto fail;
-		}
-
-		err = xenbus_printf(xbt, dev->nodename, "feature-sg", "%d", sg);
-		if (err) {
-			message = "writing feature-sg";
-			goto abort_transaction;
-		}
-
-		err = xenbus_printf(xbt, dev->nodename, "feature-gso-tcpv4",
-				    "%d", sg);
-		if (err) {
-			message = "writing feature-gso-tcpv4";
-			goto abort_transaction;
-		}
-
-		err = xenbus_printf(xbt, dev->nodename, "feature-gso-tcpv6",
-				    "%d", sg);
-		if (err) {
-			message = "writing feature-gso-tcpv6";
-			goto abort_transaction;
-		}
-
-		/* We support partial checksum setup for IPv6 packets */
-		err = xenbus_printf(xbt, dev->nodename,
-				    "feature-ipv6-csum-offload",
-				    "%d", 1);
-		if (err) {
-			message = "writing feature-ipv6-csum-offload";
-			goto abort_transaction;
-		}
-
-		/* We support rx-copy path. */
-		err = xenbus_printf(xbt, dev->nodename,
-				    "feature-rx-copy", "%d", 1);
-		if (err) {
-			message = "writing feature-rx-copy";
-			goto abort_transaction;
-		}
-
-		/*
-		 * We don't support rx-flip path (except old guests who don't
-		 * grok this feature flag).
-		 */
-		err = xenbus_printf(xbt, dev->nodename,
-				    "feature-rx-flip", "%d", 0);
-		if (err) {
-			message = "writing feature-rx-flip";
-			goto abort_transaction;
-		}
-
-		/* We support dynamic multicast-control. */
-		err = xenbus_printf(xbt, dev->nodename,
-				    "feature-multicast-control", "%d", 1);
-		if (err) {
-			message = "writing feature-multicast-control";
-			goto abort_transaction;
-		}
-
-		err = xenbus_printf(xbt, dev->nodename,
-				    "feature-dynamic-multicast-control",
-				    "%d", 1);
-		if (err) {
-			message = "writing feature-dynamic-multicast-control";
-			goto abort_transaction;
-		}
-
-		err = xenbus_transaction_end(xbt, 0);
-	} while (err == -EAGAIN);
-
-	if (err) {
-		xenbus_dev_fatal(dev, err, "completing transaction");
-		goto fail;
-	}
-
-	/*
-	 * Split event channels support, this is optional so it is not
-	 * put inside the above loop.
-	 */
-	err = xenbus_printf(XBT_NIL, dev->nodename,
-			    "feature-split-event-channels",
-			    "%u", separate_tx_rx_irq);
-	if (err)
-		pr_debug("Error writing feature-split-event-channels\n");
-
-	/* Multi-queue support: This is an optional feature. */
-	err = xenbus_printf(XBT_NIL, dev->nodename,
-			    "multi-queue-max-queues", "%u", xenvif_max_queues);
-	if (err)
-		pr_debug("Error writing multi-queue-max-queues\n");
-
-	err = xenbus_printf(XBT_NIL, dev->nodename,
-			    "feature-ctrl-ring",
-			    "%u", true);
-	if (err)
-		pr_debug("Error writing feature-ctrl-ring\n");
-
-	script = xenbus_read(XBT_NIL, dev->nodename, "script", NULL);
-	if (IS_ERR(script)) {
-		err = PTR_ERR(script);
-		xenbus_dev_fatal(dev, err, "reading script");
-		goto fail;
-	}
-
-	be->hotplug_script = script;
-
-
-	/* This kicks hotplug scripts, so do it immediately. */
-	err = backend_create_xenvif(be);
-	if (err)
-		goto fail;
-
-	return 0;
-
-abort_transaction:
-	xenbus_transaction_end(xbt, 1);
-	xenbus_dev_fatal(dev, err, "%s", message);
-fail:
-	pr_debug("failed\n");
-	netback_remove(dev);
-	return err;
-}
-
-
 /*
  * Handle the creation of the hotplug script environment.  We add the script
  * and vif variables to the environment, for the benefit of the vif-* hotplug
@@ -1128,6 +949,180 @@ static int read_xenbus_vif_flags(struct backend_info *be)
 	return 0;
 }
 
+static int netback_remove(struct xenbus_device *dev)
+{
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
+
+	set_backend_state(be, XenbusStateClosed);
+
+	unregister_hotplug_status_watch(be);
+	if (be->vif) {
+		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
+		xen_unregister_watchers(be->vif);
+		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
+		xenvif_free(be->vif);
+		be->vif = NULL;
+	}
+	kfree(be->hotplug_script);
+	kfree(be);
+	dev_set_drvdata(&dev->dev, NULL);
+	return 0;
+}
+
+/**
+ * Entry point to this code when a new device is created.  Allocate the basic
+ * structures and switch to InitWait.
+ */
+static int netback_probe(struct xenbus_device *dev,
+			 const struct xenbus_device_id *id)
+{
+	const char *message;
+	struct xenbus_transaction xbt;
+	int err;
+	int sg;
+	const char *script;
+	struct backend_info *be = kzalloc(sizeof(*be), GFP_KERNEL);
+
+	if (!be) {
+		xenbus_dev_fatal(dev, -ENOMEM,
+				 "allocating backend structure");
+		return -ENOMEM;
+	}
+
+	be->dev = dev;
+	dev_set_drvdata(&dev->dev, be);
+
+	be->state = XenbusStateInitialising;
+	err = xenbus_switch_state(dev, XenbusStateInitialising);
+	if (err)
+		goto fail;
+
+	sg = 1;
+
+	do {
+		err = xenbus_transaction_start(&xbt);
+		if (err) {
+			xenbus_dev_fatal(dev, err, "starting transaction");
+			goto fail;
+		}
+
+		err = xenbus_printf(xbt, dev->nodename, "feature-sg", "%d", sg);
+		if (err) {
+			message = "writing feature-sg";
+			goto abort_transaction;
+		}
+
+		err = xenbus_printf(xbt, dev->nodename, "feature-gso-tcpv4",
+				    "%d", sg);
+		if (err) {
+			message = "writing feature-gso-tcpv4";
+			goto abort_transaction;
+		}
+
+		err = xenbus_printf(xbt, dev->nodename, "feature-gso-tcpv6",
+				    "%d", sg);
+		if (err) {
+			message = "writing feature-gso-tcpv6";
+			goto abort_transaction;
+		}
+
+		/* We support partial checksum setup for IPv6 packets */
+		err = xenbus_printf(xbt, dev->nodename,
+				    "feature-ipv6-csum-offload",
+				    "%d", 1);
+		if (err) {
+			message = "writing feature-ipv6-csum-offload";
+			goto abort_transaction;
+		}
+
+		/* We support rx-copy path. */
+		err = xenbus_printf(xbt, dev->nodename,
+				    "feature-rx-copy", "%d", 1);
+		if (err) {
+			message = "writing feature-rx-copy";
+			goto abort_transaction;
+		}
+
+		/* We don't support rx-flip path (except old guests who
+		 * don't grok this feature flag).
+		 */
+		err = xenbus_printf(xbt, dev->nodename,
+				    "feature-rx-flip", "%d", 0);
+		if (err) {
+			message = "writing feature-rx-flip";
+			goto abort_transaction;
+		}
+
+		/* We support dynamic multicast-control. */
+		err = xenbus_printf(xbt, dev->nodename,
+				    "feature-multicast-control", "%d", 1);
+		if (err) {
+			message = "writing feature-multicast-control";
+			goto abort_transaction;
+		}
+
+		err = xenbus_printf(xbt, dev->nodename,
+				    "feature-dynamic-multicast-control",
+				    "%d", 1);
+		if (err) {
+			message = "writing feature-dynamic-multicast-control";
+			goto abort_transaction;
+		}
+
+		err = xenbus_transaction_end(xbt, 0);
+	} while (err == -EAGAIN);
+
+	if (err) {
+		xenbus_dev_fatal(dev, err, "completing transaction");
+		goto fail;
+	}
+
+	/* Split event channels support, this is optional so it is not
+	 * put inside the above loop.
+	 */
+	err = xenbus_printf(XBT_NIL, dev->nodename,
+			    "feature-split-event-channels",
+			    "%u", separate_tx_rx_irq);
+	if (err)
+		pr_debug("Error writing feature-split-event-channels\n");
+
+	/* Multi-queue support: This is an optional feature. */
+	err = xenbus_printf(XBT_NIL, dev->nodename,
+			    "multi-queue-max-queues", "%u", xenvif_max_queues);
+	if (err)
+		pr_debug("Error writing multi-queue-max-queues\n");
+
+	err = xenbus_printf(XBT_NIL, dev->nodename,
+			    "feature-ctrl-ring",
+			    "%u", true);
+	if (err)
+		pr_debug("Error writing feature-ctrl-ring\n");
+
+	script = xenbus_read(XBT_NIL, dev->nodename, "script", NULL);
+	if (IS_ERR(script)) {
+		err = PTR_ERR(script);
+		xenbus_dev_fatal(dev, err, "reading script");
+		goto fail;
+	}
+
+	be->hotplug_script = script;
+
+	/* This kicks hotplug scripts, so do it immediately. */
+	err = backend_create_xenvif(be);
+	if (err)
+		goto fail;
+
+	return 0;
+
+abort_transaction:
+	xenbus_transaction_end(xbt, 1);
+	xenbus_dev_fatal(dev, err, "%s", message);
+fail:
+	pr_debug("failed\n");
+	netback_remove(dev);
+	return err;
+}
+
 static const struct xenbus_device_id netback_ids[] = {
 	{ "vif" },
 	{ "" }
-- 
2.20.1

