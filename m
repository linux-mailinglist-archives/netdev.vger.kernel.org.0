Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153BE5B09C
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfF3QYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfF3QYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 12:24:12 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9269120673;
        Sun, 30 Jun 2019 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561911850;
        bh=Llw08yT9b00HV55RRDdgcrxmNSAqk/dKbBY0zBjL8P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sf9dreCbW97WPpjxnTwTb7BCjHuX5jZQC1luyrZDH+imbpE95g77/03uX28b2nUq+
         XzLZ40pzf3ZaBWennt37OG+WLcqGqQQJrWo6FQjDWuuT6w6qtaP/1at5xEqu082nRI
         KWsEG9V7LCnyHosW/0yuqX1noxAokkplo7FCADG4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 08/13] IB/mlx5: Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
Date:   Sun, 30 Jun 2019 19:23:29 +0300
Message-Id: <20190630162334.22135-9-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
References: <20190630162334.22135-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD and its initial
implementation.

This object is from type class FD and will be used to read DEVX
async events.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c         | 95 +++++++++++++++++++++++
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  | 10 +++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |  4 +
 3 files changed, 109 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 80b42d069328..89947b4f4f6f 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -33,6 +33,17 @@ struct devx_async_data {
 	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
 };
 
+struct devx_async_event_file {
+	struct ib_uobject uobj;
+	/* Head of events that are subscribed to this FD */
+	struct list_head subscribed_events_list;
+	spinlock_t lock;
+	wait_queue_head_t poll_wait;
+	struct list_head event_list;
+	struct mlx5_ib_dev *dev;
+	u8 omit_data:1;
+};
+
 #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
 struct devx_obj {
 	struct mlx5_core_dev	*mdev;
@@ -1375,6 +1386,37 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_ASYNC_CMD_FD_ALLOC)(
 	return 0;
 }
 
