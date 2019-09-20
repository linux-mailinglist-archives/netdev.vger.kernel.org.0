Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E915B9862
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 22:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfITUW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 16:22:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727273AbfITUW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 16:22:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KKMLYe063774;
        Fri, 20 Sep 2019 16:22:23 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v53wf47um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 16:22:23 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8KKJcO6007895;
        Fri, 20 Sep 2019 20:22:22 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 2v3vbuw2wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 20:22:22 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KKML8C58655116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 20:22:21 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 082A56A05D;
        Fri, 20 Sep 2019 20:22:21 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 951F66A04F;
        Fri, 20 Sep 2019 20:22:20 +0000 (GMT)
Received: from ltcfleet2-lp9.aus.stglabs.ibm.com (unknown [9.40.195.116])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 20:22:20 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, tlfalcon@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 1/2] net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run
Date:   Fri, 20 Sep 2019 16:11:22 -0400
Message-Id: <20190920201123.18913-2-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190920201123.18913-1-julietk@linux.vnet.ibm.com>
References: <20190920201123.18913-1-julietk@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200167
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
 drivers/net/ethernet/ibm/ibmvnic.c | 224 ++++++++++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |   1 +
 2 files changed, 157 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5cb55ea671e3..ba340aaff1b3 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1723,6 +1723,86 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	return rc;
 }
 
+/**
+ * do_change_param_reset returns zero if we are able to keep processing reset
+ * events, or non-zero if we hit a fatal error and must halt.
+ */
+static int do_change_param_reset(struct ibmvnic_adapter *adapter,
+				 struct ibmvnic_rwi *rwi,
+				 u32 reset_state)
+{
+	struct net_device *netdev = adapter->netdev;
+	int i, rc;
+
+	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
+		   rwi->reset_reason);
+
+	netif_carrier_off(netdev);
+	adapter->reset_reason = rwi->reset_reason;
+
+	ibmvnic_cleanup(netdev);
+
+	if (reset_state == VNIC_OPEN) {
+		rc = __ibmvnic_close(netdev);
+		if (rc)
+			return rc;
+	}
+
+	release_resources(adapter);
+	release_sub_crqs(adapter, 1);
+	release_crq_queue(adapter);
+
+	adapter->state = VNIC_PROBED;
+
+	rc = init_crq_queue(adapter);
+
+	if (rc) {
+		netdev_err(adapter->netdev,
+			   "Couldn't initialize crq. rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = ibmvnic_reset_init(adapter);
+	if (rc)
+		return IBMVNIC_INIT_FAILED;
+
+	/* If the adapter was in PROBE state prior to the reset,
+	 * exit here.
+	 */
+	if (reset_state == VNIC_PROBED)
+		return 0;
+
+	rc = ibmvnic_login(netdev);
+	if (rc) {
+		adapter->state = reset_state;
+		return rc;
+	}
+
+	rc = init_resources(adapter);
+	if (rc)
+		return rc;
+
+	ibmvnic_disable_irqs(adapter);
+
+	adapter->state = VNIC_CLOSED;
+
+	if (reset_state == VNIC_CLOSED)
+		return 0;
+
+	rc = __ibmvnic_open(netdev);
+	if (rc)
+		return IBMVNIC_OPEN_FAILED;
+
+	/* refresh device's multicast list */
+	ibmvnic_set_multi(netdev);
+
+	/* kick napi */
+	for (i = 0; i < adapter->req_rx_queues; i++)
+		napi_schedule(&adapter->napi[i]);
+
+	return 0;
+}
+
 /**
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -1738,6 +1818,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
 		   rwi->reset_reason);
 
+	rtnl_lock();
+
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
 
@@ -1751,16 +1833,25 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	if (reset_state == VNIC_OPEN &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
 	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
-		rc = __ibmvnic_close(netdev);
+		adapter->state = VNIC_CLOSING;
+
+		/* Release the RTNL lock before link state change and
+		 * re-acquire after the link state change to allow
+		 * linkwatch_event to grab the RTNL lock and run during
+		 * a reset.
+		 */
+		rtnl_unlock();
+		rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
+		rtnl_lock();
 		if (rc)
-			return rc;
-	}
+			goto out;
 
