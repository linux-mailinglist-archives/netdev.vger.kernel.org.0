Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA5912F895
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgACNBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:01:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbgACNBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 08:01:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003Cwvv3131942;
        Fri, 3 Jan 2020 13:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=vuqX35esN36uhhlHmd3AU92vyFY4M3gSeNIKrdzGtGk=;
 b=k6CAKoNTV2sikwBHpHx6Toj32CdSZshz+TPyCqap5ebeSQONksOiAt9TCosUGer0bRAx
 SIL90wbYqhOYtR960jy6CE1ZpyLg4NYAAnBKj8hdtnNFb/MTkV9fDdhNY8nAF3KmnLN1
 iDAnRgszKkl1xB4lffo8zfs8pkx42Ry8Q9GqH5uV9DcwwopPf4kjTpmS5dScs6siLEuD
 eMBD2OZGksOyk7v0YVuAuPruiTJAHHoyCcDEd4D5i8y3CnKobOLVoLxOcWsCnKSluOpE
 dL4eZfn70C4LOpB1D7EeJqKAAuLROoHbTqFmgqrcqa8ZlLOuozhaIK9H6KWRmHFZSsLM wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftvbmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 13:01:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003CxHQ3131048;
        Fri, 3 Jan 2020 13:01:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xa5fg9dhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 13:01:21 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 003D1KRp023074;
        Fri, 3 Jan 2020 13:01:20 GMT
Received: from Lirans-MBP.Home (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 05:01:20 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     csully@google.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     sagis@google.com, jonolson@google.com, yangchun@google.com,
        lrizzo@google.com, adisuresh@google.com,
        Liran Alon <liran.alon@oracle.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH] net: Google gve: Remove dma_wmb() before ringing doorbell
Date:   Fri,  3 Jan 2020 15:01:08 +0200
Message-Id: <20200103130108.70593-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code use dma_wmb() to ensure Tx descriptors are visible
to device before writing to doorbell.

However, these dma_wmb() are wrong and unnecessary. Therefore,
they should be removed.

iowrite32be() called from gve_tx_put_doorbell() internally executes
dma_wmb()/wmb() on relevant architectures. E.g. On ARM, iowrite32be()
calls __iowmb() which translates to wmb() and only then executes
__raw_writel(). However on x86, iowrite32be() will call writel()
which just writes to memory because writes to UC memory is guaranteed
to be globally visible only after previous writes to WB memory are
globally visible.

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index f4889431f9b7..d0244feb0301 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -487,10 +487,6 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 		 * may have added descriptors without ringing the doorbell.
 		 */
 
-		/* Ensure tx descs from a prior gve_tx are visible before
-		 * ringing doorbell.
-		 */
-		dma_wmb();
 		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 		return NETDEV_TX_BUSY;
 	}
@@ -505,8 +501,6 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
 		return NETDEV_TX_OK;
 
-	/* Ensure tx descs are visible before ringing doorbell */
-	dma_wmb();
 	gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 	return NETDEV_TX_OK;
 }
-- 
2.20.1

