Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076198498A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbfHGKbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:31:51 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45371 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729278AbfHGKbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:31:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D5ECE156D;
        Wed,  7 Aug 2019 06:31:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:31:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bhqnkCwU9JraNPNBQDBEPpIHzm5+chtMvyDx0DXte+I=; b=Af+Oq0VW
        /9TLyAa/h0okUR+H05b8bNY7cs9cifqmDR79KG7MP8thdWanqJa+s3q4ZFsKC+Fy
        Ahga3ghkPQPwL2hnqwfD3kgbTPhRTuakU9esA6aEn2cSwi4HT1rF7wcc92uXkKdZ
        WmE2xpLNoEdtGqBk9gnnB+o2ezLpsS75HNMYEhm/iOgH3fmHiozapaw6s+qNWQgy
        Pjv4FcS/RlcAB6zLKXJPDsTXTCNPFuTL4db+EITiRdNg+Q4gkxTpwracikaFnkH+
        BD+gDEGywPT7UcHbInfYwB/T2Yk9++BZOtClNSIEvdDaPdBTRHM4SXR8YysFgM8G
        55TueBohXbINGQ==
X-ME-Sender: <xms:lKhKXa7oqArDlPB8hghj8BzBk64CY53hIUOM1GG60Z_22PzakT8QAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuffhomhgrihhnpehmohguvgdrnhgvthenucfkphepudelfedrge
    ejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:lKhKXfb4cVKQ3OJLUmjS1cgdtYTnqL-IMfBp_tUnTr9L1eI2w--cLw>
    <xmx:lKhKXf4undyb84nA9VEK7aHH7VPDQzW79bwyYG0llcgzi4O4PPXzEA>
    <xmx:lKhKXSDzYvL0QP8ZxM56vvYsz80r7MmlEf-x8z28fjIgP9JE0wyYzw>
    <xmx:lKhKXXJmWAuUgsFf-P9l91THZw2D-7uB9X5hKrVUCGSvgfABCx2lHw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4729F38008E;
        Wed,  7 Aug 2019 06:31:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/10] drop_monitor: Add alert mode operations
Date:   Wed,  7 Aug 2019 13:30:54 +0300
Message-Id: <20190807103059.15270-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190807103059.15270-1-idosch@idosch.org>
References: <20190807103059.15270-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The next patch is going to add another alert mode in which the dropped
packet is notified to user space, instead of only a summary of recent
drops.

Abstract the differences between the modes by adding alert mode
operations. The operations are selected based on the currently
configured mode and associated with the probes and the work item just
before tracing starts.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  9 ++++++++
 net/core/drop_monitor.c          | 38 +++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 5edbd0a675fd..0fecdedeb6ca 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -62,4 +62,13 @@ enum {
  * Our group identifiers
  */
 #define NET_DM_GRP_ALERT 1
+
+/**
+ * enum net_dm_alert_mode - Alert mode.
+ * @NET_DM_ALERT_MODE_SUMMARY: A summary of recent drops is sent to user space.
+ */
+enum net_dm_alert_mode {
+	NET_DM_ALERT_MODE_SUMMARY,
+};
+
 #endif
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index cd2f3069f34e..9cd2f662cb9e 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -75,6 +75,16 @@ static int dm_delay = 1;
 static unsigned long dm_hw_check_delta = 2*HZ;
 static LIST_HEAD(hw_stats_list);
 
+static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
+
+struct net_dm_alert_ops {
+	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
+				void *location);
+	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
+				int work, int budget);
+	void (*work_item_func)(struct work_struct *work);
+};
+
 static struct sk_buff *reset_per_cpu_data(struct per_cpu_dm_data *data)
 {
 	size_t al;
@@ -241,10 +251,23 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
+static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
+	.kfree_skb_probe	= trace_kfree_skb_hit,
+	.napi_poll_probe	= trace_napi_poll_hit,
+	.work_item_func		= send_dm_alert,
+};
+
+static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
+	[NET_DM_ALERT_MODE_SUMMARY]	= &net_dm_alert_summary_ops,
+};
+
 static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 {
+	const struct net_dm_alert_ops *ops;
 	int cpu, rc;
 
+	ops = net_dm_alert_ops_arr[net_dm_alert_mode];
+
 	if (!try_module_get(THIS_MODULE)) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
 		return -ENODEV;
@@ -254,7 +277,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		INIT_WORK(&data->dm_alert_work, send_dm_alert);
+		INIT_WORK(&data->dm_alert_work, ops->work_item_func);
 		timer_setup(&data->send_timer, sched_send_work, 0);
 		/* Allocate a new per-CPU skb for the summary alert message and
 		 * free the old one which might contain stale data from
@@ -264,13 +287,13 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 		consume_skb(skb);
 	}
 
-	rc = register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+	rc = register_trace_kfree_skb(ops->kfree_skb_probe, NULL);
 	if (rc) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to kfree_skb() tracepoint");
 		goto err_module_put;
 	}
 
-	rc = register_trace_napi_poll(trace_napi_poll_hit, NULL);
+	rc = register_trace_napi_poll(ops->napi_poll_probe, NULL);
 	if (rc) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to napi_poll() tracepoint");
 		goto err_unregister_trace;
@@ -279,7 +302,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 	return 0;
 
 err_unregister_trace:
-	unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
 err_module_put:
 	module_put(THIS_MODULE);
 	return rc;
@@ -288,10 +311,13 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 static void net_dm_trace_off_set(void)
 {
 	struct dm_hw_stat_delta *new_stat, *temp;
+	const struct net_dm_alert_ops *ops;
 	int cpu;
 
-	unregister_trace_napi_poll(trace_napi_poll_hit, NULL);
-	unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+	ops = net_dm_alert_ops_arr[net_dm_alert_mode];
+
+	unregister_trace_napi_poll(ops->napi_poll_probe, NULL);
+	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
 
 	tracepoint_synchronize_unregister();
 
-- 
2.21.0

