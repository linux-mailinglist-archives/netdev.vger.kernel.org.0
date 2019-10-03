Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0646CC9B01
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbfJCJtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50436 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbfJCJtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so1755917wmg.0
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gcY6OH6CerAp+h1ixV74w5u9OlTGVYyJE9fYPIhYnjk=;
        b=tCn3UgPsQpAwg+gXF+yjWpn7MAh9KJnZ1vxSyyR2pi9gSF9sdf65XGj/ka9t0DbBzB
         jzjWhpB1JHInrlwzWarDBTHANWjag8ddIF5yBDYu8VLsrVnPuo3tHJzSD7dTWmzM/n1y
         6Lkg0qDubTNMaDVI7eQ5pas29bEdAMeSfJyIQEjKxaOYox98h/RT8iJxj1OttxQmIoVt
         KiJuhdYgT6iXkHZEFIIq8KwI+gOnaqoN+BqDbrFJZLuJv9IUlIYBL9hdA7F+8dNdh2oi
         8DRCRwiL199O/SIu9wsXDJTdRvYRKN1T5IsBqNdpVb5CZtRjMH1sCHUIYKH7jcE+DE78
         ItVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gcY6OH6CerAp+h1ixV74w5u9OlTGVYyJE9fYPIhYnjk=;
        b=OQl9cVhg8b3HxDBMTWAB6KKQm+idxqVC8K0joNp3n04gXFhCMsFKu61bckXBZ3kg0k
         rcJMjntURTE7nBIU3YIX0hKYM/aaHzxMwMf66O/jP+7ysnqX1V5oLBSXR6YXG5glxEVS
         BhXbpMd3phBL07oy4/WeD/URPanU4vfvIlXY2XL4rR7CAYnNVJVnTpjofLis23EmALN5
         /YmMBXYmJIF51LRBpk9suCsB3aOBToH7a+Qnisb0YBBQubgBzoMnZ23HQv0nPeDFBB1B
         h95ZW/2kF6fLX+vBa2tj0pkriHLXMD5OFiXjEOQvMmL1syr0H3Gtx03oVHR1dLbZBvyB
         5noA==
X-Gm-Message-State: APjAAAWoxzJyfY4IcMWC9sBhF/e0f27H1YBjZF7oMGjMfLjcbzDWshxZ
        3sqX2TR2EozDtoWs3KLu3DBodi1uGeE=
X-Google-Smtp-Source: APXvYqyRmfPQWr2FCvO+/lrIEHbs41x4PIkn6X347ift0clhGKWRZU7KaC+tY7PqzvqKtW17uOBVsQ==
X-Received: by 2002:a7b:c7d7:: with SMTP id z23mr2479487wmk.137.1570096182945;
        Thu, 03 Oct 2019 02:49:42 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id t18sm2115681wmi.44.2019.10.03.02.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:42 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 01/15] netdevsim: change fib accounting and limitations to be per-device
Date:   Thu,  3 Oct 2019 11:49:26 +0200
Message-Id: <20191003094940.9797-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, the accounting is done per-namespace. However, devlink
instance is always in init_net namespace for now, so only the accounting
related to init_net is used. Limitations set using devlink resources
are only considered for init_net. nsim_devlink_net() always
returns init_net always.

Make the accounting per-device. This brings no functional change.
Per-device accounting has the same values as per-net.
For a single netdevsim instance, the behaviour is exactly the same
as before. When multiple netdevsim instances are created, each
can have different limits.

This is in prepare to implement proper devlink netns support. After
that, the devlink instance which would exist in particular netns would
account and limit that netns.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c       |  79 ++++------------
 drivers/net/netdevsim/fib.c       | 144 +++++++++++++++++++-----------
 drivers/net/netdevsim/netdev.c    |   9 +-
 drivers/net/netdevsim/netdevsim.h |  10 ++-
 4 files changed, 114 insertions(+), 128 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 56576d4f34a5..6087f5b99e47 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -123,39 +123,6 @@ static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_port)
 	debugfs_remove_recursive(nsim_dev_port->ddir);
 }
 
