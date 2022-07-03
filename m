Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81615649CE
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 22:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiGCUyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 16:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiGCUyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 16:54:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9829A5597;
        Sun,  3 Jul 2022 13:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2373B80CD3;
        Sun,  3 Jul 2022 20:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C70C341C6;
        Sun,  3 Jul 2022 20:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656881666;
        bh=v1upxO6OKCZzmpinjkQuyX4DQQrtVyRo7txDCM4xESw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR/io81qhuNJPZQATE8HdA9aR2NuTzkJqPIWG75UFNOVqQGmVcRBJPvX/QYkG3iio
         S46yOVUBF93P21x5j451uvwGQVl0Ld62UfxZuUoxzRirlW3rQWc12tCuSicW4OemYi
         HcHaL4EfOvKIY2tRdfELhcOQi63iatlL44xfFMgAjVZDmxQr+8KGjnNTzDRzf5hX38
         nHWgas28iYPoeMwjXbEQendbMe/B3GdUuvYsrUNz5Ujdh883vlW9/ygIyUSTPGk0pc
         WPoJBjzlfl/E1ZbXMTl0Vfc9XpS/vGTuRQx8UE0YxtYNw0DxHcyCq+4QkRxyZ+bjSE
         bhdfhIqrgrWsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 5/5] RDMA/mlx5: Expose steering anchor to userspace
Date:   Sun,  3 Jul 2022 13:54:07 -0700
Message-Id: <20220703205407.110890-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220703205407.110890-1-saeed@kernel.org>
References: <20220703205407.110890-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Expose a steering anchor per priority to allow users to re-inject
packets back into default NIC pipeline for additional processing.

MLX5_IB_METHOD_STEERING_ANCHOR_CREATE returns a flow table ID which
a user can use to re-inject packets at a specific priority.

A FTE (flow table entry) can be created and the flow table ID
used as a destination.

When a packet is taken into a RDMA-controlled steering domain (like
software steering) there may be a need to insert the packet back into
the default NIC pipeline. This exposes a flow table ID to the user that can
be used as a destination in a flow table entry.

With this new method priorities that are exposed to users via
MLX5_IB_METHOD_FLOW_MATCHER_CREATE can be reached from a non-zero UID.

As user-created flow tables (via RDMA DEVX) are created with a non-zero UID
thus it's impossible to point to a NIC core flow table (core driver flow tables
are created with UID value of zero) from userspace.
Create flow tables that are exposed to users with the shared UID, this
allows users to point to default NIC flow tables.

