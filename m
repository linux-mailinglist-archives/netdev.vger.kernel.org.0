Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F511DD925
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgEUVLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730614AbgEUVLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:01 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C4FC05BD43
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:01 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so10539357ejd.8
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UxPaIBDRafmiQ0UKafviws3l8/Ted7xW1QOTsLZHkDg=;
        b=OLaWPySrBqnIg6Pf6BjB5H4W1LcV9h1gTbn5DGM5SU1a/bePMwWbfV9pgSfLk+7V3I
         9MwQan3iuGVF0dwlEdza1OVrdj1Qlb75zl0et6wKm/iMCyY3slPffDw6mruS2zSuSQlC
         GDYINZRMKVsUKfBa2jA2AQpJJ6rXbVjaVkLFYh05R8TPVgZyaimo4dc90YEwIjkeGuGu
         EY6/KVthlNL/9pFdKUbRs9tlFSR2/4yHkF8X4KRFuKaQYNx4K8hD2hEyP55gCQiiPfEL
         LIR6zqdSa2hEWfT/JJZx03q4AlPxTT3IBxApnKf3IQi2rCXWpUW5bv1qbQ+e0yUSiuIQ
         6ERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UxPaIBDRafmiQ0UKafviws3l8/Ted7xW1QOTsLZHkDg=;
        b=ruJ6uAFE3ic3+0U2dDfB0pSxsPtH1HErSd4XQZOtR4+qAjQ1+vKOl3fRLyzkiE6RQK
         rc44O+/tzYcEvCtadL59pEB3LRkIbaHxf5An+x+OmvyWdiV4vGkjSNZZw+7w6jTmpDLM
         4IDNznFw5WEidgobpLLO+tyBX3/g3JtqMPc8g+T12RYTbVJ1vIqP3Ba7g3ainlwbs362
         Atzx2UgTHUi1/DlrfKHDJYf06YD+0LbBwTG9xeLm0tk0swXltGqDqVQDktJCcBuxp3l6
         wj/tok9CwpfCJrBpmcwQUD4vh5u1AzDLDkbofthfGAQI8VXbQOKMQf7zd4Sr89+NQuZz
         TkBQ==
X-Gm-Message-State: AOAM5326lvtZ9adQjisYIkMtNbg0LPaycPbsSWY6AzfSC4LNHUuznzq1
        Wo9ZcdPKFelKmge56y6wa5I=
X-Google-Smtp-Source: ABdhPJy+zJV7Rq+419DJvC+EYHH5Q6ELRBZ/K/HcH5/Uu37UyXnvDoTScDUEJUiJIGyTjhzTTs2Ohg==
X-Received: by 2002:a17:906:6990:: with SMTP id i16mr5653026ejr.175.1590095459940;
        Thu, 21 May 2020 14:10:59 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 07/13] net: dsa: don't use switchdev_notifier_fdb_info in dsa_switchdev_event_work
Date:   Fri, 22 May 2020 00:10:30 +0300
Message-Id: <20200521211036.668624-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently DSA doesn't add FDB entries on the CPU port, because it only
does so through switchdev, which is associated with a net_device, and
there are none of those for the CPU port.

But actually FDB addresses on the CPU port can be associated with RX
filtering, so we can initiate switchdev operations from within the DSA
layer. We need the deferred work because .ndo_set_rx_mode runs in atomic
context. There is just one problem with the existing code: it passes a
structure in dsa_switchdev_event_work which was retrieved directly from
switchdev, so it contains a net_device. We need to generalize the
contents to something that covers the CPU port as well: the "ds, port"
tuple is fine for that.

Note that the new procedure for notifying the successful FDB offload is
inspired from the rocker model.

Also, nothing was being done if added_by_user was false. Let's check for
that a lot earlier, and don't actually bother to schedule the whole
workqueue for nothing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 12 ++++++
 net/dsa/slave.c    | 98 +++++++++++++++++++++++-----------------------
 2 files changed, 60 insertions(+), 50 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index adecf73bd608..001668007efd 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -72,6 +72,18 @@ struct dsa_notifier_mtu_info {
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
index 886490fb203d..d2072fbd22fe 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1914,72 +1914,60 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
+	struct dsa_port *dp = dsa_to_port(ds, switchdev_work->port);
 	int err;
 
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
@@ -1987,7 +1975,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	const struct switchdev_notifier_fdb_info *fdb_info;
 	struct dsa_switchdev_event_work *switchdev_work;
+	struct dsa_port *dp;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -2000,20 +1990,32 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
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
 	case SWITCHDEV_FDB_ADD_TO_DEVICE: /* fall through */
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
@@ -2023,10 +2025,6 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
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

