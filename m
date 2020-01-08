Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6816134A22
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgAHSGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:20 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45087 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728971AbgAHSGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I65kH030027;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I657r022330;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I65eZ022329;
        Wed, 8 Jan 2020 20:06:05 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 04/10] RDMA/uverbs: Add ioctl command to get a device context
Date:   Wed,  8 Jan 2020 20:05:34 +0200
Message-Id: <1578506740-22188-5-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Allow future extensions of the get context command through the uverbs
ioctl kabi.

Unlike the uverbs version this does not return an async_fd as well,
that has to be done with another command.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/uverbs.h                   |   3 +
 drivers/infiniband/core/uverbs_cmd.c               | 132 ++++++++++++---------
 drivers/infiniband/core/uverbs_main.c              |   9 +-
 .../infiniband/core/uverbs_std_types_async_fd.c    |   2 -
 drivers/infiniband/core/uverbs_std_types_device.c  |  30 +++++
 include/uapi/rdma/ib_user_ioctl_cmds.h             |   5 +
 6 files changed, 119 insertions(+), 62 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index aaa5c75..4d4cec4 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -220,6 +220,9 @@ struct ib_ucq_object {
 void ib_uverbs_free_event_queue(struct ib_uverbs_event_queue *event_queue);
 void ib_uverbs_flow_resources_free(struct ib_uflow_resources *uflow_res);
 
+int ib_alloc_ucontext(struct uverbs_attr_bundle *attrs);
+int ib_init_ucontext(struct uverbs_attr_bundle *attrs);
+
 void ib_uverbs_release_ucq(struct ib_uverbs_completion_event_file *ev_file,
 			   struct ib_ucq_object *uobj);
 void ib_uverbs_release_uevent(struct ib_uevent_object *uobj);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d71ffe4..c8693f5 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -203,104 +203,118 @@ struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
 #define ib_uverbs_lookup_comp_file(_fd, _ufile)                                \
 	_ib_uverbs_lookup_comp_file((_fd)*typecheck(s32, _fd), _ufile)
 
-static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
+int ib_alloc_ucontext(struct uverbs_attr_bundle *attrs)
 {
-	struct ib_uverbs_file *file = attrs->ufile;
-	struct ib_uverbs_get_context      cmd;
-	struct ib_uverbs_get_context_resp resp;
-	struct ib_ucontext		 *ucontext;
-	struct ib_rdmacg_object		 cg_obj;
+	struct ib_uverbs_file *ufile = attrs->ufile;
+	struct ib_ucontext *ucontext;
 	struct ib_device *ib_dev;
-	struct ib_uobject *uobj;
-	int ret;
 
-	ret = uverbs_request(attrs, &cmd, sizeof(cmd));
-	if (ret)
-		return ret;
+	ib_dev = srcu_dereference(ufile->device->ib_dev,
+				  &ufile->device->disassociate_srcu);
+	if (!ib_dev)
+		return -EIO;
+
+	ucontext = rdma_zalloc_drv_obj(ib_dev, ib_ucontext);
+	if (!ucontext)
+		return -ENOMEM;
+
+	ucontext->res.type = RDMA_RESTRACK_CTX;
+	ucontext->device = ib_dev;
+	ucontext->ufile = ufile;
+	xa_init_flags(&ucontext->mmap_xa, XA_FLAGS_ALLOC);
+	attrs->context = ucontext;
+	return 0;
+}
+
+int ib_init_ucontext(struct uverbs_attr_bundle *attrs)
+{
+	struct ib_ucontext *ucontext = attrs->context;
+	struct ib_uverbs_file *file = attrs->ufile;
+	int ret;
 
 	if (!down_read_trylock(&file->hw_destroy_rwsem))
 		return -EIO;
 	mutex_lock(&file->ucontext_lock);
-	ib_dev = srcu_dereference(file->device->ib_dev,
-				  &file->device->disassociate_srcu);
-	if (!ib_dev) {
-		ret = -EIO;
-		goto err;
-	}
-
 	if (file->ucontext) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	ret = ib_rdmacg_try_charge(&cg_obj, ib_dev, RDMACG_RESOURCE_HCA_HANDLE);
+	ret = ib_rdmacg_try_charge(&ucontext->cg_obj, ucontext->device,
+				   RDMACG_RESOURCE_HCA_HANDLE);
 	if (ret)
 		goto err;
 
-	ucontext = rdma_zalloc_drv_obj(ib_dev, ib_ucontext);
-	if (!ucontext) {
-		ret = -ENOMEM;
-		goto err_alloc;
-	}
+	ret = ucontext->device->ops.alloc_ucontext(ucontext,
+						   &attrs->driver_udata);
+	if (ret)
+		goto err_uncharge;
 
-	attrs->context = ucontext;
+	rdma_restrack_uadd(&ucontext->res);
 
-	ucontext->res.type = RDMA_RESTRACK_CTX;
-	ucontext->device = ib_dev;
-	ucontext->cg_obj = cg_obj;
-	/* ufile is required when some objects are released */
-	ucontext->ufile = file;
+	/*
+	 * Make sure that ib_uverbs_get_ucontext() sees the pointer update
+	 * only after all writes to setup the ucontext have completed
+	 */
+	smp_store_release(&file->ucontext, ucontext);
+
+	mutex_unlock(&file->ucontext_lock);
+	up_read(&file->hw_destroy_rwsem);
+	return 0;
 
-	ucontext->closing = false;
-	ucontext->cleanup_retryable = false;
+err_uncharge:
+	ib_rdmacg_uncharge(&ucontext->cg_obj, ucontext->device,
+			   RDMACG_RESOURCE_HCA_HANDLE);
+err:
+	mutex_unlock(&file->ucontext_lock);
+	up_read(&file->hw_destroy_rwsem);
+	return ret;
+}
 
-	xa_init_flags(&ucontext->mmap_xa, XA_FLAGS_ALLOC);
+static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uverbs_get_context_resp resp;
+	struct ib_uverbs_get_context cmd;
+	struct ib_device *ib_dev;
+	struct ib_uobject *uobj;
+	int ret;
+
+	ret = uverbs_request(attrs, &cmd, sizeof(cmd));
+	if (ret)
+		return ret;
+
+	ret = ib_alloc_ucontext(attrs);
+	if (ret)
+		return ret;
 
 	uobj = uobj_alloc(UVERBS_OBJECT_ASYNC_EVENT, attrs, &ib_dev);
 	if (IS_ERR(uobj)) {
 		ret = PTR_ERR(uobj);
-		goto err_free;
+		goto err_ucontext;
 	}
 
-	resp.async_fd = uobj->id;
-	resp.num_comp_vectors = file->device->num_comp_vectors;
-
+	resp = (struct ib_uverbs_get_context_resp){
+		.num_comp_vectors = attrs->ufile->device->num_comp_vectors,
+		.async_fd = uobj->id,
+	};
 	ret = uverbs_response(attrs, &resp, sizeof(resp));
 	if (ret)
 		goto err_uobj;
 
-	ret = ib_dev->ops.alloc_ucontext(ucontext, &attrs->driver_udata);
+	ret = ib_init_ucontext(attrs);
 	if (ret)
 		goto err_uobj;
 
-	rdma_restrack_uadd(&ucontext->res);
-
 	ib_uverbs_init_async_event_file(
 		container_of(uobj, struct ib_uverbs_async_event_file, uobj));
 	rdma_alloc_commit_uobject(uobj, attrs);
-
-	/*
-	 * Make sure that ib_uverbs_get_ucontext() sees the pointer update
-	 * only after all writes to setup the ucontext have completed
-	 */
-	smp_store_release(&file->ucontext, ucontext);
-
-	mutex_unlock(&file->ucontext_lock);
-	up_read(&file->hw_destroy_rwsem);
 	return 0;
 
 err_uobj:
 	rdma_alloc_abort_uobject(uobj, attrs);
-
-err_free:
-	kfree(ucontext);
-
-err_alloc:
-	ib_rdmacg_uncharge(&cg_obj, ib_dev, RDMACG_RESOURCE_HCA_HANDLE);
-
-err:
-	mutex_unlock(&file->ucontext_lock);
-	up_read(&file->hw_destroy_rwsem);
+err_ucontext:
+	kfree(attrs->context);
+	attrs->context = NULL;
 	return ret;
 }
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index fb9e752..2d4083b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -150,6 +150,9 @@ void ib_uverbs_release_uevent(struct ib_uevent_object *uobj)
 		READ_ONCE(uobj->uobject.ufile->async_file);
 	struct ib_uverbs_event *evt, *tmp;
 
