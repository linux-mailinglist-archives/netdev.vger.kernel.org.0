Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B833B3EB73D
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbhHMPAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbhHMPAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:00:41 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126E2C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:14 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cn28so4004961edb.6
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uQfunZVnk/RE6hSfXipXCZVnbtxnoI5ozTjpp5YTWOU=;
        b=FoQ7BIDZOm2dxPrlvnm0LDyVvml47BDIU8Q5yDlOIslHS3S6jn6VvP+rcDOOVpRrYV
         uDtjAw+InbYkhWbh7QNYYIezhiZ9PECs/bqOZxBPc/w6gRndFbE8+1vpO1wTDa+UBmFx
         gHFiyeI3olYqnPYCNDNEFHNoAGL9FkeZAyy8CWhjbd85hnNzIy91hyM39y7jaNMMcW4j
         QORNjX+7ddNIMBSEpkI8OnRCqjfaHYOzLVzRqypkI8TCyWUBsCJAbcT6Kypktj1kR5wQ
         dK8keegsl2OvHybtYDep5OxG9gUGKff41PpgfPfWtzVtjhbWg112+NTe3uNv6kAsL2PV
         1/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQfunZVnk/RE6hSfXipXCZVnbtxnoI5ozTjpp5YTWOU=;
        b=Ufs0PI3EJes0q5e1LHEnhyr3jEzRkWoSyr4kqV61RTju/sGGl2aUBhbC2v5DmXze5d
         92kc3rIwI+7r1WcOoCBdM6733jNfEIg6dTHB987bamWWe8zE4Jh0EHCScSKiqhxIuion
         dkJbWUSOsYPZA5dSmrDqoA/GHNagXvynrOsKxnH6o9H0KYwvK4snhXS7dhkQf4pSQdDY
         ZvkQ3kdfSDUo13ecJSa4wVhb6/IiDG9Pl6OsH0bo62tMVolwyyHVCLR/SxNAWrLYH/qi
         U0ANvrBsFohEiClvDmOirUU2O7OJ2YroPHv4GJQuBig9gAsQZlotPmw2O1qutZcc22yO
         HsqQ==
X-Gm-Message-State: AOAM533VWaeaPo0wJzTigVjt/1O0leZcbs6AMwmLncPwZF8QuOckcBJJ
        f7AfpyzhuPNJLLQrlbAsj1xXbtX9MVr9c8JR
X-Google-Smtp-Source: ABdhPJyW5c02MUMmdvsjqxnoWQ6XcyoZyInB33s4qAQvAb1hgCt3xVdjlWPxFTBFJTiKcc1E7IhPaQ==
X-Received: by 2002:a05:6402:430d:: with SMTP id m13mr3651258edc.372.1628866812325;
        Fri, 13 Aug 2021 08:00:12 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d26sm1015711edp.90.2021.08.13.08.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:00:11 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 4/6] net: bridge: mcast: dump ipv4 querier state
