Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631DB8D749
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfHNPhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:37:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37528 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfHNPhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:37:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so9588585wrt.4
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fVl767nQqrWqhWKlJjSFN7rEcOevdu3IDAxs9HNn4xM=;
        b=wsHSkt3SK+1GT3qNyCorjZZq8RhGEaxWDFm/SIZv5ce5Y6TtFk6g70sVxVmYQgFAjV
         H/86Yo5PjYgOhdLrcvPe4iPnOYUlXxjfI39pIONVGsYXFyvt4vxOL5Kqjtocc7TlvKWT
         TNOf4POKfHA/hSA64q4lzdnv37pWTDowAQ3IRvvGnjw60Xk+cFTQSEFoo9ytBgeu6uSM
         eOaUGqdTtGRu/1fzPl+eicaCecLe1d+esiVlfF0LJnv11x4ChsJUU8SCQ7M4kvF83tzy
         1KBC0ZxYFNf4dGeNTCv61mzxuuwUFu9WfDQE6rUb7pe5Ozd8OhycqmuASsHgGQERze7K
         0nLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fVl767nQqrWqhWKlJjSFN7rEcOevdu3IDAxs9HNn4xM=;
        b=FnjVt5p9DqRnx7Vl41QBb5N80qQL3BIQYD8WZLKxg3PmkXPCnPwSvRm7p0NGyeN9RF
         YHuFGi6vJ9REhdwePzuYd88iyy2nGsK8haXgdP3gXEYC+XfI895pmNfJRS750rxmbiXT
         ii5af3QLujhx3GaI9iOElUO94HkaTGuRzTWhIdDyuVQppO4GRJdkas9aTxf5J+A2PGzG
         WzskE5JJZpgusfYdJQUvZ66dXO5oKrtJDhjmflfjVTIjfT6xmglBP+Xt0YhPwYpCpWw5
         XZL21TAMz0FQmp15Z/J0wNWxpS5fgrnFYqWbbRhhPd6wAbrRxSrIUmuPVLeXZj6fRojr
         sXHw==
X-Gm-Message-State: APjAAAVd1rvKNp5gBgod9y2muHw785QeLqwCKwVQZN6w6eff/N8mpJv2
        QPJarnwXpSq776pqyVIM2Yd/zVCjk0M=
X-Google-Smtp-Source: APXvYqxGJ1AbL7eHpN8Ugs/NPKINf+OyMZLAk6PE9wrR7im04m6f5JYLOXyCgtQ1ulu8rxxDpIjGmA==
X-Received: by 2002:adf:e94e:: with SMTP id m14mr356752wrn.230.1565797057123;
        Wed, 14 Aug 2019 08:37:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z2sm35563wmi.2.2019.08.14.08.37.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 08:37:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 1/2] netdevsim: implement support for devlink region and snapshots
Date:   Wed, 14 Aug 2019 17:37:34 +0200
Message-Id: <20190814153735.6923-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814153735.6923-1-jiri@resnulli.us>
References: <20190814153735.6923-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement dummy region of size 32K and allow user to create snapshots
or random data using debugfs file trigger.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- return -ENOMEM in case dummy_data cannot be allocated
  and don't print out error message.
- return err in case snapshot creation fails and kfree dummy_data.
- use PTR_ERR_OR_ZERO in nsim_dev_dummy_region_init().
---
 drivers/net/netdevsim/dev.c       | 63 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 08ca59fc189b..125a0358bc04 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -27,6 +27,41 @@
 
 static struct dentry *nsim_dev_ddir;
 
+#define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
+
+static ssize_t nsim_dev_take_snapshot_write(struct file *file,
+					    const char __user *data,
+					    size_t count, loff_t *ppos)
+{
+	struct nsim_dev *nsim_dev = file->private_data;
+	void *dummy_data;
+	u32 id;
+	int err;
+
+	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
+	if (!dummy_data)
+		return -ENOMEM;
+
+	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
+
+	id = devlink_region_shapshot_id_get(priv_to_devlink(nsim_dev));
+	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
+					     dummy_data, id, kfree);
+	if (err) {
+		pr_err("Failed to create region snapshot\n");
+		kfree(dummy_data);
+		return err;
+	}
+
+	return count;
+}
+
+static const struct file_operations nsim_dev_take_snapshot_fops = {
+	.open = simple_open,
+	.write = nsim_dev_take_snapshot_write,
+	.llseek = generic_file_llseek,
+};
+
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
 	char dev_ddir_name[16];
@@ -44,6 +79,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			   &nsim_dev->max_macs);
 	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
 			    &nsim_dev->test1);
+	debugfs_create_file("take_snapshot", 0200, nsim_dev->ddir, nsim_dev,
+			    &nsim_dev_take_snapshot_fops);
 	return 0;
 }
 
@@ -248,6 +285,23 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
 		nsim_dev->test1 = saved_value.vbool;
 }
 
+#define NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX 16
+
+static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
+				      struct devlink *devlink)
+{
+	nsim_dev->dummy_region =
+		devlink_region_create(devlink, "dummy",
+				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
+				      NSIM_DEV_DUMMY_REGION_SIZE);
+	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
+}
+
+static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
+{
+	devlink_region_destroy(nsim_dev->dummy_region);
+}
+
 static int nsim_dev_reload(struct devlink *devlink,
 			   struct netlink_ext_ack *extack)
 {
@@ -363,10 +417,14 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 		goto err_dl_unregister;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
 
-	err = nsim_dev_debugfs_init(nsim_dev);
+	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
 	if (err)
 		goto err_params_unregister;
 
+	err = nsim_dev_debugfs_init(nsim_dev);
+	if (err)
+		goto err_dummy_region_exit;
+
 	err = nsim_bpf_dev_init(nsim_dev);
 	if (err)
 		goto err_debugfs_exit;
@@ -376,6 +434,8 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
+err_dummy_region_exit:
+	nsim_dev_dummy_region_exit(nsim_dev);
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
@@ -396,6 +456,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
+	nsim_dev_dummy_region_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 95751a817508..4c758c6919f5 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -160,6 +160,7 @@ struct nsim_dev {
 	bool fw_update_status;
 	u32 max_macs;
 	bool test1;
+	struct devlink_region *dummy_region;
 };
 
 int nsim_dev_init(void);
-- 
2.21.0

