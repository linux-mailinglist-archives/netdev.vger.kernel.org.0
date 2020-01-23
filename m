Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93721146908
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAWN2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:28:21 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40284 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgAWN2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:28:20 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18so3358363ljo.7
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 05:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TnEYqQ0aM638zm5shZjohvbYMiyGDKjlDb9qY1Q3PJ4=;
        b=MyaLZC88choVWccZhDm+aRBKyiWO0VvmRbwsTRBtCeOMKFhRaoq+2mUEVgOp6bfZjY
         z7OPH2rE848iuqSGo903XY0SkNa9MJjRGf7nQRyY15Kglsb+yw8RC+4seQty7BeKxp6T
         n2dZ/QjpADc3pv7jUGFRNkWzp6+UXk9wJsCFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TnEYqQ0aM638zm5shZjohvbYMiyGDKjlDb9qY1Q3PJ4=;
        b=VIXlnaq0x99Nk8QOrzA+Uzog42DIzOhMg5wP9am9WU36DlgVoZZKHrYcR4k4e+v+Hm
         0RTFBEHSbF8NVgp96W8NOrrPwkoamJuWHiKKod6kZYq/PhKLjXxtEdQ5Dcf8Wp6S+DOu
         IvAlglSM1JaqdRXe664Y8T2pZcy/NE39DnPBW8nMozKeajXAuJPeY1XImiCy1x4MgtuA
         L4msiTojsd2dyOoCLieqx0V5G0jOpnKVm0mlERSxuF1J5BKhAPKiDA1QxN/HBjRlP3F9
         smuzoAL73rAblrgUn4TFsFUf3LTf3CLBU/KHY/ZzquIY5hkSwSKE2gqNzy2T/mD8A+zN
         wmFA==
X-Gm-Message-State: APjAAAXnCrQF/4k0a/PjKFiiR8TiAaVqwz0cEabLBAFcDt6G821xzB1A
        UbiQWy3xrKkRmwAu22zyCFFj7ZCXvk8=
X-Google-Smtp-Source: APXvYqwhsKwH7UpkfytJk8GR6y16WBs6v7oeWKJDHx8aX/aAhyfNkvRJhzAzd1RxE9Dqu/ltfCHBrQ==
X-Received: by 2002:a2e:6c06:: with SMTP id h6mr22509503ljc.246.1579786097804;
        Thu, 23 Jan 2020 05:28:17 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b20sm1238571ljp.20.2020.01.23.05.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 05:28:17 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/4] net: bridge: vlan: add basic option dumping support
Date:   Thu, 23 Jan 2020 15:28:05 +0200
Message-Id: <20200123132807.613-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200123132807.613-1-nikolay@cumulusnetworks.com>
References: <20200123132807.613-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll be dumping the options for the whole range if they're equal. The
first range vlan will be used to extract the options. The commit doesn't
change anything yet it just adds the skeleton for the support. The dump
will happen when the first option is added.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/Makefile          |  2 +-
 net/bridge/br_private.h      |  8 ++++++++
 net/bridge/br_vlan.c         | 20 ++++++++++++++------
 net/bridge/br_vlan_options.c | 25 +++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 7 deletions(-)
 create mode 100644 net/bridge/br_vlan_options.c

diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index ac9ef337f0fa..49da7ae6f077 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
 
 bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
 
-bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o
+bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_options.o
 
 bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a6226ff2f0cc..403df71d2cfa 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1191,6 +1191,14 @@ static inline void br_vlan_notify(const struct net_bridge *br,
 }
 #endif
 
+/* br_vlan_options.c */
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+bool br_vlan_opts_eq(const struct net_bridge_vlan *v1,
+		     const struct net_bridge_vlan *v2);
+bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v);
+size_t br_vlan_opts_nl_size(void);
+#endif
+
 struct nf_br_ops {
 	int (*br_dev_xmit_hook)(struct sk_buff *skb);
 };
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index e4f7dd10c3f8..75ec3da92b0b 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1547,7 +1547,9 @@ void br_vlan_port_event(struct net_bridge_port *p, unsigned long event)
 	}
 }
 
