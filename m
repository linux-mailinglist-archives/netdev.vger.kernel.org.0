Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0716EF0E85
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfKFFvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:51:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfKFFvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:51:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA65mwbv140691;
        Wed, 6 Nov 2019 05:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=O6RlS+WPBCsPIuPvRLB+Lohj6XBlKZvtolQxhD7uG3s=;
 b=sZhsOvE8TGCzvjj58L4jfGUQhkCh/HLIicuAax71RC5ZeCBVuP8P+gn1RWvKdy/zOcIb
 jNLNMf0dmROpbOo/FJMMTGW63Ve0KjqKvjrHX+EixQzBc+zqZJlYTYTKvQTDzVxWjob3
 R8RvloBWi1V8pZ5vm7N2mKEFa7gPwpOizskfY2pmNgUb1bDtU/GArjhgvoGO4Gwy51PP
 Le76BJo3f+VYbEvaFSNgJF5nBvJqEVntWhnyHxwO0bCu97I/QqGSxY1BmD0fyyo/PW+X
 vUmGVMzU8kbt6XRY9vZo7XWBpLDAc7WTXgUfMGfan4r9cZTVZc4737e8YMemg3LkpcCL FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w11rq3bmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:51:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA65mQa4053122;
        Wed, 6 Nov 2019 05:51:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w333wmsmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:51:32 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA65pVnw014720;
        Wed, 6 Nov 2019 05:51:31 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 21:51:30 -0800
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     rain.1986.08.12@gmail.com, yanjun.zhu@oracle.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: [PATCHv5 1/1] net: forcedeth: add xmit_more support
Date:   Wed,  6 Nov 2019 01:01:11 -0500
Message-Id: <1573020071-10503-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060060
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060060
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
V4->V5: fix code style.
V3->V4: fix DMA mapping errors handler with xmit_more feature.
V2->V3: fix typo errors.
V1->V2: use the lower case label.
---
 drivers/net/ethernet/nvidia/forcedeth.c | 59 +++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 05d2b47..6b54cb3 100644
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
 
@@ -2259,7 +2265,10 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			u64_stats_update_begin(&np->swstats_tx_syncp);
 			nv_txrx_stats_inc(stat_tx_dropped);
 			u64_stats_update_end(&np->swstats_tx_syncp);
-			return NETDEV_TX_OK;
+
+			ret = NETDEV_TX_OK;
+
+			goto dma_error;
 		}
 		np->put_tx_ctx->dma_len = bcnt;
 		np->put_tx_ctx->dma_single = 1;
@@ -2305,7 +2314,10 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 				u64_stats_update_begin(&np->swstats_tx_syncp);
 				nv_txrx_stats_inc(stat_tx_dropped);
 				u64_stats_update_end(&np->swstats_tx_syncp);
-				return NETDEV_TX_OK;
+
+				ret = NETDEV_TX_OK;
+
+				goto dma_error;
 			}
 
 			np->put_tx_ctx->dma_len = bcnt;
@@ -2357,8 +2369,15 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	spin_unlock_irqrestore(&np->lock, flags);
 
-	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
-	return NETDEV_TX_OK;
+txkick:
+	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
+		u32 txrxctl_kick;
+dma_error:
+		txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
+		writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
+	}
+
+	return ret;
 }
 
 static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
@@ -2381,6 +2400,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 	struct nv_skb_map *start_tx_ctx = NULL;
 	struct nv_skb_map *tmp_tx_ctx = NULL;
 	unsigned long flags;
+	netdev_tx_t ret = NETDEV_TX_OK;
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
@@ -2396,7 +2416,13 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
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
 
@@ -2416,7 +2442,10 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 			u64_stats_update_begin(&np->swstats_tx_syncp);
 			nv_txrx_stats_inc(stat_tx_dropped);
 			u64_stats_update_end(&np->swstats_tx_syncp);
-			return NETDEV_TX_OK;
+
+			ret = NETDEV_TX_OK;
+
+			goto dma_error;
 		}
 		np->put_tx_ctx->dma_len = bcnt;
 		np->put_tx_ctx->dma_single = 1;
@@ -2463,7 +2492,10 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 				u64_stats_update_begin(&np->swstats_tx_syncp);
 				nv_txrx_stats_inc(stat_tx_dropped);
 				u64_stats_update_end(&np->swstats_tx_syncp);
-				return NETDEV_TX_OK;
+
+				ret = NETDEV_TX_OK;
+
+				goto dma_error;
 			}
 			np->put_tx_ctx->dma_len = bcnt;
 			np->put_tx_ctx->dma_single = 0;
@@ -2542,8 +2574,15 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 
 	spin_unlock_irqrestore(&np->lock, flags);
 
-	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
-	return NETDEV_TX_OK;
+txkick:
+	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
+		u32 txrxctl_kick;
+dma_error:
+		txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
+		writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
+	}
+
+	return ret;
 }
 
 static inline void nv_tx_flip_ownership(struct net_device *dev)
-- 
2.7.4

