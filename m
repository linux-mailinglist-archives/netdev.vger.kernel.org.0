Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23A53FE1B7
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346685AbhIASHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:07:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38606 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345478AbhIASHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:07:00 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181I3QqO095708
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 14:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/STvjzj5KsmkCt1yq1JYgvvnD8RXosDpF7js/9V3idA=;
 b=Mnp7GxBQbT/3IU1Vkh1pIpt0cCN8xFoXm8///3s35qdT5dXa0rLMW6OYKam6xW/p/Gh6
 G6c1z9FiMuuVxhQknrBjnuPN+HvTQubKOaFgbWvCJIYA7t36wMHCUkprwXP9cXJ2qne5
 hBGP+of1RvIDQprwx2fZvANbyWmBzuCgo4CliE6kYYBjb9/+fjOcYCrJ8bH3o4MFVoxg
 LKoGYy7psFWTSb9AL0huiPT7Y6NfLKWeBBHcxMUIT68+1eqnrIKPrcpce46EGn9F1a1s
 GZ4Z38TwEQu1bolGfhB3XfYOr/kJNCWm+Zsloc73FTFrmOOwnkMBlprJUqlc4NL0zPXf kw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ate1ngrq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:06:02 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181I2nId007636
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 18:06:01 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3atdxd0r7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 18:06:01 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181I60da30998926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 18:06:00 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C84A12405B;
        Wed,  1 Sep 2021 18:06:00 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E913B124052;
        Wed,  1 Sep 2021 18:05:58 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.152.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 18:05:58 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next v2 5/9] ibmvnic: init_tx_pools move loop-invariant code
Date:   Wed,  1 Sep 2021 11:05:47 -0700
Message-Id: <20210901180551.150126-6-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901180551.150126-1-sukadev@linux.ibm.com>
References: <20210901180551.150126-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1voxR6bbwFzm-dBb1vt_LIRfOuORkNyA
X-Proofpoint-GUID: 1voxR6bbwFzm-dBb1vt_LIRfOuORkNyA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109010104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In init_tx_pools() move some loop-invariant code out of the loop.

Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 97041b319beb..bb9b8aec9c9b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -843,11 +843,10 @@ static int init_tx_pools(struct net_device *netdev)
 	 * allocation, release_tx_pools() will know how many to look for.
 	 */
 	adapter->num_active_tx_pools = num_pools;
+	buff_size = adapter->req_mtu + VLAN_HLEN;
+	buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 
 	for (i = 0; i < num_pools; i++) {
-		buff_size = adapter->req_mtu + VLAN_HLEN;
-		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
-
 		dev_dbg(dev, "Init tx pool %d [%llu, %llu]\n",
 			i, adapter->req_tx_entries_per_subcrq, buff_size);
 
-- 
2.26.2