+	if (!async_file)
+		return;
+
 	spin_lock_irq(&async_file->ev_queue.lock);
 	list_for_each_entry_safe(evt, tmp, &uobj->event_list, obj_list) {
 		list_del(&evt->list);
@@ -391,6 +394,9 @@ void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context)
 	struct ib_uverbs_event *entry;
 	unsigned long flags;
 
+	if (!async_file)
+		return;
+
 	spin_lock_irqsave(&async_file->ev_queue.lock, flags);
 	if (async_file->ev_queue.is_closed) {
 		spin_unlock_irqrestore(&async_file->ev_queue.lock, flags);
@@ -476,12 +482,13 @@ void ib_uverbs_init_async_event_file(
 	ib_uverbs_init_event_queue(&async_file->ev_queue);
 
 	/* The first async_event_file becomes the default one for the file. */
-	lockdep_assert_held(&uverbs_file->ucontext_lock);
+	mutex_lock(&uverbs_file->ucontext_lock);
 	if (!uverbs_file->async_file) {
 		/* Pairs with the put in ib_uverbs_release_file */
 		uverbs_uobject_get(&async_file->uobj);
 		smp_store_release(&uverbs_file->async_file, async_file);
 	}
+	mutex_unlock(&uverbs_file->ucontext_lock);
 
 	INIT_IB_EVENT_HANDLER(&async_file->event_handler, ib_dev,
 			      ib_uverbs_event_handler);
diff --git a/drivers/infiniband/core/uverbs_std_types_async_fd.c b/drivers/infiniband/core/uverbs_std_types_async_fd.c
index 484dba1..82ec080 100644
--- a/drivers/infiniband/core/uverbs_std_types_async_fd.c
+++ b/drivers/infiniband/core/uverbs_std_types_async_fd.c
@@ -14,10 +14,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_ASYNC_EVENT_ALLOC)(
 	struct ib_uobject *uobj =
 		uverbs_attr_get_uobject(attrs, UVERBS_METHOD_ASYNC_EVENT_ALLOC);
 
-	mutex_lock(&attrs->ufile->ucontext_lock);
 	ib_uverbs_init_async_event_file(
 		container_of(uobj, struct ib_uverbs_async_event_file, uobj));
-	mutex_unlock(&attrs->ufile->ucontext_lock);
 	return 0;
 }
 
diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index 2a3f2f0..2c59435 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -200,6 +200,35 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_PORT)(
 					     &resp, sizeof(resp));
 }
 
