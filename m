Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22222D2B13
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbfJJNTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:19:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44194 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388178AbfJJNTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:19:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id z9so7858292wrl.11
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 06:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kjr3ixPY+4fybxkSTgJnxRSGe6gCT2tAlEBHYBa1VI4=;
        b=uIpZL1cZBkg+CaEGo7kkokfXCvgfJU04M7mXoy6tpi72hotIA+6Y7JOCgXDd/1fvJC
         aAiFDtDLez+H6rpniLKKy7loi2vhRTDhJXXz5sVygXiz4WR9g3zFmIEjsNxuzCTXGR1N
         c62oL641+d3vBxrtZXUTRlN2Uox4I5U/1ppAzR0nUdJ0fAcQp8hqvvi+tZaGsX79FjdZ
         oSdsaokqpCCUUSErnyepLxihuMjQQ0U3M0bnLRcOe35YWmlnrdggx0QcvWgqqdpnRcwb
         KDc66BKswTtKDCgJLHCLL2FyyqlOd90+EwMHOW0GGh8VrRddB4UcCtTqSXdL6MLNsnap
         JXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kjr3ixPY+4fybxkSTgJnxRSGe6gCT2tAlEBHYBa1VI4=;
        b=QpfKPhseAvEN3GXjyQtfJRN+9SQUTFymVupq1Xllf41pPuEY3Qh7gRXqLudMNEkhZj
         uH7OnMijBIlbvGomkNojKZMUO1siOYDHR8Oqmf9nAUPF1MKTQ35NgKgJ0iLo3g6b3vc4
         itg74efNqtde21OJ9FX7y85h8tRNAVDIGIKwG0cEw1ZQLPOKcVLQQdzNPS2AdO8Kglm/
         gLvlOw9u1ChJ6VvL2k6xm9dL6IgfYI5vOwJIeF4Aopr5jPqa2BcK3Dv2KLsx9X+CQyii
         NdiVbX+HOoEnzLK8Am2cwpuSgm/ClD00R468E74OZ46KO7hVVzvYf0LA14P9NLdtDVLR
         hM1w==
X-Gm-Message-State: APjAAAXFOn0jWBuTOplgP4LzmeRU2PiYGJJIYeu2sDriCw3r4nKb1ZoV
        LMjkrAtNfpzn37vGjx0pJabek6iEueQ=
X-Google-Smtp-Source: APXvYqy7oIejmw9vCwv3+N6CTs9WYiP5qgcDgdwO4HCNgZw7iRWOS8pu6emvk4Py6TXR9VCPAa9sgg==
X-Received: by 2002:a5d:6192:: with SMTP id j18mr8524396wru.63.1570713536841;
        Thu, 10 Oct 2019 06:18:56 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id x129sm9714822wmg.8.2019.10.10.06.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 06:18:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 3/4] netdevsim: implement couple of testing devlink health reporters
Date:   Thu, 10 Oct 2019 15:18:50 +0200
Message-Id: <20191010131851.21438-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010131851.21438-1-jiri@resnulli.us>
References: <20191010131851.21438-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement "empty" and "dummy" reporters. The first one is really simple
and does nothing. The other one has debugfs files to trigger breakage
and it is able to do recovery. The ops also implement dummy fmsg
content.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- fixed break message memory leak in nsim_dev_dummy_reporter_recover
- removed debugfs.h include from netdevsim.h
- use ?: in return of nsim_dev_health_break_write()
- fix error path after failure of debugfs_create_dir() call
- fixed fmsg binary serialization
---
 drivers/net/netdevsim/Makefile    |   2 +-
 drivers/net/netdevsim/dev.c       |  17 +-
 drivers/net/netdevsim/health.c    | 325 ++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  13 ++
 4 files changed, 354 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/netdevsim/health.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefile
index 09f1315d2f2a..f4d8f62f28c2 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_NETDEVSIM) += netdevsim.o
 
 netdevsim-objs := \
-	netdev.o dev.o fib.o bus.o
+	netdev.o dev.o fib.o bus.o health.o
 
 ifeq ($(CONFIG_BPF_SYSCALL),y)
 netdevsim-objs += \
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e47fa7b6ca7c..468e157a7cb1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -730,12 +730,18 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_dummy_region_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_health_init(nsim_dev, devlink);
 	if (err)
 		goto err_traps_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_health_exit;
+
 	return 0;
 
+err_health_exit:
+	nsim_dev_health_exit(nsim_dev);
 err_traps_exit:
 	nsim_dev_traps_exit(devlink);
 err_dummy_region_exit:
@@ -797,10 +803,14 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_traps_exit;
 
-	err = nsim_bpf_dev_init(nsim_dev);
+	err = nsim_dev_health_init(nsim_dev, devlink);
 	if (err)
 		goto err_debugfs_exit;
 
+	err = nsim_bpf_dev_init(nsim_dev);
+	if (err)
+		goto err_health_exit;
+
 	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
 	if (err)
 		goto err_bpf_dev_exit;
@@ -810,6 +820,8 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 
 err_bpf_dev_exit:
 	nsim_bpf_dev_exit(nsim_dev);
