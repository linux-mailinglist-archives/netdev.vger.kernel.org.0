Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572F32B0D88
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgKLTK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:10:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726802AbgKLTKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:36 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ1PYk119936;
        Thu, 12 Nov 2020 14:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=n4nrn7goqWNqID2P3GWInfj++ypdU3HDfR79ps/YCQg=;
 b=nk5NTIfaGeJtuYoJupM8U0FFD/7QPrVzoIvgatvUMaisD0Zjrsi9XAT15PY0i7qvQXNx
 4lxolpEmIOfnyAiGRjnXUpJqQCjfTLvgXPQW1AB7gYPeEz0bKrrD5OdQro8Elgf/B9NR
 ZKbXROsm95798EpXtUB4BfuFf+F5iiUtAzRy5vqIeAnrsioPdpRuNZQaNwGi1Ria4H5H
 +yT5fFCQgFfnamevR7lfxWJDd264VfbyqNF1N6LUVnKqKPh/mX/XLrrXYGALpf29r3su
 SXoYKKpkRFYHqTsF0ogy69h0EBxf2upXiEaotODqIncEFLWRwdLGH1fSUnCCZ5ipRDWr rA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34s5urknhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:27 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ75J5011362;
        Thu, 12 Nov 2020 19:10:27 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 34nk79mv4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:27 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJAQgI36110722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:26 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D1DAE060;
        Thu, 12 Nov 2020 19:10:26 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83297AE091;
        Thu, 12 Nov 2020 19:10:25 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:25 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 05/12] ibmvnic: Fix TX completion error handling
Date:   Thu, 12 Nov 2020 13:10:00 -0600
Message-Id: <1605208207-1896-6-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_10:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 spamscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When firmware reports that a transmission was not successful,
the driver is not correctly processing the completion.
It should be freeing the socket buffer and updating the
device queue's inflight frame count and BQL structures.
Do that now.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0f6aba760d65..c9437b2d1aa8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3153,10 +3153,12 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		/* ensure that we are reading the correct queue entry */
 		dma_rmb();
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
+			bool error = false;
+
 			if (next->tx_comp.rcs[i]) {
 				dev_err(dev, "tx error %x\n",
 					next->tx_comp.rcs[i]);
-				continue;
+				error = true;
 			}
 			index = be32_to_cpu(next->tx_comp.correlators[i]);
 			if (index & IBMVNIC_TSO_POOL_MASK) {
@@ -3179,7 +3181,10 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 			num_entries += txbuff->num_entries;
 			if (txbuff->skb) {
 				total_bytes += txbuff->skb->len;
-				dev_consume_skb_irq(txbuff->skb);
+				if (error)
+					dev_kfree_skb_irq(txbuff->skb);
+				else
+					dev_consume_skb_irq(txbuff->skb);
 				txbuff->skb = NULL;
 			} else {
 				netdev_warn(adapter->netdev,
-- 
2.26.2

