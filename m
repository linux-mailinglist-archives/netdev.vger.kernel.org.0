Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A69559F05
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 19:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiFXQ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiFXQz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:55:59 -0400
Received: from mail.yonan.net (mail.yonan.net [54.244.116.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEC14755A
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:55:59 -0700 (PDT)
Received: from unless.localdomain (unknown [76.130.91.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.yonan.net (Postfix) with ESMTPSA id 9651F3ECF5;
        Fri, 24 Jun 2022 16:55:58 +0000 (UTC)
From:   James Yonan <james@openvpn.net>
To:     netdev@vger.kernel.org
Cc:     therbert@google.com, James Yonan <james@openvpn.net>
Subject: [PATCH net-next] rfs: added /proc/sys/net/core/rps_allow_ooo flag to tweak flow alg
Date:   Fri, 24 Jun 2022 10:54:47 -0600
Message-Id: <20220624165447.3814355-1-james@openvpn.net>
X-Mailer: git-send-email 2.25.1
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

rps_allow_ooo (0|1, default=0) -- if set to 1, allow RFS
(receive flow steering) to move a flow to a new CPU even
if the old CPU queue has pending packets.  Note that this
can result in packets being delivered out-of-order.  If set
to 0 (the default), the previous behavior is retained, where
flows will not be moved as long as pending packets remain.

The motivation for this patch is that while it's good to
prevent out-of-order packets, the current RFS logic requires
that all previous packets for the flow have been dequeued
before an RFS CPU switch is made, so as to preserve in-order
delivery.  In some cases, on links with heavy VPN traffic,
we have observed that this requirement is too onerous, and
that it prevents an RFS CPU switch from occurring within a
reasonable time frame if heavy traffic causes the old CPU
queue to never fully drain.

So rps_allow_ooo allows the user to select the tradeoff
between a more aggressive RFS steering policy that may
reorder packets on a CPU switch event (rps_allow_ooo=1)
vs. one that prioritizes in-order delivery (rps_allow_ooo=0).

Signed-off-by: James Yonan <james@openvpn.net>
---
 Documentation/networking/scaling.rst | 12 ++++++++++++
 include/linux/netdevice.h            |  1 +
 net/core/dev.c                       |  5 ++++-
 net/core/sysctl_net_core.c           |  9 +++++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index 3d435caa3ef2..371b9aaddf81 100644
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
+user to select the tradeoff between a more aggressive steering algorithm
+that can potentially reorder packets (rps_allow_ooo=1) vs. one that
+prioritizes in-order delivery (rps_allow_ooo=0).
 
 RFS Configuration
 -----------------
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 89afa4f7747d..556efe223c17 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -715,6 +715,7 @@ struct rps_sock_flow_table {
 
 #define RPS_NO_CPU 0xffff
 
+extern int rps_allow_ooo_sysctl;
 extern u32 rps_cpu_mask;
 extern struct rps_sock_flow_table __rcu *rps_sock_flow_table;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 978ed0622d8f..621b2cc311a6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4379,6 +4379,8 @@ struct rps_sock_flow_table __rcu *rps_sock_flow_table __read_mostly;
 EXPORT_SYMBOL(rps_sock_flow_table);
 u32 rps_cpu_mask __read_mostly;
 EXPORT_SYMBOL(rps_cpu_mask);
+int rps_allow_ooo_sysctl __read_mostly;
+EXPORT_SYMBOL(rps_allow_ooo_sysctl);
 
 struct static_key_false rps_needed __read_mostly;
 EXPORT_SYMBOL(rps_needed);
@@ -4494,6 +4496,7 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		 * If the desired CPU (where last recvmsg was done) is
 		 * different from current CPU (one in the rx-queue flow
 		 * table entry), switch if one of the following holds:
+		 *   - rps_allow_ooo_sysctl is enabled.
 		 *   - Current CPU is unset (>= nr_cpu_ids).
 		 *   - Current CPU is offline.
 		 *   - The current CPU's queue tail has advanced beyond the
@@ -4502,7 +4505,7 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		 *     have been dequeued, thus preserving in order delivery.
 		 */
 		if (unlikely(tcpu != next_cpu) &&
-		    (tcpu >= nr_cpu_ids || !cpu_online(tcpu) ||
+		    (rps_allow_ooo_sysctl || tcpu >= nr_cpu_ids || !cpu_online(tcpu) ||
 		     ((int)(per_cpu(softnet_data, tcpu).input_queue_head -
 		      rflow->last_qtail)) >= 0)) {
 			tcpu = next_cpu;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 71a13596ea2b..4fd9e61c2adf 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -470,6 +470,15 @@ static struct ctl_table net_core_table[] = {
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

