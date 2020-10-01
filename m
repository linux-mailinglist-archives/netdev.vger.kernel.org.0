Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370492804CB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733009AbgJARMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:12:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732910AbgJARMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:12:00 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H21qe089515;
        Thu, 1 Oct 2020 13:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=bi4Lyk6A+kPts/aPlMZRuCO3qZtamJS10WCbkTjTENk=;
 b=C5wsEupWjfo8pRogtEqhcNm6QPIl5gEhAcgrRjdqiip7yH5jPTF7KvvDMNw5wuBS1DCi
 D0mfgedPCrYPgLiKWe/Nvg/rnErXGb08U9DsTXx6LkgtG5IAePacW8T7BsH44oEeWrbj
 oqo20XnKq+iYV63weZCifOcZgjgzObGophA30gjvUrpZRQ5yXplGbj6dTR+oIxal4PpN
 Sfwmp1cTu5gf52C7a8TDi7jUhwKU6dCgjns2W8O7AsiD4PZfTu3v0roc6DdYl1mHQh3H
 y/qGidUaobIPXIOzYeoeOsL8edtYTF2jA5oRZz2hoN7J+K99yVneFW/5teBidU3psh/R qg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33wg4cr3ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:50 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H2LWA014293;
        Thu, 1 Oct 2020 17:11:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 33svwgu1ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBgB424052198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AC6AA404D;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1471DA4055;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/7] s390/qeth: keep track of wanted TX queues
Date:   Thu,  1 Oct 2020 19:11:30 +0200
Message-Id: <20201001171136.46830-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001171136.46830-1-jwi@linux.ibm.com>
References: <20201001171136.46830-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_05:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 suspectscore=2 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010010139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When re-initializing a device, we can hit a situation where
qeth_osa_set_output_queues() detects that it supports more or less
HW TX queues than before. Right now we adjust dev->real_num_tx_queues
from right there, but
1. it's getting more & more complicated to cover all cases, and
2. we can't re-enable the actually expected number of TX queues later
because we lost the needed information.