+static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_ASYNC_EVENT_FD_ALLOC)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(
+		attrs, MLX5_IB_ATTR_DEVX_ASYNC_EVENT_FD_ALLOC_HANDLE);
+	struct devx_async_event_file *ev_file;
+	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
+		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
+	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	u32 flags;
+	int err;
+
+	err = uverbs_get_flags32(&flags, attrs,
+		MLX5_IB_ATTR_DEVX_ASYNC_EVENT_FD_ALLOC_FLAGS,
+		MLX5_IB_UAPI_DEVX_CR_EV_CH_FLAGS_OMIT_DATA);
+
+	if (err)
+		return err;
+
+	ev_file = container_of(uobj, struct devx_async_event_file,
+			       uobj);
+	spin_lock_init(&ev_file->lock);
+	INIT_LIST_HEAD(&ev_file->event_list);
+	init_waitqueue_head(&ev_file->poll_wait);
+	if (flags & MLX5_IB_UAPI_DEVX_CR_EV_CH_FLAGS_OMIT_DATA)
+		ev_file->omit_data = 1;
+	INIT_LIST_HEAD(&ev_file->subscribed_events_list);
+	ev_file->dev = dev;
+	return 0;
+}
+
 static void devx_query_callback(int status, struct mlx5_async_work *context)
 {
 	struct devx_async_data *async_data =
@@ -1729,6 +1771,32 @@ static const struct file_operations devx_async_cmd_event_fops = {
 	.llseek	 = no_llseek,
 };
 
+static ssize_t devx_async_event_read(struct file *filp, char __user *buf,
+				     size_t count, loff_t *pos)
+{
+	return -EINVAL;
+}
+
+static __poll_t devx_async_event_poll(struct file *filp,
+				      struct poll_table_struct *wait)
+{
+	return 0;
+}
+
+static int devx_async_event_close(struct inode *inode, struct file *filp)
+{
+	uverbs_close_fd(filp);
+	return 0;
+}
+
+static const struct file_operations devx_async_event_fops = {
+	.owner	 = THIS_MODULE,
+	.read	 = devx_async_event_read,
+	.poll    = devx_async_event_poll,
+	.release = devx_async_event_close,
+	.llseek	 = no_llseek,
+};
+
 static int devx_hot_unplug_async_cmd_event_file(struct ib_uobject *uobj,
 						   enum rdma_remove_reason why)
 {
@@ -1748,6 +1816,12 @@ static int devx_hot_unplug_async_cmd_event_file(struct ib_uobject *uobj,
 	return 0;
 };
 
+static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj,
+					    enum rdma_remove_reason why)
+{
+	return 0;
+};
+
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_DEVX_UMEM_REG,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DEVX_UMEM_REG_HANDLE,
@@ -1913,6 +1987,24 @@ DECLARE_UVERBS_NAMED_OBJECT(
 			     O_RDONLY),
 	&UVERBS_METHOD(MLX5_IB_METHOD_DEVX_ASYNC_CMD_FD_ALLOC));
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_DEVX_ASYNC_EVENT_FD_ALLOC,
+	UVERBS_ATTR_FD(MLX5_IB_ATTR_DEVX_ASYNC_EVENT_FD_ALLOC_HANDLE,
+			MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_FLAGS_IN(MLX5_IB_ATTR_DEVX_ASYNC_EVENT_FD_ALLOC_FLAGS,
+			enum mlx5_ib_uapi_devx_create_event_channel_flags,
+			UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(
+	MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD,
+	UVERBS_TYPE_ALLOC_FD(sizeof(struct devx_async_event_file),
+			     devx_hot_unplug_async_event_file,
+			     &devx_async_event_fops, "[devx_async_event]",
+			     O_RDONLY),
+	&UVERBS_METHOD(MLX5_IB_METHOD_DEVX_ASYNC_EVENT_FD_ALLOC));
+
 static bool devx_is_supported(struct ib_device *device)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
@@ -1933,5 +2025,8 @@ const struct uapi_definition mlx5_ib_devx_defs[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(
 		MLX5_IB_OBJECT_DEVX_ASYNC_CMD_FD,
 		UAPI_DEF_IS_OBJ_SUPPORTED(devx_is_supported)),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(
+		MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD,
+		UAPI_DEF_IS_OBJ_SUPPORTED(devx_is_supported)),
 	{},
 };
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index d404c951954c..6ad8f4f11ddd 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -127,16 +127,26 @@ enum mlx5_ib_devx_async_cmd_fd_alloc_attrs {
 	MLX5_IB_ATTR_DEVX_ASYNC_CMD_FD_ALLOC_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
 };
 
+enum mlx5_ib_devx_async_event_fd_alloc_attrs {
+	MLX5_IB_ATTR_DEVX_ASYNC_EVENT_FD_ALLOC_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_DEVX_ASYNC_EVENT_FD_ALLOC_FLAGS,
+};
+
 enum mlx5_ib_devx_async_cmd_fd_methods {
 	MLX5_IB_METHOD_DEVX_ASYNC_CMD_FD_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
 };
 
+enum mlx5_ib_devx_async_event_fd_methods {
+	MLX5_IB_METHOD_DEVX_ASYNC_EVENT_FD_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+};
+
 enum mlx5_ib_objects {
 	MLX5_IB_OBJECT_DEVX = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_OBJECT_DEVX_OBJ,
 	MLX5_IB_OBJECT_DEVX_UMEM,
 	MLX5_IB_OBJECT_FLOW_MATCHER,
 	MLX5_IB_OBJECT_DEVX_ASYNC_CMD_FD,
+	MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD,
 };
 
 enum mlx5_ib_flow_matcher_create_attrs {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index a8f34c237458..b44691315d39 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -63,5 +63,9 @@ enum mlx5_ib_uapi_dm_type {
 	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM,
 };
 
+enum mlx5_ib_uapi_devx_create_event_channel_flags {
+	MLX5_IB_UAPI_DEVX_CR_EV_CH_FLAGS_OMIT_DATA = 1 << 0,
+};
+
 #endif
 
-- 
2.20.1

