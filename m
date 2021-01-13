Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681B42F4B16
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbhAMMNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbhAMMNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:47 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95A8C0617A5
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:34 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id y187so1402789wmd.3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w7tEKM8STzYMPv/IRNCUuYVAkgY7njbrDoavQWdwiy4=;
        b=LdcwkXNtZp8GXY0OiBYvmdMmH1EtTi2vgQa7cz6tmFuMR1EucG+93TvLVhcY8MWQ9E
         PzA3UbLMdl+80o+Ptw+Si3SQA4kY1DneF9qrVGd/5MgmDkHlhEqjPwKBg2NLZ3mtrt9P
         oQhceXjQUNZ4iA4qqs6Aep1eZ6Hsn+mGjWDTE02szL3KXO44BI+2CYD2uJsLTtK1pk3s
         Ad/QumlR2fO718xHSO6ZzsRZWBEYlX8c4tmHEVdNOUNDVNNJL+cO/UGlr0jzY3roiVm0
         /xPcA9qP6Bap2pz98C0qNEB7jpkhm37+th/0krGEvz3U+NkpDSmwvJhdWJvDm7grMbI3
         3etw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w7tEKM8STzYMPv/IRNCUuYVAkgY7njbrDoavQWdwiy4=;
        b=td1WGVC0XACBYvhux2syB21Ga/IhNMwYnjDKSWgblZmeW12/w1u66Ku2EdJliNoiTG
         mY6GRljSsbhEtAmDJEdrJw8SryK+Zu25dCxuT6k0GU1QJ+hTAqCndWT+YAtaRSSXy2k0
         JJFd+dQ5jAtujllG0SCSf6mu61DQ9gqwda3l5tMr4UCaImponXTRq990zT51+4Mpa8Sl
         eP9ZjIXis3N9tMiZeDdf7FiJdbgM9HNB2yrkxBGOVfLCRdN8eMk6Onm023qZucUX6wLy
         Ds2iYn+IUqv41OsWvJ8o+nfU5Ksl4wBLYBOerBaNuK25kmv5sOBleUDWEyM+yVI4DQ1l
         /N4Q==
X-Gm-Message-State: AOAM530TOkolaHIZ3liD+72KePXk3m/N9kxMaVQbAAnarGME/AEtoiuF
        nmrG4dw/UBrvWEq6MiTnq7BHzsREztR5GZ7y
X-Google-Smtp-Source: ABdhPJyBWxYC2i/N897dJ0k8qxHoJ69xMdK/uy2E7irJCTvYxF9aY1hBARb77l6PjSoLbFZrOBR4bg==
X-Received: by 2002:a1c:b742:: with SMTP id h63mr1918921wmf.122.1610539953152;
        Wed, 13 Jan 2021 04:12:33 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id u17sm2621431wmj.35.2021.01.13.04.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:32 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 08/10] netdevsim: create devlink line card object and implement provisioning
Date:   Wed, 13 Jan 2021 13:12:20 +0100
Message-Id: <20210113121222.733517-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
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
 drivers/net/netdevsim/dev.c       | 135 +++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |   4 +
 2 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e706317fc0f9..9e9a2a75ddf8 100644
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
@@ -1053,10 +1091,88 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
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
+	devlink_linecard_provision_clear(nsim_dev_linecard->devlink_linecard);
+}
+
+static int nsim_dev_linecard_provision(struct devlink_linecard *linecard,
+				       void *priv, u32 type_index,
+				       struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = priv;
+
+	nsim_dev_linecard->type_index = type_index;
+	INIT_WORK(&nsim_dev_linecard->provision_work,
+		  nsim_dev_linecard_provision_work);
+	schedule_work(&nsim_dev_linecard->provision_work);
+
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
+					 provision_work);
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
+	INIT_WORK(&nsim_dev_linecard->provision_work,
+		  nsim_dev_linecard_unprovision_work);
+	schedule_work(&nsim_dev_linecard->provision_work);
+
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
@@ -1066,14 +1182,27 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
 	nsim_dev_linecard->linecard_index = linecard_index;
 	INIT_LIST_HEAD(&nsim_dev_linecard->port_list);
 
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
+
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
@@ -1081,8 +1210,12 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
 
 static void __nsim_dev_linecard_del(struct nsim_dev_linecard *nsim_dev_linecard)
 {
+	struct devlink_linecard *devlink_linecard =
+					nsim_dev_linecard->devlink_linecard;
+
 	list_del(&nsim_dev_linecard->list);
 	nsim_dev_linecard_debugfs_exit(nsim_dev_linecard);
+	devlink_linecard_destroy(devlink_linecard);
 	kfree(nsim_dev_linecard);
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 88b61b9390bf..ab217b361416 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -196,10 +196,14 @@ struct nsim_dev;
 
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
 };
 
 struct nsim_dev {
-- 
2.26.2

