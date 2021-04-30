Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9D36FDCD
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 17:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhD3PeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 11:34:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhD3PeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 11:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619796815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jYO//jZcSi7xfYpvg3Fu6tveh1Q8j1r4Cz2NiCZ94k8=;
        b=A2ZLA8GkqVUxYIXFDHtKMZPhVvg3KLapsJ/XF+20VQmSkIce4AyCvtBmbDecUYd4YoYCBQ
        gRrVu7lEtHOerqG3bWi9R8g+Z+rytv5eir1A0BvlJ2sXMTPtCEG0QoEp6PnEUHfyCPvGdg
        tbbGRDQSKCNYhAXJ37GYVGDEZCgxBQ8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-Thpw1teBOXGCFAVEcxOJJw-1; Fri, 30 Apr 2021 11:33:32 -0400
X-MC-Unique: Thpw1teBOXGCFAVEcxOJJw-1
Received: by mail-pf1-f198.google.com with SMTP id x9-20020a056a000bc9b02902599e77f7afso24254572pfu.3
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 08:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYO//jZcSi7xfYpvg3Fu6tveh1Q8j1r4Cz2NiCZ94k8=;
        b=Qt4T4h8L7Y+kIAjLytIU3RXq/eVLeioK/iui51eYLXY1euwmzUedIj4HiQ4t/xvFtr
         6bHe5XKtGhvqV6OVDExgJ3Bk43/LWgjcLnc7SNFy2eRkrAin2gHEWghyNQCf/F6HkWFU
         OClPZCu1Pu73Ry20c9R7qat8H+71+Fzmgdife3WsYVl28mFT9Qrg0imItmxAKJmTBRFo
         CChNjvezp8HDr1o4NHdysnW1JUwbuua5+dRIPDPV95plcUlXav02Rf7k4o+i0s7oaqik
         bZEHweE2Rr8hBq5HoHittyd8H+KAv+MurnWRDGqR53vf6ZAYKsKlnJm1fBxstZJWkW13
         nnzA==
X-Gm-Message-State: AOAM53259XUHKGpG7Z8mdBgiYGIdezAuTPt9RQVR7/yNUMSFoa9tCglm
        m4LJPfrjXdDXQh7XRn22mPG8qZsz44FQmYzEUOMJDqe9DRkR3kkYHhmj1AInngB78nOUv3H6Qki
        VRuYoI9Q9iiJAXHoJsabncVVvTsTCDZwu+ZMeGGWaGSlqLNNYZeTLLv73KPUCmIhfLG3Blthi
X-Received: by 2002:a17:90a:f694:: with SMTP id cl20mr5917034pjb.67.1619796811059;
        Fri, 30 Apr 2021 08:33:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4uXOs/ibEWYxGYdiYMlaLo8q8QmOl/qzsNCnkiyoeYbWr8hvHvqoo5qKZjtyuD36x6ctdjw==
X-Received: by 2002:a17:90a:f694:: with SMTP id cl20mr5917004pjb.67.1619796810654;
        Fri, 30 Apr 2021 08:33:30 -0700 (PDT)
Received: from wsfd-netdev91.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i126sm2490718pfc.20.2021.04.30.08.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 08:33:30 -0700 (PDT)
From:   Mark Gray <mark.d.gray@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     Mark Gray <mark.d.gray@redhat.com>
Subject: [RFC net-next] openvswitch: Introduce per-cpu upcall dispatch
Date:   Fri, 30 Apr 2021 11:33:25 -0400
Message-Id: <20210430153325.28322-1-mark.d.gray@redhat.com>
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
 include/uapi/linux/openvswitch.h |  8 ++++
 net/openvswitch/datapath.c       | 70 +++++++++++++++++++++++++++++++-
 net/openvswitch/datapath.h       | 18 ++++++++
 net/openvswitch/flow_netlink.c   |  4 --
 4 files changed, 94 insertions(+), 6 deletions(-)

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
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9d6ef6cb9b26..98d54f41fdaa 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -121,6 +121,8 @@ int lockdep_ovsl_is_held(void)
 #endif
 
 static struct vport *new_vport(const struct vport_parms *);
