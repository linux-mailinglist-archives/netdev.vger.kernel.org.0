Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D230003E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbhAVK1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbhAVJsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:13 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B35C061220
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:47:00 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id m187so3708701wme.2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kMnKgT+SQlYckkNyOccoRvPJo1WwKdsOM5DWodNKzXw=;
        b=uhrg4wFWaXh1ryF/RU4zcY5JJQpq0FpZlFOgeAaVD1BzpM9PBvIYTLkluDKsD1Unxi
         QZQ3cirHXNTWzZRKwYa0KBBmfXyq06xElzJCUdocM6WICtfJmrVDAKXrCH7QGsfbcHPH
         cBuuCJdv3oLo5LulSWZVKG5iRt+Pj0Wf327Tr5LlYeZxgxPUFr71vCxy80z57s/y5kx8
         IiwhmWo5Lvdg/8fR4Dof4XFnHvTsRqyFqK9wLomgM/urqgWpUei96Krgg+RTq17zIwK3
         RCBShfFIKrZs7B3HRRwZotQgLjqRaSKDwPwBdAngEDPBjfJQDNLW8ks28n6j0nkh+5mq
         wbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kMnKgT+SQlYckkNyOccoRvPJo1WwKdsOM5DWodNKzXw=;
        b=ekJ8EDsnIBe/4qs7zidNyhx++5hokMw0j2RWg/IfdstHaIPhzMTMRqdjuLcr8/1Inr
         +XgWI4zg45GYK7S+OWEPKMeP5BBGx6CKQd7ldv9jiMfzHWy1AR0XeGIyRp33Y7O6UoZw
         zgq0WHnO3zW9OzW67pTmSEiCuUsM1JCE+wHNLWQEP1rSlpkJt4A1qbIkMmEvoTr5rm6T
         6D+IoKgApoIPLsRXdjq2JniLSWmVjo/wxUjwdYDOBY2e8j4S/ooQF4oTrxrVT9rfw/HL
         c2Ds+8wx8CqaqS3BClrsKQXeB3Wpwf3bhHDl8jRe0QaJX/ucyUxR9d0gjfsNoKnv9op5
         hjfg==
X-Gm-Message-State: AOAM531XbrG3+b2vIo12YxkPqWk9o9VPhm/laYMbK5akyoIIGjQs27Vw
        N1KOo25cbCIhltGen4M4Ery7zp3MXWRvW6/R6gM=
X-Google-Smtp-Source: ABdhPJzatbCFinOwDCmMo+7KQNhlnjW4sHlrI9IHP96XLN6snpMQbXuS/1m8+jx/HXOZy4Djh6AZSg==
X-Received: by 2002:a1c:e255:: with SMTP id z82mr3152773wmg.60.1611308818780;
        Fri, 22 Jan 2021 01:46:58 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id p17sm10850062wmg.46.2021.01.22.01.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:58 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 08/10] netdevsim: create devlink line card object and implement provisioning
Date:   Fri, 22 Jan 2021 10:46:46 +0100
Message-Id: <20210122094648.1631078-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Use devlink_linecard_create/destroy() to register the line card with
devlink core. Implement provisioning ops with a list of supported
line cards. To avoid deadlock and to mimic actual HW flow, use workqueue
to add/del ports during provisioning as the port add/del calls
devlink_port_register/unregister() which take devlink mutex.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- cancel work in linecard_del, have separate work for unprovision
- call provision_set() without type
- use provision_fail() helper in case provisioning was not successful
---
 drivers/net/netdevsim/dev.c       | 135 +++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |   5 ++
 2 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e706317fc0f9..84daef00073b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -35,6 +35,20 @@
 
 #include "netdevsim.h"
 
