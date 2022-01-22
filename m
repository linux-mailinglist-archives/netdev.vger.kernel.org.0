Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407B9496982
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiAVC7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:59:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbiAVC7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 21:59:25 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20M2ka87005758
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=M8lXwot3bWUCfQWe4pR0lJm+OYv0QDsRm6rf1ZqE8h8=;
 b=gedN908/+LcMpJtjLqAIi02cMFwZf2cdjwjXFs/wOoDgAIsS/sFU24DXs8eZA8zwMNHX
 jhNbdMLmIWmLGef4Mm/gHX37I9/wS418YlvZPwJk16FJLrBBhqSEaAAilChSJ4LZbjvt
 o2hX291HRA9bWv0u1NAXn0o2piJkVoDiBm5M3vHSlQ7x1HXT/0N6T/ydWJs5NPO4367E
 cum2+R4KjezGxlbcijkdWX/YUmJpLNeywLf+d3a7aCAqfgI+9b18asEuWgs3vTdmd1la
 rHRFXad0nQWOQ5AYc7E1++MFCg3t+dj4nJF/yPr18iPaijPAzAI0tH8VwsGHwEH87l0n gQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr9ejg4be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:24 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20M2ugfD012615
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:24 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3dr9j8r16d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:24 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20M2xNac35062092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Jan 2022 02:59:23 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E795328060;
        Sat, 22 Jan 2022 02:59:22 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5640B2805E;
        Sat, 22 Jan 2022 02:59:22 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.135.77])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 22 Jan 2022 02:59:22 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 1/4] ibmvnic: Allow extra failures before disabling
Date:   Fri, 21 Jan 2022 18:59:18 -0800
Message-Id: <20220122025921.199446-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v23NOrtY3rikaww-2Z3ZMV0jjnTe_ZaA
X-Proofpoint-GUID: v23NOrtY3rikaww-2Z3ZMV0jjnTe_ZaA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 adultscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201220010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If auto-priority-failover (APF) is enabled and there are at least two
backing devices of different priorities, some resets like fail-over,
change-param etc can cause at least two back to back failovers. (Failover
from high priority backing device to lower priority one and then back
to the higher priority one if that is still functional).

Depending on the timimg of the two failovers it is possible to trigger
a "hard" reset and for the hard reset to fail due to failovers. When this
occurs, the driver assumes that the network is unstable and disables the
VNIC for a 60-second "settling time". This in turn can cause the ethtool
command to fail with "No such device" while the vnic automatically recovers
a little while later.

Given that it's possible to have two back to back failures, allow for extra
failures before disabling the vnic for the settling time.

Fixes: f15fde9d47b8 ("ibmvnic: delay next reset if hard reset fails")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0bb3911dd014..9b2d16ad76f1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2598,6 +2598,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 	struct ibmvnic_rwi *rwi;
 	unsigned long flags;
 	u32 reset_state;
+	int num_fails = 0;
 	int rc = 0;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
@@ -2651,11 +2652,23 @@ static void __ibmvnic_reset(struct work_struct *work)
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
-			if (rc) {
-				/* give backing device time to settle down */
+			if (rc)
+				num_fails++;
+			else
+				num_fails = 0;
+
+			/* If auto-priority-failover is enabled we can get
+			 * back to back failovers during resets, resulting
+			 * in at least two failed resets (from high-priority
+			 * backing device to low-priority one and then back)
+			 * If resets continue to fail beyond that, give the
+			 * adapter some time to settle down before retrying.
+			 */
+			if (num_fails >= 3) {
 				netdev_dbg(adapter->netdev,
-					   "[S:%s] Hard reset failed, waiting 60 secs\n",
-					   adapter_state_to_string(adapter->state));
+					   "[S:%s] Hard reset failed %d times, waiting 60 secs\n",
+					   adapter_state_to_string(adapter->state),
+					   num_fails);
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
-- 
2.27.0

