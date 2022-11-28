Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B210E63A6C9
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiK1LIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiK1LIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:08:09 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE803881
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:08:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s5so14864558edc.12
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1bEyfojz4hqBWEMruKf+lGLcvfa75Ig+IwRgShWDoXQ=;
        b=D/s9ILGeVSg/24Z4G5gb7nJOacYz1CXYJ7lWCf7fWs7HJnteQsAd3BbThxQbJYZzoP
         jW5TTUGrGxUN1QGagnJlL18jwIn/NWIO6HJqITq7LVIUfPlm95m2OdeoczsR8XgTn7Cl
         FLEXR8tG5+B+ZjEB0hoRy3jS9D+0XZI2Y0x5EyJABOHjBPLk+IJKuoS5uo3ZKNUy6EOZ
         7h3Pxcq90pQwMbN1Zx/4AToYNr7fTNA42j9OOtWp9Vsx504IQeFj2szak2nSGnvLZxFQ
         6HpMRAq3SxNsyUr5X5JhML2kV22SItDhelo4WNIgYFxMVSTPnzTVw7K6I73Ot2rNtQUn
         uXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1bEyfojz4hqBWEMruKf+lGLcvfa75Ig+IwRgShWDoXQ=;
        b=exSbYLbvA50D0yN4ZttlGiksq+qym+9XFfrEDw3TfV7Z1Xrk7Rw1TWgb2YtymbkDhc
         6TvEQiSIKEpHlLTxOQ0IqnKC6mggUJP/EcHU/3qnqlRAQm58jQLRlAbP98S9ikFuH863
         43FUMws4ivIXd3jt/etnwI9fQTu2/x0G9kF31l1d7BQ0um1F8nvGjlAkw/DNTIXMXZu/
         TWAeJGjGht8GLCC7V36l2CcTHGPATsVfz+pxgv+QaJp3KFjGGUCsb+b4Cx0X59X6lNSh
         E7hCI4dPhgDaIR634JzPYUm90uwRfzjzc6ipqmLgqT22HdA42T1LPN8rYVaXTbypXnN0
         OyhA==
X-Gm-Message-State: ANoB5pk7Eo41BMdG2ddBSlBQR6i/OFWfg6njfRNOlDLQ7IPyB5WpcQj6
        /ayCqJ9r1f4ggZ4ULYz5BlNBCueJ3dUYEg8Dhq4=
X-Google-Smtp-Source: AA0mqf6FqVl7d8BZWBZUSsnle/KIhgm/3G1MKdcsxWO/iKDciHlwYi0KqC1rwkkE5QmKHGQnlFTBBw==
X-Received: by 2002:a05:6402:3893:b0:461:b033:90ac with SMTP id fd19-20020a056402389300b00461b03390acmr35185013edb.257.1669633685158;
        Mon, 28 Nov 2022 03:08:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id og14-20020a1709071dce00b007ae035374a0sm4904386ejc.214.2022.11.28.03.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 03:08:04 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next v2] net: devlink: convert port_list into xarray