+static const char * const nsim_dev_linecard_supported_types[] = {
+	"card1port", "card2ports", "card4ports",
+};
+
+static const unsigned int nsim_dev_linecard_port_counts[] = {
+	1, 2, 4,
+};
+
+static unsigned int
+nsim_dev_linecard_port_count(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	return nsim_dev_linecard_port_counts[nsim_dev_linecard->type_index];
+}
+
 #define NSIM_DEV_LINECARD_PORT_INDEX_BASE 1000
 #define NSIM_DEV_LINECARD_PORT_INDEX_STEP 100
 
@@ -285,6 +299,25 @@ static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_port)
 	debugfs_remove_recursive(nsim_dev_port->ddir);
 }
 
+static ssize_t nsim_dev_linecard_type_read(struct file *file, char __user *data,
+					   size_t count, loff_t *ppos)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = file->private_data;
+	const char *type;
+
+	if (!nsim_dev_linecard->provisioned)
+		return -EOPNOTSUPP;
+
+	type = nsim_dev_linecard_supported_types[nsim_dev_linecard->type_index];
+	return simple_read_from_buffer(data, count, ppos, type, strlen(type));
+}
+
+static const struct file_operations nsim_dev_linecard_type_fops = {
+	.open = simple_open,
+	.read = nsim_dev_linecard_type_read,
+	.owner = THIS_MODULE,
+};
+
 static int
 nsim_dev_linecard_debugfs_init(struct nsim_dev *nsim_dev,
 			       struct nsim_dev_linecard *nsim_dev_linecard)
@@ -301,6 +334,8 @@ nsim_dev_linecard_debugfs_init(struct nsim_dev *nsim_dev,
 	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
 		nsim_dev->nsim_bus_dev->dev.id);
 	debugfs_create_symlink("dev", nsim_dev_linecard->ddir, dev_link_name);
+	debugfs_create_file("type", 0400, nsim_dev_linecard->ddir,
+			    nsim_dev_linecard, &nsim_dev_linecard_type_fops);
 
 	return 0;
 }
@@ -977,6 +1012,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
+	if (nsim_dev_linecard)
+		devlink_port_linecard_set(devlink_port,
+					  nsim_dev_linecard->devlink_linecard);
 	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
 				    nsim_dev_port->port_index);
 	if (err)
@@ -1053,10 +1091,82 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	return err;
 }
 
