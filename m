Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3951188335
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCQMKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:10:24 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39778 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgCQMKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:10:24 -0400
Received: by mail-lf1-f68.google.com with SMTP id j15so16989935lfk.6
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 05:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eeD82qOajPkDz6E23LoC90WY8WmZQtkNFWFfYrdcWyg=;
        b=U0VZhaoO8vyQWXV2M+LEhymvQTWqhoEi7/G1NfvFgQWs0XyEq+J/70fPbtE2582qhV
         xylhEpLKf2e7Q0ZImBsxeXre3tnLUb13xwjrUG42HCtywHzVhj84AUoB1uNBEtIOvzwP
         RSKrDFsQYL5GSFoSzdIY5LtJ24JNuDgz8uHeo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eeD82qOajPkDz6E23LoC90WY8WmZQtkNFWFfYrdcWyg=;
        b=GqHeZQuO5PQES28KbCBfGisQShqzf7V4RB9FyeTGynhXK8V0F7MsaFOsc1tEd4fc3c
         7WlgWQgqkPA/gDMro/7eFAXjoZLhJAMkAhR2HVV2PIUhXzDeiEIXCK83yseto1v1uMPI
         lWjgNxiQ2yQIN9pOCK6vUn19G30JKfCoq8jNY/BRzJPjwxRoC1Bk7TjNdmTq29cF/C3j
         HRoXeLfCwyedfLS2mAqqNjG0z1bjjLrs9Ip1GEy5VYYMr7MRfk1NUxQGxIbCA702tRj8
         q2FQhnuXBAMYlmpP5OayIfAxFBnNSBODJdHgM/MMzrm3z3gbJvI3cSw2JWh1sV2N+A7M
         wZcQ==
X-Gm-Message-State: ANhLgQ3njoJWV3gBSX2c9WrEXa7DnAetKgJzFnqeuRE5xTHBZ5LoiZCx
        cX1EvggGwW5rq7twTXwR08ZAN6980NA=
X-Google-Smtp-Source: ADFU+vsfUZmf9dlMHs8C4NzFlpxWJTi5sv95hJdr3027Zjb6OpaL51FdvrDynmKWmtFw3ugo7i1gWA==
X-Received: by 2002:a19:c1d2:: with SMTP id r201mr1293566lff.13.1584447021191;
        Tue, 17 Mar 2020 05:10:21 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 23sm2389208lfa.28.2020.03.17.05.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:10:13 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 4/4] net: bridge: vlan options: add support for tunnel mapping set/del
Date:   Tue, 17 Mar 2020 14:08:36 +0200
Message-Id: <20200317120836.1765164-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
References: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for manipulating vlan/tunnel mappings. The
tunnel ids are globally unique and are one per-vlan. There were two
trickier issues - first in order to support vlan ranges we have to
compute the current tunnel id in the following way:
 - base tunnel id (attr) + current vlan id - starting vlan id
