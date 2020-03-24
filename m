Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A06191A02
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgCXTeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:18 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56071 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgCXTeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 90728580061;
        Tue, 24 Mar 2020 15:34:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=K4h13n3Gj/WrzRzuyExUDHzFSJNfN44qdXndF3oFZww=; b=3iFStPgc
        LkjXlPW/08oIuT7lYuDGL1kclMPIJLm7f+StDvZQe/Ia8YSYtylDTLlGaKzswf0z
        1lAO7iGnkiQ8SxDNdjPcHU1mwLckJvbRO9pp8qkUkk3pX9d/qO7KdjVk7TiXK2IS
        6b9Jjb2noOarv/cwlS/bUutkPYQmkz849yswDaZWozSfMidtPZjQzuuihuZGDVZQ
        8YTv6sxluqVD2IRr3W/4n36BFTPFpSA/WoFXKArNEwL6PFOXAr0T1y2hw1SJgi9r
        /OgSOrJm9A6ik+R5+Beje1WyzAvI+Xz6WGPRj/Ax21z1DKu8wzjE0GYQy+aG4/eC
        Nkp0MmQu/Gi4AA==
X-ME-Sender: <xms:uWB6XoPcn1kiM7C22-6CKQ6oE7qMUSTQdfQp4hU4muA1-ZjtwZJnPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:uWB6Xj0lZV9jrYsrU-mDNJVbSkhy1K5yGercwAxT4o7hKS6PTW6stg>
    <xmx:uWB6XlI_azcf_FUkK1ZYdEnuHM6857B66IfOhy2O5IwjbZJUNso0Cw>
    <xmx:uWB6XjJowjKYoxwtiBoinTCyoaK3E0kHcaQTJD8YR2YP3BcqzykXOg>
    <xmx:uWB6XnlU3UHNvpdgHwry0gFITocr0E-ujNYynUotlMy19Ox8nGwEzw>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 865023065DD8;
        Tue, 24 Mar 2020 15:34:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/15] netdevsim: Add devlink-trap policer support
Date:   Tue, 24 Mar 2020 21:32:38 +0200
Message-Id: <20200324193250.1322038-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Register three dummy packet trap policers with devlink and implement
callbacks to change their parameters and read their counters.

This will be used later on in the series to test the devlink-trap
policer infrastructure.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 96 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 7bfd0622cef1..ce74adbf0e8b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -192,6 +192,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    &nsim_dev->fail_reload);
 	debugfs_create_file("trap_flow_action_cookie", 0600, nsim_dev->ddir,
 			    nsim_dev, &nsim_dev_trap_fa_cookie_fops);
+	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_policer_counter_get);
 	return 0;
 }
 
