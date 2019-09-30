Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC3C1CAF
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfI3IPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:15:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33569 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729804AbfI3IPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:15:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id r17so13513072wme.0
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 01:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qoVVhuh9/+xhqc+MBvKflQ/C4bDn0sYNe5PgtXFqAx8=;
        b=UWQ4WnBX1tgPWMUwzAXO4qt6uTtXk28cel2XkmlTGGpB8FBXoe9NsQhlexF1xQOdD3
         Mk5NajlQGf3/YMSpBDshs+61aA60gJom57UwMwSwKnIF13ZcynAbvNJyfY6DoDKQbgmn
         V784xAy38/Ejh/D1Rbdq/1rNn+7WE+495Cokz6/OLnDVFWbliVGWr+42fZpFTul+Ohbp
         gDcUVpbVsFdzrktp+B36BCWF+Y+14DBLheFEzT3wz//EteHsEyEryJ/nUvNYYe9L0V5E
         ImwN7dFYgus/3116TYdOwSdNCKiEdPNMVAKFAZYXH9oRlCqBTTc68O19JP4j/a1CMioN
         Z3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qoVVhuh9/+xhqc+MBvKflQ/C4bDn0sYNe5PgtXFqAx8=;
        b=JAUZe145fNly8gJNqXCz4APmZlKs0hftmj11yvGDebiIvC/HXunMJDkXB0XYo+T2vY
         obQm1fpWoq31xRGTl8xqmXmctYI9Bx75BpbmlHTsTbqnrpHlUH8F5ZW3N1uEtDZrmPKV
         HIzYAD/1dhD5VouP8e/HwVH6q7MrUH3Svp6HVgogRMihXJWyqLJ9eDWDVyGxYG297WGn
         w1d/8mk1E0aTB6K2h+ONUwbHJvweIV+zT7NXEnAGG6luAzWVATFMSdJH+qAkn8NmiZkv
         c7U4mFcrUyFEiBFpHoLvdAPr7UsSVUKpK9ZMtURDl/GyJfqZ238R/PUKJ/U4HQTJGko3
         FtUw==
X-Gm-Message-State: APjAAAVEDuYjSfo4RVesJ5AMH5N4LDZ/4IrhFqH8Q/2fZu9sgkv9Cgr7
        9Uqf+ZQVQIzahzpXflkqDrm30hO8iVI=
X-Google-Smtp-Source: APXvYqzi2Ky1jdhU5vTdoebZENbeJgFMeBnLdcoBCzYRnnPB9weC9wUGykLfZXViySceJ20QQ1eTwg==
X-Received: by 2002:a1c:d185:: with SMTP id i127mr16029429wmg.28.1569831313832;
        Mon, 30 Sep 2019 01:15:13 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id t8sm10559013wrx.76.2019.09.30.01.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 01:15:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, pabeni@redhat.com,
        edumazet@google.com, petrm@mellanox.com, sd@queasysnail.net,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: [patch net-next 1/3] net: push loops and nb calls into helper functions
Date:   Mon, 30 Sep 2019 10:15:09 +0200
Message-Id: <20190930081511.26915-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930081511.26915-1-jiri@resnulli.us>
References: <20190930081511.26915-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Push iterations over net namespaces and netdevices from
register_netdevice_notifier() and unregister_netdevice_notifier()
into helper functions. Along with that introduce continue_reverse macros
to make the code a bit nicer allowing to get rid of "last" marks.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/netdevice.h   |  3 ++
 include/net/net_namespace.h |  3 +-
 net/core/dev.c              | 89 +++++++++++++++++++++++++------------
 3 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9eda1c31d1f7..4f390eec106b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2564,6 +2564,9 @@ extern rwlock_t				dev_base_lock;		/* Device list lock */
 		list_for_each_entry_safe(d, n, &(net)->dev_base_head, dev_list)
 #define for_each_netdev_continue(net, d)		\
 		list_for_each_entry_continue(d, &(net)->dev_base_head, dev_list)
+#define for_each_netdev_continue_reverse(net, d)		\
+		list_for_each_entry_continue_reverse(d, &(net)->dev_base_head, \
+						     dev_list)
 #define for_each_netdev_continue_rcu(net, d)		\
 	list_for_each_entry_continue_rcu(d, &(net)->dev_base_head, dev_list)
 #define for_each_netdev_in_bond_rcu(bond, slave)	\
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index f8712bbeb2e0..c5a98e03591d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -317,7 +317,8 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 /* Protected by net_rwsem */
 #define for_each_net(VAR)				\
 	list_for_each_entry(VAR, &net_namespace_list, list)
