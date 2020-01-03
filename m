Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A697912FABB
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgACQpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:45:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgACQpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 11:45:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003GiX7p085534;
        Fri, 3 Jan 2020 16:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=Atq7TR4pl1vuP1qeKg0Jq5pJkC/dq8w+QnAJK3ggn+M=;
 b=nUloNc5rHN1wzcGrVz0Zju1qBl1lV5KINVfx1r3rBHtjk48A2bsbEyz+CCtTnJUB/mIS
 XGvcesAlHfBpCU+kl4r6qE1DGIXWiyZGAencqyMiJuD6EiaXuiIWksTFpSPFd1cGR+Gw
 Eahqpx210PmYqTRzOit17wAz6R7qUlFTwQvbAq/7DkURwHVPbuNdEpXLKFXspOjtL31q
 u9gtOQhZHlPgecuvYXCrHZKX9hZpfYQPbFRa3aMewmVdbpcp1HE51PlWYwFZ10DmV1BM
 fQYoLb3Tluvc/6WJPGbUYf/i4q7A3EKYr0mMwkfoTqneXFXf/LleMp38MUfHyPkudUCi 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pw5hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:45:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003Gd9db073658;
        Fri, 3 Jan 2020 16:45:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xa7ty856v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:45:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 003Gj8aC019501;
        Fri, 3 Jan 2020 16:45:08 GMT
Received: from Lirans-MBP.Home (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 08:45:07 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     csully@google.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     sagis@google.com, jonolson@google.com, yangchun@google.com,
        lrizzo@google.com, adisuresh@google.com, eric.dumazet@gmail.com,
        Liran Alon <liran.alon@oracle.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH v2] net: Google gve: Remove dma_wmb() before ringing doorbell
Date:   Fri,  3 Jan 2020 18:44:59 +0200
Message-Id: <20200103164459.71954-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code use dma_wmb() to ensure Rx/Tx descriptors are visible
to device before writing to doorbell.

However, these dma_wmb() are wrong and unnecessary. Therefore,
they should be removed.

iowrite32be() called from gve_rx_write_doorbell()/gve_tx_put_doorbell()
should guaratee that all previous writes to WB/UC memory is visible to
device before the write done by iowrite32be().

E.g. On ARM64, iowrite32be() calls __iowmb() which expands to dma_wmb()
and only then calls __raw_writel().

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 2 --
 drivers/net/ethernet/google/gve/gve_tx.c | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index edec61dfc868..9f52e72ff641 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -418,8 +418,6 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 	rx->cnt = cnt;
 	rx->fill_cnt += work_done;
 
-	/* restock desc ring slots */
-	dma_wmb();	/* Ensure descs are visible before ringing doorbell */
 	gve_rx_write_doorbell(priv, rx);
 	return gve_rx_work_pending(rx);
 }
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

