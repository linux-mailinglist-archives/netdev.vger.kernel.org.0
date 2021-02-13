Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7004331AE03
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBMUoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhBMUop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:44:45 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB11C0613D6
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:04 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hs11so5232785ejc.1
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWnLJXpmgnqKhxCvRRQzAj55lRwiX8jco9PWVDXLMCM=;
        b=VCgRix+IX9569fHtwZH0m6KlclicqOeSx9vZNoHE+jyZu0AsvmpVpLUc7WG89JYHY+
         PhBkSTnVMBbnEpcTyIPDicMctLCIFYclSYskxWun07LrwlDSMYOZern9DpmE7Y/dMetY
         xdxNyDybX9lGDA9VNu8jU32pM9d6LkBthXpt+NN4mJJXj3IsgOSLLHQH0uZwOA7KIPlk
         ZBZM4TQhNGM180IiKs2stcjmynHuaLSzkXeQ3+VaM6G20TlgCigKYox+W+YhWV98DjBt
         v7WtZo4XKS0YhG2RSqwLQahYYt/1sra0E4DAS3IzqhS6IJNfM/P7jEWcTkka7iQgIyFg
         95aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWnLJXpmgnqKhxCvRRQzAj55lRwiX8jco9PWVDXLMCM=;
        b=eDsudpTNjhcQi9VrIEIaJg+FDUz3u8CEqAi+dtprZp4c233CFOTgkDevBkCs0o1t6D
         SeGoATP1aiWEPS2W9NbF/C1WSQTg4Ej/Qc0yUevduhQxDy2R5r4ikZP/3D9ZJJ5QbwUk
         9JfOJVeg/CwTyppfdvaLFKv1fhwBU/cu1q9T4q66y6Pbi4HrN2blU2e2A2oUKorVkb/g
         A7Eq2mJMnJVXfGe/TnBdn54rGhQDJGkWKFG2hzkWTVvxrjvT1ba3IZJQwv5wIjb8jzgl
         fKv+O/CMf3975+6qXll2I+YI4Xy86LfZORFGivg1SAJkqALmiML0dumic1kBt3pJ+mhM
         J1qw==
X-Gm-Message-State: AOAM5303HVh47aoMFfUrjcgYW61e8JfhtF2OjuT+QdQPzaS2nmAVkMsH
        2mxwrOVLEumeDc3OW+doeZ4=
X-Google-Smtp-Source: ABdhPJwmkjdhAWNAFac+gdXrQ7zrO1JrxOs8NiHmhq4a7qoTvoaEFr+cL7RZq7ZRwDBXFj5Ts0dTWw==
X-Received: by 2002:a17:906:80b:: with SMTP id e11mr8698852ejd.269.1613249043385;
        Sat, 13 Feb 2021 12:44:03 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p6sm2363937ejw.79.2021.02.13.12.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:44:02 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next 2/5] net: bridge: propagate extack through store_bridge_parm
Date:   Sat, 13 Feb 2021 22:43:16 +0200
Message-Id: <20210213204319.1226170-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213204319.1226170-1-olteanv@gmail.com>
References: <20210213204319.1226170-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge sysfs interface stores parameters for the STP, VLAN,
multicast etc subsystems using a predefined function prototype.
Sometimes the underlying function being called supports a netlink
extended ack message, and we ignore it.

Let's expand the store_bridge_parm function prototype to include the
extack, and just print it to console, but at least propagate it where
applicable. Where not applicable, create a shim function in the
br_sysfs_br.c file that discards the extra function argument.

