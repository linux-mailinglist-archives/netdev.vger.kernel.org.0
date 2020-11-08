Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F2A2AAB29
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 14:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgKHNWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 08:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgKHNUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 08:20:14 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C191AC0613D2;
        Sun,  8 Nov 2020 05:20:13 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id ay21so5906235edb.2;
        Sun, 08 Nov 2020 05:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yc3fdvdMZXoIQBbOfrk5g2mtoncNy7PSx02ksEjgVdU=;
        b=dmRgZbV1OhD87z6CiSifwoSR7s9GWPgGd6HzevP4l6OqJTc3yN+UQD6W8/rP9w+/tP
         DgOyYjsIMdFL5ZtQzVB/RFclLeGlD0bAPedM8NuEk7BPG/X3g++E+IkCwVxSsEO3NR/T
         HjLNuVfh7kJfrdzUvPNRif9k5lK/JhV7bQU5XIL9BZIzYNsPjU9qxCmuEwCLnl6OvVct
         9u+J+Ve0ORZUuWi53jqFD7bo4/HebmE8xlndGM5nLjL73EicxCSgyE7NTD5G2fQM1ckr
         Eqis+um8up/T9mgSzjpj1aLVVvlbJdz/vUcippaElpBY+Pp5TNCov8Df9dM1dljGXqgH
         EA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yc3fdvdMZXoIQBbOfrk5g2mtoncNy7PSx02ksEjgVdU=;
        b=rOl5tPZTZLquuNibZ0c8XJKQ+nSvx3PQprSxmOW9OVm3ZAqMMOVNLied+M6f1jXQrj
         3N6XKvRzPQdVGCQkbqSjkh9LinkDvOTQkxkxsKqTn1cfq0d6wRf6yh1l63SW6l/hB0Aj
         u8x6baOrUxfHL9XQAvIy7yZrnzHXAi639Zxh/B0gt7pL/P8YlaR0FSO8DezTniuypkc3
         31LYypM088GunPSOimcy4XBKuZ3j+uQi081b8DkXLXH4wzJ2i4rit39taGmYQK1rMcl7
         UpR5S9aSooCeVJtT5akO68i+ptTu9ed0xsWBj2kk2jpRU4lq1KVuYVMMZnjbIXamPn7D
         TeXg==
X-Gm-Message-State: AOAM532Mqrb4cNFsDuqvfP7QSWoEb1ozTt2lioZ9MtTRFJSIRFuFOLFm
        bSpgz642PjP642XRwHIGE/I=
X-Google-Smtp-Source: ABdhPJzAN2rJKsy409i1Pukz6IpTay5+eISlUAJdlHmhNMu8QMcUB2oDLFKK0OgQw4talgDAaoV9mw==
X-Received: by 2002:a05:6402:1245:: with SMTP id l5mr10762274edw.68.1604841612472;
        Sun, 08 Nov 2020 05:20:12 -0800 (PST)
Received: from localhost.localdomain ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id og19sm5967094ejb.7.2020.11.08.05.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 05:20:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 1/3] net: dsa: don't use switchdev_notifier_fdb_info in dsa_switchdev_event_work
Date:   Sun,  8 Nov 2020 15:19:51 +0200
Message-Id: <20201108131953.2462644-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201108131953.2462644-1-olteanv@gmail.com>
References: <20201108131953.2462644-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSA doesn't add FDB entries on the CPU port, because it only
does so through switchdev events added_by_user and associated with a
DSA net_device, and there are none of those for the CPU port.

But actually FDB entries towards the CPU port make sense for some use
cases where certain addresses need to be processed in software, and in
that case we need to call dsa_switchdev_event_work.

There is just one problem with the existing code: it passes a structure
in dsa_switchdev_event_work which was retrieved directly from switchdev,
so it contains a net_device. We need to generalize the contents to
something that covers the CPU port as well: the "ds, port" tuple is fine
for that.

Note that the new procedure for notifying the successful FDB offload is
inspired from the rocker model.

Also, nothing was being done if added_by_user was false. Let's check for
that a lot earlier, and don't actually bother to schedule the whole
workqueue for nothing.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/dsa_priv.h |  12 ++++++
 net/dsa/slave.c    | 100 ++++++++++++++++++++++-----------------------
 2 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 12998bf04e55..03671ed984a1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -73,6 +73,18 @@ struct dsa_notifier_mtu_info {
 	int mtu;
 };
 
