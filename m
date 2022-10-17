Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3139A60129D
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiJQPR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJQPR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:17:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53AA11A13
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 08:17:25 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HEcxRV010650
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Y/wgmuHjDyglgFk3iKaAIrY+vHFEnwBw7rGk7Axf5dw=;
 b=HXxv2hWhzwcY0YqFE9nBp1pXene0LLq0s98rFm/yf/d8fzNgyGopxWJPDkZuzJAoRGJq
 D2PqEmILKAhR5dvsLp9+tSnS+BPn2T49ZkoBX855guRP97IJo8qPEudQ8QzWkJuzRqzx
 uzXfzwRq4wJHwp7clw7ZjMIYbzrxD8EStb5DoJLxkclHOzIH/h6YkupN8rJ9CUR4Oth5
 LJ++PcQjq2s3b95L5T0P7IKfnnbOYOsbn75o5S/0b7acb/9eezWoeLnk4LNVMtTJSeY4
 0kI+x283rxCtQQKgskcCgKzTyffwsEGMrYpnR5bObF/+Tn4Q9IREi8UXGRCC52w+tVUB Vw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86g66g2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:17:24 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29HF6I9C024826
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:17:23 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3k7mg9fqb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:17:23 +0000
Received: from smtpav03.dal12v.mail.ibm.com ([9.208.128.129])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29HFHJL540567052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 15:17:19 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4918158056;
        Mon, 17 Oct 2022 15:17:20 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D461758060;
        Mon, 17 Oct 2022 15:17:19 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.6.192])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 15:17:19 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     nick.child@ibm.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: Free rwi on reset success
Date:   Mon, 17 Oct 2022 10:15:16 -0500
Message-Id: <20221017151516.45430-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wp1PPq_wGlHWv-HUZ5g-iDvYlH_4c4F-
X-Proofpoint-ORIG-GUID: wp1PPq_wGlHWv-HUZ5g-iDvYlH_4c4F-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_12,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 mlxlogscore=999 bulkscore=0 impostorscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free the rwi structure in the event that the last rwi in the list
processed successfully. The logic in commit 4f408e1fa6e1 ("ibmvnic:
retry reset if there are no other resets") introduces an issue that
results in a 32 byte memory leak whenever the last rwi in the list
gets processed.

Fixes: 4f408e1fa6e1 ("ibmvnic: retry reset if there are no other resets")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 65dbfbec487a..9282381a438f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3007,19 +3007,19 @@ static void __ibmvnic_reset(struct work_struct *work)
 		rwi = get_next_rwi(adapter);
 
 		/*
-		 * If there is another reset queued, free the previous rwi
-		 * and process the new reset even if previous reset failed
-		 * (the previous reset could have failed because of a fail
-		 * over for instance, so process the fail over).
-		 *
 		 * If there are no resets queued and the previous reset failed,
 		 * the adapter would be in an undefined state. So retry the
 		 * previous reset as a hard reset.
+		 *
+		 * Else, free the previous rwi and, if there is another reset
+		 * queued, process the new reset even if previous reset failed
+		 * (the previous reset could have failed because of a fail
+		 * over for instance, so process the fail over).
 		 */
-		if (rwi)
-			kfree(tmprwi);
-		else if (rc)
+		if (!rwi && rc)
 			rwi = tmprwi;
+		else
+			kfree(tmprwi);
 
 		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
 			    rwi->reset_reason == VNIC_RESET_MOBILITY || rc))
-- 
2.31.1

