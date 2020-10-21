Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9162946DD
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 05:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411601AbgJUDOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 23:14:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2411597AbgJUDOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 23:14:33 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L32549007814
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 23:14:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=y9b5yD34915W96xY2H6bsXAlI1yJX2UKZV3ATcfHrb4=;
 b=FpZCjkRmaV8eL0oklzBLPxs8dg+JtLFT7f7OnJ1kPNGLB9HPaAb9NhEflzM7/J+FYl3S
 uZ79RKa9ERig9iXvt//uFioKw6f74Tq/YmoBIHoaGdZp7NybRD8cI0+cjxVYxUY+GRZR
 SfoY9uPJLHp7xdu1VYRL+sPBysY9orgPFqkjUjovEuYVEH85LOBfSDhBMPrrBh4Wv2+5
 2HpeRpXB5k35Et9XluG48curNsqW671gBOLyn3ZSP3bTYXPeNctepx3wbfiopvrW0EQ3
 2mfdIc3csyPBPxrxFlDBGdE0g/Pn3CYpUPF/Om4eEqce9pGYVsDgviUREqBj7YcysKB2 eg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34aah6uat2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 23:14:32 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09L3BTv3017062
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 03:14:31 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 347r894v3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 03:14:31 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09L3EVBY50528738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 03:14:31 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B584AC060;
        Wed, 21 Oct 2020 03:14:31 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C217EAC05F;
        Wed, 21 Oct 2020 03:14:30 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.196.79])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 21 Oct 2020 03:14:30 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.vnet.ibm.com>, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
Date:   Tue, 20 Oct 2020 20:14:30 -0700
Message-Id: <20201021031430.1327927-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_02:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=999 suspectscore=1 impostorscore=0 malwarescore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
the "failover pending window" - where we wait for the partner to become
ready (after a transport event) before actually attempting to failover.
i.e window is between following two events:

        a. we get a transport event due to a FAILOVER

        b. later, we get CRQ_INITIALIZED indicating the partner is
           ready  at which point we schedule a FAILOVER reset.

and ->failover_pending is true during this window.

If during this window, we attempt to open (or close) a device, we pretend
that the operation succeded and let the FAILOVER reset path complete the
operation.

This is fine, except if the transport event ("a" above) occurs during the
open and after open has already checked whether a failover is pending. If
that happens, we fail the open, which can cause the boot scripts to leave
the interface down requiring administrator to manually bring up the device.

This fix "extends" the failover pending window till we are _actually_
ready to perform the failover reset (i.e until after we get the RTNL
lock). Since open() holds the RTNL lock, we can be sure that we either
finish the open or if the open() fails due to the failover pending window,
we can again pretend that open is done and let the failover complete it.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
Changelog [v2]:
	[Brian King] Ensure we clear failover_pending during hard reset
---
 drivers/net/ethernet/ibm/ibmvnic.c | 36 ++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1b702a43a5d0..2a0f6f6820db 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1197,18 +1197,27 @@ static int ibmvnic_open(struct net_device *netdev)
 	if (adapter->state != VNIC_CLOSED) {
 		rc = ibmvnic_login(netdev);
 		if (rc)
-			return rc;
+			goto out;
 
 		rc = init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
 			release_resources(adapter);
-			return rc;
+			goto out;
 		}
 	}
 
 	rc = __ibmvnic_open(netdev);
 
+out:
+	/*
+	 * If open fails due to a pending failover, set device state and
+	 * return. Device operation will be handled by reset routine.
+	 */
+	if (rc && adapter->failover_pending) {
+		adapter->state = VNIC_OPEN;
+		rc = 0;
+	}
 	return rc;
 }
 
@@ -1931,6 +1940,13 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		   rwi->reset_reason);
 
 	rtnl_lock();
+	/*
+	 * Now that we have the rtnl lock, clear any pending failover.
+	 * This will ensure ibmvnic_open() has either completed or will
+	 * block until failover is complete.
+	 */
+	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
+		adapter->failover_pending = false;
 
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
@@ -2211,6 +2227,13 @@ static void __ibmvnic_reset(struct work_struct *work)
 			/* CHANGE_PARAM requestor holds rtnl_lock */
 			rc = do_change_param_reset(adapter, rwi, reset_state);
 		} else if (adapter->force_reset_recovery) {
+			/*
+			 * Since we are doing a hard reset now, clear the
+			 * failover_pending flag so we don't ignore any
+			 * future MOBILITY or other resets.
+			 */
+			adapter->failover_pending = false;
+
 			/* Transport event occurred during previous reset */
 			if (adapter->wait_for_reset) {
 				/* Previous was CHANGE_PARAM; caller locked */
@@ -2275,9 +2298,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	unsigned long flags;
 	int ret;
 
+	/*
+	 * If failover is pending don't schedule any other reset.
+	 * Instead let the failover complete. If there is already a
+	 * a failover reset scheduled, we will detect and drop the
+	 * duplicate reset when walking the ->rwi_list below.
+	 */
 	if (adapter->state == VNIC_REMOVING ||
 	    adapter->state == VNIC_REMOVED ||
-	    adapter->failover_pending) {
+	    (adapter->failover_pending && reason != VNIC_RESET_FAILOVER)) {
 		ret = EBUSY;
 		netdev_dbg(netdev, "Adapter removing or pending failover, skipping reset\n");
 		goto err;
@@ -4653,7 +4682,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		case IBMVNIC_CRQ_INIT:
 			dev_info(dev, "Partner initialized\n");
 			adapter->from_passive_init = true;
-			adapter->failover_pending = false;
 			if (!completion_done(&adapter->init_done)) {
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
-- 
2.25.4

