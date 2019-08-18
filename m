Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A1C9179C
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfHRQBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 12:01:10 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55501 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726097AbfHRQBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 12:01:09 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 18 Aug 2019 19:01:07 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7IG16Ev019657;
        Sun, 18 Aug 2019 19:01:06 +0300
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
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc chain
Date:   Sun, 18 Aug 2019 19:00:59 +0300
Message-Id: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What do you guys say about the following diff on top of the last one?
Use static key, and also have OVS_DP_CMD_SET command probe/enable the feature.

This will allow userspace to probe the feature, and selectivly enable it via the
OVS_DP_CMD_SET command.

Thansk,
Paul.


---
 include/uapi/linux/openvswitch.h |  3 +++
 net/openvswitch/datapath.c       | 29 +++++++++++++++++++++++++----
 net/openvswitch/datapath.h       |  2 ++
 net/openvswitch/flow.c           |  6 ++++--
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index f271f1e..1887a45 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -123,6 +123,9 @@ struct ovs_vport_stats {
 /* Allow datapath to associate multiple Netlink PIDs to each vport */
 #define OVS_DP_F_VPORT_PIDS	(1 << 1)
 
+/* Allow tc offload recirc sharing */
+#define OVS_DP_F_TC_RECIRC_SHARING	(1 << 2)
+
 /* Fixed logical ports. */
 #define OVSP_LOCAL      ((__u32)0)
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 892287d..589b4f1 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1541,10 +1541,27 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb, struct genl_info *in
 	dp->user_features = 0;
 }
 
-static void ovs_dp_change(struct datapath *dp, struct nlattr *a[])
+DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
+
+static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 {
+	u32 user_features;
+
 	if (a[OVS_DP_ATTR_USER_FEATURES])
-		dp->user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
+		user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
+
+#if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	if (user_features & OVS_DP_F_TC_RECIRC_SHARING)
+		return -EOPNOTSUPP;
+#endif
+	dp->user_features = user_features;
+
+	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
+		static_branch_enable(&tc_recirc_sharing_support);
+	else
+		static_branch_disable(&tc_recirc_sharing_support);
+
+	return 0;
 }
 
 static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
@@ -1606,7 +1623,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	parms.port_no = OVSP_LOCAL;
 	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
 
-	ovs_dp_change(dp, a);
+	err = ovs_dp_change(dp, a);
+	if (err)
+		goto err_destroy_meters;
 
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
@@ -1732,7 +1751,9 @@ static int ovs_dp_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(dp))
 		goto err_unlock_free;
 
-	ovs_dp_change(dp, info->attrs);
+	err = ovs_dp_change(dp, info->attrs);
+	if (err)
+		goto err_unlock_free;
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_SET);
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 751d34a..81e85dd 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -218,6 +218,8 @@ static inline struct datapath *get_dp(struct net *net, int dp_ifindex)
 extern struct notifier_block ovs_dp_device_notifier;
 extern struct genl_family dp_vport_genl_family;
 
+DECLARE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
+
 void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key);
 void ovs_dp_detach_port(struct vport *);
 int ovs_dp_upcall(struct datapath *, struct sk_buff *,
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 0287ead..c0ac7c9 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -853,8 +853,10 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	key->mac_proto = res;
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	tc_ext = skb_ext_find(skb, TC_SKB_EXT);
-	key->recirc_id = tc_ext ? tc_ext->chain : 0;
+	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
+		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
+		key->recirc_id = tc_ext ? tc_ext->chain : 0;
+	}
 #else
 	key->recirc_id = 0;
 #endif
-- 
1.8.3.1

