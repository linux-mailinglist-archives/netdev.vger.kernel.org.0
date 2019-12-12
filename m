Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B53611CEDB
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 14:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfLLNyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 08:54:36 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:10993 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbfLLNyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 08:54:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576158874; x=1607694874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ezPH1AiTE6r0zrlYMo9nYWVSoQFuwMWPwgfu8FiMjsY=;
  b=VLkmmL2crhc45w2m9S9Z6nnJFjWJ8LRMUHjqr3fRkl5ZwOQCbk9NysQ3
   Rw8Ilq0c30d68D5FeRa6gsmVn+VIn5Nad4F+shPn9FiL69d7YzeDRpCfO
   MLFFiBlG89Yo0727aUlzVG/acMpVePl8SFdf5t1qmHQ85fkZeqwjH3+7e
   I=;
IronPort-SDR: ZpXwKJBgLKNCqpKSMOsUBcKFEjRDg2isaOM1ouRhYHHHL4Y2mIQ8C5LR4SZKZMz9ozikSYQWDM
 OB0j0FcYnf4g==
X-IronPort-AV: E=Sophos;i="5.69,306,1571702400"; 
   d="scan'208";a="14514350"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Dec 2019 13:54:14 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 3DE31C5715;
        Thu, 12 Dec 2019 13:54:13 +0000 (UTC)
Received: from EX13D32EUB003.ant.amazon.com (10.43.166.165) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Dec 2019 13:54:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D32EUB003.ant.amazon.com (10.43.166.165) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Dec 2019 13:54:11 +0000
Received: from u2f063a87eabd5f.cbg10.amazon.com (10.125.106.135) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Dec 2019 13:54:09 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paul Durrant <pdurrant@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] xen-netback: get rid of old udev related code
Date:   Thu, 12 Dec 2019 13:54:06 +0000
Message-ID: <20191212135406.26229-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the past it used to be the case that the Xen toolstack relied upon
udev to execute backend hotplug scripts. However this has not been the
case for many releases now and removal of the associated code in
xen-netback shortens the source by more than 100 lines, and removes much
complexity in the interaction with the xenstore backend state.

