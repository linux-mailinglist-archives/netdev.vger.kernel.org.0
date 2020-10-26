Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C76298F36
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 15:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781305AbgJZOZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 10:25:56 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:32410 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781274AbgJZOZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 10:25:56 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f96dc720000>; Mon, 26 Oct 2020 22:25:54 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 14:25:54 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 26 Oct 2020 14:25:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGNvCVfMQ+0vZxH3qZDIBFJJ4bEjOBHYn7WTq+hmmDM+dH7GFQClA4HWaNnXAdtqCJZd0Fl/AxMVUGwlHKapPBE2iNu+3Xpm2v8Gdan9QoQoutGXrbHlrG+AT0qfioJWzMoBR8Nsk3pRX9SptIxL7SVoqnEUi7a0vVFtBTBfHyGyc5e0bBIyE3tvOZd+UmbMDvQDlHmvHAPbiDgRwrOcEtiq3upse16yb3lA2GOwA3KlI84/DAidaPajmJubE3vZGCfRAWIopmFCnpiQCL1n4HHe4h9w8GNkKIo5V+WBw974ArThd1vgi3L4TQzWOFnxtbJJdZK2zrZLKwLXyxYxfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hnip12KaMvA/T2PRbs5aEPYafJlCW3vwge7fxr7lIhs=;
 b=msHx2W/zVFEqzaRc/022A0rK2xXsJYJdZsLQad3gXXNJqSJqqjSuFAaExc/ciQ1pL4iUiNxnEBjLSoGx+nziYMfboXhd0AOGsCRrNAl/fSnKjlhx+ETMJb8eQts6rbNgCtzWvxD8dmgXr+lw9XOftEtxtWBUjzVrvhOzMgeWCZDrEosDbmruA9Kts6iXAJKVWEpeQ6g6e9zeSek83WPkl6IeHPwPm4KKFeuaW1PI/1n7z3YlXz5fYUzP80NNuMbAhwgHw0hogSMCDbB3+z+z29obyz1ex3TZNfOO4ABsF/eAfdxguY/gQSYWW4g9z2AJHh4KaA0uK1nFQ7s9iSmRgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4268.namprd12.prod.outlook.com (2603:10b6:5:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 14:25:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 14:25:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Keith Busch <kbusch@kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
CC:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH] RDMA: Add rdma_connect_locked()
Date:   Mon, 26 Oct 2020 11:25:49 -0300
Message-ID: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0021.namprd22.prod.outlook.com
 (2603:10b6:208:238::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR22CA0021.namprd22.prod.outlook.com (2603:10b6:208:238::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 14:25:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kX3RV-008UXx-Aq; Mon, 26 Oct 2020 11:25:49 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603722354; bh=3Talaqe6CzHwWkl88seoO1OFUwf+v37Vv6YdzCO3ev4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Date:Message-ID:Content-Transfer-Encoding:Content-Type:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=lq4nNOy1c7xQqNc6IcxfLrgLQHYELyKOxZzovcGtCoK/6sHQgJ41nbvbQsDNfcvKr
         80+arNfA+mSIrxBvRpRUBwSYBD4Fp0L1L/+iJ0WUreNps2BBoIh86h26JWc+6HihqK
         Rs7AcHxqGb7lIHba8e3+NUPfinyVe46pPjBINmAL5XTs4q27fTz+WNI9QC7YNvD3RK
         xAIn3AFmeHHpBsB/NxRTIfm+2KTJcfmDJjt2azYrHsZvpAU7ThLaChQXpek2aVDmqK
         zhwV8rC2TvHsEBPeqnYP4psAh+EI+KBN3BPtWkKwQ3PRQ0FJWvIs5deMbJnwBZ4tTV
         tNfYobtDIOAzA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two flows for handling RDMA_CM_EVENT_ROUTE_RESOLVED, either the
handler triggers a completion and another thread does rdma_connect() or
the handler directly calls rdma_connect().

In all cases rdma_connect() needs to hold the handler_mutex, but when
handler's are invoked this is already held by the core code. This causes
ULPs using the 2nd method to deadlock.

Provide a rdma_connect_locked() and have all ULPs call it from their
handlers.

Reported-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Fixes: 2a7cec538169 ("RDMA/cma: Fix locking for the RDMA_CM_CONNECT state"
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/core/cma.c            | 39 +++++++++++++++++++++---
 drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c   |  4 +--
 drivers/nvme/host/rdma.c                 | 10 +++---
 include/rdma/rdma_cm.h                   | 13 +-------
 net/rds/ib_cm.c                          |  5 +--
 6 files changed, 47 insertions(+), 26 deletions(-)

Seems people are not testing these four ULPs against rdma-next.. Here is a
quick fix for the issue:

https://lore.kernel.org/r/3b1f7767-98e2-93e0-b718-16d1c5346140@cloud.ionos.=
com

Jason

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7c2ab1f2fbea37..2eaaa1292fb847 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -405,10 +405,10 @@ static int cma_comp_exch(struct rdma_id_private *id_p=
riv,
 	/*
 	 * The FSM uses a funny double locking where state is protected by both
 	 * the handler_mutex and the spinlock. State is not allowed to change
-	 * away from a handler_mutex protected value without also holding
+	 * to/from a handler_mutex protected value without also holding
 	 * handler_mutex.
 	 */
-	if (comp =3D=3D RDMA_CM_CONNECT)
+	if (comp =3D=3D RDMA_CM_CONNECT || exch =3D=3D RDMA_CM_CONNECT)
 		lockdep_assert_held(&id_priv->handler_mutex);
=20
 	spin_lock_irqsave(&id_priv->lock, flags);
@@ -4038,13 +4038,20 @@ static int cma_connect_iw(struct rdma_id_private *i=
d_priv,
 	return ret;
 }
=20
-int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param=
)
+/**
+ * rdma_connect_locked - Initiate an active connection request.
+ * @id: Connection identifier to connect.
+ * @conn_param: Connection information used for connected QPs.
+ *
+ * Same as rdma_connect() but can only be called from the
+ * RDMA_CM_EVENT_ROUTE_RESOLVED handler callback.
+ */
+int rdma_connect_locked(struct rdma_cm_id *id, struct rdma_conn_param *con=
n_param)
 {
 	struct rdma_id_private *id_priv =3D
 		container_of(id, struct rdma_id_private, id);
 	int ret;
=20
-	mutex_lock(&id_priv->handler_mutex);
 	if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT)) {
 		ret =3D -EINVAL;
 		goto err_unlock;
@@ -4071,6 +4078,30 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_=
conn_param *conn_param)
 err_state:
 	cma_comp_exch(id_priv, RDMA_CM_CONNECT, RDMA_CM_ROUTE_RESOLVED);
 err_unlock:
+	return ret;
+}
+EXPORT_SYMBOL(rdma_connect_locked);
+
+/**
+ * rdma_connect - Initiate an active connection request.
+ * @id: Connection identifier to connect.
+ * @conn_param: Connection information used for connected QPs.
+ *
+ * Users must have resolved a route for the rdma_cm_id to connect with by =
having
+ * called rdma_resolve_route before calling this routine.
+ *
+ * This call will either connect to a remote QP or obtain remote QP inform=
ation
+ * for unconnected rdma_cm_id's.  The actual operation is based on the
+ * rdma_cm_id's port space.
+ */
+int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param=
)
+{
+	struct rdma_id_private *id_priv =3D
+		container_of(id, struct rdma_id_private, id);
+	int ret;
+
+	mutex_lock(&id_priv->handler_mutex);
+	ret =3D rdma_connect_locked(id, conn_param);
 	mutex_unlock(&id_priv->handler_mutex);
 	return ret;
 }
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/=
ulp/iser/iser_verbs.c
index 2f3ebc0a75d924..2bd18b00689341 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -620,7 +620,7 @@ static void iser_route_handler(struct rdma_cm_id *cma_i=
d)
 	conn_param.private_data	=3D (void *)&req_hdr;
 	conn_param.private_data_len =3D sizeof(struct iser_cm_hdr);