+static u32 ovs_dp_get_upcall_portid(const struct datapath *, uint32_t);
+static int ovs_dp_set_upcall_portids(struct datapath *, const struct nlattr *);
 static int queue_gso_packets(struct datapath *dp, struct sk_buff *,
 			     const struct sw_flow_key *,
 			     const struct dp_upcall_info *,
@@ -238,7 +240,12 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 
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
@@ -1590,16 +1597,67 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 
 DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
 
+static int ovs_dp_set_upcall_portids(struct datapath *dp,
+				     const struct nlattr *ids)
+{
+	struct dp_portids *old, *dp_portids;
+
+	if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
+		return -EINVAL;
+
+	old = ovsl_dereference(dp->upcall_portids);
+
+	dp_portids = kmalloc(sizeof(*dp_portids) + nla_len(ids),
+			     GFP_KERNEL);
+	if (!dp)
+		return -ENOMEM;
+
+	dp_portids->n_ids = nla_len(ids) / sizeof(u32);
+	nla_memcpy(dp_portids->ids, ids, nla_len(ids));
+
+	rcu_assign_pointer(dp->upcall_portids, dp_portids);
+
+	if (old)
+		kfree_rcu(old, rcu);
+	return 0;
+}
+
+static u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
+{
+	struct dp_portids *dp_portids;
+
+	dp_portids = rcu_dereference_ovsl(dp->upcall_portids);
+
+	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && dp_portids) {
+		if (cpu_id < dp_portids->n_ids) {
+			return dp_portids->ids[cpu_id];
+		} else if (dp_portids->n_ids > 0 && cpu_id >= dp_portids->n_ids) {
+			/* If the number of netlink PIDs is mismatched with the number of
+			 * CPUs as seen by the kernel, log this and send the upcall to an
+			 * arbitrary socket (0) in order to not drop packets
+			 */
+			pr_info_ratelimited("cpu_id mismatch with handler threads");
+			return dp_portids->ids[0];
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
@@ -1620,6 +1678,14 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 
 	dp->user_features = user_features;
 
+	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU &&
+	    a[OVS_DP_ATTR_PER_CPU_PIDS]) {
+		/* Upcall Netlink Port IDs have been updated */
+		err = ovs_dp_set_upcall_portids(dp, a[OVS_DP_ATTR_PER_CPU_PIDS]);
+		if (err)
+			return err;
+	}
+
 	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
 		static_branch_enable(&tc_recirc_sharing_support);
 	else
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 38f7d3e66ca6..6003eba81958 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -50,6 +50,21 @@ struct dp_stats_percpu {
 	struct u64_stats_sync syncp;
 };
 
+/**
+ * struct dp_portids - array of netlink portids of for a datapath.
+ *                     This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
+ *                     is enabled and must be protected by rcu.
+ * @rcu: RCU callback head for deferred destruction.
+ * @n_ids: Size of @ids array.
+ * @ids: Array storing the Netlink socket PIDs indexed by CPU ID for packets
+ *       that miss the flow table.
+ */
+struct dp_portids {
+	struct rcu_head rcu;
+	u32 n_ids;
+	u32 ids[];
+};
+
 /**
  * struct datapath - datapath for flow-based packet switching
  * @rcu: RCU callback head for deferred destruction.
@@ -61,6 +76,7 @@ struct dp_stats_percpu {
  * @net: Reference to net namespace.
  * @max_headroom: the maximum headroom of all vports in this datapath; it will
  * be used by all the internal vports in this dp.
+ * @upcall_portids: RCU protected 'struct dp_portids'.
  *
  * Context: See the comment on locking at the top of datapath.c for additional
  * locking information.
@@ -87,6 +103,8 @@ struct datapath {
 
 	/* Switch meters. */
 	struct dp_meter_table meter_tbl;
+
+	struct dp_portids __rcu *upcall_portids;
 };
 
 /**
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index fd1f809e9bc1..97242bc1d960 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2928,10 +2928,6 @@ static int validate_userspace(const struct nlattr *attr)
 	if (error)
 		return error;
 
-	if (!a[OVS_USERSPACE_ATTR_PID] ||
-	    !nla_get_u32(a[OVS_USERSPACE_ATTR_PID]))
-		return -EINVAL;
-
 	return 0;
 }
 
-- 
2.27.0