-static struct net *nsim_devlink_net(struct devlink *devlink)
-{
-	return &init_net;
-}
-
-static u64 nsim_dev_ipv4_fib_resource_occ_get(void *priv)
-{
-	struct net *net = priv;
-
-	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB, false);
-}
-
-static u64 nsim_dev_ipv4_fib_rules_res_occ_get(void *priv)
-{
-	struct net *net = priv;
-
-	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB_RULES, false);
-}
-
-static u64 nsim_dev_ipv6_fib_resource_occ_get(void *priv)
-{
-	struct net *net = priv;
-
-	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB, false);
-}
-
-static u64 nsim_dev_ipv6_fib_rules_res_occ_get(void *priv)
-{
-	struct net *net = priv;
-
-	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB_RULES, false);
-}
-
 static int nsim_dev_resources_register(struct devlink *devlink)
 {
 	struct devlink_resource_size_params params = {
@@ -163,9 +130,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		.size_granularity = 1,
 		.unit = DEVLINK_RESOURCE_UNIT_ENTRY
 	};
-	struct net *net = nsim_devlink_net(devlink);
 	int err;
-	u64 n;
 
 	/* Resources for IPv4 */
 	err = devlink_resource_register(devlink, "IPv4", (u64)-1,
@@ -177,8 +142,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		goto out;
 	}
 
-	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB, true);
-	err = devlink_resource_register(devlink, "fib", n,
+	err = devlink_resource_register(devlink, "fib", (u64)-1,
 					NSIM_RESOURCE_IPV4_FIB,
 					NSIM_RESOURCE_IPV4, &params);
 	if (err) {
@@ -186,8 +150,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
-	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB_RULES, true);
-	err = devlink_resource_register(devlink, "fib-rules", n,
+	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
 					NSIM_RESOURCE_IPV4_FIB_RULES,
 					NSIM_RESOURCE_IPV4, &params);
 	if (err) {
@@ -205,8 +168,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		goto out;
 	}
 
-	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB, true);
-	err = devlink_resource_register(devlink, "fib", n,
+	err = devlink_resource_register(devlink, "fib", (u64)-1,
 					NSIM_RESOURCE_IPV6_FIB,
 					NSIM_RESOURCE_IPV6, &params);
 	if (err) {
@@ -214,8 +176,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
-	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB_RULES, true);
-	err = devlink_resource_register(devlink, "fib-rules", n,
+	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
 					NSIM_RESOURCE_IPV6_FIB_RULES,
 					NSIM_RESOURCE_IPV6, &params);
 	if (err) {
@@ -223,22 +184,6 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV4_FIB,
-					  nsim_dev_ipv4_fib_resource_occ_get,
-					  net);
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV4_FIB_RULES,
-					  nsim_dev_ipv4_fib_rules_res_occ_get,
-					  net);
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV6_FIB,
-					  nsim_dev_ipv6_fib_resource_occ_get,
-					  net);
-	devlink_resource_occ_get_register(devlink,
-					  NSIM_RESOURCE_IPV6_FIB_RULES,
-					  nsim_dev_ipv6_fib_rules_res_occ_get,
-					  net);
 out:
 	return err;
 }