-
+#define for_each_net_continue_reverse(VAR)		\
+	list_for_each_entry_continue_reverse(VAR, &net_namespace_list, list)
 #define for_each_net_rcu(VAR)				\
 	list_for_each_entry_rcu(VAR, &net_namespace_list, list)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abaf..6a87d0e71201 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1617,6 +1617,62 @@ static int call_netdevice_notifier(struct notifier_block *nb, unsigned long val,
 	return nb->notifier_call(nb, val, &info);
 }
 
+static int call_netdevice_register_notifiers(struct notifier_block *nb,
+					     struct net_device *dev)
+{
+	int err;
+
+	err = call_netdevice_notifier(nb, NETDEV_REGISTER, dev);
+	err = notifier_to_errno(err);
+	if (err)
+		return err;
+
+	if (!(dev->flags & IFF_UP))
+		return 0;
+
+	call_netdevice_notifier(nb, NETDEV_UP, dev);
+	return 0;
+}
+
+static void call_netdevice_unregister_notifiers(struct notifier_block *nb,
+						struct net_device *dev)
+{
+	if (dev->flags & IFF_UP) {
+		call_netdevice_notifier(nb, NETDEV_GOING_DOWN,
+					dev);
+		call_netdevice_notifier(nb, NETDEV_DOWN, dev);
+	}
+	call_netdevice_notifier(nb, NETDEV_UNREGISTER, dev);
+}
+
+static int call_netdevice_register_net_notifiers(struct notifier_block *nb,
+						 struct net *net)
+{
+	struct net_device *dev;
+	int err;
+
+	for_each_netdev(net, dev) {
+		err = call_netdevice_register_notifiers(nb, dev);
+		if (err)
+			goto rollback;
+	}
+	return 0;
+
+rollback:
+	for_each_netdev_continue_reverse(net, dev)
+		call_netdevice_unregister_notifiers(nb, dev);
+	return err;
+}
+
+static void call_netdevice_unregister_net_notifiers(struct notifier_block *nb,
+						    struct net *net)
+{
+	struct net_device *dev;
+
+	for_each_netdev(net, dev)
+		call_netdevice_unregister_notifiers(nb, dev);
+}
+
 static int dev_boot_phase = 1;
 
 /**
@@ -1635,8 +1691,6 @@ static int dev_boot_phase = 1;
 
 int register_netdevice_notifier(struct notifier_block *nb)
 {
-	struct net_device *dev;
-	struct net_device *last;
 	struct net *net;
 	int err;
 
@@ -1649,17 +1703,9 @@ int register_netdevice_notifier(struct notifier_block *nb)
 	if (dev_boot_phase)
 		goto unlock;
 	for_each_net(net) {
-		for_each_netdev(net, dev) {
-			err = call_netdevice_notifier(nb, NETDEV_REGISTER, dev);
-			err = notifier_to_errno(err);
-			if (err)
-				goto rollback;
-
-			if (!(dev->flags & IFF_UP))
-				continue;
-
-			call_netdevice_notifier(nb, NETDEV_UP, dev);
-		}
+		err = call_netdevice_register_net_notifiers(nb, net);
+		if (err)
+			goto rollback;
 	}
 
 unlock:
@@ -1668,22 +1714,9 @@ int register_netdevice_notifier(struct notifier_block *nb)
 	return err;
 
 rollback:
-	last = dev;
-	for_each_net(net) {
-		for_each_netdev(net, dev) {
-			if (dev == last)
-				goto outroll;
-
-			if (dev->flags & IFF_UP) {
-				call_netdevice_notifier(nb, NETDEV_GOING_DOWN,
-							dev);
-				call_netdevice_notifier(nb, NETDEV_DOWN, dev);
-			}
-			call_netdevice_notifier(nb, NETDEV_UNREGISTER, dev);
-		}
-	}
+	for_each_net_continue_reverse(net)
+		call_netdevice_unregister_net_notifiers(nb, net);
 
-outroll:
 	raw_notifier_chain_unregister(&netdev_chain, nb);
 	goto unlock;
 }
-- 
2.21.0

