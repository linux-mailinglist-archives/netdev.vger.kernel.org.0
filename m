Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51139281C90
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgJBUHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:07:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgJBUHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:07:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092K6dqf186823;
        Fri, 2 Oct 2020 20:07:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=+oN1Sr5m1kZN7D7Y817gY2aCh9P8d/pDYhAHHqikyg4=;
 b=tm5/BsF2d2972/toGa0fTqCqpQYFby7ZCWQXOuYSmNkYduFLPsYdKYH+N8/US3McwJYh
 0FfFdqCnEFRZ/CrEDDJ0DzBTYCzZOhmntdODWz4SqOnqK5Yl2PAnuTUkD+kXybS0L2yV
 LxlJH0BApv1pVV0ClkkyP/qUG7GSp9aNmznIeMx75LBie7nY0JtIaPkjE+ARqAzxqD3G
 q2XWBgWjDty5k9fbBCzoyfVC5kA5f7kYoB+UjMzRUltOYNOhaVFlh5RfTCATRiovC6cn
 tZF1VouAF/K4R+D4r08smyoxfLeMYci6tH3lZAMF0+UiSgk/Yf7MIdHOL6DTjSkUrvG6 WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9nmp7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 20:07:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092K4pRp100703;
        Fri, 2 Oct 2020 20:06:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33tfj3h4xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 20:06:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 092K6wX6025391;
        Fri, 2 Oct 2020 20:06:58 GMT
Received: from mbpatil.us.oracle.com (/10.211.44.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 13:06:57 -0700
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com,
        manjunath.b.patil@oracle.com
Subject: [PATCH 1/1] net/rds: suppress page allocation failure error in recv buffer refill
Date:   Fri,  2 Oct 2020 13:05:45 -0700
Message-Id: <1601669145-13604-1-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDS/IB tries to refill the recv buffer in softirq context using
GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
refill the recv buffer with GFP_KERNEL flag. This means failure to
allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
softirq context fails to refill the recv buffer, instead print rate
limited warnings.

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
---
 net/rds/ib_recv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 694d411dc72f..b4ed421acc7b 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -310,8 +310,8 @@ static int rds_ib_recv_refill_one(struct rds_connection *conn,
 	struct rds_ib_connection *ic = conn->c_transport_data;
 	struct ib_sge *sge;
 	int ret = -ENOMEM;
-	gfp_t slab_mask = GFP_NOWAIT;
-	gfp_t page_mask = GFP_NOWAIT;
+	gfp_t slab_mask = gfp;
+	gfp_t page_mask = gfp;
 
 	if (gfp & __GFP_DIRECT_RECLAIM) {
 		slab_mask = GFP_KERNEL;
@@ -406,6 +406,9 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 		recv = &ic->i_recvs[pos];
 		ret = rds_ib_recv_refill_one(conn, recv, gfp);
 		if (ret) {
+			pr_warn_ratelimited("RDS/IB: failed to refill recv buffer for <%pI6c,%pI6c,%d>, waking worker\n",
+					    &conn->c_laddr, &conn->c_faddr,
+					    conn->c_tos);
 			must_wake = true;
 			break;
 		}
@@ -1020,7 +1023,7 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
 		rds_ib_stats_inc(s_ib_rx_ring_empty);
 
 	if (rds_ib_ring_low(&ic->i_recv_ring)) {
-		rds_ib_recv_refill(conn, 0, GFP_NOWAIT);
+		rds_ib_recv_refill(conn, 0, GFP_NOWAIT | __GFP_NOWARN);
 		rds_ib_stats_inc(s_ib_rx_refill_from_cq);
 	}
 }
-- 
2.27.0.112.g101b320

