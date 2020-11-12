Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2642B0D84
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgKLTKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:10:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726255AbgKLTKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:38 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ1sn4167512;
        Thu, 12 Nov 2020 14:10:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=986sAIKUIcfZQmz4RRAz2gcNv3bdgtdfPoRlqD3uRGA=;
 b=BVICjXn/zoN4tTxV28iGyrgtX1OYBRFJavmhbUrJewViVan5zqk1VX/mYHzMB9i/Y0d8
 HwF057VdBVPmnYsGU5i5J2RrRWEmD1z8ZafumDOQ6FJICxceBl5Zh8EZ8wuTTrX+FeC1
 1rDC7FfYqHILogaXMwYhy9pfqOr4SgJ9Z9tsmaMBpeJqQZ9rMewFxzMtf63rFpkUUa+r
 aXo85A1unFEeBR7G7251f9CSQH7PLOs6qhVAO+XsamHUZjhzys4B3pgtV0ETxXL/p7Z4
 ogwWLO95DoY5srQOPUMesC4cMugGTcUVbOEvAPpvkvPh3c5itOdQqLHpaKg2WH8lLeUi PA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sab6s3kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:35 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJA0eH022554;
        Thu, 12 Nov 2020 19:10:34 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 34nk7rmurd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:34 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJAX1I2687596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:33 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B9F7AE06A;
        Thu, 12 Nov 2020 19:10:33 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CF67AE086;
        Thu, 12 Nov 2020 19:10:32 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:32 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 11/12] ibmvnic: Use netdev_alloc_skb instead of alloc_skb to replenish RX buffers
Date:   Thu, 12 Nov 2020 13:10:06 -0600
Message-Id: <1605208207-1896-12-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_09:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 suspectscore=1
 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>

Take advantage of the additional optimizations in netdev_alloc_skb when
allocating socket buffers to be used for packet reception.

Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e48a44d8884c..0791dbf1cba8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -323,7 +323,7 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	rx_scrq = adapter->rx_scrq[pool->index];
 	ind_bufp = &rx_scrq->ind_buf;
 	for (i = 0; i < count; ++i) {
-		skb = alloc_skb(pool->buff_size, GFP_ATOMIC);
+		skb = netdev_alloc_skb(adapter->netdev, pool->buff_size);
 		if (!skb) {
 			dev_err(dev, "Couldn't replenish rx buff\n");
 			adapter->replenish_no_mem++;
-- 
2.26.2

