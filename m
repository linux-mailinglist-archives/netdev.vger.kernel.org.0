Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612C1EF46B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 05:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbfKEETF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 23:19:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34060 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfKEETF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 23:19:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA54InT3067243;
        Tue, 5 Nov 2019 04:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=hcAq50x7GyS8NS7+myX6Bp6qr1nWHvv3C4o2RcESjH0=;
 b=sluc59YNKEFHdi3/FbPdjHjXl56nFAS581c5iQeaElokgvxiVnWEiY4K+rYivzBSemxP
 6QlQSYy/X7Kknuz7OyiBl699BLzuIv8dLjvtE84n4oMtd5mXUnHi5E2KugIrx0Nh35qn
 r/vCz2KaW4RHfr+3BrAhZYbYtPBgyjPiLJernuusXUmOsWZFr3E1rP9oCHmc4CUQ6TmG
 Ycqy0oNjnwxGwodeFh1qtLwkPYZfnbzOkbyJaPWCKytanZKdGbCd1HUvydnIupHf7vxl
 iVyPugE5zxLfvbq3ah33SLJgVaMEBuVreB6X447j4X4SQqZ51VJSgikfcNNcfeRrBWN/ zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rpufuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 04:18:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA54DUrn087547;
        Tue, 5 Nov 2019 04:16:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w3160hkaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 04:16:53 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA54GqGB031043;
        Tue, 5 Nov 2019 04:16:53 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 20:16:52 -0800
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     rain.1986.08.12@gmail.com, yanjun.zhu@oracle.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: [PATCHv4 1/1] net: forcedeth: add xmit_more support
Date:   Mon,  4 Nov 2019 23:26:41 -0500
Message-Id: <1572928001-6915-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050032
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for xmit_more based on the igb commit 6f19e12f6230
("igb: flush when in xmit_more mode and under descriptor pressure") and
commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
were made to igb to support this feature. The function netif_xmit_stopped
is called to check whether transmit queue on device is currently unable to
send to determine whether we must write the tail because we can add no
further buffers.

When normal packets and/or xmit_more packets fill up tx_desc, it is
necessary to trigger NIC tx reg.

Following the advice from David Miller and Jakub Kicinski, after the
xmit_more feature is added, the following scenario will occur.

         |
   xmit_more packets
         |
   DMA_MAPPING
         |
   DMA_MAPPING error check
         |
   xmit_more packets already in HW xmit queue
         |

In the above scenario, if DMA_MAPPING error occurrs, the xmit_more packets
already in HW xmit queue will also be dropped. This is different from the
behavior before xmit_more feature. So it is necessary to trigger NIC HW tx
reg in the above scenario.

To the non-xmit_more packets, the above scenario will not occur.

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
V3->V4: fix DMA mapping errors handler with xmit_more feature.
V2->V3: fix typo errors.
V1->V2: use the lower case label.
---
 drivers/net/ethernet/nvidia/forcedeth.c | 67 ++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 05d2b47..0d21ddd 100644
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
 
@@ -2259,7 +2265,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			u64_stats_update_begin(&np->swstats_tx_syncp);
 			nv_txrx_stats_inc(stat_tx_dropped);
 			u64_stats_update_end(&np->swstats_tx_syncp);
-			return NETDEV_TX_OK;
+
+			writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
+			       get_hwbase(dev) + NvRegTxRxControl);
+			ret = NETDEV_TX_OK;
+
+			goto dma_error;
 		}
 		np->put_tx_ctx->dma_len = bcnt;
 		np->put_tx_ctx->dma_single = 1;
@@ -2305,7 +2316,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 				u64_stats_update_begin(&np->swstats_tx_syncp);
 				nv_txrx_stats_inc(stat_tx_dropped);
 				u64_stats_update_end(&np->swstats_tx_syncp);
-				return NETDEV_TX_OK;
+
+				writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
+				       get_hwbase(dev) + NvRegTxRxControl);
+				ret = NETDEV_TX_OK;
+
+				goto dma_error;
 			}
 
 			np->put_tx_ctx->dma_len = bcnt;
@@ -2357,8 +2373,15 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
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
+dma_error:
+	return ret;
 }
 
 static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
@@ -2381,6 +2404,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 	struct nv_skb_map *start_tx_ctx = NULL;
 	struct nv_skb_map *tmp_tx_ctx = NULL;
 	unsigned long flags;
+	netdev_tx_t ret = NETDEV_TX_OK;
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
@@ -2396,7 +2420,13 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
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
 
@@ -2416,7 +2446,12 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 			u64_stats_update_begin(&np->swstats_tx_syncp);
 			nv_txrx_stats_inc(stat_tx_dropped);
 			u64_stats_update_end(&np->swstats_tx_syncp);
-			return NETDEV_TX_OK;
+
+			writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
+			       get_hwbase(dev) + NvRegTxRxControl);
+			ret = NETDEV_TX_OK;
+
+			goto dma_error;
 		}
 		np->put_tx_ctx->dma_len = bcnt;
 		np->put_tx_ctx->dma_single = 1;
@@ -2463,7 +2498,12 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 				u64_stats_update_begin(&np->swstats_tx_syncp);
 				nv_txrx_stats_inc(stat_tx_dropped);
 				u64_stats_update_end(&np->swstats_tx_syncp);
-				return NETDEV_TX_OK;
+
+				writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
+				       get_hwbase(dev) + NvRegTxRxControl);
+				ret = NETDEV_TX_OK;
+
+				goto dma_error;
 			}
 			np->put_tx_ctx->dma_len = bcnt;
 			np->put_tx_ctx->dma_single = 0;
@@ -2542,8 +2582,15 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 
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
+dma_error:
+	return ret;
 }
 
 static inline void nv_tx_flip_ownership(struct net_device *dev)
-- 
2.7.4

