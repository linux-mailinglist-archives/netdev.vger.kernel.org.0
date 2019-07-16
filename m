Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C466B1D8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388862AbfGPW3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:29:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388741AbfGPW3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:29:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMDbeM102436;
        Tue, 16 Jul 2019 22:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Rh/uds8XUyOzuD9R0uNLNA2vVIjuvWFBIm7npHwfsT4=;
 b=ABAPpcf85uv1JwBU3r6x0eoPfMYeUVxciixIjtZXoCtNtDW6hZ8Gv0vdpePMiEnQZ+yl
 ca4hkbix/E3LoPY5T3vvpHLNdCGB9sshi1K70zZV4ZojVukeGEA5jLNtIusUQHvplEwI
 KrRS6VOFBQ1cOsK/4spglawR7uLnh0LsS8+iBw1KTL/uS3/t4uYYOqI/BLb2Aj3u1Fva
 REHBB/WJnUAwH+vPy9Df12nrOwkNSkgwKvhMV6qpOTOOjr9js22J4hDBnFGOr7cuBU83
 lxsPAP+k/bg3a6GCC/6EWxZwu6+QB9UZQEvNkRLcNmHz7in4zilSIKI67YU5x+Ruo8jK zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tq6qtq94r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMChJZ153609;
        Tue, 16 Jul 2019 22:29:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2tsctwhx3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:29:09 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMT9wf192628;
        Tue, 16 Jul 2019 22:29:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tsctwhx3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GMT9ZB003726;
        Tue, 16 Jul 2019 22:29:09 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:29:08 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 4/7] net/rds: Fix NULL/ERR_PTR inconsistency
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <0b9b1d80-0be7-a2ba-82da-cdceda467fc8@oracle.com>
Date:   Tue, 16 Jul 2019 15:29:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make function "rds_ib_try_reuse_ibmr" return NULL in case
memory region could not be allocated, since callers
simply check if the return value is not NULL.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 6b047e63a769..c8c1e3ae8d84 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -450,7 +450,7 @@ struct rds_ib_mr *rds_ib_try_reuse_ibmr(struct rds_ib_mr_pool *pool)
 				rds_ib_stats_inc(s_ib_rdma_mr_8k_pool_depleted);
 			else
 				rds_ib_stats_inc(s_ib_rdma_mr_1m_pool_depleted);
-			return ERR_PTR(-EAGAIN);
+			break;
 		}
 
 		/* We do have some empty MRs. Flush them out. */
@@ -464,7 +464,7 @@ struct rds_ib_mr *rds_ib_try_reuse_ibmr(struct rds_ib_mr_pool *pool)
 			return ibmr;
 	}
 
-	return ibmr;
+	return NULL;
 }
 
 static void rds_ib_mr_pool_flush_worker(struct work_struct *work)
-- 
2.22.0