So keep track of the wanted TX queues (on initial setup, and whenever
its changed via .set_channels), and later use that information when
re-enabling the netdevice.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 11 ++++-
 drivers/s390/net/qeth_core_main.c | 70 +++++++++++++------------------
 drivers/s390/net/qeth_ethtool.c   |  8 +++-
 drivers/s390/net/qeth_l2_main.c   | 14 ++++---
 drivers/s390/net/qeth_l3_main.c   | 12 ++++--
 5 files changed, 61 insertions(+), 54 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f321eabefbe4..f1c9a694873e 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -538,7 +538,7 @@ struct qeth_qdio_info {
 	int in_buf_size;
 
 	/* output */
-	int no_out_queues;
+	unsigned int no_out_queues;
 	struct qeth_qdio_out_q *out_qs[QETH_MAX_OUT_QUEUES];
 	struct qdio_outbuf_state *out_bufstates;
 
@@ -788,6 +788,7 @@ struct qeth_switch_info {
 
 struct qeth_priv {
 	unsigned int rx_copybreak;
+	unsigned int tx_wanted_queues;
 	u32 brport_hw_features;
 	u32 brport_features;
 };
@@ -873,6 +874,13 @@ struct qeth_trap_id {
 /*some helper functions*/
 #define QETH_CARD_IFNAME(card) (((card)->dev)? (card)->dev->name : "")
 
+static inline unsigned int qeth_tx_actual_queues(struct qeth_card *card)
+{
+	struct qeth_priv *priv = netdev_priv(card->dev);
+
+	return min(priv->tx_wanted_queues, card->qdio.no_out_queues);
+}
+
 static inline u16 qeth_iqd_translate_txq(struct net_device *dev, u16 txq)
 {
 	if (txq == QETH_IQD_MCAST_TXQ)
@@ -1087,7 +1095,6 @@ void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
 int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
-int qeth_setup_netdev(struct qeth_card *card);
 int qeth_set_features(struct net_device *, netdev_features_t);
 void qeth_enable_hw_features(struct net_device *dev);
 netdev_features_t qeth_fix_features(struct net_device *, netdev_features_t);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index fc2c3db9259f..b61078b27562 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1511,23 +1511,12 @@ static void qeth_drain_output_queues(struct qeth_card *card)
 	}
 }
 
-static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
+static void qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 {
 	unsigned int max = single ? 1 : card->dev->num_tx_queues;
-	unsigned int count;
-	int rc;
-
-	count = IS_VM_NIC(card) ? min(max, card->dev->real_num_tx_queues) : max;
-
-	rtnl_lock();
-	rc = netif_set_real_num_tx_queues(card->dev, count);
-	rtnl_unlock();
-
-	if (rc)
-		return rc;
 
 	if (card->qdio.no_out_queues == max)
-		return 0;
+		return;
 
 	if (atomic_read(&card->qdio.state) != QETH_QDIO_UNINITIALIZED)
 		qeth_free_qdio_queues(card);
@@ -1536,14 +1525,12 @@ static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 		dev_info(&card->gdev->dev, "Priority Queueing not supported\n");
 
 	card->qdio.no_out_queues = max;
-	return 0;
 }
 
 static int qeth_update_from_chp_desc(struct qeth_card *card)
 {
 	struct ccw_device *ccwdev;
 	struct channel_path_desc_fmt0 *chp_dsc;
-	int rc = 0;
 
 	QETH_CARD_TEXT(card, 2, "chp_desc");
 
@@ -1556,12 +1543,12 @@ static int qeth_update_from_chp_desc(struct qeth_card *card)
 
 	if (IS_OSD(card) || IS_OSX(card))
 		/* CHPP field bit 6 == 1 -> single queue */
-		rc = qeth_osa_set_output_queues(card, chp_dsc->chpp & 0x02);
+		qeth_osa_set_output_queues(card, chp_dsc->chpp & 0x02);
 
 	kfree(chp_dsc);
 	QETH_CARD_TEXT_(card, 2, "nr:%x", card->qdio.no_out_queues);
 	QETH_CARD_TEXT_(card, 2, "lvl:%02x", card->info.func_level);
-	return rc;
+	return 0;
 }
 
 static void qeth_init_qdio_info(struct qeth_card *card)
@@ -5316,6 +5303,20 @@ static int qeth_set_online(struct qeth_card *card)
 
 	qeth_print_status_message(card);
 
+	if (card->dev->reg_state != NETREG_REGISTERED) {
+		struct qeth_priv *priv = netdev_priv(card->dev);
+
+		if (IS_IQD(card))
+			priv->tx_wanted_queues = QETH_IQD_MIN_TXQ;
+		else if (IS_VM_NIC(card))
+			priv->tx_wanted_queues = 1;
+		else
+			priv->tx_wanted_queues = card->dev->num_tx_queues;
+
+		/* no need for locking / error handling at this early stage: */
+		qeth_set_real_num_tx_queues(card, qeth_tx_actual_queues(card));
+	}
+
 	rc = card->discipline->set_online(card, carrier_ok);
 	if (rc)
 		goto err_online;
@@ -6250,8 +6251,16 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 	SET_NETDEV_DEV(dev, &card->gdev->dev);
 	netif_carrier_off(dev);
 
-	dev->ethtool_ops = IS_OSN(card) ? &qeth_osn_ethtool_ops :
-					  &qeth_ethtool_ops;
+	if (IS_OSN(card)) {
+		dev->ethtool_ops = &qeth_osn_ethtool_ops;
+	} else {
+		dev->ethtool_ops = &qeth_ethtool_ops;
+		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+		dev->hw_features |= NETIF_F_SG;
+		dev->vlan_features |= NETIF_F_SG;
+		if (IS_IQD(card))
+			dev->features |= NETIF_F_SG;
+	}
 
 	return dev;
 }
@@ -6267,28 +6276,6 @@ struct net_device *qeth_clone_netdev(struct net_device *orig)
 	return clone;
 }
 
-int qeth_setup_netdev(struct qeth_card *card)
-{
-	struct net_device *dev = card->dev;
-	unsigned int num_tx_queues;
-
-	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->hw_features |= NETIF_F_SG;
-	dev->vlan_features |= NETIF_F_SG;
-
-	if (IS_IQD(card)) {
-		dev->features |= NETIF_F_SG;
-		num_tx_queues = QETH_IQD_MIN_TXQ;
-	} else if (IS_VM_NIC(card)) {
-		num_tx_queues = 1;
-	} else {
-		num_tx_queues = dev->real_num_tx_queues;
-	}
-
-	return qeth_set_real_num_tx_queues(card, num_tx_queues);
-}
-EXPORT_SYMBOL_GPL(qeth_setup_netdev);
-
 static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card;
