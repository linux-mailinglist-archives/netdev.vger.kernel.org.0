Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B404C3CEE
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 05:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbiBYEKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 23:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbiBYEKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 23:10:20 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE3D25A95D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 20:09:49 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P16Goa008490
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Yu6de+LDPG+VfgtOuURi+g6BR0jdQmVyLNF81hU7zsc=;
 b=cpDHAgaOND+aXxJcbVsNExCO67fbzueXtpborDOt00PQq7M4KFCcYRiuR5PVowVihYcr
 E1YYthfzR1HoEG8MdT11LW7s+/Q3NKZ52IsPLUe2MXhNdLho/ZL1xuM51/eMvIdD0H2O
 B4JpgWWcW7H2wguHndpvLaiEMOxsdRW+sVxlTY1GzxQs/mMOEME0VTk3t3iPbd7Adad4
 2pEC6IVVHPvi7IKWJxaTLy4fDTI2e+Wvmnn3aY+w0/x025soU5lPCwGGZc+fQLtVAaCa
 Zz5y3tC9hR6Zqpk7bH7BZiI0A/aHr5v/HtYt/ASB8+6VEvpWakMNfg3YLraZxyaG4yoU iw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eds7a7ca5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:48 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P42ZMO007496
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:47 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3ear6ccycj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:47 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P49k6u30081448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 04:09:46 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35308BE04F;
        Fri, 25 Feb 2022 04:09:46 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08D60BE051;
        Fri, 25 Feb 2022 04:09:45 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 04:09:44 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-internal v2 2/8] ibmvnic: initialize rc before completing wait
Date:   Thu, 24 Feb 2022 20:09:35 -0800
Message-Id: <20220225040941.1429630-3-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225040941.1429630-1-sukadev@linux.ibm.com>
References: <20220225040941.1429630-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tz1W8UiScJdExLH69N-MRoVhE7Hx912E
X-Proofpoint-ORIG-GUID: Tz1W8UiScJdExLH69N-MRoVhE7Hx912E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_01,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250020
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should initialize ->init_done_rc before calling complete(). Otherwise
the waiting thread may see ->init_done_rc as 0 before we have updated it
and may assume that the CRQ was successful.

Fixes: 6b278c0cb378 ("ibmvnic delay complete()")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 27a698171d67..830f3e45ec65 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5319,9 +5319,9 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			}
 
 			if (!completion_done(&adapter->init_done)) {
-				complete(&adapter->init_done);
 				if (!adapter->init_done_rc)
 					adapter->init_done_rc = -EAGAIN;
+				complete(&adapter->init_done);
 			}
 
 			break;
-- 
2.27.0

