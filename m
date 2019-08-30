Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07187A3247
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfH3I0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:26:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbfH3I0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 04:26:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U8NjcQ150022;
        Fri, 30 Aug 2019 08:26:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=gDlCtdZ8R+76Clg1vDPR8+nT4lPWOkqeAcmcZy96zJw=;
 b=giRWaYZt1D4ebul8q0g85S4LAz4icQApODAwNl2/epIji7dbs3cv4qYEXRl/izm7/bx6
 NK9CGhUKrTTKtTOS1Q1HnCOj2uHgsVV48Fqkwri3Vpf3DdCP9hmCMrOXnUGsCbCVOAn8
 L2nXHfku9w5UQ9YnnafJO0MbdHrZSRqAREtNzjLr0mtLA41SWLX5nKWS9cXHfTcucERf
 YQrxxxeZIza0z2JyuX4X1RM5PdNaUF22ndnJVeoDMfTqZcWiKFnNf5CJnnMbbPI9mjLa
 H03PICysEQpYjeN7CX2D+UnEVgWDIEjvIkWU+TZk6a8oUdWfGwA3bvHK63Jq5xHd01jy hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uq01m8378-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 08:26:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U8NtAA076387;
        Fri, 30 Aug 2019 08:26:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2upxaaw4xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 08:26:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7U8QSxu031024;
        Fri, 30 Aug 2019 08:26:28 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 01:26:27 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     yanjun.zhu@oracle.com, netdev@vger.kernel.org, davem@davemloft.net,
        nan.1986san@gmail.com
Subject: [PATCH 1/1] forcedeth: use per cpu to collect xmit/recv statistics
Date:   Fri, 30 Aug 2019 04:35:11 -0400
Message-Id: <1567154111-23315-2-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567154111-23315-1-git-send-email-yanjun.zhu@oracle.com>
References: <1567154111-23315-1-git-send-email-yanjun.zhu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300090
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing with a background iperf pushing 1Gbit/sec traffic and running
both ifconfig and netstat to collect statistics, some deadlocks occurred.

Ifconfig and netstat will call nv_get_stats64 to get software xmit/recv
statistics. In the commit f5d827aece36 ("forcedeth: implement
ndo_get_stats64() API"), the normal tx/rx variables is to collect tx/rx
statistics. The fix is to replace normal tx/rx variables with per
cpu 64-bit variable to collect xmit/recv statistics. The per cpu variable
will avoid deadlocks and provide fast efficient statistics updates.

In nv_probe, the per cpu variable is initialized. In nv_remove, this
per cpu variable is freed.

In xmit/recv process, this per cpu variable will be updated.

In nv_get_stats64, this per cpu variable on each cpu is added up. Then
the driver can get xmit/recv packets statistics.

A test runs for several days with this commit, the deadlocks disappear
and the performance is better.

Tested:
	- iperf SMP x86_64 ->
	Client connecting to 1.1.1.108, TCP port 5001
	TCP window size: 85.0 KByte (default)
	------------------------------------------------------------
	[  3] local 1.1.1.105 port 38888 connected with 1.1.1.108 port 5001
	[ ID] Interval       Transfer     Bandwidth
	[  3]  0.0-10.0 sec  1.10 GBytes   943 Mbits/sec

	ifconfig results:

	enp0s9    Link encap:Ethernet  HWaddr 00:21:28:6f:de:0f
		  inet addr:1.1.1.105  Bcast:0.0.0.0  Mask:255.255.255.0
		  UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
		  RX packets:5774764531 errors:0 dropped:0 overruns:0 frame:0
		  TX packets:633534193 errors:0 dropped:0 overruns:0 carrier:0
		  collisions:0 txqueuelen:1000
		  RX bytes:7646159340904 (7.6 TB) TX bytes:11425340407722 (11.4 TB)

	netstat results:

	Kernel Interface table
	Iface MTU Met RX-OK RX-ERR RX-DRP RX-OVR TX-OK TX-ERR TX-DRP TX-OVR Flg
	...
	enp0s9 1500 0  5774764531 0    0 0      633534193      0      0  0 BMRU
	...

Fixes: f5d827aece36 ("forcedeth: implement ndo_get_stats64() API")
CC: Joe Jin <joe.jin@oracle.com>
CC: JUNXIAO_BI <junxiao.bi@oracle.com>
Reported-and-tested-by: Nan san <nan.1986san@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 132 +++++++++++++++++++++-----------
 1 file changed, 88 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index b327b29..ee8bb9d 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -713,6 +713,21 @@ struct nv_skb_map {
 	struct nv_skb_map *next_tx_ctx;
 };
 
+struct nv_txrx_stats {
+	u64 stat_rx_packets;
+	u64 stat_rx_bytes; /* not always available in HW */
+	u64 stat_rx_missed_errors;
+	u64 stat_rx_dropped;
+	u64 stat_tx_packets; /* not always available in HW */
+	u64 stat_tx_bytes;
+	u64 stat_tx_dropped;
+};
+
+#define nv_txrx_stats_inc(member) \
+		__this_cpu_inc(np->txrx_stats->member)
+#define nv_txrx_stats_add(member, count) \
+		__this_cpu_add(np->txrx_stats->member, (count))
+
 /*
  * SMP locking:
  * All hardware access under netdev_priv(dev)->lock, except the performance
@@ -797,10 +812,7 @@ struct fe_priv {
 
 	/* RX software stats */
 	struct u64_stats_sync swstats_rx_syncp;
-	u64 stat_rx_packets;
-	u64 stat_rx_bytes; /* not always available in HW */
-	u64 stat_rx_missed_errors;
-	u64 stat_rx_dropped;
+	struct nv_txrx_stats __percpu *txrx_stats;
 
 	/* media detection workaround.
 	 * Locking: Within irq hander or disable_irq+spin_lock(&np->lock);
@@ -826,9 +838,6 @@ struct fe_priv {
 
 	/* TX software stats */
 	struct u64_stats_sync swstats_tx_syncp;
-	u64 stat_tx_packets; /* not always available in HW */
-	u64 stat_tx_bytes;
-	u64 stat_tx_dropped;
 
 	/* msi/msi-x fields */
 	u32 msi_flags;
@@ -1721,6 +1730,28 @@ static void nv_update_stats(struct net_device *dev)
 	}
 }
 
