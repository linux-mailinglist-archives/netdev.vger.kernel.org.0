Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A802C4BD6
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgKZAJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:09:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728764AbgKZAJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:09:41 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ04O4o131415;
        Wed, 25 Nov 2020 19:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hS/O9oko7cMPTPnm8CEazRg2cfwhVlziRShqKg7dlj0=;
 b=ADFpXKQ/xNTh52P7n4xP9vWZr1MwQtTIjmPFkdaIcGiJSdDTZfgWvzx2H5Kuw1ygJkS9
 kcEoH/b/TQryzJVksKV9qOz0fHXibcwcIbCTaJfO9WOk+SpENH9UuvG/fvLfJAAhwW92
 xFlKiBAE6Z+8u+iK7Iz/6F0Kec4S5tYfQhZvu6QWlb45jpsDZL79g8yanT3rK/TamiQw
 HvzL6GrZ5Ktfn6E7lsJFT0UHtdrZJ0kUjKnfYC6Tfz2qJ1sld8HHLrsNJKm6bjMnQ7Hj
 7jh8nbcDJ3k3T1GG8K9NuQHKZg31nqHlkCvANB9WWAygHli3pEuz7We1x80+H2TU24iX sQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351suemd9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 19:09:37 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ07bXt027081;
        Thu, 26 Nov 2020 00:09:36 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 34xth9mann-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 00:09:36 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ09ZaP721658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 00:09:35 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F569AC05B;
        Thu, 26 Nov 2020 00:09:35 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 402B0AC059;
        Thu, 26 Nov 2020 00:09:35 +0000 (GMT)
Received: from linux-i8xm.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 00:09:35 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     ljp@linux.ibm.com, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net v3 2/9] ibmvnic: stop free_all_rwi on failed reset
Date:   Wed, 25 Nov 2020 18:04:25 -0600
Message-Id: <20201126000432.29897-3-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126000432.29897-1-drt@linux.ibm.com>
References: <20201126000432.29897-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=3 phishscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ibmvnic fails to reset, it breaks out of the reset loop and frees
all of the remaining resets from the workqueue. Doing so prevents the
adapter from recovering if no reset is scheduled after that. Instead,
have the driver continue to process resets on the workqueue.

Remove the no longer need free_all_rwi().

Fixes: ed651a10875f1 ("ibmvnic: Updated reset handling")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index dcb23015b6b4..d5a927bb4954 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2173,17 +2173,6 @@ static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
 	return rwi;
 }
 
-static void free_all_rwi(struct ibmvnic_adapter *adapter)
-{
-	struct ibmvnic_rwi *rwi;
-
-	rwi = get_next_rwi(adapter);
-	while (rwi) {
-		kfree(rwi);
-		rwi = get_next_rwi(adapter);
-	}
-}
-
 static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_rwi *rwi;
@@ -2253,9 +2242,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 			else
 				adapter->state = reset_state;
 			rc = 0;
-		} else if (rc && rc != IBMVNIC_INIT_FAILED &&
-		    !adapter->force_reset_recovery)
-			break;
+		}
+		if (rc)
+			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
 
 		rwi = get_next_rwi(adapter);
 
@@ -2269,11 +2258,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 		complete(&adapter->reset_done);
 	}
 
-	if (rc) {
-		netdev_dbg(adapter->netdev, "Reset failed\n");
-		free_all_rwi(adapter);
-	}
-
 	clear_bit_unlock(0, &adapter->resetting);
 }
 
-- 
2.26.2

