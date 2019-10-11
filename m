Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4BD35BC
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfJKAYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:24:45 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:5424 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfJKAYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:24:44 -0400
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x9B0CCwL028878;
        Fri, 11 Oct 2019 01:24:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=d3Ralk8QIaJhG0WGqa9vu1nyZBbakb1TADQQNwXl6ds=;
 b=cjbLOyn0FLwK2ZOUHKMlvCwYy7wFFZ10kJ+ljFOU/aH+B/aw+8etkAJ1rOF7/bSf1V/L
 L5BJ43ej4qnIHheHb5SYHWAJ1uFxCWUegZsEMFmgQwndtqEMME4iyfXU1Eg2PxNyr76N
 TusmZ45o0wC5miUEZHRpLDW1Q9cCkFEmrqXLbQY3sQ/eZrU0EgxSpPKBP9fBkav6vs8j
 X5tD/NEkcclEsdEDH00+bC9sxcGxUQQdMmd6/9J/NnYZoSttyJACuSwgZKvJUtCrJFDg
 bzUucrtN8pGX/QW73mKKeLbWzz83qAGPJgJkLxu2P74Vj6hjXfODUViHqXlJsgdTme2n eA== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 2veg8fmdgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 01:24:36 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9B0GbLs012102;
        Thu, 10 Oct 2019 20:24:35 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2veph0x33c-1;
        Thu, 10 Oct 2019 20:24:35 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 5CF6B80E1D;
        Fri, 11 Oct 2019 00:24:35 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iIijw-0001ar-IN; Thu, 10 Oct 2019 20:25:04 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com
Cc:     willemb@google.com, sridhar.samudrala@intel.com,
        aaron.f.brown@intel.com, alexander.h.duyck@linux.intel.com,
        Josh Hunt <johunt@akamai.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 1/3] igb: Add UDP segmentation offload support
Date:   Thu, 10 Oct 2019 20:25:00 -0400
Message-Id: <1570753502-6014-2-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570753502-6014-1-git-send-email-johunt@akamai.com>
References: <1570753502-6014-1-git-send-email-johunt@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910110000
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_09:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on a series from Alexander Duyck this change adds UDP segmentation
offload support to the igb driver.

CC: Alexander Duyck <alexander.h.duyck@intel.com>
CC: Willem de Bruijn <willemb@google.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.h |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c    | 23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.h b/drivers/net/ethernet/intel/igb/e1000_82575.h
index 6ad775b1a4c5..63ec253ac788 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.h
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.h
@@ -127,6 +127,7 @@ struct e1000_adv_tx_context_desc {
 };
 
 #define E1000_ADVTXD_MACLEN_SHIFT    9  /* Adv ctxt desc mac len shift */
+#define E1000_ADVTXD_TUCMD_L4T_UDP 0x00000000  /* L4 Packet TYPE of UDP */
 #define E1000_ADVTXD_TUCMD_IPV4    0x00000400  /* IP Packet Type: 1=IPv4 */
 #define E1000_ADVTXD_TUCMD_L4T_TCP 0x00000800  /* L4 Packet TYPE of TCP */
 #define E1000_ADVTXD_TUCMD_L4T_SCTP 0x00001000 /* L4 packet TYPE of SCTP */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 105b0624081a..4131bc8b079e 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2516,6 +2516,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN))
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
+				    NETIF_F_GSO_UDP_L4 |
 				    NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
@@ -2524,6 +2525,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN))
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
+				    NETIF_F_GSO_UDP_L4 |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
 
@@ -3120,7 +3122,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_HW_CSUM;
 
 	if (hw->mac.type >= e1000_82576)
-		netdev->features |= NETIF_F_SCTP_CRC;
+		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
 
 	if (hw->mac.type >= e1000_i350)
 		netdev->features |= NETIF_F_HW_TC;
@@ -5694,6 +5696,7 @@ static int igb_tso(struct igb_ring *tx_ring,
 	} ip;
 	union {
 		struct tcphdr *tcp;
+		struct udphdr *udp;
 		unsigned char *hdr;
 	} l4;
 	u32 paylen, l4_offset;
@@ -5713,7 +5716,8 @@ static int igb_tso(struct igb_ring *tx_ring,
 	l4.hdr = skb_checksum_start(skb);
 
 	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
-	type_tucmd = E1000_ADVTXD_TUCMD_L4T_TCP;
+	type_tucmd = (!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)) ?
+		      E1000_ADVTXD_TUCMD_L4T_TCP : E1000_ADVTXD_TUCMD_L4T_UDP;
 
 	/* initialize outer IP header fields */
 	if (ip.v4->version == 4) {
@@ -5741,12 +5745,19 @@ static int igb_tso(struct igb_ring *tx_ring,
 	/* determine offset of inner transport header */
 	l4_offset = l4.hdr - skb->data;
 
-	/* compute length of segmentation header */
-	*hdr_len = (l4.tcp->doff * 4) + l4_offset;
-
 	/* remove payload length from inner checksum */
 	paylen = skb->len - l4_offset;
-	csum_replace_by_diff(&l4.tcp->check, htonl(paylen));
+	if (type_tucmd & E1000_ADVTXD_TUCMD_L4T_TCP) {
+		/* compute length of segmentation header */
+		*hdr_len = (l4.tcp->doff * 4) + l4_offset;
+		csum_replace_by_diff(&l4.tcp->check,
+			(__force __wsum)htonl(paylen));
+	} else {
+		/* compute length of segmentation header */
+		*hdr_len = sizeof(*l4.udp) + l4_offset;
+		csum_replace_by_diff(&l4.udp->check,
+				     (__force __wsum)htonl(paylen));
+	}
 
 	/* update gso size and bytecount with header size */
 	first->gso_segs = skb_shinfo(skb)->gso_segs;
-- 
2.7.4