+static inline void nv_get_stats(int cpu, struct fe_priv *np,
+				struct rtnl_link_stats64 *storage)
+{
+	struct nv_txrx_stats *src = per_cpu_ptr(np->txrx_stats, cpu);
+	unsigned int syncp_start;
+
+	do {
+		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_rx_syncp);
+		storage->rx_packets       += src->stat_rx_packets;
+		storage->rx_bytes         += src->stat_rx_bytes;
+		storage->rx_dropped       += src->stat_rx_dropped;
+		storage->rx_missed_errors += src->stat_rx_missed_errors;
+	} while (u64_stats_fetch_retry_irq(&np->swstats_rx_syncp, syncp_start));
+
+	do {
+		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_tx_syncp);
+		storage->tx_packets += src->stat_tx_packets;
+		storage->tx_bytes   += src->stat_tx_bytes;
+		storage->tx_dropped += src->stat_tx_dropped;
+	} while (u64_stats_fetch_retry_irq(&np->swstats_tx_syncp, syncp_start));
+}
+
 /*
  * nv_get_stats64: dev->ndo_get_stats64 function
  * Get latest stats value from the nic.
@@ -1733,7 +1764,7 @@ nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
 	__releases(&netdev_priv(dev)->hwstats_lock)
 {
 	struct fe_priv *np = netdev_priv(dev);
-	unsigned int syncp_start;
+	int cpu;
 
 	/*
 	 * Note: because HW stats are not always available and for
@@ -1746,20 +1777,8 @@ nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
 	 */
 
 	/* software stats */
-	do {
-		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_rx_syncp);
-		storage->rx_packets       = np->stat_rx_packets;
-		storage->rx_bytes         = np->stat_rx_bytes;
-		storage->rx_dropped       = np->stat_rx_dropped;
-		storage->rx_missed_errors = np->stat_rx_missed_errors;
-	} while (u64_stats_fetch_retry_irq(&np->swstats_rx_syncp, syncp_start));
-
-	do {
-		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_tx_syncp);
-		storage->tx_packets = np->stat_tx_packets;
-		storage->tx_bytes   = np->stat_tx_bytes;
-		storage->tx_dropped = np->stat_tx_dropped;
-	} while (u64_stats_fetch_retry_irq(&np->swstats_tx_syncp, syncp_start));
+	for_each_online_cpu(cpu)
+		nv_get_stats(cpu, np, storage);
 
 	/* If the nic supports hw counters then retrieve latest values */
 	if (np->driver_data & DEV_HAS_STATISTICS_V123) {
@@ -1827,7 +1846,7 @@ static int nv_alloc_rx(struct net_device *dev)
 		} else {
 packet_dropped:
 			u64_stats_update_begin(&np->swstats_rx_syncp);
-			np->stat_rx_dropped++;
+			nv_txrx_stats_inc(stat_rx_dropped);
 			u64_stats_update_end(&np->swstats_rx_syncp);
 			return 1;
 		}
