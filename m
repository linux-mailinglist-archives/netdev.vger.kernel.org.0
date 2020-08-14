Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553F124460A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 09:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgHNH7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 03:59:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726784AbgHNH7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 03:59:32 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07E7W7fV095772;
        Fri, 14 Aug 2020 03:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=O9IIOQ1K6JePfyVHDRPg/tI1B+Vg13ObJD4Fn8XH28w=;
 b=E1RMJIH6yJJkONzRV9VkYM75HOmEwcqaGnk9q45EVpqJcRCQ5QTnnUUCwkxbqMD+Niyt
 2onjm+Q7GH7+sBGjKQlSGAWZeZkKJzing+1pan5FXw+K6rrg9fj9qpIdpkD6w7kL6wtd
 MEAahBmV/JXMybS/8orO7C3mJ86JdQgfgegtHFeKZgq/pK+ItbR2ivOkOywiL7UPO2m5
 2GLEicu6j0BJIr8Mf3sO2Tqyi0zy4nWFYOaQDHiNDvqnduP2+bD5kaSYiH/HIYSs8vyr
 Tnq2egsyEWs37Bu5ZaXaFxpdFa3LAKSp+0Dx0xBfnF7EcEh6M69eLiDrgBNbYOjcuBDr dA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w706rsbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 03:59:25 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07E7u46c029858;
        Fri, 14 Aug 2020 07:59:24 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 32skp9rfng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 07:59:24 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07E7xOBX49218040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 07:59:24 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19CADAC059;
        Fri, 14 Aug 2020 07:59:24 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE6FEAC05E;
        Fri, 14 Aug 2020 07:59:23 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.68.30])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 07:59:23 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 3/5] ibmvnic: improve ibmvnic_init and ibmvnic_reset_init
Date:   Fri, 14 Aug 2020 02:59:19 -0500
Message-Id: <20200814075921.88745-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200814075921.88745-1-ljp@linux.ibm.com>
References: <20200814075921.88745-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_02:2020-08-13,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When H_SEND_CRQ command returns with H_CLOSED, it means the
server's CRQ is not ready yet. Instead of resetting immediately,
we wait for the server to launch passive init.
ibmvnic_init() and ibmvnic_reset_init() should also return the
error code from ibmvnic_send_crq_init() call.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 50e86e65961e..e366fd42a8c4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3568,8 +3568,7 @@ static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
 	if (rc) {
 		if (rc == H_CLOSED) {
 			dev_warn(dev, "CRQ Queue closed\n");
-			if (test_bit(0, &adapter->resetting))
-				ibmvnic_reset(adapter, VNIC_RESET_FATAL);
+			/* do not reset, report the fail, wait for passive init from server */
 		}
 
 		dev_warn(dev, "Send error (rc=%d)\n", rc);
@@ -4985,7 +4984,12 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 
 	reinit_completion(&adapter->init_done);
 	adapter->init_done_rc = 0;
-	ibmvnic_send_crq_init(adapter);
+	rc = ibmvnic_send_crq_init(adapter);
+	if (rc) {
+		dev_err(dev, "%s: Send crq init failed with error %d\n", __func__, rc);
+		return rc;
+	}
+
 	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
 		dev_err(dev, "Initialization sequence timed out\n");
 		return -1;
@@ -5039,7 +5043,12 @@ static int ibmvnic_init(struct ibmvnic_adapter *adapter)
 	adapter->from_passive_init = false;
 
 	adapter->init_done_rc = 0;
-	ibmvnic_send_crq_init(adapter);
+	rc = ibmvnic_send_crq_init(adapter);
+	if (rc) {
+		dev_err(dev, "%s: Send crq init failed with error %d\n", __func__, rc);
+		return rc;
+	}
+
 	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
 		dev_err(dev, "Initialization sequence timed out\n");
 		return -1;
-- 
2.23.0

