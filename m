Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574A52C4BD1
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgKZAJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:09:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727498AbgKZAJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:09:42 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ01ngf084748;
        Wed, 25 Nov 2020 19:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cyXkgWoUxwG2aTyA95OgnCiMIPfUWZNIxMPqUAeOkSE=;
 b=ik9Z2ugUEXjuKY9N8y6ORrGypd4bjqBmkHFXk5tnWlUBP6uSiQNvCVL/41B1M3wlB8qy
 JP43GtzbMkaRRSJIzZrPn8apcLhPTKFlIE9mxHs4x9z8gco+kbhuvp4y/RRHwMdMoh2j
 IC7wHZJ06xIthCgoiF2TFIaT8mBQo0oxpWKTaGMmwNhKj01EQJAMU6/EU7+iMoIoAi1q
 H6NmEvmDU9c/xrLR+UKccO0jNYR161CojOb6+kXNwzW8v+gJGV48slEK4ywtOsvDSTwF
 ShGIkJI4hAk4d9Hastp2BfkiTjouVQCe4jHNt7SC0mYNEypZIbK37YSkGXzrvqFhBj8p dQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35200dhxtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 19:09:37 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ07Doq010147;
        Thu, 26 Nov 2020 00:09:36 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 35133p3hpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 00:09:36 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ09ahJ64094642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 00:09:36 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E778AC05E;
        Thu, 26 Nov 2020 00:09:36 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAAB9AC064;
        Thu, 26 Nov 2020 00:09:35 +0000 (GMT)
Received: from linux-i8xm.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 00:09:35 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     ljp@linux.ibm.com, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net v3 3/9] ibmvnic: avoid memset null scrq msgs
Date:   Wed, 25 Nov 2020 18:04:26 -0600
Message-Id: <20201126000432.29897-4-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126000432.29897-1-drt@linux.ibm.com>
References: <20201126000432.29897-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=3 mlxscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

scrq->msgs could be NULL during device reset, causing Linux to crash.
So, check before memset scrq->msgs.

Fixes: c8b2ad0a4a901 ("ibmvnic: Sanitize entire SCRQ buffer on reset")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d5a927bb4954..b08f95017825 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2845,15 +2845,26 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
 {
 	int rc;
 
+	if (!scrq) {
+		netdev_dbg(adapter->netdev,
+			   "Invalid scrq reset. irq (%d) or msgs (%p).\n",
+			   scrq->irq, scrq->msgs);
+		return -EINVAL;
+	}
+
 	if (scrq->irq) {
 		free_irq(scrq->irq, scrq);
 		irq_dispose_mapping(scrq->irq);
 		scrq->irq = 0;
 	}
-
-	memset(scrq->msgs, 0, 4 * PAGE_SIZE);
-	atomic_set(&scrq->used, 0);
-	scrq->cur = 0;
+	if (scrq->msgs) {
+		memset(scrq->msgs, 0, 4 * PAGE_SIZE);
+		atomic_set(&scrq->used, 0);
+		scrq->cur = 0;
+	} else {
+		netdev_dbg(adapter->netdev, "Invalid scrq reset\n");
+		return -EINVAL;
+	}
 
 	rc = h_reg_sub_crq(adapter->vdev->unit_address, scrq->msg_token,
 			   4 * PAGE_SIZE, &scrq->crq_num, &scrq->hw_irq);
-- 
2.26.2