=20
-	ret =3D rdma_connect(cma_id, &conn_param);
+	ret =3D rdma_connect_locked(cma_id, &conn_param);
 	if (ret) {
 		iser_err("failure connecting: %d\n", ret);
 		goto failure;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ul=
p/rtrs/rtrs-clt.c
index 776e89231c52f7..f298adc02acba2 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1674,9 +1674,9 @@ static int rtrs_rdma_route_resolved(struct rtrs_clt_c=
on *con)
 	uuid_copy(&msg.sess_uuid, &sess->s.uuid);
 	uuid_copy(&msg.paths_uuid, &clt->paths_uuid);
=20
-	err =3D rdma_connect(con->c.cm_id, &param);
+	err =3D rdma_connect_locked(con->c.cm_id, &param);
 	if (err)
-		rtrs_err(clt, "rdma_connect(): %d\n", err);
+		rtrs_err(clt, "rdma_connect_locked(): %d\n", err);
=20
 	return err;
 }
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index aad829a2b50d0f..f488dc5f4c2c61 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1730,11 +1730,10 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_=
rdma_queue *queue,
 	req->result =3D cqe->result;
=20
 	if (wc->wc_flags & IB_WC_WITH_INVALIDATE) {
-		if (unlikely(!req->mr ||
-			     wc->ex.invalidate_rkey !=3D req->mr->rkey)) {
+		if (unlikely(wc->ex.invalidate_rkey !=3D req->mr->rkey)) {
 			dev_err(queue->ctrl->ctrl.device,
 				"Bogus remote invalidation for rkey %#x\n",
-				req->mr ? req->mr->rkey : 0);
+				req->mr->rkey);
 			nvme_rdma_error_recovery(queue->ctrl);
 		}
 	} else if (req->mr) {
@@ -1890,10 +1889,10 @@ static int nvme_rdma_route_resolved(struct nvme_rdm=
a_queue *queue)
 		priv.hsqsize =3D cpu_to_le16(queue->ctrl->ctrl.sqsize);
 	}
