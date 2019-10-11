Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E48D35BB
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfJKAYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:24:43 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:46322 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726429AbfJKAYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:24:43 -0400
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x9B0C5a5030543;
        Fri, 11 Oct 2019 01:24:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=875vaUoHc0xy/rAbcYyATmlW9LlozwumV+FgtA+veYI=;
 b=XsoccWIMZMiL+PgR97nl/uaxqFhORsfZcdHYnBuEUwsuajuFDpdlvw23gKmZziKDxhgE
 RY3gtOOPIoKwKBvVYcyQV2d4uYhe0P+cBKtl+yCnL9OyVI9VrFjI+PZP0LqqH87FJLFH
 JdwzVnWkmWODUeJ10IQcIHGWAaiRg+GBm0fUwHK9AwkQKUWlJydmQutYaVW9w2WHLVy4
 gru/KOsJRSiyB6d5rhS2NQnYWAr5quRXsEJvgYRebXb6jRkA/L4bd4Sv/pL9LbYCohNY
 sLHHA54FzKBxze6k8sIcF8aixknLpXbfr08xo00m+37NZkXvbuU8r5a0/8+Vmq1nK5Ki mw== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 2vejeqybx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 01:24:36 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9B0GcYl002041;
        Thu, 10 Oct 2019 20:24:35 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2vepgydkmd-1;
        Thu, 10 Oct 2019 20:24:35 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 6A30481422;
        Fri, 11 Oct 2019 00:24:35 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iIijw-0001aw-Jm; Thu, 10 Oct 2019 20:25:04 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com
Cc:     willemb@google.com, sridhar.samudrala@intel.com,
        aaron.f.brown@intel.com, alexander.h.duyck@linux.intel.com,
        Josh Hunt <johunt@akamai.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 2/3] ixgbe: Add UDP segmentation offload support
Date:   Thu, 10 Oct 2019 20:25:01 -0400
Message-Id: <1570753502-6014-3-git-send-email-johunt@akamai.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 bulkscore=0 spamscore=0 adultscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910110000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Repost from a series by Alexander Duyck to add UDP segmentation offload
support to the igb driver:
https://lore.kernel.org/netdev/20180504003916.4769.66271.stgit@localhost.localdomain/

CC: Alexander Duyck <alexander.h.duyck@intel.com>
CC: Willem de Bruijn <willemb@google.com>
Suggested-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1ce2397306b9..7d50c1a4a3be 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7946,6 +7946,7 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
 	} ip;
 	union {
 		struct tcphdr *tcp;
+		struct udphdr *udp;
 		unsigned char *hdr;
 	} l4;
 	u32 paylen, l4_offset;
@@ -7969,7 +7970,8 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
 	l4.hdr = skb_checksum_start(skb);
 
 	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
-	type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_TCP;
+	type_tucmd = (!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)) ?
+		      IXGBE_ADVTXD_TUCMD_L4T_TCP : IXGBE_ADVTXD_TUCMD_L4T_UDP;
 
 	/* initialize outer IP header fields */
 	if (ip.v4->version == 4) {
@@ -7999,12 +8001,20 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
 	/* determine offset of inner transport header */
 	l4_offset = l4.hdr - skb->data;
 
-	/* compute length of segmentation header */
-	*hdr_len = (l4.tcp->doff * 4) + l4_offset;
-
 	/* remove payload length from inner checksum */
 	paylen = skb->len - l4_offset;
-	csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
+
+	if (type_tucmd & IXGBE_ADVTXD_TUCMD_L4T_TCP) {
+		/* compute length of segmentation header */
+		*hdr_len = (l4.tcp->doff * 4) + l4_offset;
+		csum_replace_by_diff(&l4.tcp->check,
+				     (__force __wsum)htonl(paylen));
+	} else {
+		/* compute length of segmentation header */
+		*hdr_len = sizeof(*l4.udp) + l4_offset;
+		csum_replace_by_diff(&l4.udp->check,
+				     (__force __wsum)htonl(paylen));
+	}
 
 	/* update gso size and bytecount with header size */
 	first->gso_segs = skb_shinfo(skb)->gso_segs;
@@ -10190,6 +10200,7 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(mac_hdr_len > IXGBE_MAX_MAC_HDR_LEN))
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
+				    NETIF_F_GSO_UDP_L4 |
 				    NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
@@ -10198,6 +10209,7 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(network_hdr_len >  IXGBE_MAX_NETWORK_HDR_LEN))
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
+				    NETIF_F_GSO_UDP_L4 |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
 
@@ -10907,7 +10919,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    IXGBE_GSO_PARTIAL_FEATURES;
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->features |= NETIF_F_SCTP_CRC;
+		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
 
 #ifdef CONFIG_IXGBE_IPSEC
 #define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
-- 
2.7.4

