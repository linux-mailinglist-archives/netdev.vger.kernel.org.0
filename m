Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64D33EC1D9
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbhHNJ6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237959AbhHNJ6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 05:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD09860E93;
        Sat, 14 Aug 2021 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628935068;
        bh=/6Mlk54LEJUuiirgNaqO/aOWJitDCN9RK2SGABUKzsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CL/f/vfjdjuxBAJtD3aB0fy9t7NW1n9Fw/Bx1HkdDGD/GSdWrNi+VktmMPDELAdKv
         HsDCjVTn1HxoCtLGOXro68d5VWRl+hPtGMDMBApuWYTlhJXV9CvOjpAVHc0W8q29d9
         9rkHuaTzpvUPBklr5dcYFpL+EvEkASSRegPf0nBoq4DCGjmleLKpWRLMrzSe40sv/3
         7trbB9I8hiYOvhKKNTTUHAOj77L/p9ajnVzZJWuR0D7jTIC1xahN+6Fdr8WdI0y1Jj
         Ecy6URz7iyLzE9iJOUVSH3G2rrRW0WG9AypRSyBr0IP9aMApcgRHWGCDQn+0WYfsNM
         Hrh75S0PS1L2g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 4/6] devlink: Use xarray to store devlink instances
Date:   Sat, 14 Aug 2021 12:57:29 +0300
Message-Id: <38c969b6f490c2b2c0959c017b4461f69ab96117.1628933864.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628933864.git.leonro@nvidia.com>
References: <cover.1628933864.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

We can use xarray instead of linearly organized linked lists for the
devlink instances. This will let us revise the locking scheme in favour
of internal xarray locking that protects database.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  2 +-
 net/core/devlink.c    | 70 ++++++++++++++++++++++++++++++-------------
 2 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4c60d61d92da..154cf0dbca37 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -32,7 +32,7 @@ struct devlink_dev_stats {
 struct devlink_ops;
 
 struct devlink {
-	struct list_head list;
+	u32 index;
 	struct list_head port_list;
 	struct list_head rate_list;
 	struct list_head sb_list;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 76f459da6e05..d218f57ad8cf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -92,7 +92,8 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
 };
 
-static LIST_HEAD(devlink_list);
+static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
+#define DEVLINK_REGISTERED XA_MARK_1
 
 /* devlink_mutex
  *
@@ -123,6 +124,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
 	struct devlink *devlink;
+	unsigned long index;
 	bool found = false;
 	char *busname;
 	char *devname;
@@ -135,7 +137,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 
 	lockdep_assert_held(&devlink_mutex);
 
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0 &&
 		    net_eq(devlink_net(devlink), net)) {
@@ -1087,11 +1089,12 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	struct devlink_rate *devlink_rate;
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -1189,11 +1192,12 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -1251,11 +1255,12 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	struct devlink_port *devlink_port;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -1916,11 +1921,12 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -2067,11 +2073,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -2287,11 +2294,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -2535,11 +2543,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -4611,11 +4620,12 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	struct devlink_param_item *param_item;
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -4886,11 +4896,12 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	struct devlink_port *devlink_port;
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -5462,11 +5473,12 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -5995,11 +6007,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -7176,11 +7189,12 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	struct devlink_port *port;
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -7210,7 +7224,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -7771,11 +7785,12 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	struct devlink_trap_item *trap_item;
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -7997,11 +8012,12 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -8310,11 +8326,12 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
 	int start = cb->args[0];
+	unsigned long index;
 	int idx = 0;
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
@@ -8899,6 +8916,8 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 				 struct device *dev)
 {
 	struct devlink *devlink;
+	static u32 last_id;
+	int ret;
 
 	WARN_ON(!ops || !dev);
 	if (!devlink_reload_actions_valid(ops))
@@ -8908,6 +8927,13 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	if (!devlink)
 		return NULL;
 
+	ret = xa_alloc_cyclic(&devlinks, &devlink->index, devlink, xa_limit_31b,
+			      &last_id, GFP_KERNEL);
+	if (ret < 0) {
+		kfree(devlink);
+		return NULL;
+	}
+
 	devlink->dev = dev;
 	devlink->ops = ops;
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
@@ -8940,7 +8966,7 @@ EXPORT_SYMBOL_GPL(devlink_alloc_ns);
 int devlink_register(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
-	list_add_tail(&devlink->list, &devlink_list);
+	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	mutex_unlock(&devlink_mutex);
 	return 0;
@@ -8961,7 +8987,7 @@ void devlink_unregister(struct devlink *devlink)
 	WARN_ON(devlink_reload_supported(devlink->ops) &&
 		devlink->reload_enabled);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
-	list_del(&devlink->list);
+	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
@@ -9023,6 +9049,7 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
+	xa_erase(&devlinks, devlink->index);
 
 	kfree(devlink);
 }
@@ -11497,13 +11524,14 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 {
 	struct devlink *devlink;
 	u32 actions_performed;
+	unsigned long index;
 	int err;
 
 	/* In case network namespace is getting destroyed, reload
 	 * all devlink instances from this namespace into init_net.
 	 */
 	mutex_lock(&devlink_mutex);
-	list_for_each_entry(devlink, &devlink_list, list) {
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
-- 
2.31.1