+/* v_opts is used to dump the options which must be equal in the whole range */
 static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
+			      const struct net_bridge_vlan *v_opts,
 			      u16 flags)
 {
 	struct bridge_vlan_info info;
@@ -1572,6 +1574,9 @@ static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 	    nla_put_u16(skb, BRIDGE_VLANDB_ENTRY_RANGE, vid_range))
 		goto out_err;
 
+	if (v_opts && !br_vlan_opts_fill(skb, v_opts))
+		goto out_err;
+
 	nla_nest_end(skb, nest);
 
 	return true;
@@ -1586,7 +1591,8 @@ static size_t rtnl_vlan_nlmsg_size(void)
 	return NLMSG_ALIGN(sizeof(struct br_vlan_msg))
 		+ nla_total_size(0) /* BRIDGE_VLANDB_ENTRY */
 		+ nla_total_size(sizeof(u16)) /* BRIDGE_VLANDB_ENTRY_RANGE */
-		+ nla_total_size(sizeof(struct bridge_vlan_info)); /* BRIDGE_VLANDB_ENTRY_INFO */
+		+ nla_total_size(sizeof(struct bridge_vlan_info)) /* BRIDGE_VLANDB_ENTRY_INFO */
+		+ br_vlan_opts_nl_size(); /* bridge vlan options */
 }
 
 void br_vlan_notify(const struct net_bridge *br,
@@ -1595,7 +1601,7 @@ void br_vlan_notify(const struct net_bridge *br,
 		    int cmd)
 {
 	struct net_bridge_vlan_group *vg;
-	struct net_bridge_vlan *v;
+	struct net_bridge_vlan *v = NULL;
 	struct br_vlan_msg *bvm;
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
@@ -1647,7 +1653,7 @@ void br_vlan_notify(const struct net_bridge *br,
 		goto out_kfree;
 	}
 
-	if (!br_vlan_fill_vids(skb, vid, vid_range, flags))
+	if (!br_vlan_fill_vids(skb, vid, vid_range, v, flags))
 		goto out_err;
 
 	nlmsg_end(skb, nlh);
@@ -1665,7 +1671,8 @@ static bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 				    const struct net_bridge_vlan *range_end)
 {
 	return v_curr->vid - range_end->vid == 1 &&
-	       range_end->flags == v_curr->flags;
+	       range_end->flags == v_curr->flags &&
+	       br_vlan_opts_eq(v_curr, range_end);
 }
 
 static int br_vlan_dump_dev(const struct net_device *dev,
@@ -1729,7 +1736,8 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			u16 flags = br_vlan_flags(range_start, pvid);
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
-					       range_end->vid, flags)) {
+					       range_end->vid, range_start,
+					       flags)) {
 				err = -EMSGSIZE;
 				break;
 			}
@@ -1748,7 +1756,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 	 */
 	if (!err && range_start &&
 	    !br_vlan_fill_vids(skb, range_start->vid, range_end->vid,
-			       br_vlan_flags(range_start, pvid)))
+			       range_start, br_vlan_flags(range_start, pvid)))
 		err = -EMSGSIZE;
 
 	cb->args[1] = err ? idx : 0;
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
new file mode 100644
index 000000000000..55fcdc9c380c
--- /dev/null
+++ b/net/bridge/br_vlan_options.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2020, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/slab.h>
+
+#include "br_private.h"
+
+/* check if the options between two vlans are equal */
+bool br_vlan_opts_eq(const struct net_bridge_vlan *v1,
+		     const struct net_bridge_vlan *v2)
+{
+	return true;
+}
+
+bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
+{
+	return true;
+}
+
+size_t br_vlan_opts_nl_size(void)
+{
+	return 0;
+}
-- 
2.21.0

