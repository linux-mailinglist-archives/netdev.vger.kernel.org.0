Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1258134A20
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgAHSGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:15 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45121 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730099AbgAHSGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I65Np030044;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I652T022354;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I65cN022353;
        Wed, 8 Jan 2020 20:06:05 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 09/10] RDMA/core: Add the core support field to METHOD_GET_CONTEXT
Date:   Wed,  8 Jan 2020 20:05:39 +0200
Message-Id: <1578506740-22188-10-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Add the core support field to METHOD_GET_CONTEXT, this field should
represent capabilities that are not device-specific.

Return support for optional access flags for memory regions. User-space
will use this capability to mask the optional access flags for
unsupporting kernels.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
---
 drivers/infiniband/core/uverbs_std_types_device.c | 8 ++++++++
 include/uapi/rdma/ib_user_ioctl_cmds.h            | 1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h           | 4 ++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index 2c59435..ae4a59d 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -204,6 +204,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 	struct uverbs_attr_bundle *attrs)
 {
 	u32 num_comp = attrs->ufile->device->num_comp_vectors;
+	u64 core_support = IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS;
 	int ret;
 
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
@@ -211,6 +212,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 	if (IS_UVERBS_COPY_ERR(ret))
 		return ret;
 
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
+			     &core_support, sizeof(core_support));
+	if (IS_UVERBS_COPY_ERR(ret))
+		return ret;
+
 	ret = ib_alloc_ucontext(attrs);
 	if (ret)
 		return ret;
@@ -227,6 +233,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 	UVERBS_METHOD_GET_CONTEXT,
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
 			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
+			    UVERBS_ATTR_TYPE(u64), UA_OPTIONAL),
 	UVERBS_ATTR_UHW());
 
 DECLARE_UVERBS_NAMED_METHOD(
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index da6c63c..d4ddbe4 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -84,6 +84,7 @@ enum uverbs_attrs_query_port_cmd_attr_ids {
 
 enum uverbs_attrs_get_context_attr_ids {
 	UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
+	UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
 };
 
 enum uverbs_attrs_create_cq_cmd_attr_ids {
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 2a165f4..a640bb8 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -44,6 +44,10 @@
 #define IB_UVERBS_ACCESS_OPTIONAL_FIRST (1 << 20)
 #define IB_UVERBS_ACCESS_OPTIONAL_LAST (1 << 29)
 
+enum ib_uverbs_core_support {
+	IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS = 1 << 0,
+};
+
 enum ib_uverbs_access_flags {
 	IB_UVERBS_ACCESS_LOCAL_WRITE = 1 << 0,
 	IB_UVERBS_ACCESS_REMOTE_WRITE = 1 << 1,
-- 
1.8.3.1

