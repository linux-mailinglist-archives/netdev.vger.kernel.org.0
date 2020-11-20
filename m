Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA442BB942
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgKTWlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729099AbgKTWlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:00 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMXDU2061483
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K+jmjRvsOVEAmiv+i4uUD4h5u0e2XlrMPx8Hf2WIF/Y=;
 b=NFRxjUyzdfFjiPtOAtUbK2Rs18xkCqjf23wH4DJExfUCAx0rxA+2l/Osnonz/Vp8wLcC
 78h2hH+dtgFK2DU5tMuEcIgsZKO1EdqzcBSVvlfTv3/+b8LO6/LSifeqRIcYAJgEnnPm
 wOzo/2ahecNUi614oLmq1OWHMgjEjck8evCbper5Kj45GSn/Ksd1Ox6M+KzX2s87fyqP
 Rju25Cm6LLmMaQGG2gXKThMlXgIUAY8gfRZ88YF6Ey2RV2XhbNILFEuURD9OUNOc+JYk
 cYOi52xYhgd+R/9lcClvwd4aGrboCAD7yYXyWn3iqf666w/B35a/eoVybI2a6ey4Jjj6 1g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xgu8arkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:00 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMcWhU027016
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:59 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 34t6va68ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:59 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMemLL11076182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:48 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A047D6E056;
        Fri, 20 Nov 2020 22:40:57 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 031E26E052;
        Fri, 20 Nov 2020 22:40:57 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:56 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 08/15] ibmvnic: track pending login
Date:   Fri, 20 Nov 2020 16:40:42 -0600
Message-Id: <20201120224049.46933-9-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=959 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 suspectscore=3 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

If after ibmvnic sent a LOGIN and got a FAILOVER, it is possible that the
worker thread will start the reset process and free the login response
buffer before it gets a (now stale) LOGIN_RSP. The ibmvnic tasklet will
then tries to access the login response buffer and crash.

This patch tracks when ibmvnic sends a LOGIN and discards any stale login
responses.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b0a93556a51b..c8242c0bfee0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3876,6 +3876,8 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	crq.login.cmd = LOGIN;
 	crq.login.ioba = cpu_to_be32(buffer_token);
 	crq.login.len = cpu_to_be32(buffer_size);
+
+	adapter->login_pending = true;
 	ibmvnic_send_crq(adapter, &crq);
 
 	return 0;
@@ -4428,6 +4430,15 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	u64 *size_array;
 	int i;
 
+	/* CHECK: Test/set of login_pending does not need to be atomic
+	 * because only ibmvnic_tasklet tests/clears this.
+	 */
+	if (!adapter->login_pending) {
+		netdev_warn(netdev, "Ignoring unexpected login response\n");
+		return 0;
+	}
+	adapter->login_pending = false;
+
 	dma_unmap_single(dev, adapter->login_buf_token, adapter->login_buf_sz,
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, adapter->login_rsp_buf_token,
@@ -4799,6 +4810,11 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		case IBMVNIC_CRQ_INIT:
 			dev_info(dev, "Partner initialized\n");
 			adapter->from_passive_init = true;
+			/* Discard any stale login responses from prev reset.
+			 * CHECK: should we clear even on INIT_COMPLETE?
+			 */
+			adapter->login_pending = false;
+
 			if (!completion_done(&adapter->init_done)) {
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
@@ -5230,6 +5246,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	dev_set_drvdata(&dev->dev, netdev);
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
+	adapter->login_pending = false;
 
 	ether_addr_copy(adapter->mac_addr, mac_addr_p);
 	ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index af68f85534bc..9b1f34602f33 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1088,6 +1088,7 @@ struct ibmvnic_adapter {
 	struct delayed_work ibmvnic_delayed_reset;
 	unsigned long resetting;
 	bool napi_enabled, from_passive_init;
+	bool login_pending;
 
 	bool failover_pending;
 	bool force_reset_recovery;
-- 
2.23.0

