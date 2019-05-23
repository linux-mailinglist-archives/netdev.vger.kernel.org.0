Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11EB2784C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 10:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbfEWInj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 04:43:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36263 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEWInj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 04:43:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id j187so4857285wmj.1
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 01:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=szmJOWY3PH+fTKidc/OVOr5CSaGElpMxQJI74Y/2NaY=;
        b=jg6d1KpUBxWNtid/tTZZEZetmLfNfgYCiAcr8F8ScHKgOaHkmJzF/eXn6cU9s2eojk
         M8RAW7mv7esggWrqNSZAYZv9SE5RQG/4yyZrB0lL5WCm0ELgem+eac3DaQyMkyYzlPsC
         2chF6ZxXdySUpVvwcOFpPmYJS34/IagXcWk9wrulr69xitQX4YUQKMI7j3X3Z8nsrLmS
         S70cxP5rXVftKqvzUEVpTPdx3ZHlf8kbfltRR5LxqRHNS93jXBvDXiKLef5yTZSByv+z
         K5L9j+Ib1LZqJOHn1PgVOWnoc03w8pEelwzsaXliO/Yb+6kqc9sPpvd33dhAoe/2TDjf
         rSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=szmJOWY3PH+fTKidc/OVOr5CSaGElpMxQJI74Y/2NaY=;
        b=EEgbXV6nGZ0LFp7eLnpv2R/R6vZo8XmanM7wqxr1aP8IiMaT0rn6FWxGgnzo5azIw+
         Som4W/Y+dMrI8ommaJYC+m0wGDxkgL2lIB5iAAXhL4QNAZyr+m4h9l+ir18MeRmOZMy3
         MxqfapuFr5k3oM7nygyP8TNVhm4tD6ZuUEf4L98kMV7uMfDqX+WhkPB0jhcrd5031xxb
         4OkvVt9j9rO39vE/pq4DuChK+l6VoJrwfPyooQgHegv1lOUXCCUrgVMhpsa0Gv/y07eQ
         p/W1WZ5JMhrCHiXCVdouLMwEdxafhYu2itR0pFbpE8ePHF4HZCoXxiQ5xwkPngl1J9Wj
         D7Ow==
X-Gm-Message-State: APjAAAXMP4+3ASjw/3HVQ0T80aptDMX8e/RMO6I6zZSidLohbtUzU17I
        ga5HvxoVh/3jXHy/cPFiQGc+sMqyAvA=
X-Google-Smtp-Source: APXvYqwUT3IMms9VsuQ15XLmRb7dj6RL0+O3nKNshhuvNP3yITHOrGzan9u6Nckv6Sq8FKpNy1Kq4A==
X-Received: by 2002:a1c:7ed2:: with SMTP id z201mr10556348wmc.113.1558601016588;
        Thu, 23 May 2019 01:43:36 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id u7sm19503507wmg.25.2019.05.23.01.43.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 01:43:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com
Subject: [patch net-next v2] devlink: add warning in case driver does not set port type
Date:   Thu, 23 May 2019 10:43:35 +0200
Message-Id: <20190523084335.5205-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Prevent misbehavior of drivers who would not set port type for longer
period of time. Drivers should always set port type. Do WARN if that
happens.

Note that it is perfectly fine to temporarily not have the type set,
during initialization and port type change.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- Don't warn on DSA and CPU ports.
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1c4adfb4195a..151eb930d329 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <net/net_namespace.h>
 #include <uapi/linux/devlink.h>
 
@@ -64,6 +65,7 @@ struct devlink_port {
 	enum devlink_port_type desired_type;
 	void *type_dev;
 	struct devlink_port_attrs attrs;
+	struct delayed_work type_warn_dw;
 };
 
 struct devlink_sb_pool_info {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d43bc52b8840..9716a7f382cb 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -21,6 +21,7 @@
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 #include <rdma/ib_verbs.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
@@ -5390,6 +5391,38 @@ void devlink_free(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_free);
 
+static void devlink_port_type_warn(struct work_struct *work)
+{
+	WARN(true, "Type was not set for devlink port.");
+}
+
+static bool devlink_port_type_should_warn(struct devlink_port *devlink_port)
+{
+	/* Ignore CPU and DSA flavours. */
+	return devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_CPU &&
+	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA;
+}
+
+#define DEVLINK_PORT_TYPE_WARN_TIMEOUT (HZ * 30)
+
+static void devlink_port_type_warn_schedule(struct devlink_port *devlink_port)
+{
+	if (!devlink_port_type_should_warn(devlink_port))
+		return;
+	/* Schedule a work to WARN in case driver does not set port
+	 * type within timeout.
+	 */
+	schedule_delayed_work(&devlink_port->type_warn_dw,
+			      DEVLINK_PORT_TYPE_WARN_TIMEOUT);
+}
+
+static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
+{
+	if (!devlink_port_type_should_warn(devlink_port))
+		return;
+	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
+}
+
 /**
  *	devlink_port_register - Register devlink port
  *
@@ -5419,6 +5452,8 @@ int devlink_port_register(struct devlink *devlink,
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	mutex_unlock(&devlink->lock);
+	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
+	devlink_port_type_warn_schedule(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	return 0;
 }
@@ -5433,6 +5468,7 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
+	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_port->list);
@@ -5446,6 +5482,7 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	if (WARN_ON(!devlink_port->registered))
 		return;
+	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock(&devlink_port->type_lock);
 	devlink_port->type = type;
 	devlink_port->type_dev = type_dev;
@@ -5519,6 +5556,7 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
+	devlink_port_type_warn_schedule(devlink_port);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-- 
2.17.2

