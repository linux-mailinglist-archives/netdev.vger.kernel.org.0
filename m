Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D320335069B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhCaSn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 14:43:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbhCaSnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 14:43:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VIOYBQ180470;
        Wed, 31 Mar 2021 18:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n7JBwYLNn26+J1GUz24BAPq8TuE4XDiYwzWMHkXAT2A=;
 b=BMzdpFUvC/XOHNxccRjcQe33OlqqPQPdp9be2eFW1s8waBA7/cOXMuMTnd4VfJJnYSAA
 dTs0AlEn6PyorIDsT8RkOYwbuRpgPzHvuBav4cwXdOGExUULk/z150HdZaSnwJTtJCOo
 Ww43d+tB6Py9frXTUygT28NLa8ACTAXORSw1RP2zUp4Ky8jdDxxG1FAx/2xXlN3vOsgB
 6gTZL5T0Rc7M9nyQnga66uqhawk5EwfxJUoyGOeGOjKUDXVebgWm2t7F7G2nEKipypZX
 xbRMC12/gqY0qnzA8RETSHqVuD2mbLErKZt1dIzGxs2N70hKIWVlguj9Io6axOirrLw6 hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37mp06srf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VIOea4178423;
        Wed, 31 Mar 2021 18:43:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 37mac5us54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:33 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 12VIhX8g046509;
        Wed, 31 Mar 2021 18:43:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 37mac5us4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12VIhWLs012178;
        Wed, 31 Mar 2021 18:43:32 GMT
Received: from lab02.no.oracle.com (/10.172.144.56)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Mar 2021 11:43:31 -0700
From:   =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Cc:     netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next v3 2/2] rds: ib: Remove two ib_modify_qp() calls
Date:   Wed, 31 Mar 2021 20:43:14 +0200
Message-Id: <1617216194-12890-3-git-send-email-haakon.bugge@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-IMR: 1
X-Proofpoint-ORIG-GUID: csyf7p_zqFnhbCIIWZ6SbE9yfPS_xGs3
X-Proofpoint-GUID: csyf7p_zqFnhbCIIWZ6SbE9yfPS_xGs3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some HCAs, ib_modify_qp() is an expensive operation running
virtualized.

For both the active and passive side, the QP returned by the CM has
the state set to RTS, so no need for this excess RTS -> RTS
transition. With IB Core's ability to set the RNR Retry timer, we use
this interface to shave off another ib_modify_qp().

Fixes: ec16227e1414 ("RDS/IB: Infiniband transport")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 net/rds/ib_cm.c          | 35 +----------------------------------
 net/rds/rdma_transport.c |  1 +
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index f5cbe96..26b069e 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -68,31 +68,6 @@ static void rds_ib_set_flow_control(struct rds_connection *conn, u32 credits)
 }
 
 /*
- * Tune RNR behavior. Without flow control, we use a rather
- * low timeout, but not the absolute minimum - this should
- * be tunable.
- *
- * We already set the RNR retry count to 7 (which is the
- * smallest infinite number :-) above.
- * If flow control is off, we want to change this back to 0
- * so that we learn quickly when our credit accounting is
- * buggy.
- *
- * Caller passes in a qp_attr pointer - don't waste stack spacv
- * by allocation this twice.
- */
-static void
-rds_ib_tune_rnr(struct rds_ib_connection *ic, struct ib_qp_attr *attr)
-{
-	int ret;
-
-	attr->min_rnr_timer = IB_RNR_TIMER_000_32;
-	ret = ib_modify_qp(ic->i_cm_id->qp, attr, IB_QP_MIN_RNR_TIMER);
-	if (ret)
-		printk(KERN_NOTICE "ib_modify_qp(IB_QP_MIN_RNR_TIMER): err=%d\n", -ret);
-}
-
-/*
  * Connection established.
  * We get here for both outgoing and incoming connection.
  */
@@ -100,7 +75,6 @@ void rds_ib_cm_connect_complete(struct rds_connection *conn, struct rdma_cm_even
 {
 	struct rds_ib_connection *ic = conn->c_transport_data;
 	const union rds_ib_conn_priv *dp = NULL;
-	struct ib_qp_attr qp_attr;
 	__be64 ack_seq = 0;
 	__be32 credit = 0;
 	u8 major = 0;
@@ -168,14 +142,6 @@ void rds_ib_cm_connect_complete(struct rds_connection *conn, struct rdma_cm_even
 	 * the posted credit count. */
 	rds_ib_recv_refill(conn, 1, GFP_KERNEL);
 
-	/* Tune RNR behavior */
-	rds_ib_tune_rnr(ic, &qp_attr);
-
-	qp_attr.qp_state = IB_QPS_RTS;
-	err = ib_modify_qp(ic->i_cm_id->qp, &qp_attr, IB_QP_STATE);
-	if (err)
-		printk(KERN_NOTICE "ib_modify_qp(IB_QP_STATE, RTS): err=%d\n", err);
-
 	/* update ib_device with this local ipaddr */
 	err = rds_ib_update_ipaddr(ic->rds_ibdev, &conn->c_laddr);
 	if (err)
@@ -947,6 +913,7 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 				  event->param.conn.responder_resources,
 				  event->param.conn.initiator_depth, isv6);
 
+	rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
 	/* rdma_accept() calls rdma_reject() internally if it fails */
 	if (rdma_accept(cm_id, &conn_param))
 		rds_ib_conn_error(conn, "rdma_accept failed\n");
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 5f741e5..a9e4ff9 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -87,6 +87,7 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		rdma_set_service_type(cm_id, conn->c_tos);
+		rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
 		/* XXX do we need to clean up if this fails? */
 		ret = rdma_resolve_route(cm_id,
 					 RDS_RDMA_RESOLVE_TIMEOUT_MS);
-- 
1.8.3.1

