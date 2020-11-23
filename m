Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF712C148D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgKWTfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:35:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42404 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728930AbgKWTfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:35:53 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJVVpj007858
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QtRe39ZIe8XBzt+kgpOqeWGDIh3RxFnzton4Acx8K08=;
 b=SPhGI0Rx9OlNQaetOdkf/UiOLy67yAhFs1yyv3EHZWzmJS0/eFA1V5MTot2z3OvF7/Yj
 KM2QMb/FPc5evmf1NAavS7Cw6jgOWoEZU41q90pN/cP+iNRZXTYSpFkoiTAaDesGZ53Z
 5PFvecvNuhGXqLav5SP9dAweiF0DNeQFpgb4QzYz2Aa+NkoRt2aAFrp+jQaqojqbiq0J
 PyIIr2cUTIAdld1GsCTgK2tHfJK4OvT+ZfBtZ7sA1LSa30aUNs1PzaCeiKkanC5jHvy3
 ndmcXusg/Ai1WOjarz/J3ySEbpndC6iFJ05W6xbdG/J6WgAA9sZk18sc/RCrcRK5Wzng VA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtt47v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:35:51 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJWbol018867
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:35:50 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 34xth8x45d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:35:50 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANJZnwv17236614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 19:35:49 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F1CBB2065;
        Mon, 23 Nov 2020 19:35:49 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A82CB2064;
        Mon, 23 Nov 2020 19:35:49 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.185.230])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 19:35:48 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2 3/3] ibmvnic: enhance resetting status check during module exit
Date:   Mon, 23 Nov 2020 13:35:47 -0600
Message-Id: <20201123193547.57225-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201123193547.57225-1-ljp@linux.ibm.com>
References: <20201123193547.57225-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 malwarescore=0 mlxlogscore=958 suspectscore=1
 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussion with Sukadev Bhattiprolu and Dany Madden,
we believe that checking adapter->resetting bit is preferred
since RESETTING state flag is not as strict as resetting bit.
RESETTING state flag is removed since it is verbose now.

Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during device reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: add fix tag

 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 drivers/net/ethernet/ibm/ibmvnic.h | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 91b7a383debf..5cb4cfabe2de 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2251,7 +2251,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 		if (!saved_state) {
 			reset_state = adapter->state;
-			adapter->state = VNIC_RESETTING;
 			saved_state = true;
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
@@ -5357,7 +5356,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->state_lock, flags);
-	if (adapter->state == VNIC_RESETTING) {
+	if (test_bit(0, &adapter->resetting)) {
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 		return -EBUSY;
 	}
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index d15866cbc2a6..950f439bed32 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -943,8 +943,7 @@ enum vnic_state {VNIC_PROBING = 1,
 		 VNIC_CLOSING,
 		 VNIC_CLOSED,
 		 VNIC_REMOVING,
-		 VNIC_REMOVED,
-		 VNIC_RESETTING};
+		 VNIC_REMOVED};
 
 enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
 			   VNIC_RESET_MOBILITY,
-- 
2.23.0