@@ -6959,6 +6946,7 @@ int qeth_set_real_num_tx_queues(struct qeth_card *card, unsigned int count)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(qeth_set_real_num_tx_queues);
 
 u16 qeth_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
 			  u8 cast_type, struct net_device *sb_dev)
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index f870c5322bfe..bc3ea0efb58b 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -211,7 +211,9 @@ static void qeth_get_channels(struct net_device *dev,
 static int qeth_set_channels(struct net_device *dev,
 			     struct ethtool_channels *channels)
 {
+	struct qeth_priv *priv = netdev_priv(dev);
 	struct qeth_card *card = dev->ml_priv;
+	int rc;
 
 	if (channels->rx_count == 0 || channels->tx_count == 0)
 		return -EINVAL;
@@ -234,7 +236,11 @@ static int qeth_set_channels(struct net_device *dev,
 			return -EOPNOTSUPP;
 	}
 
-	return qeth_set_real_num_tx_queues(card, channels->tx_count);
+	rc = qeth_set_real_num_tx_queues(card, channels->tx_count);
+	if (!rc)
+		priv->tx_wanted_queues = channels->tx_count;
+
+	return rc;
 }
 
 static int qeth_get_ts_info(struct net_device *dev,
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 1852d0a3c10a..290389fc7e79 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -894,18 +894,12 @@ static const struct net_device_ops qeth_osn_netdev_ops = {
 
 static int qeth_l2_setup_netdev(struct qeth_card *card)
 {
-	int rc;
-
 	if (IS_OSN(card)) {
 		card->dev->netdev_ops = &qeth_osn_netdev_ops;
 		card->dev->flags |= IFF_NOARP;
 		goto add_napi;
 	}
 
-	rc = qeth_setup_netdev(card);
-	if (rc)
-		return rc;
-
 	card->dev->needed_headroom = sizeof(struct qeth_hdr);
 	card->dev->netdev_ops = &qeth_l2_netdev_ops;
 	card->dev->priv_flags |= IFF_UNICAST_FLT;
@@ -2274,6 +2268,13 @@ static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
 			netif_carrier_on(dev);
 	} else {
 		rtnl_lock();
+		rc = qeth_set_real_num_tx_queues(card,
+						 qeth_tx_actual_queues(card));
+		if (rc) {
+			rtnl_unlock();
+			goto err_set_queues;
+		}
+
 		if (carrier_ok)
 			netif_carrier_on(dev);
 		else
@@ -2291,6 +2292,7 @@ static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
 	}
 	return 0;
 
+err_set_queues:
 err_setup:
 	qeth_set_allowed_threads(card, 0, 1);
 	card->state = CARD_STATE_DOWN;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index a6f8878b55c6..ea5f25857aff 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1875,10 +1875,6 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 	unsigned int headroom;
 	int rc;
 
-	rc = qeth_setup_netdev(card);
-	if (rc)
-		return rc;
-
 	if (IS_OSD(card) || IS_OSX(card)) {
 		card->dev->netdev_ops = &qeth_l3_osa_netdev_ops;
 
@@ -2022,6 +2018,13 @@ static int qeth_l3_set_online(struct qeth_card *card, bool carrier_ok)
 			netif_carrier_on(dev);
 	} else {
 		rtnl_lock();
+		rc = qeth_set_real_num_tx_queues(card,
+						 qeth_tx_actual_queues(card));
+		if (rc) {
+			rtnl_unlock();
+			goto err_set_queues;
+		}
+
 		if (carrier_ok)
 			netif_carrier_on(dev);
 		else
@@ -2038,6 +2041,7 @@ static int qeth_l3_set_online(struct qeth_card *card, bool carrier_ok)
 	}
 	return 0;
 
+err_set_queues:
 err_setup:
 	qeth_set_allowed_threads(card, 0, 1);
 	card->state = CARD_STATE_DOWN;
-- 
2.17.1

