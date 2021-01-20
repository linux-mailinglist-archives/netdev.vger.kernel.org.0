Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF61F2FD458
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbhATPkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389887AbhATOyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:54:46 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA9AC061799
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:11 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id r12so22535551ejb.9
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RUfnxg7JDBFIwuUWLAhYbWYF3RttZk+VcieI3V+L2Fs=;
        b=gQ3nLuW4o4Eol9q5Pt15/DWuygHTU0A8Sdpm0AWwEy8iyn8a573G0TADPMcTJSCIzg
         EVxuFKmS9z3D+djEw2u++NT9/IA3+R/TcpL/jwWifrOjrihNZdWxR5fMANOPZ0ytmet/
         Qne0DHiIJuBWCqeQVP8VAdUvVMh+V/2Ca8dWxmDWjTIbiGq3Yy7SK2KxkciFuezAj723
         I177XCVmiM6dqnBP5lz+QexxHHHjFrquHeQ8wqwh3V2im49zYExsdWeLb9KiEyY35ef/
         OOAyHDLAL+e9gzJqQAiX8fi8WMnay4zIv2HoH3ykoR5WxnG/XDjKaaX9qSaR39iLvnET
         nPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUfnxg7JDBFIwuUWLAhYbWYF3RttZk+VcieI3V+L2Fs=;
        b=htS1R8tEDjjryEkDhgH8/kCifqxzVILTika0GmFs85KPZDN3E608NkMP1xUHn05tYH
         UrG4d86zts/acIDASs3DskQEDPPF1cIjNqAKAWxp6tzjTppoo9s5O73Rl/gn75fD3voo
         p8POmR4S4WDuNJMJRUy2tl55DEgYx/GmYrC4FgBtQNYQPVYppY0rjpy/gS4xKFy+ys6n
         QmIul0ngs+TP3UmAAxNfyGJthkznAJCXzNywf4e04X485wpCDI7aIVWKumSY91ql7RXR
         JJev9wHtgmv6gsBVNr1Z3K1rj5abrgNMvhDdjgcCXLcwLVSUq6kYCL/pT6plOH1ph4O5
         /soQ==
X-Gm-Message-State: AOAM533Ascb4Piawe/JAn3zP7exAJASNy6KXc8JOqpcTRdHJgAmZwAzh
        16P2Q2uFMqPn9ynrbz9jhqOH5X+50ZQWH5YBziA=
X-Google-Smtp-Source: ABdhPJzrFNidycGyTV9SBshPnSCIi+GJPPottSUkGSiy905eX1YTowz09tt0n0YOuTM1kcAlDXniwQ==
X-Received: by 2002:a17:906:c954:: with SMTP id fw20mr4228893ejb.342.1611154389683;
        Wed, 20 Jan 2021 06:53:09 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:08 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 06/14] net: bridge: multicast: add EHT host handling functions
Date:   Wed, 20 Jan 2021 16:51:55 +0200
Message-Id: <20210120145203.1109140-7-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add functions to create, destroy and lookup an EHT host. These are
per-host entries contained in the eht_host_tree in net_bridge_port_group
which are used to store a list of all sources (S,G) entries joined for that
group by each host, the host's current filter mode and total number of
joined entries.
No functional changes yet, these would be used in later patches.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/Makefile           |   2 +-
 net/bridge/br_multicast.c     |   1 +
 net/bridge/br_multicast_eht.c | 115 ++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 1 deletion(-)
 create mode 100644 net/bridge/br_multicast_eht.c

diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 4702702a74d3..7fb9a021873b 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -18,7 +18,7 @@ br_netfilter-y := br_netfilter_hooks.o
 br_netfilter-$(subst m,y,$(CONFIG_IPV6)) += br_netfilter_ipv6.o
 obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
 
-bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
+bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o br_multicast_eht.o
 
 bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_options.o
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3aaa6adbff82..dc6e879dc840 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1173,6 +1173,7 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	p->flags = flags;
 	p->filter_mode = filter_mode;
 	p->rt_protocol = rt_protocol;
