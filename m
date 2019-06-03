Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E6232735
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 06:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFCEUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 00:20:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfFCEUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 00:20:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x534Ilp6072117;
        Mon, 3 Jun 2019 04:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=Gbhz12z94ieMgELDwPmYlCekiTfmtctGBbqE2Iwg5YM=;
 b=dIi2TZIiiqODXm1cJT7sYTaMmImJVg5PKVYP07m1QLeA4IknPNHXdMM6Xq5r+Pi2U4KQ
 GiD+X5QgYVkTnm67qP1sq18zp8VreSwR+KbYOhhXKBO3poYNspvSDzzFytPku7AmETAr
 biHaNhI6Pjwex0ttZ3fN+VwjlYC+KSuWxWlAQIKrOezt8+kil6vw2ivbvRz+k4ckSNZz
 JRoZOOBnVNJkAeQxxsuix+nRXA1jt9Nx2K7o0m5anu2bKPr1sT93NcnJ5ThWmbnjUZvw
 JdHKVnVmpkNgrrhZVZskcGMkPkKJBKF3cJTli87WN+tBCcJsHOm6Ff8ABMGJHAD6aCli fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2suevd4p42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 04:20:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x534JYO9004418;
        Mon, 3 Jun 2019 04:20:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2svbbuwwp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Jun 2019 04:20:45 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x534KjB5006951;
        Mon, 3 Jun 2019 04:20:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2svbbuwwp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 04:20:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x534KhdD009615;
        Mon, 3 Jun 2019 04:20:43 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 02 Jun 2019 21:20:43 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCHv2 1/1] net: rds: add per rds connection cache statistics
Date:   Mon,  3 Jun 2019 00:28:01 -0400
Message-Id: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9276 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030030
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable cache_allocs is to indicate how many frags (KiB) are in one
rds connection frag cache.
The command "rds-info -Iv" will output the rds connection cache
statistics as below:
"
RDS IB Connections:
      LocalAddr RemoteAddr Tos SL  LocalDev            RemoteDev
      1.1.1.14 1.1.1.14   58 255  fe80::2:c903:a:7a31 fe80::2:c903:a:7a31
      send_wr=256, recv_wr=1024, send_sge=8, rdma_mr_max=4096,
      rdma_mr_size=257, cache_allocs=12
"
This means that there are about 12KiB frag in this rds connection frag
cache. 
Since rds.h in rds-tools is not related with the kernel rds.h, the change
in kernel rds.h does not affect rds-tools.
rds-info in rds-tools 2.0.5 and 2.0.6 is tested with this commit. It works
well.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
V1->V2: RDS CI is removed. 
---
 include/uapi/linux/rds.h | 2 ++
 net/rds/ib.c             | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index 5d0f76c..fd6b5f6 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
 	__u32		rdma_mr_max;
 	__u32		rdma_mr_size;
 	__u8		tos;
+	__u32		cache_allocs;
 };
 
 struct rds6_info_rdma_connection {
@@ -264,6 +265,7 @@ struct rds6_info_rdma_connection {
 	__u32		rdma_mr_max;
 	__u32		rdma_mr_size;
 	__u8		tos;
+	__u32		cache_allocs;
 };
 
 /* RDS message Receive Path Latency points */
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 2da9b75..f9baf2d 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -318,6 +318,7 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
 		iinfo->max_recv_wr = ic->i_recv_ring.w_nr;
 		iinfo->max_send_sge = rds_ibdev->max_sge;
 		rds_ib_get_mr_info(rds_ibdev, iinfo);
+		iinfo->cache_allocs = atomic_read(&ic->i_cache_allocs);
 	}
 	return 1;
 }
@@ -351,6 +352,7 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
 		iinfo6->max_recv_wr = ic->i_recv_ring.w_nr;
 		iinfo6->max_send_sge = rds_ibdev->max_sge;
 		rds6_ib_get_mr_info(rds_ibdev, iinfo6);
+		iinfo6->cache_allocs = atomic_read(&ic->i_cache_allocs);
 	}
 	return 1;
 }
-- 
2.7.4

