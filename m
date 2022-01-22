Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F2B496983
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiAVC7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:59:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230127AbiAVC72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 21:59:28 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20M1fvkT003905
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=faw7dETCcS/skdReFmupfDoZB+Cp3EQYgePHRyUXNEE=;
 b=Oqtn1GMkziAkFz4x0890eEr5R/8s8ap5LerpQaW8iqFf3FArSwphsXeh8I1RF1z3Bt0F
 IgK+VLY1Ce+TZP151LgZIJDkrFvZiQpS8SEN1vGeM/HDehXDhuzD0ow2bh1yJ1PJMcg7
 EKW8PXPAv3BHXCkj9nsWbkXfCokb4KSTNfwxvZlt7wIj1u43XfMQr+DQkdCParorrCGG
 YRXLy6KZ7VpbbPe7riwzbfQq0d57QKyLs8tuISEf/oiIliMt08V4JatzMxJgVi+iQKzW
 URSG4P2xNkkJNB752D39Up3PAg8vwDDI+ZLKpeeDd5PwPvm/LE2pEta5CzRktQVCtx+t WQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dr8g1rx60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:26 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20M2wDmj027086
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:25 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3dr9j8g100-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:25 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20M2xO9a7406552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Jan 2022 02:59:24 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A1222805A;
        Sat, 22 Jan 2022 02:59:24 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB0C428060;
        Sat, 22 Jan 2022 02:59:23 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.135.77])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 22 Jan 2022 02:59:23 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 3/4] ibmvnic: don't spin in tasklet
Date:   Fri, 21 Jan 2022 18:59:20 -0800
Message-Id: <20220122025921.199446-3-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220122025921.199446-1-sukadev@linux.ibm.com>
References: <20220122025921.199446-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7tU7GqqQhj_WxIA8qVRZ6cH9BD-enICY
X-Proofpoint-ORIG-GUID: 7tU7GqqQhj_WxIA8qVRZ6cH9BD-enICY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=998
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201220010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ibmvnic_tasklet() continuously spins waiting for responses to all
capability requests. It does this to avoid encountering an error
during initialization of the vnic. However if there is a bug in the
VIOS and we do not receive a response to one or more queries the
tasklet ends up spinning continuously leading to hard lock ups.

If we fail to receive a message from the VIOS it is reasonable to
timeout the login attempt rather than spin indefinitely in the tasklet.

Fixes: 249168ad07cd ("ibmvnic: Make CRQ interrupt tasklet wait for all capabilities crqs")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index acd488310bbc..682a440151a8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5491,12 +5491,6 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 			ibmvnic_handle_crq(crq, adapter);
 			crq->generic.first = 0;
 		}
-
-		/* remain in tasklet until all
-		 * capabilities responses are received
-		 */
-		if (!adapter->wait_capability)
-			done = true;
 	}
 	/* if capabilities CRQ's were sent in this tasklet, the following
 	 * tasklet must wait until all responses are received
-- 
2.27.0

