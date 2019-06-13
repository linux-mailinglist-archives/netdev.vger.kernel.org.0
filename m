Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1216444564
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbfFMQno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbfFMG12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:27:28 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678042084D;
        Thu, 13 Jun 2019 06:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560407246;
        bh=ZP+rNvKTu5qoHWlDv6HfMlOEJbcm0Iu3e7bChRTc3XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ6pTfNxoJqw8DyF/nabLi/wLpE3Y1igueEBWFxklrc4zmN2Sjvzya5B/0tID7ulp
         u18AUBsEbWFAP1g9zqSNPmeZFHcoIOwL0swKHsFraayJlQ3viU6FngisWHm15O4J7Y
         8DIEZPiklsm+qdHxjAVZcAPWusKm4VX7YLK307fk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 10/12] IB/mlx5: Enable subscription for device events over DEVX
Date:   Thu, 13 Jun 2019 09:26:38 +0300
Message-Id: <20190613062640.28958-11-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613062640.28958-1-leon@kernel.org>
References: <20190613062640.28958-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enable subscription for device events over DEVX.

Each subscription is added to the two level XA data structure according
to its event number and the DEVX object information in case was given
with the given target fd.

Those events will be reported over the given fd once will occur.
Downstream patches will mange the dispatching to any subscription.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c        | 535 ++++++++++++++++++++++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |   9 +
 2 files changed, 540 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index e9b9ba5a3e9a..f48004b3d494 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -14,6 +14,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
+#include <linux/xarray.h>
 
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
@@ -33,6 +34,36 @@ struct devx_async_data {
 	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
 };
 
+/* first level XA value data structure */
+struct devx_event {
+	struct xarray object_ids; /* second XA level, Key = object id */
+	struct list_head unaffiliated_list;
+};
+
+/* second level XA value data structure */
+struct devx_obj_event {
+	struct rcu_head rcu;
+	struct list_head obj_sub_list;
+};
+
+struct devx_event_subscription {
+	struct list_head file_list; /* headed in private_data->
+				     * subscribed_events_list
+				     */
+	struct list_head xa_list; /* headed in devx_event->unaffiliated_list or
+				   * devx_obj_event->obj_sub_list
+				   */
+	struct list_head obj_list; /* headed in devx_object */
+
+	u32 xa_key_level1;
+	u32 xa_key_level2;
+	struct rcu_head	rcu;
+	u64 cookie;
+	bool is_obj_related;
+	struct ib_uobject *fd_uobj;
+	struct eventfd_ctx *eventfd;
+};
+
 struct devx_async_event_queue {
 	spinlock_t		lock;
 	wait_queue_head_t	poll_wait;
@@ -62,6 +93,7 @@ struct devx_obj {
 		struct mlx5_ib_devx_mr	devx_mr;
 		struct mlx5_core_dct	core_dct;
 	};
+	struct list_head event_sub; /* holds devx_event_subscription entries */
 };
 
 struct devx_umem {
@@ -167,6 +199,105 @@ bool mlx5_ib_devx_is_flow_counter(void *obj, u32 *counter_id)
 	return false;
 }
 
