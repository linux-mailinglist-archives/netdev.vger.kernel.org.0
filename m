Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEDF346EBC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhCXBbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbhCXBbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FB4AC061763;
        Tue, 23 Mar 2021 18:31:11 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E954263128;
        Wed, 24 Mar 2021 02:31:02 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 04/24] net: bridge: resolve forwarding path for VLAN tag actions in bridge devices
Date:   Wed, 24 Mar 2021 02:30:35 +0100
Message-Id: <20210324013055.5619-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Depending on the VLAN settings of the bridge and the port, the bridge can
either add or remove a tag. When vlan filtering is enabled, the fdb lookup
also needs to know the VLAN tag/proto for the destination address
To provide this, keep track of the stack of VLAN tags for the path in the
lookup context

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/linux/netdevice.h | 16 ++++++++++++
 net/8021q/vlan_dev.c      |  6 +++++
 net/bridge/br_device.c    | 23 ++++++++++++++++-
 net/bridge/br_private.h   | 20 +++++++++++++++
 net/bridge/br_vlan.c      | 53 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b8b6927e04fc..ad67f26c77d8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -862,10 +862,20 @@ struct net_device_path {
 			u16		id;
 			__be16		proto;
 		} encap;
+		struct {
+			enum {
+				DEV_PATH_BR_VLAN_KEEP,
+				DEV_PATH_BR_VLAN_TAG,
+				DEV_PATH_BR_VLAN_UNTAG,
+			}		vlan_mode;
+			u16		vlan_id;
+			__be16		vlan_proto;
+		} bridge;
 	};
 };
 
 #define NET_DEVICE_PATH_STACK_MAX	5
+#define NET_DEVICE_PATH_VLAN_MAX	2
 
 struct net_device_path_stack {
 	int			num_paths;
@@ -875,6 +885,12 @@ struct net_device_path_stack {
 struct net_device_path_ctx {
 	const struct net_device *dev;
 	const u8		*daddr;
+
+	int			num_vlans;
+	struct {
+		u16		id;
+		__be16		proto;
+	} vlan[NET_DEVICE_PATH_VLAN_MAX];
 };
 
 enum tc_setup_type {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 1b1955a63f7f..4db3f0621959 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -786,6 +786,12 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->encap.proto = vlan->vlan_proto;
 	path->dev = ctx->dev;
 	ctx->dev = vlan->real_dev;
+	if (ctx->num_vlans >= ARRAY_SIZE(ctx->vlan))
+		return -ENOSPC;
+
+	ctx->vlan[ctx->num_vlans].id = vlan->vlan_id;
+	ctx->vlan[ctx->num_vlans].proto = vlan->vlan_proto;
+	ctx->num_vlans++;
 
 	return 0;
 }
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index c241719013f4..0c72503e0d39 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -396,7 +396,10 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 		return -1;
 
 	br = netdev_priv(ctx->dev);
-	f = br_fdb_find_rcu(br, ctx->daddr, 0);
+
+	br_vlan_fill_forward_path_pvid(br, ctx, path);
+
+	f = br_fdb_find_rcu(br, ctx->daddr, path->bridge.vlan_id);
 	if (!f || !f->dst)
 		return -1;
 
@@ -404,10 +407,28 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 	if (!dst)
 		return -1;
 
+	if (br_vlan_fill_forward_path_mode(br, dst, path))
+		return -1;
+
 	path->type = DEV_PATH_BRIDGE;
 	path->dev = dst->br->dev;
 	ctx->dev = dst->dev;
 
+	switch (path->bridge.vlan_mode) {
+	case DEV_PATH_BR_VLAN_TAG:
+		if (ctx->num_vlans >= ARRAY_SIZE(ctx->vlan))
+			return -ENOSPC;
+		ctx->vlan[ctx->num_vlans].id = path->bridge.vlan_id;
+		ctx->vlan[ctx->num_vlans].proto = path->bridge.vlan_proto;
+		ctx->num_vlans++;
+		break;
+	case DEV_PATH_BR_VLAN_UNTAG:
+		ctx->num_vlans--;
+		break;
+	case DEV_PATH_BR_VLAN_KEEP:
+		break;
+	}
+
 	return 0;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d7d167e10b70..50747990188e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1118,6 +1118,13 @@ void br_vlan_notify(const struct net_bridge *br,
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end);
 
+void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_device_path_ctx *ctx,
+				    struct net_device_path *path);
+int br_vlan_fill_forward_path_mode(struct net_bridge *br,
+				   struct net_bridge_port *dst,
+				   struct net_device_path *path);
+
 static inline struct net_bridge_vlan_group *br_vlan_group(
 					const struct net_bridge *br)
 {
@@ -1277,6 +1284,19 @@ static inline int nbp_get_num_vlan_infos(struct net_bridge_port *p,
 	return 0;
 }
 
+static inline void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+						  struct net_device_path_ctx *ctx,
+						  struct net_device_path *path)
+{
+}
+
+static inline int br_vlan_fill_forward_path_mode(struct net_bridge *br,
+						 struct net_bridge_port *dst,
+						 struct net_device_path *path)
+{
+	return 0;
+}
+
 static inline struct net_bridge_vlan_group *br_vlan_group(
 					const struct net_bridge *br)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 8829f621b8ec..0d09d3745e52 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1339,6 +1339,59 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
 
+void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_device_path_ctx *ctx,
+				    struct net_device_path *path)
+{
+	struct net_bridge_vlan_group *vg;
+	int idx = ctx->num_vlans - 1;
+	u16 vid;
+
+	path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+
+	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
+		return;
+
+	vg = br_vlan_group(br);
+
+	if (idx >= 0 &&
+	    ctx->vlan[idx].proto == br->vlan_proto) {
+		vid = ctx->vlan[idx].id;
+	} else {
+		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_TAG;
+		vid = br_get_pvid(vg);
+	}
+
+	path->bridge.vlan_id = vid;
+	path->bridge.vlan_proto = br->vlan_proto;
+}
+
+int br_vlan_fill_forward_path_mode(struct net_bridge *br,
+				   struct net_bridge_port *dst,
+				   struct net_device_path *path)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+
+	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
+		return 0;
+
+	vg = nbp_vlan_group_rcu(dst);
+	v = br_vlan_find(vg, path->bridge.vlan_id);
+	if (!v || !br_vlan_should_use(v))
+		return -EINVAL;
+
+	if (!(v->flags & BRIDGE_VLAN_INFO_UNTAGGED))
+		return 0;
+
+	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
+		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+	else
+		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
+
+	return 0;
+}
+
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo)
 {
-- 
2.20.1

