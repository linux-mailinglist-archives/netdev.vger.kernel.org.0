Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAB74C0451
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiBVWFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiBVWFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:05:22 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D79328E07
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:04:56 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id ay3so8057868plb.1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gzyN0jgi4oIxO3xd+zqCFTMQCkb/sCkF5eTWJ9gu9PM=;
        b=druEG27Uh7rfeVK1K1n6n9PKMViveXzOTAIBPz0pGB4uktl4hBpwWfNAUGU8GapKyw
         JqyIqiPipxDv3u5gwpfk3bSDkXVw9/0pyNhpjrFkfxwb3J42grxYttNgJfWfIFcVL208
         5mdY9j7caqhyIWddVWkYmY5TYCqJErQr3h3NukLJRKf+wPf2zqj8daLwQ95idVXdMle4
         4TiZQwVijRWbOs4P4TY6ozY1477z9VY/YVllm6c7OZjJGlXveBmaE+f4YhKbBBnxHkaf
         9jWMLyqjdFtcGd4KgFAWKMcofKvEwNvBhTbchOPFieyY8utRYk1HBt6cGjzz+ZzC9bz6
         KQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gzyN0jgi4oIxO3xd+zqCFTMQCkb/sCkF5eTWJ9gu9PM=;
        b=gktijp4A3nx4Dd9CTApsdRv5XWomNFs5FweQqn7TkYuBJeJyAJVAQ6vzqjLcNsiJWS
         ivtFBpEoV5UMGqYeuFWV3D97BjhN27SIGELc0rBmelwj+qFglgd7wSqXjVnkFxHHMVQq
         4TP/3GB2TIa8wl5E5ZKNrkAlwYMY6MyZn1vpBLWjkkeMuk34gqyxykHoa7Wezr/AKI3o
         6wnn6v1gR37JELkuRFXPvyum8p4mO+BwhzabYjfEqTv4NkVQiU7+zAL9V3JbgIDH5Jlu
         Xt6jT8oCZrPGlneMRq0FIAueMbKKE3OcYp9dNQbgsfgqILMFPs9c5NOskW9iY7WxiqOs
         +WNg==
X-Gm-Message-State: AOAM531tIjf7e4JuDK7ixWKGq1VLmQFIOV44x0zPu0FNlMAA5fFBCSYv
        T1FItjg1FoBeuu8B483htD8=
X-Google-Smtp-Source: ABdhPJyhsyBJ4gwG/gnOHyywjlxVAGVAhz9N6jXvs02FqxsBfPJ5Os92Lo6YaAJwJEkIb1pYaRgxsw==
X-Received: by 2002:a17:90a:280e:b0:1bc:3bb7:aa0a with SMTP id e14-20020a17090a280e00b001bc3bb7aa0amr6207746pjd.6.1645567495896;
        Tue, 22 Feb 2022 14:04:55 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7bd9:d9bf:eaa2:653])
        by smtp.gmail.com with ESMTPSA id k13sm19721877pfc.176.2022.02.22.14.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 14:04:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net-next] drop_monitor: remove quadratic behavior
Date:   Tue, 22 Feb 2022 14:04:50 -0800
Message-Id: <20220222220450.1154948-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

drop_monitor is using an unique list on which all netdevices in
the host have an element, regardless of their netns.

This scales poorly, not only at device unregister time (what I
caught during my netns dismantle stress tests), but also at packet
processing time whenever trace_napi_poll_hit() is called.

