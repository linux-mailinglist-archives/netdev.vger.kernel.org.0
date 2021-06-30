Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720463B8073
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 11:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhF3J4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 05:56:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233943AbhF3J4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 05:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625046833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7AhVGRapRt3EPe3iUATWGIlw9+M4aPOluQn8TTO//yM=;
        b=TDrCtwfyJfDnM4H+zR9LswLUN7nMvrZex3KoKlcFnnbK62qsrLnJcL+1j14Xm9lKlqOkge
        ZvcXIBnclGSenrTBt+VeF2eDYfG+OIeUJ665Iats8208v3Xwsn8weLnf2zqT4LicRpSocu
        qQnFGzwyaMnHOQEzHoisKJv158IqwQE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-3rmXO6iFNTKzm1LknL-M3g-1; Wed, 30 Jun 2021 05:53:52 -0400
X-MC-Unique: 3rmXO6iFNTKzm1LknL-M3g-1
Received: by mail-qt1-f200.google.com with SMTP id c17-20020ac87dd10000b0290250fd339409so806037qte.6
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 02:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7AhVGRapRt3EPe3iUATWGIlw9+M4aPOluQn8TTO//yM=;
        b=RkdIqd5XluqnFbQNnbwB3mIoRr6B2qKm72sYyzuG5iEWHszXxVmnGzsasLuz88z0kw
         I0GV05Y9NitlR2DTvxC4HkZi7lb6yddbPNYJpiyL2tDOlixmA1ixCZiOi8nVPiKlIhKf
         fUTw3c+7PzDqf8DnVg6e2Cpeu7biFt93usK4Ow/EzQaSOLUn8eJUCxm4e9pQmr77VtA5
         PURFu4i9V7d5bqveKY9F3VO4jBL0HPIYhY6sAZqMxhCM/4PmvXa4VfRBduDJW102Jyf9
         eA3ZymtP/1xjiPou+LwGLR9+j4nvExZfjaV0/BpRSBAuG6ddLv9IjqUv/vtUrBCBHpUm
         gahw==
X-Gm-Message-State: AOAM530Vf93aJH/Mn77s3M6Kh3qtaQnzabd1UEWgGXzzUh/ZoJ+nhuwc
        7bKiIxnG8For1PSsvJhmOOPjOR+z7MTHQat6o838SXQQcqyRCD5gBDfHg3w4h36dTga0EwuOk25
        gEOTfPItpndbY6gwn
X-Received: by 2002:a05:6214:2469:: with SMTP id im9mr7367149qvb.15.1625046831598;
        Wed, 30 Jun 2021 02:53:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx82y/J9ADv68l4PIcdVP5hTMjTbkaALfzmFTfSWNkDKkdTGq7WAvbYL5Fi6jdCI7JbKwkgZw==
X-Received: by 2002:a05:6214:2469:: with SMTP id im9mr7367129qvb.15.1625046831404;
        Wed, 30 Jun 2021 02:53:51 -0700 (PDT)
Received: from wsfd-netdev76.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u184sm8907929qkd.53.2021.06.30.02.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 02:53:50 -0700 (PDT)
From:   Mark Gray <mark.d.gray@redhat.com>
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     fbl@sysclose.org, dan.carpenter@oracle.com, pravin.ovn@gmail.com,
        Mark Gray <mark.d.gray@redhat.com>
Subject: [PATCH net-next] openvswitch: Introduce per-cpu upcall dispatch
Date:   Wed, 30 Jun 2021 05:53:49 -0400
Message-Id: <20210630095350.817785-1-mark.d.gray@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Open vSwitch kernel module uses the upcall mechanism to send
packets from kernel space to user space when it misses in the kernel
space flow table. The upcall sends packets via a Netlink socket.
Currently, a Netlink socket is created for every vport. In this way,
there is a 1:1 mapping between a vport and a Netlink socket.
When a packet is received by a vport, if it needs to be sent to
user space, it is sent via the corresponding Netlink socket.

This mechanism, with various iterations of the corresponding user
space code, has seen some limitations and issues:

* On systems with a large number of vports, there is a correspondingly
large number of Netlink sockets which can limit scaling.
(https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
* Packet reordering on upcalls.
(https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
* A thundering herd issue.
(https://bugzilla.redhat.com/show_bug.cgi?id=1834444)

This patch introduces an alternative, feature-negotiated, upcall
mode using a per-cpu dispatch rather than a per-vport dispatch.

In this mode, the Netlink socket to be used for the upcall is
selected based on the CPU of the thread that is executing the upcall.
In this way, it resolves the issues above as:

a) The number of Netlink sockets scales with the number of CPUs
rather than the number of vports.
b) Ordering per-flow is maintained as packets are distributed to
CPUs based on mechanisms such as RSS and flows are distributed
to a single user space thread.
c) Packets from a flow can only wake up one user space thread.

