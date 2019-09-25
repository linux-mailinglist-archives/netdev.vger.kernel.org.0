Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC81BDC84
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbfIYK7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:59:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390798AbfIYK7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:59:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsZGk039717;
        Wed, 25 Sep 2019 10:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=E8H/frZ9/fWc7k78GWp5NEUpzmSzIEZU5pJkiGWo/yc=;
 b=kspfZwFigHfuHanufL22PJiZhyItbAtQLAk/JClgvSJJx4FcJz/35fuThh2h0ROnXo1H
 ScM7cqgGfCPwp6Azcin0n1DJuega6HHwvoL/9dHJAWQM5lvV8P3sueIbZGaeItSEz3NE
 wafN1uZgvp6HSQba0733gPX2v/4HpL/TH2jM7HvE8W2y8vPdSqrcIyQ/TlRBtTQP5Ob8
 zx9hLh/NTRxoosstD62irVSWF6XsIiQyxm4FLgg4Z2XQ5EsMXPA9VLkw+qmeqYA5zdyL
 QWKHxz8chdMh2I5wWdIkIKAQ7w159ZQ5rngmbepfUAWf0M70SrGIwhyslQwNda2U+Lv5 xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btq3vwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:59:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAwxCf047153;
        Wed, 25 Sep 2019 10:59:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82q99rrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:59:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PAvwGH006469;
        Wed, 25 Sep 2019 10:57:59 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:57:56 -0700
Date:   Wed, 25 Sep 2019 13:57:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: socionext: Fix a signedness bug in ave_probe()
Message-ID: <20190925105750.GG3264@mwanda>
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

The "phy_mode" variable is an enum and in this context GCC treats it as
an unsigned int so the error handling is never triggered.

Fixes: 4c270b55a5af ("net: ethernet: socionext: add AVE ethernet driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 10d0c3e478ab..d047a53f34f2 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1566,7 +1566,7 @@ static int ave_probe(struct platform_device *pdev)
 
 	np = dev->of_node;
 	phy_mode = of_get_phy_mode(np);
-	if (phy_mode < 0) {
+	if ((int)phy_mode < 0) {
 		dev_err(dev, "phy-mode not found\n");
 		return -EINVAL;
 	}
-- 
2.20.1

