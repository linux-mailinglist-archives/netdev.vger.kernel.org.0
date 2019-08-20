Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B0595F34
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 14:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfHTMwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 08:52:09 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41350 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729203AbfHTMwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 08:52:09 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Aug 2019 15:52:02 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7KCq2wO009694;
        Tue, 20 Aug 2019 15:52:02 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: Set OvS recirc_id from tc chain index
Date:   Tue, 20 Aug 2019 15:51:55 +0300
Message-Id: <1566305515-25008-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1566304251-15795-1-git-send-email-paulb@mellanox.com>
References: <1566304251-15795-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regarding the user_features change, I tested the above patch with this one in
userspace that I'll send once this is accepted, togother with the rest
of connection tracking offload patches.

I also have a test for it, if anyone wants it.

Patch is:
lib/netdev-offloads-tc: Probe recirc tc sharing feature on first recirc_id rule

Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 datapath/linux/compat/include/linux/openvswitch.h |  3 ++
 lib/dpif-netdev.c                                 |  1 +
 lib/dpif-netlink.c                                | 61 +++++++++++++++++++----
 lib/dpif-provider.h                               |  2 +
 lib/dpif.c                                        |  9 ++++
 lib/dpif.h                                        |  2 +
 lib/netdev-offload-tc.c                           | 33 ++++++++++--
 lib/netdev-offload.h                              |  2 +-
 8 files changed, 100 insertions(+), 13 deletions(-)

