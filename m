Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F77BBDC88
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390918AbfIYK7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:59:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390798AbfIYK7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:59:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsZiP087220;
        Wed, 25 Sep 2019 10:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=RaxbzEYgSm67aAT2RWDYs3Ke/EvB0jJZdjRp5bjWFNw=;
 b=NuSAOXo4uTJ3Xz6aFrQsnxcw3ieaY3/Uhl+hnkCM5GqE+/9KK2oqsUexlglvlCz+agFz
 vS/RgO7bpGVSKzpxBEGxVAu2v3yGDWkuWed29twPZEZk6xhn6QXOUEezgPQhZnj8lV0/
 Gwrc54sqgRVWt/r5KE0eeIax5bJob3/MCHgyvPwchN0Uxqnr74O0ErxjwS+SUjoJAn6u
 xrmbqG5yZfAb2wTfj3keQRAI/j2fhPXopzjje1glHYETZRFzSxhVJVK/wDWvzNdimPBJ
 QGsTVomo4j/v8OAV2ZA6ImMjRoJklt9A75jAbpEwKjnwGe/GxBBQ/PhSvsqOw/CXhc7F kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9tuvae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:59:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAx9Ed147929;
        Wed, 25 Sep 2019 10:59:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2v829uuu04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:59:23 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PAxIXw027750;
        Wed, 25 Sep 2019 10:59:18 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:59:18 -0700
Date:   Wed, 25 Sep 2019 13:59:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "Alvaro G. M" <alvaro.gamez@hazent.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: axienet: fix a signedness bug in probe
Message-ID: <20190925105911.GI3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "lp->phy_mode" is an enum but in this context GCC treats it as an
unsigned int so the error handling is never triggered.

Fixes: ee06b1728b95 ("net: axienet: add support for standard phy-mode binding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4fc627fb4d11..676006f32f91 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1762,7 +1762,7 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 	} else {
 		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-		if (lp->phy_mode < 0) {
+		if ((int)lp->phy_mode < 0) {
 			ret = -EINVAL;
 			goto free_netdev;
 		}
-- 
2.20.1

