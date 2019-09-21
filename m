Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82947B9C7D
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 07:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730910AbfIUF7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 01:59:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfIUF7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 01:59:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L5wvfL117603;
        Sat, 21 Sep 2019 05:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=pRq2y32TjFwnLy1W9SbnysuaNFXkcIJPQ9IS172eFRw=;
 b=cG/T2ZYTMmaNeViesFBtkU16seb9AraRU/x4xASJIt8pDcDlAOCIRoFiT/WYezC57lAK
 WQTlDbx3SRpguer+wjVC7f3bwyzd2Tmh4k99l1q9dwzHK0nw1hmd6HjopxNNZPY1ch0T
 1Sw3udOvh3hnlvVTyCp1hKQaTNII1w/q6r4oaQnsLOduEcPdmbx9LZGGwOqFmk7MpHXU
 h+Dv84KWROEno5CcPHGV+1x7luXxcVXW1bcnAujVpmZsrPxPJuIAAcYPLbE3eT8FbgqG
 9CYwtBaowxRzC4Z3CJ7//t4fl3jkyfPF01pXBOwPBvAGsRy99eiHSFrRCD7M6YzABJru cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgqg4r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 05:59:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L5vuo7179403;
        Sat, 21 Sep 2019 05:59:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v5bpby879-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 05:59:33 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8L5xWO1020848;
        Sat, 21 Sep 2019 05:59:33 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 22:59:32 -0700
Date:   Sat, 21 Sep 2019 08:59:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] ionic: Fix an error code in ionic_lif_alloc()
Message-ID: <20190921055926.GA18726@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=679
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909210065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=759 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909210066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to set the error code on this path.  Otherwise it probably
results in a NULL dereference down the line.

Fixes: aa3198819bea ("ionic: Add RSS support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index db7c82742828..72107a0627a9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1704,6 +1704,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 					      GFP_KERNEL);
 
 	if (!lif->rss_ind_tbl) {
+		err = -ENOMEM;
 		dev_err(dev, "Failed to allocate rss indirection table, aborting\n");
 		goto err_out_free_qcqs;
 	}
-- 
2.20.1

