Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14802BB94D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgKTWk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729024AbgKTWk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:56 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMXfxR195245
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mvYSyqbFjmsWWbg77lGqV59YDDT6zg4d7uUrG+uId2k=;
 b=PV88cura6zPxSs06zRQLsx5Qh1OMvwD1ayrbrkfK7SdacFE9AFkSW3HHlneCfn23nc93
 zblEfmro2iTNCHx+R9MP02HUdqjFdXTKUeY+6qThjdIn+pARZwfkROk0kOwOPyBVX6hG
 0Ojge+MwaIiL6BW2Um3FDbI3xM3ZkhJzs1lR0dLY5LYnjXdeSzhyRbCCba0PckeK0nY4
 paSH4sKv7OB8SXt4zUPH/R4vESHIzHAz2zchb2Oj393wJQr5D2F+6Uc++BMrZtraVK8m
 duwgYN9so5yl/8tFZp9zXlAvTMsU9XPKJCIz9Ss0o/k12fOc+ol17AgZkSHCB8MONhic Hw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34x0jpj3j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:55 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMcWhR027016
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:55 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 34t6va68a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMerBF11076252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:53 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A3446E052;
        Fri, 20 Nov 2020 22:40:53 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDFC06E053;
        Fri, 20 Nov 2020 22:40:52 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:52 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 03/15] ibmvnic: stop free_all_rwi on failed reset
Date:   Fri, 20 Nov 2020 16:40:37 -0600
Message-Id: <20201120224049.46933-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 suspectscore=3 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

When ibmvnic fails to reset, it breaks out of the reset loop and frees
all of the remaining resets from the workqueue. Doing so prevents the
adapter from recovering if no reset is scheduled after that. Instead,
have the driver continue to process resets on the workqueue.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 82074e503ba9..9e097c05e249 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2291,9 +2291,9 @@ static void __ibmvnic_reset(struct work_struct *work)
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
 
@@ -2307,11 +2307,6 @@ static void __ibmvnic_reset(struct work_struct *work)
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
2.23.0

