Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9018E7A376
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfG3I5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:57:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43529 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731221AbfG3I5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:57:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so64816759wru.10
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 01:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aFcvd2TTCZ8ZfR2IYpnu18zt3N3uMA4v+BNJtXVykgs=;
        b=EMs1ItPa+rGNkKe3TBMCJLym4XisjTIKgo6NWP171TzYPdmwwRWjbRFvz02tWGgxB2
         r2vubguO72xnDzxcfvWpmJeXV5P6/4UQoYdL/tq7CVu3Q8pZo5tqMc7G/1NnSvcL6rBm
         nWayDvVqRd0eABUC7y6A8nQaUbD4WxvoCFjtqzKycwn6T09M38FBu0RS84iim5foIVTh
         6PBIWaQotOnInlvlQtYByffPgRYNlvdedY3V70Inh30UJqR9GWoPCeQCScZvilIS6JVZ
         S0w7Q4IsDWUW714tCGr1lxqwHPV9yFBDwip6kB5jdKF52IITitEvv1mTeEvJyMwgTyl/
         VBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aFcvd2TTCZ8ZfR2IYpnu18zt3N3uMA4v+BNJtXVykgs=;
        b=J/A0M03koOhDteF/Snhj0Tns42IfJWeHlnj3NvaYQd/DYKpcx8y25FPAgJsbOo4pCw
         /te/eEJvwCDNgxKN51aErMuJaeDEpP0+Awxf9npLKSCrsfMDa5fLJDjTdyT93+ioL7rW
         upHfsYSVBMq42i9+QGRA+dAVRNN9oNy9gHHHK79KWedWy9OdWI5FBdWp3R+E3YDpNTaI
         KhihdTOoC0Y8zqPmK3ehrRAS7TjDnZrCP2aZyyxaUl1/DRqO/obzHJR4sk/npTvyQfRK
         IutSb7+H/f/h5Aixdh7HwYSDKwoE/ZIOhaJaNHNjwJYMp1NDK62L7kwnjpxGEXY1Ponz
         woDw==
X-Gm-Message-State: APjAAAXxe7FbHHZe8VIh5gakmOsT6zitDmjSSUG6q1COkV04DLnNpQZK
        yx2ASgZxjgDIljbHJxtMU62JDcl3
X-Google-Smtp-Source: APXvYqwB9F2/6NsZe9BV6r9DTGgonLCy41T+aypeLjuTv5XSdAlWd2x9OlqAqLsmz+Fcvi3uCOXLKg==
X-Received: by 2002:a5d:5450:: with SMTP id w16mr78518974wrv.128.1564477057621;
        Tue, 30 Jul 2019 01:57:37 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id f10sm51131585wrs.22.2019.07.30.01.57.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 01:57:37 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v2 2/3] net: devlink: export devlink net set/get helpers
Date:   Tue, 30 Jul 2019 10:57:33 +0200
Message-Id: <20190730085734.31504-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730085734.31504-1-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
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
---
 include/net/devlink.h |  3 +++
 net/core/devlink.c    | 18 ++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index bc36f942a7d5..98b89eabd73a 100644
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
index e1cbfd90f788..fc364bdb9cf2 100644
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
@@ -696,7 +705,7 @@ static void devlink_netns_change(struct devlink *devlink, struct net *net)
 	if (net_eq(devlink_net(devlink), net))
 		return;
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
-	devlink_net_set(devlink, net);
+	__devlink_net_set(devlink, net);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 }
 
@@ -5603,7 +5612,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
-	devlink_net_set(devlink, &init_net);
+	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
@@ -5627,6 +5636,7 @@ int devlink_register(struct devlink *devlink, struct device *dev)
 {
 	mutex_lock(&devlink_mutex);
 	devlink->dev = dev;
+	devlink->registered = true;
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	mutex_unlock(&devlink_mutex);
-- 
2.21.0

