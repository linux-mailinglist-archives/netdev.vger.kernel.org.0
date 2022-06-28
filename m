Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FAE55CCE8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244928AbiF1FVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244930AbiF1FVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:21:01 -0400
Received: from mail.yonan.net (mail.yonan.net [54.244.116.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DD226AE3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 22:19:02 -0700 (PDT)
Received: from unless.localdomain (unknown [76.130.91.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.yonan.net (Postfix) with ESMTPSA id 156603E947;
        Tue, 28 Jun 2022 05:19:02 +0000 (UTC)
From:   James Yonan <james@openvpn.net>
To:     netdev@vger.kernel.org
Cc:     therbert@google.com, stephen@networkplumber.org,
        James Yonan <james@openvpn.net>
Subject: [PATCH net-next v2] rfs: added /proc/sys/net/core/rps_allow_ooo flag to tweak flow alg
Date:   Mon, 27 Jun 2022 23:17:54 -0600
Message-Id: <20220628051754.365238-1-james@openvpn.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624100536.4bbc1156@hermes.local>
References: <20220624100536.4bbc1156@hermes.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rps_allow_ooo (0|1, default=0) -- if set to 1, allow RFS (receive flow
steering) to move a flow to a new CPU even if the old CPU queue has
pending packets.  Note that this can result in packets being delivered
out-of-order.  If set to 0 (the default), the previous behavior is
retained, where flows will not be moved as long as pending packets remain.

The motivation for this patch is that while it's good to prevent
out-of-order packets, the current RFS logic requires that all previous
packets for the flow have been dequeued before an RFS CPU switch is made,
so as to preserve in-order delivery.  In some cases, on links with heavy
VPN traffic, we have observed that this requirement is too onerous, and
that it prevents an RFS CPU switch from occurring within a reasonable time
frame if heavy traffic causes the old CPU queue to never fully drain.

So rps_allow_ooo allows the user to select the tradeoff between a more
aggressive RFS steering policy that may reorder packets on a CPU switch
event (rps_allow_ooo=1) vs. one that prioritizes in-order delivery
(rps_allow_ooo=0).

Patch history:

v2: based on feedback from Stephen Hemminger <stephen@networkplumber.org>,
    for clarity, refactor the big conditional in get_rps_cpu() that
    determines whether or not to switch the RPS CPU into a new inline
    function __should_reset_rps_cpu().

Signed-off-by: James Yonan <james@openvpn.net>
---
 Documentation/networking/scaling.rst | 12 ++++++
 include/linux/netdevice.h            |  1 +
 net/core/dev.c                       | 58 +++++++++++++++++++++-------
 net/core/sysctl_net_core.c           |  9 +++++
 4 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index f78d7bf27ff5..2c2e9007a5e0 100644
--- a/Documentation/networking/scaling.rst
+++ b/Documentation/networking/scaling.rst
@@ -313,6 +313,18 @@ there are no packets outstanding on the old CPU, as the outstanding
 packets could arrive later than those about to be processed on the new
 CPU.
 
+However, in some cases it may be desirable to relax the requirement
+that a flow only moves to a new CPU when there are no packets
+outstanding on the old CPU.  For this, we introduce::
+
+  /proc/sys/net/core/rps_allow_ooo (0|1, default=0)
+
+If set to 1, allow RFS to move a flow to a new CPU even if the old CPU
+queue has pending packets.  If set to 0 (the default), flows will not be
+moved as long as pending packets remain.  So rps_allow_ooo allows the
+user to choose the tradeoff between a more aggressive steering algorithm
+that can potentially reorder packets (rps_allow_ooo=1) vs. one that
+prioritizes in-order delivery (rps_allow_ooo=0).
 
 RFS Configuration
 -----------------
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 288a58678256..dee6a481ec0d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -710,6 +710,7 @@ struct rps_sock_flow_table {
 
 #define RPS_NO_CPU 0xffff
 
+extern int rps_allow_ooo_sysctl;
 extern u32 rps_cpu_mask;
 extern struct rps_sock_flow_table __rcu *rps_sock_flow_table;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index a03036456221..962f3931de10 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3899,6 +3899,8 @@ struct rps_sock_flow_table __rcu *rps_sock_flow_table __read_mostly;
 EXPORT_SYMBOL(rps_sock_flow_table);
 u32 rps_cpu_mask __read_mostly;
 EXPORT_SYMBOL(rps_cpu_mask);
+int rps_allow_ooo_sysctl __read_mostly;
+EXPORT_SYMBOL(rps_allow_ooo_sysctl);
 
 struct static_key_false rps_needed __read_mostly;
 EXPORT_SYMBOL(rps_needed);
@@ -3950,6 +3952,45 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 	return rflow;
 }
 
+/* Helper function used by get_rps_cpu() below.
+ * Returns true if we should reset the current
+ * RPS CPU (tcpu) to next_cpu.
+ */
+static inline bool __should_reset_rps_cpu(const struct rps_dev_flow *rflow,
+					  const u32 tcpu,
+					  const u32 next_cpu)
+{
+	/* Is the desired CPU (next_cpu, where last recvmsg was done)
+	 * the same as the current CPU (tcpu from the rx-queue flow
+	 * table entry)?
+	 */
+	if (likely(tcpu == next_cpu))
+		return false; /* no action */
+
+	/* Is rps_allow_ooo_sysctl enabled? */
+	if (rps_allow_ooo_sysctl)
+		return true;  /* reset RPS CPU to next_cpu */
+
+	/* Is current CPU unset? */
+	if (unlikely(tcpu >= nr_cpu_ids))
+		return true;  /* reset RPS CPU to next_cpu */
+
+	/* Is current CPU offline? */
+	if (unlikely(!cpu_online(tcpu)))
+		return true;  /* reset RPS CPU to next_cpu */
+
+	/* Has the current CPU's queue tail advanced beyond the
+	 * last packet that was enqueued using this table entry?
+	 * If so, this guarantees that all previous packets for the
+	 * flow have been dequeued, thus preserving in-order delivery.
+	 */
+	if ((int)(per_cpu(softnet_data, tcpu).input_queue_head -
+		  rflow->last_qtail) >= 0)
+		return true;  /* reset RPS CPU to next_cpu */
+
+	return false; /* no action */
+}
+
 /*
  * get_rps_cpu is called from netif_receive_skb and returns the target
  * CPU from the RPS map of the receiving queue for a given skb.
@@ -4010,21 +4051,8 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		rflow = &flow_table->flows[hash & flow_table->mask];
 		tcpu = rflow->cpu;
 
-		/*
-		 * If the desired CPU (where last recvmsg was done) is
-		 * different from current CPU (one in the rx-queue flow
-		 * table entry), switch if one of the following holds:
-		 *   - Current CPU is unset (>= nr_cpu_ids).
-		 *   - Current CPU is offline.
-		 *   - The current CPU's queue tail has advanced beyond the
-		 *     last packet that was enqueued using this table entry.
-		 *     This guarantees that all previous packets for the flow
-		 *     have been dequeued, thus preserving in order delivery.
-		 */
-		if (unlikely(tcpu != next_cpu) &&
-		    (tcpu >= nr_cpu_ids || !cpu_online(tcpu) ||
-		     ((int)(per_cpu(softnet_data, tcpu).input_queue_head -
-		      rflow->last_qtail)) >= 0)) {
+		/* Should we reset the current RPS CPU (tcpu) to next_cpu? */
+		if (__should_reset_rps_cpu(rflow, tcpu, next_cpu)) {
 			tcpu = next_cpu;
 			rflow = set_rps_cpu(dev, skb, rflow, next_cpu);
 		}
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 48041f50ecfb..20e82a432d88 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -471,6 +471,15 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= rps_sock_flow_sysctl
 	},
+	{
+		.procname	= "rps_allow_ooo",
+		.data		= &rps_allow_ooo_sysctl,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
+	},
 #endif
 #ifdef CONFIG_NET_FLOW_LIMIT
 	{
-- 
2.25.1

