Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CD42853EA
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJFVey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:34:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51660 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJFVey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:34:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096LYrcs187116;
        Tue, 6 Oct 2020 21:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=vFFlkxXq73e45vuMvZRNqt5JePwyW/LmodedhqKf7uM=;
 b=kxy8NqUOegFqIN1JOOqG2eKBCnYJNs9bHtjB/n0J/vTPFUZ6tyKmx8CGmM3Tvm/3Fzsr
 r4SrDxrsXVmGg5UoMJzxnWH+uFEwhstkQUhWh80CO7OZppYoW1hhs8X0fD9aij7rlpuv
 4si0rymlgYEX9cqJcSJQh9anAwv3qxrt1B0rSHiYxW6EGRgEufIjN6SunOv0BCJaIvY8
 9ZJfrDLMwO7I7pe97xCQGIwJPe1l+/glFZxSwzp13coodUFD/7+EXXC90n6Vw+0ZQaO+
 SapDVD3KcTbnkiZVPXEEM1/0Ij28xJc2eVb8Mml5//Z1GRImO8cXDlmadr4vzQyKoGcT 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetaxsdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 21:34:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096LVfgQ131883;
        Tue, 6 Oct 2020 21:32:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3410jxr0xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 21:32:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 096LWq8c020845;
        Tue, 6 Oct 2020 21:32:52 GMT
Received: from mbpatil.us.oracle.com (/10.211.44.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 14:32:51 -0700
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com,
        manjunath.b.patil@oracle.com
Subject: [PATCH v3 1/1] net/rds: suppress page allocation failure error in recv buffer refill
Date:   Tue,  6 Oct 2020 14:31:37 -0700
Message-Id: <1602019897-25904-1-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDS/IB tries to refill the recv buffer in softirq context using
GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
refill the recv buffer with GFP_KERNEL flag. This means failure to
allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
softirq context fails to refill the recv buffer. We will see the PAF
warnings when worker also fails to allocate.

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
---
v3:
 - remove pr_warn_ratelimited() when softirq context fails to allocate

v2:
 - change pr_warn once a day to pr_warn_ratelimited()

 net/rds/ib_recv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 694d411dc72f..3cffcec5fb37 100644
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
@@ -1020,7 +1020,7 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
 		rds_ib_stats_inc(s_ib_rx_ring_empty);
 
 	if (rds_ib_ring_low(&ic->i_recv_ring)) {
-		rds_ib_recv_refill(conn, 0, GFP_NOWAIT);
+		rds_ib_recv_refill(conn, 0, GFP_NOWAIT | __GFP_NOWARN);
 		rds_ib_stats_inc(s_ib_rx_refill_from_cq);
 	}
 }
-- 
2.27.0.112.g101b320

