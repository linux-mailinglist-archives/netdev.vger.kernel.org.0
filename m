Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6746315FDD
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhBJHKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:10:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231915AbhBJHKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:10:34 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11A750LF165135
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 02:09:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=MjjUnLdtVJ8XwCoH0isLCFFhUbw1k65w5pl5SMXegiQ=;
 b=pzh6RFOLy2e+LrsIC/7f+6jrBcq6x8RKjEKVwmX3Zv2X51IWaY1zDrsGRU+Fq73RNuq8
 ax9kXFsIbUpeB1EH1bo9rRI/+GQifem3TtuwngULdJipbJ++sfUu/XmfBHvE1BedSG8v
 sRVDV0qKssoPuU+c7EJrUvXDp3HvhRS3/xyLM9va3oSvwPhoTM9ZEUt6FMXvbinPwJ51
 cRtG8xWLiWKezjvt0rrhpNlYa8jdNlu4quGw4OGtBTsAHeejYH/lDfLcuVnT3fITQUu4
 9FM4v1veTlmfhA4K1sXLTh9Nk0bI72yEYf9RT6B4XK0YZ7WlDtkfb09LSOyB5/GILNKh 9w== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36mahg0mht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 02:09:52 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11A72jET020293
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:09:52 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 36hjr9bdqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:09:52 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11A79pQm20382204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:09:51 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E57B6A04D
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:09:51 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E146C6A057
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:09:50 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.171.114])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:09:50 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id D70432E1070; Tue,  9 Feb 2021 23:09:47 -0800 (PST)
Date:   Tue, 9 Feb 2021 23:09:47 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com
Subject: [PATCH net v3] ibmvnic: fix a race between open and reset
Message-ID: <20210210070947.GA852317@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_01:2021-02-09,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From 0d6616e843973d2f052ea09237c16667802b52e3 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Date: Wed, 20 Jan 2021 21:10:15 -0800
Subject: [PATCH net v3] ibmvnic: fix a race between open and reset

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
Reviewed-by: Dany Madden <drt@linux.ibm.com>
---
Changelog[v3]
        [Jakub Kicinski] Rebase to current net and fix comment style.

Changelog[v2]
	[Jakub Kicinski] Use ASSERT_RTNL() instead of WARN_ON_ONCE()
	and rtnl_is_locked());
---
 drivers/net/ethernet/ibm/ibmvnic.c | 63 ++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a536fdbf05e1..e51a7f2d00cb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1197,12 +1197,25 @@ static int ibmvnic_open(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
-	/* If device failover is pending, just set device state and return.
-	 * Device operation will be handled by reset routine.
+	ASSERT_RTNL();
+
+	/* If device failover is pending or we are about to reset, just set
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
@@ -1221,11 +1234,12 @@ static int ibmvnic_open(struct net_device *netdev)
 	rc = __ibmvnic_open(netdev);
 
 out:
-	/*
-	 * If open fails due to a pending failover, set device state and
-	 * return. Device operation will be handled by reset routine.
+	/* If open failed and there is a pending failover or in-progress reset,
+	 * set device state and return. Device operation will be handled by
+	 * reset routine. See also comments above regarding rtnl.
 	 */
-	if (rc && adapter->failover_pending) {
+	if (rc &&
+	    (adapter->failover_pending || (test_bit(0, &adapter->resetting)))) {
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 	}
@@ -2037,6 +2051,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
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
 
@@ -2063,7 +2085,24 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		if (rc)
 			goto out;
 
+		if (adapter->state == VNIC_OPEN) {
+			/* When we dropped rtnl, ibmvnic_open() got
+			 * it and noticed that we are resetting and
+			 * set the adapter state to OPEN. Update our
+			 * new "target" state, and resume the reset
+			 * from VNIC_CLOSING state.
+			 */
+			netdev_dbg(netdev,
+				   "Open changed state from %d, updating.\n",
+				   reset_state);
+			reset_state = VNIC_OPEN;
+			adapter->state = VNIC_CLOSING;
+		}
+
 		if (adapter->state != VNIC_CLOSING) {
+			/* If someone else changed the adapter state
+			 * when we dropped the rtnl, fail the reset
+			 */
 			rc = -1;
 			goto out;
 		}
@@ -2197,6 +2236,14 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
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

