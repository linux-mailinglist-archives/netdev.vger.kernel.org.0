Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361D7FB771
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfKMS0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:26:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39468 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbfKMS0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 13:26:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADI98pe081000;
        Wed, 13 Nov 2019 18:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=/ultW3+i2ngy2tSY04iZhVkT25/XQLUPgtZc1VgXtts=;
 b=TP/cilS3jjjLG4NgWoQXr/GIZERRUyTFs0kTNKUfxPms7JOMbgjMKwe2e3TJoEn3xmcC
 fXsQxrGhGZW8WXW3H6hEff6z+APt0G3P3UqG3xfflsWKSY1uim43pyfbWkUZLxtiiH4m
 QVdBtPKcl3BbhoIeO2KYgKWxXlhPMeQBUMBjcoV/fZCcSg3WLOa3DALYl5Rp3cId8ReQ
 W6+P1gJ3GLq3AvKr9IqcOtgEMow0P5bQ0NI9Q7poXwIfwoEXsurfYTagTGOVzAcwrkY2
 lbqQdsL1gBQHKOrNuFlqHS6QUPvjyTeh1IWPxkoQ5e0nAogDy7Yncys69tQc8tL3fLrK xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3qx9dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:25:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADIDe2b006887;
        Wed, 13 Nov 2019 18:25:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w7vbdb5fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:25:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADIPuSH020004;
        Wed, 13 Nov 2019 18:25:56 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 10:25:56 -0800
Date:   Wed, 13 Nov 2019 21:25:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] cxgb4: Fix an error code in
 cxgb4_mqprio_alloc_hw_resources()
Message-ID: <20191113182548.vtmyryulik4gxnrv@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"ret" is zero or possibly uninitialized on this error path.  It
should be a negative error code instead.

Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 143cb1f31bc0..eee45edc59e7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -158,8 +158,10 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
 		/* Allocate Rxqs for receiving ETHOFLD Tx completions */
 		if (msix >= 0) {
 			msix = cxgb4_get_msix_idx_from_bmap(adap);
-			if (msix < 0)
+			if (msix < 0) {
+				ret = msix;
 				goto out_free_queues;
+			}
 
 			eorxq->msix = &adap->msix_info[msix];
 			snprintf(eorxq->msix->desc,
-- 
2.11.0

