Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1E1F9824
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbgFONTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:19:03 -0400
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:64844 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730120AbgFONTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 09:19:01 -0400
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FDDvWF006463;
        Mon, 15 Jun 2020 08:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type;
 s=PODMain02222019; bh=1dRfs36KYnwyGoVrRklSXMDuFrHPtd9eaNq3bCtvbWE=;
 b=FGRV3fBXTdtIb+VbdE9e9rYJ71x1n0IJSfGE42C/RuYuSHrLP3cEfQg0xrt/SOwbNVOX
 5D2A7Ar3AsQPgK8ZQmCSlOGRBL/nz5uXd1pQo2OqgkoP/0mk9EqDnzA1AHCjEDPbk1P9
 JGZHcnORKr/HYEgt+XqabBqM1KRhz0dE7fVgIeW6AsJrOX79Vf8+ZsfM5FotszA3CJOE
 O36YAh6vx+k67EK7bnNoFHu4l6/4CuLnrGFDZrmNnA/RFRxYGUjXbInyruaurq9fuQAG
 pgL9ge8l79UfQgNiFwXJCOEIhvq/IBwVX5ze8+gMr4mWQ0wpX6rdPJAod8zxmk8D0CuG zg== 
Authentication-Results: ppops.net;
        spf=fail smtp.mailfrom=ckeepax@opensource.cirrus.com
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 31mv73jpeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 15 Jun 2020 08:18:57 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 15 Jun
 2020 14:18:54 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Mon, 15 Jun 2020 14:18:54 +0100
Received: from algalon.ad.cirrus.com (algalon.ad.cirrus.com [198.90.251.122])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 5F5732C6;
        Mon, 15 Jun 2020 13:18:54 +0000 (UTC)
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     <davem@davemloft.net>, <nicolas.ferre@microchip.com>,
        <kuba@kernel.org>
CC:     <clabbe@baylibre.com>, <netdev@vger.kernel.org>
Subject: [PATCH] net: macb: Only disable NAPI on the actual error path
Date:   Mon, 15 Jun 2020 14:18:54 +0100
Message-ID: <20200615131854.12187-1-ckeepax@opensource.cirrus.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-SPF-Result: fail
X-Proofpoint-SPF-Record: v=spf1 include:spf-001ae601.pphosted.com include:spf.protection.outlook.com
 ip4:5.172.152.52 -all
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 phishscore=0 clxscore=1011 spamscore=0 impostorscore=0 mlxlogscore=808
 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006150106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change added a disable to NAPI into macb_open, this was
intended to only happen on the error path but accidentally applies
to all paths. This causes NAPI to be disabled on the success path, which
leads to the network to no longer functioning.

Fixes: 014406babc1f ("net: cadence: macb: disable NAPI on error")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5b9d7c60eebc0..67933079aeea5 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2565,15 +2565,14 @@ static int macb_open(struct net_device *dev)
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_init(dev);
 
+	return 0;
+
 napi_exit:
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
 pm_exit:
-	if (err) {
-		pm_runtime_put_sync(&bp->pdev->dev);
-		return err;
-	}
-	return 0;
+	pm_runtime_put_sync(&bp->pdev->dev);
+	return err;
 }
 
 static int macb_close(struct net_device *dev)
-- 
2.11.0