@@ -533,11 +478,11 @@ static int nsim_dev_reload_down(struct devlink *devlink,
 static int nsim_dev_reload_up(struct devlink *devlink,
 			      struct netlink_ext_ack *extack)
 {
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	enum nsim_resource_id res_ids[] = {
 		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
 		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
 	};
-	struct net *net = nsim_devlink_net(devlink);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(res_ids); ++i) {
@@ -546,7 +491,8 @@ static int nsim_dev_reload_up(struct devlink *devlink,
 
 		err = devlink_resource_size_get(devlink, res_ids[i], &val);
 		if (!err) {
-			err = nsim_fib_set_max(net, res_ids[i], val, extack);
+			err = nsim_fib_set_max(nsim_dev->fib_data,
+					       res_ids[i], val, extack);
 			if (err)
 				return err;
 		}
@@ -681,9 +627,15 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	if (err)
 		goto err_devlink_free;
 
+	nsim_dev->fib_data = nsim_fib_create(devlink);
+	if (IS_ERR(nsim_dev->fib_data)) {
+		err = PTR_ERR(nsim_dev->fib_data);
+		goto err_resources_unregister;
+	}
+
 	err = devlink_register(devlink, &nsim_bus_dev->dev);
 	if (err)
-		goto err_resources_unregister;
+		goto err_fib_destroy;
 
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
@@ -721,6 +673,8 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
 	devlink_unregister(devlink);
+err_fib_destroy:
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_resources_unregister:
 	devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
@@ -739,6 +693,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	devlink_resources_unregister(devlink, NULL);
 	mutex_destroy(&nsim_dev->port_list_lock);
 	devlink_free(devlink);
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index f61d094746c0..7de17e42d77a 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -18,7 +18,7 @@
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
 #include <net/fib_rules.h>
-#include <net/netns/generic.h>
+#include <net/net_namespace.h>
 
 #include "netdevsim.h"
 
@@ -33,15 +33,14 @@ struct nsim_per_fib_data {
 };
 
 struct nsim_fib_data {
+	struct notifier_block fib_nb;
 	struct nsim_per_fib_data ipv4;
 	struct nsim_per_fib_data ipv6;
 };
 
-static unsigned int nsim_fib_net_id;
-
-u64 nsim_fib_get_val(struct net *net, enum nsim_resource_id res_id, bool max)
+u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
+		     enum nsim_resource_id res_id, bool max)
 {
-	struct nsim_fib_data *fib_data = net_generic(net, nsim_fib_net_id);
 	struct nsim_fib_entry *entry;
 
 	switch (res_id) {
@@ -64,10 +63,10 @@ u64 nsim_fib_get_val(struct net *net, enum nsim_resource_id res_id, bool max)
 	return max ? entry->max : entry->num;
 }
 
-int nsim_fib_set_max(struct net *net, enum nsim_resource_id res_id, u64 val,
+int nsim_fib_set_max(struct nsim_fib_data *fib_data,
+		     enum nsim_resource_id res_id, u64 val,
 		     struct netlink_ext_ack *extack)
 {
-	struct nsim_fib_data *fib_data = net_generic(net, nsim_fib_net_id);
 	struct nsim_fib_entry *entry;
 	int err = 0;
 
@@ -120,9 +119,9 @@ static int nsim_fib_rule_account(struct nsim_fib_entry *entry, bool add,
 	return err;
 }
 
-static int nsim_fib_rule_event(struct fib_notifier_info *info, bool add)
+static int nsim_fib_rule_event(struct nsim_fib_data *data,
+			       struct fib_notifier_info *info, bool add)
 {
-	struct nsim_fib_data *data = net_generic(info->net, nsim_fib_net_id);
 	struct netlink_ext_ack *extack = info->extack;
 	int err = 0;
 
@@ -157,9 +156,9 @@ static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
 	return err;
 }
 
-static int nsim_fib_event(struct fib_notifier_info *info, bool add)
+static int nsim_fib_event(struct nsim_fib_data *data,
+			  struct fib_notifier_info *info, bool add)
 {
-	struct nsim_fib_data *data = net_generic(info->net, nsim_fib_net_id);
 	struct netlink_ext_ack *extack = info->extack;
 	int err = 0;
 
@@ -178,18 +177,25 @@ static int nsim_fib_event(struct fib_notifier_info *info, bool add)
 static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
+	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
+						  fib_nb);
 	struct fib_notifier_info *info = ptr;
 	int err = 0;
 
+	if (!net_eq(info->net, &init_net))
+		return NOTIFY_DONE;
+
 	switch (event) {
 	case FIB_EVENT_RULE_ADD: /* fall through */
 	case FIB_EVENT_RULE_DEL:
-		err = nsim_fib_rule_event(info, event == FIB_EVENT_RULE_ADD);
+		err = nsim_fib_rule_event(data, info,
+					  event == FIB_EVENT_RULE_ADD);
 		break;
 
 	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
-		err = nsim_fib_event(info, event == FIB_EVENT_ENTRY_ADD);
+		err = nsim_fib_event(data, info,
+				     event == FIB_EVENT_ENTRY_ADD);
 		break;
 	}
 
@@ -199,68 +205,98 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 /* inconsistent dump, trying again */
 static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 {
-	struct nsim_fib_data *data;
-	struct net *net;
+	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
+						  fib_nb);
 
-	rcu_read_lock();
-	for_each_net_rcu(net) {
-		data = net_generic(net, nsim_fib_net_id);
+	data->ipv4.fib.num = 0ULL;
+	data->ipv4.rules.num = 0ULL;
+	data->ipv6.fib.num = 0ULL;
+	data->ipv6.rules.num = 0ULL;
+}
 
-		data->ipv4.fib.num = 0ULL;
-		data->ipv4.rules.num = 0ULL;
+static u64 nsim_fib_ipv4_resource_occ_get(void *priv)
+{
+	struct nsim_fib_data *data = priv;
 
-		data->ipv6.fib.num = 0ULL;
-		data->ipv6.rules.num = 0ULL;
-	}
-	rcu_read_unlock();
+	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV4_FIB, false);
 }
 
-static struct notifier_block nsim_fib_nb = {
-	.notifier_call = nsim_fib_event_nb,
-};
-
-/* Initialize per network namespace state */
-static int __net_init nsim_fib_netns_init(struct net *net)
+static u64 nsim_fib_ipv4_rules_res_occ_get(void *priv)
 {
-	struct nsim_fib_data *data = net_generic(net, nsim_fib_net_id);
+	struct nsim_fib_data *data = priv;
 
-	data->ipv4.fib.max = (u64)-1;
-	data->ipv4.rules.max = (u64)-1;
+	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV4_FIB_RULES, false);
+}
 
-	data->ipv6.fib.max = (u64)-1;
-	data->ipv6.rules.max = (u64)-1;
+static u64 nsim_fib_ipv6_resource_occ_get(void *priv)
+{
+	struct nsim_fib_data *data = priv;
 
-	return 0;
+	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV6_FIB, false);
 }
 
-static struct pernet_operations nsim_fib_net_ops = {
-	.init = nsim_fib_netns_init,
-	.id   = &nsim_fib_net_id,
-	.size = sizeof(struct nsim_fib_data),
-};
-
-void nsim_fib_exit(void)
+static u64 nsim_fib_ipv6_rules_res_occ_get(void *priv)
 {
-	unregister_pernet_subsys(&nsim_fib_net_ops);
-	unregister_fib_notifier(&nsim_fib_nb);
+	struct nsim_fib_data *data = priv;
+
+	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV6_FIB_RULES, false);
 }
 
