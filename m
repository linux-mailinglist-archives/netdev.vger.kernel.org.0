Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539F627571F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 13:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWL2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 07:28:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgIWL2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 07:28:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NBOlTZ027355;
        Wed, 23 Sep 2020 11:28:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=uEf9FWNukK8RgzNDp5y3BawUGVfjd90oZWpVO7yCEVY=;
 b=hxf+7l2v6hG1i3NGSfiS7kzr3V85RO2HEJCnIGiTaEzMv1InK8FB89LExG/rRQ6pL/wz
 tNw9PeSYeO+kcCM/AWcWYVRJBtGsOl05D7TxLCgApZyKL+1sRPBz+wb6CKPosEUcE6hi
 ggoBswwKdaKakvoxp4iLkVRFTl5pFBb0p6jryq7Hq0W1D/xqx/+Z0wNELjTUOg0BWeIP
 Hxk6+ewbZBAaf7yFu01Q3zWfTGoqzXHBCT9oA7Zea7NHGrW1f23oJ2zIx8Ke9lDpzTJS
 howSL1Ohf6+vlFSi1pPtESbc6yjO0G7+LsAbKIvLAfc0D3XdTzRHJz807RrtMHRbXR3Q 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnuhx8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 11:28:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NBPP0t136367;
        Wed, 23 Sep 2020 11:28:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33nux0yvfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 11:28:01 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NBS0x9032204;
        Wed, 23 Sep 2020 11:28:00 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 04:27:59 -0700
Date:   Wed, 23 Sep 2020 14:27:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] can: mcp25xxfd: fix a leak in mcp25xxfd_ring_free()
Message-ID: <20200923112752.GA1473821@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=2 bulkscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This loop doesn't free the first element of the array.  The "i > 0" has
to be changed to "i >= 0".

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
index bd2ba981ae36..7e094afaac04 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
@@ -377,7 +377,7 @@ static void mcp25xxfd_ring_free(struct mcp25xxfd_priv *priv)
 {
 	int i;
 
-	for (i = ARRAY_SIZE(priv->rx) - 1; i > 0; i--) {
+	for (i = ARRAY_SIZE(priv->rx) - 1; i >= 0; i--) {
 		kfree(priv->rx[i]);
 		priv->rx[i] = NULL;
 	}
-- 
2.28.0

