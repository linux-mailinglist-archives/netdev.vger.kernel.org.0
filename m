Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B112CA77E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391959AbgLAPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:53:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389694AbgLAPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:53:15 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FXCLJ001684;
        Tue, 1 Dec 2020 10:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=cEa9wJ96I/Gq+VnJlinTU4XhWP8zhBZZp6rL9Pt1tPM=;
 b=nv/Y4LLqwksiOcdiD7Wkg83o2etMl2UD9DwgWxinoMvnfmtlTN7h9ysKAQlqeb18iH8R
 Rycyh9eEFqTr0sYTNxeSh3d53vj7zxO86CjdI2I0DYXfQd+G7QkASsqhFPOOG+90RZ48
 ut3vxWKnxyoexHDH+F200TyhdkyKlUqqoJkpUg2B12R8+0SJitPIfRu15DjLR0FLZ7I7
 /9h4H5YB8swpLhkHwqulhRDlTRHm42Iyx2T8J0RtMrB5/rtHIrurwPCBodf/n80uaCCV
 nCQzvoQCMjOqDRmPuR8/3shmHX40P5hBbYYVYpMUlaTmtVUScQIYIS9EE/4e05zDXs8f Zw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355he3yrvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 10:52:24 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FXLwq011626;
        Tue, 1 Dec 2020 15:52:23 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 353e6919fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 15:52:23 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1FqNZf20644740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 15:52:23 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2843FAE063;
        Tue,  1 Dec 2020 15:52:23 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 148DDAE062;
        Tue,  1 Dec 2020 15:52:22 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.5.242])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 15:52:21 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     mpe@ellerman.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, cforno12@linux.ibm.com,
        ljp@linux.vnet.ibm.com, ricklind@linux.ibm.com,
        dnbanerg@us.ibm.com, drt@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tlfalcon@linux.ibm.com
Subject: [PATCH net v3 2/2] ibmvnic: Fix TX completion error handling
Date:   Tue,  1 Dec 2020 09:52:11 -0600
Message-Id: <1606837931-22676-3-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606837931-22676-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1606837931-22676-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 suspectscore=1 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX completions received with an error return code are not
being processed properly. When an error code is seen, do not
proceed to the next completion before cleaning up the existing
entry's data structures.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5ea9f5c..10878f8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3113,11 +3113,9 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
-			if (next->tx_comp.rcs[i]) {
+			if (next->tx_comp.rcs[i])
 				dev_err(dev, "tx error %x\n",
 					next->tx_comp.rcs[i]);
-				continue;
-			}
 			index = be32_to_cpu(next->tx_comp.correlators[i]);
 			if (index & IBMVNIC_TSO_POOL_MASK) {
 				tx_pool = &adapter->tso_pool[pool];
-- 
1.8.3.1