+static bool is_legacy_unaffiliated_event_num(u16 event_num)
+{
+	switch (event_num) {
+	case MLX5_EVENT_TYPE_PORT_CHANGE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool is_legacy_obj_event_num(u16 event_num)
+{
+	switch (event_num) {
+	case MLX5_EVENT_TYPE_PATH_MIG:
+	case MLX5_EVENT_TYPE_COMM_EST:
+	case MLX5_EVENT_TYPE_SQ_DRAINED:
+	case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
+	case MLX5_EVENT_TYPE_SRQ_RQ_LIMIT:
+	case MLX5_EVENT_TYPE_CQ_ERROR:
+	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
+	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+	case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
+	case MLX5_EVENT_TYPE_DCT_DRAINED:
+	case MLX5_EVENT_TYPE_COMP:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static u16 get_legacy_obj_type(u16 opcode)
+{
+	switch (opcode) {
+	case MLX5_CMD_OP_CREATE_RQ:
+	case MLX5_CMD_OP_CREATE_XRC_SRQ:
+		return MLX5_EVENT_QUEUE_TYPE_RQ;
+	case MLX5_CMD_OP_CREATE_QP:
+		return MLX5_EVENT_QUEUE_TYPE_QP;
+	case MLX5_CMD_OP_CREATE_SQ:
+		return MLX5_EVENT_QUEUE_TYPE_SQ;
+	case MLX5_CMD_OP_CREATE_DCT:
+		return MLX5_EVENT_QUEUE_TYPE_DCT;
+	default:
+		return 0;
+	}
+}
+
+static u16 get_dec_obj_type(struct devx_obj *obj, u16 event_num)
+{
+	u16 opcode;
+
+	opcode = (obj->obj_id >> 32) & 0xffff;
+
+	if (is_legacy_obj_event_num(event_num))
+		return get_legacy_obj_type(opcode);
+
+	switch (opcode) {
+	case MLX5_CMD_OP_CREATE_GENERAL_OBJECT:
+		return (obj->obj_id >> 48);
+	case MLX5_CMD_OP_CREATE_RQ:
+		return MLX5_OBJ_TYPE_RQ;
+	case MLX5_CMD_OP_CREATE_QP:
+		return MLX5_OBJ_TYPE_QP;
+	case MLX5_CMD_OP_CREATE_SQ:
+		return MLX5_OBJ_TYPE_SQ;
+	case MLX5_CMD_OP_CREATE_DCT:
+		return MLX5_OBJ_TYPE_DCT;
+	case MLX5_CMD_OP_CREATE_TIR:
+		return MLX5_OBJ_TYPE_TIR;
+	case MLX5_CMD_OP_CREATE_TIS:
+		return MLX5_OBJ_TYPE_TIS;
+	case MLX5_CMD_OP_CREATE_PSV:
+		return MLX5_OBJ_TYPE_PSV;
+	case MLX5_OBJ_TYPE_MKEY:
+		return MLX5_OBJ_TYPE_MKEY;
+	case MLX5_CMD_OP_CREATE_RMP:
+		return MLX5_OBJ_TYPE_RMP;
+	case MLX5_CMD_OP_CREATE_XRC_SRQ:
+		return MLX5_OBJ_TYPE_XRC_SRQ;
+	case MLX5_CMD_OP_CREATE_XRQ:
+		return MLX5_OBJ_TYPE_XRQ;
+	case MLX5_CMD_OP_CREATE_RQT:
+		return MLX5_OBJ_TYPE_RQT;
+	case MLX5_CMD_OP_ALLOC_FLOW_COUNTER:
+		return MLX5_OBJ_TYPE_FLOW_COUNTER;
+	case MLX5_CMD_OP_CREATE_CQ:
+		return MLX5_OBJ_TYPE_CQ;
+	default:
+		return 0;
+	}
+}
+
+static u32 get_dec_obj_id(u64 obj_id)
+{
+	return (obj_id & 0xffffffff);
+}
+
 /*
  * As the obj_id in the firmware is not globally unique the object type
  * must be considered upon checking for a valid object id.
@@ -1148,9 +1279,16 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 			    struct uverbs_attr_bundle *attrs)
 {
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	struct mlx5_devx_event_table *devx_event_table;
 	struct devx_obj *obj = uobject->object;
+	struct devx_event_subscription *sub_entry, *tmp;
+	struct devx_obj_event *xa_val_level2;
+	struct devx_event *event;
+	struct mlx5_ib_dev *dev;
+	u32 obj_id;
 	int ret;
 
+	dev = mlx5_udata_to_mdev(&attrs->driver_udata);
 	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY)
 		devx_cleanup_mkey(obj);
 
@@ -1162,10 +1300,33 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	if (ib_is_destroy_retryable(ret, why, uobject))
 		return ret;
 
-	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
-		struct mlx5_ib_dev *dev =
-			mlx5_udata_to_mdev(&attrs->driver_udata);
+	devx_event_table = &dev->devx_event_table;
+	obj_id = get_dec_obj_id(obj->obj_id);
+
+	mutex_lock(&devx_event_table->event_xa_lock);
+
+	list_for_each_entry_safe(sub_entry, tmp, &obj->event_sub, obj_list) {
+		list_del_rcu(&sub_entry->obj_list);
+		list_del_rcu(&sub_entry->xa_list);
+		list_del_rcu(&sub_entry->file_list);
+
+		/* check whether key level 1 for this obj_sub_list is empty */
+		event = xa_load(&devx_event_table->event_xa,
+				sub_entry->xa_key_level1);
+		WARN_ON(!event);
 
+		xa_val_level2 = xa_load(&event->object_ids, obj_id);
+		if (list_empty(&xa_val_level2->obj_sub_list)) {
+			xa_erase(&event->object_ids, obj_id);
+			kfree_rcu(xa_val_level2, rcu);
+		}
+
+		kfree_rcu(sub_entry, rcu);
+	}
+
+	mutex_unlock(&devx_event_table->event_xa_lock);
+
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
 		call_srcu(&dev->mr_srcu, &obj->devx_mr.rcu,
 			  devx_free_indirect_mkey);
 		return ret;
@@ -1237,6 +1398,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
+	INIT_LIST_HEAD(&obj->event_sub);
 	devx_obj_build_destroy_cmd(cmd_in, cmd_out, obj->dinbox, &obj->dinlen,
 				   &obj_id);
 	WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
@@ -1523,6 +1685,349 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 	return err;
 }
 
+static void
+subscribe_event_xa_dealloc(struct mlx5_devx_event_table *devx_event_table,
+			   u32 key_level1,
+			   u32 key_level2,
+			   struct devx_obj_event *alloc_obj_event)
+{
+	struct devx_event *event;
+
+	/* Level 1 is valid for future use - no need to free */
+	if (!alloc_obj_event)
+		return;
+
+	event = xa_load(&devx_event_table->event_xa, key_level1);
+	WARN_ON(!event);
+
+	xa_erase(&event->object_ids, key_level2);
+	kfree(alloc_obj_event);
+}
+
+static int
+subscribe_event_xa_alloc(struct mlx5_devx_event_table *devx_event_table,
+			 u32 key_level1,
+			 bool is_level2,
+			 u32 key_level2,
+			 struct devx_obj_event **alloc_obj_event)
+{
+	struct devx_obj_event *obj_event;
+	struct devx_event *event;
+	bool new_entry_level1 = false;
+	int err;
+
+	event = xa_load(&devx_event_table->event_xa, key_level1);
+	if (!event) {
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (!event)
+			return -ENOMEM;
+
+		new_entry_level1 = true;
+		INIT_LIST_HEAD(&event->unaffiliated_list);
+		xa_init(&event->object_ids);
+
+		err = xa_insert(&devx_event_table->event_xa,
+				key_level1,
+				event,
+				GFP_KERNEL);
+		if (err)
+			goto end;
+	}
+
+	if (!is_level2)
+		return 0;
+
+	obj_event = xa_load(&event->object_ids, key_level2);
+	if (!obj_event) {
+		err = xa_reserve(&event->object_ids, key_level2, GFP_KERNEL);
+		if (err)
+			goto err_level1;
+
+		obj_event = kzalloc(sizeof(*obj_event), GFP_KERNEL);
+		if (!obj_event) {
+			err = -ENOMEM;
+			goto err_level2;
+		}
+
+		INIT_LIST_HEAD(&obj_event->obj_sub_list);
+		*alloc_obj_event = obj_event;
+	}
+
+	return 0;
+
+err_level2:
+	xa_erase(&event->object_ids, key_level2);
+
+err_level1:
+	if (new_entry_level1)
+		xa_erase(&devx_event_table->event_xa, key_level1);
+end:
+	if (new_entry_level1)
+		kfree(event);
+	return err;
+}
+
+static bool is_valid_events_legacy(int num_events, u16 *event_type_num_list,
+				   struct devx_obj *obj)
+{
+	int i;
+
+	for (i = 0; i < num_events; i++) {
+		if (obj) {
+			if (!is_legacy_obj_event_num(event_type_num_list[i]))
+				return false;
+		} else if (!is_legacy_unaffiliated_event_num(
+				event_type_num_list[i])) {
+			return false;
+		}
+	}
+
+	return true;
+}
+
+#define MAX_SUPP_EVENT_NUM 255
+static bool is_valid_events(struct mlx5_core_dev *dev,
+			    int num_events, u16 *event_type_num_list,
+			    struct devx_obj *obj)
+{
+	__be64 *aff_events;
+	__be64 *unaff_events;
+	int mask_entry;
+	int mask_bit;
+	int i;
+
+	if (MLX5_CAP_GEN(dev, event_cap)) {
+		aff_events = MLX5_CAP_DEV_EVENT(dev,
+						user_affiliated_events);
+		unaff_events = MLX5_CAP_DEV_EVENT(dev,
+						  user_unaffiliated_events);
+	} else {
+		return is_valid_events_legacy(num_events, event_type_num_list,
+					      obj);
+	}
+
+	for (i = 0; i < num_events; i++) {
+		if (event_type_num_list[i] > MAX_SUPP_EVENT_NUM)
+			return false;
+
+		mask_entry = event_type_num_list[i] / 64;
+		mask_bit = event_type_num_list[i] % 64;
+
+		if (obj) {
+			/* CQ completion */
+			if (event_type_num_list[i] == 0)
+				continue;
+
+			if (!(be64_to_cpu(aff_events[mask_entry]) &
+					(1ull << mask_bit)))
+				return false;
+
+			continue;
+		}
+
+		if (!(be64_to_cpu(unaff_events[mask_entry]) &
+				(1ull << mask_bit)))
+			return false;
+	}
+
+	return true;
+}
+
+#define MAX_NUM_EVENTS 16
+static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *devx_uobj = uverbs_attr_get_uobject(
+				attrs,
+				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_OBJ_HANDLE);
+	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
+		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
+	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct ib_uobject *fd_uobj;
+	struct devx_obj *obj = NULL;
+	struct devx_async_event_file *ev_file;
+	struct mlx5_devx_event_table *devx_event_table = &dev->devx_event_table;
+	u16 *event_type_num_list;
+	struct devx_event_subscription **event_sub_arr;
+	struct devx_obj_event  **event_obj_array_alloc;
+	int redirect_fd;
+	bool use_eventfd = false;
+	int num_events;
+	int num_alloc_xa_entries = 0;
+	u16 obj_type = 0;
+	u64 cookie = 0;
+	u32 obj_id = 0;
+	int err;
+	int i;
+
+	if (!c->devx_uid)
+		return -EINVAL;
+
+	if (!IS_ERR(devx_uobj)) {
+		obj = (struct devx_obj *)devx_uobj->object;
+		if (obj)
+			obj_id = get_dec_obj_id(obj->obj_id);
+	}
+
+	fd_uobj = uverbs_attr_get_uobject(attrs,
+				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_HANDLE);
+	if (IS_ERR(fd_uobj))
+		return PTR_ERR(fd_uobj);
+
+	ev_file = container_of(fd_uobj, struct devx_async_event_file,
+			       uobj);
+
+	if (uverbs_attr_is_valid(attrs,
+				 MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM)) {
+		err = uverbs_copy_from(&redirect_fd, attrs,
+			       MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM);
+		if (err)
+			return err;
+
+		use_eventfd = true;
+	}
+
+	if (uverbs_attr_is_valid(attrs,
+				 MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE)) {
+		if (use_eventfd)
+			return -EINVAL;
+
+		err = uverbs_copy_from(&cookie, attrs,
+				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE);
+		if (err)
+			return err;
+	}
+
+	num_events = uverbs_attr_ptr_get_array_size(
+		attrs, MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST,
+		sizeof(u16));
+
+	if (num_events < 0)
+		return num_events;
+
+	if (num_events > MAX_NUM_EVENTS)
+		return -EINVAL;
+
+	event_type_num_list = uverbs_attr_get_alloced_ptr(attrs,
+			MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST);
+
+	if (!is_valid_events(dev->mdev, num_events, event_type_num_list, obj))
+		return -EINVAL;
+
+	event_sub_arr = uverbs_zalloc(attrs,
+		MAX_NUM_EVENTS * sizeof(struct devx_event_subscription *));
+	event_obj_array_alloc = uverbs_zalloc(attrs,
+		MAX_NUM_EVENTS * sizeof(struct devx_obj_event *));
+
+	if (!event_sub_arr || !event_obj_array_alloc)
+		return -ENOMEM;
+
+	/* Protect from concurrent subscriptions to same XA entries to allow
+	 * both to succeed
+	 */
+	mutex_lock(&devx_event_table->event_xa_lock);
+	for (i = 0; i < num_events; i++) {
+		u32 key_level1;
+
+		if (obj)
+			obj_type = get_dec_obj_type(obj,
+						    event_type_num_list[i]);
+		key_level1 = event_type_num_list[i] | obj_type << 16;
+
+		err = subscribe_event_xa_alloc(devx_event_table,
+					       key_level1,
+					       obj ? true : false,
+					       obj_id,
+					       &event_obj_array_alloc[i]);
+		if (err)
+			goto err;
+
+		num_alloc_xa_entries++;
+		event_sub_arr[i] = kzalloc(sizeof(*event_sub_arr[i]),
+					   GFP_KERNEL);
+		if (!event_sub_arr[i])
+			goto err;
+
+		if (use_eventfd) {
+			event_sub_arr[i]->eventfd =
+				eventfd_ctx_fdget(redirect_fd);
+
+			if (IS_ERR(event_sub_arr[i]->eventfd)) {
+				err = PTR_ERR(event_sub_arr[i]->eventfd);
+				event_sub_arr[i]->eventfd = NULL;
+				goto err;
+			}
+		}
+
+		event_sub_arr[i]->cookie = cookie;
+		event_sub_arr[i]->fd_uobj = fd_uobj;
+		/* May be needed upon cleanup the devx object/subscription */
+		event_sub_arr[i]->xa_key_level1 = key_level1;
+		event_sub_arr[i]->xa_key_level2 = obj_id;
+		event_sub_arr[i]->is_obj_related = obj ? true : false;
+	}
+
+	/* Once all the allocations and the reservations for level 2
+	 * have been done we can go ahead and insert the data without any
+	 * concern of a failure.
+	 */
+	for (i = 0; i < num_events; i++) {
+		struct devx_event *event;
+		struct devx_obj_event  *obj_event;
+
+		spin_lock_irq(&ev_file->ev_queue.lock);
+		list_add_tail_rcu(&event_sub_arr[i]->file_list,
+				  &ev_file->subscribed_events_list);
+		spin_unlock_irq(&ev_file->ev_queue.lock);
+
+		event = xa_load(&devx_event_table->event_xa,
+				event_sub_arr[i]->xa_key_level1);
+		WARN_ON(!event);
+
+		if (!obj) {
+			list_add_tail_rcu(&event_sub_arr[i]->xa_list,
+					  &event->unaffiliated_list);
+			continue;
+		}
+
+		/* If was no entry prior calling this API need to insert
+		 * this XA key level 2 entry.
+		 */
+		if (event_obj_array_alloc[i]) {
+			err = xa_err(xa_store(&event->object_ids, obj_id,
+					      event_obj_array_alloc[i],
+					      GFP_KERNEL));
+			WARN_ON(err);
+		}
+
+		obj_event = xa_load(&event->object_ids, obj_id);
+		WARN_ON(!obj_event);
+		list_add_tail_rcu(&event_sub_arr[i]->xa_list,
+				  &obj_event->obj_sub_list);
+		list_add_tail_rcu(&event_sub_arr[i]->obj_list,
+				  &obj->event_sub);
+	}
+
+	mutex_unlock(&devx_event_table->event_xa_lock);
+	return 0;
+
+err:
+	for (i = 0; i < num_alloc_xa_entries; i++) {
+		subscribe_event_xa_dealloc(devx_event_table,
+					   event_sub_arr[i]->xa_key_level1,
+					   obj_id,
+					   event_obj_array_alloc[i]);
+
+		if (event_sub_arr[i]->eventfd)
+			eventfd_ctx_put(event_sub_arr[i]->eventfd);
+
+		kvfree(event_sub_arr[i]);
+	}
+
+	mutex_unlock(&devx_event_table->event_xa_lock);
+	return err;
+}
+
 static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
 			 struct uverbs_attr_bundle *attrs,
 			 struct devx_umem *obj)
