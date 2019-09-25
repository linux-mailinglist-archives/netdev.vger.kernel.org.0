Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB5ABDC7C
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390795AbfIYK52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:57:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfIYK51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:57:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsPqx087171;
        Wed, 25 Sep 2019 10:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=DuwlDcn27ej98UfB6kNHnasI15aWg5iDsOQfXCoy1kE=;
 b=UAob2PhA5Of91xyxj+FjDbjrOSYndWstsqRnU1KwYhtLDcAfMqR5zPfn8dQfTIWGMxR4
 sbgfkQq9jbwjMDS3Nz8G368V+JqskuHV7d6T6g+Tp1HjxA2cwnqY/5XfMYDFL3/Zg6Bd
 vy6kKYDJHTdtgww/8OJ05GukJsyTKtaAGmF8yHmLewzQi6hIM7MeVpZfvoYZSg29yHhc
 A3Vve3ZKRIJuZzXgQodLZNLDvmIFXGKXpT0ZuB1hPKhKXaz0+1htUQEUdYlf9NznnImw
 MRxxYk1ghZm+Mgo/hE44M3cOW+SwkHMWQ5hrHMvrKe4UBbZL3hF8BzMAuSWJasLoZC/F IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9tuv2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:57:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PArrKC035505;
        Wed, 25 Sep 2019 10:57:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82q99r1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:57:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PAvLN2006252;
        Wed, 25 Sep 2019 10:57:21 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:57:21 -0700
Date:   Wed, 25 Sep 2019 13:57:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] enetc: Fix a signedness bug in enetc_of_get_phy()
Message-ID: <20190925105714.GF3264@mwanda>
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

The "priv->if_mode" is type phy_interface_t which is an enum.  In this
context GCC will treat the enum as an unsigned int so this error
handling is never triggered.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7d6513ff8507..b73421c3e25b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -785,7 +785,7 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 	}
 
 	priv->if_mode = of_get_phy_mode(np);
-	if (priv->if_mode < 0) {
+	if ((int)priv->if_mode < 0) {
 		dev_err(priv->dev, "missing phy type\n");
 		of_node_put(priv->phy_node);
 		if (of_phy_is_fixed_link(np))
-- 
2.20.1

