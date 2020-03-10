Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71F017ED1A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 01:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgCJAGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 20:06:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727533AbgCJAGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 20:06:31 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02A05ewP083212;
        Mon, 9 Mar 2020 20:06:17 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ynr9cqkjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 20:06:17 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02A01x9W025845;
        Tue, 10 Mar 2020 00:06:17 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 2ym3866cdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 00:06:17 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02A06Gdc34865446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 00:06:16 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A56C628059;
        Tue, 10 Mar 2020 00:06:16 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50A2828058;
        Tue, 10 Mar 2020 00:06:16 +0000 (GMT)
Received: from ltcalpine2-lp14.aus.stglabs.ibm.com (unknown [9.40.195.197])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 00:06:16 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, julietk@linux.vnet.ibm.com,
        tlfalcon@linux.vnet.ibm.com
Subject: [PATCH] ibmvnic: Do not process device remove during device reset
Date:   Mon,  9 Mar 2020 19:00:58 -0500
Message-Id: <20200310000058.58521-1-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_13:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 suspectscore=3 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ibmvnic driver does not check the device state when the device
is removed. If the device is removed while a device reset is being 
processed, the remove may free structures needed by the reset, 
causing an oops.

Fix this by checking the device state before processing device remove.

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 24 ++++++++++++++++++++++--
 drivers/net/ethernet/ibm/ibmvnic.h |  6 +++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c75239d8820f..7ef1ae0d49bc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2144,6 +2144,8 @@ static void __ibmvnic_reset(struct work_struct *work)
 	struct ibmvnic_adapter *adapter;
 	u32 reset_state;
 	int rc = 0;
+	unsigned long flags;
+	bool saved_state = false;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
 
@@ -2153,17 +2155,25 @@ static void __ibmvnic_reset(struct work_struct *work)
 		return;
 	}
 
-	reset_state = adapter->state;
-
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
+		spin_lock_irqsave(&adapter->state_lock, flags);
+
 		if (adapter->state == VNIC_REMOVING ||
 		    adapter->state == VNIC_REMOVED) {
+			spin_unlock_irqrestore(&adapter->state_lock, flags);
 			kfree(rwi);
 			rc = EBUSY;
 			break;
 		}
 
+		if (!saved_state) {
+			reset_state = adapter->state;
+			adapter->state = VNIC_RESETTING;
+			saved_state = true;
+		}
+		spin_unlock_irqrestore(&adapter->state_lock, flags);
+
 		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
 			/* CHANGE_PARAM requestor holds rtnl_lock */
 			rc = do_change_param_reset(adapter, rwi, reset_state);
@@ -5091,6 +5101,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 			  __ibmvnic_delayed_reset);
 	INIT_LIST_HEAD(&adapter->rwi_list);
 	spin_lock_init(&adapter->rwi_lock);
+	spin_lock_init(&adapter->state_lock);
 	mutex_init(&adapter->fw_lock);
 	init_completion(&adapter->init_done);
 	init_completion(&adapter->fw_done);
@@ -5161,10 +5172,19 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 static int ibmvnic_remove(struct vio_dev *dev)
 {
+	unsigned long flags;
 	struct net_device *netdev = dev_get_drvdata(&dev->dev);
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
+	spin_lock_irqsave(&adapter->state_lock, flags);
+	if (adapter->state == VNIC_RESETTING) {
+		spin_unlock_irqrestore(&adapter->state_lock, flags);
+		return -EBUSY;
+	}
+
 	adapter->state = VNIC_REMOVING;
+	spin_unlock_irqrestore(&adapter->state_lock, flags);
+
 	rtnl_lock();
 	unregister_netdevice(netdev);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 60eccaf91b12..971505e4cc52 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -941,7 +941,8 @@ enum vnic_state {VNIC_PROBING = 1,
 		 VNIC_CLOSING,
 		 VNIC_CLOSED,
 		 VNIC_REMOVING,
-		 VNIC_REMOVED};
+		 VNIC_REMOVED,
+		 VNIC_RESETTING};
 
 enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
 			   VNIC_RESET_MOBILITY,
@@ -1090,4 +1091,7 @@ struct ibmvnic_adapter {
 
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
+
+	/* lock to protect state field */
+	spinlock_t state_lock;
 };
-- 
2.25.0

