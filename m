Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4FB4C3CF2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 05:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbiBYEKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 23:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbiBYEK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 23:10:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1752225A95D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 20:09:55 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P2GCiY022894
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hSQ2Kj2aj1MVoTwRio7y57fo0ZIrq726z9prVSeG/EI=;
 b=E0+iSxnWZIGiXFWuTAeVwnBjHdiMsnVUKHjv7X3A9BB2mIY9TAe1SWPqP+rPdbcwT6CZ
 CIOnKhYAiJLFabZomkduuNvdGKFPunRuPhyMyZ2Ao9MTKpeBsVsZqD8wsD0++ufeNbZh
 dAAFGjms4EAfFauXmdr8TcdF7Hw/NtETfjXiUyd0pWkLuIECZTYdMrv0Krh+wIRmW7JL
 jyACBPHM87e+y2npR748AfvQRtQeY2/2Yr3DZiZBmZZmp7KfVF/JMVeGRce7cd5OUPzc
 1rypQbSUgsSN/lSBA+D2Orrcz82BjkKm3A7HW4r0QY/oXAE0/zYNPEPcbyQ/1QG4TxK7 wA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edsjty156-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:54 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P432wT014314
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:53 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3ear6bfknw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:53 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P49qc036831512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 04:09:52 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C6C0BE05A;
        Fri, 25 Feb 2022 04:09:52 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDDF9BE051;
        Fri, 25 Feb 2022 04:09:50 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 04:09:50 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-internal v2 6/8] ibmvnic: init init_done_rc earlier
Date:   Thu, 24 Feb 2022 20:09:39 -0800
Message-Id: <20220225040941.1429630-7-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225040941.1429630-1-sukadev@linux.ibm.com>
References: <20220225040941.1429630-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tGYYdC2h-CE_eyLnPEjMfRafgLB2D3ZZ
X-Proofpoint-GUID: tGYYdC2h-CE_eyLnPEjMfRafgLB2D3ZZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_01,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250020
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently initialize the ->init_done completion/return code fields
before issuing a CRQ_INIT command. But if we get a transport event soon
after registering the CRQ the taskslet may already have recorded the
completion and error code. If we initialize here, we might overwrite/
lose that and end up issuing the CRQ_INIT only to timeout later.

If that timeout happens during probe, we will leave the adapter in the
DOWN state rather than retrying to register/init the CRQ.

Initialize the completion before registering the CRQ so we don't lose
the notification.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1d1fd4b41f80..936a94eaed5e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2212,6 +2212,19 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
 	return "UNKNOWN";
 }
 
+/*
+ * Initialize the init_done completion and return code values. We
+ * can get a transport event just after registering the CRQ and the
+ * tasklet will use this to communicate the transport event. To ensure
+ * we don't miss the notification/error, initialize these _before_
+ * regisering the CRQ.
+ */
+static inline void reinit_init_done(struct ibmvnic_adapter *adapter)
+{
+	reinit_completion(&adapter->init_done);
+	adapter->init_done_rc = 0;
+}
+
 /*
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -2318,6 +2331,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
+		reinit_init_done(adapter);
+
 		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
 			rc = init_crq_queue(adapter);
 		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
@@ -2461,7 +2476,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	 */
 	adapter->state = VNIC_PROBED;
 
-	reinit_completion(&adapter->init_done);
+	reinit_init_done(adapter);
+
 	rc = init_crq_queue(adapter);
 	if (rc) {
 		netdev_err(adapter->netdev,
@@ -5675,10 +5691,6 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	adapter->from_passive_init = false;
 
-	if (reset)
-		reinit_completion(&adapter->init_done);
-
-	adapter->init_done_rc = 0;
 	rc = ibmvnic_send_crq_init(adapter);
 	if (rc) {
 		dev_err(dev, "Send crq init failed with error %d\n", rc);
@@ -5692,12 +5704,14 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	if (adapter->init_done_rc) {
 		release_crq_queue(adapter);
+		dev_err(dev, "CRQ-init failed, %d\n", adapter->init_done_rc);
 		return adapter->init_done_rc;
 	}
 
 	if (adapter->from_passive_init) {
 		adapter->state = VNIC_OPEN;
 		adapter->from_passive_init = false;
+		dev_err(dev, "CRQ-init failed, passive-init\n");
 		return -EINVAL;
 	}
 
@@ -5791,6 +5805,8 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	init_success = false;
 	do {
+		reinit_init_done(adapter);
+
 		rc = init_crq_queue(adapter);
 		if (rc) {
 			dev_err(&dev->dev, "Couldn't initialize crq. rc=%d\n",
-- 
2.27.0

