Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86D91724A5
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgB0RId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:08:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729983AbgB0RIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:08:32 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RH6L1n114962
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:32 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydxepfux5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:31 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Feb 2020 17:08:29 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 17:08:26 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RH8OKP41418978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 17:08:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7008A405C;
        Thu, 27 Feb 2020 17:08:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E42FA4054;
        Thu, 27 Feb 2020 17:08:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 17:08:24 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 8/8] s390/qeth: support configurable RX copybreak
Date:   Thu, 27 Feb 2020 18:08:16 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200227170816.101286-1-jwi@linux.ibm.com>
References: <20200227170816.101286-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022717-0028-0000-0000-000003DE988A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022717-0029-0000-0000-000024A3B8BB
Message-Id: <20200227170816.101286-9-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_05:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the ethtool hooks for the ETHTOOL_RX_COPYBREAK tunable.

The copybreak is stored into netdev_priv, so that we automatically go
back to the default value if the netdev is re-allocated.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 10 ++++++----
 drivers/s390/net/qeth_core_main.c | 17 +++++++++++------
 drivers/s390/net/qeth_ethtool.c   | 31 +++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 9575a627a1e1..b7d64690ea38 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -189,6 +189,8 @@ struct qeth_vnicc_info {
 #define QETH_IQD_MIN_TXQ	2	/* One for ucast, one for mcast. */
 #define QETH_IQD_MCAST_TXQ	0
 #define QETH_IQD_MIN_UCAST_TXQ	1
+
+#define QETH_RX_COPYBREAK      (PAGE_SIZE >> 1)
 #define QETH_IN_BUF_SIZE_DEFAULT 65536
 #define QETH_IN_BUF_COUNT_DEFAULT 64
 #define QETH_IN_BUF_COUNT_HSDEFAULT 128
@@ -219,9 +221,6 @@ struct qeth_vnicc_info {
 #define QETH_HIGH_WATERMARK_PACK 5
 #define QETH_WATERMARK_PACK_FUZZ 1
 
-/* large receive scatter gather copy break */
-#define QETH_RX_SG_CB (PAGE_SIZE >> 1)
-
 struct qeth_hdr_layer3 {
 	__u8  id;
 	__u8  flags;
@@ -711,7 +710,6 @@ struct qeth_card_options {
 	struct qeth_vnicc_info vnicc; /* VNICC options */
 	int fake_broadcast;
 	enum qeth_discipline_id layer;
-	int rx_sg_cb;
 	enum qeth_ipa_isolation_modes isolation;
 	enum qeth_ipa_isolation_modes prev_isolation;
 	int sniffer;
@@ -770,6 +768,10 @@ struct qeth_switch_info {
 	__u32 settings;
 };
 
+struct qeth_priv {
+	unsigned int rx_copybreak;
+};
+
 #define QETH_NAPI_WEIGHT NAPI_POLL_WEIGHT
 
 struct qeth_card {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index cbd2b4c46ea4..1bcac50bb395 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1257,7 +1257,6 @@ static void qeth_set_initial_options(struct qeth_card *card)
 {
 	card->options.route4.type = NO_ROUTER;
 	card->options.route6.type = NO_ROUTER;
-	card->options.rx_sg_cb = QETH_RX_SG_CB;
 	card->options.isolation = ISOLATION_MODE_NONE;
 	card->options.cq = QETH_CQ_DISABLED;
 	card->options.layer = QETH_DISCIPLINE_UNDETERMINED;
@@ -5268,6 +5267,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 			    int *__offset)
 {
 	struct qdio_buffer_element *element = *__element;
+	struct qeth_priv *priv = netdev_priv(card->dev);
 	struct qdio_buffer *buffer = qethbuffer->buffer;
 	struct napi_struct *napi = &card->napi;
 	unsigned int linear_len = 0;
@@ -5343,7 +5343,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 	}
 
 	use_rx_sg = (card->options.cq == QETH_CQ_ENABLED) ||
-		    (skb_len > card->options.rx_sg_cb &&
+		    (skb_len > READ_ONCE(priv->rx_copybreak) &&
 		     !atomic_read(&card->force_alloc_skb) &&
 		     !IS_OSN(card));
 
@@ -5892,25 +5892,30 @@ static void qeth_clear_dbf_list(void)
 static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 {
 	struct net_device *dev;
+	struct qeth_priv *priv;
 
 	switch (card->info.type) {
 	case QETH_CARD_TYPE_IQD:
-		dev = alloc_netdev_mqs(0, "hsi%d", NET_NAME_UNKNOWN,
+		dev = alloc_netdev_mqs(sizeof(*priv), "hsi%d", NET_NAME_UNKNOWN,
 				       ether_setup, QETH_MAX_QUEUES, 1);
 		break;
 	case QETH_CARD_TYPE_OSM:
-		dev = alloc_etherdev(0);
+		dev = alloc_etherdev(sizeof(*priv));
 		break;
 	case QETH_CARD_TYPE_OSN:
-		dev = alloc_netdev(0, "osn%d", NET_NAME_UNKNOWN, ether_setup);
+		dev = alloc_netdev(sizeof(*priv), "osn%d", NET_NAME_UNKNOWN,
+				   ether_setup);
 		break;
 	default:
-		dev = alloc_etherdev_mqs(0, QETH_MAX_QUEUES, 1);
+		dev = alloc_etherdev_mqs(sizeof(*priv), QETH_MAX_QUEUES, 1);
 	}
 
 	if (!dev)
 		return NULL;
 
+	priv = netdev_priv(dev);
+	priv->rx_copybreak = QETH_RX_COPYBREAK;
+
 	dev->ml_priv = card;
 	dev->watchdog_timeo = QETH_TX_TIMEOUT;
 	dev->min_mtu = IS_OSN(card) ? 64 : 576;
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index ab59bc975719..9052c72d5b8f 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -175,6 +175,35 @@ static void qeth_get_channels(struct net_device *dev,
 	channels->combined_count = 0;
 }
 
+static int qeth_get_tunable(struct net_device *dev,
+			    const struct ethtool_tunable *tuna, void *data)
+{
+	struct qeth_priv *priv = netdev_priv(dev);
+
+	switch (tuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		*(u32 *)data = priv->rx_copybreak;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int qeth_set_tunable(struct net_device *dev,
+			    const struct ethtool_tunable *tuna,
+			    const void *data)
+{
+	struct qeth_priv *priv = netdev_priv(dev);
+
+	switch (tuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		WRITE_ONCE(priv->rx_copybreak, *(u32 *)data);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /* Helper function to fill 'advertising' and 'supported' which are the same. */
 /* Autoneg and full-duplex are supported and advertised unconditionally.     */
 /* Always advertise and support all speeds up to specified, and only one     */
@@ -381,6 +410,8 @@ const struct ethtool_ops qeth_ethtool_ops = {
 	.get_sset_count = qeth_get_sset_count,
 	.get_drvinfo = qeth_get_drvinfo,
 	.get_channels = qeth_get_channels,
+	.get_tunable = qeth_get_tunable,
+	.set_tunable = qeth_set_tunable,
 	.get_link_ksettings = qeth_get_link_ksettings,
 };
 
-- 
2.17.1