Date:   Mon, 28 Nov 2022 12:08:03 +0100
Message-Id: <20221128110803.1992340-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Some devlink instances may contain thousands of ports. Storing them in
linked list and looking them up is not scalable. Convert the linked list
into xarray.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- use xa_insert() instead of xa_alloc()
---
 net/core/devlink.c | 56 +++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index cea154ddce7a..d58cc2916e3a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -41,7 +41,7 @@ struct devlink_dev_stats {
 
 struct devlink {
 	u32 index;
-	struct list_head port_list;
+	struct xarray ports;
 	struct list_head rate_list;
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
@@ -382,19 +382,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
 {
-	struct devlink_port *devlink_port;
-
-	list_for_each_entry(devlink_port, &devlink->port_list, list) {
-		if (devlink_port->index == port_index)
-			return devlink_port;
-	}
-	return NULL;
-}
-
-static bool devlink_port_index_exists(struct devlink *devlink,
-				      unsigned int port_index)
-{
-	return devlink_port_get_by_index(devlink, port_index);
+	return xa_load(&devlink->ports, port_index);
 }
 
 static struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
@@ -1565,14 +1553,14 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink *devlink;
 	struct devlink_port *devlink_port;
+	unsigned long index, port_index;
 	int start = cb->args[0];
-	unsigned long index;
 	int idx = 0;
 	int err;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
-		list_for_each_entry(devlink_port, &devlink->port_list, list) {
+		xa_for_each(&devlink->ports, port_index, devlink_port) {
 			if (idx < start) {
 				idx++;
 				continue;
@@ -2886,10 +2874,11 @@ static int __sb_port_pool_get_dumpit(struct sk_buff *msg, int start, int *p_idx,
 {
 	struct devlink_port *devlink_port;
 	u16 pool_count = devlink_sb_pool_count(devlink_sb);
+	unsigned long port_index;
 	u16 pool_index;
 	int err;
 
-	list_for_each_entry(devlink_port, &devlink->port_list, list) {
+	xa_for_each(&devlink->ports, port_index, devlink_port) {
 		for (pool_index = 0; pool_index < pool_count; pool_index++) {
 			if (*p_idx < start) {
 				(*p_idx)++;
@@ -3107,10 +3096,11 @@ static int __sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 					u32 portid, u32 seq)
 {
 	struct devlink_port *devlink_port;
+	unsigned long port_index;
 	u16 tc_index;
 	int err;
 
-	list_for_each_entry(devlink_port, &devlink->port_list, list) {
+	xa_for_each(&devlink->ports, port_index, devlink_port) {
 		for (tc_index = 0;
 		     tc_index < devlink_sb->ingress_tc_count; tc_index++) {
 			if (*p_idx < start) {
@@ -6207,6 +6197,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 {
 	struct devlink_region *region;
 	struct devlink_port *port;
+	unsigned long port_index;
 	int err = 0;
 
 	devl_lock(devlink);
@@ -6225,7 +6216,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 		(*idx)++;
 	}
 
-	list_for_each_entry(port, &devlink->port_list, list) {
+	xa_for_each(&devlink->ports, port_index, port) {
 		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
 							    start);
 		if (err)
@@ -7974,10 +7965,10 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
 	struct devlink_health_reporter *reporter;
+	unsigned long index, port_index;
 	struct devlink_port *port;
 	struct devlink *devlink;
 	int start = cb->args[0];
-	unsigned long index;
 	int idx = 0;
 	int err;
 
@@ -8006,7 +7997,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
-		list_for_each_entry(port, &devlink->port_list, list) {
+		xa_for_each(&devlink->ports, port_index, port) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
 				if (idx < start) {
@@ -9724,9 +9715,9 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 
 	devlink->dev = dev;
 	devlink->ops = ops;
+	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
-	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->rate_list);
 	INIT_LIST_HEAD(&devlink->linecard_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
@@ -9778,12 +9769,13 @@ static void devlink_notify_register(struct devlink *devlink)
 	struct devlink_linecard *linecard;
 	struct devlink_rate *rate_node;
 	struct devlink_region *region;
+	unsigned long port_index;
 
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	list_for_each_entry(linecard, &devlink->linecard_list, list)
 		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 
-	list_for_each_entry(devlink_port, &devlink->port_list, list)
+	xa_for_each(&devlink->ports, port_index, devlink_port)
 		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 
 	list_for_each_entry(policer_item, &devlink->trap_policer_list, list)
@@ -9817,6 +9809,7 @@ static void devlink_notify_unregister(struct devlink *devlink)
 	struct devlink_port *devlink_port;
 	struct devlink_rate *rate_node;
 	struct devlink_region *region;
+	unsigned long port_index;
 
 	list_for_each_entry_reverse(param_item, &devlink->param_list, list)
 		devlink_param_notify(devlink, 0, param_item,
@@ -9839,7 +9832,7 @@ static void devlink_notify_unregister(struct devlink *devlink)
 		devlink_trap_policer_notify(devlink, policer_item,
 					    DEVLINK_CMD_TRAP_POLICER_DEL);
 
-	list_for_each_entry_reverse(devlink_port, &devlink->port_list, list)
+	xa_for_each(&devlink->ports, port_index, devlink_port)
 		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
@@ -9903,9 +9896,9 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->sb_list));
 	WARN_ON(!list_empty(&devlink->rate_list));
 	WARN_ON(!list_empty(&devlink->linecard_list));
-	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
+	xa_destroy(&devlink->ports);
 
 	unregister_netdevice_notifier_net(devlink_net(devlink),
 					  &devlink->netdevice_nb);
@@ -10004,10 +9997,9 @@ int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
 {
-	devl_assert_locked(devlink);
+	int err;
 
-	if (devlink_port_index_exists(devlink, port_index))
-		return -EEXIST;
+	devl_assert_locked(devlink);
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
 
@@ -10017,7 +10009,11 @@ int devl_port_register(struct devlink *devlink,
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
-	list_add_tail(&devlink_port->list, &devlink->port_list);
+	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
+	if (err) {
+		mutex_destroy(&devlink_port->reporters_lock);
+		return err;
+	}
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -10066,7 +10062,7 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-	list_del(&devlink_port->list);
+	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
-- 
2.37.3

