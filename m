Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036FD2C19B1
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgKWX6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728137AbgKWX6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:16 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNW8Lq180934
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=omWaOEAmvK0gHwTebta6ytRU2TjYKBWnlHC+CEcCbhU=;
 b=k2vb+hu+ISrZMdCJX0QPozf4JPocFmzAC/CHiiH65Qv1xR9kqV2yR2UG+XW4i6ZtE7UQ
 8dALY1bSNGh1B9PACl1JWYwtjSWp97X5LN1txsRVOJed/YC0asG2+WpL5uMUvxWvhYMm
 V1WejxiHNxmgSlAxd3vv1G6oD0YL9lpTn0IK+NYXiedOqPXc7z3zCqRUDapHyr1wLurk
 rpFm/3Ar9W8k60gAtpsoHjQB+yGR9jTfO5vek33Nu/g4vEr3Yu3vmLKB3PzkSxC2j9oO
 2B9cte8wOXZtcESQCd1DdPK2BuB9idzjf92EQu57Iz+KvMRqi4k5VJ3x0l+781OCDQf5 NA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34yhay8uy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:15 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNw5rC021248
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:14 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 34xth97rmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:14 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwDjv63373730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:13 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8D942805E;
        Mon, 23 Nov 2020 23:58:13 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F49728059;
        Mon, 23 Nov 2020 23:58:13 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:13 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 8/9] ibmvnic: no reset timeout for 5 seconds after reset
Date:   Mon, 23 Nov 2020 18:57:56 -0500
Message-Id: <20201123235757.6466-9-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 suspectscore=1 spamscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset timeout is going off right after adapter reset. This patch ensures
that timeout is scheduled if it has been 5 seconds since the last reset.
5 seconds is the default watchdog timeout.

Fixes: ed651a10875f1 ("ibmvnic: Updated reset handling")

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++--
 drivers/net/ethernet/ibm/ibmvnic.h |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 79a8b78d93ca..3bfdf9f2edff 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2253,6 +2253,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);
+		adapter->last_reset_time = jiffies;
 
 		if (rc)
 			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
@@ -2356,7 +2357,13 @@ static void ibmvnic_tx_timeout(struct net_device *dev, unsigned int txqueue)
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
 
@@ -5276,7 +5283,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->state = VNIC_PROBED;
 
 	adapter->wait_for_reset = false;
-
+	adapter->last_reset_time = jiffies;
 	return 0;
 
 ibmvnic_register_fail:
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 6f0a701c4a38..b21092f5f9c1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1088,6 +1088,8 @@ struct ibmvnic_adapter {
 	unsigned long resetting;
 	bool napi_enabled, from_passive_init;
 	bool login_pending;
+	/* last device reset time */
+	unsigned long last_reset_time;
 
 	bool failover_pending;
 	bool force_reset_recovery;
-- 
2.26.2

