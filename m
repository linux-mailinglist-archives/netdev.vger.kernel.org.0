Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A0631A9E6
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 05:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhBMEnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 23:43:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhBMEnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 23:43:40 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11D4Vt7w194079;
        Fri, 12 Feb 2021 23:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=3ypOhMi26aC7iWBnY8VmQf3cHtjEOdfuHb/o7KHuPNg=;
 b=jI8h9E1TKUuZtGUw8dc+XykAZEYNXvPgbdjje7hLAU3MRpObVsGg9CM2ua9S32Dz4wVz
 Pi8sRbIDgnrnzypuehEcx3Gn+Ga3lRwL58GYUkwfWs9Qnig9qaSdyai0+VkqqJ+vClUG
 NECsGfvQsMPRMz+KI0UbWwFH98DjVnZcnTdvCXUbZLm+F2xWUKPkUrPU7g7NA0x5CSU4
 phHrC7gxa1DMa70OjzuCjZOcb1Ds7shv1kEpjeLvddTrVmAnOvKN6sG4+fVzhSOcF1HJ
 ruUDE4mVF7RYPDSQkJCc7xuwLeOEKmU3pT80wuoLkpdGnptqZDtAcQRwxTTQ230cjGtv 3Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36p7hmrhpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 23:42:53 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11D4gSYO027056;
        Sat, 13 Feb 2021 04:42:53 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 36p6d8rhvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Feb 2021 04:42:53 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11D4gqtB26345874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Feb 2021 04:42:52 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CD582805A;
        Sat, 13 Feb 2021 04:42:52 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CFD328058;
        Sat, 13 Feb 2021 04:42:51 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.159.212])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 13 Feb 2021 04:42:50 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, uwe@kleine-koenig.org,
        saeed@kernel.org, sukadev@linux.ibm.com
Subject: [PATCH net 1/1] ibmvnic: serialize access to work queue on remove
Date:   Fri, 12 Feb 2021 20:42:50 -0800
Message-Id: <20210213044250.960317-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_01:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The work queue is used to queue reset requests like CHANGE-PARAM or
FAILOVER resets for the worker thread. When the adapter is being removed
the adapter state is set to VNIC_REMOVING and the work queue is flushed
so no new work is added. However the check for adapter being removed is
racy in that the adapter can go into REMOVING state just after we check
and we might end up adding work just as it is being flushed (or after).

The ->rwi_lock is already being used to serialize queue/dequeue work.
Extend its usage ensure there is no race when scheduling/flushing work.

Fixes: 6954a9e4192b ("ibmvnic: Flush existing work items before device removal")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:Uwe Kleine-König <uwe@kleine-koenig.org>
Cc:Saeed Mahameed <saeed@kernel.org>
---
Changelog
	An earlier version was reviewed by Saeed Mahmeed. But I have deferred
	some earlier patches in that set. Also, now extend the use of ->rwi_lock
	rather than defining a new lock.
---
 drivers/net/ethernet/ibm/ibmvnic.c | 27 ++++++++++++++++++++-------
 drivers/net/ethernet/ibm/ibmvnic.h |  5 ++++-
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ce6b1cb0b0f9..004565b18a03 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2442,6 +2442,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&adapter->rwi_lock, flags);
+
 	/*
 	 * If failover is pending don't schedule any other reset.
 	 * Instead let the failover complete. If there is already a
@@ -2462,14 +2464,11 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
-	spin_lock_irqsave(&adapter->rwi_lock, flags);
-
 	list_for_each(entry, &adapter->rwi_list) {
 		tmp = list_entry(entry, struct ibmvnic_rwi, list);
 		if (tmp->reset_reason == reason) {
 			netdev_dbg(netdev, "Skipping matching reset, reason=%d\n",
 				   reason);
-			spin_unlock_irqrestore(&adapter->rwi_lock, flags);
 			ret = EBUSY;
 			goto err;
 		}
@@ -2477,8 +2476,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	rwi = kzalloc(sizeof(*rwi), GFP_ATOMIC);
 	if (!rwi) {
-		spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-		ibmvnic_close(netdev);
 		ret = ENOMEM;
 		goto err;
 	}
@@ -2491,12 +2488,17 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	}
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
-	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
 	schedule_work(&adapter->ibmvnic_reset);
 
-	return 0;
+	ret = 0;
 err:
+	/* ibmvnic_close() below can block, so drop the lock first */
+	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+
+	if (ret == ENOMEM)
+		ibmvnic_close(netdev);
+
 	return -ret;
 }
 
@@ -5512,7 +5514,18 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->state_lock, flags);
+
+	/* If ibmvnic_reset() is scheduling a reset, wait for it to
+	 * finish. Then, set the state to REMOVING to prevent it from
+	 * scheduling any more work and to have reset functions ignore
+	 * any resets that have already been scheduled. Drop the lock
+	 * after setting state, so __ibmvnic_reset() which is called
+	 * from the flush_work() below, can make progress.
+	 */
+	spin_lock_irqsave(&adapter->rwi_lock, flags);
 	adapter->state = VNIC_REMOVING;
+	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+
 	spin_unlock_irqrestore(&adapter->state_lock, flags);
 
 	flush_work(&adapter->ibmvnic_reset);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index c09c3f6bba9f..3cccbba70365 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1081,6 +1081,7 @@ struct ibmvnic_adapter {
 	struct tasklet_struct tasklet;
 	enum vnic_state state;
 	enum ibmvnic_reset_reason reset_reason;
+	/* when taking both state and rwi locks, take state lock first */
 	spinlock_t rwi_lock;
 	struct list_head rwi_list;
 	struct work_struct ibmvnic_reset;
@@ -1097,6 +1098,8 @@ struct ibmvnic_adapter {
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
 
-	/* Used for serializatin of state field */
+	/* Used for serialization of state field. When taking both state
+	 * and rwi locks, take state lock first.
+	 */
 	spinlock_t state_lock;
 };
-- 
2.26.2

