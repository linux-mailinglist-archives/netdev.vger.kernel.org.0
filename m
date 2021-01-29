Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF74308459
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhA2DsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:48:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60154 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231556AbhA2Dr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:47:57 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10T3Vi0f067851
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 22:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2OK9HQnOm81U9f7PG6mlCRH8Vdn0DJlhPAgudGoriDY=;
 b=XotrR7CiLWzg5NHFo/In70ujLkRiqDkSpudE0ML5D55BCF5QPnXQZ1wjIx2ODMsFYx+P
 sRmemk36x2izy87pLIpI0Spo47Km1Dm6nGRm2q1xudvhuR4kIOFKTXUcF0TMn9UaEMQI
 yDwUfGtShFd8sbqMjoqyl0+Pu0hixfWhrrKff5kV9gR53ml8gTAstVciuUxQr/Uw5fqX
 StBdjC5JfFdYk1RocCfF2AD5e/YlwGvkqidDdct2hstIOrWbY7SWpr93g3k8xTICekqW
 qakGCfUy11b2sKNpoh21qnLkpMT106cBTPnjOpxbMKIxUelNipmCqaC0eJSI4Wi7XCtx lg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36c3wv8nk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 22:47:15 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10T3WjM8010978
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:47:14 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 36a4mcfe1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:47:14 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10T3lDQt9765186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 03:47:13 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01791AE06D;
        Fri, 29 Jan 2021 03:47:12 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36CDDAE063;
        Fri, 29 Jan 2021 03:47:12 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.183.51])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Jan 2021 03:47:12 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com,
        sukadev@linux.ibm.com
Subject: [PATCH net 1/2] ibmvnic: fix a race between open and reset
Date:   Thu, 28 Jan 2021 19:47:10 -0800
Message-Id: <20210129034711.518250-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ibmvnic_reset() currently reads the adapter->state before getting the
rtnl and saves that state as the "target state" for the reset. If this
read occurs when adapter is in PROBED state, the target state would be
PROBED.

Just after the target state is saved, and before the actual reset process
is started (i.e before rtnl is acquired) if we get an ibmvnic_open() call
we would move the adapter to OPEN state.

But when the reset is processed (after ibmvnic_open()) drops the rtnl),
it will leave the adapter in PROBED state even though we already moved
it to OPEN.

To fix this, use the RTNL to improve the serialization when reading/updating
the adapter state. i.e determine the target state of a reset only after
getting the RTNL. And if a reset is in progress during an open, simply
set the target state of the adapter and let the reset code finish the
open (like we currently do if failover is pending).

One twist to this serialization is if the adapter state changes when we
drop the RTNL to update the link state. Account for this by checking if
there was an intervening open and update the target state for the reset
accordingly (see new comments in the code). Note that only the reset
functions and ibmvnic_open() can set the adapter to OPEN state and this
must happen under rtnl.

Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during device reset")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 72 +++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8820c98ea891..cb7ddfefb03e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1197,12 +1197,26 @@ static int ibmvnic_open(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
-	/* If device failover is pending, just set device state and return.
-	 * Device operation will be handled by reset routine.
+	WARN_ON_ONCE(!rtnl_is_locked());
+
+	/**
+	 * If device failover is pending or we are about to reset, just set
+	 * device state and return. Device operation will be handled by reset
+	 * routine.
+	 *
+	 * It should be safe to overwrite the adapter->state here. Since
+	 * we hold the rtnl, either the reset has not actually started or
+	 * the rtnl got dropped during the set_link_state() in do_reset().
+	 * In the former case, no one else is changing the state (again we
+	 * have the rtnl) and in the latter case, do_reset() will detect and
+	 * honor our setting below.
 	 */
-	if (adapter->failover_pending) {
+	if (adapter->failover_pending || (test_bit(0, &adapter->resetting))) {
+		netdev_dbg(netdev, "[S:%d FOP:%d] Resetting, deferring open\n",
+			   adapter->state, adapter->failover_pending);
 		adapter->state = VNIC_OPEN;
-		return 0;
+		rc = 0;
+		goto out;
 	}
 
 	if (adapter->state != VNIC_CLOSED) {
@@ -1222,10 +1236,12 @@ static int ibmvnic_open(struct net_device *netdev)
 
 out:
 	/*
-	 * If open fails due to a pending failover, set device state and
-	 * return. Device operation will be handled by reset routine.
+	 * If open failed and there is a pending failover or in-progress reset,
+	 * set device state and return. Device operation will be handled by
+	 * reset routine. See also comments above regarding rtnl.
 	 */
-	if (rc && adapter->failover_pending) {
+	if (rc &&
+	    (adapter->failover_pending || (test_bit(0, &adapter->resetting)))) {
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 	}
@@ -1939,6 +1955,14 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
 		   rwi->reset_reason);
 
+	/* read the state and check (again) after getting rtnl */
+	reset_state = adapter->state;
+
+	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
+		rc = -EBUSY;
+		goto out;
+	}
+
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
 
@@ -2037,6 +2061,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
 		adapter->failover_pending = false;
 
+	/* read the state and check (again) after getting rtnl */
+	reset_state = adapter->state;
+
+	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
+		rc = -EBUSY;
+		goto out;
+	}
+
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
 
@@ -2063,7 +2095,25 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		if (rc)
 			goto out;
 
+		if (adapter->state == VNIC_OPEN) {
+			/**
+			 * When we dropped rtnl, ibmvnic_open() got it and
+			 * noticed that we are resetting and set the adapter
+			 * state to OPEN. Update our new "target" state,
+			 * and resume the reset from VNIC_CLOSING state.
+			 */
+			netdev_dbg(netdev,
+				   "Open changed state from %d, updating.\n",
+				    reset_state);
+			reset_state = VNIC_OPEN;
+			adapter->state = VNIC_CLOSING;
+		}
+
 		if (adapter->state != VNIC_CLOSING) {
+			/**
+			 * If someone else changed the adapter state
+			 * when we dropped the rtnl, fail the reset
+			 */
 			rc = -1;
 			goto out;
 		}
@@ -2197,6 +2247,14 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	netdev_dbg(adapter->netdev, "Hard resetting driver (%d)\n",
 		   rwi->reset_reason);
 
+	/* read the state and check (again) after getting rtnl */
+	reset_state = adapter->state;
+
+	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
+		rc = -EBUSY;
+		goto out;
+	}
+
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
 
-- 
2.26.2

