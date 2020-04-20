Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06A91B036E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgDTHyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:54:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51595 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726240AbgDTHyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 03:54:39 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Apr 2020 10:54:31 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03K7sUfF026672;
        Mon, 20 Apr 2020 10:54:31 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V2 mlx5-next 06/10] RDMA/core: Get xmit slave for LAG
Date:   Mon, 20 Apr 2020 10:54:22 +0300
Message-Id: <20200420075426.31462-7-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200420075426.31462-1-maorg@mellanox.com>
References: <20200420075426.31462-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a call to rdma_lag_get_ah_roce_slave when
Address handle is created.
Low driver can use it to select the QP's affinity port.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 44 ++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 56a71337112c..a0d60376ba6b 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -50,6 +50,7 @@
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>
 #include <rdma/rw.h>
+#include <rdma/lag.h>
 
 #include "core_priv.h"
 #include <trace/events/rdma_core.h>
@@ -554,8 +555,14 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 	if (ret)
 		return ERR_PTR(ret);
 
-	ah = _rdma_create_ah(pd, ah_attr, flags, NULL);
+	ret = rdma_lag_get_ah_roce_slave(pd->device, ah_attr);
+	if (ret) {
+		rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
+		return ERR_PTR(ret);
+	}
 
+	ah = _rdma_create_ah(pd, ah_attr, flags, NULL);
+	rdma_lag_put_ah_roce_slave(ah_attr);
 	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
 	return ah;
 }
@@ -1638,6 +1645,25 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
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
+							 &attr->ah_attr);
+			if (ret)
+				goto out_av;
+		}
 	}
 	if (attr_mask & IB_QP_ALT_PATH) {
 		/*
@@ -1664,18 +1690,6 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
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
@@ -1717,8 +1731,10 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_ALT_PATH)
 		rdma_unfill_sgid_attr(&attr->alt_ah_attr, old_sgid_attr_alt_av);
 out_av:
-	if (attr_mask & IB_QP_AV)
+	if (attr_mask & IB_QP_AV) {
+		rdma_lag_put_ah_roce_slave(&attr->ah_attr);
 		rdma_unfill_sgid_attr(&attr->ah_attr, old_sgid_attr_av);
+	}
 	return ret;
 }
 
-- 
2.17.2