@@ -363,6 +366,7 @@ struct nsim_trap_item {
 struct nsim_trap_data {
 	struct delayed_work trap_report_dw;
 	struct nsim_trap_item *trap_items_arr;
+	u64 *trap_policers_cnt_arr;
 	struct nsim_dev *nsim_dev;
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
@@ -397,6 +401,12 @@ enum {
 			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			    NSIM_TRAP_METADATA)
 
+static const struct devlink_trap_policer nsim_trap_policers_arr[] = {
+	DEVLINK_TRAP_POLICER(1, 1000, 128),
+	DEVLINK_TRAP_POLICER(2, 2000, 256),
+	DEVLINK_TRAP_POLICER(3, 3000, 512),
+};
+
 static const struct devlink_trap_group nsim_trap_groups_arr[] = {
 	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS),
 	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS),
@@ -539,6 +549,7 @@ static void nsim_dev_trap_report_work(struct work_struct *work)
 
 static int nsim_dev_traps_init(struct devlink *devlink)
 {
+	size_t policers_count = ARRAY_SIZE(nsim_trap_policers_arr);
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	struct nsim_trap_data *nsim_trap_data;
 	int err;
@@ -555,6 +566,14 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 		goto err_trap_data_free;
 	}
 
+	nsim_trap_data->trap_policers_cnt_arr = kcalloc(policers_count,
+							sizeof(u64),
+							GFP_KERNEL);
+	if (!nsim_trap_data->trap_policers_cnt_arr) {
+		err = -ENOMEM;
+		goto err_trap_items_free;
+	}
+
 	/* The lock is used to protect the action state of the registered
 	 * traps. The value is written by user and read in delayed work when
 	 * iterating over all the traps.
@@ -563,10 +582,15 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 	nsim_trap_data->nsim_dev = nsim_dev;
 	nsim_dev->trap_data = nsim_trap_data;
 
+	err = devlink_trap_policers_register(devlink, nsim_trap_policers_arr,
+					     policers_count);
+	if (err)
+		goto err_trap_policers_cnt_free;
+
 	err = devlink_trap_groups_register(devlink, nsim_trap_groups_arr,
 					   ARRAY_SIZE(nsim_trap_groups_arr));
 	if (err)
-		goto err_trap_items_free;
+		goto err_trap_policers_unregister;
 
 	err = devlink_traps_register(devlink, nsim_traps_arr,
 				     ARRAY_SIZE(nsim_traps_arr), NULL);
@@ -583,6 +607,11 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 err_trap_groups_unregister:
 	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
 				       ARRAY_SIZE(nsim_trap_groups_arr));
+err_trap_policers_unregister:
+	devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
+					 ARRAY_SIZE(nsim_trap_policers_arr));
+err_trap_policers_cnt_free:
+	kfree(nsim_trap_data->trap_policers_cnt_arr);
 err_trap_items_free:
 	kfree(nsim_trap_data->trap_items_arr);
 err_trap_data_free:
@@ -599,6 +628,9 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 				 ARRAY_SIZE(nsim_traps_arr));
 	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
 				       ARRAY_SIZE(nsim_trap_groups_arr));
+	devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
+					 ARRAY_SIZE(nsim_trap_policers_arr));
+	kfree(nsim_dev->trap_data->trap_policers_cnt_arr);
 	kfree(nsim_dev->trap_data->trap_items_arr);
 	kfree(nsim_dev->trap_data);
 }
@@ -737,6 +769,66 @@ nsim_dev_devlink_trap_action_set(struct devlink *devlink,
 	return 0;
 }
 
+#define NSIM_DEV_TRAP_POLICER_MIN_RATE	1
+#define NSIM_DEV_TRAP_POLICER_MAX_RATE	8000
+#define NSIM_DEV_TRAP_POLICER_MIN_BURST	8
+#define NSIM_DEV_TRAP_POLICER_MAX_BURST	65536
+
+static int
+nsim_dev_devlink_trap_policer_set(struct devlink *devlink,
+				  const struct devlink_trap_policer *policer,
+				  u64 rate, u64 burst,
+				  struct netlink_ext_ack *extack)
+{
+	int bs = fls64(burst);
+
+	if (rate < NSIM_DEV_TRAP_POLICER_MIN_RATE) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer rate lower than limit");
+		return -EINVAL;
+	}
+
+	if (rate > NSIM_DEV_TRAP_POLICER_MAX_RATE) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer rate higher than limit");
+		return -EINVAL;
+	}
+
+	if (burst < NSIM_DEV_TRAP_POLICER_MIN_BURST) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
+		return -EINVAL;
+	}
+
+	if (burst > NSIM_DEV_TRAP_POLICER_MAX_BURST) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer burst size higher than limit");
+		return -EINVAL;
+	}
+
+	--bs;
+	if (burst != (1 << bs)) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer burst size is not power of two");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
+					  const struct devlink_trap_policer *policer,
+					  u64 *p_drops)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	u64 *cnt;
+
+	if (nsim_dev->fail_trap_policer_counter_get)
+		return -EINVAL;
+
+	cnt = &nsim_dev->trap_data->trap_policers_cnt_arr[policer->id - 1];
+	*p_drops = *cnt;
+	*cnt += jiffies % 64;
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
@@ -744,6 +836,8 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.flash_update = nsim_dev_flash_update,
 	.trap_init = nsim_dev_devlink_trap_init,
 	.trap_action_set = nsim_dev_devlink_trap_action_set,
+	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
+	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index e46fc565b981..68788dae5625 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -180,6 +180,7 @@ struct nsim_dev {
 	struct nsim_dev_health health;
 	struct flow_action_cookie *fa_cookie;
 	spinlock_t fa_cookie_lock; /* protects fa_cookie */
+	bool fail_trap_policer_counter_get;
 };
 
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
-- 
2.24.1

