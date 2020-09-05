Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E0025E672
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgIEIZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbgIEIYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:24:47 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA01C061245
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:24:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c15so9620485wrs.11
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/rmyWrnXvOCm7Q1YwgJ/ZWsjJP5X0WLKrIJz0s4aWCY=;
        b=cYyFvXxWSm8EIxf27MIKZ40y5cOzT4lySq5n4C/R/uBEgtcN8Lse0rNyiQo7AiCcYf
         zO1JjAP4agYuO6erUEWcVT//4k190KiJWEjJOYTpp0IhDd4LEAKgaP2fAwXeWIYfh8F1
         cBWxPLSby9M6LzIR9BRuOuUBycM8iZfxNzueo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/rmyWrnXvOCm7Q1YwgJ/ZWsjJP5X0WLKrIJz0s4aWCY=;
        b=Osb2xrn/kD+7xaslGiycZefotPxcUmqklTjkYXqOqn6z9kSlLJAWov8ftO32e54Uqi
         iK9lR2hfJFtX2KViihyOkzF4dGBl17kXUDsDJOpuiYUToK3D4dM8Kuq26rYOF5Edpub8
         AYI2meF7dwG0/8rI3kGrR5u7dF2Bqd2GLz/Rxm9jPGLRNpDEmGmBm4yRjiB6Zpy5buUZ
         nLBV5kw76LArpuM1T+mufOOxNVHnDIMwXo7Qc+GtnzXMCHiOEBmeIpCiAdKDgvjjLvSf
         /l8z+o/igI3MvorLQ9fdzyDJSt7gixt0DUtRYOA40QQQJrkghBltwwsIeBVXRKkxpD1Y
         lrlA==
X-Gm-Message-State: AOAM533EBtOkvyJpA5WTWMow18WAgEJrajTkZEN2f0oOlqlJHSA5ye4T
        IKHouFUuCAbodWUfDv6J6vMsrdCmk4BPe81f
X-Google-Smtp-Source: ABdhPJwiPPEdh5yaaFAqSvi0UUszApZ9+OvQPA7CHuZnkLZXZZCYVY2I+c+n6a8HM2M94fvZYc+66w==
X-Received: by 2002:adf:ba83:: with SMTP id p3mr11741130wrg.246.1599294284571;
        Sat, 05 Sep 2020 01:24:44 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:43 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 03/15] net: bridge: mcast: add support for src list and filter mode dumping
Date:   Sat,  5 Sep 2020 11:23:58 +0300
Message-Id: <20200905082410.2230253-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support per port group src list (address and timer) and filter mode
dumping. Protected by either multicast_lock or rcu.

