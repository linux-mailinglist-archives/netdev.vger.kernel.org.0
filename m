Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC40626C97C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgIPTKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:10:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbgIPTJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 15:09:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GJ4BM8030758;
        Wed, 16 Sep 2020 19:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=qyKbWfoXqEDMlA9j1xjcPrM4x9W/VoaoccGRj6OqD2g=;
 b=dBLBTUPbSkon/18vX5bIG8yLCqIRSe8emCN/R4FYEdA2FBWeHx6dbTQ5PvNrzSUwVUIO
 2niyUIZcc58ytpF7I6XCc/e6JWVG7VAg8alYljFBwFSP1xDCV3cdAwNGIB6ADUCv6eXW
 T9PayQU4cmCivgW7propmTsGCKubblLkwg65ZsDBcx++G1rfHSjolcTmq+4D48hFcezq
 PtgUwBkuVZQ8vfLsy29UzD0sKkWNpl/XDavFQaqj+3MCEnyP9Qun7r6EvNTsbQ+vdtco
 B7IE/R8cHq810rmPyc+CLtJP+JQJRLCMHQ/nJEBpzKVod75y7Iv/W18ACYETIqWfvysN Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33gnrr521q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 19:09:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GJ4m9E132346;
        Wed, 16 Sep 2020 19:09:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33h89287a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 19:09:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GJ9p2C024180;
        Wed, 16 Sep 2020 19:09:51 GMT
Received: from mbpatil.us.oracle.com (/10.211.44.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 19:09:51 +0000
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com
Subject: [PATCH 1/1] net/rds: suppress page allocation failure error in recv buffer refill
Date:   Wed, 16 Sep 2020 12:08:46 -0700
Message-Id: <1600283326-30323-1-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1011 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDS/IB tries to refill the recv buffer in softirq context using
GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
refill the recv buffer with GFP_KERNEL flag. This means failure to
allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
softirq context fails to refill the recv buffer, instead print a one
line warning once a day.

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
---
 net/rds/ib_recv.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 694d411dc72f..38d2894f6bb2 100644
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
@@ -406,6 +406,16 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 		recv = &ic->i_recvs[pos];
 		ret = rds_ib_recv_refill_one(conn, recv, gfp);
 		if (ret) {
+			static unsigned long warn_time;
+			/* warn max once per day. This should be enough to
+			 * warn users about low mem situation.
+			 */
+			if (printk_timed_ratelimit(&warn_time,
+						   24 * 60 * 60 * 1000))
+				pr_warn("RDS/IB: failed to refill recv buffer for <%pI6c,%pI6c,%d>, waking worker\n",
+					&conn->c_laddr, &conn->c_faddr,
+					conn->c_tos);
+
 			must_wake = true;
 			break;
 		}
@@ -1020,7 +1030,7 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
 		rds_ib_stats_inc(s_ib_rx_ring_empty);
 
 	if (rds_ib_ring_low(&ic->i_recv_ring)) {
-		rds_ib_recv_refill(conn, 0, GFP_NOWAIT);
+		rds_ib_recv_refill(conn, 0, GFP_NOWAIT | __GFP_NOWARN);
 		rds_ib_stats_inc(s_ib_rx_refill_from_cq);
 	}
 }
-- 
2.27.0.112.g101b320

