Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02A93CE850
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355852AbhGSQkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347655AbhGSQgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:37 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FF1C078815
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l1so24920622edr.11
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0cS0ncWc6bcud+3qIs2YIyb5eyTBqx/ONuOdJC+NdZ8=;
        b=UszvjO2bAF8To5WUKaEzDzCq0pmMgN/8dpu4fz8lD0zmDqPyKcT1SPHVb8LEuiaxKA
         aFK2V8By8nwabDkVkvuRa2KANVRNZWPD2otll2rSq8a79oQ46lDyW5W578d4yzPDvL7K
         NH9UPI6fbpeRKvT1G/5YafzafB2Bm2UuAq9MVVRytvIUB0xQKCD4hjR79zGtqrLzl/Vy
         NK6SYxzWBelUXjoJCflVm8EFPJBdcG1g/u06lp0Zzwp+BZ3l8KL/ohJ5rQPkMRO/NLz9
         ChsvE1MeoBnRNoXCIpa9lCZ6OddOX0tolZEkveTyQZVY99tt2jXnbtvlvuGDrOiLt7sy
         mZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0cS0ncWc6bcud+3qIs2YIyb5eyTBqx/ONuOdJC+NdZ8=;
        b=qeDf8O/wm9OsAGWGJL3W68N/C0hGNLosv9h2D1mbFYlxoFGqH8kT2h36NQEWoLrCGd
         tiWKZUSXQCSSIPEX6KVSuA/CJajQ8gR63Ge/1uZ35RZOyEkMftuzpJNQIZPFHATov0dA
         RIDj2ZWPLrA26PoCt2/NP11H9zKq9UPOCZQAvzELcdkdcItx1VGrisljbq/UYFuXN2ai
         GMpvI0BicaphwC6ynPMeDOHm/y7SRsYuCld0BwPR6JcbZQBf/ZWTFTnH5aT5Jb+m5Rsf
         PHt8wwKoYDza42lyF9al2ZQkVelLYifRAqkdKhX0ftyB1C/ZGZq8yxHBmQSCr4lnx/n2
         7rwA==
X-Gm-Message-State: AOAM530Ex+CVA0qJGTmdbN/kYOPk+DpG4JoejblnFBWszgn04+gd0dFY
        WiugCkx735HHjiz5hwMdl0uOmH13Ia8glEznaOM=
X-Google-Smtp-Source: ABdhPJyS+jybb2Yn3IdrVTn1U3OuNfySNDv14l/F42JYIT7JS/v+HCbFpFRqLJ8/0pHAlOxVOxIKoA==
X-Received: by 2002:a50:fd17:: with SMTP id i23mr35868122eds.270.1626714610878;
        Mon, 19 Jul 2021 10:10:10 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:10 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 15/15] net: bridge: vlan: add mcast snooping control
Date:   Mon, 19 Jul 2021 20:06:37 +0300
Message-Id: <20210719170637.435541-16-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a new global vlan option which controls whether multicast snooping
is enabled or disabled for a single vlan. It controls the vlan private
flag: BR_VLFLAG_GLOBAL_MCAST_ENABLED.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_multicast.c      | 16 ++++++++++++++++
 net/bridge/br_private.h        |  7 +++++++
 net/bridge/br_vlan_options.c   | 24 +++++++++++++++++++++++-
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 2203eb749d31..f7997a3f7f82 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -548,6 +548,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_UNSPEC,
 	BRIDGE_VLANDB_GOPTS_ID,
 	BRIDGE_VLANDB_GOPTS_RANGE,
+	BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index fb5e5df571fd..976491951c82 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3988,6 +3988,22 @@ int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 	return 0;
 }
 
+bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan, bool on)
+{
+	ASSERT_RTNL();
+
+	/* BR_VLFLAG_GLOBAL_MCAST_ENABLED relies on eventual consistency and
+	 * requires only RTNL to change
+	 */
+	if (on == !!(vlan->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED))
+		return false;
+
+	vlan->priv_flags ^= BR_VLFLAG_GLOBAL_MCAST_ENABLED;
+	br_multicast_toggle_vlan(vlan, on);
+
+	return true;
+}
+
 void br_multicast_stop(struct net_bridge *br)
 {
 	ASSERT_RTNL();
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e0a982275a93..af1f5c1c6b88 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -922,6 +922,7 @@ void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on);
 void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan, bool on);
 int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 				      struct netlink_ext_ack *extack);
+bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan, bool on);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
@@ -1295,6 +1296,12 @@ static inline int br_multicast_toggle_vlan_snooping(struct net_bridge *br,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan,
+						   bool on)
+{
+	return false;
+}
 #endif
 
 /* br_vlan.c */
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 827bfc319599..4ef975b20185 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -262,7 +262,9 @@ int br_vlan_process_options(const struct net_bridge *br,
 bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
 					 const struct net_bridge_vlan *r_end)
 {
-	return v_curr->vid - r_end->vid == 1;
+	return v_curr->vid - r_end->vid == 1 &&
+	       ((v_curr->priv_flags ^ r_end->priv_flags) &
+		BR_VLFLAG_GLOBAL_MCAST_ENABLED) == 0;
 }
 
 bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
@@ -281,6 +283,12 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	    nla_put_u16(skb, BRIDGE_VLANDB_GOPTS_RANGE, vid_range))
 		goto out_err;
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING,
+		       !!(v_opts->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED)))
+		goto out_err;
+#endif
+
 	nla_nest_end(skb, nest);
 
 	return true;
@@ -295,6 +303,9 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 	return NLMSG_ALIGN(sizeof(struct br_vlan_msg))
 		+ nla_total_size(0) /* BRIDGE_VLANDB_GLOBAL_OPTIONS */
 		+ nla_total_size(sizeof(u16)) /* BRIDGE_VLANDB_GOPTS_ID */
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING */
+#endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
 
@@ -349,12 +360,23 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 					   struct netlink_ext_ack *extack)
 {
 	*changed = false;
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING]) {
+		u8 mc_snooping;
+
+		mc_snooping = nla_get_u8(tb[BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING]);
+		if (br_multicast_toggle_global_vlan(v, !!mc_snooping))
+			*changed = true;
+	}
+#endif
+
 	return 0;
 }
 
 static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_ID]	= { .type = NLA_U16 },
 	[BRIDGE_VLANDB_GOPTS_RANGE]	= { .type = NLA_U16 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING]	= { .type = NLA_U8 },
 };
 
 int br_vlan_rtm_process_global_options(struct net_device *dev,
-- 
2.31.1

