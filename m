Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A39189B20
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfHLKQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:16:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50924 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfHLKQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 06:16:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so11623594wml.0
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 03:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlkygxELSjcFu+7PIfNPIgyLb8Iv5HzGAwP1wYBf/nk=;
        b=Nz4GtlEBv98Wc9CeyzwYk5P7rkhY8+wB4hPQxXCY3doGWaHCn7xwU0IdT+7peDTQbN
         Me75JI/lb9Ch71eiT316CNMzNhlccY/9AZvJlO/YfDHWb1Eguyko9Fs2ttAzrHp5Es51
         hZgoAstLwNe6VLHIFuB8mzUmhmrFe2GzUpkrLw1d+HACZAK/rReW0pOIVTN2o7HKdBu9
         TFUUlXaJkO02cnvib36L8ytce73spBjHVQs5v5pMb3zc8XdKbcqJR7e4NYpLly/1RbB/
         iDxzteYOaiiDm1aQJZ23pDQcv4yHJ/w9vEK2iSeVtQJxV8t94nhZswW9ZPTrFcIA0u2E
         VgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlkygxELSjcFu+7PIfNPIgyLb8Iv5HzGAwP1wYBf/nk=;
        b=Vffx9vfTCOsFRgzv1t2EMNK8SbR8JvP8ZCKqIUrm1hmKAX3GPRvMSIOWA/JWYbRY/D
         AXd/h4gR9Wt0KzJYAlO/27b+WJ2k2ewCSk9Y8RYP2upoLHyk+yulUX04FZy7AWETF1wG
         p3pz7LiVdHwjICE/M3OziynBNYMRGUkEFOwCvlHTXrYVgwlu8E8sShcihsfNpnEyHL96
         vKyhb2KZVwyIWgJuemLcXGJxg/eBt/RyM0dm4yMUjcG2p5vvFU4BzuhwLuInxdofMEqw
         e36mWPKJr65tzzC0Vpqpahr8qpfXmc9SEtomP5gE9UpIvvXZxTdcB3LzUhSw95w9oWt9
         kAvA==
X-Gm-Message-State: APjAAAUbNEYuXrY3WhoijahRKmrZerwQh2bs5DFGFRhJW8BEHRpIHQq5
        N6aL5myG6/+rHldARDikRJSTo9qhykQ=
X-Google-Smtp-Source: APXvYqxZFM7pnOBGrQOUVGzpmeo6XpgumUwQBpwCZPJriuhBZX64oF8Tfsy3K/4TKuixjjQy+NqN1w==
X-Received: by 2002:a1c:f70c:: with SMTP id v12mr26904509wmh.42.1565604981459;
        Mon, 12 Aug 2019 03:16:21 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id 20sm8237206wmk.34.2019.08.12.03.16.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 03:16:21 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next] netdevsim: implement support for devlink region and snapshots
Date:   Mon, 12 Aug 2019 12:16:20 +0200
Message-Id: <20190812101620.7884-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
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
index 08ca59fc189b..e76ea6a3cb60 100644
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
@@ -363,10 +420,14 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
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
@@ -376,6 +437,8 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
+err_dummy_region_exit:
+	nsim_dev_dummy_region_exit(nsim_dev);
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
@@ -396,6 +459,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 
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