-int nsim_fib_init(void)
+struct nsim_fib_data *nsim_fib_create(struct devlink *devlink)
 {
+	struct nsim_fib_data *data;
 	int err;
 
-	err = register_pernet_subsys(&nsim_fib_net_ops);
-	if (err < 0) {
-		pr_err("Failed to register pernet subsystem\n");
-		goto err_out;
-	}
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
 
-	err = register_fib_notifier(&nsim_fib_nb, nsim_fib_dump_inconsistent);
-	if (err < 0) {
+	data->ipv4.fib.max = (u64)-1;
+	data->ipv4.rules.max = (u64)-1;
+
+	data->ipv6.fib.max = (u64)-1;
+	data->ipv6.rules.max = (u64)-1;
+
+	data->fib_nb.notifier_call = nsim_fib_event_nb;
+	err = register_fib_notifier(&data->fib_nb, nsim_fib_dump_inconsistent);
+	if (err) {
 		pr_err("Failed to register fib notifier\n");
 		goto err_out;
 	}
 
+	devlink_resource_occ_get_register(devlink,
+					  NSIM_RESOURCE_IPV4_FIB,
+					  nsim_fib_ipv4_resource_occ_get,
+					  data);
+	devlink_resource_occ_get_register(devlink,
+					  NSIM_RESOURCE_IPV4_FIB_RULES,
+					  nsim_fib_ipv4_rules_res_occ_get,
+					  data);
+	devlink_resource_occ_get_register(devlink,
+					  NSIM_RESOURCE_IPV6_FIB,
+					  nsim_fib_ipv6_resource_occ_get,
+					  data);
+	devlink_resource_occ_get_register(devlink,
+					  NSIM_RESOURCE_IPV6_FIB_RULES,
+					  nsim_fib_ipv6_rules_res_occ_get,
+					  data);
+	return data;
+
 err_out:
-	return err;
+	kfree(data);
+	return ERR_PTR(err);
+}
+
+void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
+{
+	devlink_resource_occ_get_unregister(devlink,
+					    NSIM_RESOURCE_IPV6_FIB_RULES);
+	devlink_resource_occ_get_unregister(devlink,
+					    NSIM_RESOURCE_IPV6_FIB);
+	devlink_resource_occ_get_unregister(devlink,
+					    NSIM_RESOURCE_IPV4_FIB_RULES);
+	devlink_resource_occ_get_unregister(devlink,
+					    NSIM_RESOURCE_IPV4_FIB);
+	unregister_fib_notifier(&data->fib_nb);
+	kfree(data);
 }
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 55f57f76d01b..0740940f41b1 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -357,18 +357,12 @@ static int __init nsim_module_init(void)
 	if (err)
 		goto err_dev_exit;
 
-	err = nsim_fib_init();
-	if (err)
-		goto err_bus_exit;
-
 	err = rtnl_link_register(&nsim_link_ops);
 	if (err)
-		goto err_fib_exit;
+		goto err_bus_exit;
 
 	return 0;
 
-err_fib_exit:
-	nsim_fib_exit();
 err_bus_exit:
 	nsim_bus_exit();
 err_dev_exit:
@@ -379,7 +373,6 @@ static int __init nsim_module_init(void)
 static void __exit nsim_module_exit(void)
 {
 	rtnl_link_unregister(&nsim_link_ops);
-	nsim_fib_exit();
 	nsim_bus_exit();
 	nsim_dev_exit();
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 66bf13765ad0..ac506cf253b6 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -173,10 +173,12 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 		      unsigned int port_index);
 
-int nsim_fib_init(void);
-void nsim_fib_exit(void);
-u64 nsim_fib_get_val(struct net *net, enum nsim_resource_id res_id, bool max);
-int nsim_fib_set_max(struct net *net, enum nsim_resource_id res_id, u64 val,
+struct nsim_fib_data *nsim_fib_create(struct devlink *devlink);
+void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data);
+u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
+		     enum nsim_resource_id res_id, bool max);
+int nsim_fib_set_max(struct nsim_fib_data *fib_data,
+		     enum nsim_resource_id res_id, u64 val,
 		     struct netlink_ext_ack *extack);
 
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
-- 
2.21.0

