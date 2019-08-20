Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454A196BA4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbfHTVnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:43:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729900AbfHTVnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 17:43:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KLg9vX086283;
        Tue, 20 Aug 2019 17:42:55 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugqat4400-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 17:42:54 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7KLe5bc025851;
        Tue, 20 Aug 2019 21:42:54 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 2ue976yp80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 21:42:54 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KLgrmd42795496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 21:42:53 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 182FAAE062;
        Tue, 20 Aug 2019 21:42:53 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8307AE060;
        Tue, 20 Aug 2019 21:42:52 +0000 (GMT)
Received: from ltcfleet2-lp9.aus.stglabs.ibm.com (unknown [9.40.195.116])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 21:42:52 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/2] net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run
Date:   Tue, 20 Aug 2019 17:31:19 -0400
Message-Id: <20190820213120.19880-1-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.16.4
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a5681e20b541 ("net/ibmnvic: Fix deadlock problem in reset") 
made the change to hold the RTNL lock during a reset to avoid deadlock 
but linkwatch_event is fired during the reset and needs the RTNL lock.  
That keeps linkwatch_event process from proceeding until the reset 
is complete. The reset process cannot tolerate the linkwatch_event 
processing after reset completes, so release the RTNL lock during the 
process to allow a chance for linkwatch_event to run during reset. 
This does not guarantee that the linkwatch_event will be processed as 
soon as link state changes, but is an improvement over the current code
where linkwatch_event processing is always delayed, which prevents 
transmissions on the device from being deactivated leading transmit 
watchdog timer to time-out. 

Release the RTNL lock before link state change and re-acquire after 
the link state change to allow linkwatch_event to grab the RTNL lock 
and run during the reset.

Fixes: a5681e20b541 ("net/ibmnvic: Fix deadlock problem in reset")

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 144 +++++++++++++++++++++++++++----------
 1 file changed, 108 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cebd20f3128d..a3e2fbb9c5db 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1733,11 +1733,21 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	u64 old_num_rx_queues, old_num_tx_queues;
 	u64 old_num_rx_slots, old_num_tx_slots;
 	struct net_device *netdev = adapter->netdev;
+	bool we_lock_rtnl = false;
 	int i, rc;
 
 	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
 		   rwi->reset_reason);
 
+	/* netif_set_real_num_xx_queues needs to take rtnl lock here
+	 * unless wait_for_reset is set, in which case the rtnl lock
+	 * has already been taken before initializing the reset
+	 */
+	if (!adapter->wait_for_reset && !we_lock_rtnl) {
+		rtnl_lock();
+		we_lock_rtnl = true;
+	}
+
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
 
@@ -1751,9 +1761,27 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	if (reset_state == VNIC_OPEN &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
 	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
-		rc = __ibmvnic_close(netdev);
+		adapter->state = VNIC_CLOSING;
+		if (!adapter->wait_for_reset && we_lock_rtnl) {
+			we_lock_rtnl = false;
+			rtnl_unlock();
+		}
+
+		rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
 		if (rc)
-			return rc;
+			goto out;
+
+		if (!adapter->wait_for_reset && !we_lock_rtnl) {
+			rtnl_lock();
+			we_lock_rtnl = true;
+		}
+
+		if (adapter->state != VNIC_CLOSING) {
+			rc = -1;
+			goto out;
+		}
+
+		adapter->state = VNIC_CLOSED;
 	}
 
 	if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM ||
@@ -1783,30 +1811,34 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		if (rc) {
 			netdev_err(adapter->netdev,
 				   "Couldn't initialize crq. rc=%d\n", rc);
-			return rc;
+			goto out;
 		}
 
 		rc = ibmvnic_reset_init(adapter);
-		if (rc)
-			return IBMVNIC_INIT_FAILED;
+		if (rc) {
+			rc = IBMVNIC_INIT_FAILED;
+			goto out;
+		}
 
 		/* If the adapter was in PROBE state prior to the reset,
 		 * exit here.
 		 */
-		if (reset_state == VNIC_PROBED)
-			return 0;
+		if (reset_state == VNIC_PROBED) {
+			rc = 0;
+			goto out;
+		}
 
 		rc = ibmvnic_login(netdev);
 		if (rc) {
 			adapter->state = reset_state;
-			return rc;
+			goto out;
 		}
 
 		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM ||
 		    adapter->wait_for_reset) {
 			rc = init_resources(adapter);
 			if (rc)
-				return rc;
+				goto out;
 		} else if (adapter->req_rx_queues != old_num_rx_queues ||
 			   adapter->req_tx_queues != old_num_tx_queues ||
 			   adapter->req_rx_add_entries_per_subcrq !=
@@ -1820,23 +1852,25 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 			rc = init_resources(adapter);
 			if (rc)
-				return rc;
+				goto out;
 
 		} else {
 			rc = reset_tx_pools(adapter);
 			if (rc)
-				return rc;
+				goto out;
 
 			rc = reset_rx_pools(adapter);
 			if (rc)
-				return rc;
+				goto out;
 		}
 		ibmvnic_disable_irqs(adapter);
 	}
 	adapter->state = VNIC_CLOSED;
 
