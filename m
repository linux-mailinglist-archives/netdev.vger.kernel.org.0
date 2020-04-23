Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A941B5BE2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgDWM4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:14 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57462 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728524AbgDWM4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:11 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw20003234;
        Thu, 23 Apr 2020 15:55:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 10/16] RDMA: Group create AH arguments in struct
Date:   Thu, 23 Apr 2020 15:55:49 +0300
Message-Id: <20200423125555.21759-11-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following patch adds additional argument to the create AH function,
so it make sense to group the attribute arguments in struct.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 drivers/infiniband/core/verbs.c          |  6 +++++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 11 ++++++-----
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  3 +--
 drivers/infiniband/hw/mlx4/ah.c          | 10 ++++++----
 drivers/infiniband/hw/mlx4/mlx4_ib.h     |  3 +--
 drivers/infiniband/hw/mlx5/ah.c          |  5 +++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  3 +--
 drivers/infiniband/sw/rxe/rxe_verbs.c    |  8 ++++----
 include/rdma/ib_verbs.h                  |  9 +++++++--
 9 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3bfadd8effcc..1ea69d730492 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -502,6 +502,7 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 				     u32 flags,
 				     struct ib_udata *udata)
 {
+	struct rdma_ah_init_attr init_attr = {};
 	struct ib_device *device = pd->device;
 	struct ib_ah *ah;
 	int ret;
@@ -521,8 +522,11 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 	ah->pd = pd;
 	ah->type = ah_attr->type;
 	ah->sgid_attr = rdma_update_sgid_attr(ah_attr, NULL);
+	init_attr.ah_attr = ah_attr;
+	init_attr.flags = flags;
+	init_attr.udata = udata;
 
-	ret = device->ops.create_ah(ah, ah_attr, flags, udata);
+	ret = device->ops.create_ah(ah, &init_attr);
 	if (ret) {
 		kfree(ah);
 		return ERR_PTR(ret);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index d98348e82422..ebd0da87dbee 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -631,11 +631,11 @@ static u8 bnxt_re_stack_to_dev_nw_type(enum rdma_network_type ntype)
 	return nw_type;
 }
 
-int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
-		      u32 flags, struct ib_udata *udata)
+int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr)
 {
 	struct ib_pd *ib_pd = ib_ah->pd;
 	struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
 	struct bnxt_re_dev *rdev = pd->rdev;
 	const struct ib_gid_attr *sgid_attr;
@@ -673,16 +673,17 @@ int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
 
 	memcpy(ah->qplib_ah.dmac, ah_attr->roce.dmac, ETH_ALEN);
 	rc = bnxt_qplib_create_ah(&rdev->qplib_res, &ah->qplib_ah,
-				  !(flags & RDMA_CREATE_AH_SLEEPABLE));
+				  !(init_attr->flags &
+				    RDMA_CREATE_AH_SLEEPABLE));
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to allocate HW AH");
 		return rc;
 	}
 
 	/* Write AVID to shared page. */
-	if (udata) {
+	if (init_attr->udata) {
 		struct bnxt_re_ucontext *uctx = rdma_udata_to_drv_context(
-			udata, struct bnxt_re_ucontext, ib_uctx);
+			init_attr->udata, struct bnxt_re_ucontext, ib_uctx);
 		unsigned long flag;
 		u32 *wrptr;
 
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 18dd46f46cf4..91729e7cd5a6 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -170,8 +170,7 @@ enum rdma_link_layer bnxt_re_get_link_layer(struct ib_device *ibdev,
 					    u8 port_num);
 int bnxt_re_alloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 void bnxt_re_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
-int bnxt_re_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
-		      struct ib_udata *udata);
+int bnxt_re_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr);
 int bnxt_re_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 int bnxt_re_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 void bnxt_re_destroy_ah(struct ib_ah *ah, u32 flags);
diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 02a169f8027b..f98b14c7057d 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -141,10 +141,10 @@ static int create_iboe_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
 	return 0;
 }
 
