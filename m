Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C942DA279
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503562AbgLNVUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:20:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503389AbgLNVUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:20:14 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEL2KPE030290
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 16:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sHfdJcD0HtWtLtVy2YpmetkRLVIhAH7D2Td5mc5nE7A=;
 b=TvDozhzkGRfgqJ2E8EFtQRQxlpt/Fz8YABuOSasZ3s83k/q2X56QbxCIwcs3elPKeT8y
 t5G8wEv9xwx1+HWurLe4znjRqxIKx6IC3o9eYrXwup0J5I2n6XZOPx7wCySJ2qMGpLT6
 jfVNkI5SWLCKAlb9LOiR3unYhdo4guJzs+JcGdqQT9jdwe0PG2N/6b1QzQR1/xKaUF25
 JyEzdZOtZogtothLrgbZe04vnCePgzeE8lINxwOmoQxFaZmj2aVP13X4YbLObXnSZj94
 bA80bWaQZRX1/uXpCb1rSFiZLPy4B1N7aiIONI5sCM+kKFX3ykVUFQ49ogeXKYgTYiPY Ag== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35edn1uqp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 16:19:33 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BELHvnX006647
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:32 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 35cng92rs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:32 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BELJWsm27656656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:19:32 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F28BC2805A;
        Mon, 14 Dec 2020 21:19:31 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AABD828059;
        Mon, 14 Dec 2020 21:19:31 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.237.30])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 21:19:31 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 2/3] use __netdev_notify_peers in ibmvnic
Date:   Mon, 14 Dec 2020 15:19:29 -0600
Message-Id: <20201214211930.80778-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201214211930.80778-1-ljp@linux.ibm.com>
References: <20201214211930.80778-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_11:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start to use the lockless version of netdev_notify_peers.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a2191392ca4f..f302504faa8a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2171,10 +2171,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		napi_schedule(&adapter->napi[i]);
 
 	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
-	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
-		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
-		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
-	}
+	    adapter->reset_reason == VNIC_RESET_MOBILITY)
+		__netdev_notify_peers(netdev);
 
 	rc = 0;
 
@@ -2249,8 +2247,7 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 		goto out;
 	}
 
-	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
-	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+	__netdev_notify_peers(netdev);
 out:
 	/* restore adapter state if reset failed */
 	if (rc)
-- 
2.23.0

