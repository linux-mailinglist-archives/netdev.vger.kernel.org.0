Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354058ED39
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732477AbfHONqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:46:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54586 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732427AbfHONqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:46:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so1332547wme.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 06:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kdUOIFJ2Tj9vO53O/YDC0kULxcHzqIjVbu5/J6CgivM=;
        b=JxChDmHUj7BxLuCcRufmvEUq2NoI9Su3QcoACLbTJjsQhMPVZJhSbonb4oafHSfT+m
         kKQl8IudbcjpmDSnGQfB9FNV78y14dIxwJijJ7LKWI9U/9IJYZDexWsrflCLNuDxaPVf
         ZaglEcSvzQBf8hcLR5TJE6Kg3u0BBm0EDN2rzMvqamGQoZEpUcQ1bBckWfApQm/4yPku
         Zktr8vjch6/mNtGSIy4foCEM5mWtjnNJkvkeNmSgMx6c0N08JvgVL5i4bqm+wpo7K0Us
         dAH/9nx+ofpzK4pDGjItjzmrRLGFIXBpmLzT94N/QQgtzdqpsUV9qjE2V0fYOxK7/dAz
         Ne7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kdUOIFJ2Tj9vO53O/YDC0kULxcHzqIjVbu5/J6CgivM=;
        b=CWG6i8NHBuABLJONIBhHPd4DZmRv0oAJfgIWTsBY5svjvbhUillCspr735bvn84tXf
         iqcPBt8KgDvAH98eqXu40uoFWKa0LuZI1Qd3uZY8rx1Q0x+/W3+eLhe0lW620S0uTipe
         zsXtGCxbbsUWk9Csq8NqhpfZnekh1vUZaMxgqWIwx1C1MSMZecIVmMPY0sNUWjPZxU5p
         iFKSk7nO35+p92acAZPRAAcL3HAo2BQVEopBuyqJ7EXQHriTRrpc/JrRSyFLY3dr5YgF
         dj7VXlPcR0zT9+GpjIZ2pFMyW70ijvX7POT7UTgJx1x9czbrDPQNbG70tpEQ9N4k0TRu
         xhsA==
X-Gm-Message-State: APjAAAWv1S1wG94aOaMMpgN+pWhfkdzAHpiuOWTgQFW5jjciMeHZ0f/m
        I9yTVxgR7LAm82TqvPhfNNQ5m3tiKks=
X-Google-Smtp-Source: APXvYqwKft0BKr4MfjmfbIQMPeu32fM0FdNi3LVqwvGAZyEAioMGAJnYZfJP9nSW2ucRVnkw6boq5Q==
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr3009117wmk.52.1565876796328;
        Thu, 15 Aug 2019 06:46:36 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l3sm4625231wrb.41.2019.08.15.06.46.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 06:46:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v4 1/2] netdevsim: implement support for devlink region and snapshots
Date:   Thu, 15 Aug 2019 15:46:33 +0200
Message-Id: <20190815134634.9858-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190815134634.9858-1-jiri@resnulli.us>
References: <20190815134634.9858-1-jiri@resnulli.us>
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
v3->v4:
- sorted nsim_dev_take_snapshot_write() variables.
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
index 08ca59fc189b..a570da406d1d 100644
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
+	int err;
+	u32 id;
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

