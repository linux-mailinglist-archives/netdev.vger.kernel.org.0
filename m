Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736FD1984A7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgC3TjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:15 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:56313 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728568AbgC3TjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 86E74580542;
        Mon, 30 Mar 2020 15:39:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=dy7ucE9j2BcDPbaH8itOyX0beGd3JXlAQhim8sSysis=; b=UKRYNkX0
        9jA/usrX0t5A8hn6Y+FNwXji0UltyMUF+R1N/iDA3WjHcOC8VlFwBJBtuSngJ5ye
        ExKvxmi1+YmSy5K2G3uvvUojmnE7q3S9zTU34cjy8PUZRmzOVSQdv0tCUrRduBO4
        rcg9MoA+eXgsNL5AJLDjdon++v1A6Bq+/HGaKGBshTPsTTJGuTPZrhPtQveAmNhd
        LRgn1Ahhz865NWAQgXw/pRmtiqJnoNFdnzsROtsabGq2C8b7u+Zci3vrj11ffyWq
        v8Zu19T7osygjAFcC28EYkIDJVM78N2ljBj0HJSd0vYmoepX/jbfMuZy/Cv5ELTf
        4i/g4BYfwQDASQ==
X-ME-Sender: <xms:4EqCXkfdYUNCUi7WTnQa8zvteLIDJi7F90JmK7duXX2rC9V9O_OTtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:4EqCXpR0oppy7KuGZSD8EhYK8HoNXzXk0ppw1-UaV81tcweaFOUv5g>
    <xmx:4EqCXtuOBubA8rtGO4v42MllJW1NnHzgBUNI4XqHpe50RjD_8m8zew>
    <xmx:4EqCXtxlzVKJ4TsV5fBvzQpLaEyZ6nd_sgR2zbFPFvuGwbynZW_OKw>
    <xmx:4EqCXi5M9SaeU_3hX4L7xR7_nJ9X2tZhbGxQclQrmrUf7cKyPsI8mg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 560DF306CA25;
        Mon, 30 Mar 2020 15:39:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 03/15] netdevsim: Add devlink-trap policer support
Date:   Mon, 30 Mar 2020 22:38:20 +0300
Message-Id: <20200330193832.2359876-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
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

v2:
* Remove check about burst size being a power of 2 and instead add a
  debugfs knob to fail the operation
* Provide max/min rate/burst size when registering policers and remove
  the validity checks from nsim_dev_devlink_trap_policer_set()

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 85 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  2 +
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 2b727a7001f6..21341e592467 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -215,6 +215,12 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    &nsim_dev->fail_reload);
 	debugfs_create_file("trap_flow_action_cookie", 0600, nsim_dev->ddir,
 			    nsim_dev, &nsim_dev_trap_fa_cookie_fops);
+	debugfs_create_bool("fail_trap_policer_set", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_policer_set);
+	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_policer_counter_get);
 	return 0;
 }
 
@@ -392,6 +398,7 @@ struct nsim_trap_item {
 struct nsim_trap_data {
 	struct delayed_work trap_report_dw;
 	struct nsim_trap_item *trap_items_arr;
+	u64 *trap_policers_cnt_arr;
 	struct nsim_dev *nsim_dev;
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
@@ -426,6 +433,24 @@ enum {
 			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			    NSIM_TRAP_METADATA)
 
+#define NSIM_DEV_TRAP_POLICER_MIN_RATE	1
+#define NSIM_DEV_TRAP_POLICER_MAX_RATE	8000
+#define NSIM_DEV_TRAP_POLICER_MIN_BURST	8
+#define NSIM_DEV_TRAP_POLICER_MAX_BURST	65536
+
+#define NSIM_TRAP_POLICER(_id, _rate, _burst)				      \
+	DEVLINK_TRAP_POLICER(_id, _rate, _burst,			      \
+			     NSIM_DEV_TRAP_POLICER_MAX_RATE,		      \
+			     NSIM_DEV_TRAP_POLICER_MIN_RATE,		      \
+			     NSIM_DEV_TRAP_POLICER_MAX_BURST,		      \
+			     NSIM_DEV_TRAP_POLICER_MIN_BURST)
+
+static const struct devlink_trap_policer nsim_trap_policers_arr[] = {
+	NSIM_TRAP_POLICER(1, 1000, 128),
+	NSIM_TRAP_POLICER(2, 2000, 256),
+	NSIM_TRAP_POLICER(3, 3000, 512),
+};
+
 static const struct devlink_trap_group nsim_trap_groups_arr[] = {
 	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS),
 	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS),
@@ -568,6 +593,7 @@ static void nsim_dev_trap_report_work(struct work_struct *work)
 
 static int nsim_dev_traps_init(struct devlink *devlink)
 {
+	size_t policers_count = ARRAY_SIZE(nsim_trap_policers_arr);
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	struct nsim_trap_data *nsim_trap_data;
 	int err;
@@ -584,6 +610,14 @@ static int nsim_dev_traps_init(struct devlink *devlink)
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
@@ -592,10 +626,15 @@ static int nsim_dev_traps_init(struct devlink *devlink)
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
@@ -612,6 +651,11 @@ static int nsim_dev_traps_init(struct devlink *devlink)
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
@@ -628,6 +672,9 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 				 ARRAY_SIZE(nsim_traps_arr));
 	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
 				       ARRAY_SIZE(nsim_trap_groups_arr));
+	devlink_trap_policers_unregister(devlink, nsim_trap_policers_arr,
+					 ARRAY_SIZE(nsim_trap_policers_arr));
+	kfree(nsim_dev->trap_data->trap_policers_cnt_arr);
 	kfree(nsim_dev->trap_data->trap_items_arr);
 	kfree(nsim_dev->trap_data);
 }
@@ -766,6 +813,40 @@ nsim_dev_devlink_trap_action_set(struct devlink *devlink,
 	return 0;
 }
 
+static int
+nsim_dev_devlink_trap_policer_set(struct devlink *devlink,
+				  const struct devlink_trap_policer *policer,
+				  u64 rate, u64 burst,
+				  struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+
+	if (nsim_dev->fail_trap_policer_set) {
+		NL_SET_ERR_MSG_MOD(extack, "User setup the operation to fail for testing purposes");
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
@@ -773,6 +854,8 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.flash_update = nsim_dev_flash_update,
 	.trap_init = nsim_dev_devlink_trap_init,
 	.trap_action_set = nsim_dev_devlink_trap_action_set,
+	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
+	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index e46fc565b981..3d37df5057e8 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -180,6 +180,8 @@ struct nsim_dev {
 	struct nsim_dev_health health;
 	struct flow_action_cookie *fa_cookie;
 	spinlock_t fa_cookie_lock; /* protects fa_cookie */
+	bool fail_trap_policer_set;
+	bool fail_trap_policer_counter_get;
 };
 
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
-- 
2.24.1

