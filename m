Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B5BB2A30
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfINGqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35318 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfINGqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id g7so34106404wrx.2
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=inaniICqYj6ZMkKK1Tg+VqibvNJWq4jr9N2rQFwnnJA=;
        b=yNTbcAk3GVhvkw22TGGCBNQNEOjw26cAItC0Q5ty96YXS5xIGt7V+uVL7Yn46NiLjc
         PBghYLejXG5+lh2AZy3VG2t7dILIKEzR0327MRi3dwSJF6jgdZr5k0qDzb5VwfsXZSb8
         EF+KXROKVcd6pnijfWW127Cg1+kCjK8eiWwcKdb8puOZjA51qpcUPiyBfHRIGo+jqz8v
         lt2VZUpGYCSwx2tVM5oBnYE3+ktJV1vQCbqEeKieADYINooS7S2SfKHXslEh+p+1+XNh
         Wy9VqvinNbu17tf8Eq/s4W3qFyI9N9f3ZYZslA4JhQEUTfQtTziHv1FVE6Z3y6HMKcI+
         q+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=inaniICqYj6ZMkKK1Tg+VqibvNJWq4jr9N2rQFwnnJA=;
        b=ANoczmIL/bc39tn0e5Soyx/SYsErYlsD/5278lunr7yQ9xrbzhm0M7jYP+XkI124Pu
         05OEwZgHvWkHkGlMIW0ZVKFvID2CzfGtxzgd38eYSjyPWRb8/m3kgU76Yes5DS+D0juO
         fBwqsugF2T0FXuZqPOLetCRtZd3u2yKQ/MnzGXZEoalsGNs3YJ8W6Y26VAuHO/lWdjOh
         ywIpQK9pabGa3U2jFooD+6mDIz5oSe8RTkIdTw1NaIa3/+/3Xr39TusKqsLD4rAmhs+6
         Z6pbvbJTPFBvyD4yJh8FphkWS3veXCrH2+B2oD7ckj0a2n0XTlwStdzOw2TzJ2Jsk0NM
         odhA==
X-Gm-Message-State: APjAAAX7Pf2QMbDKXvFpaV372mPPy3qazxrc7C7uCm+w/QZzEG+4UdIx
        xeO3z9EUyZm0L9m+XBgVwtDrNoOERKc=
X-Google-Smtp-Source: APXvYqysBLBsL/hn7dRNtDVcFDCgx+yxQtqZLJC2utuIdNje+EJO6iVoXmm9CgXueG+6sO8HHfpUgg==
X-Received: by 2002:adf:e6c4:: with SMTP id y4mr7892122wrm.238.1568443580815;
        Fri, 13 Sep 2019 23:46:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d78sm5286207wmd.47.2019.09.13.23.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:20 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 11/15] netdevsim: implement proper devlink reload
Date:   Sat, 14 Sep 2019 08:46:04 +0200
Message-Id: <20190914064608.26799-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
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
 drivers/net/netdevsim/dev.c       | 137 +++++++++++++++++-------------
 drivers/net/netdevsim/fib.c       |  53 ++++++------
 drivers/net/netdevsim/netdevsim.h |   8 +-
 3 files changed, 109 insertions(+), 89 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 65e02b933aa3..ad376b443a34 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -466,37 +466,28 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 	kfree(nsim_dev->trap_data);
 }
 
+static struct nsim_dev *
+nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, struct nsim_dev *nsim_dev,
+		struct netlink_ext_ack *extack);
+static void nsim_dev_destroy(struct nsim_dev *nsim_dev, bool reload);
+
 static int nsim_dev_reload_down(struct devlink *devlink,
 				struct netlink_ext_ack *extack)
 {
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+
+	nsim_dev_destroy(nsim_dev, true);
 	return 0;
 }
 
 static int nsim_dev_reload_up(struct devlink *devlink,
 			      struct netlink_ext_ack *extack)
+
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
+	nsim_dev = nsim_dev_create(nsim_dev->nsim_bus_dev, nsim_dev, extack);
+	return PTR_ERR_OR_ZERO(nsim_dev);
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
@@ -685,15 +676,21 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 }
 
 static struct nsim_dev *
-nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
+nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, struct nsim_dev *nsim_dev,
+		struct netlink_ext_ack *extack)
 {
-	struct nsim_dev *nsim_dev;
+	bool reload = !!nsim_dev;
 	struct devlink *devlink;
 	int err;
 
-	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
-	if (!devlink)
-		return ERR_PTR(-ENOMEM);
+	if (!reload) {
+		devlink = devlink_alloc(&nsim_dev_devlink_ops,
+					sizeof(*nsim_dev));
+		if (!devlink)
+			return ERR_PTR(-ENOMEM);
+	} else {
+		devlink = priv_to_devlink(nsim_dev);
+	}
 	nsim_dev = devlink_priv(devlink);
 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
@@ -701,28 +698,35 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
-	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
-	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
 
-	err = nsim_dev_resources_register(devlink);
-	if (err)
-		goto err_devlink_free;
+	if (!reload) {
+		err = nsim_dev_resources_register(devlink);
+		if (err)
+			goto err_devlink_free;
+	}
 
-	nsim_dev->fib_data = nsim_fib_create(devlink);
+	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
 	if (IS_ERR(nsim_dev->fib_data)) {
 		err = PTR_ERR(nsim_dev->fib_data);
 		goto err_resources_unregister;
 	}
 
-	err = devlink_register(devlink, &nsim_bus_dev->dev);
-	if (err)
-		goto err_fib_destroy;
+	if (!reload) {
+		nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
+		nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
 
-	err = devlink_params_register(devlink, nsim_devlink_params,
-				      ARRAY_SIZE(nsim_devlink_params));
-	if (err)
-		goto err_dl_unregister;
-	nsim_devlink_set_params_init_values(nsim_dev, devlink);
+		err = devlink_register(devlink, &nsim_bus_dev->dev);
+		if (err)
+			goto err_fib_destroy;
+
+		err = devlink_params_register(devlink, nsim_devlink_params,
+					      ARRAY_SIZE(nsim_devlink_params));
+		if (err)
+			goto err_dl_unregister;
+		nsim_devlink_set_params_init_values(nsim_dev, devlink);
+	} else {
+		nsim_devlink_param_load_driverinit_values(devlink);
+	}
 
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
 	if (err)
@@ -744,7 +748,8 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_bpf_dev_exit;
 
-	devlink_params_publish(devlink);
+	if (reload)
+		devlink_params_publish(devlink);
 	return nsim_dev;
 
 err_bpf_dev_exit:
@@ -756,42 +761,54 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
 err_params_unregister:
-	devlink_params_unregister(devlink, nsim_devlink_params,
-				  ARRAY_SIZE(nsim_devlink_params));
+	if (!reload) {
+		devlink_params_unregister(devlink, nsim_devlink_params,
+					  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
-	devlink_unregister(devlink);
+		devlink_unregister(devlink);
+	}
 err_fib_destroy:
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_resources_unregister:
-	devlink_resources_unregister(devlink, NULL);
+	if (!reload) {
+		devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
-	devlink_free(devlink);
+		devlink_free(devlink);
+	}
 	return ERR_PTR(err);
 }
 
-static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
+static void nsim_dev_destroy(struct nsim_dev *nsim_dev, bool reload)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
-	nsim_dev_port_del_all(nsim_dev);
-	nsim_bpf_dev_exit(nsim_dev);
-	nsim_dev_debugfs_exit(nsim_dev);
-	nsim_dev_traps_exit(devlink);
-	nsim_dev_dummy_region_exit(nsim_dev);
-	devlink_params_unregister(devlink, nsim_devlink_params,
-				  ARRAY_SIZE(nsim_devlink_params));
-	devlink_unregister(devlink);
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
-	devlink_resources_unregister(devlink, NULL);
-	mutex_destroy(&nsim_dev->port_list_lock);
-	devlink_free(devlink);
+	if (!devlink_is_reload_failed(devlink)) {
+		nsim_dev_port_del_all(nsim_dev);
+		nsim_bpf_dev_exit(nsim_dev);
+		nsim_dev_debugfs_exit(nsim_dev);
+		nsim_dev_traps_exit(devlink);
+		nsim_dev_dummy_region_exit(nsim_dev);
+		mutex_destroy(&nsim_dev->port_list_lock);
+	}
+	if (!reload) {
+		devlink_params_unregister(devlink, nsim_devlink_params,
+					  ARRAY_SIZE(nsim_devlink_params));
+		devlink_unregister(devlink);
+	}
+	if (!devlink_is_reload_failed(devlink))
+		nsim_fib_destroy(devlink, nsim_dev->fib_data);
+	if (!reload) {
+		devlink_resources_unregister(devlink, NULL);
+		mutex_destroy(&nsim_dev->port_list_lock);
+		devlink_free(devlink);
+	}
 }
 
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 
-	nsim_dev = nsim_dev_create(nsim_bus_dev);
+	nsim_dev = nsim_dev_create(nsim_bus_dev, NULL, NULL);
 	if (IS_ERR(nsim_dev))
 		return PTR_ERR(nsim_dev);
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
@@ -803,7 +820,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 
-	nsim_dev_destroy(nsim_dev);
+	nsim_dev_destroy(nsim_dev, false);
 }
 
 static struct nsim_dev_port *
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

