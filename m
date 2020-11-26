Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E872C4BD3
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgKZAJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:09:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25660 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728829AbgKZAJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:09:43 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ01rOw044782;
        Wed, 25 Nov 2020 19:09:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GznAOiMUBTMy45YnONg4DDcO9hsFx92aPFKYOHdvnpc=;
 b=oZRz/OxiEdbeXhuG5WgF7fOx01nFOOBuHDUqwfwl+VH9mS5KS+IIQ5FMvH8GaQcNxb06
 73X+r3bmCEB8snFzs39VHTLOjcVCs4gyDcSCC/UoMaMmaTJ7QZMrHVP2NeI86cbuKj4n
 3sbjats5LZksQYSLl0gfYj/YpLByiYoywv1FixsHzhfUv7jqzBQOTCRfBBCCXWU/OR7m
 3NgKVVA7ia4xZu3b3rEF1TZ+RKTMSFJiYKSzu7B6RYrKqoIDo9Cr24HaMO+N+10sC43X
 C39/B01e+TU2iyIBNKT3am0I5RGiMKDtRhTbufOkjtV2e7EQDjCFL4mlF0zoaM51H0j8 bg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351wndn3hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 19:09:38 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0APNsJTE030726;
        Thu, 26 Nov 2020 00:09:38 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 34xth9b45f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 00:09:38 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ09bSb16253626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 00:09:37 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91487AC05F;
        Thu, 26 Nov 2020 00:09:37 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ED0DAC05B;
        Thu, 26 Nov 2020 00:09:37 +0000 (GMT)
Received: from linux-i8xm.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 00:09:37 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     ljp@linux.ibm.com, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net v3 6/9] ibmvnic: track pending login
Date:   Wed, 25 Nov 2020 18:04:29 -0600
Message-Id: <20201126000432.29897-7-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126000432.29897-1-drt@linux.ibm.com>
References: <20201126000432.29897-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 bulkscore=0 suspectscore=3 adultscore=0 spamscore=0 mlxlogscore=892
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240121
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
index e2f9b0e9dea8..55b07bd4c741 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3839,6 +3839,8 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	crq.login.cmd = LOGIN;
 	crq.login.ioba = cpu_to_be32(buffer_token);
 	crq.login.len = cpu_to_be32(buffer_size);
+
+	adapter->login_pending = true;
 	ibmvnic_send_crq(adapter, &crq);
 
 	return 0;
@@ -4391,6 +4393,15 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
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
@@ -4762,6 +4773,11 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
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
@@ -5191,6 +5207,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
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

