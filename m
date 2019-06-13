Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A5C44532
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732503AbfFMQmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730506AbfFMGrb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:47:31 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BC4D20896;
        Thu, 13 Jun 2019 06:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560408448;
        bh=QcL1f9ZZRMMmNsvKKUELT/o08voFsJrMadF8ibQ3Y64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnbTQR1e9FarviFGQtN0c4mG8ZHqN/WvNOIMjFJ9hHpLOxerMbWMjzYrmrp+VQLKx
         1oin1x8DyfIyhEx64IZ7M057t/1fHeC/mUrQAVJxXJ1nH67skHWcHI9xgaHMDJJuTU
         9nMSdZ1Ke4y4l9xVielDHen2Vikf34B67EVR13dA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 11/12] IB/mlx5: Implement DEVX dispatching event
Date:   Thu, 13 Jun 2019 09:46:38 +0300
Message-Id: <20190613064639.30898-12-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613064639.30898-1-leon@kernel.org>
References: <20190613064639.30898-1-leon@kernel.org>
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
 drivers/infiniband/hw/mlx5/devx.c         | 365 +++++++++++++++++++++-
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |   5 +
 2 files changed, 367 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index f48004b3d494..b96420021b1d 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -34,6 +34,11 @@ struct devx_async_data {
 	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
 };
 
+struct devx_async_event_data {
+	struct list_head list; /* headed in ev_queue->event_list */
+	struct mlx5_ib_uapi_devx_async_event_hdr hdr;
+};
+
 /* first level XA value data structure */
 struct devx_event {
 	struct xarray object_ids; /* second XA level, Key = object id */
@@ -54,6 +59,7 @@ struct devx_event_subscription {
 				   * devx_obj_event->obj_sub_list
 				   */
 	struct list_head obj_list; /* headed in devx_object */
+	struct list_head event_list; /* headed in ev_queue->event_list */
 
 	u32 xa_key_level1;
 	u32 xa_key_level2;
@@ -70,6 +76,7 @@ struct devx_async_event_queue {
 	struct list_head	event_list;
 	atomic_t		bytes_in_use;
 	u8			is_destroyed:1;
+	u8			is_overflow_err:1;
 	u32			flags;
 };
 
@@ -293,6 +300,46 @@ static u16 get_dec_obj_type(struct devx_obj *obj, u16 event_num)
 	}
 }
 
