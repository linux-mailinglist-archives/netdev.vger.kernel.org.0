Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A488BBF9
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfHMOsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:48:50 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51675 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbfHMOss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:48:48 -0400
Received: by mail-wm1-f48.google.com with SMTP id 207so1790826wma.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 07:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TNQdUyf7dGZDLwhoFTzq/Vze7EZXO2Vomec1wEHF2cU=;
        b=c9Zifw4+eRIWrBd35Qf42RqQQa+sEH1XX6o09lmF1ZD1Nz3EdXEILqperju1zt14bP
         BRrLFgbbBteztnPZjMBidz69jwQsHx2q/2f2HY/W33kvNp3/7GnoiShZIqM6CIquJltj
         xjrwyPHPc1NoZUKpM7DxmJVmsfVCyif5xqzwjqYWBJizJSxPp3o7EAbcxTEKrylwbfRK
         MbC2v9dfUmQf7LhzI+0RSzVXv4Tj1FfECdtRe7cqPaafC4NGeHNS5pO3tIJrY7P+tyJO
         5O1W240SvA0DCVV3CFr4FAaM5PLLCVHXm9FRnr58ySIzmvojBWU9aDZxJLIbTm7fDfwR
         hEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TNQdUyf7dGZDLwhoFTzq/Vze7EZXO2Vomec1wEHF2cU=;
        b=Ua+b6ca8Z6Bz8SgpID+LJ5L7O0kEGoBREGEPMLt/OfF/LYLlTIsJUHIdktTl5kf99W
         NYfmF8nRmsEpDBe1sT/ZPh0AR3ZbfApinZ2L617Xh+dNuM5+L+tnI50a+jgJkCpGe5mq
         hqmHr8ZUysBszYLgDzdyIAIkd8GImWxSpZENZK2b+hAN/xGrVZNSt/horkKeHLzAJlK3
         89QlaiDbGjQqYaqlH7RwHn1j89N51kYphYhnr1HY//E4yeV684n1Xso25goG+EuxXiK+
         BNE7zZimdCSNio2OdE6aHcJJrrrGzb9cHYbH+xr+B/WF9pe3y8Yf6pKEmZuzecoYSB4M
         3Uwg==
X-Gm-Message-State: APjAAAWbtQgQ61zA7Y6zb/T3nOolpGxtvVTzQYl3osUn14c6N65m7snz
        cu2bBDuVmnVAN3ekHax10+q9NxfpSBM=
X-Google-Smtp-Source: APXvYqylVjkGd8nNyOKFexXtFKfAdBnwNckfaWnOQE5Q/4/AmLOhhvtuf7+DY0UWj71aHP9k5GHWnA==
X-Received: by 2002:a1c:1ac2:: with SMTP id a185mr3600976wma.96.1565707725305;
        Tue, 13 Aug 2019 07:48:45 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id d20sm1220852wmb.24.2019.08.13.07.48.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 07:48:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 1/2] netdevsim: implement support for devlink region and snapshots
Date:   Tue, 13 Aug 2019 16:48:42 +0200
Message-Id: <20190813144843.28466-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813144843.28466-1-jiri@resnulli.us>
References: <20190813144843.28466-1-jiri@resnulli.us>
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
 drivers/net/netdevsim/dev.c       | 66 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 127aef85dc99..8485dd805f7c 100644
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
+	if (!dummy_data) {
+		pr_err("Failed to allocate memory for region snapshot\n");
+		goto out;
+	}
+
+	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
+
+	id = devlink_region_shapshot_id_get(priv_to_devlink(nsim_dev));
+	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
+					     dummy_data, id, kfree);
+	if (err)
+		pr_err("Failed to create region snapshot\n");
+
+out:
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
 
@@ -248,6 +285,26 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
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
+	if (IS_ERR(nsim_dev->dummy_region))
+		return PTR_ERR(nsim_dev->dummy_region);
+
+	return 0;
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
@@ -365,10 +422,14 @@ nsim_dev_create(struct net *net, struct nsim_bus_dev *nsim_bus_dev,
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
@@ -378,6 +439,8 @@ nsim_dev_create(struct net *net, struct nsim_bus_dev *nsim_bus_dev,
 
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
+err_dummy_region_exit:
+	nsim_dev_dummy_region_exit(nsim_dev);
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
@@ -398,6 +461,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
+	nsim_dev_dummy_region_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index ef879892dd6f..521802d429a0 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -163,6 +163,7 @@ struct nsim_dev {
 	bool fw_update_status;
 	u32 max_macs;
 	bool test1;
+	struct devlink_region *dummy_region;
 };
 
 int nsim_dev_init(void);
-- 
2.21.0

