Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1E7BDC91
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403821AbfIYLBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:01:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390478AbfIYLBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:01:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsJ3J087136;
        Wed, 25 Sep 2019 11:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=w6XAuF/qcTj8cDqYC4cfHG6Vdy4EsYsV65lu58h90F0=;
 b=AebTbWJCGZNNDdraBA50pdnHEUsukU3Qbh4gXU+N4wbWDwXAqP4V6i52AETufF34/VlI
 gpuJFXeR2YQqQBttefqut93lY0Z4MM/FXYSADqRtCRqUY8RJtYNVvu8dRTtmFZgdhCxJ
 toDh0VvUTS+5X6NTxa98cAAelEGETWRZJLdFiPR8Nnt5LLT50KQj2lsDS+9GkZH0q7eu
 uA4aMT3yw5sSjyHeEeuG8Maakf++oMEC3cpGCcD+f3EBTBGB6LWqGYc273OmoDwYBx4v
 IQv9DvwdSZf5ek2RCKrL6RlmDnOd78P3pg3HFhO6T9in6UkuV3QE4oMPgRF3WqfH3U+u EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v5b9tuvmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 11:01:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAx40S131861;
        Wed, 25 Sep 2019 11:01:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v82tjpg5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 11:01:17 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PB18pt029392;
        Wed, 25 Sep 2019 11:01:10 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 04:01:08 -0700
Date:   Wed, 25 Sep 2019 14:01:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>, Dongpo Li <lidongpo@hisilicon.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] of: mdio: Fix a signedness bug in
 of_phy_get_and_connect()
Message-ID: <20190925110100.GL3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250112
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

The "iface" variable is an enum and in this context GCC treats it as
an unsigned int so the error handling is never triggered.

Fixes: b78624125304 ("of_mdio: Abstract a general interface for phy connect")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/of/of_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 000b95787df1..bd6129db6417 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -362,7 +362,7 @@ struct phy_device *of_phy_get_and_connect(struct net_device *dev,
 	int ret;
 
 	iface = of_get_phy_mode(np);
-	if (iface < 0)
+	if ((int)iface < 0)
 		return NULL;
 	if (of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
-- 
2.20.1

