Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84341619B27
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiKDPOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiKDPOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:14:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A42B5F79
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:14:08 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sc25so13999540ejc.12
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iL42p3ThdxbDJBfrDMcegPqYyWwox2HJUYWMzeKK8kM=;
        b=emuQYbG+hx8U0bsgBIAI4pyAUI8TBLuV7U0VOwO1gL8aVJrbPheeNSzWme+EbL9k68
         1zgvGnK6Ld/1grWwRE1T2WBSPU+CWzLYor9B4vEjMZqHVuIxj1AOCOXUMOISutKh2LcB
         ymtL7cwvbSAn4gd3ZQS7GEuW8OXZNrkf61NAjNUhmIxtwyokRlNCaP2jY0qLiAvhdxEX
         EYNZwdMJsTb0oEt7tCoESAJRIPxlkeO2x28bzm2kyGE4zkMAzNlE6KUvy7OsKvXRCOAY
         K7csyeGxofUj/iT2GRGdUCsp2mqJZv4qyjjH0Y1PmhKXMHVA063x+ueuD2WIoFwzTz/V
         wt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iL42p3ThdxbDJBfrDMcegPqYyWwox2HJUYWMzeKK8kM=;
        b=iGjWUu4+BuX+nH+IW/3lsrlUos/aAgm32DAd1XiSluRTL7WWiLtwvK0/37NKsdLjBK
         2B6pbHW3pDbuGaOu7XnOdt9oDqkGrHK5hVkfwAOUbS1bA26DKu+peULgNCdBTjQ/xS0F
         yFVtV7nFENp3siWd85joFVPJjqmKGweE1pSgg0BkKn0NPCgJ1XNboArZbmnvFf3mr3/J
         lM+fCarRXnvyIN0pnZfwztmJoJiWB3RI1IUHN26zFUBRnozagsNUtsH3Ft1sEOz4Ltko
         dKx4940j8f3XbWBQkDHPHz4wozjRRmMHQsJjJF6V1/Jcnclvi4rv8UZB3dJMKL6Jl4xg
         OOvA==
X-Gm-Message-State: ACrzQf1934ugCgnNKZSSAE6okCTlT/Vnimwt0Y+hHYL/dqdnC9jSSpCp
        wuz3HMlXKsBATIYcU5JXCXLNRWBT1Z2Zj1oU
X-Google-Smtp-Source: AMsMyM6aTHkPyvwad2AOf3m+5Pfu1M5wljsO0galvaFa8AL71aiTP2ZTLFZPSvp0EaDKGCzMxJQcWQ==
X-Received: by 2002:a17:907:a047:b0:7ac:ff72:977c with SMTP id gz7-20020a170907a04700b007acff72977cmr35704686ejc.260.1667574846672;
        Fri, 04 Nov 2022 08:14:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h20-20020a170906111400b007aa3822f4d2sm1957737eja.17.2022.11.04.08.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:14:06 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next] net: devlink: convert port_list into xarray
Date:   Fri,  4 Nov 2022 16:14:05 +0100
Message-Id: <20221104151405.783346-1-jiri@resnulli.us>
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
 net/core/devlink.c | 58 ++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2dcf2bcc3527..bc29e6b83dfd 100644
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
@@ -1557,14 +1545,14 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
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
@@ -2822,10 +2810,11 @@ static int __sb_port_pool_get_dumpit(struct sk_buff *msg, int start, int *p_idx,
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
@@ -3043,10 +3032,11 @@ static int __sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
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
@@ -6140,6 +6130,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 {
 	struct devlink_region *region;
 	struct devlink_port *port;
+	unsigned long port_index;
 	int err = 0;
 
 	devl_lock(devlink);
@@ -6158,7 +6149,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 		(*idx)++;
 	}
 
-	list_for_each_entry(port, &devlink->port_list, list) {
+	xa_for_each(&devlink->ports, port_index, port) {
 		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
 							    start);
 		if (err)
@@ -7909,10 +7900,10 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
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
 
@@ -7941,7 +7932,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
-		list_for_each_entry(port, &devlink->port_list, list) {
+		xa_for_each(&devlink->ports, port_index, port) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
 				if (idx < start) {
@@ -9657,9 +9648,9 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 
 	devlink->dev = dev;
 	devlink->ops = ops;
+	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
-	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->rate_list);
 	INIT_LIST_HEAD(&devlink->linecard_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
@@ -9711,12 +9702,13 @@ static void devlink_notify_register(struct devlink *devlink)
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
@@ -9750,6 +9742,7 @@ static void devlink_notify_unregister(struct devlink *devlink)
 	struct devlink_port *devlink_port;
 	struct devlink_rate *rate_node;
 	struct devlink_region *region;
+	unsigned long port_index;
 
 	list_for_each_entry_reverse(param_item, &devlink->param_list, list)
 		devlink_param_notify(devlink, 0, param_item,
@@ -9772,7 +9765,7 @@ static void devlink_notify_unregister(struct devlink *devlink)
 		devlink_trap_policer_notify(devlink, policer_item,
 					    DEVLINK_CMD_TRAP_POLICER_DEL);
 
-	list_for_each_entry_reverse(devlink_port, &devlink->port_list, list)
+	xa_for_each(&devlink->ports, port_index, devlink_port)
 		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
@@ -9836,9 +9829,9 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->sb_list));
 	WARN_ON(!list_empty(&devlink->rate_list));
 	WARN_ON(!list_empty(&devlink->linecard_list));
-	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
+	xa_destroy(&devlink->ports);
 
 	unregister_netdevice_notifier_net(devlink_net(devlink),
 					  &devlink->netdevice_nb);
@@ -9937,10 +9930,10 @@ int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
 {
-	devl_assert_locked(devlink);
+	u32 id = port_index;
+	int err;
 
-	if (devlink_port_index_exists(devlink, port_index))
-		return -EEXIST;
+	devl_assert_locked(devlink);
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
 
@@ -9950,7 +9943,12 @@ int devl_port_register(struct devlink *devlink,
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
-	list_add_tail(&devlink_port->list, &devlink->port_list);
+	err = xa_alloc(&devlink->ports, &id, devlink_port, XA_LIMIT(id, id),
+		       GFP_KERNEL);
+	if (err) {
+		mutex_destroy(&devlink_port->reporters_lock);
+		return err;
+	}
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9999,7 +9997,7 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-	list_del(&devlink_port->list);
+	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
-- 
2.37.3

