Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78363DC1D3
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633145AbfJRJwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:52:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46322 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633084AbfJRJwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 05:52:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I9nLF9084030;
        Fri, 18 Oct 2019 09:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=TE1BIgxI+pY3uvViMy7xm5m9gPqkn2EXSwdvJNzf3Yc=;
 b=Vd6eKZm+F3zm5jXH8QWxcEis4hmpLrCwHTa0FqBuv38IU23rDONfkBNJZxv6mwR2ujZS
 fN38PJ7FXmcuaWUuKIpiGM+L2oGmkO5bnKMSf7jWAC0NjQfCiRT88doOnllxTqlhlUki
 ZqnROtezHuYAPybP+gCufV4+d61jNO45BaG7NfmkzupR++hBHwQ+2mmn0+DcQiuRSOdN
 VUgaZY5j9XzpMGj+FgjQrLELcgyzT7vroEIsUaZlj7dAi6MS5R+sRl2ifqakB6Rj7NLZ
 SW8snobq3yC7h1LFXylZNi8u/7RTpCVHsifIMox849j9y+1bLCdpge1c91avO/Ntm1zS xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vq0q42tkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 09:52:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I9msRn003050;
        Fri, 18 Oct 2019 09:52:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vq0ew0g4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 09:52:08 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9I9q7eJ020689;
        Fri, 18 Oct 2019 09:52:07 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 09:52:06 +0000
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     rain.1986.08.12@gmail.com, yanjun.zhu@oracle.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH] net: forcedeth: add xmit_more support
Date:   Fri, 18 Oct 2019 06:01:25 -0400
Message-Id: <1571392885-32706-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for xmit_more based on the igb commit 6f19e12f6230
("igb: flush when in xmit_more mode and under descriptor pressure") and
commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
were made to igb to support this feature. The function netif_xmit_stopped
is called to check if transmit queue on device is currently unable to send
to determine if we must write the tail because we can add no further
buffers.
When normal packets and/or xmit_more packets fill up tx_desc, it is
necessary to trigger NIC tx reg.

Tested:
  - pktgen (xmit_more packets) SMP x86_64 ->
    Test command:
    ./pktgen_sample03_burst_single_flow.sh ... -b 8 -n 1000000
    Test results:
    Params:
    ...
    burst: 8
    ...
    Result: OK: 12194004(c12188996+d5007) usec, 1000001 (1500byte,0frags)
    82007pps 984Mb/sec (984084000bps) errors: 0

  - iperf (normal packets) SMP x86_64 ->
    Test command:
    Server: iperf -s
    Client: iperf -c serverip
    Result:
    TCP window size: 85.0 KByte (default)
    ------------------------------------------------------------
    [ ID] Interval       Transfer     Bandwidth
    [  3]  0.0-10.0 sec  1.10 GBytes   942 Mbits/sec

CC: Joe Jin <joe.jin@oracle.com>
CC: JUNXIAO_BI <junxiao.bi@oracle.com>
Reported-and-tested-by: Nan san <nan.1986san@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 37 +++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 05d2b47..7417bac 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -2225,6 +2225,7 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct nv_skb_map *prev_tx_ctx;
 	struct nv_skb_map *tmp_tx_ctx = NULL, *start_tx_ctx = NULL;
 	unsigned long flags;
+	netdev_tx_t ret = NETDEV_TX_OK;
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
@@ -2240,7 +2241,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_stop_queue(dev);
 		np->tx_stop = 1;
 		spin_unlock_irqrestore(&np->lock, flags);
-		return NETDEV_TX_BUSY;
+
+		/* When normal packets and/or xmit_more packets fill up
+		 * tx_desc, it is necessary to trigger NIC tx reg.
+		 */
+		ret = NETDEV_TX_BUSY;
+		goto TXKICK;
 	}
 	spin_unlock_irqrestore(&np->lock, flags);
 
@@ -2357,8 +2363,14 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	spin_unlock_irqrestore(&np->lock, flags);
 
-	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
-	return NETDEV_TX_OK;
+TXKICK:
+	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
+		u32 txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
+
+		writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
+	}
+
+	return ret;
 }
 
 static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
@@ -2381,6 +2393,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 	struct nv_skb_map *start_tx_ctx = NULL;
 	struct nv_skb_map *tmp_tx_ctx = NULL;
 	unsigned long flags;
+	netdev_tx_t ret = NETDEV_TX_OK;
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
@@ -2396,7 +2409,13 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 		netif_stop_queue(dev);
 		np->tx_stop = 1;
 		spin_unlock_irqrestore(&np->lock, flags);
-		return NETDEV_TX_BUSY;
+
+		/* When normal packets and/or xmit_more packets fill up
+		 * tx_desc, it is necessary to trigger NIC tx reg.
+		 */
+		ret = NETDEV_TX_BUSY;
+
+		goto TXKICK;
 	}
 	spin_unlock_irqrestore(&np->lock, flags);
 
@@ -2542,8 +2561,14 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 
 	spin_unlock_irqrestore(&np->lock, flags);
 
-	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
-	return NETDEV_TX_OK;
+TXKICK:
+	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
+		u32 txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
+
+		writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
+	}
+
+	return ret;
 }
 
 static inline void nv_tx_flip_ownership(struct net_device *dev)
-- 
2.7.4

