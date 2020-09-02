Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F44225B2D7
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIBRQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 13:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBRQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 13:16:09 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A4BC061244;
        Wed,  2 Sep 2020 10:16:09 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id m6so261746wrn.0;
        Wed, 02 Sep 2020 10:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4LLYwCw24RfzCKq+wMRj1V4jGhNeafVsoI0HV+QRwuY=;
        b=uPKBAXBNoL0iLAiWUbV3Sbjhv8JvpDSzN9N7O8IymWzAI8YFuqTqcjA00h+hvBCx8c
         s5nZae74aSKp6ajA2VK0yK7oBJYb1xTi9uHPA0y9OS8wwrSB13RhuK0wINNRWzuZa+NB
         Ua296dlnyYAANcmPAw+Bjnaym0TtKPQeGsMhHxc3GZZP+CcTJVuoWMnl1k27f6dyw87l
         1niCmk0pzFxAfpxT1Il+hMTi1HRhLZqnma6UDC1ES+61H/tcyxuiZvA/3DOwU5e5K5Y6
         pRAW7k72QxnwKCPzHtcP0Is3jDkXPi7buN/gZ1R5KIDWNF9VDCIEBRsDLKCu1HMVPlCw
         1Jlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4LLYwCw24RfzCKq+wMRj1V4jGhNeafVsoI0HV+QRwuY=;
        b=D4GmygfFFVXC9mQp5qkrGIk7Y67ACxg+sltC7U04Qi6YXh8qAvfscUjuaC58eOO5n2
         nU9ZD24aTSqXUtItjVTuYhvrumqWOorBfKZDBx3YwdSSdzovAv1uQct6qWW0uyMrwH3e
         2pcbCUqadqO3EFZwZS2b8eHOtWbl8D/VFB1nRAf0gH0n54bbkDiKagY3rTOdbjeDnah/
         a0ACW5aq0Q6GgWaXJ4SGPXAcLQlyxUJ1j+ZGnM6hsYJrbY9OptClQtQVCNLvOy9DV8UJ
         vzeOjW15272ysA/HFYkE+exAdjUs+yFzeeewQ+6JWdAc7A6ZZkQUpAgo+OKTRX2+kV0v
         bkLQ==
X-Gm-Message-State: AOAM530uid/vMsM9qdkqMMmSoCn4p3IGGzpkLRZ76e8+REpslLcUEoja
        N9POxkUXeLZOMa8sH3mWb+k=
X-Google-Smtp-Source: ABdhPJxu766bthkwM9TMHb16LEgohw9EhUweJm4wZ9JfQptKSCgaJarddaZb8fMX3WLsIrR62d5pEg==
X-Received: by 2002:a5d:6343:: with SMTP id b3mr8672661wrw.179.1599066967930;
        Wed, 02 Sep 2020 10:16:07 -0700 (PDT)
Received: from localhost.localdomain ([185.200.214.168])
        by smtp.gmail.com with ESMTPSA id u66sm397122wmg.44.2020.09.02.10.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 10:16:06 -0700 (PDT)
From:   izabela.bakollari@gmail.com
To:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        izabela.bakollari@gmail.com
Subject: [PATCHv3 net-next] dropwatch: Support monitoring of dropped frames
Date:   Wed,  2 Sep 2020 19:16:04 +0200
Message-Id: <20200902171604.109864-1-izabela.bakollari@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200707171515.110818-1-izabela.bakollari@gmail.com>
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Izabela Bakollari <izabela.bakollari@gmail.com>

Dropwatch is a utility that monitors dropped frames by having userspace
record them over the dropwatch protocol over a file. This augument
allows live monitoring of dropped frames using tools like tcpdump.

With this feature, dropwatch allows two additional commands (start and
stop interface) which allows the assignment of a net_device to the
dropwatch protocol. When assinged, dropwatch will clone dropped frames,
and receive them on the assigned interface, allowing tools like tcpdump
to monitor for them.

