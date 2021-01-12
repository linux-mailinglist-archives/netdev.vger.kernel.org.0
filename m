Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EEB2F3856
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391603AbhALSPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:15:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406232AbhALSPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:15:31 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CI2FCP124378
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=agd2CayxWlu/pjGCV/9UvhlyS7e8snVb1OmUvmyKMwo=;
 b=g4JeLXybVT+b3SPh7dypr+mvbmiRfpbteZoRZN176KRrV9iE7MgMxGWVU+5Y0SwhvYSs
 EyvF8wFroi4PDF7CslDRgKHwG/wcx7WwEuhZXA0k0XhJ/ciD6b6C7T/JRgjo+DVvn75r
 4Ww3X4zICp1d967pQStzBx1TZRqNauBq7ZjbjeVKvme2qo6stkoh18QQBQqrWNicgfgt
 9M0UPzCYLMZri2jgsGF7QGNUWh9HUCGZJMy/V2P8UUizgM3BCFpY2vxtctVagHoTVSIz
 JXiSQ/ZNi/5k60VdDUakSTlvhLqUF/IWfVhpLKNGUX21XDqj9r68pKhSFnHkprJiubgk XQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361f74k9rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:50 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CHvS5M015411
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:49 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 35y448ywha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:49 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIEmGS7799382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:14:48 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FBB2B2073;
        Tue, 12 Jan 2021 18:14:48 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9878B2064;
        Tue, 12 Jan 2021 18:14:47 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.179.93])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 18:14:47 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com
Subject: [PATCH net-next v2 6/7] ibmvnic: check adapter->state under state_lock
Date:   Tue, 12 Jan 2021 10:14:40 -0800
Message-Id: <20210112181441.206545-7-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112181441.206545-1-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider following code from __ibmvnic_reset()

                spin_lock_irqsave(&adapter->state_lock, flags);

                if (adapter->state == VNIC_REMOVING ||
                    adapter->state == VNIC_REMOVED) {
                        spin_unlock_irqrestore(&adapter->state_lock, flags);
                        kfree(rwi);
                        rc = EBUSY;
                        break;
                }

                if (!saved_state) {
                        reset_state = adapter->state;
                        saved_state = true;
                }
                spin_unlock_irqrestore(&adapter->state_lock, flags);

and following from ibmvnic_open():

	if (adapter->failover_pending) {
		adapter->state = VNIC_OPEN;
		return 0;
	}

They have following issues:

	a. __ibmvnic_reset() caches the adapter->state while holding
	   the state_lock but ibmvnic_open() sets state to OPEN without
	   holding a lock.

	b. Even if adapter state changes to OPEN after __ibmvnic_reset()
	   cached the state but before reset begins, the reset process
	   will leave the adapter in PROBED state instead of OPEN state.

The reason current code caches the adapter state is so we know what state
to go back to if the reset fails. But due to recent bug fixes, the reset
functions __restore__ the adapter state on both success/failure, so we
no longer need to cache the state.

To fix the race condition b above, use ->state_lock more consistently and
throughout the open, close and reset functions. But since these may have
to block, change the ->state_lock from a spinlock to mutex.

A follow-on patch will audit/document the uses of ->state field outside
open/close/reset.

Thanks to a lot of input from Dany Madden, Lijun Pan and Rick Lindsley.

Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during device reset")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
---
 drivers/net/ethernet/ibm/ibmvnic.c | 118 ++++++++++++++++++++---------
 drivers/net/ethernet/ibm/ibmvnic.h |   5 +-
 2 files changed, 87 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 7645df37e886..3ca92a207d16 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1150,6 +1150,8 @@ static int __ibmvnic_open(struct net_device *netdev)
 	enum vnic_state prev_state = adapter->state;
 	int i, rc;
 
+	WARN_ON_ONCE(!mutex_is_locked(&adapter->state_lock));
+
 	adapter->state = VNIC_OPENING;
 	replenish_pools(adapter);
 	ibmvnic_napi_enable(adapter);
@@ -1196,11 +1198,14 @@ static int ibmvnic_open(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	mutex_lock(&adapter->state_lock);
+
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
 	 */
 	if (adapter->failover_pending) {
 		adapter->state = VNIC_OPEN;
+		mutex_unlock(&adapter->state_lock);
 		return 0;
 	}
 
@@ -1228,6 +1233,8 @@ static int ibmvnic_open(struct net_device *netdev)
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 	}
+
+	mutex_unlock(&adapter->state_lock);
 	return rc;
 }
 
@@ -1350,6 +1357,8 @@ static int __ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc = 0;
 
+	WARN_ON_ONCE(!mutex_is_locked(&adapter->state_lock));
+
 	adapter->state = VNIC_CLOSING;
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
 	if (rc)
@@ -1363,6 +1372,8 @@ static int ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	mutex_lock(&adapter->state_lock);
+
 	netdev_dbg(netdev, "[S:%d FOP:%d FRR:%d] Closing\n",
 		   adapter->state, adapter->failover_pending,
 		   adapter->force_reset_recovery);
