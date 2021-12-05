Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEB3468A14
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhLEIZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbhLEIZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:25:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAFAC0613F8;
        Sun,  5 Dec 2021 00:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B09B80DF3;
        Sun,  5 Dec 2021 08:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FDEC341CA;
        Sun,  5 Dec 2021 08:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638692537;
        bh=n8Yym6ZyaF4+VCFdjV7upA4AulIR2wv5JJgcIst1zsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnoLLY6R4ozVUJoHnVzBMNvz3D/PFYtAnNLBlFtrdmurs/bPuySfLkuDD4FkmD6nW
         s4DidRDv8JLAP773LofI9A5OhHQ4gVCmzemiXVoSTqOnvACgvvhJzIi8zaiW3r3H81
         h4sfl6PZhuDNvs3RjWcnQe14D27eI0+4XinLib+O1ZfdEIN5mL4IXN6Uz5J1msT+KW
         8s/rF/F1ZTaV4WaWhHs0itsMTl0XtmfX7MeKo7DkUF3/lb28uE39GO+4eTaCMSLZk9
         rbdDuNfD5yJCZ2JAnIRxd4pWwVxBpiJPgYZQgk3U9pCS7IqI9qzvYgQwGrezYFjF+d
         HKE8FpLze9ZDw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/6] devlink: Be explicit with devlink port protection
Date:   Sun,  5 Dec 2021 10:22:02 +0200
Message-Id: <273f772b135dffc117d20fe79dec5657d5028411.1638690564.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1638690564.git.leonro@nvidia.com>
References: <cover.1638690564.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink port flows use devlink instance lock to protect from parallel
addition and deletion from port_list. So instead of using global lock,
let's introduce specific protection lock with much more clear scope
that will protect port_list.

Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 34d0f623b2a9..eddd554b50d4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -41,6 +41,8 @@ struct devlink_dev_stats {
 struct devlink {
 	u32 index;
 	struct list_head port_list;
+	/* Protect add/delete operations of devlink_port */
+	struct mutex port_list_lock;
 	struct list_head rate_list;
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
@@ -60,7 +62,7 @@ struct devlink {
 	struct device *dev;
 	possible_net_t _net;
 	/* Serializes access to devlink instance specific objects such as
-	 * port, sb, dpipe, resource, params, region, traps and more.
+	 * sb, dpipe, resource, params, region, traps and more.
 	 */
 	struct mutex lock;
 	u8 reload_failed:1;
@@ -1373,6 +1375,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 			goto retry;
 
 		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			if (idx < start) {
 				idx++;
@@ -1384,12 +1387,14 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI, cb->extack);
 			if (err) {
+				mutex_unlock(&devlink->port_list_lock);
 				mutex_unlock(&devlink->lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
+		mutex_unlock(&devlink->port_list_lock);
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
@@ -4977,6 +4982,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 			goto retry;
 
 		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
 					    &devlink_port->param_list, list) {
@@ -4994,6 +5000,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 				if (err == -EOPNOTSUPP) {
 					err = 0;
 				} else if (err) {
+					mutex_unlock(&devlink->port_list_lock);
 					mutex_unlock(&devlink->lock);
 					devlink_put(devlink);
 					goto out;
@@ -5001,6 +5008,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 				idx++;
 			}
 		}
+		mutex_unlock(&devlink->port_list_lock);
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
@@ -5531,13 +5539,15 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 		(*idx)++;
 	}
 
+	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry(port, &devlink->port_list, list) {
 		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
 							    start);
 		if (err)
-			goto out;
+			goto out_port;
 	}
-
+out_port:
+	mutex_unlock(&devlink->port_list_lock);
 out:
 	mutex_unlock(&devlink->lock);
 	return err;
@@ -7305,6 +7315,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			goto retry_port;
 
 		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
@@ -7319,6 +7330,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
+					mutex_unlock(&devlink->port_list_lock);
 					mutex_unlock(&devlink->lock);
 					devlink_put(devlink);
 					goto out;
@@ -7327,6 +7339,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			mutex_unlock(&port->reporters_lock);
 		}
+		mutex_unlock(&devlink->port_list_lock);
 		mutex_unlock(&devlink->lock);
 retry_port:
 		devlink_put(devlink);
@@ -9029,6 +9042,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
 	INIT_LIST_HEAD(&devlink->port_list);
+	mutex_init(&devlink->port_list_lock);
 	INIT_LIST_HEAD(&devlink->rate_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
@@ -9190,6 +9204,7 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->dpipe_table_list));
 	WARN_ON(!list_empty(&devlink->sb_list));
 	WARN_ON(!list_empty(&devlink->rate_list));
+	mutex_destroy(&devlink->port_list_lock);
 	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
@@ -9261,9 +9276,9 @@ int devlink_port_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&devlink_port->region_list);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->port_list_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->port_list_lock);
 
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9282,9 +9297,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->port_list_lock);
 	list_del(&devlink_port->list);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->port_list_lock);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
-- 
2.33.1

