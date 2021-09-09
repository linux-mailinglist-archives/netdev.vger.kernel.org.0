Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F4404C5E
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbhIIL4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244445AbhIILyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A59C3613A0;
        Thu,  9 Sep 2021 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187896;
        bh=bMuA6NSg9szOzpyi3d8dNJ8eTWpvnAEipx7AYXdwHHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kros6ScG4HiscqImRXqxkr326yJY51A4A3i+RoAIGhlCLCjr+xJsVIuiah8v8QbEo
         4/19BURt3Q2DUeJU/wn0A0VmEcU1TZ1KiszZoVi5ziDV/FkK3wDtjofSYPra/fw3M5
         fZDRzpP8gDWKr51zkq0FKF5DqGHZGobRwOz1pVa272feYu7ErE9WUhxn55zX67SQ2n
         se+AUGVwHSaBvP/hcYzrRI3T1ZG8U5k9mLjCx6IGwzBnpvbc3oJuzS4IvMVZ/ie/7D
         PJD3faEeyCGFWpH7VydVIPMWFjbKSovSVCWO6mDKwYom83SW0QnNMdz2+9KDMdD+7B
         E7X/Ra3Hxl/6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH AUTOSEL 5.14 176/252] net: Fix offloading indirect devices dependency on qdisc order creation
Date:   Thu,  9 Sep 2021 07:39:50 -0400
Message-Id: <20210909114106.141462-176-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 74fc4f828769cca1c3be89ea92cb88feaa27ef52 ]

Currently, when creating an ingress qdisc on an indirect device before
the driver registered for callbacks, the driver will not have a chance
to register its filter configuration callbacks.

To fix that, modify the code such that it keeps track of all the ingress
qdiscs that call flow_indr_dev_setup_offload(). When a driver calls
flow_indr_dev_register(),  go through the list of tracked ingress qdiscs
and call the driver callback entry point so as to give it a chance to
register its callback.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_offload.h            |  1 +
 net/core/flow_offload.c               | 89 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c |  1 +
 net/netfilter/nf_tables_offload.c     |  1 +
 net/sched/cls_api.c                   |  1 +
 5 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 1b9d75aedb22..3961461d9c8b 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -451,6 +451,7 @@ struct flow_block_offload {
 	struct list_head *driver_block_list;
 	struct netlink_ext_ack *extack;
 	struct Qdisc *sch;
+	struct list_head *cb_list_head;
 };
 
 enum tc_setup_type;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..e3f0d5906811 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -321,6 +321,7 @@ EXPORT_SYMBOL(flow_block_cb_setup_simple);
 static DEFINE_MUTEX(flow_indr_block_lock);
 static LIST_HEAD(flow_block_indr_list);
 static LIST_HEAD(flow_block_indr_dev_list);
+static LIST_HEAD(flow_indir_dev_list);
 
 struct flow_indr_dev {
 	struct list_head		list;
@@ -346,6 +347,33 @@ static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
 	return indr_dev;
 }
 
+struct flow_indir_dev_info {
+	void *data;
+	struct net_device *dev;
+	struct Qdisc *sch;
+	enum tc_setup_type type;
+	void (*cleanup)(struct flow_block_cb *block_cb);
+	struct list_head list;
+	enum flow_block_command command;
+	enum flow_block_binder_type binder_type;
+	struct list_head *cb_list;
+};
+
+static void existing_qdiscs_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
+{
+	struct flow_block_offload bo;
+	struct flow_indir_dev_info *cur;
+
+	list_for_each_entry(cur, &flow_indir_dev_list, list) {
+		memset(&bo, 0, sizeof(bo));
+		bo.command = cur->command;
+		bo.binder_type = cur->binder_type;
+		INIT_LIST_HEAD(&bo.cb_list);
+		cb(cur->dev, cur->sch, cb_priv, cur->type, &bo, cur->data, cur->cleanup);
+		list_splice(&bo.cb_list, cur->cb_list);
+	}
+}
+
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 {
 	struct flow_indr_dev *indr_dev;
@@ -367,6 +395,7 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	}
 
 	list_add(&indr_dev->list, &flow_block_indr_dev_list);
+	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
 	return 0;
@@ -463,7 +492,59 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(flow_indr_block_cb_alloc);
 
-int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
+static struct flow_indir_dev_info *find_indir_dev(void *data)
+{
+	struct flow_indir_dev_info *cur;
+
+	list_for_each_entry(cur, &flow_indir_dev_list, list) {
+		if (cur->data == data)
+			return cur;
+	}
+	return NULL;
+}
+
+static int indir_dev_add(void *data, struct net_device *dev, struct Qdisc *sch,
+			 enum tc_setup_type type, void (*cleanup)(struct flow_block_cb *block_cb),
+			 struct flow_block_offload *bo)
+{
+	struct flow_indir_dev_info *info;
+
+	info = find_indir_dev(data);
+	if (info)
+		return -EEXIST;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->data = data;
+	info->dev = dev;
+	info->sch = sch;
+	info->type = type;
+	info->cleanup = cleanup;
+	info->command = bo->command;
+	info->binder_type = bo->binder_type;
+	info->cb_list = bo->cb_list_head;
+
+	list_add(&info->list, &flow_indir_dev_list);
+	return 0;
+}
+
+static int indir_dev_remove(void *data)
+{
+	struct flow_indir_dev_info *info;
+
+	info = find_indir_dev(data);
+	if (!info)
+		return -ENOENT;
+
+	list_del(&info->list);
+
+	kfree(info);
+	return 0;
+}
+
+int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb))
@@ -471,6 +552,12 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 	struct flow_indr_dev *this;
 
 	mutex_lock(&flow_indr_block_lock);
+
+	if (bo->command == FLOW_BLOCK_BIND)
+		indir_dev_add(data, dev, sch, type, cleanup, bo);
+	else if (bo->command == FLOW_BLOCK_UNBIND)
+		indir_dev_remove(data);
+
 	list_for_each_entry(this, &flow_block_indr_dev_list, list)
 		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index f92006cec94c..cbd9f59098b7 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1097,6 +1097,7 @@ static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->cb_list_head = &flowtable->flow_block.cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b58d73a96523..9656c1646222 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -353,6 +353,7 @@ static void nft_flow_block_offload_init(struct flow_block_offload *bo,
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->cb_list_head = &basechain->flow_block.cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e3e79e9bd706..9b276d14be4c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -634,6 +634,7 @@ static void tcf_block_offload_init(struct flow_block_offload *bo,
 	bo->block_shared = shared;
 	bo->extack = extack;
 	bo->sch = sch;
+	bo->cb_list_head = &flow_block->cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
-- 
2.30.2