@@ -1980,10 +2485,32 @@ DECLARE_UVERBS_NAMED_METHOD(
 		UVERBS_ATTR_TYPE(u64),
 		UA_MANDATORY));
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT,
+	UVERBS_ATTR_FD(MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_HANDLE,
+		MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD,
+		UVERBS_ACCESS_READ,
+		UA_MANDATORY),
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_OBJ_HANDLE,
+		MLX5_IB_OBJECT_DEVX_OBJ,
+		UVERBS_ACCESS_READ,
+		UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST,
+		UVERBS_ATTR_MIN_SIZE(sizeof(u16)),
+		UA_MANDATORY,
+		UA_ALLOC_AND_COPY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE,
+		UVERBS_ATTR_TYPE(u64),
+		UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM,
+		UVERBS_ATTR_TYPE(u32),
+		UA_OPTIONAL));
+
 DECLARE_UVERBS_GLOBAL_METHODS(MLX5_IB_OBJECT_DEVX,
 			      &UVERBS_METHOD(MLX5_IB_METHOD_DEVX_OTHER),
 			      &UVERBS_METHOD(MLX5_IB_METHOD_DEVX_QUERY_UAR),
-			      &UVERBS_METHOD(MLX5_IB_METHOD_DEVX_QUERY_EQN));
+			      &UVERBS_METHOD(MLX5_IB_METHOD_DEVX_QUERY_EQN),
+			      &UVERBS_METHOD(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT));
 
 DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_DEVX_OBJ,
 			    UVERBS_TYPE_ALLOC_IDR(devx_obj_cleanup),
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 6ad8f4f11ddd..d0da070cf0ab 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -51,6 +51,7 @@ enum mlx5_ib_devx_methods {
 	MLX5_IB_METHOD_DEVX_OTHER  = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_METHOD_DEVX_QUERY_UAR,
 	MLX5_IB_METHOD_DEVX_QUERY_EQN,
+	MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT,
 };
 
 enum  mlx5_ib_devx_other_attrs {
@@ -93,6 +94,14 @@ enum mlx5_ib_devx_obj_query_async_attrs {
 	MLX5_IB_ATTR_DEVX_OBJ_QUERY_ASYNC_OUT_LEN,
 };
 
+enum mlx5_ib_devx_subscribe_event_attrs {
+	MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_OBJ_HANDLE,
+	MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST,
+	MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM,
+	MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE,
+};
+
 enum  mlx5_ib_devx_query_eqn_attrs {
 	MLX5_IB_ATTR_DEVX_QUERY_EQN_USER_VEC = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_ATTR_DEVX_QUERY_EQN_DEV_EQN,
-- 
2.20.1

