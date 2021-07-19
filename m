Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683863CE852
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355870AbhGSQkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347835AbhGSQgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E469C0613AF
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:56 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id hr1so29953509ejc.1
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=29TqZv5oN4lRjIuLVLlHSdl22CZNOehTdPTwu5IVoLg=;
        b=UgKnCiitiLfGRIgT44411Dx5uiabkLnWL/K6/F6ItGI+xdJa+ctfbwl6hogSiD6Qhs
         OamGHqEACBiOsrfqae9Xd0hd4qHrbOSMDUs9iCgqDXol3LxZ4s406aUFW+MS8mYS3+uV
         befDHIrIZNIzmkRRH/GDkwT18p+0nP2YYw0yN388X5vJkxVbR2Dz2PuldE5uTDgts5lm
         Vy85Tev8e/kBHccEc55MVi4sPDXrD4zwopr4HKuVad76uTF66vu6kDCqhS+HqYRQOLXL
         cV0+Myv10OjpvL1km+yTu3vyb8cVIUyBReWTIHANrG1O4GGlaijBpuJL8nEELHdH741y
         QAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=29TqZv5oN4lRjIuLVLlHSdl22CZNOehTdPTwu5IVoLg=;
        b=sCWc2kFNA+o6tSdjC9BCN0lrlJAnhdVP0TtYH3fTSb3GySRPn/6p8fwN2ndoqCWVgL
         80W0siRxkyL5ADCN9YXDeU5W+ndhDhZERWkEGSDlHGP0OTQVvm3GXN9lv/0DnLws9QrQ
         1RLFUPCa4vPeQdNMv5lmR/YVL6VE14dlLUtu4mcaD12Uy/3eu1S5W3ZdxbxGfFN/w60y
         I0eLOtx+dDJynoi9AvRAmTmkTYdsa8pCk5VP+kG9rgvu6HERO7sxB+k0g6h5VY/AYRTw
         TnvRBqCKs1nkMfDhuAbdiWDI51p24WSliNxJzYpW5AYv4BPzS9jZQanM+ObbIgeZReGD
         ZnfQ==
X-Gm-Message-State: AOAM532J5m9gei9v7jpHnKdu6yS6/tH9QUaTkgu8tC8b5Ic0GDlyQ6x1
        7ZR2BM8c5vu9961Ei86A8vUn6IJosCCfVCCDxkU=
X-Google-Smtp-Source: ABdhPJxYxJjv1X81gq8ReaRbBW1NnkwEMPa46l5HvYHHzi/S1jUnT0sViircGsm38aNkPlVYEawnfA==
X-Received: by 2002:a17:907:62a5:: with SMTP id nd37mr27649202ejc.148.1626714608131;
        Mon, 19 Jul 2021 10:10:08 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:07 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 12/15] net: bridge: vlan: add support for global options
Date:   Mon, 19 Jul 2021 20:06:34 +0300
Message-Id: <20210719170637.435541-13-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We can have two types of vlan options depending on context:
 - per-device vlan options (split in per-bridge and per-port)
 - global vlan options

The second type wasn't supported in the bridge until now, but we need
them for per-vlan multicast support, per-vlan STP support and other
options which require global vlan context. They are contained in the global
bridge vlan context even if the vlan is not configured on the bridge device
itself. This patch adds initial netlink attributes and support for setting
these global vlan options, they can only be set (RTM_NEWVLAN) and the
operation must use the bridge device. Since there are no such options yet
it shouldn't have any functional effect.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h | 13 ++++++
 net/bridge/br_private.h        |  4 ++
 net/bridge/br_vlan.c           | 16 +++++--
 net/bridge/br_vlan_options.c   | 85 ++++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 1f7513300cfe..760b264bd03d 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -485,10 +485,15 @@ enum {
  *     [BRIDGE_VLANDB_ENTRY_INFO]
  *     ...
  * }
+ * [BRIDGE_VLANDB_GLOBAL_OPTIONS] = {
+ *     [BRIDGE_VLANDB_GOPTS_ID]
+ *     ...
+ * }
  */
 enum {
 	BRIDGE_VLANDB_UNSPEC,
 	BRIDGE_VLANDB_ENTRY,
+	BRIDGE_VLANDB_GLOBAL_OPTIONS,
 	__BRIDGE_VLANDB_MAX,
 };
 #define BRIDGE_VLANDB_MAX (__BRIDGE_VLANDB_MAX - 1)
@@ -538,6 +543,14 @@ enum {
 };
 #define BRIDGE_VLANDB_STATS_MAX (__BRIDGE_VLANDB_STATS_MAX - 1)
 
