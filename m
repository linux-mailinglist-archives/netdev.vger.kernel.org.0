Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE1A12C71
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 13:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfECLb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 07:31:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35323 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfECLb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 07:31:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id y197so6336076wmd.0
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 04:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=19SVHnhiAzv+bAq2t+VGf5mihhyhBWGYklj53l2a44Q=;
        b=pR/4w0BoVZgEIW+x1/GqtLsfgnEVe8VXYPgLZkmZaW+hI8qhBBR4uXx1IAapHPb2gO
         ouECb6YbFE5WzrcjRZJXmf6Anjw4ZtDDdrRd+SAta2PUEkK34h5lo0eAHQqlxiFJl3Pf
         ukM+S/2fzKHv+6k5+W+yT2jtfWu8+CzuLEGUSiQO8YO77W1ad8gWGaaHu/HgDf7VyLGg
         jTYdBtCw9d/WG6xwyg6s9KuMqJt1IK1MdZKtMIbHqMWK90wvIpIRuQyl8+ED2wREjM5C
         0Vb166kuQ+1iHUzAElKquRt5R/WApASHGKJV1j2+EC6h9C+BZWlOVRDr2R3XiD+l4hI8
         0VPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=19SVHnhiAzv+bAq2t+VGf5mihhyhBWGYklj53l2a44Q=;
        b=qNJQCZupCtfxn1dVLfjPqenhnHtxtcxoekLSh/jtU3Yrxgqo9GerglL6WQeA6GP542
         8x40Nm7hGhdXXAFcX4H9DbHcnB2+YBo3dBrP+4hSVSRJcP13fR5/OhGIP10qyEvuSHdI
         goFM4XYiY3BxOmYo5ScUr8u6kdqrVOvxycS98j5OG/VFf6XXCzCVInt2VvY6tc/mfQkK
         JVrAAgplqQLC/rNXPQwwc31eZ69K20StEQiKC8ruw/qKXuqJoDPSrSD0w3us4dA+UZzt
         VftvJAdyNwtm3tM9g6vJ3Duej0yG0VAWAoEgSikunkNqksAlgVCDR43P9cKylN8/QsXa
         utJw==
X-Gm-Message-State: APjAAAWEyD1DCX6/fivCrc0H02Kf0lLzFKhLuSEdTD0DhKFAYcjqYGxJ
        b14RysWyUnXZ+XrPMLXaFXxprbnxZ1Y=
X-Google-Smtp-Source: APXvYqxalMm06fRTP2Y4Y9hvMCevF6qVqgjudgJTiwhviO9Tq6YmVxgalb8qUMvbALTUGKkCTPI6ZA==
X-Received: by 2002:a7b:c411:: with SMTP id k17mr5063137wmi.68.1556883114507;
        Fri, 03 May 2019 04:31:54 -0700 (PDT)
Received: from localhost (ip-89-177-126-50.net.upcbroadband.cz. [89.177.126.50])
        by smtp.gmail.com with ESMTPSA id e5sm1346856wrh.79.2019.05.03.04.31.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 04:31:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com
Subject: [patch net-next] devlink: add warning in case driver does not set port type
Date:   Fri,  3 May 2019 13:31:53 +0200
Message-Id: <20190503113153.3261-1-jiri@resnulli.us>
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
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

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
index d43bc52b8840..2515f7269ed0 100644
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
@@ -5390,6 +5391,27 @@ void devlink_free(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_free);
 
+static void devlink_port_type_warn(struct work_struct *work)
+{
+	WARN(true, "Type was not set for devlink port.");
+}
+
+#define DEVLINK_PORT_TYPE_WARN_TIMEOUT (HZ * 30)
+
+static void devlink_port_type_warn_schedule(struct devlink_port *devlink_port)
+{
+	/* Schedule a work to WARN in case driver does not set port
+	 * type within timeout.
+	 */
+	schedule_delayed_work(&devlink_port->type_warn_dw,
+			      DEVLINK_PORT_TYPE_WARN_TIMEOUT);
+}
+
+static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
+{
+	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
+}
+
 /**
  *	devlink_port_register - Register devlink port
  *
@@ -5419,6 +5441,8 @@ int devlink_port_register(struct devlink *devlink,
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	mutex_unlock(&devlink->lock);
+	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
+	devlink_port_type_warn_schedule(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	return 0;
 }
@@ -5433,6 +5457,7 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
+	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_port->list);
@@ -5446,6 +5471,7 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	if (WARN_ON(!devlink_port->registered))
 		return;
+	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock(&devlink_port->type_lock);
 	devlink_port->type = type;
 	devlink_port->type_dev = type_dev;
@@ -5519,6 +5545,7 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
+	devlink_port_type_warn_schedule(devlink_port);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-- 
2.17.2

