Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3812C19B0
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgKWX6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728132AbgKWX6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:15 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNWAu3033592
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6joUUpwqnmH+0gv1rtJWJwogZIfjqIFV9adHljKMA4A=;
 b=m8tT/cnFwBeZyASks6imz8OGiQF8NSEfe2QuRUSUJDgyyzyt/hcoRygE1uJZuB0uNTJo
 CPbmAJtODLjcXkyjiMLqV8pAhaKsJl3P5Tv+zDqXaJJ+Y2ijaX0BTRZShHRUqyuTT495
 jGc9YeLis6pztjN2w0c5Sr8/qdCaDEHitqZj+jVEUAZv1KkywyoL5KDPv+nEGJeiM2CK
 Kd4LnMrKhQ6cSVafB2kmDRWmJUBNFfbWsSAET62MxfDLvicAQv9Jl2QQ2Xvn9RsekebN
 NcYlUKo9x00nd/gFZuE3P9YRHY0F6gANykAuuCmBUQUq+ZEJlPH7KJ+8g0tKK3o+alhi Xw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350mepvm18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:14 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNvWu3008196
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:13 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 34xth8u0sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:13 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwD7o16515586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:13 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5DD22805C;
        Mon, 23 Nov 2020 23:58:12 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C21A28059;
        Mon, 23 Nov 2020 23:58:12 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:12 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 6/9] ibmvnic: track pending login
Date:   Mon, 23 Nov 2020 18:57:54 -0500
Message-Id: <20201123235757.6466-7-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 phishscore=0
 adultscore=0 bulkscore=0 mlxlogscore=769 lowpriorityscore=0 spamscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

If after ibmvnic sends a LOGIN it gets a FAILOVER, it is possible that
the worker thread will start reset process and free the login response
buffer before it gets a (now stale) LOGIN_RSP. The ibmvnic tasklet will
then try to access the login response buffer and crash.

Have ibmvnic track pending logins and discard any stale login responses.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a11af9e0a0a1..6d01cc8ec6b6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3838,6 +3838,8 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	crq.login.cmd = LOGIN;
 	crq.login.ioba = cpu_to_be32(buffer_token);
 	crq.login.len = cpu_to_be32(buffer_size);
+
+	adapter->login_pending = true;
 	ibmvnic_send_crq(adapter, &crq);
 
 	return 0;
@@ -4390,6 +4392,15 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
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
@@ -4761,6 +4772,11 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
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
@@ -5190,6 +5206,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	dev_set_drvdata(&dev->dev, netdev);
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
+	adapter->login_pending = false;
 
 	ether_addr_copy(adapter->mac_addr, mac_addr_p);
 	ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 217dcc7ded70..6f0a701c4a38 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1087,6 +1087,7 @@ struct ibmvnic_adapter {
 	struct delayed_work ibmvnic_delayed_reset;
 	unsigned long resetting;
 	bool napi_enabled, from_passive_init;
+	bool login_pending;
 
 	bool failover_pending;
 	bool force_reset_recovery;
-- 
2.26.2