NOTE: xen-netback is the only xenbus driver to have a functional uevent()
      method. The only other driver to have a method at all is
      pvcalls-back, and currently pvcalls_back_uevent() simply returns 0.
      Hence this patch also facilitates further cleanup.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Wei Liu <wei.liu@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/xen-netback/common.h |  11 ---
 drivers/net/xen-netback/xenbus.c | 125 ++++---------------------------
 2 files changed, 14 insertions(+), 122 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 05847eb91a1b..e48da004c1a3 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -251,17 +251,6 @@ struct xenvif_hash {
 struct backend_info {
 	struct xenbus_device *dev;
 	struct xenvif *vif;
-
-	/* This is the state that will be reflected in xenstore when any
-	 * active hotplug script completes.
-	 */
-	enum xenbus_state state;
-
-	enum xenbus_state frontend_state;
-	struct xenbus_watch hotplug_status_watch;
-	u8 have_hotplug_status_watch:1;
-
-	const char *hotplug_script;
 };
 
 struct xenvif {
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index f533b7372d59..4e89393d5dd8 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -15,7 +15,6 @@ static int connect_data_rings(struct backend_info *be,
 static void connect(struct backend_info *be);
 static int read_xenbus_vif_flags(struct backend_info *be);
 static int backend_create_xenvif(struct backend_info *be);
-static void unregister_hotplug_status_watch(struct backend_info *be);
 static void xen_unregister_watchers(struct xenvif *vif);
 static void set_backend_state(struct backend_info *be,
 			      enum xenbus_state state);
@@ -199,17 +198,11 @@ static int netback_remove(struct xenbus_device *dev)
 {
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
-	set_backend_state(be, XenbusStateClosed);
-
-	unregister_hotplug_status_watch(be);
 	if (be->vif) {
-		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xen_unregister_watchers(be->vif);
-		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
-	kfree(be->hotplug_script);
 	kfree(be);
 	dev_set_drvdata(&dev->dev, NULL);
 	return 0;
@@ -227,7 +220,6 @@ static int netback_probe(struct xenbus_device *dev,
 	struct xenbus_transaction xbt;
 	int err;
 	int sg;
-	const char *script;
 	struct backend_info *be = kzalloc(sizeof(struct backend_info),
 					  GFP_KERNEL);
 	if (!be) {
@@ -239,7 +231,6 @@ static int netback_probe(struct xenbus_device *dev,
 	be->dev = dev;
 	dev_set_drvdata(&dev->dev, be);
 
-	be->state = XenbusStateInitialising;
 	err = xenbus_switch_state(dev, XenbusStateInitialising);
 	if (err)
 		goto fail;
@@ -347,21 +338,12 @@ static int netback_probe(struct xenbus_device *dev,
 	if (err)
 		pr_debug("Error writing feature-ctrl-ring\n");
 
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
 	err = backend_create_xenvif(be);
 	if (err)
 		goto fail;
 
+	set_backend_state(be, XenbusStateInitWait);
+
 	return 0;
 
 abort_transaction:
@@ -374,29 +356,6 @@ static int netback_probe(struct xenbus_device *dev,
 }
 
 
-/*
- * Handle the creation of the hotplug script environment.  We add the script
- * and vif variables to the environment, for the benefit of the vif-* hotplug
- * scripts.
- */
-static int netback_uevent(struct xenbus_device *xdev,
-			  struct kobj_uevent_env *env)
-{
-	struct backend_info *be = dev_get_drvdata(&xdev->dev);
-
-	if (!be)
-		return 0;
-
-	if (add_uevent_var(env, "script=%s", be->hotplug_script))
-		return -ENOMEM;
-
-	if (!be->vif)
-		return 0;
-
-	return add_uevent_var(env, "vif=%s", be->vif->dev->name);
-}
-
-
 static int backend_create_xenvif(struct backend_info *be)
 {
 	int err;
@@ -422,7 +381,6 @@ static int backend_create_xenvif(struct backend_info *be)
 	be->vif = vif;
 	vif->be = be;
 
-	kobject_uevent(&dev->dev.kobj, KOBJ_ONLINE);
 	return 0;
 }
 
@@ -462,21 +420,6 @@ static void backend_connect(struct backend_info *be)
 		connect(be);
 }
 
-static inline void backend_switch_state(struct backend_info *be,
-					enum xenbus_state state)
-{
-	struct xenbus_device *dev = be->dev;
-
-	pr_debug("%s -> %s\n", dev->nodename, xenbus_strstate(state));
-	be->state = state;
-
-	/* If we are waiting for a hotplug script then defer the
-	 * actual xenbus state change.
-	 */
-	if (!be->have_hotplug_status_watch)
-		xenbus_switch_state(dev, state);
-}
-
 /* Handle backend state transitions:
  *
  * The backend state starts in Initialising and the following transitions are
@@ -500,17 +443,19 @@ static inline void backend_switch_state(struct backend_info *be,
 static void set_backend_state(struct backend_info *be,
 			      enum xenbus_state state)
 {
-	while (be->state != state) {
-		switch (be->state) {
+	struct xenbus_device *dev = be->dev;
+
+	while (dev->state != state) {
+		switch (dev->state) {
 		case XenbusStateInitialising:
 			switch (state) {
 			case XenbusStateInitWait:
 			case XenbusStateConnected:
 			case XenbusStateClosing:
-				backend_switch_state(be, XenbusStateInitWait);
+				xenbus_switch_state(dev, XenbusStateInitWait);
 				break;
 			case XenbusStateClosed:
-				backend_switch_state(be, XenbusStateClosed);
+				xenbus_switch_state(dev, XenbusStateClosed);
 				break;
 			default:
 				BUG();
@@ -520,10 +465,10 @@ static void set_backend_state(struct backend_info *be,
 			switch (state) {
 			case XenbusStateInitWait:
 			case XenbusStateConnected:
-				backend_switch_state(be, XenbusStateInitWait);
+				xenbus_switch_state(dev, XenbusStateInitWait);
 				break;
 			case XenbusStateClosing:
-				backend_switch_state(be, XenbusStateClosing);
+				xenbus_switch_state(dev, XenbusStateClosing);
 				break;
 			default:
 				BUG();
@@ -533,11 +478,11 @@ static void set_backend_state(struct backend_info *be,
 			switch (state) {
 			case XenbusStateConnected:
 				backend_connect(be);
-				backend_switch_state(be, XenbusStateConnected);
+				xenbus_switch_state(dev, XenbusStateConnected);
 				break;
 			case XenbusStateClosing:
 			case XenbusStateClosed:
-				backend_switch_state(be, XenbusStateClosing);
+				xenbus_switch_state(dev, XenbusStateClosing);
 				break;
 			default:
 				BUG();
@@ -549,7 +494,7 @@ static void set_backend_state(struct backend_info *be,
 			case XenbusStateClosing:
 			case XenbusStateClosed:
 				backend_disconnect(be);
-				backend_switch_state(be, XenbusStateClosing);
+				xenbus_switch_state(dev, XenbusStateClosing);
 				break;
 			default:
 				BUG();
@@ -560,7 +505,7 @@ static void set_backend_state(struct backend_info *be,
 			case XenbusStateInitWait:
 			case XenbusStateConnected:
 			case XenbusStateClosed:
-				backend_switch_state(be, XenbusStateClosed);
+				xenbus_switch_state(dev, XenbusStateClosed);
 				break;
 			default:
 				BUG();
@@ -582,8 +527,6 @@ static void frontend_changed(struct xenbus_device *dev,
 
 	pr_debug("%s -> %s\n", dev->otherend, xenbus_strstate(frontend_state));
 
-	be->frontend_state = frontend_state;
-
 	switch (frontend_state) {
 	case XenbusStateInitialising:
 		set_backend_state(be, XenbusStateInitWait);
@@ -799,38 +742,6 @@ static void xen_unregister_watchers(struct xenvif *vif)
 	xen_unregister_credit_watch(vif);
 }
 
-static void unregister_hotplug_status_watch(struct backend_info *be)
-{
-	if (be->have_hotplug_status_watch) {
-		unregister_xenbus_watch(&be->hotplug_status_watch);
-		kfree(be->hotplug_status_watch.node);
-	}
-	be->have_hotplug_status_watch = 0;
-}
-
-static void hotplug_status_changed(struct xenbus_watch *watch,
-				   const char *path,
-				   const char *token)
-{
-	struct backend_info *be = container_of(watch,
-					       struct backend_info,
-					       hotplug_status_watch);
-	char *str;
-	unsigned int len;
-
-	str = xenbus_read(XBT_NIL, be->dev->nodename, "hotplug-status", &len);
-	if (IS_ERR(str))
-		return;
-	if (len == sizeof("connected")-1 && !memcmp(str, "connected", len)) {
-		/* Complete any pending state change */
-		xenbus_switch_state(be->dev, be->state);
-
-		/* Not interested in this watch anymore. */
-		unregister_hotplug_status_watch(be);
-	}
-	kfree(str);
-}
-
 static int connect_ctrl_ring(struct backend_info *be)
 {
 	struct xenbus_device *dev = be->dev;
@@ -974,13 +885,6 @@ static void connect(struct backend_info *be)
 
 	xenvif_carrier_on(be->vif);
 
-	unregister_hotplug_status_watch(be);
-	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
-				   hotplug_status_changed,
-				   "%s/%s", dev->nodename, "hotplug-status");
-	if (!err)
-		be->have_hotplug_status_watch = 1;
-
 	netif_tx_wake_all_queues(be->vif->dev);
 
 	return;
@@ -1137,7 +1041,6 @@ static struct xenbus_driver netback_driver = {
 	.ids = netback_ids,
 	.probe = netback_probe,
 	.remove = netback_remove,
-	.uevent = netback_uevent,
 	.otherend_changed = frontend_changed,
 };
 
-- 
2.20.1

