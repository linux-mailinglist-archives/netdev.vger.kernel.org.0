Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6161113274D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgAGNMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:12:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43980 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgAGNMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:12:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007D9Xld095298;
        Tue, 7 Jan 2020 13:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=g7nkYe1ARDrVKx7na1mVAWf8BhUTVbUMNdy8zKM4VjY=;
 b=igFaqiZEbD8KP3BJ+EQV9Gtq2QRSC4xIWQURvW7BcUEs5vRr/VwRsmgF5mjmskAF+0He
 eUXOClMz/QeQnXT4B6pE7LDD3JYFxIVt/WTJCpUPv0o7hCHQjPkvKkwaFUsgJ3HMl1ZP
 xs1RBl6elszKcQcr/t91Bbp5Y+sqUMg1/Lzan4nZYyLN06Lht0QPdAit9VBEdSFOm9Qp
 tc3X9aaW2t51WveNc+7/lTiJQ/5lU5fM1QjCofkDzIa4lDyb/GpjGz26aLcCtsoq8uHl
 dODhTilOLp+lDL/sPSgAeBFrM2l2jkXd39eApuGXwHebQCxH7X3n05McbU0gZfd7vdsq Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnpwc3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 13:11:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007D4B8C022179;
        Tue, 7 Jan 2020 13:11:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xcpamgbny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 13:11:53 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 007DBpI9017448;
        Tue, 7 Jan 2020 13:11:51 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 05:11:51 -0800
Date:   Tue, 7 Jan 2020 16:11:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] enetc: Fix an off by one in enetc_setup_tc_txtime()
Message-ID: <20200107131143.jqytedvewberqp5c@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The priv->tx_ring[] has 16 elements but only priv->num_tx_rings are
set up, the rest are NULL.  This ">" comparison should be ">=" to avoid
a potential crash.

Fixes: 0d08c9ec7d6e ("enetc: add support time specific departure base on the qos etf")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index e910aaf0f5ec..00382b7c5bd8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -315,7 +315,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 
 	tc = qopt->queue;
 
-	if (tc < 0 || tc > priv->num_tx_rings)
+	if (tc < 0 || tc >= priv->num_tx_rings)
 		return -EINVAL;
 
 	/* Do not support TXSTART and TX CSUM offload simutaniously */
-- 
2.11.0