+static void nsim_dev_linecard_provision_work(struct work_struct *work)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard;
+	struct nsim_bus_dev *nsim_bus_dev;
+	int err;
+	int i;
+
+	nsim_dev_linecard = container_of(work, struct nsim_dev_linecard,
+					 provision_work);
+
+	nsim_bus_dev = nsim_dev_linecard->nsim_dev->nsim_bus_dev;
+	for (i = 0; i < nsim_dev_linecard_port_count(nsim_dev_linecard); i++) {
+		err = nsim_dev_port_add(nsim_bus_dev, nsim_dev_linecard, i);
+		if (err)
+			goto err_port_del_all;
+	}
+	nsim_dev_linecard->provisioned = true;
+	devlink_linecard_provision_set(nsim_dev_linecard->devlink_linecard,
+				       nsim_dev_linecard->type_index);
+	return;
+
+err_port_del_all:
+	for (i--; i >= 0; i--)
+		nsim_dev_port_del(nsim_bus_dev, nsim_dev_linecard, i);
+	devlink_linecard_provision_fail(nsim_dev_linecard->devlink_linecard);
+}
+
+static int nsim_dev_linecard_provision(struct devlink_linecard *linecard,
+				       void *priv, u32 type_index,
+				       struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = priv;
+
+	nsim_dev_linecard->type_index = type_index;
+	schedule_work(&nsim_dev_linecard->provision_work);
+	return 0;
+}
+
+static void nsim_dev_linecard_unprovision_work(struct work_struct *work)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard;
+	struct nsim_bus_dev *nsim_bus_dev;
+	int i;
+
+	nsim_dev_linecard = container_of(work, struct nsim_dev_linecard,
+					 unprovision_work);
+
+	nsim_bus_dev = nsim_dev_linecard->nsim_dev->nsim_bus_dev;
+	nsim_dev_linecard->provisioned = false;
+	devlink_linecard_provision_clear(nsim_dev_linecard->devlink_linecard);
+	for (i = 0; i < nsim_dev_linecard_port_count(nsim_dev_linecard); i++)
+		nsim_dev_port_del(nsim_bus_dev, nsim_dev_linecard, i);
+}
+
+static int nsim_dev_linecard_unprovision(struct devlink_linecard *linecard,
+					 void *priv,
+					 struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = priv;
+
+	schedule_work(&nsim_dev_linecard->unprovision_work);
+	return 0;
+}
+
+static const struct devlink_linecard_ops nsim_dev_linecard_ops = {
+	.supported_types = nsim_dev_linecard_supported_types,
+	.supported_types_count = ARRAY_SIZE(nsim_dev_linecard_supported_types),
+	.provision = nsim_dev_linecard_provision,
+	.unprovision = nsim_dev_linecard_unprovision,
+};
+
 static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
 				   unsigned int linecard_index)
 {
 	struct nsim_dev_linecard *nsim_dev_linecard;
+	struct devlink_linecard *devlink_linecard;
 	int err;
 
 	nsim_dev_linecard = kzalloc(sizeof(*nsim_dev_linecard), GFP_KERNEL);
@@ -1065,15 +1175,32 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
 	nsim_dev_linecard->nsim_dev = nsim_dev;
 	nsim_dev_linecard->linecard_index = linecard_index;
 	INIT_LIST_HEAD(&nsim_dev_linecard->port_list);
+	INIT_WORK(&nsim_dev_linecard->provision_work,
+		  nsim_dev_linecard_provision_work);
+	INIT_WORK(&nsim_dev_linecard->unprovision_work,
+		  nsim_dev_linecard_unprovision_work);
+
+	devlink_linecard = devlink_linecard_create(priv_to_devlink(nsim_dev),
+						   linecard_index,
+						   &nsim_dev_linecard_ops,
+						   nsim_dev_linecard);
+	if (IS_ERR(devlink_linecard)) {
+		err = PTR_ERR(devlink_linecard);
+		goto err_linecard_free;
+	}
+
+	nsim_dev_linecard->devlink_linecard = devlink_linecard;
 
 	err = nsim_dev_linecard_debugfs_init(nsim_dev, nsim_dev_linecard);
 	if (err)
-		goto err_linecard_free;
+		goto err_dl_linecard_destroy;
 
 	list_add(&nsim_dev_linecard->list, &nsim_dev->linecard_list);
 
 	return 0;
 
+err_dl_linecard_destroy:
+	devlink_linecard_destroy(devlink_linecard);
 err_linecard_free:
 	kfree(nsim_dev_linecard);
 	return err;
@@ -1081,8 +1208,14 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
 
 static void __nsim_dev_linecard_del(struct nsim_dev_linecard *nsim_dev_linecard)
 {
+	struct devlink_linecard *devlink_linecard =
+					nsim_dev_linecard->devlink_linecard;
+
+	cancel_work_sync(&nsim_dev_linecard->provision_work);
+	cancel_work_sync(&nsim_dev_linecard->unprovision_work);
 	list_del(&nsim_dev_linecard->list);
 	nsim_dev_linecard_debugfs_exit(nsim_dev_linecard);
+	devlink_linecard_destroy(devlink_linecard);
 	kfree(nsim_dev_linecard);
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 88b61b9390bf..01edff939c3a 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -196,10 +196,15 @@ struct nsim_dev;
 
 struct nsim_dev_linecard {
 	struct list_head list;
+	struct devlink_linecard *devlink_linecard;
 	struct nsim_dev *nsim_dev;
 	struct list_head port_list;
 	unsigned int linecard_index;
 	struct dentry *ddir;
+	bool provisioned;
+	u32 type_index;
+	struct work_struct provision_work;
+	struct work_struct unprovision_work;
 };
 
 struct nsim_dev {
-- 
2.26.2

