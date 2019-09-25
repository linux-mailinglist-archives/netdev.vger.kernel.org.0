Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3A8BDCAB
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732224AbfIYLFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:05:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729602AbfIYLFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:05:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PB4P3O095194;
        Wed, 25 Sep 2019 11:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=rjh6Y0aAFSEq231KNNfsjDwz8c/kE2zCEgm+a2ktHJI=;
 b=f09KFQbUzWGWqiJq04FdHL+01NNu3/FF1VnCC1EzvNO+nyZLat0I2EzNR6CiXqlgRzms
 bMRaGIp+QYycppcD20GegmwB6a3P32nPRcjVdsfmiTq2KqGrcOprHenkLVUFCiI2ugvR
 FjpCKMCq4yULTEEMms4eyuOky1oxwlBelvMuy6FcptI7VtBHnH6Z6LZRi8K4xRqufTRh
 F9I+gl/crM3wqWjTf29te6sfkw6aC9EITWqv0cLAtnDZdjKV+/1iRpTIrBeCiGuhQMkB
 jt8+tNET66V3Of9kLFbrbC/nE/Gp7K3ankxWmN4/rqP+9z5pkCW42DmgqSxJLKUUAPLb PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tuw9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 11:05:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PB42vC049926;
        Wed, 25 Sep 2019 11:05:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v7vnxskf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 11:05:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PB5V4G023777;
        Wed, 25 Sep 2019 11:05:32 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 04:05:31 -0700
Date:   Wed, 25 Sep 2019 14:05:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Moritz Fischer <mdf@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Alex Williams <alex.williams@ni.com>,
        Luis Chamberlain <mcgrof@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: nixge: Fix a signedness bug in nixge_probe()
Message-ID: <20190925110524.GP3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "priv->phy_mode" is an enum and in this context GCC will treat it
as an unsigned int so it can never be less than zero.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/ni/nixge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 0b384f97d2fd..2761f3a3ae50 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1347,7 +1347,7 @@ static int nixge_probe(struct platform_device *pdev)
 	}
 
 	priv->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-	if (priv->phy_mode < 0) {
+	if ((int)priv->phy_mode < 0) {
 		netdev_err(ndev, "not find \"phy-mode\" property\n");
 		err = -EINVAL;
 		goto unregister_mdio;
-- 
2.20.1

