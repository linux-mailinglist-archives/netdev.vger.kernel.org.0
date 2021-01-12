Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF0D2F3851
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406707AbhALSPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:15:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392481AbhALSPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:15:30 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CI3Cp3123822
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PS+s9bAGg/dOoJqSawJJC6j22s+xmuHNkdH9Lx9tDTo=;
 b=k5xMQUbanZflKofeWyuF70GineMxDw2Qb7NiiR/D1xAmj3KQdRd2z9/OtACJ06p3O3Bg
 WEUBox0Psvq3YkBIO39nZQL2hfVi1ZwM+v4JkkLoEmrnrR8oZW83Kr83AmXHJeaZ/zhK
 KSraXclBhVvLfA46pDDK/MLDVt8lzJy+pj7AoIUKEkpJ7wRpYd83Bg3/BFZkmCd4VmFV
 vaOWPFk9Pa3FYrHhXjyFgxfbKdSjdpD0K8l0jrb7FF5KLPWmCOtEMHE8SrVCKLgPWsVY
 Z6SWW5m6GC7FP6OBJWkAzLPKcWkvbNRhD9cvGlfAPQQbKEcA0CIgPGaiFPXMlMJKlJko Lw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361f9j36db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:49 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CI82Lj028860
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:48 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 35y4495u1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:48 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIElDA25231788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:14:47 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73912B206B;
        Tue, 12 Jan 2021 18:14:47 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC073B2065;
        Tue, 12 Jan 2021 18:14:46 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.179.93])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 18:14:46 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com
Subject: [PATCH net-next v2 5/7] ibmvnic: serialize access to work queue
Date:   Tue, 12 Jan 2021 10:14:39 -0800
Message-Id: <20210112181441.206545-6-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112181441.206545-1-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The work queue is used to queue reset requests like CHANGE-PARAM or
FAILOVER resets for the worker thread. When the adapter is being removed
the adapter state is set to VNIC_REMOVING and the work queue is flushed
so no new work is added. However the check for adapter being removed is
racy in that the adapter can go into REMOVING state just after we check
and we might end up adding work just as it is being flushed (or after).

Use a new spin lock, ->remove_lock to ensure that after (while) the work
queue is (being) flushed, no new work is queued.

A follow-on patch will convert the existing ->state_lock from a spin lock
to to a mutex to allow us to hold it for longer periods of time. Since
work can be scheduled from a tasklet, we cannot block on the mutex, so
use a new spin lock.

Fixes: 6954a9e4192b ("ibmvnic: Flush existing work items before device removal")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 15 ++++++++++++++-
 drivers/net/ethernet/ibm/ibmvnic.h |  2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ad551418ac63..7645df37e886 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2435,6 +2435,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
 	struct net_device *netdev = adapter->netdev;
+	unsigned long flags;
 	int ret;
 
 	if (adapter->state == VNIC_PROBING) {
@@ -2443,6 +2444,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
+	spin_lock_irqsave(&adapter->remove_lock, flags);
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
+	spin_unlock_irqrestore(&adapter->remove_lock, flags);
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
@@ -5467,7 +5472,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
 		return -EBUSY;
 	}
 
+	/* If ibmvnic_reset() is scheduling a reset, wait for it to
+	 * finish. Then prevent it from scheduling any more resets
+	 * and have the reset functions ignore any resets that have
+	 * already been scheduled.
+	 */
+	spin_lock_irqsave(&adapter->remove_lock, flags);
 	adapter->state = VNIC_REMOVING;
+	spin_unlock_irqrestore(&adapter->remove_lock, flags);
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