+	p->eht_host_tree = RB_ROOT;
 	p->mcast_gc.destroy = br_multicast_destroy_port_group;
 	INIT_HLIST_HEAD(&p->src_list);
 
diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
new file mode 100644
index 000000000000..5cebca45e72c
--- /dev/null
+++ b/net/bridge/br_multicast_eht.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+// Copyright (c) 2020, Nikolay Aleksandrov <nikolay@nvidia.com>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/if_ether.h>
+#include <linux/igmp.h>
+#include <linux/in.h>
+#include <linux/jhash.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+#include <linux/netdevice.h>
+#include <linux/netfilter_bridge.h>
+#include <linux/random.h>
+#include <linux/rculist.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/inetdevice.h>
+#include <linux/mroute.h>
+#include <net/ip.h>
+#include <net/switchdev.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <linux/icmpv6.h>
+#include <net/ipv6.h>
+#include <net/mld.h>
+#include <net/ip6_checksum.h>
+#include <net/addrconf.h>
+#endif
+
+#include "br_private.h"
+#include "br_private_mcast_eht.h"
+
+static struct net_bridge_group_eht_host *
+br_multicast_eht_host_lookup(struct net_bridge_port_group *pg,
+			     union net_bridge_eht_addr *h_addr)
+{
+	struct rb_node *node = pg->eht_host_tree.rb_node;
+
+	while (node) {
+		struct net_bridge_group_eht_host *this;
+		int result;
+
+		this = rb_entry(node, struct net_bridge_group_eht_host,
+				rb_node);
+		result = memcmp(h_addr, &this->h_addr, sizeof(*h_addr));
+		if (result < 0)
+			node = node->rb_left;
+		else if (result > 0)
+			node = node->rb_right;
+		else
+			return this;
+	}
+
+	return NULL;
+}
+
+static int br_multicast_eht_host_filter_mode(struct net_bridge_port_group *pg,
+					     union net_bridge_eht_addr *h_addr)
+{
+	struct net_bridge_group_eht_host *eht_host;
+
+	eht_host = br_multicast_eht_host_lookup(pg, h_addr);
+	if (!eht_host)
+		return MCAST_INCLUDE;
+
+	return eht_host->filter_mode;
+}
+
+static void __eht_destroy_host(struct net_bridge_group_eht_host *eht_host)
+{
+	WARN_ON(!hlist_empty(&eht_host->set_entries));
+
+	rb_erase(&eht_host->rb_node, &eht_host->pg->eht_host_tree);
+	RB_CLEAR_NODE(&eht_host->rb_node);
+	kfree(eht_host);
+}
+
+static struct net_bridge_group_eht_host *
+__eht_lookup_create_host(struct net_bridge_port_group *pg,
+			 union net_bridge_eht_addr *h_addr,
+			 unsigned char filter_mode)
+{
+	struct rb_node **link = &pg->eht_host_tree.rb_node, *parent = NULL;
+	struct net_bridge_group_eht_host *eht_host;
+
+	while (*link) {
+		struct net_bridge_group_eht_host *this;
+		int result;
+
+		this = rb_entry(*link, struct net_bridge_group_eht_host,
+				rb_node);
+		result = memcmp(h_addr, &this->h_addr, sizeof(*h_addr));
+		parent = *link;
+		if (result < 0)
+			link = &((*link)->rb_left);
+		else if (result > 0)
+			link = &((*link)->rb_right);
+		else
+			return this;
+	}
+
+	eht_host = kzalloc(sizeof(*eht_host), GFP_ATOMIC);
+	if (!eht_host)
+		return NULL;
+
+	memcpy(&eht_host->h_addr, h_addr, sizeof(*h_addr));
+	INIT_HLIST_HEAD(&eht_host->set_entries);
+	eht_host->pg = pg;
+	eht_host->filter_mode = filter_mode;
+
+	rb_link_node(&eht_host->rb_node, parent, link);
+	rb_insert_color(&eht_host->rb_node, &pg->eht_host_tree);
+
+	return eht_host;
+}
-- 
2.29.2

