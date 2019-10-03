Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D75BC9B0C
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbfJCJuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:50:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbfJCJt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id w12so2237541wro.5
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1tNfDrM3XP+tRvpb29Gurqo/I/g6egwahuVHMBqa6Es=;
        b=1QHnhTPk9yPsGC7+R5WeBDU82SWTr1Dy2j9H6819aA4hWQf5orLjt0/ZF7Y7j5d1Iz
         hIc2E4Uz1BgvuTnsZd5ue/nEfvp+K4s1ILXKs5IxlEvg7uV/gP5TXqK9RyNejz9Zocs/
         10n2/ZTNq3WfujrTsFOvsawlqRriiDuBhCI6+BHlHqD/bJVZNpqnPmxA//zWQ8Rvw1pP
         ycBB6AZ592u+X8NYdRhpmbBQE3Fpb0QLC+1CJfVVBWxG+ZZKelcx2on5bECUYzZ9adSH
         CWECO+Ykq4hUBHihU0LpV59iMX6KCv7YYqE/0J2r1DAd3StXD81J9cdB3+C69SOQHjDe
         Mqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1tNfDrM3XP+tRvpb29Gurqo/I/g6egwahuVHMBqa6Es=;
        b=lEATvGRW0TiBanlJoTaW6nwON2wgW/WTzVRx+GIBrm5WrWwCMrQtahhw7isfMeN4pa
         32Yle4/bA7/Se9O71D5OEc29dMqHeMZ4WhOMPnRhPAhdDmCPas2OhAX8yOkYWqdFL+Sk
         UkObphB4vVNrcssG9YIX6Hg5FS3jvUd/gaTLdChPaTqBN51J9aOjp0bZnugBSfu8iAxy
         F7hG+w4CALG+vNsD0JMtaCxagxt3Xwgteo2hjhEM25RYHNNs/YB1zV5nFB1veQnB+9Q9
         Ba2K2HfWXouKz62SWixQCWV5qX8bQtGy/gevuhzUF3lkSCQ4paMaNGlrBFxR+EB2+jkq
         eMFg==
X-Gm-Message-State: APjAAAXDTrdLV7PFtC3Yefyu2DBrVjG0Gt/kEZ9xS6WM71xiEZLLmitY
        4bBDmNckk4a7okXQz78be7RvseBdNW4=
X-Google-Smtp-Source: APXvYqw9sOi1R930I7PjSdp5YvXVNs5sitCzu+6X4O28TjzV4rbqOPyHYLd5BvGl4dYmPVzKxx1evA==
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr2269101wrr.23.1570096194511;
        Thu, 03 Oct 2019 02:49:54 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id w7sm2755075wmd.22.2019.10.03.02.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 11/15] netdevsim: implement proper devlink reload
Date:   Thu,  3 Oct 2019 11:49:36 +0200
Message-Id: <20191003094940.9797-12-jiri@resnulli.us>
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

During devlink reload, all driver objects should be reinstantiated with
the exception of devlink instance and devlink resources and params.
Move existing devlink_resource_size_get() calls into fib_create() just
before fib notifier is registered. Also, make sure that extack is
propagated down to fib_notifier_register() call.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- removed extra empty line in nsim_dev_reload_up()
- did separate create/destroy functions for reload and non-reload cases
v1->v2:
- don't reinstantiate debugfs during reload.
---
 drivers/net/netdevsim/dev.c       | 95 ++++++++++++++++++++++---------
 drivers/net/netdevsim/fib.c       | 53 +++++++++--------
 drivers/net/netdevsim/netdevsim.h |  8 +--
 3 files changed, 99 insertions(+), 57 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 3cc101aee991..7de80faab047 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -469,9 +469,16 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 	kfree(nsim_dev->trap_data);
 }
 
+static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
+				  struct netlink_ext_ack *extack);
+static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
+
 static int nsim_dev_reload_down(struct devlink *devlink,
 				struct netlink_ext_ack *extack)
 {
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+
+	nsim_dev_reload_destroy(nsim_dev);
 	return 0;
 }
 
@@ -479,27 +486,8 @@ static int nsim_dev_reload_up(struct devlink *devlink,
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	enum nsim_resource_id res_ids[] = {
-		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
-		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
-	};
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(res_ids); ++i) {
-		int err;
-		u64 val;
-
-		err = devlink_resource_size_get(devlink, res_ids[i], &val);
-		if (!err) {
-			err = nsim_fib_set_max(nsim_dev->fib_data,
-					       res_ids[i], val, extack);
-			if (err)
-				return err;
-		}
-	}
-	nsim_devlink_param_load_driverinit_values(devlink);
 
-	return 0;
+	return nsim_dev_reload_create(nsim_dev, extack);
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
@@ -687,8 +675,49 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	return err;
 }
 