@@ -1869,7 +1888,7 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 		} else {
 packet_dropped:
 			u64_stats_update_begin(&np->swstats_rx_syncp);
-			np->stat_rx_dropped++;
+			nv_txrx_stats_inc(stat_rx_dropped);
 			u64_stats_update_end(&np->swstats_rx_syncp);
 			return 1;
 		}
@@ -2013,7 +2032,7 @@ static void nv_drain_tx(struct net_device *dev)
 		}
 		if (nv_release_txskb(np, &np->tx_skb[i])) {
 			u64_stats_update_begin(&np->swstats_tx_syncp);
-			np->stat_tx_dropped++;
+			nv_txrx_stats_inc(stat_tx_dropped);
 			u64_stats_update_end(&np->swstats_tx_syncp);
 		}
 		np->tx_skb[i].dma = 0;
@@ -2227,7 +2246,7 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			/* on DMA mapping error - drop the packet */
 			dev_kfree_skb_any(skb);
 			u64_stats_update_begin(&np->swstats_tx_syncp);
-			np->stat_tx_dropped++;
+			nv_txrx_stats_inc(stat_tx_dropped);
 			u64_stats_update_end(&np->swstats_tx_syncp);
 			return NETDEV_TX_OK;
 		}
@@ -2273,7 +2292,7 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 				dev_kfree_skb_any(skb);
 				np->put_tx_ctx = start_tx_ctx;
 				u64_stats_update_begin(&np->swstats_tx_syncp);
-				np->stat_tx_dropped++;
+				nv_txrx_stats_inc(stat_tx_dropped);
 				u64_stats_update_end(&np->swstats_tx_syncp);
 				return NETDEV_TX_OK;
 			}
@@ -2384,7 +2403,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 			/* on DMA mapping error - drop the packet */
 			dev_kfree_skb_any(skb);
 			u64_stats_update_begin(&np->swstats_tx_syncp);
-			np->stat_tx_dropped++;
+			nv_txrx_stats_inc(stat_tx_dropped);
 			u64_stats_update_end(&np->swstats_tx_syncp);
 			return NETDEV_TX_OK;
 		}
@@ -2431,7 +2450,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 				dev_kfree_skb_any(skb);
 				np->put_tx_ctx = start_tx_ctx;
 				u64_stats_update_begin(&np->swstats_tx_syncp);
-				np->stat_tx_dropped++;
+				nv_txrx_stats_inc(stat_tx_dropped);
 				u64_stats_update_end(&np->swstats_tx_syncp);
 				return NETDEV_TX_OK;
 			}
@@ -2560,9 +2579,12 @@ static int nv_tx_done(struct net_device *dev, int limit)
 					    && !(flags & NV_TX_RETRYCOUNT_MASK))
 						nv_legacybackoff_reseed(dev);
 				} else {
+					unsigned int len;
+
 					u64_stats_update_begin(&np->swstats_tx_syncp);
-					np->stat_tx_packets++;
-					np->stat_tx_bytes += np->get_tx_ctx->skb->len;
+					nv_txrx_stats_inc(stat_tx_packets);
+					len = np->get_tx_ctx->skb->len;
+					nv_txrx_stats_add(stat_tx_bytes, len);
 					u64_stats_update_end(&np->swstats_tx_syncp);
 				}
 				bytes_compl += np->get_tx_ctx->skb->len;
@@ -2577,9 +2599,12 @@ static int nv_tx_done(struct net_device *dev, int limit)
 					    && !(flags & NV_TX2_RETRYCOUNT_MASK))
 						nv_legacybackoff_reseed(dev);
 				} else {
+					unsigned int len;
+
 					u64_stats_update_begin(&np->swstats_tx_syncp);
-					np->stat_tx_packets++;
-					np->stat_tx_bytes += np->get_tx_ctx->skb->len;
+					nv_txrx_stats_inc(stat_tx_packets);
+					len = np->get_tx_ctx->skb->len;
+					nv_txrx_stats_add(stat_tx_bytes, len);
 					u64_stats_update_end(&np->swstats_tx_syncp);
 				}
 				bytes_compl += np->get_tx_ctx->skb->len;
