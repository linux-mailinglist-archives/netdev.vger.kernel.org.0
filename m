Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1BBDC77
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390743AbfIYKzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:55:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59682 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfIYKzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:55:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsImu087109;
        Wed, 25 Sep 2019 10:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=YJe/tgXOW3S1P2awaFmF2CB/k3/xTETjKYbtE2F+9JI=;
 b=JESPJqbO2R3IwYJNbjv5J33JL/XL4mJUiyMUbOEZrmmu63aMi2UfGQHXgxibqkNKOaMi
 t+AkYbwZg1hMtq8EWnMJiTGkErNzeps6IZIxX23cSvDJskjpoH2GH8NQNuqlKQyHXYRx
 y1LFefumesT/xYw4DeJui0BzqbW6xUOPxo7B5Gb5QEsf+Hg0xEdzb+jgM1XpEl3AU4Rw
 UPEfB51rLkdIbP+o5rJTRuV9jPJ61/Lgw6P3AJAN/WjJ/mNMdllN39UlWawUln48JLWN
 kmBRZREcNHBmUFzGnFkPOp4xKrS0pTk3yMGaHyk/JeYUe/BMUDBV2jojjIpf5axn02jW dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9tuuta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:55:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PArwqI136195;
        Wed, 25 Sep 2019 10:55:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v829uun2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:55:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PAtdnJ005496;
        Wed, 25 Sep 2019 10:55:39 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:55:39 -0700
Date:   Wed, 25 Sep 2019 13:55:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()
Message-ID: <20190925105532.GC3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250111
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

The "priv->phy_mode" variable is an enum and in this context GCC will
treat it as unsigned to the error handling will never trigger.

Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 95a6b0926170..c41b19c760f8 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1194,7 +1194,7 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 		goto err_free_mdio;
 
 	priv->phy_mode = of_get_phy_mode(node);
-	if (priv->phy_mode < 0) {
+	if ((int)priv->phy_mode < 0) {
 		netdev_err(ndev, "not find phy-mode\n");
 		ret = -EINVAL;
 		goto err_mdiobus;
-- 
2.20.1