This patch allows us to propagate the extack argument to
br_vlan_set_default_pvid, br_vlan_set_proto and br_vlan_filter_toggle,
and from there, further up in br_changelink from br_netlink.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_netlink.c  |   2 +-
 net/bridge/br_private.h  |   9 ++-
 net/bridge/br_sysfs_br.c | 166 ++++++++++++++++++++++++++++++---------
 net/bridge/br_vlan.c     |  11 ++-
 4 files changed, 142 insertions(+), 46 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a12bbbdacb9b..3f5dc6fcc980 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1212,7 +1212,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_VLAN_FILTERING]) {
 		u8 vlan_filter = nla_get_u8(data[IFLA_BR_VLAN_FILTERING]);
 
-		err = br_vlan_filter_toggle(br, vlan_filter);
+		err = br_vlan_filter_toggle(br, vlan_filter, extack);
 		if (err)
 			return err;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 0281de20212e..a8d483325476 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1085,13 +1085,16 @@ int br_vlan_delete(struct net_bridge *br, u16 vid);
 void br_vlan_flush(struct net_bridge *br);
 struct net_bridge_vlan *br_vlan_find(struct net_bridge_vlan_group *vg, u16 vid);
 void br_recalculate_fwd_mask(struct net_bridge *br);
-int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val);
+int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val,
+			  struct netlink_ext_ack *extack);
 int __br_vlan_set_proto(struct net_bridge *br, __be16 proto);
-int br_vlan_set_proto(struct net_bridge *br, unsigned long val);
+int br_vlan_set_proto(struct net_bridge *br, unsigned long val,
+		      struct netlink_ext_ack *extack);
 int br_vlan_set_stats(struct net_bridge *br, unsigned long val);
 int br_vlan_set_stats_per_port(struct net_bridge *br, unsigned long val);
 int br_vlan_init(struct net_bridge *br);
-int br_vlan_set_default_pvid(struct net_bridge *br, unsigned long val);
+int br_vlan_set_default_pvid(struct net_bridge *br, unsigned long val,
+			     struct netlink_ext_ack *extack);
 int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 			       struct netlink_ext_ack *extack);
 int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 71f0f671c4ef..072e29840082 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -30,11 +30,13 @@
  */
 static ssize_t store_bridge_parm(struct device *d,
 				 const char *buf, size_t len,
-				 int (*set)(struct net_bridge *, unsigned long))
+				 int (*set)(struct net_bridge *br, unsigned long val,
+					    struct netlink_ext_ack *extack))
 {
 	struct net_bridge *br = to_bridge(d);
-	char *endp;
+	struct netlink_ext_ack extack = {0};
 	unsigned long val;
+	char *endp;
 	int err;
 
 	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
@@ -47,9 +49,15 @@ static ssize_t store_bridge_parm(struct device *d,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	err = (*set)(br, val);
+	err = (*set)(br, val, &extack);
 	if (!err)
 		netdev_state_change(br->dev);
+	if (extack._msg) {
+		if (err)
+			br_err(br, "%s\n", extack._msg);
+		else
+			br_warn(br, "%s\n", extack._msg);
+	}
 	rtnl_unlock();
 
 	return err ? err : len;
@@ -63,11 +71,17 @@ static ssize_t forward_delay_show(struct device *d,
 	return sprintf(buf, "%lu\n", jiffies_to_clock_t(br->forward_delay));
 }
 
+static int set_forward_delay(struct net_bridge *br, unsigned long val,
+			     struct netlink_ext_ack *extack)
+{
+	return br_set_forward_delay(br, val);
+}
+
 static ssize_t forward_delay_store(struct device *d,
 				   struct device_attribute *attr,
 				   const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_set_forward_delay);
+	return store_bridge_parm(d, buf, len, set_forward_delay);
 }
 static DEVICE_ATTR_RW(forward_delay);
 
@@ -78,11 +92,17 @@ static ssize_t hello_time_show(struct device *d, struct device_attribute *attr,
 		       jiffies_to_clock_t(to_bridge(d)->hello_time));
 }
 
+static int set_hello_time(struct net_bridge *br, unsigned long val,
+			  struct netlink_ext_ack *extack)
+{
+	return br_set_hello_time(br, val);
+}
+
 static ssize_t hello_time_store(struct device *d,
 				struct device_attribute *attr, const char *buf,
 				size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_set_hello_time);
+	return store_bridge_parm(d, buf, len, set_hello_time);
 }
 static DEVICE_ATTR_RW(hello_time);
 
@@ -93,10 +113,16 @@ static ssize_t max_age_show(struct device *d, struct device_attribute *attr,
 		       jiffies_to_clock_t(to_bridge(d)->max_age));
 }
 
+static int set_max_age(struct net_bridge *br, unsigned long val,
+		       struct netlink_ext_ack *extack)
+{
+	return br_set_max_age(br, val);
+}
+
 static ssize_t max_age_store(struct device *d, struct device_attribute *attr,
 			     const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_set_max_age);
