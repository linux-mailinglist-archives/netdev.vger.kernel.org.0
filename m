Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2979B1B5BE1
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgDWM4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:13 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60518 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728541AbgDWM4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:11 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw22003234;
        Thu, 23 Apr 2020 15:55:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 12/16] RDMA/core: Get xmit slave for LAG
Date:   Thu, 23 Apr 2020 15:55:51 +0300
Message-Id: <20200423125555.21759-13-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a call to rdma_lag_get_ah_roce_slave when
Address handle is created.
Lower driver can use it to select the QP's affinity port.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 53 +++++++++++++++++++++++----------
 include/rdma/ib_verbs.h         |  2 ++
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 1ea69d730492..00062b6c3031 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -50,6 +50,7 @@
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>
 #include <rdma/rw.h>
+#include <rdma/lag.h>
 
 #include "core_priv.h"
 #include <trace/events/rdma_core.h>
@@ -500,7 +501,8 @@ rdma_update_sgid_attr(struct rdma_ah_attr *ah_attr,
 static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 				     struct rdma_ah_attr *ah_attr,
 				     u32 flags,
-				     struct ib_udata *udata)
+				     struct ib_udata *udata,
+				     struct net_device *xmit_slave)
 {
 	struct rdma_ah_init_attr init_attr = {};
 	struct ib_device *device = pd->device;
@@ -525,6 +527,7 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 	init_attr.ah_attr = ah_attr;
 	init_attr.flags = flags;
 	init_attr.udata = udata;
+	init_attr.xmit_slave = xmit_slave;
 
 	ret = device->ops.create_ah(ah, &init_attr);
 	if (ret) {
@@ -551,6 +554,7 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 			     u32 flags)
 {
 	const struct ib_gid_attr *old_sgid_attr;
+	struct net_device *slave;
 	struct ib_ah *ah;
 	int ret;
 
@@ -558,8 +562,14 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 	if (ret)
 		return ERR_PTR(ret);
 
-	ah = _rdma_create_ah(pd, ah_attr, flags, NULL);
+	ret = rdma_lag_get_ah_roce_slave(pd->device, ah_attr, &slave);
+	if (ret) {
+		rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
+		return ERR_PTR(ret);
+	}
 
+	ah = _rdma_create_ah(pd, ah_attr, flags, NULL, slave);
+	rdma_lag_put_ah_roce_slave(slave);
 	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
 	return ah;
 }
@@ -598,7 +608,8 @@ struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
 		}
 	}
 
-	ah = _rdma_create_ah(pd, ah_attr, RDMA_CREATE_AH_SLEEPABLE, udata);
+	ah = _rdma_create_ah(pd, ah_attr, RDMA_CREATE_AH_SLEEPABLE,
+			     udata, NULL);
 
 out:
 	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
@@ -1642,6 +1653,26 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 					  &old_sgid_attr_av);
 		if (ret)
 			return ret;
+
+		if (attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE &&
+		    is_qp_type_connected(qp)) {
+			/*
+			 * If the user provided the qp_attr then we have to
+			 * resolve it. Kerne users have to provide already
+			 * resolved rdma_ah_attr's.
+			 */
+			if (udata) {
+				ret = ib_resolve_eth_dmac(qp->device,
+							  &attr->ah_attr);
+				if (ret)
+					goto out_av;
+			}
+			ret = rdma_lag_get_ah_roce_slave(qp->device,
+							 &attr->ah_attr,
+							 &attr->xmit_slave);
+			if (ret)
+				goto out_av;
+		}
 	}
 	if (attr_mask & IB_QP_ALT_PATH) {
 		/*
@@ -1668,18 +1699,6 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 		}
 	}
 
-	/*
-	 * If the user provided the qp_attr then we have to resolve it. Kernel
-	 * users have to provide already resolved rdma_ah_attr's
-	 */
-	if (udata && (attr_mask & IB_QP_AV) &&
-	    attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE &&
-	    is_qp_type_connected(qp)) {
-		ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
-		if (ret)
-			goto out;
-	}
-
 	if (rdma_ib_or_roce(qp->device, port)) {
 		if (attr_mask & IB_QP_RQ_PSN && attr->rq_psn & ~0xffffff) {
 			dev_warn(&qp->device->dev,
@@ -1721,8 +1740,10 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_ALT_PATH)
 		rdma_unfill_sgid_attr(&attr->alt_ah_attr, old_sgid_attr_alt_av);
 out_av:
-	if (attr_mask & IB_QP_AV)
+	if (attr_mask & IB_QP_AV) {
+		rdma_lag_put_ah_roce_slave(attr->xmit_slave);
 		rdma_unfill_sgid_attr(&attr->ah_attr, old_sgid_attr_av);
+	}
 	return ret;
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1d5acf3cc287..22a41493ef4c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -884,6 +884,7 @@ struct rdma_ah_init_attr {
 	struct rdma_ah_attr *ah_attr;
 	u32 flags;
 	struct ib_udata *udata;
+	struct net_device *xmit_slave;
 };
 
 enum rdma_ah_attr_type {
@@ -1273,6 +1274,7 @@ struct ib_qp_attr {
 	u8			alt_port_num;
 	u8			alt_timeout;
 	u32			rate_limit;
+	struct net_device	*xmit_slave;
 };
 
 enum ib_wr_opcode {
-- 
2.17.2