@@ -1372,12 +1383,15 @@ static int ibmvnic_close(struct net_device *netdev)
 	 */
 	if (adapter->failover_pending) {
 		adapter->state = VNIC_CLOSED;
+		mutex_unlock(&adapter->state_lock);
 		return 0;
 	}
 
+
 	rc = __ibmvnic_close(netdev);
 	ibmvnic_cleanup(netdev);
 
+	mutex_unlock(&adapter->state_lock);
 	return rc;
 }
 
@@ -1929,15 +1943,24 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
  * events, or non-zero if we hit a fatal error and must halt.
  */
 static int do_change_param_reset(struct ibmvnic_adapter *adapter,
-				 enum ibmvnic_reset_reason reason,
-				 u32 reset_state)
+				 enum ibmvnic_reset_reason reason)
 {
 	struct net_device *netdev = adapter->netdev;
+	u32 reset_state;
 	int i, rc;
 
 	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
 		   reason);
 
+	mutex_lock(&adapter->state_lock);
+
+	reset_state = adapter->state;
+	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
+		netdev_err(netdev, "Adapter removed before change-param!\n");
+		rc = IBMVNIC_NODEV;
+		goto out;
+	}
+
 	netif_carrier_off(netdev);
 	adapter->reset_reason = reason;
 
@@ -2007,6 +2030,9 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 out:
 	if (rc)
 		adapter->state = reset_state;
+
+	mutex_unlock(&adapter->state_lock);
+
 	return rc;
 }
 
@@ -2015,19 +2041,31 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
  * non-zero if we hit a fatal error and must halt.
  */
 static int do_reset(struct ibmvnic_adapter *adapter,
-		    enum ibmvnic_reset_reason reason, u32 reset_state)
+		    enum ibmvnic_reset_reason reason)
 {
+	struct net_device *netdev = adapter->netdev;
 	u64 old_num_rx_queues, old_num_tx_queues;
 	u64 old_num_rx_slots, old_num_tx_slots;
-	struct net_device *netdev = adapter->netdev;
+	u32 reset_state;
 	int i, rc;
 
+	rtnl_lock();
+
+	mutex_lock(&adapter->state_lock);
+
+	reset_state = adapter->state;
+
 	netdev_dbg(adapter->netdev,
 		   "[S:%d FOP:%d] Reset reason %d, reset_state %d\n",
 		   adapter->state, adapter->failover_pending,
 		   reason, reset_state);
 
-	rtnl_lock();
+	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
+		netdev_err(netdev, "Adapter removed before reset!\n");
+		rc = IBMVNIC_NODEV;
+		goto out;
+	}
+
 	/*
 	 * Now that we have the rtnl lock, clear any pending failover.
 	 * This will ensure ibmvnic_open() has either completed or will
@@ -2054,11 +2092,21 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		/* Release the RTNL lock before link state change and
 		 * re-acquire after the link state change to allow
 		 * linkwatch_event to grab the RTNL lock and run during
-		 * a reset.
+		 * a reset. To reacquire RTNL, we must also drop/reacquire
+		 * state_lock. Once we reacquire state_lock, we don't need
+		 * to check for REMOVING since ->resetting bit is still set
+		 * (any ibmvnic_remove() in between would have failed).
+		 *
+		 * We set the state to CLOSING above. If adapter is no
+		 * longer in CLOSING state, another thread changed the
+		 * state when we dropped the lock, so fail the reset
+		 * and retry.
 		 */
+		mutex_unlock(&adapter->state_lock);
 		rtnl_unlock();
 		rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
 		rtnl_lock();
+		mutex_lock(&adapter->state_lock);
 		if (rc)
 			goto out;
 
@@ -2180,6 +2228,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	/* restore the adapter state if reset failed */
 	if (rc)
 		adapter->state = reset_state;
+
+	mutex_unlock(&adapter->state_lock);
 	rtnl_unlock();
 
 	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Reset done, rc %d\n",
@@ -2188,11 +2238,24 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 }
 
 static int do_hard_reset(struct ibmvnic_adapter *adapter,
-			 enum ibmvnic_reset_reason reason, u32 reset_state)
+			 enum ibmvnic_reset_reason reason)
 {
 	struct net_device *netdev = adapter->netdev;
+	u32 reset_state;
 	int rc;
 
+	WARN_ON_ONCE(!rtnl_is_locked());
+
+	mutex_lock(&adapter->state_lock);
+
+	reset_state = adapter->state;
+
+	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
+		netdev_err(netdev, "Adapter removed before hard reset!\n");
+		rc = IBMVNIC_NODEV;
+		goto out;
+	}
+
 	netdev_dbg(adapter->netdev, "Hard resetting driver (%d)\n",
 		   reason);
 