+	return store_bridge_parm(d, buf, len, set_max_age);
 }
 static DEVICE_ATTR_RW(max_age);
 
@@ -107,7 +133,8 @@ static ssize_t ageing_time_show(struct device *d,
 	return sprintf(buf, "%lu\n", jiffies_to_clock_t(br->ageing_time));
 }
 
-static int set_ageing_time(struct net_bridge *br, unsigned long val)
+static int set_ageing_time(struct net_bridge *br, unsigned long val,
+			   struct netlink_ext_ack *extack)
 {
 	return br_set_ageing_time(br, val);
 }
@@ -128,9 +155,10 @@ static ssize_t stp_state_show(struct device *d,
 }
 
 
-static int set_stp_state(struct net_bridge *br, unsigned long val)
+static int set_stp_state(struct net_bridge *br, unsigned long val,
+			 struct netlink_ext_ack *extack)
 {
-	return br_stp_set_enabled(br, val, NULL);
+	return br_stp_set_enabled(br, val, extack);
 }
 
 static ssize_t stp_state_store(struct device *d,
@@ -149,7 +177,8 @@ static ssize_t group_fwd_mask_show(struct device *d,
 	return sprintf(buf, "%#x\n", br->group_fwd_mask);
 }
 
-static int set_group_fwd_mask(struct net_bridge *br, unsigned long val)
+static int set_group_fwd_mask(struct net_bridge *br, unsigned long val,
+			      struct netlink_ext_ack *extack)
 {
 	if (val & BR_GROUPFWD_RESTRICTED)
 		return -EINVAL;
@@ -176,7 +205,8 @@ static ssize_t priority_show(struct device *d, struct device_attribute *attr,
 		       (br->bridge_id.prio[0] << 8) | br->bridge_id.prio[1]);
 }
 
-static int set_priority(struct net_bridge *br, unsigned long val)
+static int set_priority(struct net_bridge *br, unsigned long val,
+			struct netlink_ext_ack *extack)
 {
 	br_stp_set_bridge_priority(br, (u16) val);
 	return 0;
@@ -312,7 +342,8 @@ static ssize_t group_addr_store(struct device *d,
 
 static DEVICE_ATTR_RW(group_addr);
 
-static int set_flush(struct net_bridge *br, unsigned long val)
+static int set_flush(struct net_bridge *br, unsigned long val,
+		     struct netlink_ext_ack *extack)
 {
 	br_fdb_flush(br);
 	return 0;
@@ -334,9 +365,10 @@ static ssize_t no_linklocal_learn_show(struct device *d,
 	return sprintf(buf, "%d\n", br_boolopt_get(br, BR_BOOLOPT_NO_LL_LEARN));
 }
 
-static int set_no_linklocal_learn(struct net_bridge *br, unsigned long val)
+static int set_no_linklocal_learn(struct net_bridge *br, unsigned long val,
+				  struct netlink_ext_ack *extack)
 {
-	return br_boolopt_toggle(br, BR_BOOLOPT_NO_LL_LEARN, !!val, NULL);
+	return br_boolopt_toggle(br, BR_BOOLOPT_NO_LL_LEARN, !!val, extack);
 }
 
 static ssize_t no_linklocal_learn_store(struct device *d,
@@ -355,11 +387,17 @@ static ssize_t multicast_router_show(struct device *d,
 	return sprintf(buf, "%d\n", br->multicast_router);
 }
 
+static int set_multicast_router(struct net_bridge *br, unsigned long val,
+				struct netlink_ext_ack *extack)
+{
+	return br_multicast_set_router(br, val);
+}
+
 static ssize_t multicast_router_store(struct device *d,
 				      struct device_attribute *attr,
 				      const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_multicast_set_router);
+	return store_bridge_parm(d, buf, len, set_multicast_router);
 }
 static DEVICE_ATTR_RW(multicast_router);
 
@@ -371,11 +409,17 @@ static ssize_t multicast_snooping_show(struct device *d,
 	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_MULTICAST_ENABLED));
 }
 
+static int toggle_multicast(struct net_bridge *br, unsigned long val,
+			    struct netlink_ext_ack *extack)
+{
+	return br_multicast_toggle(br, val);
+}
+
 static ssize_t multicast_snooping_store(struct device *d,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_multicast_toggle);
+	return store_bridge_parm(d, buf, len, toggle_multicast);
 }
 static DEVICE_ATTR_RW(multicast_snooping);
 
@@ -388,7 +432,8 @@ static ssize_t multicast_query_use_ifaddr_show(struct device *d,
 		       br_opt_get(br, BROPT_MULTICAST_QUERY_USE_IFADDR));
 }
 