-static struct nsim_dev *
-nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
+static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
+				  struct netlink_ext_ack *extack)
+{
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
+	struct devlink *devlink;
+	int err;
+
+	devlink = priv_to_devlink(nsim_dev);
+	nsim_dev = devlink_priv(devlink);
+	INIT_LIST_HEAD(&nsim_dev->port_list);
+	mutex_init(&nsim_dev->port_list_lock);
+	nsim_dev->fw_update_status = true;
+
+	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
+	if (IS_ERR(nsim_dev->fib_data))
+		return PTR_ERR(nsim_dev->fib_data);
+
+	nsim_devlink_param_load_driverinit_values(devlink);
+
+	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
+	if (err)
+		goto err_fib_destroy;
+
+	err = nsim_dev_traps_init(devlink);
+	if (err)
+		goto err_dummy_region_exit;
+
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_traps_exit;
+
+	return 0;
+
+err_traps_exit:
+	nsim_dev_traps_exit(devlink);
+err_dummy_region_exit:
+	nsim_dev_dummy_region_exit(nsim_dev);
+err_fib_destroy:
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
+	return err;
+}
+
+static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 	struct devlink *devlink;
@@ -711,7 +740,7 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_devlink_free;
 
-	nsim_dev->fib_data = nsim_fib_create(devlink);
+	nsim_dev->fib_data = nsim_fib_create(devlink, NULL);
 	if (IS_ERR(nsim_dev->fib_data)) {
 		err = PTR_ERR(nsim_dev->fib_data);
 		goto err_resources_unregister;
@@ -772,21 +801,31 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	return ERR_PTR(err);
 }
 
-static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
+static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
+	if (devlink_is_reload_failed(devlink))
+		return;
 	nsim_dev_port_del_all(nsim_dev);
-	nsim_bpf_dev_exit(nsim_dev);
-	nsim_dev_debugfs_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
+	mutex_destroy(&nsim_dev->port_list_lock);
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
+}
+
+static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
+{
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+
+	nsim_dev_reload_destroy(nsim_dev);
+
+	nsim_bpf_dev_exit(nsim_dev);
+	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	devlink_resources_unregister(devlink, NULL);
-	mutex_destroy(&nsim_dev->port_list_lock);
 	devlink_free(devlink);
 }
 
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index d2aeac0f4c2c..fdc682f3a09a 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -63,12 +63,10 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 	return max ? entry->max : entry->num;
 }
 
-int nsim_fib_set_max(struct nsim_fib_data *fib_data,
-		     enum nsim_resource_id res_id, u64 val,
-		     struct netlink_ext_ack *extack)
+static void nsim_fib_set_max(struct nsim_fib_data *fib_data,
+			     enum nsim_resource_id res_id, u64 val)
 {
 	struct nsim_fib_entry *entry;
-	int err = 0;
 
 	switch (res_id) {
 	case NSIM_RESOURCE_IPV4_FIB:
@@ -84,20 +82,10 @@ int nsim_fib_set_max(struct nsim_fib_data *fib_data,
 		entry = &fib_data->ipv6.rules;
 		break;
 	default:
-		return 0;
-	}
-
-	/* not allowing a new max to be less than curren occupancy
-	 * --> no means of evicting entries
-	 */
-	if (val < entry->num) {
-		NL_SET_ERR_MSG_MOD(extack, "New size is less than current occupancy");
-		err = -EINVAL;
-	} else {
-		entry->max = val;
+		WARN_ON(1);
+		return;
 	}
-
-	return err;
+	entry->max = val;
 }
 
 static int nsim_fib_rule_account(struct nsim_fib_entry *entry, bool add,
@@ -239,7 +227,28 @@ static u64 nsim_fib_ipv6_rules_res_occ_get(void *priv)
 	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV6_FIB_RULES, false);
 }
 
-struct nsim_fib_data *nsim_fib_create(struct devlink *devlink)
+static void nsim_fib_set_max_all(struct nsim_fib_data *data,
+				 struct devlink *devlink)
+{
+	enum nsim_resource_id res_ids[] = {
+		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
+		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(res_ids); i++) {
+		int err;
+		u64 val;
+
+		err = devlink_resource_size_get(devlink, res_ids[i], &val);
+		if (err)
+			val = (u64) -1;
+		nsim_fib_set_max(data, res_ids[i], val);
+	}
+}
+
+struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
+				      struct netlink_ext_ack *extack)
 {
 	struct nsim_fib_data *data;
 	int err;
@@ -248,15 +257,11 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink)
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	data->ipv4.fib.max = (u64)-1;
-	data->ipv4.rules.max = (u64)-1;
-
-	data->ipv6.fib.max = (u64)-1;
-	data->ipv6.rules.max = (u64)-1;
+	nsim_fib_set_max_all(data, devlink);
 
 	data->fib_nb.notifier_call = nsim_fib_event_nb;
 	err = register_fib_notifier(&init_net, &data->fib_nb,
-				    nsim_fib_dump_inconsistent, NULL);
+				    nsim_fib_dump_inconsistent, extack);
 	if (err) {
 		pr_err("Failed to register fib notifier\n");
 		goto err_out;
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index ac506cf253b6..702d951fe160 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -173,13 +173,11 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 		      unsigned int port_index);
 
-struct nsim_fib_data *nsim_fib_create(struct devlink *devlink);
-void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data);
+struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
+				      struct netlink_ext_ack *extack);
+void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *fib_data);
 u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 		     enum nsim_resource_id res_id, bool max);
-int nsim_fib_set_max(struct nsim_fib_data *fib_data,
-		     enum nsim_resource_id res_id, u64 val,
-		     struct netlink_ext_ack *extack);
 
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
 void nsim_ipsec_init(struct netdevsim *ns);
-- 
2.21.0