@@ -2254,6 +2317,7 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 		adapter->state = reset_state;
 	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Hard reset done, rc %d\n",
 		   adapter->state, adapter->failover_pending, rc);
+	mutex_unlock(&adapter->state_lock);
 	return rc;
 }
 
@@ -2333,9 +2397,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 {
 	enum ibmvnic_reset_reason reason;
 	struct ibmvnic_adapter *adapter;
-	bool saved_state = false;
-	unsigned long flags;
-	u32 reset_state;
 	int rc = 0;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
@@ -2348,24 +2409,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 	reason = get_pending_reset(adapter);
 	while (reason) {
-		spin_lock_irqsave(&adapter->state_lock, flags);
-
-		if (adapter->state == VNIC_REMOVING ||
-		    adapter->state == VNIC_REMOVED) {
-			spin_unlock_irqrestore(&adapter->state_lock, flags);
-			rc = EBUSY;
-			break;
-		}
-
-		if (!saved_state) {
-			reset_state = adapter->state;
-			saved_state = true;
-		}
-		spin_unlock_irqrestore(&adapter->state_lock, flags);
-
 		if (reason == VNIC_RESET_CHANGE_PARAM) {
 			/* CHANGE_PARAM requestor holds rtnl_lock */
-			rc = do_change_param_reset(adapter, reason, reset_state);
+			rc = do_change_param_reset(adapter, reason);
 		} else if (adapter->force_reset_recovery) {
 			/*
 			 * Since we are doing a hard reset now, clear the
@@ -2378,11 +2424,11 @@ static void __ibmvnic_reset(struct work_struct *work)
 			if (adapter->wait_for_reset) {
 				/* Previous was CHANGE_PARAM; caller locked */
 				adapter->force_reset_recovery = false;
-				rc = do_hard_reset(adapter, reason, reset_state);
+				rc = do_hard_reset(adapter, reason);
 			} else {
 				rtnl_lock();
 				adapter->force_reset_recovery = false;
-				rc = do_hard_reset(adapter, reason, reset_state);
+				rc = do_hard_reset(adapter, reason);
 				rtnl_unlock();
 			}
 			if (rc) {
@@ -2395,12 +2441,16 @@ static void __ibmvnic_reset(struct work_struct *work)
 			}
 		} else if (!(reason == VNIC_RESET_FATAL &&
 				adapter->from_passive_init)) {
-			rc = do_reset(adapter, reason, reset_state);
+			rc = do_reset(adapter, reason);
 		}
 		adapter->last_reset_time = jiffies;
 
 		if (rc)
 			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
+		if (rc == IBMVNIC_NODEV) {
+			rc = EBUSY;
+			break;
+		}
 
 		reason = get_pending_reset(adapter);
 
@@ -5390,7 +5440,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->next_reset = 0;
 	memset(&adapter->pending_resets, 0, sizeof(adapter->pending_resets));
 	spin_lock_init(&adapter->rwi_lock);
-	spin_lock_init(&adapter->state_lock);
+	mutex_init(&adapter->state_lock);
 	spin_lock_init(&adapter->remove_lock);
 	mutex_init(&adapter->fw_lock);
 	init_completion(&adapter->init_done);
@@ -5466,9 +5516,9 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->state_lock, flags);
+	mutex_lock(&adapter->state_lock);
 	if (test_bit(0, &adapter->resetting)) {
-		spin_unlock_irqrestore(&adapter->state_lock, flags);
+		mutex_unlock(&adapter->state_lock);
 		return -EBUSY;
 	}
 
@@ -5481,7 +5531,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	adapter->state = VNIC_REMOVING;
 	spin_unlock_irqrestore(&adapter->remove_lock, flags);
 
-	spin_unlock_irqrestore(&adapter->state_lock, flags);
+	mutex_unlock(&adapter->state_lock);
 
 	flush_work(&adapter->ibmvnic_reset);
 	flush_delayed_work(&adapter->ibmvnic_delayed_reset);
@@ -5497,7 +5547,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	release_stats_buffers(adapter);
 
 	adapter->state = VNIC_REMOVED;
-
+	mutex_destroy(&adapter->state_lock);
 	rtnl_unlock();
 	mutex_destroy(&adapter->fw_lock);
 	device_remove_file(&dev->dev, &dev_attr_failover);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 2779696ade09..ac79dfa76333 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -21,6 +21,7 @@
 #define IBMVNIC_STATS_TIMEOUT	1
 #define IBMVNIC_INIT_FAILED	2
 #define IBMVNIC_OPEN_FAILED	3
+#define IBMVNIC_NODEV		4
 
 /* basic structures plus 100 2k buffers */
 #define IBMVNIC_IO_ENTITLEMENT_DEFAULT	610305
@@ -1097,6 +1098,6 @@ struct ibmvnic_adapter {
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
 
-	/* Used for serializatin of state field */
-	spinlock_t state_lock;
+	/* Used for serialization of state field */
+	struct mutex state_lock;
 };
-- 
2.26.2

