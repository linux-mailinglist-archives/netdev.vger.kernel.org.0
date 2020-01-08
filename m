Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62293134A2A
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgAHSGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:07 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45049 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728905AbgAHSGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I65pn030021;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I64eC022322;
        Wed, 8 Jan 2020 20:06:04 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I643O022321;
        Wed, 8 Jan 2020 20:06:04 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 02/10] RDMA/core: Add UVERBS_METHOD_ASYNC_EVENT_ALLOC
Date:   Wed,  8 Jan 2020 20:05:32 +0200
Message-Id: <1578506740-22188-3-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Allow the async FD to be allocated separately from the context.

This is necessary to introduce the ioctl to create a context, as an ioctl
should only ever create a single uobject at a time.

If multiple async FDs are created then the first one is used to deliver
affiliated events from any ib_uevent_object, with all subsequent ones will
receive only unaffiliated events.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/uverbs_main.c              |  4 +++-
 .../infiniband/core/uverbs_std_types_async_fd.c    | 23 +++++++++++++++++++++-
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  8 ++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 1f279b0a..fb9e752 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -475,7 +475,9 @@ void ib_uverbs_init_async_event_file(
 
 	ib_uverbs_init_event_queue(&async_file->ev_queue);
 
-	if (!WARN_ON(uverbs_file->async_file)) {
+	/* The first async_event_file becomes the default one for the file. */
+	lockdep_assert_held(&uverbs_file->ucontext_lock);
+	if (!uverbs_file->async_file) {
 		/* Pairs with the put in ib_uverbs_release_file */
 		uverbs_uobject_get(&async_file->uobj);
 		smp_store_release(&uverbs_file->async_file, async_file);
diff --git a/drivers/infiniband/core/uverbs_std_types_async_fd.c b/drivers/infiniband/core/uverbs_std_types_async_fd.c
index 31ff968..484dba1 100644
--- a/drivers/infiniband/core/uverbs_std_types_async_fd.c
+++ b/drivers/infiniband/core/uverbs_std_types_async_fd.c
@@ -8,6 +8,19 @@
 #include "rdma_core.h"
 #include "uverbs.h"
 
+static int UVERBS_HANDLER(UVERBS_METHOD_ASYNC_EVENT_ALLOC)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj =
+		uverbs_attr_get_uobject(attrs, UVERBS_METHOD_ASYNC_EVENT_ALLOC);
+
+	mutex_lock(&attrs->ufile->ucontext_lock);
+	ib_uverbs_init_async_event_file(
+		container_of(uobj, struct ib_uverbs_async_event_file, uobj));
+	mutex_unlock(&attrs->ufile->ucontext_lock);
+	return 0;
+}
+
 static int uverbs_async_event_destroy_uobj(struct ib_uobject *uobj,
 					   enum rdma_remove_reason why)
 {
@@ -19,13 +32,21 @@ static int uverbs_async_event_destroy_uobj(struct ib_uobject *uobj,
 	return 0;
 }
 
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_ASYNC_EVENT_ALLOC,
+	UVERBS_ATTR_FD(UVERBS_ATTR_ASYNC_EVENT_ALLOC_FD_HANDLE,
+		       UVERBS_OBJECT_ASYNC_EVENT,
+		       UVERBS_ACCESS_NEW,
+		       UA_MANDATORY));
+
 DECLARE_UVERBS_NAMED_OBJECT(
 	UVERBS_OBJECT_ASYNC_EVENT,
 	UVERBS_TYPE_ALLOC_FD(sizeof(struct ib_uverbs_async_event_file),
 			     uverbs_async_event_destroy_uobj,
 			     &uverbs_async_event_fops,
 			     "[infinibandevent]",
-			     O_RDONLY));
+			     O_RDONLY),
+	&UVERBS_METHOD(UVERBS_METHOD_ASYNC_EVENT_ALLOC));
 
 const struct uapi_definition uverbs_def_obj_async_fd[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_ASYNC_EVENT),
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 9cfadb5..498955c 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -242,4 +242,12 @@ enum uverbs_attrs_flow_destroy_ids {
 	UVERBS_ATTR_DESTROY_FLOW_HANDLE,
 };
 
+enum uverbs_method_async_event {
+	UVERBS_METHOD_ASYNC_EVENT_ALLOC,
+};
+
+enum uverbs_attrs_async_event_create {
+	UVERBS_ATTR_ASYNC_EVENT_ALLOC_FD_HANDLE,
+};
+
 #endif
-- 
1.8.3.1

