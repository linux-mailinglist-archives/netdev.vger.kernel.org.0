Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F092A0C18
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgJ3RHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:07:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57606 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727076AbgJ3RHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:07:16 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UH2j7G152639
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 13:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LA10jbzpPA+nR3p9oGyoYnw5cHWlhip1NfoVkjWsL+A=;
 b=KZqpPOo+vxSef1N//GHt083k9oorTnDRg2qOcwgFs3R1D6SXcI3ByqkNhe6tw5jC3cyD
 cGBZfdvSO6pbJ0GEdUESVcS0KXI6eZCO1C0YV+twFMQ9HhH02tbSmK1lud0h2vPnQsUy
 79zL/IqMGPhmSW3C96FepILTs/S3otUGEho99ofWfAQfPCCSUERG61vR1BW7FfQRRcni
 w2JuI1Y1Y2pqJcph2DxIgyDtfrBDrcsp1EpkBmOkjMv/VzTdJ0hzc+Gy8VQ6Ya5fdhO2
 dtZb+A+XM9E+/sbSYF5Q7/1Nk/2KAIDb7AalOIEsHtL9RSU7+OSElSs2nYxvYnV6osld zQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gp9hhbn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 13:07:15 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UH2Fau028621
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 17:07:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 34fy75sw0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 17:07:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UH7D9u66585058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:07:13 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F0347805C;
        Fri, 30 Oct 2020 17:07:13 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3A117805F;
        Fri, 30 Oct 2020 17:07:12 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.198.130])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 17:07:12 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.vnet.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v3 1/1] powerpc/vnic: Extend "failover pending" window
Date:   Fri, 30 Oct 2020 10:07:11 -0700
Message-Id: <20201030170711.1562994-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_07:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300122
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

We could try and block the open until failover is completed but a) that
could still timeout the application and b) Existing code "pretends" that
failover occurred "just after" open succeeded, so marks the open successful
and lets the failover complete the open. So, mark the open successful even
if the transport event occurs before we actually start the open.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
Changelog [v3]:
	[Lijun Pan]: Add a few more notes to patch description.

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

