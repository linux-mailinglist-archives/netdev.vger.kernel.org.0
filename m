Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A775D36DD0
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFFHxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:53:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFHxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:53:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x567nGAG166670;
        Thu, 6 Jun 2019 07:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=l68XanI+OC3EWntQIT4zAcW5wK4/464skn+jfLx0LX8=;
 b=Gje7F8vXB09EJWvYdCI2pTt2XJ5UCZB1W+UAuHPvOd2KPHTdP9UZRcKD7viJusS2yipk
 vtZ6VWuWE8w7ZjEfK7ct14ZGBwgla2ciSX4Yp8iAC++wUZ1r0ELwkurkvuJw8DtU98tK
 JPzR6ZqzQZcOK9jBMZbYsGksCyrGStg5WGRXY6G1P1fYgvHOwg5OipmuwwB+GEkLwgSQ
 z3KuG/1/F21OyJudCryMG9kfR0+78H3l6F2y+ua+GeoOQ3NS35AGEb/lRm/zzXOl17HL
 J0HHvlz5v+oMehFovqnEYsHqOKC4dd7zykOINdPAtHZ4S+YWvID5REJ92+BNl/9Du9m8 Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0qpr2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 07:53:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x567qbHF133661;
        Thu, 6 Jun 2019 07:53:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2swnhambqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Jun 2019 07:53:03 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x567r3Nm134193;
        Thu, 6 Jun 2019 07:53:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2swnhambqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 07:53:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x567r2TY006851;
        Thu, 6 Jun 2019 07:53:02 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 00:53:01 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCH 1/1] net: rds: fix memory leak in rds_ib_flush_mr_pool
Date:   Thu,  6 Jun 2019 04:00:03 -0400
Message-Id: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the following tests last for several hours, the problem will occur.

Server:
    rds-stress -r 1.1.1.16 -D 1M
Client:
    rds-stress -r 1.1.1.14 -s 1.1.1.16 -D 1M -T 30

The following will occur.

"
Starting up....
tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu
%
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
  1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
"
From vmcore, we can find that clean_list is NULL.

From the source code, rds_mr_flushd calls rds_ib_mr_pool_flush_worker.
Then rds_ib_mr_pool_flush_worker calls
"
 rds_ib_flush_mr_pool(pool, 0, NULL);
"
Then in function
"
int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
                         int free_all, struct rds_ib_mr **ibmr_ret)
"
ibmr_ret is NULL.

In the source code,
"
...
list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
if (ibmr_ret)
        *ibmr_ret = llist_entry(clean_nodes, struct rds_ib_mr, llnode);

/* more than one entry in llist nodes */
if (clean_nodes->next)
        llist_add_batch(clean_nodes->next, clean_tail, &pool->clean_list);
...
"
When ibmr_ret is NULL, llist_entry is not executed. clean_nodes->next
instead of clean_nodes is added in clean_list.
So clean_nodes is discarded. It can not be used again.
The workqueue is executed periodically. So more and more clean_nodes are
discarded. Finally the clean_list is NULL.
Then this problem will occur.

Fixes: 1bc144b62524 ("net, rds, Replace xlist in net/rds/xlist.h with llist")
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 net/rds/ib_rdma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index d664e9a..0b347f4 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -428,12 +428,14 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
 		wait_clean_list_grace();
 
 		list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
-		if (ibmr_ret)
+		if (ibmr_ret) {
 			*ibmr_ret = llist_entry(clean_nodes, struct rds_ib_mr, llnode);
-
+			clean_nodes = clean_nodes->next;
+		}
 		/* more than one entry in llist nodes */
-		if (clean_nodes->next)
-			llist_add_batch(clean_nodes->next, clean_tail, &pool->clean_list);
+		if (clean_nodes)
+			llist_add_batch(clean_nodes, clean_tail,
+					&pool->clean_list);
 
 	}
 
-- 
2.7.4

