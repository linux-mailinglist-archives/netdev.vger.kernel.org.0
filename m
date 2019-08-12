Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BB78A004
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfHLNr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:47:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34619 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfHLNr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:47:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id e8so66708wme.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 06:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+0o90YKJky3w7dw9E4hZ8KrcJ0wxdpaW2rTCM0EIsTQ=;
        b=kAuDU/6Lppyx1EJy4rA18FcpaNyGcbofM7DsVm2+A4sv1PHeYSdv3HsvSJPTqRxqvD
         0EmYQwYJYHTQysx/e2jE7ISA4EGZCbTj7qZf0LJkHnMXrGZ02aGXgTApeOy8uqSTCqgQ
         uDw92a+I+MZczxMCJ56XqJ86WLyEOL3yMVIOVEW/HM4ZY8Klm1TpGLusGEk2vOiwycNN
         oyLmvzqNz7jDs2Qxyo4CYrSLacQi1L8eLUVhGBKAvP88hrEIOsbi4JcbZ0l5ZkqKd+4o
         J826UI0ev9R7c1nU1VQQMNC7/zyj2yer6q6CAVrm+Sv06o6MwlT5sbn4v1FwKswRhb8D
         KQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+0o90YKJky3w7dw9E4hZ8KrcJ0wxdpaW2rTCM0EIsTQ=;
        b=J7xHDK0UGnYUTcyarmYaWi7V6eN8qrWBUvm2VhpBrBbZIRbgu3X/ThfUXvF17xebp1
         HPr743NzfUDswj3Hy++zDIRicgxEbNaOpT5MVE/j0zgE2mUnqh094aNXRuW1tkffxfuP
         3uHXzC7Gbf+SFxeR/kXuVwXe6p3p04wUdJcNr7OS34wdiOsz3/sMHjMminrPeT4w2OHY
         wg36shL4Fm60WKM8kwgwe8Ox64ZEbYmJd2tJJcG5RL3wVi9PTu3yhkQkyH8TCT/QLfBk
         4+E2HXKQpRa0CzKlP9xGUnJ99WbSCMSeC2wPut7wwTPrTUUQ0G6zzQ6rhGZqBY2YebKJ
         D0yw==
X-Gm-Message-State: APjAAAU2K3Rmxf/1pQA7DGoQzd2AYxXyHaN8UtUsNZZM5IrQyKfT3rwQ
        WjC/lBTaD1Sbhk5MTr6acWRMfKcGq/Q=
X-Google-Smtp-Source: APXvYqzE9lKXF4FCkH7HSV2elgLFCX78i4d5LBadrmOGtuII6OZV+JfrB8JAqwPahBMB5P/erm6UJw==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr26956826wmc.33.1565617674818;
        Mon, 12 Aug 2019 06:47:54 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id o9sm1754324wrj.17.2019.08.12.06.47.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:47:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v3 2/3] net: devlink: export devlink net set/get helpers
Date:   Mon, 12 Aug 2019 15:47:50 +0200
Message-Id: <20190812134751.30838-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812134751.30838-1-jiri@resnulli.us>
References: <20190812134751.30838-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow drivers to set/get net struct for devlink instance. Set is only
allowed for newly allocated devlink instance.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/devlink.h |  3 +++
 net/core/devlink.c    | 18 ++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 451268f64880..c45b10d79b14 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -35,6 +35,7 @@ struct devlink {
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock;
+	bool registered;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -591,6 +592,8 @@ static inline struct devlink *netdev_to_devlink(struct net_device *dev)
 
 struct ib_device;
 
+struct net *devlink_net(const struct devlink *devlink);
+void devlink_net_set(struct devlink *devlink, struct net *net);
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6f8c1b2cdfb2..80a4b3ae9d39 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -92,16 +92,25 @@ static LIST_HEAD(devlink_list);
  */
 static DEFINE_MUTEX(devlink_mutex);
 
-static struct net *devlink_net(const struct devlink *devlink)
+struct net *devlink_net(const struct devlink *devlink)
 {
 	return read_pnet(&devlink->_net);
 }
+EXPORT_SYMBOL_GPL(devlink_net);
 
-static void devlink_net_set(struct devlink *devlink, struct net *net)
+static void __devlink_net_set(struct devlink *devlink, struct net *net)
 {
 	write_pnet(&devlink->_net, net);
 }
 
+void devlink_net_set(struct devlink *devlink, struct net *net)
+{
+	if (WARN_ON(devlink->registered))
+		return;
+	__devlink_net_set(devlink, net);
+}
+EXPORT_SYMBOL_GPL(devlink_net_set);
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -690,7 +699,7 @@ static void devlink_netns_change(struct devlink *devlink, struct net *net)
 	if (net_eq(devlink_net(devlink), net))
 		return;
 	devlink_all_del_notify(devlink);
-	devlink_net_set(devlink, net);
+	__devlink_net_set(devlink, net);
 	devlink_all_add_notify(devlink);
 }
 
@@ -5606,7 +5615,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
-	devlink_net_set(devlink, &init_net);
+	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
@@ -5630,6 +5639,7 @@ int devlink_register(struct devlink *devlink, struct device *dev)
 {
 	mutex_lock(&devlink_mutex);
 	devlink->dev = dev;
+	devlink->registered = true;
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	mutex_unlock(&devlink_mutex);
-- 
2.21.0