-	if (reset_state == VNIC_CLOSED)
-		return 0;
+	if (reset_state == VNIC_CLOSED) {
+		rc = 0;
+		goto out;
+	}
 
 	rc = __ibmvnic_open(netdev);
 	if (rc) {
@@ -1845,7 +1879,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		else
 			adapter->state = reset_state;
 
-		return 0;
+		rc = 0;
+		goto out;
 	}
 
 	/* refresh device's multicast list */
@@ -1859,18 +1894,42 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM)
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 
+	if (!adapter->wait_for_reset && we_lock_rtnl) {
+		rtnl_unlock();
+		we_lock_rtnl = false;
+	}
+
 	return 0;
+
+out:
+	if (!adapter->wait_for_reset && we_lock_rtnl) {
+		rtnl_unlock();
+		we_lock_rtnl = false;
+	}
+
+	return rc;
 }
 
 static int do_hard_reset(struct ibmvnic_adapter *adapter,
 			 struct ibmvnic_rwi *rwi, u32 reset_state)
 {
 	struct net_device *netdev = adapter->netdev;
+	bool we_lock_rtnl = false;
 	int rc;
 
 	netdev_dbg(adapter->netdev, "Hard resetting driver (%d)\n",
 		   rwi->reset_reason);
 
+	/* netif_set_real_num_xx_queues needs to take rtnl lock here
+	 * unless wait_for_reset is set, in which case the rtnl lock
+	 * has already been taken before initializing the reset
+	 */
+	if (!adapter->wait_for_reset && !we_lock_rtnl) {
+		rtnl_lock();
+		we_lock_rtnl = true;
+	}
+
+	adapter->force_reset_recovery = false;
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
 
@@ -1889,34 +1948,39 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc) {
 		netdev_err(adapter->netdev,
 			   "Couldn't initialize crq. rc=%d\n", rc);
-		return rc;
+		goto out;
 	}
 
 	rc = ibmvnic_init(adapter);
 	if (rc)
-		return rc;
+		goto out;
 
 	/* If the adapter was in PROBE state prior to the reset,
 	 * exit here.
 	 */
-	if (reset_state == VNIC_PROBED)
-		return 0;
+	if (reset_state == VNIC_PROBED) {
+		rc = 0;
+		goto out;
+	}
 
 	rc = ibmvnic_login(netdev);
 	if (rc) {
 		adapter->state = VNIC_PROBED;
-		return 0;
+		rc = 0;
+		goto out;
 	}
 
 	rc = init_resources(adapter);
 	if (rc)
-		return rc;
+		goto out;
 
 	ibmvnic_disable_irqs(adapter);
 	adapter->state = VNIC_CLOSED;
 
-	if (reset_state == VNIC_CLOSED)
-		return 0;
+	if (reset_state == VNIC_CLOSED) {
+		rc = 0;
+		goto out;
+	}
 
 	rc = __ibmvnic_open(netdev);
 	if (rc) {
@@ -1925,10 +1989,25 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 		else
 			adapter->state = reset_state;
 
-		return 0;
+		rc = 0;
+		goto out;
+	}
+
+	if (!adapter->wait_for_reset && we_lock_rtnl) {
+		rtnl_unlock();
+		we_lock_rtnl = false;
 	}
 
 	return 0;
+
+out:
+	if (!adapter->wait_for_reset && we_lock_rtnl) {
+		rtnl_unlock();
+		we_lock_rtnl = false;
+	}
+
+	return rc;
+
 }
 
 static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
@@ -1965,26 +2044,16 @@ static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_rwi *rwi;
 	struct ibmvnic_adapter *adapter;
-	bool we_lock_rtnl = false;
 	u32 reset_state;
 	int rc = 0;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
 
-	/* netif_set_real_num_xx_queues needs to take rtnl lock here
-	 * unless wait_for_reset is set, in which case the rtnl lock
-	 * has already been taken before initializing the reset
-	 */
-	if (!adapter->wait_for_reset) {
-		rtnl_lock();
-		we_lock_rtnl = true;
-	}
 	reset_state = adapter->state;
 
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
 		if (adapter->force_reset_recovery) {
-			adapter->force_reset_recovery = false;
 			rc = do_hard_reset(adapter, rwi, reset_state);
 		} else {
 			rc = do_reset(adapter, rwi, reset_state);
@@ -1995,6 +2064,11 @@ static void __ibmvnic_reset(struct work_struct *work)
 			break;
 
 		rwi = get_next_rwi(adapter);
+
+		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
+			    rwi->reset_reason == VNIC_RESET_MOBILITY) &&
+			!adapter->force_reset_recovery)
+			adapter->force_reset_recovery = true;
 	}
 
 	if (adapter->wait_for_reset) {
@@ -2009,8 +2083,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	adapter->resetting = false;
-	if (we_lock_rtnl)
-		rtnl_unlock();
 }
 
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
-- 
2.16.4

