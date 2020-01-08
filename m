Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A5C134A19
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbgAHSGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:07 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45056 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730070AbgAHSGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I65nP030024;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I65tD022326;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I6557022325;
        Wed, 8 Jan 2020 20:06:05 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 03/10] RDMA/core: Remove ucontext_lock from the uverbs_destry_ufile_hw() path
Date:   Wed,  8 Jan 2020 20:05:33 +0200
Message-Id: <1578506740-22188-4-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

This lock only serializes ucontext creation. Instead of checking the
ucontext_lock during destruction hold the existing hw_destroy_rwsem
during creation, which is the standard pattern for object creation.

The simplification of locking is needed for the next patch.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/rdma_core.c  | 21 +--------------------
 drivers/infiniband/core/uverbs_cmd.c |  5 ++++-
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index f839b93..58af6a7 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -863,9 +863,7 @@ static int __uverbs_cleanup_ufile(struct ib_uverbs_file *ufile,
 }
 
 /*
- * Destroy the uncontext and every uobject associated with it. If called with
- * reason != RDMA_REMOVE_CLOSE this will not return until the destruction has
- * been completed and ufile->ucontext is NULL.
+ * Destroy the uncontext and every uobject associated with it.
  *
  * This is internally locked and can be called in parallel from multiple
  * contexts.
@@ -873,22 +871,6 @@ static int __uverbs_cleanup_ufile(struct ib_uverbs_file *ufile,
 void uverbs_destroy_ufile_hw(struct ib_uverbs_file *ufile,
 			     enum rdma_remove_reason reason)
 {
-	if (reason == RDMA_REMOVE_CLOSE) {
-		/*
-		 * During destruction we might trigger something that
-		 * synchronously calls release on any file descriptor. For
-		 * this reason all paths that come from file_operations
-		 * release must use try_lock. They can progress knowing that
-		 * there is an ongoing uverbs_destroy_ufile_hw that will clean
-		 * up the driver resources.
-		 */
-		if (!mutex_trylock(&ufile->ucontext_lock))
-			return;
-
-	} else {
-		mutex_lock(&ufile->ucontext_lock);
-	}
-
 	down_write(&ufile->hw_destroy_rwsem);
 
 	/*
@@ -917,7 +899,6 @@ void uverbs_destroy_ufile_hw(struct ib_uverbs_file *ufile,
 
 done:
 	up_write(&ufile->hw_destroy_rwsem);
-	mutex_unlock(&ufile->ucontext_lock);
 }
 
 const struct uverbs_obj_type_class uverbs_fd_class = {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 29b1b5a..d71ffe4 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -218,6 +218,8 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
 	if (ret)
 		return ret;
 
+	if (!down_read_trylock(&file->hw_destroy_rwsem))
+		return -EIO;
 	mutex_lock(&file->ucontext_lock);
 	ib_dev = srcu_dereference(file->device->ib_dev,
 				  &file->device->disassociate_srcu);
@@ -284,7 +286,7 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
 	smp_store_release(&file->ucontext, ucontext);
 
 	mutex_unlock(&file->ucontext_lock);
-
+	up_read(&file->hw_destroy_rwsem);
 	return 0;
 
 err_uobj:
@@ -298,6 +300,7 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
 
 err:
 	mutex_unlock(&file->ucontext_lock);
+	up_read(&file->hw_destroy_rwsem);
 	return ret;
 }
 
-- 
1.8.3.1