@@ -2627,9 +2652,12 @@ static int nv_tx_done_optimized(struct net_device *dev, int limit)
 						nv_legacybackoff_reseed(dev);
 				}
 			} else {
+				unsigned int len;
+
 				u64_stats_update_begin(&np->swstats_tx_syncp);
-				np->stat_tx_packets++;
-				np->stat_tx_bytes += np->get_tx_ctx->skb->len;
+				nv_txrx_stats_inc(stat_tx_packets);
+				len = np->get_tx_ctx->skb->len;
+				nv_txrx_stats_add(stat_tx_bytes, len);
 				u64_stats_update_end(&np->swstats_tx_syncp);
 			}
 
@@ -2806,6 +2834,15 @@ static int nv_getlen(struct net_device *dev, void *packet, int datalen)
 	}
 }
 
+static inline void rx_missing_handler(u32 flags, struct fe_priv *np)
+{
+	if (flags & NV_RX_MISSEDFRAME) {
+		u64_stats_update_begin(&np->swstats_rx_syncp);
+		nv_txrx_stats_inc(stat_rx_missed_errors);
+		u64_stats_update_end(&np->swstats_rx_syncp);
+	}
+}
+
 static int nv_rx_process(struct net_device *dev, int limit)
 {
 	struct fe_priv *np = netdev_priv(dev);
@@ -2848,11 +2885,7 @@ static int nv_rx_process(struct net_device *dev, int limit)
 					}
 					/* the rest are hard errors */
 					else {
-						if (flags & NV_RX_MISSEDFRAME) {
-							u64_stats_update_begin(&np->swstats_rx_syncp);
-							np->stat_rx_missed_errors++;
-							u64_stats_update_end(&np->swstats_rx_syncp);
-						}
+						rx_missing_handler(flags, np);
 						dev_kfree_skb(skb);
 						goto next_pkt;
 					}
@@ -2896,8 +2929,8 @@ static int nv_rx_process(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&np->napi, skb);
 		u64_stats_update_begin(&np->swstats_rx_syncp);
-		np->stat_rx_packets++;
-		np->stat_rx_bytes += len;
+		nv_txrx_stats_inc(stat_rx_packets);
+		nv_txrx_stats_add(stat_rx_bytes, len);
 		u64_stats_update_end(&np->swstats_rx_syncp);
 next_pkt:
 		if (unlikely(np->get_rx.orig++ == np->last_rx.orig))
@@ -2982,8 +3015,8 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 			}
 			napi_gro_receive(&np->napi, skb);
 			u64_stats_update_begin(&np->swstats_rx_syncp);
-			np->stat_rx_packets++;
-			np->stat_rx_bytes += len;
+			nv_txrx_stats_inc(stat_rx_packets);
+			nv_txrx_stats_add(stat_rx_bytes, len);
 			u64_stats_update_end(&np->swstats_rx_syncp);
 		} else {
 			dev_kfree_skb(skb);
@@ -5651,6 +5684,12 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	SET_NETDEV_DEV(dev, &pci_dev->dev);
 	u64_stats_init(&np->swstats_rx_syncp);
 	u64_stats_init(&np->swstats_tx_syncp);
+	np->txrx_stats = alloc_percpu(struct nv_txrx_stats);
+	if (!np->txrx_stats) {
+		pr_err("np->txrx_stats, alloc memory error.\n");
+		err = -ENOMEM;
+		goto out_alloc_percpu;
+	}
 
 	timer_setup(&np->oom_kick, nv_do_rx_refill, 0);
 	timer_setup(&np->nic_poll, nv_do_nic_poll, 0);
@@ -6060,6 +6099,8 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 out_disable:
 	pci_disable_device(pci_dev);
 out_free:
+	free_percpu(np->txrx_stats);
+out_alloc_percpu:
 	free_netdev(dev);
 out:
 	return err;
@@ -6105,6 +6146,9 @@ static void nv_restore_mac_addr(struct pci_dev *pci_dev)
 static void nv_remove(struct pci_dev *pci_dev)
 {
 	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct fe_priv *np = netdev_priv(dev);
+
+	free_percpu(np->txrx_stats);
 
 	unregister_netdev(dev);
 
-- 
2.7.4