This is in line how the old API does vlan/tunnel mapping with ranges. We
already have the vlan range present, so it's redundant to add another
attribute for the tunnel range end. It's simply base tunnel id + vlan
range. And second to support removing mappings we need an out-of-band way
to tell the option manipulating function because there are no
special/reserved tunnel id values, so we use a vlan flag to denote the
operation is tunnel mapping removal.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_netlink_tunnel.c |  4 ++--
 net/bridge/br_private_tunnel.h |  2 ++
 net/bridge/br_vlan.c           |  1 +
 net/bridge/br_vlan_options.c   | 39 ++++++++++++++++++++++++++++++++++
 5 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 36760ff69711..54010b49c093 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -131,6 +131,7 @@ enum {
 #define BRIDGE_VLAN_INFO_RANGE_END	(1<<4) /* VLAN is end of vlan range */
 #define BRIDGE_VLAN_INFO_BRENTRY	(1<<5) /* Global bridge VLAN entry */
 #define BRIDGE_VLAN_INFO_ONLY_OPTS	(1<<6) /* Skip create/delete/flags */
+#define BRIDGE_VLAN_INFO_REMOVE_TUN	(1<<7) /* Remove tunnel mapping */
 
 struct bridge_vlan_info {
 	__u16 flags;
diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index 996a77620814..162998e2f039 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -193,8 +193,8 @@ static const struct nla_policy vlan_tunnel_policy[IFLA_BRIDGE_VLAN_TUNNEL_MAX +
 	[IFLA_BRIDGE_VLAN_TUNNEL_FLAGS] = { .type = NLA_U16 },
 };
 
-static int br_vlan_tunnel_info(const struct net_bridge_port *p, int cmd,
-			       u16 vid, u32 tun_id, bool *changed)
+int br_vlan_tunnel_info(const struct net_bridge_port *p, int cmd,
+			u16 vid, u32 tun_id, bool *changed)
 {
 	int err = 0;
 
diff --git a/net/bridge/br_private_tunnel.h b/net/bridge/br_private_tunnel.h
index b27a0c0371f2..c54cc26211d7 100644
--- a/net/bridge/br_private_tunnel.h
+++ b/net/bridge/br_private_tunnel.h
@@ -45,6 +45,8 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan);
 bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
 			const struct net_bridge_vlan *v_last);
+int br_vlan_tunnel_info(const struct net_bridge_port *p, int cmd,
+			u16 vid, u32 tun_id, bool *changed);
 #else
 static inline int vlan_tunnel_init(struct net_bridge_vlan_group *vg)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 09bfda47fbbf..24f524536be4 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1839,6 +1839,7 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
 					    .len = sizeof(struct bridge_vlan_info) },
 	[BRIDGE_VLANDB_ENTRY_RANGE]	= { .type = NLA_U16 },
 	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
+	[BRIDGE_VLANDB_ENTRY_TUNNEL_ID] = { .type = NLA_U32 },
 };
 
 static int br_vlan_rtm_process_one(struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index d3618da32b8e..138e180cf4d8 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -85,6 +85,40 @@ static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
 	return 0;
 }
 
+static int br_vlan_modify_tunnel(const struct net_bridge_port *p,
+				 struct net_bridge_vlan *v,
+				 struct nlattr **tb,
+				 bool *changed,
+				 struct netlink_ext_ack *extack)
+{
+	struct bridge_vlan_info *vinfo;
+	int cmdmap;
+	u32 tun_id;
+
+	if (!p) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't modify tunnel mapping of non-port vlans");
+		return -EINVAL;
+	}
+	if (!(p->flags & BR_VLAN_TUNNEL)) {
+		NL_SET_ERR_MSG_MOD(extack, "Port doesn't have tunnel flag set");
+		return -EINVAL;
+	}
+
+	/* vlan info attribute is guaranteed by br_vlan_rtm_process_one */
+	vinfo = nla_data(tb[BRIDGE_VLANDB_ENTRY_INFO]);
+	cmdmap = vinfo->flags & BRIDGE_VLAN_INFO_REMOVE_TUN ? RTM_DELLINK :
+							      RTM_SETLINK;
+	/* when working on vlan ranges this represents the starting tunnel id */
+	tun_id = nla_get_u32(tb[BRIDGE_VLANDB_ENTRY_TUNNEL_ID]);
+	/* tunnel ids are mapped to each vlan in increasing order,
+	 * the starting vlan is in BRIDGE_VLANDB_ENTRY_INFO and v is the
+	 * current vlan, so we compute: tun_id + v - vinfo->vid
+	 */
+	tun_id += v->vid - vinfo->vid;
+
+	return br_vlan_tunnel_info(p, cmdmap, v->vid, tun_id, changed);
+}
+
 static int br_vlan_process_one_opts(const struct net_bridge *br,
 				    const struct net_bridge_port *p,
 				    struct net_bridge_vlan_group *vg,
@@ -103,6 +137,11 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
 		if (err)
 			return err;
 	}
+	if (tb[BRIDGE_VLANDB_ENTRY_TUNNEL_ID]) {
+		err = br_vlan_modify_tunnel(p, v, tb, changed, extack);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
-- 
2.24.1