If the intent was to avoid adding one pointer in 'struct net_device'
then surely we prefer O(1) behavior.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 include/linux/netdevice.h |  4 +-
 net/core/drop_monitor.c   | 79 ++++++++++++---------------------------
 2 files changed, 27 insertions(+), 56 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 93fc680b658f0f1b31c4d33a34e21b705097ad6f..c79ee22962961810f5f8f2f4529159fd308b8fc6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2236,7 +2236,9 @@ struct net_device {
 #if IS_ENABLED(CONFIG_MRP)
 	struct mrp_port __rcu	*mrp_port;
 #endif
-
+#if IS_ENABLED(CONFIG_NET_DROP_MONITOR)
+	struct dm_hw_stat_delta __rcu *dm_private;
+#endif
 	struct device		dev;
 	const struct attribute_group *sysfs_groups[4];
 	const struct attribute_group *sysfs_rx_queue_group;
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index d7d177f75d43c6fbcdbbf2facaa18c120a541ffb..b89e3e95bffc0f50d477e86959f2bb42af9dce46 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -64,7 +64,6 @@ static const char * const drop_reasons[] = {
 /* net_dm_mutex
  *
  * An overall lock guarding every operation coming from userspace.
- * It also guards the global 'hw_stats_list' list.
  */
 static DEFINE_MUTEX(net_dm_mutex);
 
@@ -100,11 +99,9 @@ struct per_cpu_dm_data {
 };
 
 struct dm_hw_stat_delta {
-	struct net_device *dev;
 	unsigned long last_rx;
-	struct list_head list;
-	struct rcu_head rcu;
 	unsigned long last_drop_val;
+	struct rcu_head rcu;
 };
 
 static struct genl_family net_drop_monitor_family;
@@ -115,7 +112,6 @@ static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_hw_cpu_data);
 static int dm_hit_limit = 64;
 static int dm_delay = 1;
 static unsigned long dm_hw_check_delta = 2*HZ;
-static LIST_HEAD(hw_stats_list);
 
 static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
 static u32 net_dm_trunc_len;
@@ -287,33 +283,27 @@ static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
 static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 				int work, int budget)
 {
-	struct dm_hw_stat_delta *new_stat;
-
+	struct net_device *dev = napi->dev;
+	struct dm_hw_stat_delta *stat;
 	/*
 	 * Don't check napi structures with no associated device
 	 */
-	if (!napi->dev)
+	if (!dev)
 		return;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(new_stat, &hw_stats_list, list) {
-		struct net_device *dev;
-
+	stat = rcu_dereference(dev->dm_private);
+	if (stat) {
 		/*
 		 * only add a note to our monitor buffer if:
-		 * 1) this is the dev we received on
-		 * 2) its after the last_rx delta
-		 * 3) our rx_dropped count has gone up
+		 * 1) its after the last_rx delta
+		 * 2) our rx_dropped count has gone up
 		 */
-		/* Paired with WRITE_ONCE() in dropmon_net_event() */
-		dev = READ_ONCE(new_stat->dev);
-		if ((dev == napi->dev)  &&
-		    (time_after(jiffies, new_stat->last_rx + dm_hw_check_delta)) &&
-		    (napi->dev->stats.rx_dropped != new_stat->last_drop_val)) {
+		if (time_after(jiffies, stat->last_rx + dm_hw_check_delta) &&
+		    (dev->stats.rx_dropped != stat->last_drop_val)) {
 			trace_drop_common(NULL, NULL);
-			new_stat->last_drop_val = napi->dev->stats.rx_dropped;
-			new_stat->last_rx = jiffies;
-			break;
+			stat->last_drop_val = dev->stats.rx_dropped;
+			stat->last_rx = jiffies;
 		}
 	}
 	rcu_read_unlock();
@@ -1198,7 +1188,6 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 static void net_dm_trace_off_set(void)
 {
-	struct dm_hw_stat_delta *new_stat, *temp;
 	const struct net_dm_alert_ops *ops;
 	int cpu;
 
@@ -1222,13 +1211,6 @@ static void net_dm_trace_off_set(void)
 			consume_skb(skb);
 	}
 
-	list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
-		if (new_stat->dev == NULL) {
-			list_del_rcu(&new_stat->list);
-			kfree_rcu(new_stat, rcu);
-		}
-	}
-
 	module_put(THIS_MODULE);
 }
 
@@ -1589,41 +1571,28 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 			     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct dm_hw_stat_delta *new_stat = NULL;
-	struct dm_hw_stat_delta *tmp;
+	struct dm_hw_stat_delta *stat;
 
 	switch (event) {
 	case NETDEV_REGISTER:
-		new_stat = kzalloc(sizeof(struct dm_hw_stat_delta), GFP_KERNEL);
+		if (WARN_ON_ONCE(rtnl_dereference(dev->dm_private)))
+			break;
+		stat = kzalloc(sizeof(*stat), GFP_KERNEL);
+		if (!stat)
+			break;
 
-		if (!new_stat)
-			goto out;
+		stat->last_rx = jiffies;
+		rcu_assign_pointer(dev->dm_private, stat);
 
-		new_stat->dev = dev;
-		new_stat->last_rx = jiffies;
-		mutex_lock(&net_dm_mutex);
-		list_add_rcu(&new_stat->list, &hw_stats_list);
-		mutex_unlock(&net_dm_mutex);
 		break;
 	case NETDEV_UNREGISTER:
-		mutex_lock(&net_dm_mutex);
-		list_for_each_entry_safe(new_stat, tmp, &hw_stats_list, list) {
-			if (new_stat->dev == dev) {
-
-				/* Paired with READ_ONCE() in trace_napi_poll_hit() */
-				WRITE_ONCE(new_stat->dev, NULL);
-
-				if (trace_state == TRACE_OFF) {
-					list_del_rcu(&new_stat->list);
-					kfree_rcu(new_stat, rcu);
-					break;
-				}
-			}
+		stat = rtnl_dereference(dev->dm_private);
+		if (stat) {
+			rcu_assign_pointer(dev->dm_private, NULL);
+			kfree_rcu(stat, rcu);
 		}
-		mutex_unlock(&net_dm_mutex);
 		break;
 	}
-out:
 	return NOTIFY_DONE;
 }
 
-- 
2.35.1.473.g83b2b277ed-goog