+static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
+	struct uverbs_attr_bundle *attrs)
+{
+	u32 num_comp = attrs->ufile->device->num_comp_vectors;
+	int ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
+			     &num_comp, sizeof(num_comp));
+	if (IS_UVERBS_COPY_ERR(ret))
+		return ret;
+
+	ret = ib_alloc_ucontext(attrs);
+	if (ret)
+		return ret;
+	ret = ib_init_ucontext(attrs);
+	if (ret) {
+		kfree(attrs->context);
+		attrs->context = NULL;
+		return ret;
+	}
+	return 0;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_GET_CONTEXT,
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
+			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL),
+	UVERBS_ATTR_UHW());
+
 DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_METHOD_INFO_HANDLES,
 	/* Also includes any device specific object ids */
@@ -220,6 +249,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_PORT)(
 		UA_MANDATORY));
 
 DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DEVICE,
+			      &UVERBS_METHOD(UVERBS_METHOD_GET_CONTEXT),
 			      &UVERBS_METHOD(UVERBS_METHOD_INVOKE_WRITE),
 			      &UVERBS_METHOD(UVERBS_METHOD_INFO_HANDLES),
 			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_PORT));
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 498955c..da6c63c 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -68,6 +68,7 @@ enum uverbs_methods_device {
 	UVERBS_METHOD_INVOKE_WRITE,
 	UVERBS_METHOD_INFO_HANDLES,
 	UVERBS_METHOD_QUERY_PORT,
+	UVERBS_METHOD_GET_CONTEXT,
 };
 
 enum uverbs_attrs_invoke_write_cmd_attr_ids {
@@ -81,6 +82,10 @@ enum uverbs_attrs_query_port_cmd_attr_ids {
 	UVERBS_ATTR_QUERY_PORT_RESP,
 };
 
+enum uverbs_attrs_get_context_attr_ids {
+	UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
+};
+
 enum uverbs_attrs_create_cq_cmd_attr_ids {
 	UVERBS_ATTR_CREATE_CQ_HANDLE,
 	UVERBS_ATTR_CREATE_CQ_CQE,
-- 
1.8.3.1