-static int set_query_use_ifaddr(struct net_bridge *br, unsigned long val)
+static int set_query_use_ifaddr(struct net_bridge *br, unsigned long val,
+				struct netlink_ext_ack *extack)
 {
 	br_opt_toggle(br, BROPT_MULTICAST_QUERY_USE_IFADDR, !!val);
 	return 0;
@@ -411,11 +456,17 @@ static ssize_t multicast_querier_show(struct device *d,
 	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_MULTICAST_QUERIER));
 }
 
+static int set_multicast_querier(struct net_bridge *br, unsigned long val,
+				 struct netlink_ext_ack *extack)
+{
+	return br_multicast_set_querier(br, val);
+}
+
 static ssize_t multicast_querier_store(struct device *d,
 				       struct device_attribute *attr,
 				       const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_multicast_set_querier);
+	return store_bridge_parm(d, buf, len, set_multicast_querier);
 }
 static DEVICE_ATTR_RW(multicast_querier);
 
@@ -425,10 +476,12 @@ static ssize_t hash_elasticity_show(struct device *d,
 	return sprintf(buf, "%u\n", RHT_ELASTICITY);
 }
 
-static int set_elasticity(struct net_bridge *br, unsigned long val)
+static int set_elasticity(struct net_bridge *br, unsigned long val,
+			  struct netlink_ext_ack *extack)
 {
-	br_warn(br, "the hash_elasticity option has been deprecated and is always %u\n",
-		RHT_ELASTICITY);
+	/* 16 is RHT_ELASTICITY */
+	NL_SET_ERR_MSG_MOD(extack,
+			   "the hash_elasticity option has been deprecated and is always 16");
 	return 0;
 }
 
@@ -447,7 +500,8 @@ static ssize_t hash_max_show(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "%u\n", br->hash_max);
 }
 
-static int set_hash_max(struct net_bridge *br, unsigned long val)
+static int set_hash_max(struct net_bridge *br, unsigned long val,
+			struct netlink_ext_ack *extack)
 {
 	br->hash_max = val;
 	return 0;
@@ -469,11 +523,17 @@ static ssize_t multicast_igmp_version_show(struct device *d,
 	return sprintf(buf, "%u\n", br->multicast_igmp_version);
 }
 
+static int set_multicast_igmp_version(struct net_bridge *br, unsigned long val,
+				      struct netlink_ext_ack *extack)
+{
+	return br_multicast_set_igmp_version(br, val);
+}
+
 static ssize_t multicast_igmp_version_store(struct device *d,
 					    struct device_attribute *attr,
 					    const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_multicast_set_igmp_version);
+	return store_bridge_parm(d, buf, len, set_multicast_igmp_version);
 }
 static DEVICE_ATTR_RW(multicast_igmp_version);
 
@@ -485,7 +545,8 @@ static ssize_t multicast_last_member_count_show(struct device *d,
 	return sprintf(buf, "%u\n", br->multicast_last_member_count);
 }
 
