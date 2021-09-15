Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4ED40BEA0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhIODyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236500AbhIODyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F3BtBL029878
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/STvjzj5KsmkCt1yq1JYgvvnD8RXosDpF7js/9V3idA=;
 b=q7jm6VBdhISUpw8Kj+OGPEHUjR0NQ9PcWMYR+i30/i7WQz0I/UwktGxsWn3KFbq7hNvJ
 xlTel90D2FyjVxhuOwHQEOj8MppAHe016OM5AsGwB+g1va3ObKVfxVtn1TQVoPfF3iLn
 tKvo8lENj10CuKZFHm9DPODPdzrw7dAqv3xN/irNruJtX0VfWNfqGNrPIvvYZj3qL8w5
 JdSRTKIkdd2hYghMoSe158L61bo3+fPKK9VyASZwUc9KpZHJuDIisr1Wk/Yj855QSxH1
 ZVehCmmVTqOFWib/sIF50n5nUmDhM/9Oe+0sBO4pqiYyB8Lei0DYySFp63HJEm5OMqnF 4w== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b353fvhhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:14 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lNw0030301
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:13 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3b0m3d9ja8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:13 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3rCq922282534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:12 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B2FB112061;
        Wed, 15 Sep 2021 03:53:12 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BA40112065;
        Wed, 15 Sep 2021 03:53:10 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:10 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 5/9] ibmvnic: init_tx_pools move loop-invariant code
Date:   Tue, 14 Sep 2021 20:52:55 -0700
Message-Id: <20210915035259.355092-6-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FLoW7UlT8wG-P8s-9fOyfJmhIInUeN1y
X-Proofpoint-GUID: FLoW7UlT8wG-P8s-9fOyfJmhIInUeN1y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140123
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

