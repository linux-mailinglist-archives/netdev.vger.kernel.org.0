Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4FFE7ED7
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 04:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfJ2DXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 23:23:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbfJ2DXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 23:23:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T3JWiF177200;
        Tue, 29 Oct 2019 03:22:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=1gMN7XpFdn//+OSv8RfjdGsM0W4lCXtPtQmL7v/v18k=;
 b=ebzmx2lW9kpISPH2JqsMJt3iZ/Rg7PQD9u7ugm2hIxmlpm0rI8jq/K0sZi/nQpsbvmv6
 y++nyfLQHaPSTsa33h7hVY0pACa83HhQ158mm+4bRBD/XHr+hd6YLIEkQxGPh/j9kYUY
 mKNJjLyOZ+PpchV0oKhDX4pz09KNzL/nvSEL7YPFB6kqpMEf1y0CNyf4uUK40E7r4OrU
 ADkZ6iRSs064aWgzf9h88fL1D2am/EonQM4rgzpPShJBcicciLWNk9M1fpUnJWZpMTU2
 nVnfzdNouI1KNRpeAyoYPpsQy2yhQDJGgvfVlDw5OijlSBEQ1adJlVsang1xgHTy5u+P yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vvdju63ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 03:22:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T3JRTJ018071;
        Tue, 29 Oct 2019 03:20:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vvyn0wx6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 03:20:52 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9T3KoO4001185;
        Tue, 29 Oct 2019 03:20:50 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 20:20:50 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     rain.1986.08.12@gmail.com, yanjun.zhu@oracle.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHv3 1/1] net: forcedeth: add xmit_more support
Date:   Mon, 28 Oct 2019 23:30:12 -0400
Message-Id: <1572319812-27196-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for xmit_more based on the igb commit 6f19e12f6230
("igb: flush when in xmit_more mode and under descriptor pressure") and
commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
were made to igb to support this feature. The function netif_xmit_stopped
is called to check whether transmit queue on device is currently unable to
send to determine whether we must write the tail because we can add no further
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
Acked-by: Rain River <rain.1986.08.12@gmail.com>
---
V2->V3: fix typo errors.
V1->V2: use the lower case label.
---
 drivers/net/ethernet/nvidia/forcedeth.c | 37 +++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 05d2b47..e2bb0cd 100644
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
+		goto txkick;
 	}
 	spin_unlock_irqrestore(&np->lock, flags);
 
@@ -2357,8 +2363,14 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	spin_unlock_irqrestore(&np->lock, flags);
 
-	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
-	return NETDEV_TX_OK;
+txkick:
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
+		goto txkick;
 	}
 	spin_unlock_irqrestore(&np->lock, flags);
 
@@ -2542,8 +2561,14 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 
 	spin_unlock_irqrestore(&np->lock, flags);
 
-	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
-	return NETDEV_TX_OK;
+txkick:
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

