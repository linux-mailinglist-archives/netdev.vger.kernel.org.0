Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3822B2BB952
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgKTWlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729147AbgKTWlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:05 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMW1WW131798
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oOSym+M0ILKMfES1qQmdXIdpZuQB+QR04gJqICcE+gM=;
 b=f+TSYSjFOY7hNmZpEZC6HB/6GeiyU7NUXOprRsbfhPd/kRo1e0hjBftasZrhAf5J3p5D
 qgPH9pbBDRp7oMkWuMo4Vk+ND8hhs788l/4MdWr9ueswnFoofZpc5qEAuA7gf1G8JwhW
 soohu/N8mc0fwHClPXkCY+LVN5BXg+Sx2bGKxDqo2ZhxHzqyUz86AZ9eSgaWrSY7cMiL
 g9jIU0brwQGAs9EfoH8zYqbDL3HIF+LF4jJb9itMBTEkUTw4JNoIIyLDduk+Cv59ykIi
 rfTit5bWHg0p+Ih4VMUhgH4I3D+22Aio/gj5w6dGOO+wzg2Ip1l8S1Qyr0np7HIezI2F JA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xm9e3jcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:05 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMcX5T027026
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:04 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 34t6va68av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:04 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMesTE11076196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:54 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F00E56E050;
        Fri, 20 Nov 2020 22:41:02 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E4716E053;
        Fri, 20 Nov 2020 22:41:02 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:41:02 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 14/15] ibmvnic: enhance resetting status check during module exit
Date:   Fri, 20 Nov 2020 16:40:48 -0600
Message-Id: <20201120224049.46933-15-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=936 mlxscore=0
 phishscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussion with Sukadev Bhattiprolu and Dany Madden,
we believe that checking adapter->resetting bit is preferred
since RESETTING state flag is not as strict as resetting bit.
RESETTING state flag is removed since it is verbose now.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 drivers/net/ethernet/ibm/ibmvnic.h | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index dda2d4bb9b40..b1519e92ccce 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2251,7 +2251,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 		if (!saved_state) {
 			reset_state = adapter->state;
-			adapter->state = VNIC_RESETTING;
 			saved_state = true;
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
@@ -5362,7 +5361,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
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

