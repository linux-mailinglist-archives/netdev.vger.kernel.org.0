Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2408777F9
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 11:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387549AbfG0JpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 05:45:05 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:37492 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387507AbfG0JpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 05:45:04 -0400
Received: by mail-wr1-f44.google.com with SMTP id n9so31696983wrr.4
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 02:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rucH6cf/Xmdfs8bbbj9zCp2udraDJ9SyOdwLb/mx0tE=;
        b=0VyC0mZN+3TdWbs5UNsL7brJGBdL1MBoIHcIWS8syEWohua6ZtC2LmjOG39o0O3wLX
         vgr889aMDX5sJzLYc88AH0Uk+X3hvQ+XHzU8dWipwXc1e9VcOaSEOtYcxzMsmIEgRiN6
         l/bIAWudYk/lYb9Afl7/tgWDX1gqFvG/OGszxJDQVzaGoIoWP2S+vPa7ghOobTGM0/TU
         ScmqyYRBxHQuhADEUq7+7zMnG+qKT/Jzls0khIKrZJr/iP7UCxyBBZwNvWizTEdreTZK
         D4NGqQ1Pxo9QgcJEbF4paYvxvoWjYbaqwPNTGNEJ3+WEj5b00yublN8VlT4RG6YXdAQ2
         ytag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rucH6cf/Xmdfs8bbbj9zCp2udraDJ9SyOdwLb/mx0tE=;
        b=ko/cSnLSg0wZ0BgrWCiOYS75YJwMcKYWMmEylixN0pHnyfw3p9WXIyOqRR7NEDKfwm
         IRpmD+dxYpkuDA34PB6JS3Z7P+wrCid63Zq/bSMMyF8oYQmnlliBhDa16tp14iVMJJOx
         ixTbsGy4PWAPT23HKWQoDn8jlH7RyFGYm9owXmVutz783mu9GaZLAc1FfJOYWBz8RxZp
         HJc7nTNXsnPv+476bZleY0uCSWqlud8kNNqhDEWOClYfoAevzIsDx2nYLtTt6OPO0MtC
         bPiCKTFN84Nqbi2qFAzLr0ERhKyijomcIiPSDvN00LrrevSQy92vGi/sgPwjuUvjVA/Y
         0Ucw==
X-Gm-Message-State: APjAAAXWwt9wpPtsasFnuzQ+pu7MDzCOCuWt84luZ7jd0Q1ufHSDJvW9
        pHo0TnHM6/nEVs/FiJhVmvY25Y8J
X-Google-Smtp-Source: APXvYqzlEgVau3eSHEJ1mqgg3zyeeJzPyJljRkO6N1pWAC1CH8PFvdTS2n6VpB9idwwts2cQFBfbWg==
X-Received: by 2002:adf:ec49:: with SMTP id w9mr100550192wrn.303.1564220702367;
        Sat, 27 Jul 2019 02:45:02 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id r15sm59508835wrj.68.2019.07.27.02.45.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 02:45:01 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next 2/3] net: devlink: export devlink net set/get helpers
Date:   Sat, 27 Jul 2019 11:44:58 +0200
Message-Id: <20190727094459.26345-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727094459.26345-1-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us>
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
index ec024462e7d4..ad57058ed0d5 100644
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
@@ -695,7 +704,7 @@ static void devlink_netns_change(struct devlink *devlink, struct net *net)
 	if (net_eq(devlink_net(devlink), net))
 		return;
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
-	devlink_net_set(devlink, net);
+	__devlink_net_set(devlink, net);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 }
 
@@ -5602,7 +5611,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
-	devlink_net_set(devlink, &init_net);
+	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
@@ -5626,6 +5635,7 @@ int devlink_register(struct devlink *devlink, struct device *dev)
 {
 	mutex_lock(&devlink_mutex);
 	devlink->dev = dev;
+	devlink->registered = true;
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	mutex_unlock(&devlink_mutex);
-- 
2.21.0

