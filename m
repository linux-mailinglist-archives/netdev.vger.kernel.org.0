Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5B2B0D7E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgKLTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:10:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726787AbgKLTKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:35 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ1W7c036357;
        Thu, 12 Nov 2020 14:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Kk8qrjyiN0intXkSBEOfW+fMOmwdPhSlfEWoRNX9n+E=;
 b=q62oLFTlam313qRttn752GCXROSkP+O9RXZoCc3QJlchoVBIF9rD1Lkrqn5HhoT2qeCP
 3axNl6phFrsGEIUB4bMOY5V0dsCI78pDp6uZlzUXeTyxFs99RfXby4UsLosGLHTYOdZC
 agdVGmQfj9fFOEwEzV1vtHPXLkU+RjFP+C6JwyMCktf+O2L+G5VzDy8lbSBXFM0lc5ZL
 vLejWJ1jmeTklWvM3G3HtCRl5R2sVTnM+WBYC8YuLwwI8p186NZXv6FM/hPC5mTDUMAY
 Lcoyrg0PgJDf8rNqgNWeMQQ3LvpVOVx8QpyZGf2OXR2l9tzeyGY4DCEllAoipr/M6Te6 eA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34s8x9utcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:32 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ7UA2030897;
        Thu, 12 Nov 2020 19:10:31 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 34nk7a831b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:31 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJATkG56295860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:29 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7C49AE06A;
        Thu, 12 Nov 2020 19:10:28 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BADBAAE079;
        Thu, 12 Nov 2020 19:10:27 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:27 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 07/12] ibmvnic: Clean up TX error handling and statistics tracking
Date:   Thu, 12 Nov 2020 13:10:02 -0600
Message-Id: <1605208207-1896-8-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_09:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=3
 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update error handling code in ibmvnic_xmit to be more readable
and remove unused statistics counters. Also record statistics
when TX completions are received to improve accuracy.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 38 ++++++++++--------------------
 drivers/net/ethernet/ibm/ibmvnic.h |  2 --
 2 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b523da20bffc..2c24d4774457 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1535,13 +1535,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct ibmvnic_tx_buff *tx_buff = NULL;
 	struct ibmvnic_sub_crq_queue *tx_scrq;
 	struct ibmvnic_tx_pool *tx_pool;
-	unsigned int tx_send_failed = 0;
 	netdev_tx_t ret = NETDEV_TX_OK;
-	unsigned int tx_map_failed = 0;
 	union sub_crq indir_arr[16];
 	unsigned int tx_dropped = 0;
-	unsigned int tx_packets = 0;
-	unsigned int tx_bytes = 0;
 	dma_addr_t data_dma_addr;
 	struct netdev_queue *txq;
 	unsigned long lpar_rc;
@@ -1558,18 +1554,13 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		if (!netif_subqueue_stopped(netdev, skb))
 			netif_stop_subqueue(netdev, queue_num);
 		dev_kfree_skb_any(skb);
-
-		tx_send_failed++;
 		tx_dropped++;
-		ret = NETDEV_TX_OK;
-		goto out;
+		goto err_out;
 	}
 
 	if (ibmvnic_xmit_workarounds(skb, netdev)) {
 		tx_dropped++;
-		tx_send_failed++;
-		ret = NETDEV_TX_OK;
-		goto out;
+		goto err_out;
 	}
 	if (skb_is_gso(skb))
 		tx_pool = &adapter->tso_pool[queue_num];
@@ -1584,10 +1575,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	if (index == IBMVNIC_INVALID_MAP) {
 		dev_kfree_skb_any(skb);
-		tx_send_failed++;
 		tx_dropped++;
-		ret = NETDEV_TX_OK;
-		goto out;
+		goto err_out;
 	}
 
 	tx_pool->free_map[tx_pool->consumer_index] = IBMVNIC_INVALID_MAP;
@@ -1707,12 +1696,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		netif_stop_subqueue(netdev, queue_num);
 	}
 
-	tx_packets++;
-	tx_bytes += skb->len;
 	txq->trans_start = jiffies;
-	ret = NETDEV_TX_OK;
-	goto out;
 
+	return ret;
 tx_flush_err:
 	dev_kfree_skb_any(skb);
 	tx_buff->skb = NULL;
@@ -1758,14 +1744,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		netif_tx_stop_all_queues(netdev);
 		netif_carrier_off(netdev);
 	}
-out:
+err_out:
 	netdev->stats.tx_dropped += tx_dropped;
-	netdev->stats.tx_bytes += tx_bytes;
-	netdev->stats.tx_packets += tx_packets;
-	adapter->tx_send_failed += tx_send_failed;
-	adapter->tx_map_failed += tx_map_failed;
-	adapter->tx_stats_buffers[queue_num].packets += tx_packets;
-	adapter->tx_stats_buffers[queue_num].bytes += tx_bytes;
 	adapter->tx_stats_buffers[queue_num].dropped_packets += tx_dropped;
 
 	return ret;
@@ -3147,6 +3127,7 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		int num_entries = 0;
 		int total_bytes = 0;
 		int num_packets = 0;
+		int tx_dropped = 0;
 
 		next = ibmvnic_next_scrq(adapter, scrq);
 		/* ensure that we are reading the correct queue entry */
@@ -3157,6 +3138,7 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 			if (next->tx_comp.rcs[i]) {
 				dev_err(dev, "tx error %x\n",
 					next->tx_comp.rcs[i]);
+				tx_dropped++;
 				error = true;
 			}
 			index = be32_to_cpu(next->tx_comp.correlators[i]);
@@ -3200,6 +3182,12 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 			netdev_dbg(adapter->netdev, "Started queue %d\n",
 				   scrq->pool_index);
 		}
+		adapter->netdev->stats.tx_packets += num_packets;
+		adapter->netdev->stats.tx_bytes += total_bytes;
+		adapter->netdev->stats.tx_dropped += tx_dropped;
+		adapter->tx_stats_buffers[scrq->pool_index].packets += num_packets;
+		adapter->tx_stats_buffers[scrq->pool_index].bytes += total_bytes;
+		adapter->tx_stats_buffers[scrq->pool_index].dropped_packets += tx_dropped;
 	}
 
 	enable_scrq_irq(adapter, scrq);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 11af1f29210b..c6f1842d2023 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -992,8 +992,6 @@ struct ibmvnic_adapter {
 	int replenish_add_buff_success;
 	int replenish_add_buff_failure;
 	int replenish_task_cycles;
-	int tx_send_failed;
-	int tx_map_failed;
 
 	struct ibmvnic_tx_queue_stats *tx_stats_buffers;
 	struct ibmvnic_rx_queue_stats *rx_stats_buffers;
-- 
2.26.2

