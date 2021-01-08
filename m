Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B57E2EEDBE
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbhAHHN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:13:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726312AbhAHHN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 02:13:27 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10872EO7071554
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 02:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=l9VEHZNob2Wr8tif39ecPf6Fglpbho3Ep7XeMlW7RyQ=;
 b=mCi88BFi/ucCnbJ1YVmOiutf37Oew0Hj/AMTfdVqbOFoIvQzp1mXQ/v9wTMhNgdgiE5G
 4h/7tUgNSuRZa8FmdyvuNaNcUR5pFmrlfwzv5l/XD4zHw+6t2yTyMiV5xmmwqGT3wHDU
 bYNoFSaVEzJuv93gwPC6BJdB6+Se1leGBW2LCLyMmKtoagUxZyKdRCgbXslDR574VmPR
 GNb71aHshifaNmN2iLYRikk7LQHO4IHe9ktf62dYPMwqwr7AYvucoKAaGbZwXOKAUJek
 d17RkmB80rQkmbwX9lK1Ah8igXFpyo4B30yrAZ3M2ZQDxUhj2PYaKDBbouoNLLczu1yW Pw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35xjjbggd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:12:45 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1086r5fq022512
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 07:12:45 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 35tgfaa3hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 07:12:45 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1087CiNH28705054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jan 2021 07:12:44 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DD507805C;
        Fri,  8 Jan 2021 07:12:44 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54F7F78060;
        Fri,  8 Jan 2021 07:12:43 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.139.161])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  8 Jan 2021 07:12:43 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        sukadev@linux.ibm.com
Subject: [PATCH 5/7] ibmvnic: use a lock to serialize remove/reset
Date:   Thu,  7 Jan 2021 23:12:34 -0800
Message-Id: <20210108071236.123769-6-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108071236.123769-1-sukadev@linux.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_04:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a separate lock to serialze ibmvnic_reset() and ibmvnic_remove()
functions. ibmvnic_reset() schedules work for the worker thread and
ibmvnic_remove() flushes the work before removing the adapter. We
don't want any work to be scheduled once we start removing the
adapter (i.e after we have already flushed the work).

A follow-on patch will convert the ->state_lock from a spinklock
to a mutex to allow us to hold it for longer periods of time.
ibmvnic_reset() can be called from a tasklet and cannot use the
mutex.

Fixes: 6954a9e4192b ("ibmvnic: Flush existing work items before
                     device removal")

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 +++++++++++++++-
 drivers/net/ethernet/ibm/ibmvnic.h |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ad551418ac63..c7675ab0b7e3 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2435,6 +2435,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
 	struct net_device *netdev = adapter->netdev;
+	unsigned long rmflags;
 	int ret;
 
 	if (adapter->state == VNIC_PROBING) {
@@ -2443,6 +2444,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
+	spin_lock_irqsave(&adapter->remove_lock, rmflags);
+
 	/*
 	 * If failover is pending don't schedule any other reset.
 	 * Instead let the failover complete. If there is already a
@@ -2465,8 +2468,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
 	schedule_work(&adapter->ibmvnic_reset);
 
-	return 0;
+	ret = 0;
 err:
+	spin_unlock_irqrestore(&adapter->remove_lock, rmflags);
 	return -ret;
 }
 
@@ -5387,6 +5391,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	memset(&adapter->pending_resets, 0, sizeof(adapter->pending_resets));
 	spin_lock_init(&adapter->rwi_lock);
 	spin_lock_init(&adapter->state_lock);
+	spin_lock_init(&adapter->remove_lock);
 	mutex_init(&adapter->fw_lock);
 	init_completion(&adapter->init_done);
 	init_completion(&adapter->fw_done);
@@ -5459,6 +5464,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(&dev->dev);
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
+	unsigned long rmflags;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->state_lock, flags);
@@ -5467,7 +5473,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
 		return -EBUSY;
 	}
 
+	/* If ibmvnic_reset() is scheduling a reset, wait for it to
+	 * finish. Then prevent it from scheduling any more resets
+	 * and have the reset functions ignore any resets that have
+	 * already been scheduled.
+	 */
+	spin_lock_irqsave(&adapter->remove_lock, rmflags);
 	adapter->state = VNIC_REMOVING;
+	spin_unlock_irqrestore(&adapter->remove_lock, rmflags);
+
 	spin_unlock_irqrestore(&adapter->state_lock, flags);
 
 	flush_work(&adapter->ibmvnic_reset);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 1179a95a3f92..2779696ade09 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1081,6 +1081,8 @@ struct ibmvnic_adapter {
 	spinlock_t rwi_lock;
 	enum ibmvnic_reset_reason pending_resets[VNIC_RESET_MAX-1];
 	short next_reset;
+	/* serialize ibmvnic_reset() and ibmvnic_remove() */
+	spinlock_t remove_lock;
 	struct work_struct ibmvnic_reset;
 	struct delayed_work ibmvnic_delayed_reset;
 	unsigned long resetting;
-- 
2.26.2

