Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDE15B0A2
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF3QY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfF3QY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 12:24:28 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307F820838;
        Sun, 30 Jun 2019 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561911867;
        bh=MYWLIve9R07aQOToDgYN0YhbSuiHvtsEgMdSy5Rq2Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqjUgYUQqvxGgrSObzCUj9e2H6yTJZ9n8VK1MbHTwL8O/FIvm0SFs0iwg56nDrZRv
         p+VTqh3VjD4bVE/Ga9ckvz4B9N8W8U6iQNzlY3jHG0tnPYEkS2xuSRLDlhLZdksrYS
         0VEPGr42i67xjyAOKFWbhwaGqkg1aaZX0Ks2HuZM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 11/13] IB/mlx5: Implement DEVX dispatching event
Date:   Sun, 30 Jun 2019 19:23:32 +0300
Message-Id: <20190630162334.22135-12-leon@kernel.org>
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

Implement DEVX dispatching event by looking up for the applicable
subscriptions for the reported event and using their target fd to
signal/set the event.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c         | 303 +++++++++++++++++++++-
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |   5 +
 2 files changed, 305 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 6fb58339b291..de068fe94363 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -34,6 +34,11 @@ struct devx_async_data {
 	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
 };
 
+struct devx_async_event_data {
+	struct list_head list; /* headed in ev_file->event_list */
+	struct mlx5_ib_uapi_devx_async_event_hdr hdr;
+};
+
 /* first level XA value data structure */
 struct devx_event {
 	struct xarray object_ids; /* second XA level, Key = object id */
@@ -77,6 +82,8 @@ struct devx_async_event_file {
 	struct list_head event_list;
 	struct mlx5_ib_dev *dev;
 	u8 omit_data:1;
+	u8 is_overflow_err:1;
+	u8 is_destroyed:1;
 };
 
 #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
@@ -289,6 +296,29 @@ static u16 get_dec_obj_type(struct devx_obj *obj, u16 event_num)
 	}
 }
 