+err_health_exit:
+	nsim_dev_health_exit(nsim_dev);
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
 err_traps_exit:
@@ -837,6 +849,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	if (devlink_is_reload_failed(devlink))
 		return;
 	nsim_dev_port_del_all(nsim_dev);
+	nsim_dev_health_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
 	mutex_destroy(&nsim_dev->port_list_lock);
diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
new file mode 100644
index 000000000000..2716235a0336
--- /dev/null
+++ b/drivers/net/netdevsim/health.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Mellanox Technologies. All rights reserved */
+
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "netdevsim.h"
+
+static int
+nsim_dev_empty_reporter_dump(struct devlink_health_reporter *reporter,
+			     struct devlink_fmsg *fmsg, void *priv_ctx,
+			     struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static int
+nsim_dev_empty_reporter_diagnose(struct devlink_health_reporter *reporter,
+				 struct devlink_fmsg *fmsg,
+				 struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static const
+struct devlink_health_reporter_ops nsim_dev_empty_reporter_ops = {
+	.name = "empty",
+	.dump = nsim_dev_empty_reporter_dump,
+	.diagnose = nsim_dev_empty_reporter_diagnose,
+};
+
+struct nsim_dev_dummy_reporter_ctx {
+	char *break_msg;
+};
+
+static int
+nsim_dev_dummy_reporter_recover(struct devlink_health_reporter *reporter,
+				void *priv_ctx,
+				struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_health *health = devlink_health_reporter_priv(reporter);
+	struct nsim_dev_dummy_reporter_ctx *ctx = priv_ctx;
+
+	if (health->fail_recover) {
+		/* For testing purposes, user set debugfs fail_recover
+		 * value to true. Fail right away.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "User setup the recover to fail for testing purposes");
+		return -EINVAL;
+	}
+	if (ctx) {
+		kfree(health->recovered_break_msg);
+		health->recovered_break_msg = kstrdup(ctx->break_msg,
+						      GFP_KERNEL);
+		if (!health->recovered_break_msg)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static int nsim_dev_dummy_fmsg_put(struct devlink_fmsg *fmsg, u32 binary_len)
+{
+	char *binary;
+	int err;
+	int i;
+
+	err = devlink_fmsg_bool_pair_put(fmsg, "test_bool", true);
+	if (err)
+		return err;
+	err = devlink_fmsg_u8_pair_put(fmsg, "test_u8", 1);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "test_u32", 3);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "test_u64", 4);
+	if (err)
+		return err;
+	err = devlink_fmsg_string_pair_put(fmsg, "test_string", "somestring");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_binary");
+	if (err)
+		return err;
+	binary = kmalloc(binary_len, GFP_KERNEL);
+	if (!binary)
+		return -ENOMEM;
+	get_random_bytes(binary, binary_len);
+	err = devlink_fmsg_binary_put(fmsg, binary, binary_len);
+	kfree(binary);
+	if (err)
+		return err;
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, "test_nest");
+	if (err)
+		return err;
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_bool_pair_put(fmsg, "nested_test_bool", false);
+	if (err)
+		return err;
+	err = devlink_fmsg_u8_pair_put(fmsg, "nested_test_u8", false);
+	if (err)
+		return err;
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_bool_array");
+	if (err)
+		return err;
+	for (i = 0; i < 10; i++) {
+		err = devlink_fmsg_bool_put(fmsg, true);
+		if (err)
+			return err;
+	}
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_u8_array");
+	if (err)
+		return err;
+	for (i = 0; i < 10; i++) {
+		err = devlink_fmsg_u8_put(fmsg, i);
+		if (err)
+			return err;
+	}
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_u32_array");
+	if (err)
+		return err;
+	for (i = 0; i < 10; i++) {
+		err = devlink_fmsg_u32_put(fmsg, i);
+		if (err)
+			return err;
+	}
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_u64_array");
+	if (err)
+		return err;
+	for (i = 0; i < 10; i++) {
+		err = devlink_fmsg_u64_put(fmsg, i);
+		if (err)
+			return err;
+	}
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_array_of_objects");
+	if (err)
+		return err;
+	for (i = 0; i < 10; i++) {
+		err = devlink_fmsg_obj_nest_start(fmsg);
+		if (err)
+			return err;
+		err = devlink_fmsg_bool_pair_put(fmsg,
+						 "in_array_nested_test_bool",
+						 false);
+		if (err)
+			return err;
+		err = devlink_fmsg_u8_pair_put(fmsg,
+					       "in_array_nested_test_u8",
+					       i);
+		if (err)
+			return err;
+		err = devlink_fmsg_obj_nest_end(fmsg);
+		if (err)
+			return err;
+	}
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+
+static int
+nsim_dev_dummy_reporter_dump(struct devlink_health_reporter *reporter,
+			     struct devlink_fmsg *fmsg, void *priv_ctx,
+			     struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_health *health = devlink_health_reporter_priv(reporter);
+	struct nsim_dev_dummy_reporter_ctx *ctx = priv_ctx;
+	int err;
+
+	if (ctx) {
+		err = devlink_fmsg_string_pair_put(fmsg, "break_message",
+						   ctx->break_msg);
+		if (err)
+			return err;
+	}
+	return nsim_dev_dummy_fmsg_put(fmsg, health->binary_len);
+}
+
+static int
+nsim_dev_dummy_reporter_diagnose(struct devlink_health_reporter *reporter,
+				 struct devlink_fmsg *fmsg,
+				 struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_health *health = devlink_health_reporter_priv(reporter);
+	int err;
+
+	if (health->recovered_break_msg) {
+		err = devlink_fmsg_string_pair_put(fmsg,
+						   "recovered_break_message",
+						   health->recovered_break_msg);
+		if (err)
+			return err;
+	}
+	return nsim_dev_dummy_fmsg_put(fmsg, health->binary_len);
+}
+
+static const
+struct devlink_health_reporter_ops nsim_dev_dummy_reporter_ops = {
+	.name = "dummy",
+	.recover = nsim_dev_dummy_reporter_recover,
+	.dump = nsim_dev_dummy_reporter_dump,
+	.diagnose = nsim_dev_dummy_reporter_diagnose,
+};
+
+static ssize_t nsim_dev_health_break_write(struct file *file,
+					   const char __user *data,
+					   size_t count, loff_t *ppos)
+{
+	struct nsim_dev_health *health = file->private_data;
+	struct nsim_dev_dummy_reporter_ctx ctx;
+	char *break_msg;
+	int err;
+
+	break_msg = kmalloc(count + 1, GFP_KERNEL);
+	if (!break_msg)
+		return -ENOMEM;
+
+	if (copy_from_user(break_msg, data, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+	break_msg[count] = '\0';
+	if (break_msg[count - 1] == '\n')
+		break_msg[count - 1] = '\0';
+
+	ctx.break_msg = break_msg;
+	err = devlink_health_report(health->dummy_reporter, break_msg, &ctx);
+	if (err)
+		goto out;
+
+out:
+	kfree(break_msg);
+	return err ?: count;
+}
+
+static const struct file_operations nsim_dev_health_break_fops = {
+	.open = simple_open,
+	.write = nsim_dev_health_break_write,
+	.llseek = generic_file_llseek,
+};
+
+int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
+{
+	struct nsim_dev_health *health = &nsim_dev->health;
+	int err;
+
+	health->empty_reporter =
+		devlink_health_reporter_create(devlink,
+					       &nsim_dev_empty_reporter_ops,
+					       0, false, health);
+	if (IS_ERR(health->empty_reporter))
+		return PTR_ERR(health->empty_reporter);
+
+	health->dummy_reporter =
+		devlink_health_reporter_create(devlink,
+					       &nsim_dev_dummy_reporter_ops,
+					       0, false, health);
+	if (IS_ERR(health->dummy_reporter)) {
+		err = PTR_ERR(health->dummy_reporter);
+		goto err_empty_reporter_destroy;
+	}
+
+	health->ddir = debugfs_create_dir("health", nsim_dev->ddir);
+	if (IS_ERR_OR_NULL(health->ddir)) {
+		err = PTR_ERR_OR_ZERO(health->ddir) ?: -EINVAL;
+		goto err_dummy_reporter_destroy;
+	}
+
+	health->recovered_break_msg = NULL;
+	debugfs_create_file("break_health", 0200, health->ddir, health,
+			    &nsim_dev_health_break_fops);
+	health->binary_len = 16;
+	debugfs_create_u32("binary_len", 0600, health->ddir,
+			   &health->binary_len);
+	health->fail_recover = false;
+	debugfs_create_bool("fail_recover", 0600, health->ddir,
+			    &health->fail_recover);
+	return 0;
+
+err_dummy_reporter_destroy:
+	devlink_health_reporter_destroy(health->dummy_reporter);
+err_empty_reporter_destroy:
+	devlink_health_reporter_destroy(health->empty_reporter);
+	return err;
+}
+
+void nsim_dev_health_exit(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_health *health = &nsim_dev->health;
+
+	debugfs_remove_recursive(health->ddir);
+	kfree(health->recovered_break_msg);
+	devlink_health_reporter_destroy(health->dummy_reporter);
+	devlink_health_reporter_destroy(health->empty_reporter);
+}
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 24358385d869..94df795ef4d3 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -134,6 +134,18 @@ enum nsim_resource_id {
 	NSIM_RESOURCE_IPV6_FIB_RULES,
 };
 
+struct nsim_dev_health {
+	struct devlink_health_reporter *empty_reporter;
+	struct devlink_health_reporter *dummy_reporter;
+	struct dentry *ddir;
+	char *recovered_break_msg;
+	u32 binary_len;
+	bool fail_recover;
+};
+
+int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink);
+void nsim_dev_health_exit(struct nsim_dev *nsim_dev);
+
 struct nsim_dev_port {
 	struct list_head list;
 	struct devlink_port devlink_port;
@@ -164,6 +176,7 @@ struct nsim_dev {
 	bool dont_allow_reload;
 	bool fail_reload;
 	struct devlink_region *dummy_region;
+	struct nsim_dev_health health;
 };
 
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
-- 
2.21.0

