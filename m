Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A5126FFF4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIROdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:33:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41610 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIROdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 10:33:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IESxZJ081681;
        Fri, 18 Sep 2020 14:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=pC5PeaObzOnZ0t+mhJGBnj35yVCcyEMfey6oRomZY7Y=;
 b=nRcvy6DLJXMwyQFXGrW3bRANiKAjT5MRbDoTCyx5NUT6q2KFrm/JwCCeP42Tbu63XIsi
 shopfyGBpoLSi2a6IbLmljOuqwXqsJNXYB17j0tL9+eDgtrkSCyz09HtbYw2uTJzPF/g
 drKy6NuVJqcQ9V7015uYU9/M58fs0cU0s/fhwaBYI5DcDcERV7BhjYHtYTxtfpFZEt5/
 xs0nlGG64Z9vlA7TMy7i8aTxTDOyqq/FOSEtcOn7SakPw8RB3+z3L+t1zwIpZLBa49S/
 WwEfdUSBzIqJQxONQWsAzIIp0K6eNzbhw4DlzvkmudN2uHUiNw+NEpOLOqqKaFXZNPUP 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9mqga0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 14:33:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IEV2Zt120436;
        Fri, 18 Sep 2020 14:33:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33megbhprb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 14:33:26 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08IEXO12011726;
        Fri, 18 Sep 2020 14:33:25 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 14:33:18 +0000
Date:   Fri, 18 Sep 2020 17:33:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] sfc: Fix error code in probe
Message-ID: <20200918143311.GD909725@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This failure path should return a negative error code but it currently
returns success.

Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/sfc/ef100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index c54b7f8243f3..ffdb36715a49 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -490,6 +490,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 	if (fcw.offset > pci_resource_len(efx->pci_dev, fcw.bar) - ESE_GZ_FCW_LEN) {
 		netif_err(efx, probe, efx->net_dev,
 			  "Func control window overruns BAR\n");
+		rc = -EIO;
 		goto fail;
 	}
 
-- 
2.28.0