-int mlx4_ib_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
-		      u32 flags, struct ib_udata *udata)
-
+int mlx4_ib_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr)
 {
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
+
 	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
 		if (!(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH))
 			return -EINVAL;
@@ -167,12 +167,14 @@ int mlx4_ib_create_ah_slave(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
 			    int slave_sgid_index, u8 *s_mac, u16 vlan_tag)
 {
 	struct rdma_ah_attr slave_attr = *ah_attr;
+	struct rdma_ah_init_attr init_attr = {};
 	struct mlx4_ib_ah *mah = to_mah(ah);
 	int ret;
 
 	slave_attr.grh.sgid_attr = NULL;
 	slave_attr.grh.sgid_index = slave_sgid_index;
-	ret = mlx4_ib_create_ah(ah, &slave_attr, 0, NULL);
+	init_attr.ah_attr = &slave_attr;
+	ret = mlx4_ib_create_ah(ah, &init_attr);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index d188573187fa..ee24993dcfd8 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -752,8 +752,7 @@ int mlx4_ib_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
 void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 void mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 
-int mlx4_ib_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
-		      struct ib_udata *udata);
+int mlx4_ib_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr);
 int mlx4_ib_create_ah_slave(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
 			    int slave_sgid_index, u8 *s_mac, u16 vlan_tag);
 int mlx4_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 80642dd359bc..b3a3df51c44a 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -68,10 +68,11 @@ static void create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
 	}
 }
 
-int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
-		      u32 flags, struct ib_udata *udata)
+int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr)
 
 {
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
+	struct ib_udata *udata = init_attr->udata;
 	struct mlx5_ib_ah *ah = to_mah(ibah);
 	struct mlx5_ib_dev *dev = to_mdev(ibah->device);
 	enum rdma_ah_attr_type ah_type = ah_attr->type;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a4e522385de0..a041a1357a13 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1180,8 +1180,7 @@ void mlx5_ib_db_unmap_user(struct mlx5_ib_ucontext *context, struct mlx5_db *db)
 void __mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq);
 void mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq);
 void mlx5_ib_free_srq_wqe(struct mlx5_ib_srq *srq, int wqe_index);
-int mlx5_ib_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
-		      struct ib_udata *udata);
+int mlx5_ib_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr);
 int mlx5_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
 void mlx5_ib_destroy_ah(struct ib_ah *ah, u32 flags);
 int mlx5_ib_create_srq(struct ib_srq *srq, struct ib_srq_init_attr *init_attr,
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 9dd4bd7aea92..0aa89a070cec 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -195,15 +195,15 @@ static void rxe_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 	rxe_drop_ref(pd);
 }
 
-static int rxe_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr,
-			 u32 flags, struct ib_udata *udata)
+static int rxe_create_ah(struct ib_ah *ibah,
+			 struct rdma_ah_init_attr *init_attr)
 
 {
 	int err;
 	struct rxe_dev *rxe = to_rdev(ibah->device);
 	struct rxe_ah *ah = to_rah(ibah);
 
-	err = rxe_av_chk_attr(rxe, attr);
+	err = rxe_av_chk_attr(rxe, init_attr->ah_attr);
 	if (err)
 		return err;
 
@@ -211,7 +211,7 @@ static int rxe_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr,
 	if (err)
 		return err;
 
-	rxe_init_av(attr, &ah->av);
+	rxe_init_av(init_attr->ah_attr, &ah->av);
 	return 0;
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bbc5cfb57cd2..c49e4d9ead66 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -880,6 +880,12 @@ struct ib_mr_status {
  */
 __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
 
+struct rdma_ah_init_attr {
+	struct rdma_ah_attr *ah_attr;
+	u32 flags;
+	struct ib_udata *udata;
+};
+
 enum rdma_ah_attr_type {
 	RDMA_AH_ATTR_TYPE_UNDEFINED,
 	RDMA_AH_ATTR_TYPE_IB,
@@ -2403,8 +2409,7 @@ struct ib_device_ops {
 	void (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
 	int (*alloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
 	void (*dealloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
-	int (*create_ah)(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
-			 u32 flags, struct ib_udata *udata);
+	int (*create_ah)(struct ib_ah *ah, struct rdma_ah_init_attr *attr);
 	int (*modify_ah)(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 	int (*query_ah)(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 	void (*destroy_ah)(struct ib_ah *ah, u32 flags);
-- 
2.17.2