+static u16 get_event_obj_type(unsigned long event_type, struct mlx5_eqe *eqe)
+{
+	switch (event_type) {
+	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+	case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
+	case MLX5_EVENT_TYPE_PATH_MIG:
+	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
+	case MLX5_EVENT_TYPE_COMM_EST:
+	case MLX5_EVENT_TYPE_SQ_DRAINED:
+	case MLX5_EVENT_TYPE_SRQ_RQ_LIMIT:
+	case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
+		return eqe->data.qp_srq.type;
+	case MLX5_EVENT_TYPE_CQ_ERROR:
+		return 0;
+	case MLX5_EVENT_TYPE_DCT_DRAINED:
+		return MLX5_EVENT_QUEUE_TYPE_DCT;
+	default:
+		return MLX5_GET(affiliated_event_header, &eqe->data, obj_type);
+	}
+}
+
 static u32 get_dec_obj_id(u64 obj_id)
 {
 	return (obj_id & 0xffffffff);
@@ -2171,10 +2201,170 @@ static int devx_umem_cleanup(struct ib_uobject *uobject,
 	return 0;
 }
 
+static bool is_unaffiliated_event(struct mlx5_core_dev *dev,
+				  unsigned long event_type)
+{
+	__be64 *unaff_events;
+	int mask_entry;
+	int mask_bit;
+
+	if (!MLX5_CAP_GEN(dev, event_cap))
+		return is_legacy_unaffiliated_event_num(event_type);
+
+	unaff_events = MLX5_CAP_DEV_EVENT(dev,
+					  user_unaffiliated_events);
+	WARN_ON(event_type > MAX_SUPP_EVENT_NUM);
+
+	mask_entry = event_type / 64;
+	mask_bit = event_type % 64;
+
+	if (!(be64_to_cpu(unaff_events[mask_entry]) & (1ull << mask_bit)))
+		return false;
+
+	return true;
+}
+
+static u32 devx_get_obj_id_from_event(unsigned long event_type, void *data)
+{
+	struct mlx5_eqe *eqe = data;
+	u32 obj_id = 0;
+
+	switch (event_type) {
+	case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
+	case MLX5_EVENT_TYPE_SRQ_RQ_LIMIT:
+	case MLX5_EVENT_TYPE_PATH_MIG:
+	case MLX5_EVENT_TYPE_COMM_EST:
+	case MLX5_EVENT_TYPE_SQ_DRAINED:
+	case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
+	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
+	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+		obj_id = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
+		break;
+	case MLX5_EVENT_TYPE_DCT_DRAINED:
+		obj_id = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
+		break;
+	case MLX5_EVENT_TYPE_CQ_ERROR:
+		obj_id = be32_to_cpu(eqe->data.cq_err.cqn) & 0xffffff;
+		break;
+	default:
+		obj_id = MLX5_GET(affiliated_event_header, &eqe->data, obj_id);
+		break;
+	}
+
+	return obj_id;
+}
+
+static int deliver_event(struct devx_event_subscription *event_sub,
+			 const void *data)
+{
+	struct devx_async_event_file *ev_file;
+	struct devx_async_event_data *event_data;
+	unsigned long flags;
+
+	ev_file = event_sub->ev_file;
+
+	if (ev_file->omit_data) {
+		spin_lock_irqsave(&ev_file->lock, flags);
+		if (!list_empty(&event_sub->event_list)) {
+			spin_unlock_irqrestore(&ev_file->lock, flags);
+			return 0;
+		}
+
+		list_add_tail(&event_sub->event_list, &ev_file->event_list);
+		spin_unlock_irqrestore(&ev_file->lock, flags);
+		wake_up_interruptible(&ev_file->poll_wait);
+		return 0;
+	}
+
+	event_data = kzalloc(sizeof(*event_data) + sizeof(struct mlx5_eqe),
+			     GFP_ATOMIC);
+	if (!event_data) {
+		spin_lock_irqsave(&ev_file->lock, flags);
+		ev_file->is_overflow_err = 1;
+		spin_unlock_irqrestore(&ev_file->lock, flags);
+		return -ENOMEM;
+	}
+
+	event_data->hdr.cookie = event_sub->cookie;
+	memcpy(event_data->hdr.out_data, data, sizeof(struct mlx5_eqe));
+
+	spin_lock_irqsave(&ev_file->lock, flags);
+	list_add_tail(&event_data->list, &ev_file->event_list);
+	spin_unlock_irqrestore(&ev_file->lock, flags);
+	wake_up_interruptible(&ev_file->poll_wait);
+
+	return 0;
+}
+
+static void dispatch_event_fd(struct list_head *fd_list,
+			      const void *data)
+{
+	struct devx_event_subscription *item;
+
+	list_for_each_entry_rcu(item, fd_list, xa_list) {
+		if (!get_file_rcu(item->filp))
+			continue;
+
+		if (item->eventfd) {
+			eventfd_signal(item->eventfd, 1);
+			fput(item->filp);
+			continue;
+		}
+
+		deliver_event(item, data);
+		fput(item->filp);
+	}
+}
+
 static int devx_event_notifier(struct notifier_block *nb,
 			       unsigned long event_type, void *data)
 {
-	return NOTIFY_DONE;
+	struct mlx5_devx_event_table *table;
+	struct mlx5_ib_dev *dev;
+	struct devx_event *event;
+	struct devx_obj_event *obj_event;
+	u16 obj_type = 0;
+	bool is_unaffiliated;
+	u32 obj_id;
+
+	/* Explicit filtering to kernel events which may occur frequently */
+	if (event_type == MLX5_EVENT_TYPE_CMD ||
+	    event_type == MLX5_EVENT_TYPE_PAGE_REQUEST)
+		return NOTIFY_OK;
+
+	table = container_of(nb, struct mlx5_devx_event_table, devx_nb.nb);
+	dev = container_of(table, struct mlx5_ib_dev, devx_event_table);
+	is_unaffiliated = is_unaffiliated_event(dev->mdev, event_type);
+
+	if (!is_unaffiliated)
+		obj_type = get_event_obj_type(event_type, data);
+
+	rcu_read_lock();
+	event = xa_load(&table->event_xa, event_type | (obj_type << 16));
+	if (!event) {
+		rcu_read_unlock();
+		return NOTIFY_DONE;
+	}
+
+	if (is_unaffiliated) {
+		dispatch_event_fd(&event->unaffiliated_list, data);
+		rcu_read_unlock();
+		return NOTIFY_OK;
+	}
+
+	obj_id = devx_get_obj_id_from_event(event_type, data);
+	obj_event = xa_load(&event->object_ids, obj_id);
+	if (!obj_event) {
+		rcu_read_unlock();
+		return NOTIFY_DONE;
+	}
+
+	dispatch_event_fd(&obj_event->obj_sub_list, data);
+
+	rcu_read_unlock();
+	return NOTIFY_OK;
 }
 
 void mlx5_ib_devx_init_event_table(struct mlx5_ib_dev *dev)
@@ -2309,19 +2499,108 @@ static const struct file_operations devx_async_cmd_event_fops = {
 static ssize_t devx_async_event_read(struct file *filp, char __user *buf,
 				     size_t count, loff_t *pos)
 {
-	return -EINVAL;
+	struct devx_async_event_file *ev_file = filp->private_data;
+	struct devx_event_subscription *event_sub;
+	struct devx_async_event_data *uninitialized_var(event);
+	int ret = 0;
+	size_t eventsz;
+	bool omit_data;
+	void *event_data;
+
+	omit_data = ev_file->omit_data;
+
+	spin_lock_irq(&ev_file->lock);
+
+	if (ev_file->is_overflow_err) {
+		ev_file->is_overflow_err = 0;
+		spin_unlock_irq(&ev_file->lock);
+		return -EOVERFLOW;
+	}
+
+	if (ev_file->is_destroyed) {
+		spin_unlock_irq(&ev_file->lock);
+		return -EIO;
+	}
+
+	while (list_empty(&ev_file->event_list)) {
+		spin_unlock_irq(&ev_file->lock);
+
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		if (wait_event_interruptible(ev_file->poll_wait,
+			    (!list_empty(&ev_file->event_list) ||
+			     ev_file->is_destroyed))) {
+			return -ERESTARTSYS;
+		}
+
+		spin_lock_irq(&ev_file->lock);
+		if (ev_file->is_destroyed) {
+			spin_unlock_irq(&ev_file->lock);
+			return -EIO;
+		}
+	}
+
+	if (omit_data) {
+		event_sub = list_first_entry(&ev_file->event_list,
+					struct devx_event_subscription,
+					event_list);
+		eventsz = sizeof(event_sub->cookie);
+		event_data = &event_sub->cookie;
+	} else {
+		event = list_first_entry(&ev_file->event_list,
+				      struct devx_async_event_data, list);
+		eventsz = sizeof(struct mlx5_eqe) +
+			sizeof(struct mlx5_ib_uapi_devx_async_event_hdr);
+		event_data = &event->hdr;
+	}
+
+	if (eventsz > count) {
+		spin_unlock_irq(&ev_file->lock);
+		return -EINVAL;
+	}
+
+	if (omit_data)
+		list_del_init(&event_sub->event_list);
+	else
+		list_del(&event->list);
+
+	spin_unlock_irq(&ev_file->lock);
+
+	if (copy_to_user(buf, event_data, eventsz))
+		/* This points to an application issue, not a kernel concern */
+		ret = -EFAULT;
+	else
+		ret = eventsz;
+
+	if (!omit_data)
+		kfree(event);
+	return ret;
 }
 
 static __poll_t devx_async_event_poll(struct file *filp,
 				      struct poll_table_struct *wait)
 {
-	return 0;
+	struct devx_async_event_file *ev_file = filp->private_data;
+	__poll_t pollflags = 0;
+
+	poll_wait(filp, &ev_file->poll_wait, wait);
+
+	spin_lock_irq(&ev_file->lock);
+	if (ev_file->is_destroyed)
+		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+	else if (!list_empty(&ev_file->event_list))
+		pollflags = EPOLLIN | EPOLLRDNORM;
+	spin_unlock_irq(&ev_file->lock);
+
+	return pollflags;
 }
 
 static int devx_async_event_close(struct inode *inode, struct file *filp)
 {
 	struct devx_async_event_file *ev_file = filp->private_data;
 	struct devx_event_subscription *event_sub, *event_sub_tmp;
+	struct devx_async_event_data *entry, *tmp;
 
 	mutex_lock(&ev_file->dev->devx_event_table.event_xa_lock);
 	/* delete the subscriptions which are related to this FD */
@@ -2338,6 +2617,15 @@ static int devx_async_event_close(struct inode *inode, struct file *filp)
 
 	mutex_unlock(&ev_file->dev->devx_event_table.event_xa_lock);
 
+	/* free the pending events allocation */
+	if (!ev_file->omit_data) {
+		spin_lock_irq(&ev_file->lock);
+		list_for_each_entry_safe(entry, tmp,
+					 &ev_file->event_list, list)
+			kfree(entry); /* read can't come any more */
+		spin_unlock_irq(&ev_file->lock);
+	}
+
 	uverbs_close_fd(filp);
 	put_device(&ev_file->dev->ib_dev.dev);
 	return 0;
@@ -2373,6 +2661,15 @@ static int devx_hot_unplug_async_cmd_event_file(struct ib_uobject *uobj,
 static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj,
 					    enum rdma_remove_reason why)
 {
+	struct devx_async_event_file *ev_file =
+		container_of(uobj, struct devx_async_event_file,
+			     uobj);
+
+	spin_lock_irq(&ev_file->lock);
+	ev_file->is_destroyed = 1;
+	spin_unlock_irq(&ev_file->lock);
+
+	wake_up_interruptible(&ev_file->poll_wait);
 	return 0;
 };
 
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index b44691315d39..7e9900b0e746 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -67,5 +67,10 @@ enum mlx5_ib_uapi_devx_create_event_channel_flags {
 	MLX5_IB_UAPI_DEVX_CR_EV_CH_FLAGS_OMIT_DATA = 1 << 0,
 };
 
+struct mlx5_ib_uapi_devx_async_event_hdr {
+	__aligned_u64	cookie;
+	__u8		out_data[];
+};
+
 #endif
 
-- 
2.20.1

