Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504CB371711
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhECOue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:50:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50638 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhECOue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:50:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 143Ei4dM009417;
        Mon, 3 May 2021 14:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=SoiMkEpKlhR/SPzQZKWhuYHOGqyO7f6ekQE/KJ2Xfeo=;
 b=rhN7qTDtQVfJR+e8ttEzU75oUxrD1Bm1dNxIacJuZBx9ORUwfIJVvmyv4PQvZ+byUWgt
 W4iCGFwheqBa1EIFWkBMHO48jSNXbDdsOcMHQcN57Q/PlRBuEsssuEqRbVhHFzK+E8TG
 vp3ihpGtlG6rrNv9K4Vg3qubLJgRJUTylyOSkwcONI+KEuO8uDu6yNgrSwia9fk9IpAT
 5CjnpF8CyMg4qCay0begB/1HugJBwFg2+2y1JmgNXH4F75vXGDny/HqG5/lSjdPK2wy7
 L6y9j1YgXq5mgnAGa22OjCkucE9OAvODOwpvg2szltRLPMw8b1LK4n4gRf+MfdXjcg7S gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 388xxmuuww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 May 2021 14:49:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 143EfHWQ139249;
        Mon, 3 May 2021 14:49:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 389grqtc54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 May 2021 14:49:20 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 143Egu4q161043;
        Mon, 3 May 2021 14:49:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 389grqtc4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 May 2021 14:49:20 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 143EnHSX032020;
        Mon, 3 May 2021 14:49:17 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 May 2021 14:49:16 +0000
Date:   Mon, 3 May 2021 17:49:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] can: mcp251xfd: fix an error pointer dereference in probe
Message-ID: <YJANZf13Qxd5Mhr1@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: X_RwcsY3xP1R8gQHmDq5FQLLSFZox1Rz
X-Proofpoint-ORIG-GUID: X_RwcsY3xP1R8gQHmDq5FQLLSFZox1Rz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9973 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1011 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105030102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we converted this code to use dev_err_probe() we accidentally
removed a return.  It means that if devm_clk_get() it will lead to
an Oops when we call clk_get_rate() on the next line.

Fixes: cf8ee6de2543 ("can: mcp251xfd: mcp251xfd_probe(): use dev_err_probe() to simplify error handling")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 970dc570e7a5..f122976e90da 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2885,8 +2885,8 @@ static int mcp251xfd_probe(struct spi_device *spi)
 
 	clk = devm_clk_get(&spi->dev, NULL);
 	if (IS_ERR(clk))
-		dev_err_probe(&spi->dev, PTR_ERR(clk),
-			      "Failed to get Oscillator (clock)!\n");
+		return dev_err_probe(&spi->dev, PTR_ERR(clk),
+				     "Failed to get Oscillator (clock)!\n");
 	freq = clk_get_rate(clk);
 
 	/* Sanity check */
-- 
2.30.2

