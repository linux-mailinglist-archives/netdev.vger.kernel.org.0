Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0AB257F2B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgHaRAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:00:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbgHaRAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 13:00:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGrAfg009404
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 13:00:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=bZGJXJ5aC/R6G/cQtx9kS3UPqigIaMeu8ClCJiK9DCw=;
 b=V9Vm/sOiAtRyyVVlmh2Xm6qZXjGHh9/LXP+EDcnnniQROMwBpHx0XUel/UQL3ky3i86o
 JnedtWQHlI9q4nEn13hMuzpEtqyl0BrRHkJZSwCqTOsiX5xJKaJqVnR09VhbgZ78oid+
 eDfCMiabQ2slLzMdx55QTEGjBc31U2b42KYousZmt39UseM+aIhVNMelN9EHg4jUkxav
 oKwVfOAOnEdqgIrLxoEVerHPAQelZhfdacFaXANG/oZFyJxTWsBiKL2YNpuR75Rba6/O
 lt5ZGK6z29HEZCZnh+RU8EbyA7LYyxoNT6pdAeEfR4gL5BPEf1VoBlzhkd5T2whABLc6 sw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33954c83gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 13:00:03 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VGxJxB006914
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 17:00:02 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 337en95vsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 17:00:02 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VH019Z36569450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:00:01 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACE17124075;
        Mon, 31 Aug 2020 17:00:01 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E1E7124052;
        Mon, 31 Aug 2020 17:00:01 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 17:00:00 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: Harden device Command Response Queue handshake
Date:   Mon, 31 Aug 2020 11:59:57 -0500
Message-Id: <1598893197-14450-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_08:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 suspectscore=1 priorityscore=1501 mlxlogscore=999 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, the device or firmware may be busy when the
driver attempts to perform the CRQ initialization handshake.
If the partner is busy, the hypervisor will return the H_CLOSED
return code. The aim of this patch is that, if the device is not
ready, to query the device a number of times, with a small wait
time in between queries. If all initialization requests fail,
the driver will remain in a dormant state, awaiting a signal
from the device that it is ready for operation.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 86a83e5..9943586 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3566,14 +3566,31 @@ static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
 
 static int ibmvnic_send_crq_init(struct ibmvnic_adapter *adapter)
 {
+	struct device *dev = &adapter->vdev->dev;
 	union ibmvnic_crq crq;
+	int retries = 100;
+	int rc;
 
 	memset(&crq, 0, sizeof(crq));
 	crq.generic.first = IBMVNIC_CRQ_INIT_CMD;
 	crq.generic.cmd = IBMVNIC_CRQ_INIT;
 	netdev_dbg(adapter->netdev, "Sending CRQ init\n");
 
-	return ibmvnic_send_crq(adapter, &crq);
+	do {
+		rc = ibmvnic_send_crq(adapter, &crq);
+		if (rc != H_CLOSED)
+			break;
+		retries--;
+		msleep(50);
+
+	} while (retries > 0);
+
+	if (rc) {
+		dev_err(dev, "Failed to send init request, rc = %d\n", rc);
+		return rc;
+	}
+
+	return 0;
 }
 
 static int send_version_xchg(struct ibmvnic_adapter *adapter)
-- 
1.8.3.1

