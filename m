Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9A300068
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbhAVK1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbhAVJsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:13 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767FCC061221
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:47:01 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id 6so4450060wri.3
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y9B/h2ojqnkqmAUkgwrWgZ53kC5mimhV8wtUSRBmaRY=;
        b=aeE+sVqknSf7MwoeRVbKcwnT9Y+kPuW6gKRj/g+3jSyKkPBkPu3IY2NHk4ztOZYNWV
         NHlX1xW1VfgW85UbYDhOjXDh6dVrWtiA9v0qmmsE5WYk0O367byTaM5Z2FBfqigrQz+O
         ANsbAFGTyK+lzdSP9dlHi6l72OJZjUwmlOn/r2+FUxDLDvPYLG1NaqhWacDMvkhd7AK0
         U9hSTkrze/1C4GO6Zuo5Sv+QOBke7VZmzO4g1WKD/lWMA7vNF79Q+1yRz8VZTGjaDntK
         K43G9CUzE+DLd1FXBQHaeN8im0IOh56OX46zsje0kk8k53DpsWamYlTjIbes6eNJnvPF
         MYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y9B/h2ojqnkqmAUkgwrWgZ53kC5mimhV8wtUSRBmaRY=;
        b=mxKoCl1L3KrxHtoLqLzmxjcxAKnalUIdoANyx7Wqv9Fa5bQcT8xU73Sq2uMnqHoMu2
         bhzav6TPH2sZmjWzGcyFSGE1HMiiLSm7t2gr5rgdmHnpsM2dp+5S59jpHsu7YVgCb5rK
         5gI4qoDeNNMbRq5q/GDBb7jJCLXHpcpxl6hNbz8ebDMMnwnvZCfUP1H6QCt/CckPsPKf
         1Bm2zZG1XP3UR9jJuLRYSXm347B/66gonwzDu5VeQ8vXVbC/o+3WeEaBjHlQqz6jab0A
         yu3MGTZci8wgNrZWDAKsTLFkQLaK2+rrAMwqQ8cDoLtQa89P8g7Sw0oWZOXsZIt4f9LI
         V1Qg==
X-Gm-Message-State: AOAM533ZQYJ8BwbvIdv6ynhx0L5lUpRfIVcJsXbgy2Obmgk6EiC0nnq1
        Ge6+JA890lPPqxryZmcXXSYnYH0hd/58qZqn7ms=
X-Google-Smtp-Source: ABdhPJwshG3v9z8Eym7zQMZM6oR4xRDTRGLO22Qh1LwHdmWeyiNC21YpQQkbcY63ntWTdWMMf9/ekw==
X-Received: by 2002:a5d:51cc:: with SMTP id n12mr3540252wrv.375.1611308819932;
        Fri, 22 Jan 2021 01:46:59 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o9sm12308152wrw.81.2021.01.22.01.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 09/10] netdevsim: implement line card activation
Date:   Fri, 22 Jan 2021 10:46:47 +0100
Message-Id: <20210122094648.1631078-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

On real HW, the activation typically happens upon line card insertion.
Emulate such event using write to debugfs file "inserted_type".

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- converted bool "active" to string "inserted_type" and adjust loginc
  around it wrt provision/unprovision work
---
 drivers/net/netdevsim/dev.c       | 136 ++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |   2 +
 2 files changed, 138 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 84daef00073b..d37e69fc13d6 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -43,6 +43,16 @@ static const unsigned int nsim_dev_linecard_port_counts[] = {
 	1, 2, 4,
 };
 
+static int nsim_dev_linecard_type_index(const char *type)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nsim_dev_linecard_supported_types); i++)
+		if (!strcmp(nsim_dev_linecard_supported_types[i], type))
+			return i;
+	return -1;
+}
+
 static unsigned int
 nsim_dev_linecard_port_count(struct nsim_dev_linecard *nsim_dev_linecard)
 {
@@ -64,6 +74,60 @@ nsim_dev_port_index(struct nsim_dev_linecard *nsim_dev_linecard,
 	       port_index;
 }
 
+static int
+nsim_dev_linecard_activate(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	struct nsim_dev_port *nsim_dev_port;
+
+	if (!nsim_dev_linecard->inserted || !nsim_dev_linecard->provisioned)
+		return 0;
+
+	if (nsim_dev_linecard->type_index !=
+	    nsim_dev_linecard->inserted_type_index)
+		return -EINVAL;
+
+	list_for_each_entry(nsim_dev_port, &nsim_dev_linecard->port_list,
+			    list_lc)
+		netif_carrier_on(nsim_dev_port->ns->netdev);
+
+	devlink_linecard_activate(nsim_dev_linecard->devlink_linecard);
+	return 0;
+}
+
+static int
+nsim_dev_linecard_insert(struct nsim_dev_linecard *nsim_dev_linecard,
+			 u32 inserted_type_index)
+{
+	if (nsim_dev_linecard->type_index != inserted_type_index)
+		return -EINVAL;
+
+	nsim_dev_linecard->inserted_type_index = inserted_type_index;
+	nsim_dev_linecard->inserted = true;
+	return nsim_dev_linecard_activate(nsim_dev_linecard);
+}
+
+static void
+nsim_dev_linecard_deactivate(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	struct nsim_dev_port *nsim_dev_port;
+
+	if (!nsim_dev_linecard->inserted)
+		return;
+	list_for_each_entry(nsim_dev_port, &nsim_dev_linecard->port_list,
+			    list_lc)
+		netif_carrier_off(nsim_dev_port->ns->netdev);
+}
+
+static void
+nsim_dev_linecard_remove(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	if (!nsim_dev_linecard->inserted)
+		return;
+	nsim_dev_linecard_deactivate(nsim_dev_linecard);
+	nsim_dev_linecard->inserted = false;
+	devlink_linecard_deactivate(nsim_dev_linecard->devlink_linecard);
+}
+
 static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
@@ -299,6 +363,72 @@ static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_port)
 	debugfs_remove_recursive(nsim_dev_port->ddir);
 }
 