-static int set_last_member_count(struct net_bridge *br, unsigned long val)
+static int set_last_member_count(struct net_bridge *br, unsigned long val,
+				 struct netlink_ext_ack *extack)
 {
 	br->multicast_last_member_count = val;
 	return 0;
@@ -506,7 +567,8 @@ static ssize_t multicast_startup_query_count_show(
 	return sprintf(buf, "%u\n", br->multicast_startup_query_count);
 }
 
-static int set_startup_query_count(struct net_bridge *br, unsigned long val)
+static int set_startup_query_count(struct net_bridge *br, unsigned long val,
+				   struct netlink_ext_ack *extack)
 {
 	br->multicast_startup_query_count = val;
 	return 0;
@@ -528,7 +590,8 @@ static ssize_t multicast_last_member_interval_show(
 		       jiffies_to_clock_t(br->multicast_last_member_interval));
 }
 
-static int set_last_member_interval(struct net_bridge *br, unsigned long val)
+static int set_last_member_interval(struct net_bridge *br, unsigned long val,
+				    struct netlink_ext_ack *extack)
 {
 	br->multicast_last_member_interval = clock_t_to_jiffies(val);
 	return 0;
@@ -550,7 +613,8 @@ static ssize_t multicast_membership_interval_show(
 		       jiffies_to_clock_t(br->multicast_membership_interval));
 }
 
-static int set_membership_interval(struct net_bridge *br, unsigned long val)
+static int set_membership_interval(struct net_bridge *br, unsigned long val,
+				   struct netlink_ext_ack *extack)
 {
 	br->multicast_membership_interval = clock_t_to_jiffies(val);
 	return 0;
@@ -573,7 +637,8 @@ static ssize_t multicast_querier_interval_show(struct device *d,
 		       jiffies_to_clock_t(br->multicast_querier_interval));
 }
 
-static int set_querier_interval(struct net_bridge *br, unsigned long val)
+static int set_querier_interval(struct net_bridge *br, unsigned long val,
+				struct netlink_ext_ack *extack)
 {
 	br->multicast_querier_interval = clock_t_to_jiffies(val);
 	return 0;
@@ -596,7 +661,8 @@ static ssize_t multicast_query_interval_show(struct device *d,
 		       jiffies_to_clock_t(br->multicast_query_interval));
 }
 
-static int set_query_interval(struct net_bridge *br, unsigned long val)
+static int set_query_interval(struct net_bridge *br, unsigned long val,
+			      struct netlink_ext_ack *extack)
 {
 	br->multicast_query_interval = clock_t_to_jiffies(val);
 	return 0;
@@ -619,7 +685,8 @@ static ssize_t multicast_query_response_interval_show(
 		jiffies_to_clock_t(br->multicast_query_response_interval));
 }
 
-static int set_query_response_interval(struct net_bridge *br, unsigned long val)
+static int set_query_response_interval(struct net_bridge *br, unsigned long val,
+				       struct netlink_ext_ack *extack)
 {
 	br->multicast_query_response_interval = clock_t_to_jiffies(val);
 	return 0;
@@ -642,7 +709,8 @@ static ssize_t multicast_startup_query_interval_show(
 		jiffies_to_clock_t(br->multicast_startup_query_interval));
 }
 
-static int set_startup_query_interval(struct net_bridge *br, unsigned long val)
+static int set_startup_query_interval(struct net_bridge *br, unsigned long val,
+				      struct netlink_ext_ack *extack)
 {
 	br->multicast_startup_query_interval = clock_t_to_jiffies(val);
 	return 0;
@@ -666,7 +734,8 @@ static ssize_t multicast_stats_enabled_show(struct device *d,
 		       br_opt_get(br, BROPT_MULTICAST_STATS_ENABLED));
 }
 
-static int set_stats_enabled(struct net_bridge *br, unsigned long val)
+static int set_stats_enabled(struct net_bridge *br, unsigned long val,
+			     struct netlink_ext_ack *extack)
 {
 	br_opt_toggle(br, BROPT_MULTICAST_STATS_ENABLED, !!val);
 	return 0;
@@ -691,11 +760,17 @@ static ssize_t multicast_mld_version_show(struct device *d,
 	return sprintf(buf, "%u\n", br->multicast_mld_version);
 }
 
+static int set_multicast_mld_version(struct net_bridge *br, unsigned long val,
+				     struct netlink_ext_ack *extack)
+{
+	return br_multicast_set_mld_version(br, val);
+}
+
 static ssize_t multicast_mld_version_store(struct device *d,
 					   struct device_attribute *attr,
 					   const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_multicast_set_mld_version);
+	return store_bridge_parm(d, buf, len, set_multicast_mld_version);
 }
 static DEVICE_ATTR_RW(multicast_mld_version);
 #endif
@@ -708,7 +783,8 @@ static ssize_t nf_call_iptables_show(
 	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_NF_CALL_IPTABLES));
 }
 
