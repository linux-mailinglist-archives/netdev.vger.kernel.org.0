Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29F6350698
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 20:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhCaSn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 14:43:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhCaSnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 14:43:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VINleI181779;
        Wed, 31 Mar 2021 18:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b7wvClihVzSZVhWqogGdhHm4qexMCST9e3ROWIkOdIM=;
 b=NgOT2kU12eEJLY0SLnokKqDfyXAr27r6jO1bPqnyGOrE2nvX9lVjDjsxYKTBKZtzmQoq
 BuSE9lGp4RR7YpZ8MiQK/l0UBifFj74IAV1y1OfsD/IIcpoEgjdTsMdgLLGB3s9iGujp
 vzxTlRHYk0vhMI7Pqv6/BxNtcDqpg9J+D/oPJo+DcTtBb7TdWn5/beDKQxhQqeCMuf2b
 IFEOp3J5CPc6mRyuK5fRuYPn8HKKlF33bD+X30q/rOMtlojtvMZecQEXffWIeiu+PnuD
 0gNE0idQ2fOPorQT8IfJAm4nuIDJnoAkD9EEMS3vldpRDv3Znvw9anyPYOkbcuLz5MXI kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37mabqu9e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VIPhV8032611;
        Wed, 31 Mar 2021 18:43:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 37mabprqpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:32 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 12VIguBM090868;
        Wed, 31 Mar 2021 18:43:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 37mabprqp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:31 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12VIhUIP031028;
        Wed, 31 Mar 2021 18:43:30 GMT
Received: from lab02.no.oracle.com (/10.172.144.56)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Mar 2021 11:43:29 -0700
From:   =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Cc:     netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next v3 1/2] IB/cma: Introduce rdma_set_min_rnr_timer()
Date:   Wed, 31 Mar 2021 20:43:13 +0200
Message-Id: <1617216194-12890-2-git-send-email-haakon.bugge@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-IMR: 1
X-Proofpoint-ORIG-GUID: fdOQGMhPHOgEDOZLSDcCTUtVCgs5yPB7
X-Proofpoint-GUID: fdOQGMhPHOgEDOZLSDcCTUtVCgs5yPB7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the ability for kernel ULPs to adjust the minimum RNR Retry
timer. The INIT -> RTR transition executed by RDMA CM will be used for
this adjustment. This avoids an additional ib_modify_qp() call.

rdma_set_min_rnr_timer() must be called before the call to
rdma_connect() on the active side and before the call to rdma_accept()
on the passive side.

The default value of RNR Retry timer is zero, which translates to 655
ms. When the receiver is not ready to accept a send messages, it
encodes the RNR Retry timer value in the NAK. The requestor will then
wait at least the specified time value before retrying the send.

The 5-bit value to be supplied to the rdma_set_min_rnr_timer() is
documented in IBTA Table 45: "Encoding for RNR NAK Timer Field".

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/core/cma.c      | 41 ++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/cma_priv.h |  2 ++
 include/rdma/rdma_cm.h             |  2 ++
 3 files changed, 45 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9409651..5ce097d 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -852,6 +852,7 @@ static void cma_id_put(struct rdma_id_private *id_priv)
 	id_priv->id.qp_type = qp_type;
 	id_priv->tos_set = false;
 	id_priv->timeout_set = false;
+	id_priv->min_rnr_timer_set = false;
 	id_priv->gid_type = IB_GID_TYPE_IB;
 	spin_lock_init(&id_priv->lock);
 	mutex_init(&id_priv->qp_mutex);
@@ -1141,6 +1142,9 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 	if ((*qp_attr_mask & IB_QP_TIMEOUT) && id_priv->timeout_set)
 		qp_attr->timeout = id_priv->timeout;
 
+	if ((*qp_attr_mask & IB_QP_MIN_RNR_TIMER) && id_priv->min_rnr_timer_set)
+		qp_attr->min_rnr_timer = id_priv->min_rnr_timer;
+
 	return ret;
 }
 EXPORT_SYMBOL(rdma_init_qp_attr);
@@ -2615,6 +2619,43 @@ int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout)
 }
 EXPORT_SYMBOL(rdma_set_ack_timeout);
 
+/**
+ * rdma_set_min_rnr_timer() - Set the minimum RNR Retry timer of the
+ *			      QP associated with a connection identifier.
+ * @id: Communication identifier to associated with service type.
+ * @min_rnr_timer: 5-bit value encoded as Table 45: "Encoding for RNR NAK
+ *		   Timer Field" in the IBTA specification.
+ *
+ * This function should be called before rdma_connect() on active
+ * side, and on passive side before rdma_accept(). The timer value
+ * will be associated with the local QP. When it receives a send it is
+ * not read to handle, typically if the receive queue is empty, an RNR
+ * Retry NAK is returned to the requester with the min_rnr_timer
+ * encoded. The requester will then wait at least the time specified
+ * in the NAK before retrying. The default is zero, which translates
+ * to a minimum RNR Timer value of 655 ms.
+ *
+ * Return: 0 for success
+ */
+int rdma_set_min_rnr_timer(struct rdma_cm_id *id, u8 min_rnr_timer)
+{
+	struct rdma_id_private *id_priv;
+
+	/* It is a five-bit value */
+	if (min_rnr_timer & 0xe0)
+		return -EINVAL;
+
+	if (id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT)
+		return -EINVAL;
+
+	id_priv = container_of(id, struct rdma_id_private, id);
+	id_priv->min_rnr_timer = min_rnr_timer;
+	id_priv->min_rnr_timer_set = true;
+
+	return 0;
+}
+EXPORT_SYMBOL(rdma_set_min_rnr_timer);
+
 static void cma_query_handler(int status, struct sa_path_rec *path_rec,
 			      void *context)
 {
diff --git a/drivers/infiniband/core/cma_priv.h b/drivers/infiniband/core/cma_priv.h
index caece96..bf83d32 100644
--- a/drivers/infiniband/core/cma_priv.h
+++ b/drivers/infiniband/core/cma_priv.h
@@ -86,9 +86,11 @@ struct rdma_id_private {
 	u8			tos;
 	u8			tos_set:1;
 	u8                      timeout_set:1;
+	u8			min_rnr_timer_set:1;
 	u8			reuseaddr;
 	u8			afonly;
 	u8			timeout;
+	u8			min_rnr_timer;
 	enum ib_gid_type	gid_type;
 
 	/*
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 32a67af..8b0f66e 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -331,6 +331,8 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 int rdma_set_afonly(struct rdma_cm_id *id, int afonly);
 
 int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout);
+
+int rdma_set_min_rnr_timer(struct rdma_cm_id *id, u8 min_rnr_timer);
  /**
  * rdma_get_service_id - Return the IB service ID for a specified address.
  * @id: Communication identifier associated with the address.
-- 
1.8.3.1