+struct dsa_switchdev_event_work {
+	struct dsa_switch *ds;
+	int port;
+	struct work_struct work;
+	unsigned long event;
+	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
+	 * SWITCHDEV_FDB_DEL_TO_DEVICE
+	 */
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 59c80052e950..30db8230e30b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2062,72 +2062,62 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-struct dsa_switchdev_event_work {
-	struct work_struct work;
-	struct switchdev_notifier_fdb_info fdb_info;
-	struct net_device *dev;
-	unsigned long event;
-};
+static void
+dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+{
+	struct dsa_switch *ds = switchdev_work->ds;
+	struct dsa_port *dp = dsa_to_port(ds, switchdev_work->port);
+	struct switchdev_notifier_fdb_info info;
+
+	if (!dsa_is_user_port(ds, dp->index))
+		return;
+
+	info.addr = switchdev_work->addr;
+	info.vid = switchdev_work->vid;
+	info.offloaded = true;
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
+				 dp->slave, &info.info, NULL);
+}
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
 {
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
-	struct net_device *dev = switchdev_work->dev;
-	struct switchdev_notifier_fdb_info *fdb_info;
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = switchdev_work->ds;
+	struct dsa_port *dp;
 	int err;
 
+	dp = dsa_to_port(ds, switchdev_work->port);
+
 	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
-			break;
-
-		err = dsa_port_fdb_add(dp, fdb_info->addr, fdb_info->vid);
+		err = dsa_port_fdb_add(dp, switchdev_work->addr,
+				       switchdev_work->vid);
 		if (err) {
-			netdev_dbg(dev, "fdb add failed err=%d\n", err);
+			dev_dbg(ds->dev, "port %d fdb add failed err=%d\n",
+				dp->index, err);
 			break;
 		}
-		fdb_info->offloaded = true;
-		call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev,
-					 &fdb_info->info, NULL);
+		dsa_fdb_offload_notify(switchdev_work);
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
-			break;
-
-		err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
+		err = dsa_port_fdb_del(dp, switchdev_work->addr,
+				       switchdev_work->vid);
 		if (err) {
-			netdev_dbg(dev, "fdb del failed err=%d\n", err);
-			dev_close(dev);
+			dev_dbg(ds->dev, "port %d fdb del failed err=%d\n",
+				dp->index, err);
+			if (dsa_is_user_port(ds, dp->index))
+				dev_close(dp->slave);
 		}
 		break;
 	}
 	rtnl_unlock();
 
-	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
-	dev_put(dev);
-}
-
-static int
-dsa_slave_switchdev_fdb_work_init(struct dsa_switchdev_event_work *
-				  switchdev_work,
-				  const struct switchdev_notifier_fdb_info *
-				  fdb_info)
-{
-	memcpy(&switchdev_work->fdb_info, fdb_info,
-	       sizeof(switchdev_work->fdb_info));
-	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-	if (!switchdev_work->fdb_info.addr)
-		return -ENOMEM;
-	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-			fdb_info->addr);
-	return 0;
+	if (dsa_is_user_port(ds, dp->index))
+		dev_put(dp->slave);
 }
 
 /* Called under rcu_read_lock() */
@@ -2135,7 +2125,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	const struct switchdev_notifier_fdb_info *fdb_info;
 	struct dsa_switchdev_event_work *switchdev_work;
+	struct dsa_port *dp;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -2148,20 +2140,32 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	if (!dsa_slave_dev_check(dev))
 		return NOTIFY_DONE;
 
+	dp = dsa_slave_to_port(dev);
+
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return NOTIFY_BAD;
 
 	INIT_WORK(&switchdev_work->work,
 		  dsa_slave_switchdev_event_work);
-	switchdev_work->dev = dev;
+	switchdev_work->ds = dp->ds;
+	switchdev_work->port = dp->index;
 	switchdev_work->event = event;
 
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (dsa_slave_switchdev_fdb_work_init(switchdev_work, ptr))
-			goto err_fdb_work_init;
+		fdb_info = ptr;
+
+		if (!fdb_info->added_by_user) {
+			kfree(switchdev_work);
+			return NOTIFY_OK;
+		}
+
+		ether_addr_copy(switchdev_work->addr,
+				fdb_info->addr);
+		switchdev_work->vid = fdb_info->vid;
+
 		dev_hold(dev);
 		break;
 	default:
@@ -2171,10 +2175,6 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 	dsa_schedule_work(&switchdev_work->work);
 	return NOTIFY_OK;
-
-err_fdb_work_init:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
-- 
2.25.1

