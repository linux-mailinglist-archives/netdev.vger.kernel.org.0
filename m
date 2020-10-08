Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7B287C10
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgJHTGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:06:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgJHTGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:06:46 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 098J3Mfx117351
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 15:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=257nyO53XDdwa+Kdzw+f02+Zpc+6657u4DZTzaq0NSg=;
 b=ZU/eoNvwXSlOcinXhmsCqbjANo8an94Zh9n8nljVeMWFWfX0H85JQHNE5nFaL0AXTcoQ
 YgZi/WHjI7w2wma/OeNtu8Xig6jlY9ArBOCPpJ25EwFf4VPZg/ZckIhTEjDsbNzemg63
 VB2IfaztpFCgHBxYITzgxWoBqdzszlL5efDqFIKxjUo/yIYUM9jPcEtVG7LJ0DKG1R3R
 cVOFhL7KVbQRS6+d/teDS8LvW2lxDGjw7iT3AnzUKdKda9tgMPJlRpyVFRFqqEn38hqS
 rnW3rvi45B+RSey0E42RwqjOah6bAV0GlLLuCHeLJbTm7PTxiU8ny6Pwoxw+k+07aMqa ww== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3428j0g6am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 15:06:45 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 098Ipe6D014458
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 19:06:44 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 33xgxa3u5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 19:06:44 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 098J6fha51773862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Oct 2020 19:06:41 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A16FFBE058;
        Thu,  8 Oct 2020 19:06:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 493C4BE054;
        Thu,  8 Oct 2020 19:06:40 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.28.108])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Oct 2020 19:06:40 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
Subject: [ PATCH v1 2/2] ibmveth: Identify ingress large send packets.
Date:   Thu,  8 Oct 2020 12:05:38 -0700
Message-Id: <20201008190538.6223-3-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20201008190538.6223-1-dwilder@us.ibm.com>
References: <20201008190538.6223-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-08_12:2020-10-08,2020-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=1 impostorscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ingress large send packets are identified by either:
The IBMVETH_RXQ_LRG_PKT flag in the receive buffer
or with a -1 placed in the ip header checksum.
The method used depends on firmware version.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 3935a7e..e357cbe 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1349,6 +1349,7 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
 			int offset = ibmveth_rxq_frame_offset(adapter);
 			int csum_good = ibmveth_rxq_csum_good(adapter);
 			int lrg_pkt = ibmveth_rxq_large_packet(adapter);
+			__sum16 iph_check = 0;
 
 			skb = ibmveth_rxq_get_buffer(adapter);
 
@@ -1385,7 +1386,17 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
 
-			if (length > netdev->mtu + ETH_HLEN) {
+			/* PHYP without PLSO support places a -1 in the ip
+			 * checksum for large send frames.
+			 */
+			if (be16_to_cpu(skb->protocol) == ETH_P_IP) {
+				struct iphdr *iph = (struct iphdr *)skb->data;
+
+				iph_check = iph->check;
+			}
+
+			if ((length > netdev->mtu + ETH_HLEN) ||
+			    lrg_pkt || iph_check == 0xffff) {
 				ibmveth_rx_mss_helper(skb, mss, lrg_pkt);
 				adapter->rx_large_packets++;
 			}
-- 
1.8.3.1

