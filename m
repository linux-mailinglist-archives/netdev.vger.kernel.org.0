Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444642BB93F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgKTWlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6570 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729074AbgKTWk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:59 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMZUJH152794
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SkczATyTv4M3h8gS0TVXR0h5/U4y+c7jSTUIW6+MyyA=;
 b=numcrNz900SqXPu9XQqVGESVslb/1eejd3rNVSF3S+Hy9drsB9S8hX3Yes750tSTeaB0
 28v7y6D631vt8XGaNKv8dkO8K/VrO2kHZlanMM7MrbAW+6GqY+Vo7e8p8tey9yZR64q2
 2gp5JPpgGMUG4v4Gm7WZT69n0g97BfqdtW38fL1omY/ZC7LZy5vIZ+wl0uDWgsHU4k+Y
 zsGAW+hB/rShtyjJWOI0Ip73w0Kd/nrLXtISF0GZT3CdMpSheWIPWsxhg8V00sWanH4h
 EWinRobpQPx1qeKajrNi801BJL40uzPyX8TozS1hsLD4g6uYOaPaA5rfp6ngZ0zv4VP7 nQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xdt082yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:57 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMbMwC024797
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:57 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 34t6v9sr9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:57 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeulr4129318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:56 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA7576E054;
        Fri, 20 Nov 2020 22:40:55 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EA2B6E052;
        Fri, 20 Nov 2020 22:40:55 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:55 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 06/15] ibmvnic: restore adapter state on failed reset
Date:   Fri, 20 Nov 2020 16:40:40 -0600
Message-Id: <20201120224049.46933-7-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 suspectscore=1
 adultscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

In a failed reset, driver could end up in VNIC_PROBED or VNIC_CLOSED
state and cannot recover in subsequent resets, leaving it offline.
This patch restores the adapter state to reset_state, the original
state when reset was called.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 67 ++++++++++++++++--------------
 1 file changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ceafd999a1ac..6f775ca4bea1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1895,7 +1895,7 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 	if (reset_state == VNIC_OPEN) {
 		rc = __ibmvnic_close(netdev);
 		if (rc)
-			return rc;
+			goto out;
 	}
 
 	release_resources(adapter);
@@ -1913,24 +1913,25 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 	}
 
 	rc = ibmvnic_reset_init(adapter, true);
-	if (rc)
-		return IBMVNIC_INIT_FAILED;
+	if (rc) {
+		rc = IBMVNIC_INIT_FAILED;
+		goto out;
+	}
 
 	/* If the adapter was in PROBE state prior to the reset,
 	 * exit here.
 	 */
 	if (reset_state == VNIC_PROBED)
-		return 0;
+		goto out;
 
 	rc = ibmvnic_login(netdev);
 	if (rc) {
-		adapter->state = reset_state;
-		return rc;
+		goto out;
 	}
 
 	rc = init_resources(adapter);
 	if (rc)
-		return rc;
+		goto out;
 
 	ibmvnic_disable_irqs(adapter);
 
@@ -1940,8 +1941,10 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 		return 0;
 
 	rc = __ibmvnic_open(netdev);
-	if (rc)
-		return IBMVNIC_OPEN_FAILED;
+	if (rc) {
+		rc = IBMVNIC_OPEN_FAILED;
+		goto out;
+	}
 
 	/* refresh device's multicast list */
 	ibmvnic_set_multi(netdev);
@@ -1950,7 +1953,10 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	return 0;
+out:
+	if (rc)
+		adapter->state = reset_state;
+	return rc;
 }
 
 /**
@@ -2053,7 +2059,6 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 		rc = ibmvnic_login(netdev);
 		if (rc) {
-			adapter->state = reset_state;
 			goto out;
 		}
 
@@ -2121,6 +2126,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	rc = 0;
 
 out:
+	/* restore the adapter state if reset failed */
+	if (rc)
+		adapter->state = reset_state;
 	rtnl_unlock();
 
 	return rc;
@@ -2153,43 +2161,46 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc) {
 		netdev_err(adapter->netdev,
 			   "Couldn't initialize crq. rc=%d\n", rc);
-		return rc;
+		goto out;
 	}
 
 	rc = ibmvnic_reset_init(adapter, false);
 	if (rc)
-		return rc;
+		goto out;
 
 	/* If the adapter was in PROBE state prior to the reset,
 	 * exit here.
 	 */
 	if (reset_state == VNIC_PROBED)
-		return 0;
+		goto out;
 
 	rc = ibmvnic_login(netdev);
-	if (rc) {
-		adapter->state = VNIC_PROBED;
-		return 0;
-	}
+	if (rc)
+		goto out;
 
 	rc = init_resources(adapter);
 	if (rc)
-		return rc;
+		goto out;
 
 	ibmvnic_disable_irqs(adapter);
 	adapter->state = VNIC_CLOSED;
 
 	if (reset_state == VNIC_CLOSED)
-		return 0;
+		goto out;
 
 	rc = __ibmvnic_open(netdev);
-	if (rc)
-		return IBMVNIC_OPEN_FAILED;
+	if (rc) {
+		rc = IBMVNIC_OPEN_FAILED;
+		goto out;
+	}
 
 	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
-
-	return 0;
+out:
+	/* restore adapter state if reset failed */
+	if (rc)
+		adapter->state = reset_state;
+	return rc;
 }
 
 static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
@@ -2274,13 +2285,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);
-		if (rc == IBMVNIC_OPEN_FAILED) {
-			if (list_empty(&adapter->rwi_list))
-				adapter->state = VNIC_CLOSED;
-			else
-				adapter->state = reset_state;
-			rc = 0;
-		}
+
 		if (rc)
 			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
 
-- 
2.23.0

