Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01352E21BD
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgLWUtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:49:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbgLWUtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 15:49:47 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BNKWbTJ126526
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 15:49:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gXDpKvx06M5Wd+TjOFrD8jKaEbcdLfRoSo2QnSpZeR4=;
 b=MDYamFH2YSdd3VaC3AI5VEPAWwFQYKnw7AKCHpUkOOUrLQTxh5imSJo447OMibsAjRPa
 I5LzRSiexenHP/svsmmhVTtB1OqiT70dvs9DxzCv8/X/9+i1I+UN3mXjehiriTTUahP0
 orYNfkIdsLzmP8+3e9EJSCG2eBhZS5nr3QjNSJBe3xQnvqzgXAWlEc34BRzaUmbYHk/j
 aGlIhg8ubalw8KvQRUXnnT7bEKCYogXIhyJcBQ5l2abuQ0yt64XG1g09xbbKmpiknuef
 9z/nk4T2wlquhMBKbvJ3Giv15WVOp65EJbWqN9/NyQlY4Wb73XamhPR/sMi8dWK6KDnM qQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35mb6k2jfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 15:49:06 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BNKklJS027554
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 20:49:05 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 35m87kt70u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 20:49:05 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BNKn4I925690610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 20:49:04 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A38F2124053;
        Wed, 23 Dec 2020 20:49:04 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65E22124052;
        Wed, 23 Dec 2020 20:49:04 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.163.68])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 20:49:04 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2] ibmvnic: continue fatal error reset after passive init
Date:   Wed, 23 Dec 2020 14:49:04 -0600
Message-Id: <20201223204904.12677-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-23_12:2020-12-23,2020-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
says "If the passive
CRQ initialization occurs before the FATAL reset task is processed,
the FATAL error reset task would try to access a CRQ message queue
that was freed, causing an oops. The problem may be most likely to
occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
process will automatically issue a change MTU request.
Fix this by not processing fatal error reset if CRQ is passively
initialized after client-driven CRQ initialization fails."

The original commit skips a specific reset condition, but that does
not fix the problem it claims to fix, and misses a reset condition.
The effective fix is commit 0e435befaea4 ("ibmvnic: fix NULL pointer
dereference in ibmvic_reset_crq") and commit a0faaa27c716 ("ibmvnic:
fix NULL pointer dereference in reset_sub_crq_queues"). With above
two fixes, there are no more crashes seen as described even without
the original commit, so I would like to revert the original commit.

Fixes: f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: reword the commit message to explain it better.

 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b370c88a43f1..237a36040689 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2342,8 +2342,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
-		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
-				adapter->from_passive_init)) {
+		} else {
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);
-- 
2.23.0

