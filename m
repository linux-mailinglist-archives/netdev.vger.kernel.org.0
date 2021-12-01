Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1234646D9
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 06:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346801AbhLAFwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 00:52:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22748 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346798AbhLAFwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 00:52:01 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B14qYne026267
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 05:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EoNrl1Ufn7DQ4MrzXIeaYu7E0Ok7GvXeWmLw3pwZa6o=;
 b=rDHdq47ua79qtdLLafeDpcBzt2yA3dLySrcFumuNELLhDRAhApF7z1mv4hBv8lXK9bCC
 79me9MgjUyPvhXlcK9YczbzFUwubtHIsHsv28nviXBNKcjuxP73hZnU866Zbn0iY/drs
 m7w2Z5EhltHZaJiTX/cbBXNPhuElvXzFLMNRR+rjCjNySOUBRewYVpVPTW70DAHPgEXL
 fntichn6m69iX+uMDODWAkHjyiHJfV0IOznUZo91iNuYUFyETUxuFlEusXCif5YnVZ7u
 o1y2QYfW8aa71UyEz1qbdb9dM2jkfwQeBwI8FUJN/33bLNZfO1ieyKmSaEn3dvfhGpGB sw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cp2dj0ryg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 05:48:40 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B15h7Gf025360
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 05:48:40 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3ckcabw24e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 05:48:40 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B15mdPF66650496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 05:48:39 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CECE112063;
        Wed,  1 Dec 2021 05:48:39 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DAF7112061;
        Wed,  1 Dec 2021 05:48:38 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.98.147])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Dec 2021 05:48:38 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 2/2] ibmvnic: drop bad optimization in reuse_tx_pools()
Date:   Tue, 30 Nov 2021 21:48:36 -0800
Message-Id: <20211201054836.3488211-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201054836.3488211-1-sukadev@linux.ibm.com>
References: <20211201054836.3488211-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y8DzucqR4VONNQpF_0NajYCPvBfh8UKg
X-Proofpoint-ORIG-GUID: Y8DzucqR4VONNQpF_0NajYCPvBfh8UKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112010031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When trying to decide whether or not reuse existing rx/tx pools
we tried to allow a range of values for the pool parameters rather
than exact matches. This was intended to reuse the resources for
instance when switching between two VIO servers with different
default parameters.

But this optimization is incomplete and breaks when we try to
change the number of queues for instance. The optimization needs
to be updated, so drop it for now and simplify the code.

Fixes: bbd809305bc7 ("ibmvnic: Reuse tx pools when possible")
Reported-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6df92a872f0f..0bb3911dd014 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -866,17 +866,9 @@ static bool reuse_tx_pools(struct ibmvnic_adapter *adapter)
 	old_mtu = adapter->prev_mtu;
 	new_mtu = adapter->req_mtu;
 
-	/* Require MTU to be exactly same to reuse pools for now */
-	if (old_mtu != new_mtu)
-		return false;
-
-	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
-		return true;
-
-	if (old_num_pools < adapter->min_tx_queues ||
-	    old_num_pools > adapter->max_tx_queues ||
-	    old_pool_size < adapter->min_tx_entries_per_subcrq ||
-	    old_pool_size > adapter->max_tx_entries_per_subcrq)
+	if (old_mtu != new_mtu ||
+	    old_num_pools != new_num_pools ||
+	    old_pool_size != new_pool_size)
 		return false;
 
 	return true;
-- 
2.27.0