-	if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM ||
-	    adapter->wait_for_reset) {
-		release_resources(adapter);
-		release_sub_crqs(adapter, 1);
-		release_crq_queue(adapter);
+		if (adapter->state != VNIC_CLOSING) {
+			rc = -1;
+			goto out;
+		}
+
+		adapter->state = VNIC_CLOSED;
 	}
 
 	if (adapter->reset_reason != VNIC_RESET_NON_FATAL) {
@@ -1769,9 +1860,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
-		if (adapter->wait_for_reset) {
-			rc = init_crq_queue(adapter);
-		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
+		if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
 			rc = ibmvnic_reenable_crq_queue(adapter);
 			release_sub_crqs(adapter, 1);
 		} else {
@@ -1783,36 +1872,35 @@ static int do_reset(struct ibmvnic_adapter *adapter,
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
 
-		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM ||
-		    adapter->wait_for_reset) {
-			rc = init_resources(adapter);
-			if (rc)
-				return rc;
-		} else if (adapter->req_rx_queues != old_num_rx_queues ||
-			   adapter->req_tx_queues != old_num_tx_queues ||
-			   adapter->req_rx_add_entries_per_subcrq !=
-							old_num_rx_slots ||
-			   adapter->req_tx_entries_per_subcrq !=
-							old_num_tx_slots) {
+		if (adapter->req_rx_queues != old_num_rx_queues ||
+		    adapter->req_tx_queues != old_num_tx_queues ||
+		    adapter->req_rx_add_entries_per_subcrq !=
+		    old_num_rx_slots ||
+		    adapter->req_tx_entries_per_subcrq !=
+		    old_num_tx_slots) {
 			release_rx_pools(adapter);
 			release_tx_pools(adapter);
 			release_napi(adapter);
@@ -1820,32 +1908,30 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
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
-		if (list_empty(&adapter->rwi_list))
-			adapter->state = VNIC_CLOSED;
-		else
-			adapter->state = reset_state;
-
-		return 0;
+		rc = IBMVNIC_OPEN_FAILED;
+		goto out;
 	}
 
 	/* refresh device's multicast list */
@@ -1855,11 +1941,15 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
-	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM)
+	if (adapter->reset_reason != VNIC_RESET_FAILOVER)
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 
-	return 0;
+	rc = 0;
+
+out:
+	rtnl_unlock();
+
+	return rc;
 }
 
 static int do_hard_reset(struct ibmvnic_adapter *adapter,
@@ -1919,14 +2009,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 		return 0;
 
 	rc = __ibmvnic_open(netdev);
-	if (rc) {
-		if (list_empty(&adapter->rwi_list))
-			adapter->state = VNIC_CLOSED;
-		else
-			adapter->state = reset_state;
-
-		return 0;
-	}
+	if (rc)
+		return IBMVNIC_OPEN_FAILED;
 
 	return 0;
 }
@@ -1965,20 +2049,11 @@ static void __ibmvnic_reset(struct work_struct *work)
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
@@ -1990,14 +2065,32 @@ static void __ibmvnic_reset(struct work_struct *work)
 			break;
 		}
 
-		if (adapter->force_reset_recovery) {
-			adapter->force_reset_recovery = false;
-			rc = do_hard_reset(adapter, rwi, reset_state);
+		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+			/* CHANGE_PARAM requestor holds rtnl_lock */
+			rc = do_change_param_reset(adapter, rwi, reset_state);
+		} else if (adapter->force_reset_recovery) {
+			/* Transport event occurred during previous reset */
+			if (adapter->wait_for_reset) {
+				/* Previous was CHANGE_PARAM; caller locked */
+				adapter->force_reset_recovery = false;
+				rc = do_hard_reset(adapter, rwi, reset_state);
+			} else {
+				rtnl_lock();
+				adapter->force_reset_recovery = false;
+				rc = do_hard_reset(adapter, rwi, reset_state);
+				rtnl_unlock();
+			}
 		} else {
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);
-		if (rc && rc != IBMVNIC_INIT_FAILED &&
+		if (rc == IBMVNIC_OPEN_FAILED) {
+			if (list_empty(&adapter->rwi_list))
+				adapter->state = VNIC_CLOSED;
+			else
+				adapter->state = reset_state;
+			rc = 0;
+		} else if (rc && rc != IBMVNIC_INIT_FAILED &&
 		    !adapter->force_reset_recovery)
 			break;
 
@@ -2005,7 +2098,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	if (adapter->wait_for_reset) {
-		adapter->wait_for_reset = false;
 		adapter->reset_done_rc = rc;
 		complete(&adapter->reset_done);
 	}
@@ -2016,8 +2108,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	adapter->resetting = false;
-	if (we_lock_rtnl)
-		rtnl_unlock();
 }
 
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
@@ -2078,8 +2168,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	return 0;
 err:
-	if (adapter->wait_for_reset)
-		adapter->wait_for_reset = false;
 	return -ret;
 }
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 70bd286f8932..9d3d35cc91d6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -20,6 +20,7 @@
 #define IBMVNIC_INVALID_MAP	-1
 #define IBMVNIC_STATS_TIMEOUT	1
 #define IBMVNIC_INIT_FAILED	2
+#define IBMVNIC_OPEN_FAILED	3
 
 /* basic structures plus 100 2k buffers */
 #define IBMVNIC_IO_ENTITLEMENT_DEFAULT	610305
-- 
2.16.4