Date:   Fri, 13 Aug 2021 18:00:00 +0300
Message-Id: <20210813150002.673579-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813150002.673579-1-razor@blackwall.org>
References: <20210813150002.673579-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for dumping global IPv4 querier state, we dump the state
only if our own querier is enabled or there has been another external
querier which has won the election. For the bridge global state we use
a new attribute IFLA_BR_MCAST_QUERIER_STATE and embed the state inside.
The structure is:
 [IFLA_BR_MCAST_QUERIER_STATE]
  `[BRIDGE_QUERIER_IP_ADDRESS] - ip address of the querier
  `[BRIDGE_QUERIER_IP_PORT]    - bridge port ifindex where the querier was
                                 seen (set only if external querier)
  `[BRIDGE_QUERIER_IP_OTHER_TIMER]   -  other querier timeout

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h | 10 +++++
 include/uapi/linux/if_link.h   |  1 +
 net/bridge/br_multicast.c      | 73 ++++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        |  5 ++-
 net/bridge/br_private.h        |  4 ++
 5 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 620d86e825b8..e0fff67fcd88 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -770,4 +770,14 @@ struct br_boolopt_multi {
 	__u32 optval;
 	__u32 optmask;
 };
+
+enum {
+	BRIDGE_QUERIER_UNSPEC,
+	BRIDGE_QUERIER_IP_ADDRESS,
+	BRIDGE_QUERIER_IP_PORT,
+	BRIDGE_QUERIER_IP_OTHER_TIMER,
+	BRIDGE_QUERIER_PAD,
+	__BRIDGE_QUERIER_MAX
+};
+#define BRIDGE_QUERIER_MAX (__BRIDGE_QUERIER_MAX - 1)
 #endif /* _UAPI_LINUX_IF_BRIDGE_H */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5310003523ce..8aad65b69054 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -479,6 +479,7 @@ enum {
 	IFLA_BR_MCAST_MLD_VERSION,
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
+	IFLA_BR_MCAST_QUERIER_STATE,
 	__IFLA_BR_MAX,
 };
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3705b7ace62d..4513bc13b6d3 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2905,6 +2905,79 @@ static bool br_multicast_select_querier(struct net_bridge_mcast *brmctx,
 	return true;
 }
 
+static struct net_bridge_port *
+__br_multicast_get_querier_port(struct net_bridge *br,
+				const struct bridge_mcast_querier *querier)
+{
+	int port_ifidx = READ_ONCE(querier->port_ifidx);
+	struct net_bridge_port *p;
+	struct net_device *dev;
+
+	if (port_ifidx == 0)
+		return NULL;
+
+	dev = dev_get_by_index_rcu(dev_net(br->dev), port_ifidx);
+	if (!dev)
+		return NULL;
+	p = br_port_get_rtnl_rcu(dev);
+	if (!p || p->br != br)
+		return NULL;
+
+	return p;
+}
+
+size_t br_multicast_querier_state_size(void)
+{
+	return nla_total_size(sizeof(0)) +      /* nest attribute */
+	       nla_total_size(sizeof(__be32)) + /* BRIDGE_QUERIER_IP_ADDRESS */
+	       nla_total_size(sizeof(int)) +    /* BRIDGE_QUERIER_IP_PORT */
+	       nla_total_size_64bit(sizeof(u64)); /* BRIDGE_QUERIER_IP_OTHER_TIMER */
+}
+
+/* protected by rtnl or rcu */
+int br_multicast_dump_querier_state(struct sk_buff *skb,
+				    const struct net_bridge_mcast *brmctx,
+				    int nest_attr)
+{
+	struct bridge_mcast_querier querier = {};
+	struct net_bridge_port *p;
+	struct nlattr *nest;
+
+	if (!brmctx->multicast_querier &&
+	    !timer_pending(&brmctx->ip4_other_query.timer))
+		return 0;
+
+	nest = nla_nest_start(skb, nest_attr);
+	if (!nest)
+		return -EMSGSIZE;
+
+	rcu_read_lock();
+	br_multicast_read_querier(&brmctx->ip4_querier, &querier);
+	if (nla_put_in_addr(skb, BRIDGE_QUERIER_IP_ADDRESS,
+			    querier.addr.src.ip4)) {
+		rcu_read_unlock();
+		goto out_err;
+	}
+
+	p = __br_multicast_get_querier_port(brmctx->br, &querier);
+	if (timer_pending(&brmctx->ip4_other_query.timer) &&
+	    (nla_put_u64_64bit(skb, BRIDGE_QUERIER_IP_OTHER_TIMER,
+			       br_timer_value(&brmctx->ip4_other_query.timer),
+			       BRIDGE_QUERIER_PAD) ||
+	     (p && nla_put_u32(skb, BRIDGE_QUERIER_IP_PORT, p->dev->ifindex)))) {
+		rcu_read_unlock();
+		goto out_err;
+	}
+	rcu_read_unlock();
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+out_err:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static void
 br_multicast_update_query_timer(struct net_bridge_mcast *brmctx,
 				struct bridge_mcast_other_query *query,
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 8ae026fa2ad7..2f184ad8ae29 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1501,6 +1501,7 @@ static size_t br_get_size(const struct net_device *brdev)
 	       nla_total_size_64bit(sizeof(u64)) + /* IFLA_BR_MCAST_STARTUP_QUERY_INTVL */
 	       nla_total_size(sizeof(u8)) +	/* IFLA_BR_MCAST_IGMP_VERSION */
 	       nla_total_size(sizeof(u8)) +	/* IFLA_BR_MCAST_MLD_VERSION */
+	       br_multicast_querier_state_size() + /* IFLA_BR_MCAST_QUERIER_STATE */
 #endif
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_NF_CALL_IPTABLES */
@@ -1587,7 +1588,9 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	    nla_put_u32(skb, IFLA_BR_MCAST_STARTUP_QUERY_CNT,
 			br->multicast_ctx.multicast_startup_query_count) ||
 	    nla_put_u8(skb, IFLA_BR_MCAST_IGMP_VERSION,
-		       br->multicast_ctx.multicast_igmp_version))
+		       br->multicast_ctx.multicast_igmp_version) ||
+	    br_multicast_dump_querier_state(skb, &br->multicast_ctx,
+					    IFLA_BR_MCAST_QUERIER_STATE))
 		return -EMSGSIZE;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, IFLA_BR_MCAST_MLD_VERSION,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6ca9519f18a3..e03fc4c5f283 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -948,6 +948,10 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 		  struct netlink_ext_ack *extack);
 int br_rports_fill_info(struct sk_buff *skb,
 			const struct net_bridge_mcast *brmctx);
+int br_multicast_dump_querier_state(struct sk_buff *skb,
+				    const struct net_bridge_mcast *brmctx,
+				    int nest_attr);
+size_t br_multicast_querier_state_size(void);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
-- 
2.31.1