The corresponding user space code can be found at:
https://mail.openvswitch.org/pipermail/ovs-dev/2021-April/382618.html

Bugzilla: https://bugzilla.redhat.com/1844576
Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
---

Notes:
    v1 - Reworked based on Flavio's comments:
         * Fixed handling of userspace action case
         * Renamed 'struct dp_portids'
         * Fixed handling of return from kmalloc()
         * Removed check for dispatch type from ovs_dp_get_upcall_portid()
       - Reworked based on Dan's comments:
         * Fixed handling of return from kmalloc()
       - Reworked based on Pravin's comments:
         * Fixed handling of userspace action case
       - Added kfree() in destroy_dp_rcu() to cleanup netlink port ids

 include/uapi/linux/openvswitch.h |  8 ++++
 net/openvswitch/actions.c        |  6 ++-
 net/openvswitch/datapath.c       | 70 +++++++++++++++++++++++++++++++-
 net/openvswitch/datapath.h       | 20 +++++++++
 4 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 8d16744edc31..6571b57b2268 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -70,6 +70,8 @@ enum ovs_datapath_cmd {
  * set on the datapath port (for OVS_ACTION_ATTR_MISS).  Only valid on
  * %OVS_DP_CMD_NEW requests. A value of zero indicates that upcalls should
  * not be sent.
+ * OVS_DP_ATTR_PER_CPU_PIDS: Per-cpu array of PIDs for upcalls when
+ * OVS_DP_F_DISPATCH_UPCALL_PER_CPU feature is set.
  * @OVS_DP_ATTR_STATS: Statistics about packets that have passed through the
  * datapath.  Always present in notifications.
  * @OVS_DP_ATTR_MEGAFLOW_STATS: Statistics about mega flow masks usage for the
@@ -87,6 +89,9 @@ enum ovs_datapath_attr {
 	OVS_DP_ATTR_USER_FEATURES,	/* OVS_DP_F_*  */
 	OVS_DP_ATTR_PAD,
 	OVS_DP_ATTR_MASKS_CACHE_SIZE,
+	OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in per-cpu
+				     * dispatch mode
+				     */
 	__OVS_DP_ATTR_MAX
 };
 
@@ -127,6 +132,9 @@ struct ovs_vport_stats {
 /* Allow tc offload recirc sharing */
 #define OVS_DP_F_TC_RECIRC_SHARING	(1 << 2)
 
+/* Allow per-cpu dispatch of upcalls */
+#define OVS_DP_F_DISPATCH_UPCALL_PER_CPU	(1 << 3)
+
 /* Fixed logical ports. */
 #define OVSP_LOCAL      ((__u32)0)
 
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index ef15d9eb4774..f79679746c62 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -924,7 +924,11 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 			break;
 
 		case OVS_USERSPACE_ATTR_PID:
-			upcall.portid = nla_get_u32(a);
+			if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
+				upcall.portid =
+				   ovs_dp_get_upcall_portid(dp, smp_processor_id());
+			else
+				upcall.portid = nla_get_u32(a);
 			break;
 
 		case OVS_USERSPACE_ATTR_EGRESS_TUN_PORT: {
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index bc164b35e67d..8d54fa323543 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -166,6 +166,7 @@ static void destroy_dp_rcu(struct rcu_head *rcu)
 	free_percpu(dp->stats_percpu);
 	kfree(dp->ports);
 	ovs_meters_exit(dp);
+	kfree(dp->upcall_portids);
 	kfree(dp);
 }
 
@@ -239,7 +240,12 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 
 		memset(&upcall, 0, sizeof(upcall));
 		upcall.cmd = OVS_PACKET_CMD_MISS;
-		upcall.portid = ovs_vport_find_upcall_portid(p, skb);
+
+		if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
+			upcall.portid = ovs_dp_get_upcall_portid(dp, smp_processor_id());
+		else
+			upcall.portid = ovs_vport_find_upcall_portid(p, skb);
+
 		upcall.mru = OVS_CB(skb)->mru;
 		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
 		if (unlikely(error))
@@ -1594,16 +1600,67 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 
 DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
 
+int ovs_dp_set_upcall_portids(struct datapath *dp,
+			      const struct nlattr *ids)
+{
+	struct dp_nlsk_pids *old, *dp_nlsk_pids;
+
+	if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
+		return -EINVAL;
+
+	old = ovsl_dereference(dp->upcall_portids);
+
+	dp_nlsk_pids = kmalloc(sizeof(*dp_nlsk_pids) + nla_len(ids),
+			       GFP_KERNEL);
+	if (!dp_nlsk_pids)
+		return -ENOMEM;
+
+	dp_nlsk_pids->n_pids = nla_len(ids) / sizeof(u32);
+	nla_memcpy(dp_nlsk_pids->pids, ids, nla_len(ids));
+
+	rcu_assign_pointer(dp->upcall_portids, dp_nlsk_pids);
+
+	kfree_rcu(old, rcu);
+
+	return 0;
+}
+
+u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
+{
+	struct dp_nlsk_pids *dp_nlsk_pids;
+
+	dp_nlsk_pids = rcu_dereference_ovsl(dp->upcall_portids);
+
+	if (dp_nlsk_pids) {
+		if (cpu_id < dp_nlsk_pids->n_pids) {
+			return dp_nlsk_pids->pids[cpu_id];
+		} else if (dp_nlsk_pids->n_pids > 0 && cpu_id >= dp_nlsk_pids->n_pids) {
+			/* If the number of netlink PIDs is mismatched with the number of
+			 * CPUs as seen by the kernel, log this and send the upcall to an
+			 * arbitrary socket (0) in order to not drop packets
+			 */
+			pr_info_ratelimited("cpu_id mismatch with handler threads");
+			return dp_nlsk_pids->pids[cpu_id % dp_nlsk_pids->n_pids];
+		} else {
+			return 0;
+		}
+	} else {
+		return 0;
+	}
+}
+
 static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 {
 	u32 user_features = 0;
+	int err;
 
 	if (a[OVS_DP_ATTR_USER_FEATURES]) {
 		user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
 
 		if (user_features & ~(OVS_DP_F_VPORT_PIDS |
 				      OVS_DP_F_UNALIGNED |
-				      OVS_DP_F_TC_RECIRC_SHARING))
+				      OVS_DP_F_TC_RECIRC_SHARING |
+				      OVS_DP_F_DISPATCH_UPCALL_PER_CPU))
 			return -EOPNOTSUPP;
 
 #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
@@ -1624,6 +1681,15 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 
 	dp->user_features = user_features;
 
+	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU &&
+	    a[OVS_DP_ATTR_PER_CPU_PIDS]) {
+		/* Upcall Netlink Port IDs have been updated */
+		err = ovs_dp_set_upcall_portids(dp,
+						a[OVS_DP_ATTR_PER_CPU_PIDS]);
+		if (err)
+			return err;
+	}
+
 	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
 		static_branch_enable(&tc_recirc_sharing_support);
 	else
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 38f7d3e66ca6..a12a7d0168b1 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -50,6 +50,21 @@ struct dp_stats_percpu {
 	struct u64_stats_sync syncp;
 };
 
+/**
+ * struct dp_nlsk_pids - array of netlink portids of for a datapath.
+ *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
+ *                       is enabled and must be protected by rcu.
+ * @rcu: RCU callback head for deferred destruction.
+ * @n_pids: Size of @pids array.
+ * @pids: Array storing the Netlink socket PIDs indexed by CPU ID for packets
+ *       that miss the flow table.
+ */
+struct dp_nlsk_pids {
+	struct rcu_head rcu;
+	u32 n_pids;
+	u32 pids[];
+};
+
 /**
  * struct datapath - datapath for flow-based packet switching
  * @rcu: RCU callback head for deferred destruction.
@@ -61,6 +76,7 @@ struct dp_stats_percpu {
  * @net: Reference to net namespace.
  * @max_headroom: the maximum headroom of all vports in this datapath; it will
  * be used by all the internal vports in this dp.
+ * @upcall_portids: RCU protected 'struct dp_nlsk_pids'.
  *
  * Context: See the comment on locking at the top of datapath.c for additional
  * locking information.
@@ -87,6 +103,8 @@ struct datapath {
 
 	/* Switch meters. */
 	struct dp_meter_table meter_tbl;
+
+	struct dp_nlsk_pids __rcu *upcall_portids;
 };
 
 /**
@@ -243,6 +261,8 @@ int ovs_dp_upcall(struct datapath *, struct sk_buff *,
 		  const struct sw_flow_key *, const struct dp_upcall_info *,
 		  uint32_t cutlen);
 
+u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id);
+int ovs_dp_set_upcall_portids(struct datapath *dp, const struct nlattr *ids);
 const char *ovs_dp_name(const struct datapath *dp);
 struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 					 u32 portid, u32 seq, u8 cmd);
-- 
2.27.0

