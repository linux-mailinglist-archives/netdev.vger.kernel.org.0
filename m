Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B312174E5
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgGGRPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgGGRPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:15:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA663C061755;
        Tue,  7 Jul 2020 10:15:18 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f18so37969193wrs.0;
        Tue, 07 Jul 2020 10:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zPaFNN0CwRIrxgMT/Hx12rk1w2uEgsV43cWtsFNawmA=;
        b=OoD5s6EqQZLxfIp3I7A669VifnUn9Ibnc7LYMSzZ0tIPUiA9Tp+buHQWel8bB9NGk2
         EGangoBXq+izJzkRL1SnU8OAXuEDSdrGvKiTIwg3pdycFDevybGoENDig+Lin5AzfxWn
         rV61Zirbp/gFLfE4XdvxvCOlOODfeXWxT96BQOHVqZkX/J+llXtaJhvzMN3duDyx1vmF
         UtnFxZDDLSvOdsxVgUzYyobE4n4F/ZgGwV+CqNdRYZAjF1GmtCkfutynvWYnuKPjn1wm
         ymW3Rw/ZTEaVMH6waJzp/4nd8HMM7k76LkNaYVpT4umj4p1Z6H3JkI3G8/Hg1SfAn7v2
         IxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zPaFNN0CwRIrxgMT/Hx12rk1w2uEgsV43cWtsFNawmA=;
        b=bBrUUUf2JVcBAHcp8P7U/l62YvlsVWBC4yA6G1YXFjf6RDy85RgK/ngcdPpsVUDluo
         h3RcpreFKki1YTjUd2DiEMGhkr45E41Q1FJdzNTN8c1OBVAt+wkkNHkIIXshXQZbohPW
         V1kpaa0w5zCh9RyX7ISKFZp3tU+5ms1r4laEs541Ny10MWIrUQsHHqLmpgBa0YCITRdi
         ArK810IAF/RtcOP3T5WXsHvXbqF6nfHDBIcC35Q2rK1PbJDyTRGMvlemxXBJPKApR05Y
         3P2EgZy7TcvtKIxCYyOgtU+K4u8ZnIcbByHTPGLN1h0Nlpfbee3ZrXjLO8Rcr0f4FvmX
         rXLA==
X-Gm-Message-State: AOAM531138zjzglc/zRSHI2yYLJ/zYv+Bfw/4D4XwOXW3Ohy7B8Jvm+9
        qxhZaSponVLGhLKb6up4oag=
X-Google-Smtp-Source: ABdhPJwhTIoqPYMMiP4fvG9oZ1gOVUngiaKMsqX034M6n5Y/X7x48Jlyu5WLxXmWUrCOj1WsUBIg7A==
X-Received: by 2002:a5d:6683:: with SMTP id l3mr7880261wru.288.1594142117582;
        Tue, 07 Jul 2020 10:15:17 -0700 (PDT)
Received: from localhost.localdomain ([185.200.214.168])
        by smtp.gmail.com with ESMTPSA id d132sm1872742wmd.35.2020.07.07.10.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 10:15:16 -0700 (PDT)
From:   izabela.bakollari@gmail.com
To:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        izabela.bakollari@gmail.com
Subject: [PATCH net-next] dropwatch: Support monitoring of dropped frames
Date:   Tue,  7 Jul 2020 19:15:15 +0200
Message-Id: <20200707171515.110818-1-izabela.bakollari@gmail.com>
X-Mailer: git-send-email 2.18.4
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
 include/uapi/linux/net_dropmon.h |  3 ++
 net/core/drop_monitor.c          | 79 +++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 2 deletions(-)

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
index 8e33cec9fc4e..8049bff05abd 100644
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
@@ -220,9 +222,8 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	struct per_cpu_dm_data *data;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&data->lock, flags);
 	data = this_cpu_ptr(&dm_cpu_data);
-	spin_lock(&data->lock);
 	dskb = data->skb;
 
 	if (!dskb)
@@ -255,6 +256,12 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 
 out:
 	spin_unlock_irqrestore(&data->lock, flags);
+
+	if (interface && interface != skb->dev) {
+		skb = skb_clone(skb, GFP_ATOMIC);
+		skb->dev = interface;
+		netif_receive_skb(skb);
+	}
 }
 
 static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
@@ -1315,6 +1322,63 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int net_dm_interface_start(struct net *net, const char *ifname)
+{
+	struct net_device *nd;
+
+	nd = dev_get_by_name(net, ifname);
+
+	if (nd) {
+		interface = nd;
+		dev_hold(interface);
+	} else {
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int net_dm_interface_stop(struct net *net, const char *ifname)
+{
+	struct net_device *nd;
+
+	nd = dev_get_by_name(net, ifname);
+
+	if (nd) {
+		interface = nd;
+		dev_put(interface);
+	} else {
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net *net = sock_net(skb->sk);
+	char ifname[IFNAMSIZ];
+	int rc;
+
+	memset(ifname, 0, IFNAMSIZ);
+	nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
+
+	switch (info->genlhdr->cmd) {
+	case NET_DM_CMD_START_IFC:
+		rc = net_dm_interface_start(net, ifname);
+		if (rc)
+			return rc;
+		break;
+	case NET_DM_CMD_STOP_IFC:
+		if (interface) {
+			rc = net_dm_interface_stop(net, interface->ifname);
+			return rc;
+		} else {
+			return -ENODEV;
+		}
+	}
+
+	return 0;
+}
+
 static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
 {
 	void *hdr;
@@ -1543,6 +1607,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
 	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
 	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
+	[NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
 };
 
 static const struct genl_ops dropmon_ops[] = {
@@ -1570,6 +1635,16 @@ static const struct genl_ops dropmon_ops[] = {
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