+enum {
+	BRIDGE_VLANDB_GOPTS_UNSPEC,
+	BRIDGE_VLANDB_GOPTS_ID,
+	BRIDGE_VLANDB_GOPTS_RANGE,
+	__BRIDGE_VLANDB_GOPTS_MAX
+};
+#define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 5515b6c37322..bc920bc1ff44 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1605,6 +1605,10 @@ int br_vlan_process_options(const struct net_bridge *br,
 			    struct net_bridge_vlan *range_end,
 			    struct nlattr **tb,
 			    struct netlink_ext_ack *extack);
+int br_vlan_rtm_process_global_options(struct net_device *dev,
+				       const struct nlattr *attr,
+				       int cmd,
+				       struct netlink_ext_ack *extack);
 
 /* vlan state manipulation helpers using *_ONCE to annotate lock-free access */
 static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index ab4969a4a380..dcb5acf783d2 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2203,12 +2203,22 @@ static int br_vlan_rtm_process(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	nlmsg_for_each_attr(attr, nlh, sizeof(*bvm), rem) {
-		if (nla_type(attr) != BRIDGE_VLANDB_ENTRY)
+		switch (nla_type(attr)) {
+		case BRIDGE_VLANDB_ENTRY:
+			err = br_vlan_rtm_process_one(dev, attr,
+						      nlh->nlmsg_type,
+						      extack);
+			break;
+		case BRIDGE_VLANDB_GLOBAL_OPTIONS:
+			err = br_vlan_rtm_process_global_options(dev, attr,
+								 nlh->nlmsg_type,
+								 extack);
+			break;
+		default:
 			continue;
+		}
 
 		vlans++;
-		err = br_vlan_rtm_process_one(dev, attr, nlh->nlmsg_type,
-					      extack);
 		if (err)
 			break;
 	}
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index b4add9ea8964..a7d5a2334207 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -258,3 +258,88 @@ int br_vlan_process_options(const struct net_bridge *br,
 
 	return err;
 }
+
+static int br_vlan_process_global_one_opts(const struct net_bridge *br,
+					   struct net_bridge_vlan_group *vg,
+					   struct net_bridge_vlan *v,
+					   struct nlattr **tb,
+					   bool *changed,
+					   struct netlink_ext_ack *extack)
+{
+	*changed = false;
+	return 0;
+}
+
+static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
+	[BRIDGE_VLANDB_GOPTS_ID]	= { .type = NLA_U16 },
+	[BRIDGE_VLANDB_GOPTS_RANGE]	= { .type = NLA_U16 },
+};
+
+int br_vlan_rtm_process_global_options(struct net_device *dev,
+				       const struct nlattr *attr,
+				       int cmd,
+				       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[BRIDGE_VLANDB_GOPTS_MAX + 1];
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+	u16 vid, vid_range = 0;
+	struct net_bridge *br;
+	int err = 0;
+
+	if (cmd != RTM_NEWVLAN) {
+		NL_SET_ERR_MSG_MOD(extack, "Global vlan options support only set operation");
+		return -EINVAL;
+	}
+	if (!netif_is_bridge_master(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Global vlan options can only be set on bridge device");
+		return -EINVAL;
+	}
+	br = netdev_priv(dev);
+	vg = br_vlan_group(br);
+	if (WARN_ON(!vg))
+		return -ENODEV;
+
+	err = nla_parse_nested(tb, BRIDGE_VLANDB_GOPTS_MAX, attr,
+			       br_vlan_db_gpol, extack);
+	if (err)
+		return err;
+
+	if (!tb[BRIDGE_VLANDB_GOPTS_ID]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing vlan entry id");
+		return -EINVAL;
+	}
+	vid = nla_get_u16(tb[BRIDGE_VLANDB_GOPTS_ID]);
+	if (!br_vlan_valid_id(vid, extack))
+		return -EINVAL;
+
+	if (tb[BRIDGE_VLANDB_GOPTS_RANGE]) {
+		vid_range = nla_get_u16(tb[BRIDGE_VLANDB_GOPTS_RANGE]);
+		if (!br_vlan_valid_id(vid_range, extack))
+			return -EINVAL;
+		if (vid >= vid_range) {
+			NL_SET_ERR_MSG_MOD(extack, "End vlan id is less than or equal to start vlan id");
+			return -EINVAL;
+		}
+	} else {
+		vid_range = vid;
+	}
+
+	for (; vid <= vid_range; vid++) {
+		bool changed = false;
+
+		v = br_vlan_find(vg, vid);
+		if (!v) {
+			NL_SET_ERR_MSG_MOD(extack, "Vlan in range doesn't exist, can't process global options");
+			err = -ENOENT;
+			break;
+		}
+
+		err = br_vlan_process_global_one_opts(br, vg, v, tb, &changed,
+						      extack);
+		if (err)
+			break;
+	}
+
+	return err;
+}
-- 
2.31.1

