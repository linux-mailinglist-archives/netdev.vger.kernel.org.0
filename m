Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC2031A9AA
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBMCtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:49:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231394AbhBMCtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:49:45 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11D2XWPc002244
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:49:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=9RyRAK2kYCPPIRFaaq0a1bMae3EJqGoAckUmYu049a4=;
 b=nBumxHA1vjTRhApDfh9981UbUqiTR91+UyjtdPPdZ+n013q+/z5RaKfNAlL3AZ10HkJ+
 2fX3knAL0k9uCPhoH5lZTVDJsTUtv0ocUWzUs1fHcMPtX6lDbzcx+XUqGwplDEtPZD8i
 oideMSBA5ZSWqu+cStSWJID+Q6efoSdQ6qVW5WfCPmfdHMilMy4R52Fma6NQMF48KHdz
 9Cs2MabzATUBC9E5B72/R2Vc3Bj/FJ8ateA+BKjUSC4A2Qun6iWjdiqLLdHdblJAJ/RP
 XzBGOT4OHj5KEG2xloJlgcRVt+0Xl7+UqR6evxKxIHa4H2R8tEnvCPVgFwv5qZGreYbW Pw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36p5mn0sfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:49:04 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11D2lGhV008940
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:49:03 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 36hjra5wf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:49:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11D2n2aI27853202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Feb 2021 02:49:02 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D278C605A;
        Sat, 13 Feb 2021 02:49:02 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66AAAC6055;
        Sat, 13 Feb 2021 02:49:01 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.198.213])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 13 Feb 2021 02:49:01 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] ibmvnic: skip send_request_unmap for timeout reset
Date:   Fri, 12 Feb 2021 20:49:00 -0600
Message-Id: <20210213024900.56081-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Timeout reset will trigger the VIOS to unmap it automatically,
similarly as FAILVOER and MOBILITY events. If we unmap it
in the linux side, we will see errors like
"30000003: Error 4 in REQUEST_UNMAP_RSP".
So, don't call send_request_unmap for timeout reset.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 621be6d2da97..c8b0d99608d5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -247,8 +247,13 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	if (!ltb->buff)
 		return;
 
+	/* VIOS automatically unmaps the long term buffer at remote
+	 * end for the following resets:
+	 * FAILOVER, MOBILITY, TIMEOUT.
+	 */
 	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
-	    adapter->reset_reason != VNIC_RESET_MOBILITY)
+	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
+	    adapter->reset_reason != VNIC_RESET_TIMEOUT)
 		send_request_unmap(adapter, ltb->map_id);
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 }
-- 
2.23.0

