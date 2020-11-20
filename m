Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70D52BB94F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgKTWlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27530 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729074AbgKTWlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:02 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMVtMM029205
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0YEPbFXCLgtU8+YIAZXAv7kmGhreHb0DHHhz5N02FqY=;
 b=U+5DWOWf1vZ/M82tJ5AhukYA2U0MkPBHCHBAMK9uIfdRm2tZhBIcdlXgwGMf4Q8Rr7iX
 PvOnwxKc6amni5tGBXC4h3d/2rMTwhIpcUHXfsN6OZAbkgF3OOPtKLJZaHeysRKuoXWn
 N3xnfMGQm3wHt0AzSJzvgvPLv5uGL+BA9c1ZJCB7ujaKXUFihL9lH7fqHa3H1D1rwzBV
 TGb+ZnPE501yVMQV6ZsN71qjbj81/uKxwaB+aCjyjOfqbJE+RzRw4WCM/Qvze3B9fOIR
 u3urrKQkGEiytXY3N8a0vcaeOm4RHXT+IPqSrxDb+Ek/rqB7yEL0vedqj8WZoBhvMfZ5 GA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xghfbycy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:00 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMbLNI024794
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:00 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 34t6v9sra0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:00 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMexSO12124892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:59 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 356706E054;
        Fri, 20 Nov 2020 22:40:59 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A60D16E050;
        Fri, 20 Nov 2020 22:40:58 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:58 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 10/15] ibmvnic: no reset timeout for 5 seconds after reset
Date:   Fri, 20 Nov 2020 16:40:44 -0600
Message-Id: <20201120224049.46933-11-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 mlxlogscore=999 spamscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

Reset timeout is going off right after adapter reset. This patch ensures
that timeout is scheduled if it has been 5 seconds since the last reset.
5 seconds is the default watchdog timeout.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++--
 drivers/net/ethernet/ibm/ibmvnic.h |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9d2eebd31ff6..252af4ab6468 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2291,6 +2291,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);
+		adapter->last_reset_time = jiffies;
 
 		if (rc)
 			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
@@ -2394,7 +2395,13 @@ static void ibmvnic_tx_timeout(struct net_device *dev, unsigned int txqueue)
 			   "Adapter is resetting, skip timeout reset\n");
 		return;
 	}
-
+	/* No queuing up reset until at least 5 seconds (default watchdog val)
+	 * after last reset
+	 */
+	if (time_before(jiffies, (adapter->last_reset_time + dev->watchdog_timeo))) {
+		netdev_dbg(dev, "Not yet time to tx timeout.\n");
+		return;
+	}
 	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
 }
 
@@ -5316,7 +5323,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->state = VNIC_PROBED;
 
 	adapter->wait_for_reset = false;
-
+	adapter->last_reset_time = jiffies;
 	return 0;
 
 ibmvnic_register_fail:
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 9b1f34602f33..d15866cbc2a6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1089,6 +1089,8 @@ struct ibmvnic_adapter {
 	unsigned long resetting;
 	bool napi_enabled, from_passive_init;
 	bool login_pending;
+	/* last device reset time */
+	unsigned long last_reset_time;
 
 	bool failover_pending;
 	bool force_reset_recovery;
-- 
2.23.0

