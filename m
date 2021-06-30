Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6C3B8889
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhF3Siw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:38:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234297AbhF3Siu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:38:50 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15UIWuIk102540
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 14:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=/A4W+vtmgWnlwYkFUfqNtqLnSFNg0+097mLwQejjGtk=;
 b=lImxiIJPHlXmxjrHryaj/t9Ymnm/TYa5+ae9MIY4F+VSgZ4hUQA5335DMzRqI4xGkD5O
 HVW3tEzEGu4vpAkXXewl5cCWt+F8y0oN7/6kTAefeH82feGaCCwd/HnLzhrwvwcErNF5
 EZMc16sAkehMp3HKQ5xOS1g3I4IUlcXBpK7niGwwMYV809vysmg7SSoyN4eOEk8wux5G
 HGPndtHjj+HiPUGdN5MNHJZwXl974P3SfkPzbv6OfvXC5EBXVVP1OkRcU0n9S+fbMaCU
 YTf1rzhXNXpW7OK+TUy2gc5iWIUZjlgflxgEjP5KkRQy00Vqf8rwJaSBTyjFrxGY9eLS 7A== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39gv6ru43e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 14:36:20 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15UIY2Zm016346
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 18:36:19 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 39duvdye7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 18:36:19 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15UIaJhE31981836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 18:36:19 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F37F7AC05E;
        Wed, 30 Jun 2021 18:36:18 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A86BFAC05F;
        Wed, 30 Jun 2021 18:36:17 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 30 Jun 2021 18:36:17 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, brking@linux.vnet.ibm.com,
        ricklind@linux.vnet.ibm.com
Subject: [PATCH 1/1] ibmvnic: retry reset if there are no other resets
Date:   Wed, 30 Jun 2021 14:36:17 -0400
Message-Id: <20210630183617.3093690-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2lpF1NhqYw1blxYbbXA7ATQNk-Nc1ry-
X-Proofpoint-ORIG-GUID: 2lpF1NhqYw1blxYbbXA7ATQNk-Nc1ry-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_08:2021-06-30,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106300103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally, if a reset fails due to failover or other communication error
there is another reset (eg: FAILOVER) in the queue and we would process
that reset. But if we are unable to communicate with PHYP or VIOS after
H_FREE_CRQ, there would be no other resets in the queue and the adapter
would be in an undefined state even though it was in the OPEN state
earlier. While starting the reset we set the carrier to off state so
we won't even get the timeout resets.

If the last queued reset fails, retry it as a hard reset (after the
usual 60 second settling time).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 697b9714fc76..ff49cda142b0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2420,9 +2420,10 @@ static int do_passive_init(struct ibmvnic_adapter *adapter)
 
 static void __ibmvnic_reset(struct work_struct *work)
 {
-	struct ibmvnic_rwi *rwi;
 	struct ibmvnic_adapter *adapter;
 	bool saved_state = false;
+	struct ibmvnic_rwi *tmprwi;
+	struct ibmvnic_rwi *rwi;
 	unsigned long flags;
 	u32 reset_state;
 	int rc = 0;
@@ -2489,7 +2490,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		} else {
 			rc = do_reset(adapter, rwi, reset_state);
 		}
-		kfree(rwi);
+		tmprwi = rwi;
 		adapter->last_reset_time = jiffies;
 
 		if (rc)
@@ -2497,8 +2498,23 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 		rwi = get_next_rwi(adapter);
 
+		/*
+		 * If there is another reset queued, free the previous rwi
+		 * and process the new reset even if previous reset failed
+		 * (the previous reset could have failed because of a fail
+		 * over for instance, so process the fail over).
+		 *
+		 * If there are no resets queued and the previous reset failed,
+		 * the adapter would be in an undefined state. So retry the
+		 * previous reset as a hard reset.
+		 */
+		if (rwi)
+			kfree(tmprwi);
+		else if (rc)
+			rwi = tmprwi;
+
 		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
-			    rwi->reset_reason == VNIC_RESET_MOBILITY))
+			    rwi->reset_reason == VNIC_RESET_MOBILITY || rc))
 			adapter->force_reset_recovery = true;
 	}
 
-- 
2.18.2

