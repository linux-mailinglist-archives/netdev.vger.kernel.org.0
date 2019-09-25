Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136FBBDC7F
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbfIYK6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:58:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390798AbfIYK6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:58:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsLcD084548;
        Wed, 25 Sep 2019 10:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=JSkVVc90kSYbWiOp9CDSJUoO9qPSL4ypucRs/TpanXk=;
 b=PgSqXU6eCpxpcHnRPAVg4gcTWljriuzmd3Fb3GGc/rF0W6/4+dyh/s3HyzzxmQ1Uoql4
 4Ak62gPHTISpgGTYDqmUFnHU9SlbT7e/RsHOqIjF6wwosmUuvA1VSdtUOrGt0JG1x4UJ
 dAWYKe7IUm+HEMUl6szuSbOlv5qJPnEEq87/epV1RCjiVWmbfaWsC1cqXeAOJLOs6wvv
 MUZqJz9Uj2JBOGCg3H3AxOAjRor+sAaNqzLFysKfLo4HPEFxk5bvUDgpKE4ALh3K6UbW
 sAB/HVNAm2WsCL9ol9pzgs1tGO99+/gHHBup2oFsdUH5vv8Eq1QuL6cC6+bzxWwy+10x tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr3t7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:58:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAro99022472;
        Wed, 25 Sep 2019 10:56:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v7vnxs5gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:56:13 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PAuChl005743;
        Wed, 25 Sep 2019 10:56:12 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:56:12 -0700
Date:   Wed, 25 Sep 2019 13:56:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: broadcom/bcmsysport: Fix signedness in
 bcm_sysport_probe()
Message-ID: <20190925105604.GD3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "priv->phy_interface" variable is an enum and in this context GCC
will treat it as unsigned so the error handling will never be
triggered.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 7df887e4024c..a977a459bd20 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2481,7 +2481,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 
 	priv->phy_interface = of_get_phy_mode(dn);
 	/* Default to GMII interface mode */
-	if (priv->phy_interface < 0)
+	if ((int)priv->phy_interface < 0)
 		priv->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	/* In the case of a fixed PHY, the DT node associated
-- 
2.20.1

