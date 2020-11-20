Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1472BB955
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgKTWlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729115AbgKTWlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:03 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMXtsW105695
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rvOAKSivBjD0fDxH/pw5qkXM8kmGCsA+tJOY35Vbmwc=;
 b=WJITLgbEU/YjE+Bm2nZIgS3rFfwRwSVlnNATYZD+eH8Gm0xI43mz3ini/qeQrImmQLob
 vHtt8KvrwInH3smpt1YCvq4vCm4gike32i0/EeVdLlST9mFQlQg3ATCTHakKv12e3h4H
 zQFUyjNq7EKiEnpff5glTEBFfdNP2QALIxo7dQxKiL9Q5T4NRLcFVDEQkqpdIo9a6Swk
 Cw3oskgeVcCdgaPAKoVyb+jByEHS//oH3M6U26GGnJ+3jPPYTlrQmuf+H9Nmg+LZYoie
 HCE/IjwTJ234RZgZ3NhVB6msAH014qHmPBR1EwOOWnoRrVPNqs0L6n/ct6gRNXdteYQx Uw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xd1m366a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:02 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMc21I015141
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:01 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 34t6v9ss9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:01 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMf0Zm7668244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:41:00 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0023E6E053;
        Fri, 20 Nov 2020 22:41:00 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70D596E05F;
        Fri, 20 Nov 2020 22:40:59 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:59 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 11/15] ibmvnic: reduce wait for completion time
Date:   Fri, 20 Nov 2020 16:40:45 -0600
Message-Id: <20201120224049.46933-12-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 clxscore=1015 suspectscore=1 bulkscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

Reduce the wait time for Command Response Queue response from 30 seconds
to 20 seconds, as recommended by VIOS and Power Hypervisor teams.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 252af4ab6468..47446e5f8ec5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -836,7 +836,7 @@ static void release_napi(struct ibmvnic_adapter *adapter)
 static int ibmvnic_login(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	int retry_count = 0;
 	int retries = 10;
 	bool retry;
@@ -940,7 +940,7 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 {
 	struct net_device *netdev = adapter->netdev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	union ibmvnic_crq crq;
 	bool resend;
 	int rc;
@@ -5164,7 +5164,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 {
 	struct device *dev = &adapter->vdev->dev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	u64 old_num_rx_queues, old_num_tx_queues;
 	int rc;
 
-- 
2.23.0

