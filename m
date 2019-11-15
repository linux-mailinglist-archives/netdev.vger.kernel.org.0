Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D615AFD831
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 09:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKOI6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 03:58:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfKOI6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 03:58:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAF8ruQl167779;
        Fri, 15 Nov 2019 08:58:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=bKlkz75k2t9qiVKCRRAjOjoUiEbMQdE6818aHAymnsQ=;
 b=gaXSanL+UZ00rXUZuQneCz9pcbTZw9jaoAYKr0z6vVUy05JOzPA42yLHs3oYp6It+CvE
 llXw04l3X7SRfVYESN5bL8HwCWyu0Xc8mEjyi3g9VM7zvh25JxtO7rdQv9I9RV+FBBSh
 QtDzsnilEirjMNe4ycL0rutW42FbcCB8YRPG/MiDad+ZcHpoZ8zNFqYoN/7SYoxhuIEZ
 Da7N/9hp382W0FnFWYdpDGbwBFpW2Lc6dHEIwWwJZBBcYce1DOjsbwEBjA5SAqyTQRjc
 IV/sWbJQSurR7n9ESUEeEvft6V0s7bWUBGdG24IyFCTkI963Z01E1JSfu9sKRJQTrbH8 yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w9gxphwws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 08:58:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAF8sAKx121744;
        Fri, 15 Nov 2019 08:56:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2w9h14c50q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Nov 2019 08:56:09 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id xAF8u9BT126659;
        Fri, 15 Nov 2019 08:56:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w9h14c50g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 08:56:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAF8u8Xe009008;
        Fri, 15 Nov 2019 08:56:08 GMT
Received: from dm-oel.no.oracle.com (/10.172.157.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Nov 2019 00:56:08 -0800
From:   Dag Moxnes <dag.moxnes@oracle.com>
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     davem@davemloft.net, dag.moxnes@oracle.com
Subject: [net] rds: ib: update WR sizes when bringing up connection
Date:   Fri, 15 Nov 2019 09:56:01 +0100
Message-Id: <1573808161-331-1-git-send-email-dag.moxnes@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently WR sizes are updated from rds_ib_sysctl_max_send_wr and
rds_ib_sysctl_max_recv_wr when a connection is shut down. As a result,
a connection being down while rds_ib_sysctl_max_send_wr or
rds_ib_sysctl_max_recv_wr are updated, will not update the sizes when
it comes back up.

Move resizing of WRs to rds_ib_setup_qp so that connections will be setup
with the most current WR sizes.

Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
---
 net/rds/ib_cm.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 233f136816..18c6fac6ea 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -450,6 +450,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	struct ib_qp_init_attr attr;
 	struct ib_cq_init_attr cq_attr = {};
 	struct rds_ib_device *rds_ibdev;
+	unsigned long max_wrs;
 	int ret, fr_queue_space;
 
 	/*
@@ -469,10 +470,15 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	/* add the conn now so that connection establishment has the dev */
 	rds_ib_add_conn(rds_ibdev, conn);
 
-	if (rds_ibdev->max_wrs < ic->i_send_ring.w_nr + 1)
-		rds_ib_ring_resize(&ic->i_send_ring, rds_ibdev->max_wrs - 1);
-	if (rds_ibdev->max_wrs < ic->i_recv_ring.w_nr + 1)
-		rds_ib_ring_resize(&ic->i_recv_ring, rds_ibdev->max_wrs - 1);
+	max_wrs = rds_ibdev->max_wrs < rds_ib_sysctl_max_send_wr + 1 ?
+		rds_ibdev->max_wrs - 1 : rds_ib_sysctl_max_send_wr;
+	if (ic->i_send_ring.w_nr != max_wrs)
+		rds_ib_ring_resize(&ic->i_send_ring, max_wrs);
+
+	max_wrs = rds_ibdev->max_wrs < rds_ib_sysctl_max_recv_wr + 1 ?
+		rds_ibdev->max_wrs - 1 : rds_ib_sysctl_max_recv_wr;
+	if (ic->i_recv_ring.w_nr != max_wrs)
+		rds_ib_ring_resize(&ic->i_recv_ring, max_wrs);
 
 	/* Protection domain and memory range */
 	ic->i_pd = rds_ibdev->pd;
@@ -1099,8 +1105,9 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 	ic->i_flowctl = 0;
 	atomic_set(&ic->i_credits, 0);
 
-	rds_ib_ring_init(&ic->i_send_ring, rds_ib_sysctl_max_send_wr);
-	rds_ib_ring_init(&ic->i_recv_ring, rds_ib_sysctl_max_recv_wr);
+	/* Re-init rings, but retain sizes. */
+	rds_ib_ring_init(&ic->i_send_ring, ic->i_send_ring.w_nr);
+	rds_ib_ring_init(&ic->i_recv_ring, ic->i_recv_ring.w_nr);
 
 	if (ic->i_ibinc) {
 		rds_inc_put(&ic->i_ibinc->ii_inc);
@@ -1147,8 +1154,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	 * rds_ib_conn_shutdown() waits for these to be emptied so they
 	 * must be initialized before it can be called.
 	 */
-	rds_ib_ring_init(&ic->i_send_ring, rds_ib_sysctl_max_send_wr);
-	rds_ib_ring_init(&ic->i_recv_ring, rds_ib_sysctl_max_recv_wr);
+	rds_ib_ring_init(&ic->i_send_ring, 0);
+	rds_ib_ring_init(&ic->i_recv_ring, 0);
 
 	ic->conn = conn;
 	conn->c_transport_data = ic;
-- 
2.20.1