With this feature, create a dummy ethernet interface (ip link add dev
dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
these new commands, and then monitor dropped frames in real time by
running tcpdump -i dummy0.

Signed-off-by: Izabela Bakollari <izabela.bakollari@gmail.com>
---
Changes in v3:
- Name the cloned skb "nskb"
- Remove the error log
- Change coding style in some if statements
---
 include/uapi/linux/net_dropmon.h |  3 ++
 net/core/drop_monitor.c          | 80 ++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 67e31f329190..e8e861e03a8a 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -58,6 +58,8 @@ enum {
 	NET_DM_CMD_CONFIG_NEW,
 	NET_DM_CMD_STATS_GET,
 	NET_DM_CMD_STATS_NEW,
+	NET_DM_CMD_START_IFC,
+	NET_DM_CMD_STOP_IFC,
 	_NET_DM_CMD_MAX,
 };
 
@@ -93,6 +95,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
 	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
+	NET_DM_ATTR_IFNAME,			/* string */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 8e33cec9fc4e..ae5ed70b6b2a 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -30,6 +30,7 @@
 #include <net/genetlink.h>
 #include <net/netevent.h>
 #include <net/flow_offload.h>
+#include <net/sock.h>
 
 #include <trace/events/skb.h>
 #include <trace/events/napi.h>
@@ -46,6 +47,7 @@
  */
 static int trace_state = TRACE_OFF;
 static bool monitor_hw;
+struct net_device *interface;
 
 /* net_dm_mutex
  *
@@ -54,6 +56,8 @@ static bool monitor_hw;
  */
 static DEFINE_MUTEX(net_dm_mutex);
 
+static DEFINE_SPINLOCK(interface_lock);
+
 struct net_dm_stats {
 	u64 dropped;
 	struct u64_stats_sync syncp;
@@ -217,6 +221,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	struct nlattr *nla;
 	int i;
 	struct sk_buff *dskb;
+	struct sk_buff *nskb;
 	struct per_cpu_dm_data *data;
 	unsigned long flags;
 
@@ -255,6 +260,18 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 
 out:
 	spin_unlock_irqrestore(&data->lock, flags);
+	spin_lock_irqsave(&interface_lock, flags);
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (!nskb) {
+		spin_unlock_irqrestore(&interface_lock, flags);
+		return;
+	} else if (interface && interface != nskb->dev) {
+		nskb->dev = interface;
+		spin_unlock_irqrestore(&interface_lock, flags);
+		netif_receive_skb(nskb);
+	} else {
+		spin_unlock_irqrestore(&interface_lock, flags);
+	}
 }
 
 static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
@@ -1315,6 +1332,51 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int net_dm_interface_start(struct net *net, const char *ifname)
+{
+	struct net_device *nd = dev_get_by_name(net, ifname);
+
+	if (!nd)
+		return -ENODEV;
+
+	interface = nd;
+
+	return 0;
+}
+
+static int net_dm_interface_stop(struct net *net, const char *ifname)
+{
+	dev_put(interface);
+	interface = NULL;
+
+	return 0;
+}
+
+static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net *net = sock_net(skb->sk);
+	char ifname[IFNAMSIZ];
+
+	if (net_dm_is_monitoring())
+		return -EBUSY;
+
+	memset(ifname, 0, IFNAMSIZ);
+	nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
+
+	switch (info->genlhdr->cmd) {
+	case NET_DM_CMD_START_IFC:
+		if (interface)
+			return -EBUSY;
+		return net_dm_interface_start(net, ifname);
+	case NET_DM_CMD_STOP_IFC:
+		if (!interface)
+			return -ENODEV;
+		return net_dm_interface_stop(net, interface->name);
+	}
+
+	return 0;
+}
+
 static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
 {
 	void *hdr;
@@ -1503,6 +1565,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct dm_hw_stat_delta *new_stat = NULL;
 	struct dm_hw_stat_delta *tmp;
+	unsigned long flags;
 
 	switch (event) {
 	case NETDEV_REGISTER:
@@ -1529,6 +1592,12 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 				}
 			}
 		}
+		spin_lock_irqsave(&interface_lock, flags);
+		if (interface && interface == dev) {
+			dev_put(interface);
+			interface = NULL;
+		}
+		spin_unlock_irqrestore(&interface_lock, flags);
 		mutex_unlock(&net_dm_mutex);
 		break;
 	}
@@ -1543,6 +1612,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
 	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
 	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
+	[NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
 };
 
 static const struct genl_ops dropmon_ops[] = {
@@ -1570,6 +1640,16 @@ static const struct genl_ops dropmon_ops[] = {
 		.cmd = NET_DM_CMD_STATS_GET,
 		.doit = net_dm_cmd_stats_get,
 	},
+	{
+		.cmd = NET_DM_CMD_START_IFC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = net_dm_cmd_ifc_trace,
+	},
+	{
+		.cmd = NET_DM_CMD_STOP_IFC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = net_dm_cmd_ifc_trace,
+	},
 };
 
 static int net_dm_nl_pre_doit(const struct genl_ops *ops,
-- 
2.18.4

