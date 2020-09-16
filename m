Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3060D26CE67
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgIPWMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:12:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61378 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgIPWMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:12:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08GM1eZD001388
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 18:12:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=NC7PxbahHKMtMcKAQIHruIRdO/6Dpqo2/kTXHrK9Um0=;
 b=MfChwlF3AQEthJhwrcXeqjqxLBglcZZ5TS8Iz5Fn7T7xkCZpIRppVduZgiLyCZZVX0Eb
 TMa04AlC2gxD9sqY5/ZYkyvwx9F1dmHUnJkBrs1hH30QD5PRMUAfbzTKyOO0D4LC3Voq
 yP77qi1fzdgdzCdTuDBAa6DJaEE0F4D4lvVi4wqGtaZg2OemmPDhzqnBQ5Cuh2mpJ0Eb
 9JX4YQXfvN48abzdgsssu05P0Iy4ubsdRYnv1Ygki/W+qjnVVfKdT76d7XWr9fphIfRB
 qsbDVQQCmzKRgYiAc+XYpUdSpr/FC70TthcB9o2OXPRzRR4QIsxrhADqvxscnkRLHCVf mA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ksntte7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 18:12:43 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08GMBx74023698
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:12:41 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 33k675yr3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:12:41 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08GMCftk52625780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 22:12:41 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7042BAC060;
        Wed, 16 Sep 2020 22:12:41 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2279DAC064;
        Wed, 16 Sep 2020 22:12:41 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.243.76])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 16 Sep 2020 22:12:41 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmvnic: Fix returning uninitialized return code
Date:   Wed, 16 Sep 2020 17:12:37 -0500
Message-Id: <1600294357-19302-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_13:2020-09-16,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=1 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160156
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If successful, __ibmvnic_open and reset_sub_crq_queues,
if no device queues exist, will return an uninitialized
variable rc. Return zero on success instead.

Fixes: 57a49436f4e8 ("ibmvnic: Reset sub-crqs during driver reset")
Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1b702a4..1619311 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1178,7 +1178,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 	}
 
 	adapter->state = VNIC_OPEN;
-	return rc;
+	return 0;
 }
 
 static int ibmvnic_open(struct net_device *netdev)
@@ -2862,7 +2862,7 @@ static int reset_sub_crq_queues(struct ibmvnic_adapter *adapter)
 			return rc;
 	}
 
-	return rc;
+	return 0;
 }
 
 static void release_sub_crq_queue(struct ibmvnic_adapter *adapter,
-- 
1.8.3.1