+/* Any future affiliated event should have a fixed header to get the obj
+ * type and id including events on legacy objects.
+ */
+static u32 get_affiliated_event_obj_id(struct mlx5_eqe *eqe)
+{
+	u32 obj_id = MLX5_GET(affiliated_event_header, eqe, obj_id);
+
+	return obj_id;
+}
+
+static u16 get_affiliated_event_obj_type(struct mlx5_eqe *eqe)
+{
+	u16 obj_type = MLX5_GET(affiliated_event_header, eqe, obj_type);
+
+	return obj_type;
+}
+
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
+		return get_affiliated_event_obj_type(eqe);
+	}
+}
+
 static u32 get_dec_obj_id(u64 obj_id)
 {
 	return (obj_id & 0xffffffff);
@@ -1965,6 +2012,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 		event_sub_arr[i]->xa_key_level1 = key_level1;
 		event_sub_arr[i]->xa_key_level2 = obj_id;
 		event_sub_arr[i]->is_obj_related = obj ? true : false;
+		INIT_LIST_HEAD(&event_sub_arr[i]->event_list);
 	}
 
 	/* Once all the allocations and the reservations for level 2
@@ -2175,10 +2223,174 @@ static int devx_umem_cleanup(struct ib_uobject *uobject,
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
+		obj_id = get_affiliated_event_obj_id(data);
+		break;
+	}
+
+	return obj_id;
+}
+
+static int deliver_event(struct devx_event_subscription *event_sub,
+			 const void *data)
+{
+	struct ib_uobject *fd_uobj = event_sub->fd_uobj;
+	struct devx_async_event_file *ev_file;
+	struct devx_async_event_queue *ev_queue;
+	struct devx_async_event_data *event_data;
+	unsigned long flags;
+	bool omit_data;
+
+	ev_file = container_of(fd_uobj, struct devx_async_event_file,
+			       uobj);
+	ev_queue = &ev_file->ev_queue;
+	omit_data = ev_queue->flags &
+		MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA;
+
+	if (omit_data) {
+		spin_lock_irqsave(&ev_queue->lock, flags);
+		if (!list_empty(&event_sub->event_list)) {
+			spin_unlock_irqrestore(&ev_queue->lock, flags);
+			return 0;
+		}
+
+		list_add_tail(&event_sub->event_list, &ev_queue->event_list);
+		spin_unlock_irqrestore(&ev_queue->lock, flags);
+		wake_up_interruptible(&ev_queue->poll_wait);
+		return 0;
+	}
+
+	event_data = kzalloc(sizeof(*event_data) +
+			     (omit_data ? 0 : sizeof(struct mlx5_eqe)),
+			     GFP_ATOMIC);
+	if (!event_data) {
+		spin_lock_irqsave(&ev_queue->lock, flags);
+		ev_queue->is_overflow_err = 1;
+		spin_unlock_irqrestore(&ev_queue->lock, flags);
+		return -ENOMEM;
+	}
+
+	event_data->hdr.cookie = event_sub->cookie;
+	memcpy(event_data->hdr.out_data, data, sizeof(struct mlx5_eqe));
+
+	spin_lock_irqsave(&ev_queue->lock, flags);
+	list_add_tail(&event_data->list, &ev_queue->event_list);
+	spin_unlock_irqrestore(&ev_queue->lock, flags);
+	wake_up_interruptible(&ev_queue->poll_wait);
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
+		if (!get_file_rcu((struct file *)item->fd_uobj->object))
+			continue;
+
+		if (item->eventfd) {
+			eventfd_signal(item->eventfd, 1);
+			fput(item->fd_uobj->object);
+			continue;
+		}
+
+		deliver_event(item, data);
+		fput(item->fd_uobj->object);
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
+	event = xa_load(&table->event_xa, event_type | (obj_type << 16));
+	if (!event)
+		return NOTIFY_DONE;
+
+	if (is_unaffiliated) {
+		dispatch_event_fd(&event->unaffiliated_list, data);
+		return NOTIFY_OK;
+	}
+
+	obj_id = devx_get_obj_id_from_event(event_type, data);
+	rcu_read_lock();
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
@@ -2306,17 +2518,153 @@ static const struct file_operations devx_async_cmd_event_fops = {
 static ssize_t devx_async_event_read(struct file *filp, char __user *buf,
 				     size_t count, loff_t *pos)
 {
-	return -EINVAL;
+	struct devx_async_event_file *ev_file = filp->private_data;
+	struct devx_async_event_queue *ev_queue = &ev_file->ev_queue;
+	struct devx_event_subscription *event_sub;
+	struct devx_async_event_data *uninitialized_var(event);
+	int ret = 0;
+	size_t eventsz;
+	bool omit_data;
+	void *event_data;
+
+	omit_data = ev_queue->flags &
+		MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA;
+
+	spin_lock_irq(&ev_queue->lock);
+
+	if (ev_queue->is_overflow_err) {
+		ev_queue->is_overflow_err = 0;
+		spin_unlock_irq(&ev_queue->lock);
+		return -EOVERFLOW;
+	}
+
+	while (list_empty(&ev_queue->event_list)) {
+		spin_unlock_irq(&ev_queue->lock);
+
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		if (wait_event_interruptible(ev_queue->poll_wait,
+			    (!list_empty(&ev_queue->event_list) ||
+			     ev_queue->is_destroyed))) {
+			return -ERESTARTSYS;
+		}
+
+		if (list_empty(&ev_queue->event_list) &&
+		    ev_queue->is_destroyed)
+			return -EIO;
+
+		spin_lock_irq(&ev_queue->lock);
+	}
+
+	if (omit_data) {
+		event_sub = list_first_entry(&ev_queue->event_list,
+					struct devx_event_subscription,
+					event_list);
+		eventsz = sizeof(event_sub->cookie);
+		event_data = &event_sub->cookie;
+	} else {
+		event = list_first_entry(&ev_queue->event_list,
+				      struct devx_async_event_data, list);
+		eventsz = sizeof(struct mlx5_eqe) +
+			sizeof(struct mlx5_ib_uapi_devx_async_event_hdr);
+		event_data = &event->hdr;
+	}
+
+	if (eventsz > count) {
+		spin_unlock_irq(&ev_queue->lock);
+		return -ENOSPC;
+	}
+
+	if (omit_data)
+		list_del_init(&event_sub->event_list);
+	else
+		list_del(&event->list);
+
+	spin_unlock_irq(&ev_queue->lock);
+
+	if (copy_to_user(buf, event_data, eventsz))
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
+	struct devx_async_event_queue *ev_queue = &ev_file->ev_queue;
+	__poll_t pollflags = 0;
+
+	poll_wait(filp, &ev_queue->poll_wait, wait);
+
+	spin_lock_irq(&ev_queue->lock);
+	if (ev_queue->is_destroyed)
+		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+	else if (!list_empty(&ev_queue->event_list))
+		pollflags = EPOLLIN | EPOLLRDNORM;
+	spin_unlock_irq(&ev_queue->lock);
+
+	return pollflags;
 }
 
 static int devx_async_event_close(struct inode *inode, struct file *filp)
 {
+	struct ib_uobject *uobj = filp->private_data;
+	struct devx_async_event_file *ev_file =
+		container_of(uobj, struct devx_async_event_file, uobj);
+	struct devx_event_subscription *event_sub, *event_sub_tmp;
+	struct devx_async_event_data *entry, *tmp;
+
+	mutex_lock(&ev_file->dev->devx_event_table.event_xa_lock);
+	/* delete the subscriptions which are related to this FD */
+	list_for_each_entry_safe(event_sub, event_sub_tmp,
+				 &ev_file->subscribed_events_list, file_list) {
+		list_del_rcu(&event_sub->file_list);
+		list_del_rcu(&event_sub->xa_list);
+		if (event_sub->is_obj_related) {
+			struct devx_event *event;
+			struct devx_obj_event *xa_val_level2;
+
+			list_del_rcu(&event_sub->obj_list);
+
+			/* check whether the key level 1 for this obj_sub_list
+			 * is empty
+			 */
+			event = xa_load(
+				&ev_file->dev->devx_event_table.event_xa,
+				event_sub->xa_key_level1);
+			WARN_ON(!event);
+
+			xa_val_level2 = xa_load(&event->object_ids,
+						event_sub->xa_key_level2);
+			if (list_empty(&xa_val_level2->obj_sub_list)) {
+				xa_erase(&event->object_ids,
+					 event_sub->xa_key_level2);
+				kfree_rcu(xa_val_level2, rcu);
+			}
+		}
+
+		if (event_sub->eventfd)
+			eventfd_ctx_put(event_sub->eventfd);
+
+		kfree_rcu(event_sub, rcu);
+	}
+	mutex_unlock(&ev_file->dev->devx_event_table.event_xa_lock);
+
+	/* free the pending events allocation */
+	if (!(ev_file->ev_queue.flags &
+	    MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA)) {
+		spin_lock_irq(&ev_file->ev_queue.lock);
+		list_for_each_entry_safe(entry, tmp,
+					 &ev_file->ev_queue.event_list, list)
+			kfree(entry); /* read can't come any nore */
+		spin_unlock_irq(&ev_file->ev_queue.lock);
+	}
 	uverbs_close_fd(filp);
 	return 0;
 }
@@ -2351,6 +2699,17 @@ static int devx_hot_unplug_async_cmd_event_file(struct ib_uobject *uobj,
 static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj,
 					    enum rdma_remove_reason why)
 {
+	struct devx_async_event_file *ev_file =
+		container_of(uobj, struct devx_async_event_file,
+			     uobj);
+	struct devx_async_event_queue *ev_queue = &ev_file->ev_queue;
+
+	spin_lock_irq(&ev_queue->lock);
+	ev_queue->is_destroyed = 1;
+	spin_unlock_irq(&ev_queue->lock);
+
+	if (why == RDMA_REMOVE_DRIVER_REMOVE)
+		wake_up_interruptible(&ev_queue->poll_wait);
 	return 0;
 };
 
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index 57beea4589e4..9500ff7363ef 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -67,5 +67,10 @@ enum mlx5_ib_uapi_devx_create_event_channel_flags {
 	MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA = 1 << 0,
 };
 
+struct mlx5_ib_uapi_devx_async_event_hdr {
+	__aligned_u64	cookie;
+	__u8		out_data[];
+};
+
 #endif
 
-- 
2.20.1

