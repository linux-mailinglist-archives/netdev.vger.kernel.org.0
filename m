Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42C76323A2
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiKUNcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiKUNci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:32:38 -0500
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711CB1136
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:32:34 -0800 (PST)
Received: from [192.168.16.41] (helo=fisk.sw.ru)
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <nikolay.borisov@virtuozzo.com>)
        id 1ox6tg-0011Rq-Lh;
        Mon, 21 Nov 2022 14:31:40 +0100
From:   Nikolay Borisov <nikolay.borisov@virtuozzo.com>
To:     nhorman@tuxdriver.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, den@virtuozzo.com, khorenko@virtuozzo.com,
        Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Subject: [PATCH net-next 1/3] drop_monitor: Implement namespace filtering/reporting for software drops
Date:   Mon, 21 Nov 2022 15:31:30 +0200
Message-Id: <20221121133132.1837107-2-nikolay.borisov@virtuozzo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121133132.1837107-1-nikolay.borisov@virtuozzo.com>
References: <20221121133132.1837107-1-nikolay.borisov@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On hosts running multiple containers it's helpful to be able to see
in which net namespace a particular drop occured. Additionally, it's
also useful to limit drop point filtering to a single namespace,
especially for hosts which are dropping skb's at a high rate.

Signed-off-by: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
---
 include/uapi/linux/net_dropmon.h |  2 ++
 net/core/drop_monitor.c          | 36 ++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 84f622a66a7a..016c36b531da 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -8,6 +8,7 @@
 struct net_dm_drop_point {
 	__u8 pc[8];
 	__u32 count;
+	__u32 ns_id;
 };

 #define is_drop_point_hw(x) do {\
@@ -82,6 +83,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_TRUNC_LEN,			/* u32 */
 	NET_DM_ATTR_ORIG_LEN,			/* u32 */
 	NET_DM_ATTR_QUEUE_LEN,			/* u32 */
+	NET_DM_ATTR_NS,				/* u32 */
 	NET_DM_ATTR_STATS,			/* nested */
 	NET_DM_ATTR_HW_STATS,			/* nested */
 	NET_DM_ATTR_ORIGIN,			/* u16 */
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 5a782d1d8fd3..d8450c1ee739 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -103,6 +103,7 @@ static unsigned long dm_hw_check_delta = 2*HZ;
 static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
 static u32 net_dm_trunc_len;
 static u32 net_dm_queue_len = 1000;
+static u32 net_dm_ns;

 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
@@ -210,6 +211,19 @@ static void sched_send_work(struct timer_list *t)
 	schedule_work(&data->dm_alert_work);
 }

+static bool drop_point_matches(struct net_dm_drop_point *point, void *location,
+			       unsigned long ns_id)
+{
+	if (net_dm_ns && point->ns_id == net_dm_ns &&
+	    !memcmp(&location, &point->pc, sizeof(void *)))
+		return true;
+	else if (net_dm_ns == 0 && point->ns_id == ns_id &&
+		 !memcmp(&location, &point->pc, sizeof(void *)))
+		return true;
+	else
+		return false;
+}
+
 static void trace_drop_common(struct sk_buff *skb, void *location)
 {
 	struct net_dm_alert_msg *msg;
@@ -219,7 +233,11 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	int i;
 	struct sk_buff *dskb;
 	struct per_cpu_dm_data *data;
-	unsigned long flags;
+	unsigned long flags, ns_id = 0;
+
+	if (skb->dev && net_dm_ns &&
+	    dev_net(skb->dev)->ns.inum != net_dm_ns)
+		return;

 	local_irq_save(flags);
 	data = this_cpu_ptr(&dm_cpu_data);
@@ -233,8 +251,10 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	nla = genlmsg_data(nlmsg_data(nlh));
 	msg = nla_data(nla);
 	point = msg->points;
+	if (skb->dev)
+		ns_id = dev_net(skb->dev)->ns.inum;
 	for (i = 0; i < msg->entries; i++) {
-		if (!memcmp(&location, &point->pc, sizeof(void *))) {
+		if (drop_point_matches(point, location, ns_id)) {
 			point->count++;
 			goto out;
 		}
@@ -249,6 +269,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	nla->nla_len += NLA_ALIGN(sizeof(struct net_dm_drop_point));
 	memcpy(point->pc, &location, sizeof(void *));
 	point->count = 1;
+	point->ns_id = ns_id;
 	msg->entries++;

 	if (!timer_pending(&data->send_timer)) {
@@ -1283,6 +1304,14 @@ static void net_dm_trunc_len_set(struct genl_info *info)
 	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
 }

+static void net_dm_ns_set(struct genl_info *info)
+{
+	if (!info->attrs[NET_DM_ATTR_NS])
+		return;
+
+	net_dm_ns = nla_get_u32(info->attrs[NET_DM_ATTR_NS]);
+}
+
 static void net_dm_queue_len_set(struct genl_info *info)
 {
 	if (!info->attrs[NET_DM_ATTR_QUEUE_LEN])
@@ -1310,6 +1339,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,

 	net_dm_queue_len_set(info);

+	net_dm_ns_set(info);
+
 	return 0;
 }

@@ -1589,6 +1620,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
 	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
 	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
+	[NET_DM_ATTR_NS]	= { .type = NLA_U32 },
 	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
 	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
 };
--
2.34.1

