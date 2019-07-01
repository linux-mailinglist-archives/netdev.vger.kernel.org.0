Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB1A5C14B
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfGAQkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:40:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbfGAQkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:40:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GYF3X172005;
        Mon, 1 Jul 2019 16:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Ook9+v9xTquMS/wTyDTEmjRWZxdAAG2zXV81qVwVVys=;
 b=azA1SbbKUa6HLDYq7SG9HxwG1yov2S4XjcUSQZSaHbdBVx4gJnwf5ukJ1bkekm/q0gJU
 /QPJghAWLSk2SqJXagtVG2NY1EPi45N5TYlmmo5Q9/jOv2d2wEtV/AmgEQTZRifPVyk3
 dopz9z0yH0QKKtEp0FjA41m9K8cVmYcYrZzaJTGNbZz5Zw6RfAdmY3KRZ4o4fHC3SJvQ
 fihCqZmlfcqIF+/dsV7I6AfhkOVPt9kRMyWi2V/srTianeprWVdvpmfBIh3dWq4TpkjG
 RfeSCOPhwM/75iUv5YFYaZji7xx5jtXwh02qphz3sUzHz7iHDwXc9llL0zVe63tPYPWc 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61dxqwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GWVWh147763;
        Mon, 1 Jul 2019 16:40:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tebktsayd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:01 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61Ge0G4021252;
        Mon, 1 Jul 2019 16:40:00 GMT
Received: from [10.159.137.152] (/10.159.137.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 09:39:59 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 4/7] net/rds: Fix NULL/ERR_PTR inconsistency
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <9f46098a-bcc7-bc0e-20db-2cbf05fefdee@oracle.com>
Date:   Mon, 1 Jul 2019 09:39:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010200
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
2.18.0


