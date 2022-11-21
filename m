Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1650E6323A0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiKUNcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiKUNci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:32:38 -0500
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729F92DC5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:32:34 -0800 (PST)
Received: from [192.168.16.41] (helo=fisk.sw.ru)
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <nikolay.borisov@virtuozzo.com>)
        id 1ox6th-0011Rq-2y;
        Mon, 21 Nov 2022 14:31:41 +0100
From:   Nikolay Borisov <nikolay.borisov@virtuozzo.com>
To:     nhorman@tuxdriver.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, den@virtuozzo.com, khorenko@virtuozzo.com,
        Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Subject: [PATCH net-next 2/3] drop_monitor: Add namespace filtering/reporting for hardware drops
Date:   Mon, 21 Nov 2022 15:31:31 +0200
Message-Id: <20221121133132.1837107-3-nikolay.borisov@virtuozzo.com>
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

Add support for filtering and conveying the netnamespace where a
particular drop event occured. This is counterpart to the software
drop events support that was added earlier.

Signed-off-by: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
---
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 28 ++++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 016c36b531da..c6ab91e48b2a 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -92,6 +92,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_HW_ENTRIES,			/* nested */
 	NET_DM_ATTR_HW_ENTRY,			/* nested */
 	NET_DM_ATTR_HW_TRAP_COUNT,		/* u32 */
+	NET_DM_ATTR_HW_NS,			/* u32 */
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
 	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index d8450c1ee739..e5fba0b0dd4d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -64,6 +64,7 @@ struct net_dm_stats {
 struct net_dm_hw_entry {
 	char trap_name[NET_DM_MAX_HW_TRAP_NAME_LEN];
 	u32 count;
+	u32 ns_id;
 };
 
 struct net_dm_hw_entries {
@@ -355,6 +356,9 @@ static int net_dm_hw_entry_put(struct sk_buff *msg,
 	if (nla_put_u32(msg, NET_DM_ATTR_HW_TRAP_COUNT, hw_entry->count))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NET_DM_ATTR_HW_NS, hw_entry->ns_id))
+		goto nla_put_failure;
+
 	nla_nest_end(msg, attr);
 
 	return 0;
@@ -452,6 +456,21 @@ static void net_dm_hw_summary_work(struct work_struct *work)
 	kfree(hw_entries);
 }
 
+static bool hw_entry_matches(struct net_dm_hw_entry *entry,
+			     const char *trap_name, unsigned long ns_id)
+{
+	if (net_dm_ns && entry->ns_id == net_dm_ns &&
+	    !strncmp(entry->trap_name, trap_name,
+		     NET_DM_MAX_HW_TRAP_NAME_LEN - 1))
+		return true;
+	else if (net_dm_ns == 0 && entry->ns_id == ns_id &&
+		 !strncmp(entry->trap_name, trap_name,
+			  NET_DM_MAX_HW_TRAP_NAME_LEN - 1))
+		return true;
+	else
+		return false;
+}
+
 static void
 net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 			     struct sk_buff *skb,
@@ -461,11 +480,15 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 	struct net_dm_hw_entry *hw_entry;
 	struct per_cpu_dm_data *hw_data;
 	unsigned long flags;
+	unsigned long ns_id;
 	int i;
 
 	if (metadata->trap_type == DEVLINK_TRAP_TYPE_CONTROL)
 		return;
 
+	if (net_dm_ns && dev_net(skb->dev)->ns.inum != net_dm_ns)
+		return;
+
 	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
 	spin_lock_irqsave(&hw_data->lock, flags);
 	hw_entries = hw_data->hw_entries;
@@ -473,10 +496,10 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 	if (!hw_entries)
 		goto out;
 
+	ns_id = dev_net(skb->dev)->ns.inum;
 	for (i = 0; i < hw_entries->num_entries; i++) {
 		hw_entry = &hw_entries->entries[i];
-		if (!strncmp(hw_entry->trap_name, metadata->trap_name,
-			     NET_DM_MAX_HW_TRAP_NAME_LEN - 1)) {
+		if (hw_entry_matches(hw_entry, metadata->trap_name, ns_id)) {
 			hw_entry->count++;
 			goto out;
 		}
@@ -489,6 +512,7 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 		NET_DM_MAX_HW_TRAP_NAME_LEN - 1);
 	hw_entry->count = 1;
 	hw_entries->num_entries++;
+	hw_entry->ns_id = ns_id;
 
 	if (!timer_pending(&hw_data->send_timer)) {
 		hw_data->send_timer.expires = jiffies + dm_delay * HZ;
-- 
2.34.1

