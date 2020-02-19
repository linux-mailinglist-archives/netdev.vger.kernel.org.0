Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E035F164E68
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgBSTFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSTFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 14:05:33 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3967124671;
        Wed, 19 Feb 2020 19:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582139131;
        bh=u2FHCg6xy+a0nf73hBZtXlK45nuoLT4bAPgLL4NyLls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uA1iCBWACTHeEeNoytgwWKAGuuU9uaRQfN+5v2+gjHEBBdRaVBXDqXhOdxUTE0FhO
         52b/KuTX3x0v4KRx5+dXa04uUZ4V6d8tiYdCETwyS0N+ezzCukFcWVvEQm7gnSiN55
         W5rIgXl+o4aWPukdYCpMiaR3aumREHYvxwbHmsCo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Introduce UAPIs to manage packet pacing
Date:   Wed, 19 Feb 2020 21:05:18 +0200
Message-Id: <20200219190518.200912-3-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219190518.200912-1-leon@kernel.org>
References: <20200219190518.200912-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Introduce packet pacing uobject and its alloc and destroy
methods.

This uobject holds mlx5 packet pacing context according to the device
specification and enables managing packet pacing device entries that are
needed by DEVX applications.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/Makefile       |   1 +
 drivers/infiniband/hw/mlx5/main.c         |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |   6 +
 drivers/infiniband/hw/mlx5/qos.c          | 136 ++++++++++++++++++++++
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  17 +++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |   4 +
 6 files changed, 165 insertions(+)
 create mode 100644 drivers/infiniband/hw/mlx5/qos.c

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index d0a043ccbe58..2a334800f109 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -8,3 +8,4 @@ mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
 mlx5_ib-$(CONFIG_MLX5_ESWITCH) += ib_rep.o
 mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += devx.o
 mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += flow.o
+mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += qos.o
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 398e9f32746e..01bddd584405 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6250,6 +6250,7 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(
 static const struct uapi_definition mlx5_ib_defs[] = {
 	UAPI_DEF_CHAIN(mlx5_ib_devx_defs),
 	UAPI_DEF_CHAIN(mlx5_ib_flow_defs),
+	UAPI_DEF_CHAIN(mlx5_ib_qos_defs),
 
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_FLOW_ACTION,
 				&mlx5_ib_flow_action),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2d65df34a6d0..6c85ca766678 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -201,6 +201,11 @@ struct mlx5_ib_flow_matcher {
 	u8			match_criteria_enable;
 };
 
+struct mlx5_ib_pp {
+	u16 index;
+	struct mlx5_core_dev *mdev;
+};
+
 struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	prios[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	egress_prios[MLX5_IB_NUM_FLOW_FT];
@@ -1379,6 +1384,7 @@ int mlx5_ib_fill_stat_entry(struct sk_buff *msg,
 
 extern const struct uapi_definition mlx5_ib_devx_defs[];
 extern const struct uapi_definition mlx5_ib_flow_defs[];
+extern const struct uapi_definition mlx5_ib_qos_defs[];
 
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user);
diff --git a/drivers/infiniband/hw/mlx5/qos.c b/drivers/infiniband/hw/mlx5/qos.c
new file mode 100644
index 000000000000..f822b06e7c9e
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/qos.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2020, Mellanox Technologies inc.  All rights reserved.
+ */
+
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/mlx5_user_ioctl_cmds.h>
+#include <rdma/mlx5_user_ioctl_verbs.h>
+#include <linux/mlx5/driver.h>
+#include "mlx5_ib.h"
+
+#define UVERBS_MODULE_NAME mlx5_ib
+#include <rdma/uverbs_named_ioctl.h>
+
+static bool pp_is_supported(struct ib_device *device)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+
+	return (MLX5_CAP_GEN(dev->mdev, qos) &&
+		MLX5_CAP_QOS(dev->mdev, packet_pacing) &&
+		MLX5_CAP_QOS(dev->mdev, packet_pacing_uid));
+}
+
+static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
+	struct uverbs_attr_bundle *attrs)
+{
+	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)] = {};
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
+		MLX5_IB_ATTR_PP_OBJ_ALLOC_HANDLE);
+	struct mlx5_ib_dev *dev;
+	struct mlx5_ib_ucontext *c;
+	struct mlx5_ib_pp *pp_entry;
+	void *in_ctx;
+	u16 uid;
+	int inlen;
+	u32 flags;
+	int err;
+
+	c = to_mucontext(ib_uverbs_get_ucontext(attrs));
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+
+	/* The allocated entry can be used only by a DEVX context */
+	if (!c->devx_uid)
+		return -EINVAL;
+
+	dev = to_mdev(c->ibucontext.device);
+	pp_entry = kzalloc(sizeof(*pp_entry), GFP_KERNEL);
+	if (IS_ERR(pp_entry))
+		return PTR_ERR(pp_entry);
+
+	in_ctx = uverbs_attr_get_alloced_ptr(attrs,
+					     MLX5_IB_ATTR_PP_OBJ_ALLOC_CTX);
+	inlen = uverbs_attr_get_len(attrs,
+				    MLX5_IB_ATTR_PP_OBJ_ALLOC_CTX);
+	memcpy(rl_raw, in_ctx, inlen);
+	err = uverbs_get_flags32(&flags, attrs,
+		MLX5_IB_ATTR_PP_OBJ_ALLOC_FLAGS,
+		MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX);
+	if (err)
+		goto err;
+
+	uid = (flags & MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX) ?
+		c->devx_uid : MLX5_SHARED_RESOURCE_UID;
+
+	err = mlx5_rl_add_rate_raw(dev->mdev, rl_raw, uid,
+			(flags & MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX),
+			&pp_entry->index);
+	if (err)
+		goto err;
+
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_PP_OBJ_ALLOC_INDEX,
+			     &pp_entry->index, sizeof(pp_entry->index));
+	if (err)
+		goto clean;
+
+	pp_entry->mdev = dev->mdev;
+	uobj->object = pp_entry;
+	return 0;
+
+clean:
+	mlx5_rl_remove_rate_raw(dev->mdev, pp_entry->index);
+err:
+	kfree(pp_entry);
+	return err;
+}
+
+static int pp_obj_cleanup(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why,
+			  struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_pp *pp_entry = uobject->object;
+
+	mlx5_rl_remove_rate_raw(pp_entry->mdev, pp_entry->index);
+	kfree(pp_entry);
+	return 0;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_PP_OBJ_ALLOC,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_PP_OBJ_ALLOC_HANDLE,
+			MLX5_IB_OBJECT_PP,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(
+		MLX5_IB_ATTR_PP_OBJ_ALLOC_CTX,
+		UVERBS_ATTR_SIZE(1,
+			MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)),
+		UA_MANDATORY,
+		UA_ALLOC_AND_COPY),
+	UVERBS_ATTR_FLAGS_IN(MLX5_IB_ATTR_PP_OBJ_ALLOC_FLAGS,
+			enum mlx5_ib_uapi_pp_alloc_flags,
+			UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_PP_OBJ_ALLOC_INDEX,
+			   UVERBS_ATTR_TYPE(u16),
+			   UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
+	MLX5_IB_METHOD_PP_OBJ_DESTROY,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_PP_OBJ_DESTROY_HANDLE,
+			MLX5_IB_OBJECT_PP,
+			UVERBS_ACCESS_DESTROY,
+			UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_PP,
+			    UVERBS_TYPE_ALLOC_IDR(pp_obj_cleanup),
+			    &UVERBS_METHOD(MLX5_IB_METHOD_PP_OBJ_ALLOC),
+			    &UVERBS_METHOD(MLX5_IB_METHOD_PP_OBJ_DESTROY));
+
+
+const struct uapi_definition mlx5_ib_qos_defs[] = {
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(
+		MLX5_IB_OBJECT_PP,
+		UAPI_DEF_IS_OBJ_SUPPORTED(pp_is_supported)),
+	{},
+};
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index afe7da6f2b8e..8f4a417fc70a 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -143,6 +143,22 @@ enum mlx5_ib_devx_umem_dereg_attrs {
 	MLX5_IB_ATTR_DEVX_UMEM_DEREG_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
 };
 
+enum mlx5_ib_pp_obj_methods {
+	MLX5_IB_METHOD_PP_OBJ_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_METHOD_PP_OBJ_DESTROY,
+};
+
+enum mlx5_ib_pp_alloc_attrs {
+	MLX5_IB_ATTR_PP_OBJ_ALLOC_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_PP_OBJ_ALLOC_CTX,
+	MLX5_IB_ATTR_PP_OBJ_ALLOC_FLAGS,
+	MLX5_IB_ATTR_PP_OBJ_ALLOC_INDEX,
+};
+
+enum mlx5_ib_pp_obj_destroy_attrs {
+	MLX5_IB_ATTR_PP_OBJ_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
 enum mlx5_ib_devx_umem_methods {
 	MLX5_IB_METHOD_DEVX_UMEM_REG = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_METHOD_DEVX_UMEM_DEREG,
@@ -173,6 +189,7 @@ enum mlx5_ib_objects {
 	MLX5_IB_OBJECT_DEVX_ASYNC_CMD_FD,
 	MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD,
 	MLX5_IB_OBJECT_VAR,
+	MLX5_IB_OBJECT_PP,
 };
 
 enum mlx5_ib_flow_matcher_create_attrs {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index 88b6ca70c2fe..b4641a7865f7 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -73,5 +73,9 @@ struct mlx5_ib_uapi_devx_async_event_hdr {
 	__u8		out_data[];
 };
 
+enum mlx5_ib_uapi_pp_alloc_flags {
+	MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX = 1 << 0,
+};
+
 #endif
 
-- 
2.24.1

