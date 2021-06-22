Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB133B0FA0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhFVVzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:55:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhFVVzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 17:55:14 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MLYDQO180777;
        Tue, 22 Jun 2021 17:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=p7R7ljOFUARSAXtAGmQalgSU6IdzsAWhGTgrqux9A9s=;
 b=sSg30mojDbWHro2AjXerNEFd+k432eP+kYYiKmFU0Nmg1FH5rM/GlVM4AAnLhhhj9zxC
 tkxMWIGmMb3v4jayBXFd537gOTmAzoh6wECAuVIIVO6s/GjYo//LtNlZAn9HrtOaMZlH
 5+AkgJ7AVUvItOrRujYW6MYmn+TK4aAqAB7EhouGUqJzFf9y1K6XBWBW1IU06WFr3uUM
 DjYxtshUeWvjo3nbe+KL1Rv3HwLHsx2lr9gvaWre1EJacri7iAmRv5C2nPjAgFfVk/yo
 tMag48NnvkgesLjkYTBV7M6U/LPKLTgUYFBiWMxmPZU/fjZIojA4WpREsF3pom0I8ynT Eg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bqvg0bjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 17:52:57 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MLcbZ1015786;
        Tue, 22 Jun 2021 21:52:56 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 399879sx9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 21:52:56 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MLqtFY30736778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 21:52:55 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6A97B2067;
        Tue, 22 Jun 2021 21:52:55 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60FF7B205F;
        Tue, 22 Jun 2021 21:52:54 +0000 (GMT)
Received: from li-7fb8bacc-2d5f-11b2-a85c-be3620e38a26.ibm.com.com (unknown [9.160.12.39])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 21:52:54 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     cforno12@linux.ibm.com, pradeeps@linux.vnet.ibm.com,
        wilder@us.ibm.com, kuba@kernel.org, dwilder@us.ibm.com
Subject: [PATCH v1] ibmveth: Set CHECKSUM_PARTIAL if NULL TCP CSUM.
Date:   Tue, 22 Jun 2021 14:52:15 -0700
Message-Id: <20210622215215.1947909-1-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4AbnbY0Oh8tdxdjto2f_vbmMuj1f2XCE
X-Proofpoint-ORIG-GUID: 4AbnbY0Oh8tdxdjto2f_vbmMuj1f2XCE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_13:2021-06-22,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP checksums on received packets may be set to NULL by the sender if CSO
is enabled. The hypervisor flags these packets as check-sum-ok and the
skb is then flagged CHECKSUM_UNNECESSARY. If these packets are then
forwarded the sender will not request CSO due to the CHECKSUM_UNNECESSARY
flag. The result is a TCP packet sent with a bad checksum. This change
sets up CHECKSUM_PARTIAL on these packets causing the sender to correctly
request CSUM offload.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Tested-by: Cristobal Forno <cforno12@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 51 ++++++++++++++++--------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7fea9ae60f13..da6c63ff2790 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1285,36 +1285,41 @@ static void ibmveth_rx_csum_helper(struct sk_buff *skb,
 		iph_proto = iph6->nexthdr;
 	}
 
-	/* In OVS environment, when a flow is not cached, specifically for a
-	 * new TCP connection, the first packet information is passed up
+	/* When CSO is enabled the TCP checksum may have be set to NULL by
+	 * the sender given that we zeroed out TCP checksum field in
+	 * transmit path (refer ibmveth_start_xmit routine). In this case set
+	 * up CHECKSUM_PARTIAL. If the packet is forwarded, the checksum will
+	 * then be recalculated by the destination NIC (CSO must be enabled
+	 * on the destination NIC).
+	 *
+	 * In an OVS environment, when a flow is not cached, specifically for a
+	 * new TCP connection, the first packet information is passed up to
 	 * the user space for finding a flow. During this process, OVS computes
 	 * checksum on the first packet when CHECKSUM_PARTIAL flag is set.
 	 *
-	 * Given that we zeroed out TCP checksum field in transmit path
-	 * (refer ibmveth_start_xmit routine) as we set "no checksum bit",
-	 * OVS computed checksum will be incorrect w/o TCP pseudo checksum
-	 * in the packet. This leads to OVS dropping the packet and hence
-	 * TCP retransmissions are seen.
-	 *
-	 * So, re-compute TCP pseudo header checksum.
+	 * So, re-compute TCP pseudo header checksum when configured for
+	 * trunk mode.
 	 */
-	if (iph_proto == IPPROTO_TCP && adapter->is_active_trunk) {
+	if (iph_proto == IPPROTO_TCP) {
 		struct tcphdr *tcph = (struct tcphdr *)(skb->data + iphlen);
-
-		tcphdrlen = skb->len - iphlen;
-
-		/* Recompute TCP pseudo header checksum */
-		if (skb_proto == ETH_P_IP)
-			tcph->check = ~csum_tcpudp_magic(iph->saddr,
+		if (tcph->check == 0x0000) {
+			/* Recompute TCP pseudo header checksum  */
+			if (adapter->is_active_trunk) {
+				tcphdrlen = skb->len - iphlen;
+				if (skb_proto == ETH_P_IP)
+					tcph->check =
+					 ~csum_tcpudp_magic(iph->saddr,
 					iph->daddr, tcphdrlen, iph_proto, 0);
-		else if (skb_proto == ETH_P_IPV6)
-			tcph->check = ~csum_ipv6_magic(&iph6->saddr,
+				else if (skb_proto == ETH_P_IPV6)
+					tcph->check =
+					 ~csum_ipv6_magic(&iph6->saddr,
 					&iph6->daddr, tcphdrlen, iph_proto, 0);
-
-		/* Setup SKB fields for checksum offload */
-		skb_partial_csum_set(skb, iphlen,
-				     offsetof(struct tcphdr, check));
-		skb_reset_network_header(skb);
+			}
+			/* Setup SKB fields for checksum offload */
+			skb_partial_csum_set(skb, iphlen,
+					     offsetof(struct tcphdr, check));
+			skb_reset_network_header(skb);
+		}
 	}
 }
 
-- 
2.27.0

