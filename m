Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A8E12973E
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLWOWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:22:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbfLWOWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:22:36 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNEJxID035668
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:22:34 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2x21kg4m49-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:22:34 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 23 Dec 2019 14:22:32 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Dec 2019 14:22:30 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBNEMT5051904764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 14:22:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 468E04C04E;
        Mon, 23 Dec 2019 14:22:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED1764C046;
        Mon, 23 Dec 2019 14:22:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Dec 2019 14:22:28 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/3] s390/qeth: consolidate RX code
Date:   Mon, 23 Dec 2019 15:22:25 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191223142227.19500-1-jwi@linux.ibm.com>
References: <20191223142227.19500-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19122314-0012-0000-0000-00000377996F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19122314-0013-0000-0000-000021B396AE
Message-Id: <20191223142227.19500-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_06:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reduce the path length and levels of indirection, move the RX
processing from the sub-drivers into the core.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  16 ---
 drivers/s390/net/qeth_core_main.c | 180 +++++++++++++++++++++++++-----
 drivers/s390/net/qeth_l2_main.c   |  40 -------
 drivers/s390/net/qeth_l3_main.c   |  91 ---------------
 4 files changed, 153 insertions(+), 174 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6e16b19732f6..4ab3be814ea7 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -728,7 +728,6 @@ struct qeth_osn_info {
 
 struct qeth_discipline {
 	const struct device_type *devtype;
-	int (*process_rx_buffer)(struct qeth_card *card, int budget, int *done);
 	int (*recover)(void *ptr);
 	int (*setup) (struct ccwgroup_device *);
 	void (*remove) (struct ccwgroup_device *);
@@ -923,18 +922,6 @@ static inline struct dst_entry *qeth_dst_check_rcu(struct sk_buff *skb, int ipv)
 	return dst;
 }
 
-static inline void qeth_rx_csum(struct qeth_card *card, struct sk_buff *skb,
-				u8 flags)
-{
-	if ((card->dev->features & NETIF_F_RXCSUM) &&
-	    (flags & QETH_HDR_EXT_CSUM_TRANSP_REQ)) {
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		QETH_CARD_STAT_INC(card, rx_skb_csum);
-	} else {
-		skb->ip_summed = CHECKSUM_NONE;
-	}
-}
-
 static inline void qeth_tx_csum(struct sk_buff *skb, u8 *flags, int ipv)
 {
 	*flags |= QETH_HDR_EXT_CSUM_TRANSP_REQ;
@@ -1031,9 +1018,6 @@ struct qeth_cmd_buffer *qeth_get_diag_cmd(struct qeth_card *card,
 void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason);
 void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 
-struct sk_buff *qeth_core_get_next_skb(struct qeth_card *,
-		struct qeth_qdio_buffer *, struct qdio_buffer_element **, int *,
-		struct qeth_hdr **);
 void qeth_schedule_recovery(struct qeth_card *);
 int qeth_poll(struct napi_struct *napi, int budget);
 void qeth_clear_ipacmd_list(struct qeth_card *);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 41f37ce89a4f..8e2c0588525f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5046,6 +5046,114 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 }
 EXPORT_SYMBOL_GPL(qeth_core_hardsetup_card);
 
+#if IS_ENABLED(CONFIG_QETH_L3)
+static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
+				struct qeth_hdr *hdr)
+{
+	struct af_iucv_trans_hdr *iucv = (struct af_iucv_trans_hdr *) skb->data;
+	struct qeth_hdr_layer3 *l3_hdr = &hdr->hdr.l3;
+	struct net_device *dev = skb->dev;
+
+	if (IS_IQD(card) && iucv->magic == ETH_P_AF_IUCV) {
+		dev_hard_header(skb, dev, ETH_P_AF_IUCV, dev->dev_addr,
+				"FAKELL", skb->len);
+		return;
+	}
+
+	if (!(l3_hdr->flags & QETH_HDR_PASSTHRU)) {
+		u16 prot = (l3_hdr->flags & QETH_HDR_IPV6) ? ETH_P_IPV6 :
+							     ETH_P_IP;
+		unsigned char tg_addr[ETH_ALEN];
+
+		skb_reset_network_header(skb);
+		switch (l3_hdr->flags & QETH_HDR_CAST_MASK) {
+		case QETH_CAST_MULTICAST:
+			if (prot == ETH_P_IP)
+				ip_eth_mc_map(ip_hdr(skb)->daddr, tg_addr);
+			else
+				ipv6_eth_mc_map(&ipv6_hdr(skb)->daddr, tg_addr);
+			QETH_CARD_STAT_INC(card, rx_multicast);
+			break;
+		case QETH_CAST_BROADCAST:
+			ether_addr_copy(tg_addr, dev->broadcast);
+			QETH_CARD_STAT_INC(card, rx_multicast);
+			break;
+		default:
+			if (card->options.sniffer)
+				skb->pkt_type = PACKET_OTHERHOST;
+			ether_addr_copy(tg_addr, dev->dev_addr);
+		}
+
+		if (l3_hdr->ext_flags & QETH_HDR_EXT_SRC_MAC_ADDR)
+			dev_hard_header(skb, dev, prot, tg_addr,
+					&l3_hdr->next_hop.rx.src_mac, skb->len);
+		else
+			dev_hard_header(skb, dev, prot, tg_addr, "FAKELL",
+					skb->len);
+	}
+
+	/* copy VLAN tag from hdr into skb */
+	if (!card->options.sniffer &&
+	    (l3_hdr->ext_flags & (QETH_HDR_EXT_VLAN_FRAME |
+				  QETH_HDR_EXT_INCLUDE_VLAN_TAG))) {
+		u16 tag = (l3_hdr->ext_flags & QETH_HDR_EXT_VLAN_FRAME) ?
+				l3_hdr->vlan_id :
+				l3_hdr->next_hop.rx.vlan_id;
+
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tag);
+	}
+}
+#endif
+
+static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
+			     struct qeth_hdr *hdr)
+{
+	bool is_cso;
+
+	switch (hdr->hdr.l2.id) {
+	case QETH_HEADER_TYPE_OSN:
+		skb_push(skb, sizeof(*hdr));
+		skb_copy_to_linear_data(skb, hdr, sizeof(*hdr));
+		QETH_CARD_STAT_ADD(card, rx_bytes, skb->len);
+		QETH_CARD_STAT_INC(card, rx_packets);
+
+		card->osn_info.data_cb(skb);
+		return;
+#if IS_ENABLED(CONFIG_QETH_L3)
+	case QETH_HEADER_TYPE_LAYER3:
+		qeth_l3_rebuild_skb(card, skb, hdr);
+		is_cso = hdr->hdr.l3.ext_flags & QETH_HDR_EXT_CSUM_TRANSP_REQ;
+		break;
+#endif
+	case QETH_HEADER_TYPE_LAYER2:
+		is_cso = hdr->hdr.l2.flags[1] & QETH_HDR_EXT_CSUM_TRANSP_REQ;
+		break;
+	default:
+		/* never happens */
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	if (is_cso && (card->dev->features & NETIF_F_RXCSUM)) {
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		QETH_CARD_STAT_INC(card, rx_skb_csum);
+	} else {
+		skb->ip_summed = CHECKSUM_NONE;
+	}
+
+	skb->protocol = eth_type_trans(skb, skb->dev);
+
+	QETH_CARD_STAT_ADD(card, rx_bytes, skb->len);
+	QETH_CARD_STAT_INC(card, rx_packets);
+	if (skb_is_nonlinear(skb)) {
+		QETH_CARD_STAT_INC(card, rx_sg_skbs);
+		QETH_CARD_STAT_ADD(card, rx_sg_frags,
+				   skb_shinfo(skb)->nr_frags);
+	}
+
+	napi_gro_receive(&card->napi, skb);
+}
+
 static void qeth_create_skb_frag(struct sk_buff *skb, char *data, int data_len)
 {
 	struct page *page = virt_to_page(data);
@@ -5062,10 +5170,10 @@ static inline int qeth_is_last_sbale(struct qdio_buffer_element *sbale)
 	return (sbale->eflags & SBAL_EFLAGS_LAST_ENTRY);
 }
 
-struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
-		struct qeth_qdio_buffer *qethbuffer,
-		struct qdio_buffer_element **__element, int *__offset,
-		struct qeth_hdr **hdr)
+static int qeth_extract_skb(struct qeth_card *card,
+			    struct qeth_qdio_buffer *qethbuffer,
+			    struct qdio_buffer_element **__element,
+			    int *__offset)
 {
 	struct qdio_buffer_element *element = *__element;
 	struct qdio_buffer *buffer = qethbuffer->buffer;
@@ -5073,6 +5181,7 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	int offset = *__offset;
 	bool use_rx_sg = false;
 	unsigned int headroom;
+	struct qeth_hdr *hdr;
 	struct sk_buff *skb;
 	int skb_len = 0;
 
@@ -5080,42 +5189,42 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	/* qeth_hdr must not cross element boundaries */
 	while (element->length < offset + sizeof(struct qeth_hdr)) {
 		if (qeth_is_last_sbale(element))
-			return NULL;
+			return -ENODATA;
 		element++;
 		offset = 0;
 	}
-	*hdr = element->addr + offset;
 
-	offset += sizeof(struct qeth_hdr);
+	hdr = element->addr + offset;
+	offset += sizeof(*hdr);
 	skb = NULL;
 
-	switch ((*hdr)->hdr.l2.id) {
+	switch (hdr->hdr.l2.id) {
 	case QETH_HEADER_TYPE_LAYER2:
-		skb_len = (*hdr)->hdr.l2.pkt_length;
+		skb_len = hdr->hdr.l2.pkt_length;
 		linear_len = ETH_HLEN;
 		headroom = 0;
 		break;
 	case QETH_HEADER_TYPE_LAYER3:
-		skb_len = (*hdr)->hdr.l3.length;
+		skb_len = hdr->hdr.l3.length;
 		if (!IS_LAYER3(card)) {
 			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 			goto walk_packet;
 		}
 
-		if ((*hdr)->hdr.l3.flags & QETH_HDR_PASSTHRU) {
+		if (hdr->hdr.l3.flags & QETH_HDR_PASSTHRU) {
 			linear_len = ETH_HLEN;
 			headroom = 0;
 			break;
 		}
 
-		if ((*hdr)->hdr.l3.flags & QETH_HDR_IPV6)
+		if (hdr->hdr.l3.flags & QETH_HDR_IPV6)
 			linear_len = sizeof(struct ipv6hdr);
 		else
 			linear_len = sizeof(struct iphdr);
 		headroom = ETH_HLEN;
 		break;
 	case QETH_HEADER_TYPE_OSN:
-		skb_len = (*hdr)->hdr.osn.pdu_length;
+		skb_len = hdr->hdr.osn.pdu_length;
 		if (!IS_OSN(card)) {
 			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 			goto walk_packet;
@@ -5125,13 +5234,13 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		headroom = sizeof(struct qeth_hdr);
 		break;
 	default:
-		if ((*hdr)->hdr.l2.id & QETH_HEADER_MASK_INVAL)
+		if (hdr->hdr.l2.id & QETH_HEADER_MASK_INVAL)
 			QETH_CARD_STAT_INC(card, rx_frame_errors);
 		else
 			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 
 		/* Can't determine packet length, drop the whole buffer. */
-		return NULL;
+		return -EPROTONOSUPPORT;
 	}
 
 	if (skb_len < linear_len) {
@@ -5195,7 +5304,7 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 					QETH_CARD_STAT_INC(card,
 							   rx_length_errors);
 				}
-				return NULL;
+				return -EMSGSIZE;
 			}
 			element++;
 			offset = 0;
@@ -5208,22 +5317,40 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 
 	*__element = element;
 	*__offset = offset;
-	if (use_rx_sg) {
-		QETH_CARD_STAT_INC(card, rx_sg_skbs);
-		QETH_CARD_STAT_ADD(card, rx_sg_frags,
-				   skb_shinfo(skb)->nr_frags);
+
+	qeth_receive_skb(card, skb, hdr);
+	return 0;
+}
+
+static int qeth_extract_skbs(struct qeth_card *card, int budget,
+			     struct qeth_qdio_buffer *buf, bool *done)
+{
+	int work_done = 0;
+
+	WARN_ON_ONCE(!budget);
+	*done = false;
+
+	while (budget) {
+		if (qeth_extract_skb(card, buf, &card->rx.b_element,
+				     &card->rx.e_offset)) {
+			*done = true;
+			break;
+		}
+
+		work_done++;
+		budget--;
 	}
-	return skb;
+
+	return work_done;
 }
-EXPORT_SYMBOL_GPL(qeth_core_get_next_skb);
 
 int qeth_poll(struct napi_struct *napi, int budget)
 {
 	struct qeth_card *card = container_of(napi, struct qeth_card, napi);
 	int work_done = 0;
 	struct qeth_qdio_buffer *buffer;
-	int done;
 	int new_budget = budget;
+	bool done;
 
 	while (1) {
 		if (!card->rx.b_count) {
@@ -5246,11 +5373,10 @@ int qeth_poll(struct napi_struct *napi, int budget)
 			if (!(card->rx.qdio_err &&
 			    qeth_check_qdio_errors(card, buffer->buffer,
 			    card->rx.qdio_err, "qinerr")))
-				work_done +=
-					card->discipline->process_rx_buffer(
-						card, new_budget, &done);
+				work_done += qeth_extract_skbs(card, new_budget,
+							       buffer, &done);
 			else
-				done = 1;
+				done = true;
 
 			if (done) {
 				QETH_CARD_STAT_INC(card, rx_bufs);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 8c95e6019bac..69d147c4d2ca 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -298,45 +298,6 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 	card->info.promisc_mode = 0;
 }
 
-static int qeth_l2_process_inbound_buffer(struct qeth_card *card,
-				int budget, int *done)
-{
-	int work_done = 0;
-	struct sk_buff *skb;
-	struct qeth_hdr *hdr;
-	unsigned int len;
-
-	*done = 0;
-	WARN_ON_ONCE(!budget);
-	while (budget) {
-		skb = qeth_core_get_next_skb(card,
-			&card->qdio.in_q->bufs[card->rx.b_index],
-			&card->rx.b_element, &card->rx.e_offset, &hdr);
-		if (!skb) {
-			*done = 1;
-			break;
-		}
-
-		if (hdr->hdr.l2.id == QETH_HEADER_TYPE_LAYER2) {
-			skb->protocol = eth_type_trans(skb, skb->dev);
-			qeth_rx_csum(card, skb, hdr->hdr.l2.flags[1]);
-			len = skb->len;
-			napi_gro_receive(&card->napi, skb);
-		} else {
-			skb_push(skb, sizeof(*hdr));
-			skb_copy_to_linear_data(skb, hdr, sizeof(*hdr));
-			len = skb->len;
-			card->osn_info.data_cb(skb);
-		}
-
-		work_done++;
-		budget--;
-		QETH_CARD_STAT_INC(card, rx_packets);
-		QETH_CARD_STAT_ADD(card, rx_bytes, len);
-	}
-	return work_done;
-}
-
 static int qeth_l2_request_initial_mac(struct qeth_card *card)
 {
 	int rc = 0;
@@ -961,7 +922,6 @@ static int qeth_l2_control_event(struct qeth_card *card,
 
 struct qeth_discipline qeth_l2_discipline = {
 	.devtype = &qeth_l2_devtype,
-	.process_rx_buffer = qeth_l2_process_inbound_buffer,
 	.recover = qeth_l2_recover,
 	.setup = qeth_l2_probe_device,
 	.remove = qeth_l2_remove_device,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 04d7777b7d16..8a1535ee1467 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1164,96 +1164,6 @@ static int qeth_l3_vlan_rx_kill_vid(struct net_device *dev,
 	return 0;
 }
 
-static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
-				struct qeth_hdr *hdr)
-{
-	struct af_iucv_trans_hdr *iucv = (struct af_iucv_trans_hdr *) skb->data;
-	struct net_device *dev = skb->dev;
-
-	if (IS_IQD(card) && iucv->magic == ETH_P_AF_IUCV) {
-		dev_hard_header(skb, dev, ETH_P_AF_IUCV, dev->dev_addr,
-				"FAKELL", skb->len);
-		return;
-	}
-
-	if (!(hdr->hdr.l3.flags & QETH_HDR_PASSTHRU)) {
-		u16 prot = (hdr->hdr.l3.flags & QETH_HDR_IPV6) ? ETH_P_IPV6 :
-								 ETH_P_IP;
-		unsigned char tg_addr[ETH_ALEN];
-
-		skb_reset_network_header(skb);
-		switch (hdr->hdr.l3.flags & QETH_HDR_CAST_MASK) {
-		case QETH_CAST_MULTICAST:
-			if (prot == ETH_P_IP)
-				ip_eth_mc_map(ip_hdr(skb)->daddr, tg_addr);
-			else
-				ipv6_eth_mc_map(&ipv6_hdr(skb)->daddr, tg_addr);
-			QETH_CARD_STAT_INC(card, rx_multicast);
-			break;
-		case QETH_CAST_BROADCAST:
-			ether_addr_copy(tg_addr, card->dev->broadcast);
-			QETH_CARD_STAT_INC(card, rx_multicast);
-			break;
-		default:
-			if (card->options.sniffer)
-				skb->pkt_type = PACKET_OTHERHOST;
-			ether_addr_copy(tg_addr, card->dev->dev_addr);
-		}
-
-		if (hdr->hdr.l3.ext_flags & QETH_HDR_EXT_SRC_MAC_ADDR)
-			card->dev->header_ops->create(skb, card->dev, prot,
-				tg_addr, &hdr->hdr.l3.next_hop.rx.src_mac,
-				skb->len);
-		else
-			card->dev->header_ops->create(skb, card->dev, prot,
-				tg_addr, "FAKELL", skb->len);
-	}
-
-	/* copy VLAN tag from hdr into skb */
-	if (!card->options.sniffer &&
-	    (hdr->hdr.l3.ext_flags & (QETH_HDR_EXT_VLAN_FRAME |
-				      QETH_HDR_EXT_INCLUDE_VLAN_TAG))) {
-		u16 tag = (hdr->hdr.l3.ext_flags & QETH_HDR_EXT_VLAN_FRAME) ?
-				hdr->hdr.l3.vlan_id :
-				hdr->hdr.l3.next_hop.rx.vlan_id;
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tag);
-	}
-
-	qeth_rx_csum(card, skb, hdr->hdr.l3.ext_flags);
-}
-
-static int qeth_l3_process_inbound_buffer(struct qeth_card *card,
-				int budget, int *done)
-{
-	int work_done = 0;
-	struct sk_buff *skb;
-	struct qeth_hdr *hdr;
-
-	*done = 0;
-	WARN_ON_ONCE(!budget);
-	while (budget) {
-		skb = qeth_core_get_next_skb(card,
-			&card->qdio.in_q->bufs[card->rx.b_index],
-			&card->rx.b_element, &card->rx.e_offset, &hdr);
-		if (!skb) {
-			*done = 1;
-			break;
-		}
-
-		if (hdr->hdr.l3.id == QETH_HEADER_TYPE_LAYER3)
-			qeth_l3_rebuild_skb(card, skb, hdr);
-
-		skb->protocol = eth_type_trans(skb, skb->dev);
-		QETH_CARD_STAT_INC(card, rx_packets);
-		QETH_CARD_STAT_ADD(card, rx_bytes, skb->len);
-
-		napi_gro_receive(&card->napi, skb);
-		work_done++;
-		budget--;
-	}
-	return work_done;
-}
-
 static void qeth_l3_stop_card(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 2, "stopcard");
@@ -2317,7 +2227,6 @@ static int qeth_l3_control_event(struct qeth_card *card,
 
 struct qeth_discipline qeth_l3_discipline = {
 	.devtype = &qeth_l3_devtype,
-	.process_rx_buffer = qeth_l3_process_inbound_buffer,
 	.recover = qeth_l3_recover,
 	.setup = qeth_l3_probe_device,
 	.remove = qeth_l3_remove_device,
-- 
2.17.1

