Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695C72B895A
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgKSBNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:13:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbgKSBNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:13:00 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ11eaX055163;
        Wed, 18 Nov 2020 20:12:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=RW8PkHI+RwRdpzY+4wfvgan4oS1YZyc8w8Zc30iQF2s=;
 b=K6QWCNSYsRWvyKxEDngkXuAVXsOpUFvP1RV24caJ5BFCc8uGWzUwywwuuTfm/hWWYpx8
 ThH1C4kAfy2CUuT+RnMxdc2Ha8yPm6BqVksgdhLcOVbH28cfk/GmBiDjZnBCgyKPqi4z
 UZ93dWJuHbrqNBxHaUEty080Gml0lLURJkVUk9/MoKeF1hOFdpsF6GL+oS4P6KPYRyVw
 gAL4Yg965g/KkygwBZUP4AwkAy1kC9DNyjgomgf2x3c2MQ7OVaaIZzUekjiDQS2YMqIv
 JE2QxgKcuXWTf3zMspE7cbJusUcm7QLLAWrwHwLGeBVFFoAlerbD1RVgy0ZpDVDkK3+Y sA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w8pc2717-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 20:12:57 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ17SoF004834;
        Thu, 19 Nov 2020 01:12:56 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 34w262x80v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 01:12:56 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ1CngB7864978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 01:12:49 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 201C06A057;
        Thu, 19 Nov 2020 01:12:55 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CFA36A04F;
        Thu, 19 Nov 2020 01:12:53 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.199.179])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 01:12:53 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net-next v2 8/9] ibmvnic: Use netdev_alloc_skb instead of alloc_skb to replenish RX buffers
Date:   Wed, 18 Nov 2020 19:12:24 -0600
Message-Id: <1605748345-32062-9-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 suspectscore=1 bulkscore=0 impostorscore=0 mlxlogscore=961
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190000
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
index 596546f0614d..96df6d8fa277 100644
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