-static int set_nf_call_iptables(struct net_bridge *br, unsigned long val)
+static int set_nf_call_iptables(struct net_bridge *br, unsigned long val,
+				struct netlink_ext_ack *extack)
 {
 	br_opt_toggle(br, BROPT_NF_CALL_IPTABLES, !!val);
 	return 0;
@@ -729,7 +805,8 @@ static ssize_t nf_call_ip6tables_show(
 	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_NF_CALL_IP6TABLES));
 }
 
-static int set_nf_call_ip6tables(struct net_bridge *br, unsigned long val)
+static int set_nf_call_ip6tables(struct net_bridge *br, unsigned long val,
+				 struct netlink_ext_ack *extack)
 {
 	br_opt_toggle(br, BROPT_NF_CALL_IP6TABLES, !!val);
 	return 0;
@@ -750,7 +827,8 @@ static ssize_t nf_call_arptables_show(
 	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_NF_CALL_ARPTABLES));
 }
 
-static int set_nf_call_arptables(struct net_bridge *br, unsigned long val)
+static int set_nf_call_arptables(struct net_bridge *br, unsigned long val,
+				 struct netlink_ext_ack *extack)
 {
 	br_opt_toggle(br, BROPT_NF_CALL_ARPTABLES, !!val);
 	return 0;
@@ -821,11 +899,17 @@ static ssize_t vlan_stats_enabled_show(struct device *d,
 	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_VLAN_STATS_ENABLED));
 }
 
+static int set_vlan_stats_enabled(struct net_bridge *br, unsigned long val,
+				  struct netlink_ext_ack *extack)
+{
+	return br_vlan_set_stats(br, val);
+}
+
 static ssize_t vlan_stats_enabled_store(struct device *d,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_vlan_set_stats);
+	return store_bridge_parm(d, buf, len, set_vlan_stats_enabled);
 }
 static DEVICE_ATTR_RW(vlan_stats_enabled);
 
@@ -837,11 +921,17 @@ static ssize_t vlan_stats_per_port_show(struct device *d,
 	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_VLAN_STATS_PER_PORT));
 }
 
+static int set_vlan_stats_per_port(struct net_bridge *br, unsigned long val,
+				   struct netlink_ext_ack *extack)
+{
+	return br_vlan_set_stats_per_port(br, val);
+}
+
 static ssize_t vlan_stats_per_port_store(struct device *d,
 					 struct device_attribute *attr,
 					 const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_vlan_set_stats_per_port);
+	return store_bridge_parm(d, buf, len, set_vlan_stats_per_port);
 }
 static DEVICE_ATTR_RW(vlan_stats_per_port);
 #endif
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 26e7e06b6a0d..c4a51095850a 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -806,7 +806,8 @@ void br_recalculate_fwd_mask(struct net_bridge *br)
 					      ~(1u << br->group_addr[5]);
 }
 
-int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val)
+int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val,
+			  struct netlink_ext_ack *extack)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = br->dev,
@@ -910,7 +911,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 	return err;
 }
 
-int br_vlan_set_proto(struct net_bridge *br, unsigned long val)
+int br_vlan_set_proto(struct net_bridge *br, unsigned long val,
+		      struct netlink_ext_ack *extack)
 {
 	if (!eth_type_vlan(htons(val)))
 		return -EPROTONOSUPPORT;
@@ -1095,7 +1097,8 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 	goto out;
 }
 
-int br_vlan_set_default_pvid(struct net_bridge *br, unsigned long val)
+int br_vlan_set_default_pvid(struct net_bridge *br, unsigned long val,
+			     struct netlink_ext_ack *extack)
 {
 	u16 pvid = val;
 	int err = 0;
@@ -1112,7 +1115,7 @@ int br_vlan_set_default_pvid(struct net_bridge *br, unsigned long val)
 		err = -EPERM;
 		goto out;
 	}
-	err = __br_vlan_set_default_pvid(br, pvid, NULL);
+	err = __br_vlan_set_default_pvid(br, pvid, extack);
 out:
 	return err;
 }
-- 
2.25.1

