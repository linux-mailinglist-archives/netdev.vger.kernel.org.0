Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3130E2F3857
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392196AbhALSPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:15:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392468AbhALSP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:15:29 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CICn7W058218
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=x9nLvcCcATPiWc8GCmte9Mken5FdlFO8aFeDAIzywCI=;
 b=TEV7vqYPXN0HySO2W2up0v/mTVbT/4S/HtUiFOHnAlj16gfQFpxt23Hw7mt7nm8zUEg+
 A5D4RgM2HqF8DlyAYMfHw2UunOYnIdpxsbvJz4zhVGkFKKBv41bHiq0KctEO645hLZSp
 e2pfMGGLtlgv2RUqWkSqzkOQUtcf/mG7HO6wwMunWLDRLMSBGUxCL772aPi9592ETx7H
 PFyKXUSBbzp3b8UVAYrbNpFxrPNcH0FZVzAu+pMac+e0m5Wi3MymgAvihCnDyF9ntJCa
 aB11lJIUA7IflDOfBq3baq+qWBDFxbgAOiTU3AO1sXenXSJORueiXsLBkt9XgS77BXD8 2A== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361gugg1m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:47 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CICCXH008162
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:47 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 35y448yws8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:47 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIEkp637945618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:14:46 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0B0FB206C;
        Tue, 12 Jan 2021 18:14:46 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF51BB2066;
        Tue, 12 Jan 2021 18:14:45 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.179.93])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 18:14:45 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com
Subject: [PATCH net-next v2 4/7] ibmvnic: switch order of checks in ibmvnic_reset
Date:   Tue, 12 Jan 2021 10:14:38 -0800
Message-Id: <20210112181441.206545-5-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112181441.206545-1-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We check separately for REMOVING and PROBING in ibmvnic_reset().
Switch the order of checks to facilitate better locking  when
checking for REMOVING/REMOVED state.

Fixes: 6a2fb0e99f9c ("ibmvnic: driver initialization for kdump/kexec")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d1c2aaed1478..ad551418ac63 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2437,6 +2437,12 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	struct net_device *netdev = adapter->netdev;
 	int ret;
 
+	if (adapter->state == VNIC_PROBING) {
+		netdev_warn(netdev, "Adapter reset during probe\n");
+		ret = adapter->init_done_rc = EAGAIN;
+		goto err;
+	}
+
 	/*
 	 * If failover is pending don't schedule any other reset.
 	 * Instead let the failover complete. If there is already a
@@ -2451,12 +2457,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
-	if (adapter->state == VNIC_PROBING) {
-		netdev_warn(netdev, "Adapter reset during probe\n");
-		ret = adapter->init_done_rc = EAGAIN;
-		goto err;
-	}
-
 	/* If we just received a transport event, clear
 	 * any pending resets and add just this reset.
 	 */
-- 
2.26.2

