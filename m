Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31412E82
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfECMvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:51:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfECMvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 08:51:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43CiGuY103616;
        Fri, 3 May 2019 12:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=ttM9FSVxxf8kAXDzJlmtghZ0Pi1uHs17AOrHrP0WuEg=;
 b=XH7ebmCOs7ij/pH1uQWsqpEJk8vUpmbXtbgO64lGWrP5CVb9Kkg5U/rnl/iKtO4prYQd
 45tQxPtqIAkMWhI/5sMbN/4J1igVysCsfZisUjvfnOK/VpeoMm4V75KHmcMFZ68bjL0d
 gjLi18fmnMzH2f0MKs4NNMWUkPz0kIe06gz+Jel+JIshkm9lQQPn4OET/+HlVEwSkxBi
 emWPBavauT0dt9BtdCj2p/uzvHdDamMrh5yPyTnV4JNGoOo9kxa59JsbyhI0570CKU91
 9sINtlhqjM7wJQwVsRu/d7a9aRO40t9J7AZ7OTjnqAWOidxc0jawogdfyRL0AtQ4mGB2 kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2s6xhypgky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 12:50:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43ConMY110846;
        Fri, 3 May 2019 12:50:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2s7rtc917p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 12:50:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x43Codlh015640;
        Fri, 3 May 2019 12:50:39 GMT
Received: from mwanda (/196.104.111.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 05:50:39 -0700
Date:   Fri, 3 May 2019 15:50:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Esben Haabendal <esben@geanix.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>, Yang Wei <yang.wei9@zte.com.cn>,
        YueHaibing <yuehaibing@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net-next] net: ll_temac: Fix an NULL vs IS_ERR() check in
 temac_open()
Message-ID: <20190503125024.GF29695@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030080
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_connect() function doesn't return NULL pointers.  It returns
error pointers on error, so I have updated the check.

Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1003ee14c833..bcb97fbf5b54 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -927,9 +927,9 @@ static int temac_open(struct net_device *ndev)
 	} else if (strlen(lp->phy_name) > 0) {
 		phydev = phy_connect(lp->ndev, lp->phy_name, temac_adjust_link,
 				     lp->phy_interface);
-		if (!phydev) {
+		if (IS_ERR(phydev)) {
 			dev_err(lp->dev, "phy_connect() failed\n");
-			return -ENODEV;
+			return PTR_ERR(phydev);
 		}
 		phy_start(phydev);
 	}
-- 
2.18.0