v3: add IPv6 support
v2: require RCU or multicast_lock to traverse src groups

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h | 21 +++++++++
 net/bridge/br_mdb.c            | 85 +++++++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index c1227aecd38f..75a2ac479247 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -455,10 +455,31 @@ enum {
 enum {
 	MDBA_MDB_EATTR_UNSPEC,
 	MDBA_MDB_EATTR_TIMER,
+	MDBA_MDB_EATTR_SRC_LIST,
+	MDBA_MDB_EATTR_GROUP_MODE,
 	__MDBA_MDB_EATTR_MAX
 };
 #define MDBA_MDB_EATTR_MAX (__MDBA_MDB_EATTR_MAX - 1)
 
+/* per mdb entry source */
+enum {
+	MDBA_MDB_SRCLIST_UNSPEC,
+	MDBA_MDB_SRCLIST_ENTRY,
+	__MDBA_MDB_SRCLIST_MAX
+};
+#define MDBA_MDB_SRCLIST_MAX (__MDBA_MDB_SRCLIST_MAX - 1)
+
+/* per mdb entry per source attributes
+ * these are embedded in MDBA_MDB_SRCLIST_ENTRY
+ */
+enum {
+	MDBA_MDB_SRCATTR_UNSPEC,
+	MDBA_MDB_SRCATTR_ADDRESS,
+	MDBA_MDB_SRCATTR_TIMER,
+	__MDBA_MDB_SRCATTR_MAX
+};
+#define MDBA_MDB_SRCATTR_MAX (__MDBA_MDB_SRCATTR_MAX - 1)
+
 /* multicast router types */
 enum {
 	MDB_RTR_TYPE_DISABLED,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index a7cb2710902e..76fce1dac4a5 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -77,10 +77,67 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
 #endif
 }
 
+static int __mdb_fill_srcs(struct sk_buff *skb,
+			   struct net_bridge_port_group *p)
+{
+	struct net_bridge_group_src *ent;
+	struct nlattr *nest, *nest_ent;
+
+	if (hlist_empty(&p->src_list))
+		return 0;
+
+	nest = nla_nest_start(skb, MDBA_MDB_EATTR_SRC_LIST);
+	if (!nest)
+		return -EMSGSIZE;
+
+	hlist_for_each_entry_rcu(ent, &p->src_list, node,
+				 lockdep_is_held(&p->port->br->multicast_lock)) {
+		nest_ent = nla_nest_start(skb, MDBA_MDB_SRCLIST_ENTRY);
+		if (!nest_ent)
+			goto out_cancel_err;
+		switch (ent->addr.proto) {
+		case htons(ETH_P_IP):
+			if (nla_put_in_addr(skb, MDBA_MDB_SRCATTR_ADDRESS,
+					    ent->addr.u.ip4)) {
+				nla_nest_cancel(skb, nest_ent);
+				goto out_cancel_err;
+			}
+			break;
+#if IS_ENABLED(CONFIG_IPV6)
+		case htons(ETH_P_IPV6):
+			if (nla_put_in6_addr(skb, MDBA_MDB_SRCATTR_ADDRESS,
+					     &ent->addr.u.ip6)) {
+				nla_nest_cancel(skb, nest_ent);
+				goto out_cancel_err;
+			}
+			break;
+#endif
+		default:
+			nla_nest_cancel(skb, nest_ent);
+			continue;
+		}
+		if (nla_put_u32(skb, MDBA_MDB_SRCATTR_TIMER,
+				br_timer_value(&ent->timer))) {
+			nla_nest_cancel(skb, nest_ent);
+			goto out_cancel_err;
+		}
+		nla_nest_end(skb, nest_ent);
+	}
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+out_cancel_err:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int __mdb_fill_info(struct sk_buff *skb,
 			   struct net_bridge_mdb_entry *mp,
 			   struct net_bridge_port_group *p)
 {
+	bool dump_srcs_mode = false;
 	struct timer_list *mtimer;
 	struct nlattr *nest_ent;
 	struct br_mdb_entry e;
@@ -119,6 +176,23 @@ static int __mdb_fill_info(struct sk_buff *skb,
 		nla_nest_cancel(skb, nest_ent);
 		return -EMSGSIZE;
 	}
+	switch (mp->addr.proto) {
+	case htons(ETH_P_IP):
+		dump_srcs_mode = !!(p && mp->br->multicast_igmp_version == 3);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		dump_srcs_mode = !!(p && mp->br->multicast_mld_version == 2);
+		break;
+#endif
+	}
+	if (dump_srcs_mode &&
+	    (__mdb_fill_srcs(skb, p) ||
+	     nla_put_u8(skb, MDBA_MDB_EATTR_GROUP_MODE, p->filter_mode))) {
+		nla_nest_cancel(skb, nest_ent);
+		return -EMSGSIZE;
+	}
+
 	nla_nest_end(skb, nest_ent);
 
 	return 0;
@@ -127,7 +201,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			    struct net_device *dev)
 {
-	int idx = 0, s_idx = cb->args[1], err = 0;
+	int idx = 0, s_idx = cb->args[1], err = 0, pidx = 0, s_pidx = cb->args[2];
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_mdb_entry *mp;
 	struct nlattr *nest, *nest2;
@@ -152,7 +226,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			break;
 		}
 
-		if (mp->host_joined) {
+		if (!s_pidx && mp->host_joined) {
 			err = __mdb_fill_info(skb, mp, NULL);
 			if (err) {
 				nla_nest_cancel(skb, nest2);
@@ -164,13 +238,19 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 		      pp = &p->next) {
 			if (!p->port)
 				continue;
+			if (pidx < s_pidx)
+				goto skip_pg;
 
 			err = __mdb_fill_info(skb, mp, p);
 			if (err) {
 				nla_nest_cancel(skb, nest2);
 				goto out;
 			}
+skip_pg:
+			pidx++;
 		}
+		pidx = 0;
+		s_pidx = 0;
 		nla_nest_end(skb, nest2);
 skip:
 		idx++;
@@ -178,6 +258,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 
 out:
 	cb->args[1] = idx;
+	cb->args[2] = pidx;
 	nla_nest_end(skb, nest);
 	return err;
 }
-- 
2.25.4

