Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840A711B1CD
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387820AbfLKPcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:32:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733047AbfLKPcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:32:52 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBFWPGb080981;
        Wed, 11 Dec 2019 10:32:44 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wtf83van8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 10:32:43 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBBFBPpg002198;
        Wed, 11 Dec 2019 15:32:43 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 2wr3q6y9j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 15:32:43 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBFWg1S54264180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 15:32:42 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B252AE05F;
        Wed, 11 Dec 2019 15:32:42 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03A43AE05C;
        Wed, 11 Dec 2019 15:32:41 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 15:32:41 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@ozlabs.org, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH] net/ibmvnic: Fix typo in retry check
Date:   Wed, 11 Dec 2019 09:32:39 -0600
Message-Id: <1576078359-9220-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_04:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 mlxscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This conditional is missing a bang, with the intent
being to break when the retry count reaches zero.

Fixes: 476d96ca9c ("ibmvnic: Bound waits for device queries")
Suggested-by: Juliet Kim <minkim@linux.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index efb0f10..2d84523 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -184,7 +184,7 @@ static int ibmvnic_wait_for_completion(struct ibmvnic_adapter *adapter,
 			netdev_err(netdev, "Device down!\n");
 			return -ENODEV;
 		}
-		if (retry--)
+		if (!retry--)
 			break;
 		if (wait_for_completion_timeout(comp_done, div_timeout))
 			return 0;
-- 
1.8.3.1

