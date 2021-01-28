Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE53074CA
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhA1L1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:27:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231422AbhA1L0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:26:46 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SB2a2W025626;
        Thu, 28 Jan 2021 06:26:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=w2VxL1sgUKTddGR93/SAnRrZHRz6FeVsph/hpenNGQ8=;
 b=heJmgdgHoW4SwkOOsYvtgFkUULeoENta7K8ijdmX0Nfu0KYxz4I798xo1D992ESUvKCc
 +oUopGO4r+DU6ZzX70aD5Lf0oXrNVZW6TGhpivUuQZ7VOEmbAO5lCorWU/2mk/ig0WWh
 2QkkKkuZTolIFTDwhn8wEn86KRCZ+NzFwgIY5aOmzpIMpsugG0dOlfGO3PeLq9kbujgL
 Zep12OEDZZpYz2GnjnD+97LjgrTSohCy8/O3Msot+xrmmxUh2gsxkv34nlNkfMw25/HZ
 eF0bY9Kw49vGTuJ2eGZQUcNeslAMGZFuPqhiBTZj6b6xvo0buQAuZsBgmkE7IW/Jp2tB QQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bqsyq8bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:26:02 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBM6FU027165;
        Thu, 28 Jan 2021 11:26:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 368be8afkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:26:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBPvV531588626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:25:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 248884203F;
        Thu, 28 Jan 2021 11:25:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8DFA4204C;
        Thu, 28 Jan 2021 11:25:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:25:56 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/5] s390/qeth: make cast type selection for af_iucv skbs robust
Date:   Thu, 28 Jan 2021 12:25:50 +0100
Message-Id: <20210128112551.18780-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128112551.18780-1-jwi@linux.ibm.com>
References: <20210128112551.18780-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the TX queue selection for af_iucv skbs,
qeth_l3_get_cast_type_rcu() ends up calling qeth_get_ether_cast_type().
Which is rather fragile, since such skbs don't have a proper ETH header
and we rely on it being zeroed out in the right places. Add a separate
case for ETH_P_AF_IUCV instead that does the right thing.

When later building the HW header for such skbs, don't hard-code the
cast type but follow the same path as for other protocol types. Here
the cast type should naturally come from the skb's queue mapping.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 4921afb51a1c..dd441eaec66e 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1604,8 +1604,10 @@ static int qeth_l3_get_cast_type_rcu(struct sk_buff *skb, struct dst_entry *dst,
 	case htons(ETH_P_IPV6):
 		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) ?
 				RTN_MULTICAST : RTN_UNICAST;
+	case htons(ETH_P_AF_IUCV):
+		return RTN_UNICAST;
 	default:
-		/* ... and MAC address */
+		/* OSA only: ... and MAC address */
 		return qeth_get_ether_cast_type(skb);
 	}
 }
@@ -1651,14 +1653,6 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 	} else {
 		hdr->hdr.l3.id = QETH_HEADER_TYPE_LAYER3;
 
-		if (proto == htons(ETH_P_AF_IUCV)) {
-			l3_hdr->flags = QETH_HDR_IPV6 | QETH_CAST_UNICAST;
-			l3_hdr->next_hop.addr.s6_addr16[0] = htons(0xfe80);
-			memcpy(&l3_hdr->next_hop.addr.s6_addr32[2],
-			       iucv_trans_hdr(skb)->destUserID, 8);
-			return;
-		}
-
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
 			qeth_tx_csum(skb, &hdr->hdr.l3.ext_flags, proto);
 			/* some HW requires combined L3+L4 csum offload: */
@@ -1687,16 +1681,25 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 		cast_type = qeth_l3_get_cast_type_rcu(skb, dst, proto);
 	l3_hdr->flags |= qeth_l3_cast_type_to_flag(cast_type);
 
-	if (proto == htons(ETH_P_IP)) {
+	switch (proto) {
+	case htons(ETH_P_IP):
 		l3_hdr->next_hop.addr.s6_addr32[3] =
 					qeth_next_hop_v4_rcu(skb, dst);
-	} else if (proto == htons(ETH_P_IPV6)) {
+		break;
+	case htons(ETH_P_IPV6):
 		l3_hdr->next_hop.addr = *qeth_next_hop_v6_rcu(skb, dst);
 
 		hdr->hdr.l3.flags |= QETH_HDR_IPV6;
 		if (!IS_IQD(card))
 			hdr->hdr.l3.flags |= QETH_HDR_PASSTHRU;
-	} else {
+		break;
+	case htons(ETH_P_AF_IUCV):
+		l3_hdr->next_hop.addr.s6_addr16[0] = htons(0xfe80);
+		memcpy(&l3_hdr->next_hop.addr.s6_addr32[2],
+		       iucv_trans_hdr(skb)->destUserID, 8);
+		l3_hdr->flags |= QETH_HDR_IPV6;
+		break;
+	default:
 		/* OSA only: */
 		l3_hdr->flags |= QETH_HDR_PASSTHRU;
 	}
-- 
2.17.1

