Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898ED2EEDC3
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbhAHHON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:14:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726474AbhAHHON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 02:14:13 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10873BV7127612
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 02:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zUPpMqrcfeQ6kYAe7PjNrCONlmchucD8YqtN3CK7V4E=;
 b=j8VguAAqFCBCaLLEB5LS1S4Y06NmqWCtQqtcuNWwG3DLTAcfYU0FXQwwh51NGtvRhrPs
 Vrs1UMhXmllFuDPmi5DoXLcxVSwb5x6RtpuN9Bx8br4U9vPjdkG9xjh8wDQq7Gv7/Urp
 z65ZKi41IN+RbnrGxO0NoSqOsirlBxCEy8L6Yl8fpDVL6w7kRFRGpiJcng/L5lYDriz7
 z3smmowlBSYaiQ6kxUkfrC7Eqhv846EoRzArCSO7pqes2PoVr1Blzidr3Y+ghSVyia+u
 ZxdrQdL60JFobxCXftVEeVUy20tGPUsXD/QOOZZ9gsHOGY3m0BnUERxfxRE7ScUvpV7p Uw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35xjfarjnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:13:31 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1086qvKR008827
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 07:12:44 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 35tgf9j4gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 07:12:44 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1087Ch4020578654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jan 2021 07:12:43 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1443478064;
        Fri,  8 Jan 2021 07:12:43 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BACC7805C;
        Fri,  8 Jan 2021 07:12:42 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.139.161])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  8 Jan 2021 07:12:42 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        sukadev@linux.ibm.com
Subject: [PATCH 4/7] ibmvnic: switch order of checks in ibmvnic_reset
Date:   Thu,  7 Jan 2021 23:12:33 -0800
Message-Id: <20210108071236.123769-5-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108071236.123769-1-sukadev@linux.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_04:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080036
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