+static ssize_t nsim_dev_linecard_inserted_type_read(struct file *file,
+						    char __user *data,
+						    size_t count, loff_t *ppos)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = file->private_data;
+	const char *type;
+
+	if (!nsim_dev_linecard->inserted)
+		return -EOPNOTSUPP;
+
+	type = nsim_dev_linecard_supported_types[nsim_dev_linecard->inserted_type_index];
+	return simple_read_from_buffer(data, count, ppos, type, strlen(type));
+}
+
+static ssize_t nsim_dev_linecard_inserted_type_write(struct file *file,
+						     const char __user *data,
+						     size_t count, loff_t *ppos)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = file->private_data;
+	char *buf;
+	int err;
+	int ret;
+
+	if (*ppos != 0)
+		return -EINVAL;
+	buf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = simple_write_to_buffer(buf, count, ppos, data, count);
+	if (ret < 0)
+		goto free_buf;
+
+	buf[count - 1] = '\0';
+	if (strlen(buf) > 0) {
+		int inserted_type_index;
+
+		inserted_type_index = nsim_dev_linecard_type_index(buf);
+		if (inserted_type_index == -1)
+			return -EINVAL;
+
+		if (nsim_dev_linecard->inserted)
+			return -EBUSY;
+
+		err = nsim_dev_linecard_insert(nsim_dev_linecard,
+					       inserted_type_index);
+		if (err)
+			return err;
+	} else {
+		nsim_dev_linecard_remove(nsim_dev_linecard);
+	}
+	return count;
+
+free_buf:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations nsim_dev_linecard_inserted_type_fops = {
+	.open = simple_open,
+	.read = nsim_dev_linecard_inserted_type_read,
+	.write = nsim_dev_linecard_inserted_type_write,
+	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
+};
+
 static ssize_t nsim_dev_linecard_type_read(struct file *file, char __user *data,
 					   size_t count, loff_t *ppos)
 {
@@ -334,6 +464,8 @@ nsim_dev_linecard_debugfs_init(struct nsim_dev *nsim_dev,
 	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
 		nsim_dev->nsim_bus_dev->dev.id);
 	debugfs_create_symlink("dev", nsim_dev_linecard->ddir, dev_link_name);
+	debugfs_create_file("inserted_type", 0600, nsim_dev_linecard->ddir,
+			    nsim_dev_linecard, &nsim_dev_linecard_inserted_type_fops);
 	debugfs_create_file("type", 0400, nsim_dev_linecard->ddir,
 			    nsim_dev_linecard, &nsim_dev_linecard_type_fops);
 
@@ -1110,6 +1242,8 @@ static void nsim_dev_linecard_provision_work(struct work_struct *work)
 	nsim_dev_linecard->provisioned = true;
 	devlink_linecard_provision_set(nsim_dev_linecard->devlink_linecard,
 				       nsim_dev_linecard->type_index);
+
+	nsim_dev_linecard_activate(nsim_dev_linecard);
 	return;
 
 err_port_del_all:
@@ -1138,6 +1272,8 @@ static void nsim_dev_linecard_unprovision_work(struct work_struct *work)
 	nsim_dev_linecard = container_of(work, struct nsim_dev_linecard,
 					 unprovision_work);
 
+	nsim_dev_linecard_deactivate(nsim_dev_linecard);
+
 	nsim_bus_dev = nsim_dev_linecard->nsim_dev->nsim_bus_dev;
 	nsim_dev_linecard->provisioned = false;
 	devlink_linecard_provision_clear(nsim_dev_linecard->devlink_linecard);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 01edff939c3a..8ee036e00a56 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -203,6 +203,8 @@ struct nsim_dev_linecard {
 	struct dentry *ddir;
 	bool provisioned;
 	u32 type_index;
+	bool inserted;
+	u32 inserted_type_index;
 	struct work_struct provision_work;
 	struct work_struct unprovision_work;
 };
-- 
2.26.2

