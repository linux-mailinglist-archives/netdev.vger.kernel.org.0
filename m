Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8C33FD01F
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242778AbhIAALQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:11:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243428AbhIAAJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:09:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18104miS124165
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uo+Z5YO8LnXN1Bt11bBCRiR2QZj19IWtkCnnPE30WLQ=;
 b=ijdZ/rQz8pkuHTPqUZ3JW62UoZEtSkoKtEERfwzmWTWtSCFn4nLmV4HZyKFXCaDYYCBu
 EW7KbuBNBwop+Xi4Ay9O8beuzV9C3P0TG4/n5GjSpZX+Phd7A6pTq2p3VTfTF8OXGRIZ
 ZWkrPsRaxQMFaTh3Jc9UyunICIIDK3DrxwMLir8+DL88AsktFmYcGbOu9QMoZAvkw0NP
 /e2X5+7iGIeMf6YwDUS8YJamSz+W5Wj52G2pjupgbTp8eOJ2ZxZA7YeZbsJslWqu57rf
 hUbn5odp0dk3+PSkpE4+449spjA+fZqt0Eny8bUI0QboTLucLDs/8VTMmOQCJrSg8nxB FA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aswpw97g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:25 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VNuaw2022862
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 00:08:25 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3aqcsdj1bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:08:25 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18108Nxt38535476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 00:08:23 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 704B078066;
        Wed,  1 Sep 2021 00:08:23 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 214177805C;
        Wed,  1 Sep 2021 00:08:22 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.237.107])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 00:08:21 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 5/9] ibmvnic: init_tx_pools move loop-invariant code out
Date:   Tue, 31 Aug 2021 17:08:08 -0700
Message-Id: <20210901000812.120968-6-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gcZ5O1mtCMzp6hzMnZ5H3VkdfGQ7PUYd
X-Proofpoint-GUID: gcZ5O1mtCMzp6hzMnZ5H3VkdfGQ7PUYd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In init_tx_pools() move some loop-invariant code out of the loop.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4c6739b250df..8894afdb3cb3 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -839,11 +839,10 @@ static int init_tx_pools(struct net_device *netdev)
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
2.31.1

