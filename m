Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC048902E
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfHKHhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:37:00 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:47415 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfHKHg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:36:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3B27C197E;
        Sun, 11 Aug 2019 03:36:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bhqnkCwU9JraNPNBQDBEPpIHzm5+chtMvyDx0DXte+I=; b=S+V2zAos
        873/91KkGXGiTmz4rvGRu2ynqaGfGMQvIrRiiD1b7Kf2lCWj/kqNqh+yLtxn+JjI
        V5n8HifLqB0kpsKYCAfMFwDIstOEjjBb1xUdIaXAfzqcG6lyqh8z1pS1KA56PGO8
        wETUpAwhyXKA4drcdbxmnKVm1Fb1fBQNMUQokGMr5kWJRKOXqW4eJLIrM8Q/SHsL
        zfqmtZv8S2buD7S3aysEu2tDX9UBb8jjAsDuAUWbjjr56VajALwaTRhIYccQV9iO
        uqWebGJLINMCRUHwFhCwC22VMv2QAPGngZcL+EOIbglEQ4TWYLP7R651T3Nz52Ea
        qc0DCrwddZgKMw==
X-ME-Sender: <xms:l8VPXUBlGB380_KgDjzOHxXo6qalP9UOCp7Dm9Wce2xt--K9X7-zew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuffhomhgrihhnpehmohguvgdrnhgvthenucfkphepudelfedrge
    ejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mMVPXayRf8Ye8A7okw6RV0allfgsQcMKtFOrBappthg6SDftCB9tbw>
    <xmx:mMVPXSl7bFWds3qZ51_tKwvSQphxksSBsR8-qGuLAS4bge6p2VxXsg>
    <xmx:mMVPXfFPovylIMyx6nssPffTXFEJjicC865fktAJo73Uis8AyWu6Ig>
    <xmx:mMVPXdZiUsCs3VqqU-YxkwJPVXSe5MZHIs9-LjnkMKFW7WdMniVLsw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9181680059;
        Sun, 11 Aug 2019 03:36:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/10] drop_monitor: Add alert mode operations
Date:   Sun, 11 Aug 2019 10:35:50 +0300
Message-Id: <20190811073555.27068-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811073555.27068-1-idosch@idosch.org>
References: <20190811073555.27068-1-idosch@idosch.org>
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

