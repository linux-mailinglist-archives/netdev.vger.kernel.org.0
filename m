Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C82331A1C
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 09:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfFAHr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 03:47:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfFAHr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 03:47:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x517d7Jh043662;
        Sat, 1 Jun 2019 07:47:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=L5JQ3QiVucshw5CHawZFk9WPh+P5NP4gH4149MLUDnc=;
 b=qK4d/YQx31z6/oQhWl3VPuhSnTb5dGxyrvsiq4wlK3UYvo1Uf0kG5+g9E+5TFM6BlOlW
 pCoPCGTIzsdsyKRUKnGTtIqxbhE/jV9w8drEzX1Silbq9aJl9gYuUfRjI8ra3pJ48H9X
 djFFU/pwN8DiPKmrnZILbZMQHW70faGTJIIozYwnfkZ1jhl0LRrUJ/+ogwaFNvX3n800
 x+dZeP7v+Kyd80vJOatDy+iHRv23Us53zR1jKoYw7B1ELKNaP6U6YZ5kE0HBu32ka+LQ
 smTv0NuRVd0txz0odowPY4lyvAqKweB4tjLAjbYqco45SEPLlpE7hlQ32LajyOCO8/C3 Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0q09w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Jun 2019 07:47:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x517kF3s033710;
        Sat, 1 Jun 2019 07:47:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2sugpjtr8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 01 Jun 2019 07:47:17 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x517lHpW034619;
        Sat, 1 Jun 2019 07:47:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sugpjtr8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Jun 2019 07:47:17 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x517lGaq009628;
        Sat, 1 Jun 2019 07:47:16 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 01 Jun 2019 00:47:15 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCH 1/1] net: rds: add per rds connection cache statistics
Date:   Sat,  1 Jun 2019 03:54:34 -0400
Message-Id: <1559375674-17913-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9274 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906010057
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

Tested-by: RDS CI <rdsci_oslo@no.oracle.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
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