diff --git a/datapath/linux/compat/include/linux/openvswitch.h b/datapath/linux/compat/include/linux/openvswitch.h
index 65a003a..921ef5b 100644
--- a/datapath/linux/compat/include/linux/openvswitch.h
+++ b/datapath/linux/compat/include/linux/openvswitch.h
@@ -143,6 +143,9 @@ struct ovs_vport_stats {
 /* Allow datapath to associate multiple Netlink PIDs to each vport */
 #define OVS_DP_F_VPORT_PIDS	(1 << 1)
 
+/* Allow tc offload recirc sharing */
+#define OVS_DP_F_TC_RECIRC_SHARING  (1 << 2)
+
 /* Fixed logical ports. */
 #define OVSP_LOCAL      ((__u32)0)
 
diff --git a/lib/dpif-netdev.c b/lib/dpif-netdev.c
index d0a1c58..fd8275f 100644
--- a/lib/dpif-netdev.c
+++ b/lib/dpif-netdev.c
@@ -7489,6 +7489,7 @@ const struct dpif_class dpif_netdev_class = {
     dpif_netdev_run,
     dpif_netdev_wait,
     dpif_netdev_get_stats,
+    NULL,                      /* set_features */
     dpif_netdev_port_add,
     dpif_netdev_port_del,
     dpif_netdev_port_set_config,
diff --git a/lib/dpif-netlink.c b/lib/dpif-netlink.c
index 07a9ddd..15e6057 100644
--- a/lib/dpif-netlink.c
+++ b/lib/dpif-netlink.c
@@ -192,6 +192,7 @@ struct dpif_handler {
 struct dpif_netlink {
     struct dpif dpif;
     int dp_ifindex;
+    uint32_t user_features;
 
     /* Upcall messages. */
     struct fat_rwlock upcall_lock;
@@ -303,7 +304,6 @@ dpif_netlink_enumerate(struct sset *all_dps,
     if (error) {
         return error;
     }
-
     ofpbuf_use_stub(&buf, reply_stub, sizeof reply_stub);
     dpif_netlink_dp_dump_start(&dump);
     while (nl_dump_next(&dump, &msg, &buf)) {
@@ -333,15 +333,26 @@ dpif_netlink_open(const struct dpif_class *class OVS_UNUSED, const char *name,
 
     /* Create or look up datapath. */
     dpif_netlink_dp_init(&dp_request);
+    upcall_pid = 0;
+    dp_request.upcall_pid = &upcall_pid;
+    dp_request.name = name;
+
     if (create) {
         dp_request.cmd = OVS_DP_CMD_NEW;
-        upcall_pid = 0;
-        dp_request.upcall_pid = &upcall_pid;
     } else {
+        dp_request.cmd = OVS_DP_CMD_GET;
+
+        error = dpif_netlink_dp_transact(&dp_request, &dp, &buf);
+        if (error)  {
+            return error;
+        }
+        dp_request.user_features = dp.user_features;
+        ofpbuf_delete(buf);
+
         /* Use OVS_DP_CMD_SET to report user features */
         dp_request.cmd = OVS_DP_CMD_SET;
     }
-    dp_request.name = name;
+
     dp_request.user_features |= OVS_DP_F_UNALIGNED;
     dp_request.user_features |= OVS_DP_F_VPORT_PIDS;
     error = dpif_netlink_dp_transact(&dp_request, &dp, &buf);
@@ -367,6 +378,7 @@ open_dpif(const struct dpif_netlink_dp *dp, struct dpif **dpifp)
               dp->dp_ifindex, dp->dp_ifindex);
 
     dpif->dp_ifindex = dp->dp_ifindex;
+    dpif->user_features = dp->user_features;
     *dpifp = &dpif->dpif;
 
     return 0;
@@ -662,6 +674,31 @@ dpif_netlink_get_stats(const struct dpif *dpif_, struct dpif_dp_stats *stats)
     return error;
 }
 
+static int
+dpif_netlink_set_features(struct dpif *dpif_, uint32_t new_features)
+{
+    struct dpif_netlink *dpif = dpif_netlink_cast(dpif_);
+    struct dpif_netlink_dp request, reply;
+    struct ofpbuf *bufp;
+    int error;
+
+    dpif_netlink_dp_init(&request);
+    request.cmd = OVS_DP_CMD_SET;
+    request.dp_ifindex = dpif->dp_ifindex;
+    request.user_features = dpif->user_features | new_features;
+
+    error = dpif_netlink_dp_transact(&request, &reply, &bufp);
+    if (!error) {
+        dpif->user_features = reply.user_features;
+        ofpbuf_delete(bufp);
+        if (!(dpif->user_features & new_features)) {
+            return -EOPNOTSUPP;
+        }
+    }
+
+    return error;
+}
+
 static const char *
 get_vport_type(const struct dpif_netlink_vport *vport)
 {
@@ -1989,7 +2026,6 @@ static int
 parse_flow_put(struct dpif_netlink *dpif, struct dpif_flow_put *put)
 {
     static struct vlog_rate_limit rl = VLOG_RATE_LIMIT_INIT(5, 20);
-    const struct dpif_class *dpif_class = dpif->dpif.dpif_class;
     struct match match;
     odp_port_t in_port;
     const struct nlattr *nla;
@@ -2011,7 +2047,7 @@ parse_flow_put(struct dpif_netlink *dpif, struct dpif_flow_put *put)
     }
 
     in_port = match.flow.in_port.odp_port;
-    dev = netdev_ports_get(in_port, dpif_class);
+    dev = netdev_ports_get(in_port, dpif->dpif.dpif_class);
     if (!dev) {
         return EOPNOTSUPP;
     }
@@ -2024,7 +2060,7 @@ parse_flow_put(struct dpif_netlink *dpif, struct dpif_flow_put *put)
             odp_port_t out_port;
 
             out_port = nl_attr_get_odp_port(nla);
-            outdev = netdev_ports_get(out_port, dpif_class);
+            outdev = netdev_ports_get(out_port, dpif->dpif.dpif_class);
             if (!outdev) {
                 err = EOPNOTSUPP;
                 goto out;
@@ -2040,7 +2076,7 @@ parse_flow_put(struct dpif_netlink *dpif, struct dpif_flow_put *put)
         }
     }
 
-    info.dpif_class = dpif_class;
+    info.dpif = &dpif->dpif;
     info.tp_dst_port = dst_port;
     info.tunnel_csum_on = csum_on;
     err = netdev_flow_put(dev, &match,
@@ -3394,6 +3430,7 @@ const struct dpif_class dpif_netlink_class = {
     dpif_netlink_run,
     NULL,                       /* wait */
     dpif_netlink_get_stats,
+    dpif_netlink_set_features,
     dpif_netlink_port_add,
     dpif_netlink_port_del,
     NULL,                       /* port_set_config */
@@ -3702,6 +3739,9 @@ dpif_netlink_dp_from_ofpbuf(struct dpif_netlink_dp *dp, const struct ofpbuf *buf
         [OVS_DP_ATTR_MEGAFLOW_STATS] = {
                         NL_POLICY_FOR(struct ovs_dp_megaflow_stats),
                         .optional = true },
+        [OVS_DP_ATTR_USER_FEATURES] = {
+                        .type = NL_A_U32,
+                        .optional = true },
     };
 
     dpif_netlink_dp_init(dp);
@@ -3730,6 +3770,10 @@ dpif_netlink_dp_from_ofpbuf(struct dpif_netlink_dp *dp, const struct ofpbuf *buf
         dp->megaflow_stats = nl_attr_get(a[OVS_DP_ATTR_MEGAFLOW_STATS]);
     }
 
+    if (a[OVS_DP_ATTR_USER_FEATURES]) {
+        dp->user_features = nl_attr_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
+    }
+
     return 0;
 }
 
@@ -3802,7 +3846,6 @@ dpif_netlink_dp_transact(const struct dpif_netlink_dp *request,
     dpif_netlink_dp_to_ofpbuf(request, request_buf);
     error = nl_transact(NETLINK_GENERIC, request_buf, bufp);
     ofpbuf_delete(request_buf);
-
     if (reply) {
         dpif_netlink_dp_init(reply);
         if (!error) {
diff --git a/lib/dpif-provider.h b/lib/dpif-provider.h
index 12898b9..8c8bc77 100644
--- a/lib/dpif-provider.h
+++ b/lib/dpif-provider.h
@@ -187,6 +187,8 @@ struct dpif_class {
     /* Retrieves statistics for 'dpif' into 'stats'. */
     int (*get_stats)(const struct dpif *dpif, struct dpif_dp_stats *stats);
 
+    int (*set_features)(struct dpif *dpif, uint32_t user_features);
+
     /* Adds 'netdev' as a new port in 'dpif'.  If '*port_no' is not
      * ODPP_NONE, attempts to use that as the port's port number.
      *
diff --git a/lib/dpif.c b/lib/dpif.c
index c88b210..dc13655 100644
--- a/lib/dpif.c
+++ b/lib/dpif.c
@@ -543,6 +543,15 @@ dpif_get_dp_stats(const struct dpif *dpif, struct dpif_dp_stats *stats)
     return error;
 }
 
+int
+dpif_set_features(struct dpif *dpif, uint32_t new_features)
+{
+    int error = dpif->dpif_class->set_features(dpif, new_features);
+
+    log_operation(dpif, "set_features", error);
+    return error;
+}
+
 const char *
 dpif_port_open_type(const char *datapath_type, const char *port_type)
 {
diff --git a/lib/dpif.h b/lib/dpif.h
index 289d574..c7bb48f 100644
--- a/lib/dpif.h
+++ b/lib/dpif.h
@@ -435,6 +435,8 @@ struct dpif_dp_stats {
 };
 int dpif_get_dp_stats(const struct dpif *, struct dpif_dp_stats *);
 
+int dpif_set_features(struct dpif *, uint32_t new_features);
+
 
 /* Port operations. */
 
diff --git a/lib/netdev-offload-tc.c b/lib/netdev-offload-tc.c
index 60d5a42..4e85585 100644
--- a/lib/netdev-offload-tc.c
+++ b/lib/netdev-offload-tc.c
@@ -38,6 +38,7 @@
 #include "tc.h"
 #include "unaligned.h"
 #include "util.h"
+#include "dpif-provider.h"
 
 VLOG_DEFINE_THIS_MODULE(netdev_offload_tc);
 
@@ -1354,6 +1355,25 @@ flower_match_to_tun_opt(struct tc_flower *flower, const struct flow_tnl *tnl,
     flower->mask.tunnel.metadata.present.len = tnl->metadata.present.len;
 }
 
+static bool
+recirc_id_sharing_support(struct dpif *dpif)
+{
+    static struct ovsthread_once once = OVSTHREAD_ONCE_INITIALIZER;
+    static bool supported = false;
+    int err;
+
+    if (ovsthread_once_start(&once)) {
+        err = dpif_set_features(dpif, OVS_DP_F_TC_RECIRC_SHARING);
+        supported = err ? supported : true;
+        if (supported) {
+            VLOG_INFO("probe tc: tc recirc id sharing with OvS datapath is supported.");
+        }
+        ovsthread_once_done(&once);
+    }
+
+    return supported;
+}
+
 static int
 netdev_tc_flow_put(struct netdev *netdev, struct match *match,
                    struct nlattr *actions, size_t actions_len,
@@ -1371,7 +1391,7 @@ netdev_tc_flow_put(struct netdev *netdev, struct match *match,
     uint32_t block_id = 0;
     struct nlattr *nla;
     struct tc_id id;
-    uint32_t chain;
+    uint32_t chain = 0;
     size_t left;
     int prio = 0;
     int ifindex;
@@ -1386,7 +1406,13 @@ netdev_tc_flow_put(struct netdev *netdev, struct match *match,
 
     memset(&flower, 0, sizeof flower);
 
-    chain = key->recirc_id;
+    if (key->recirc_id) {
+        if (recirc_id_sharing_support(info->dpif)) {
+            chain = key->recirc_id;
+        } else {
+            return -EOPNOTSUPP;
+        }
+    }
     mask->recirc_id = 0;
 
     if (flow_tnl_dst_is_set(&key->tunnel)) {
@@ -1634,7 +1660,8 @@ netdev_tc_flow_put(struct netdev *netdev, struct match *match,
         action = &flower.actions[flower.action_count];
         if (nl_attr_type(nla) == OVS_ACTION_ATTR_OUTPUT) {
             odp_port_t port = nl_attr_get_odp_port(nla);
-            struct netdev *outdev = netdev_ports_get(port, info->dpif_class);
+            struct netdev *outdev = netdev_ports_get(port,
+                                                     info->dpif->dpif_class);
 
             action->out.ifindex_out = netdev_get_ifindex(outdev);
             action->out.ingress = is_internal_port(netdev_get_type(outdev));
diff --git a/lib/netdev-offload.h b/lib/netdev-offload.h
index 97a5006..d852fe2 100644
--- a/lib/netdev-offload.h
+++ b/lib/netdev-offload.h
@@ -62,7 +62,7 @@ struct netdev_flow_dump {
 
 /* Flow offloading. */
 struct offload_info {
-    const struct dpif_class *dpif_class;
+    struct dpif *dpif;
     ovs_be16 tp_dst_port; /* Destination port for tunnel in SET action */
     uint8_t tunnel_csum_on; /* Tunnel header with checksum */
 
-- 
1.8.3.1

