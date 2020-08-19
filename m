Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BF624947E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHSFfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:35:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgHSFfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:35:19 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J5VkEw066077;
        Wed, 19 Aug 2020 01:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NsfJGMR2MfwEEB1xinhwp5fiwTAL2W92XoiCt1dXzEs=;
 b=hRFSBWeG08namM6ikW9fDdlgqErfeTko26ocM6U9skIi6r2F3Pb2KeS+Z1k7XrDe1ca+
 WxEVw0D/uQJsYyBxZHN++kCuETiT1AO752S1/Ym1vMc9vTpsFjEmS1HB1AscMrPuZ4nn
 AUradMnKmf0iNgAmddZkrD6Z14q68gbtA8Lo46gCb+Xskhjgt4D0jDjA/ddPBwOBhIQr
 QMExgSB0gB2vjj9feKzqPia52cR6byVv9Z8lERndNPlw0TmxAujiELGwr7EEalzdV1vU
 weoxt3r25Chqa5erGOAC5pOUHB5n98N6q4NyB2Glj9gHGR4QUy0km1kPUp9vz9rQpatc VQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r3yshp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 01:35:17 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J5Ycuc010653;
        Wed, 19 Aug 2020 05:35:15 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3304uehf5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 05:35:15 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J5ZFP649676624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 05:35:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E07AAC05B;
        Wed, 19 Aug 2020 05:35:15 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16B09AC059;
        Wed, 19 Aug 2020 05:35:15 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.104.33])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 05:35:14 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 5/5] ibmvnic: merge ibmvnic_reset_init and ibmvnic_init
Date:   Wed, 19 Aug 2020 00:35:12 -0500
Message-Id: <20200819053512.3619-6-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200819053512.3619-1-ljp@linux.ibm.com>
References: <20200819053512.3619-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_02:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190042
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two functions share the majority of the code, hence merge
them together. In the meanwhile, add a reset pass-in parameter
to differentiate them. Thus, the code is easier to read and to tell
the difference between reset_init and regular init.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 65 ++++++------------------------
 1 file changed, 13 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 280358dce8ba..c92615b74833 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -104,8 +104,7 @@ static int send_login(struct ibmvnic_adapter *adapter);
 static void send_cap_queries(struct ibmvnic_adapter *adapter);
 static int init_sub_crqs(struct ibmvnic_adapter *);
 static int init_sub_crq_irqs(struct ibmvnic_adapter *adapter);
-static int ibmvnic_init(struct ibmvnic_adapter *);
-static int ibmvnic_reset_init(struct ibmvnic_adapter *);
+static int ibmvnic_reset_init(struct ibmvnic_adapter *, bool reset);
 static void release_crq_queue(struct ibmvnic_adapter *);
 static int __ibmvnic_set_mac(struct net_device *, u8 *);
 static int init_crq_queue(struct ibmvnic_adapter *adapter);
@@ -1868,7 +1867,7 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 		return rc;
 	}
 
-	rc = ibmvnic_reset_init(adapter);
+	rc = ibmvnic_reset_init(adapter, true);
 	if (rc)
 		return IBMVNIC_INIT_FAILED;
 
@@ -1986,7 +1985,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			goto out;
 		}
 
-		rc = ibmvnic_reset_init(adapter);
+		rc = ibmvnic_reset_init(adapter, true);
 		if (rc) {
 			rc = IBMVNIC_INIT_FAILED;
 			goto out;
@@ -2093,7 +2092,7 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 		return rc;
 	}
 
-	rc = ibmvnic_init(adapter);
+	rc = ibmvnic_reset_init(adapter, false);
 	if (rc)
 		return rc;
 
@@ -4970,7 +4969,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 	return retrc;
 }
 
-static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
+static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 {
 	struct device *dev = &adapter->vdev->dev;
 	unsigned long timeout = msecs_to_jiffies(30000);
@@ -4979,10 +4978,12 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 
 	adapter->from_passive_init = false;
 
-	old_num_rx_queues = adapter->req_rx_queues;
-	old_num_tx_queues = adapter->req_tx_queues;
+	if (reset) {
+		old_num_rx_queues = adapter->req_rx_queues;
+		old_num_tx_queues = adapter->req_tx_queues;
+		reinit_completion(&adapter->init_done);
+	}
 
-	reinit_completion(&adapter->init_done);
 	adapter->init_done_rc = 0;
 	rc = ibmvnic_send_crq_init(adapter);
 	if (rc) {
@@ -5000,7 +5001,8 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 		return adapter->init_done_rc;
 	}
 
-	if (test_bit(0, &adapter->resetting) && !adapter->wait_for_reset &&
+	if (reset &&
+	    test_bit(0, &adapter->resetting) && !adapter->wait_for_reset &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY) {
 		if (adapter->req_rx_queues != old_num_rx_queues ||
 		    adapter->req_tx_queues != old_num_tx_queues) {
@@ -5028,47 +5030,6 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 	return rc;
 }
 
-static int ibmvnic_init(struct ibmvnic_adapter *adapter)
-{
-	struct device *dev = &adapter->vdev->dev;
-	unsigned long timeout = msecs_to_jiffies(30000);
-	int rc;
-
-	adapter->from_passive_init = false;
-
-	adapter->init_done_rc = 0;
-	rc = ibmvnic_send_crq_init(adapter);
-	if (rc) {
-		dev_err(dev, "%s: Send crq init failed with error %d\n", __func__, rc);
-		return rc;
-	}
-
-	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
-		dev_err(dev, "Initialization sequence timed out\n");
-		return -1;
-	}
-
-	if (adapter->init_done_rc) {
-		release_crq_queue(adapter);
-		return adapter->init_done_rc;
-	}
-
-	rc = init_sub_crqs(adapter);
-	if (rc) {
-		dev_err(dev, "Initialization of sub crqs failed\n");
-		release_crq_queue(adapter);
-		return rc;
-	}
-
-	rc = init_sub_crq_irqs(adapter);
-	if (rc) {
-		dev_err(dev, "Failed to initialize sub crq irqs\n");
-		release_crq_queue(adapter);
-	}
-
-	return rc;
-}
-
 static struct device_attribute dev_attr_failover;
 
 static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
@@ -5131,7 +5092,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 			goto ibmvnic_init_fail;
 		}
 
-		rc = ibmvnic_init(adapter);
+		rc = ibmvnic_reset_init(adapter, false);
 		if (rc && rc != EAGAIN)
 			goto ibmvnic_init_fail;
 	} while (rc == EAGAIN);
-- 
2.23.0