=20
-	ret =3D rdma_connect(queue->cm_id, &param);
+	ret =3D rdma_connect_locked(queue->cm_id, &param);
 	if (ret) {
 		dev_err(ctrl->ctrl.device,
-			"rdma_connect failed (%d).\n", ret);
+			"rdma_connect_locked failed (%d).\n", ret);
 		goto out_destroy_queue_ib;
 	}
=20
@@ -1927,6 +1926,7 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm=
_id,
 		complete(&queue->cm_done);
 		return 0;
 	case RDMA_CM_EVENT_REJECTED:
+		nvme_rdma_destroy_queue_ib(queue);
 		cm_error =3D nvme_rdma_conn_rejected(queue, ev);
 		break;
 	case RDMA_CM_EVENT_ROUTE_ERROR:
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c672ae1da26bb5..937d55611cd073 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -227,19 +227,8 @@ void rdma_destroy_qp(struct rdma_cm_id *id);
 int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 		       int *qp_attr_mask);
=20
-/**
- * rdma_connect - Initiate an active connection request.
- * @id: Connection identifier to connect.
- * @conn_param: Connection information used for connected QPs.
- *
- * Users must have resolved a route for the rdma_cm_id to connect with
- * by having called rdma_resolve_route before calling this routine.
- *
- * This call will either connect to a remote QP or obtain remote QP
- * information for unconnected rdma_cm_id's.  The actual operation is
- * based on the rdma_cm_id's port space.
- */
 int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param=
);
+int rdma_connect_locked(struct rdma_cm_id *id, struct rdma_conn_param *con=
n_param);
=20
 int rdma_connect_ece(struct rdma_cm_id *id, struct rdma_conn_param *conn_p=
aram,
 		     struct rdma_ucm_ece *ece);
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 06603dd1c8aa38..b36b60668b1da9 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -956,9 +956,10 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_i=
d, bool isv6)
 	rds_ib_cm_fill_conn_param(conn, &conn_param, &dp,
 				  conn->c_proposed_version,
 				  UINT_MAX, UINT_MAX, isv6);
-	ret =3D rdma_connect(cm_id, &conn_param);
+	ret =3D rdma_connect_locked(cm_id, &conn_param);
 	if (ret)
-		rds_ib_conn_error(conn, "rdma_connect failed (%d)\n", ret);
+		rds_ib_conn_error(conn, "rdma_connect_locked failed (%d)\n",
+				  ret);
=20
 out:
 	/* Beware - returning non-zero tells the rdma_cm to destroy
--=20
2.28.0