Steering loops are prevented at FW level as FW enforces that no flow
table at level X can point to a table at level lower than X.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c          | 138 ++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |   6 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  17 +++
 3 files changed, 156 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index b1402aea29c1..691d00c89f33 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -679,7 +679,15 @@ enum flow_table_type {
 #define MLX5_FS_MAX_TYPES	 6
 #define MLX5_FS_MAX_ENTRIES	 BIT(16)
 
-static struct mlx5_ib_flow_prio *_get_prio(struct mlx5_flow_namespace *ns,
+static bool mlx5_ib_shared_ft_allowed(struct ib_device *device)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+
+	return MLX5_CAP_GEN(dev->mdev, shared_object_to_user_object_allowed);
+}
+
+static struct mlx5_ib_flow_prio *_get_prio(struct mlx5_ib_dev *dev,
+					   struct mlx5_flow_namespace *ns,
 					   struct mlx5_ib_flow_prio *prio,
 					   int priority,
 					   int num_entries, int num_groups,
@@ -688,6 +696,8 @@ static struct mlx5_ib_flow_prio *_get_prio(struct mlx5_flow_namespace *ns,
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *ft;
 
+	if (mlx5_ib_shared_ft_allowed(&dev->ib_dev))
+		ft_attr.uid = MLX5_SHARED_RESOURCE_UID;
 	ft_attr.prio = priority;
 	ft_attr.max_fte = num_entries;
 	ft_attr.flags = flags;
@@ -784,8 +794,8 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 
 	ft = prio->flow_table;
 	if (!ft)
-		return _get_prio(ns, prio, priority, max_table_size, num_groups,
-				 flags);
+		return _get_prio(dev, ns, prio, priority, max_table_size,
+				 num_groups, flags);
 
 	return prio;
 }
@@ -927,7 +937,7 @@ int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, u32 port_num,
 
 	prio = &dev->flow_db->opfcs[type];
 	if (!prio->flow_table) {
-		prio = _get_prio(ns, prio, priority,
+		prio = _get_prio(dev, ns, prio, priority,
 				 dev->num_ports * MAX_OPFC_RULES, 1, 0);
 		if (IS_ERR(prio)) {
 			err = PTR_ERR(prio);
@@ -1499,7 +1509,7 @@ _get_flow_table(struct mlx5_ib_dev *dev, u16 user_priority,
 	if (prio->flow_table)
 		return prio;
 
-	return _get_prio(ns, prio, priority, max_table_size,
+	return _get_prio(dev, ns, prio, priority, max_table_size,
 			 MLX5_FS_MAX_TYPES, flags);
 }
 
@@ -2016,6 +2026,23 @@ static int flow_matcher_cleanup(struct ib_uobject *uobject,
 	return 0;
 }
 
+static int steering_anchor_cleanup(struct ib_uobject *uobject,
+				   enum rdma_remove_reason why,
+				   struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_steering_anchor *obj = uobject->object;
+
+	if (atomic_read(&obj->usecnt))
+		return -EBUSY;
+
+	mutex_lock(&obj->dev->flow_db->lock);
+	put_flow_table(obj->dev, obj->ft_prio, true);
+	mutex_unlock(&obj->dev->flow_db->lock);
+
+	kfree(obj);
+	return 0;
+}
+
 static int mlx5_ib_matcher_ns(struct uverbs_attr_bundle *attrs,
 			      struct mlx5_ib_flow_matcher *obj)
 {
@@ -2122,6 +2149,75 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	return err;
 }
 
+static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(
+		attrs, MLX5_IB_ATTR_STEERING_ANCHOR_CREATE_HANDLE);
+	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	enum mlx5_ib_uapi_flow_table_type ib_uapi_ft_type;
+	enum mlx5_flow_namespace_type ns_type;
+	struct mlx5_ib_steering_anchor *obj;
+	struct mlx5_ib_flow_prio *ft_prio;
+	u16 priority;
+	u32 ft_id;
+	int err;
+
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
+	err = uverbs_get_const(&ib_uapi_ft_type, attrs,
+			       MLX5_IB_ATTR_STEERING_ANCHOR_FT_TYPE);
+	if (err)
+		return err;
+
+	err = mlx5_ib_ft_type_to_namespace(ib_uapi_ft_type, &ns_type);
+	if (err)
+		return err;
+
+	err = uverbs_copy_from(&priority, attrs,
+			       MLX5_IB_ATTR_STEERING_ANCHOR_PRIORITY);
+	if (err)
+		return err;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	mutex_lock(&dev->flow_db->lock);
+	ft_prio = _get_flow_table(dev, priority, ns_type, 0);
+	if (IS_ERR(ft_prio)) {
+		mutex_unlock(&dev->flow_db->lock);
+		err = PTR_ERR(ft_prio);
+		goto free_obj;
+	}
+
+	ft_prio->refcount++;
+	ft_id = mlx5_flow_table_id(ft_prio->flow_table);
+	mutex_unlock(&dev->flow_db->lock);
+
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_STEERING_ANCHOR_FT_ID,
+			     &ft_id, sizeof(ft_id));
+	if (err)
+		goto put_flow_table;
+
+	uobj->object = obj;
+	obj->dev = dev;
+	obj->ft_prio = ft_prio;
+	atomic_set(&obj->usecnt, 0);
+
+	return 0;
+
+put_flow_table:
+	mutex_lock(&dev->flow_db->lock);
+	put_flow_table(dev, ft_prio, true);
+	mutex_unlock(&dev->flow_db->lock);
+free_obj:
+	kfree(obj);
+
+	return err;
+}
+
 static struct ib_flow_action *
 mlx5_ib_create_modify_header(struct mlx5_ib_dev *dev,
 			     enum mlx5_ib_uapi_flow_table_type ft_type,
@@ -2478,6 +2574,35 @@ DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER,
 			    &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_CREATE),
 			    &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_DESTROY));
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_STEERING_ANCHOR_CREATE,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_STEERING_ANCHOR_CREATE_HANDLE,
+			MLX5_IB_OBJECT_STEERING_ANCHOR,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_STEERING_ANCHOR_FT_TYPE,
+			     enum mlx5_ib_uapi_flow_table_type,
+			     UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_STEERING_ANCHOR_PRIORITY,
+			   UVERBS_ATTR_TYPE(u16),
+			   UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_STEERING_ANCHOR_FT_ID,
+			   UVERBS_ATTR_TYPE(u32),
+			   UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
+	MLX5_IB_METHOD_STEERING_ANCHOR_DESTROY,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_STEERING_ANCHOR_DESTROY_HANDLE,
+			MLX5_IB_OBJECT_STEERING_ANCHOR,
+			UVERBS_ACCESS_DESTROY,
+			UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(
+	MLX5_IB_OBJECT_STEERING_ANCHOR,
+	UVERBS_TYPE_ALLOC_IDR(steering_anchor_cleanup),
+	&UVERBS_METHOD(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE),
+	&UVERBS_METHOD(MLX5_IB_METHOD_STEERING_ANCHOR_DESTROY));
+
 const struct uapi_definition mlx5_ib_flow_defs[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(
 		MLX5_IB_OBJECT_FLOW_MATCHER),
@@ -2486,6 +2611,9 @@ const struct uapi_definition mlx5_ib_flow_defs[] = {
 		&mlx5_ib_fs),
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_FLOW_ACTION,
 				&mlx5_ib_flow_actions),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(
+		MLX5_IB_OBJECT_STEERING_ANCHOR,
+		UAPI_DEF_IS_OBJ_SUPPORTED(mlx5_ib_shared_ft_allowed)),
 	{},
 };
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 998b67509a53..c067db25fadd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -259,6 +259,12 @@ struct mlx5_ib_flow_matcher {
 	u8			match_criteria_enable;
 };
 
+struct mlx5_ib_steering_anchor {
+	struct mlx5_ib_flow_prio *ft_prio;
+	struct mlx5_ib_dev *dev;
+	atomic_t usecnt;
+};
+
 struct mlx5_ib_pp {
 	u16 index;
 	struct mlx5_core_dev *mdev;
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index e539c84d63f1..3bee490eb585 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -228,6 +228,7 @@ enum mlx5_ib_objects {
 	MLX5_IB_OBJECT_VAR,
 	MLX5_IB_OBJECT_PP,
 	MLX5_IB_OBJECT_UAR,
+	MLX5_IB_OBJECT_STEERING_ANCHOR,
 };
 
 enum mlx5_ib_flow_matcher_create_attrs {
@@ -248,6 +249,22 @@ enum mlx5_ib_flow_matcher_methods {
 	MLX5_IB_METHOD_FLOW_MATCHER_DESTROY,
 };
 
+enum mlx5_ib_flow_steering_anchor_create_attrs {
+	MLX5_IB_ATTR_STEERING_ANCHOR_CREATE_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_STEERING_ANCHOR_FT_TYPE,
+	MLX5_IB_ATTR_STEERING_ANCHOR_PRIORITY,
+	MLX5_IB_ATTR_STEERING_ANCHOR_FT_ID,
+};
+
+enum mlx5_ib_flow_steering_anchor_destroy_attrs {
+	MLX5_IB_ATTR_STEERING_ANCHOR_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum mlx5_ib_steering_anchor_methods {
+	MLX5_IB_METHOD_STEERING_ANCHOR_CREATE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_METHOD_STEERING_ANCHOR_DESTROY,
+};
+
 enum mlx5_ib_device_query_context_attrs {
 	MLX5_IB_ATTR_QUERY_CONTEXT_RESP_UCTX = (1U << UVERBS_ID_NS_SHIFT),
 };
-- 
2.36.1

