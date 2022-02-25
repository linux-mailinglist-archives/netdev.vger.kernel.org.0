Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF81C4C3E55
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbiBYGYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbiBYGYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:24:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7439923584B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:24:06 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P5Md9d010489
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Yu6de+LDPG+VfgtOuURi+g6BR0jdQmVyLNF81hU7zsc=;
 b=lCt+wwEnrJaehGD6ziBMy4yeoEfuzBnYjx8icTQ62qNXj25hY7euwMgaE9IjLl+jwt4m
 /h8XFUyo9Myqnnc//Db9O+addXlcGjyckb+ZaTHglLWfrq1ntRfqqZC10hRrIrFCEwuA
 BoW44DwgCGIrpSqXAZ9Oyp4HZjpUZsH4HEMshsXxvLs3ni14iwWLZaJqvJBtBxmsguRk
 cCibBRmgxkeMkSeIixa8WrIj3DdvmgrM2yplmUpAYx9+mqBnXRsovbKpcEnhyquyg0mf
 xnyXpYCNYhagZK8cijolzJMwBAqmS+019X1pjGOW944tl54c9Tzav5AFTMeVN9qMiWz+ SQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edq0kcyka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:06 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P6MJEr002405
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:04 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 3ear6bh0ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:04 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P6O3P336766160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:24:03 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9738136060;
        Fri, 25 Feb 2022 06:24:03 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC24E136051;
        Fri, 25 Feb 2022 06:24:02 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 06:24:02 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 2/8] ibmvnic: initialize rc before completing wait
Date:   Thu, 24 Feb 2022 22:23:52 -0800
Message-Id: <20220225062358.1435652-3-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225062358.1435652-1-sukadev@linux.ibm.com>
References: <20220225062358.1435652-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fa0_-BTjsEKNTMfzkqS2WGzOv1Bb0Iy6
X-Proofpoint-GUID: fa0_-BTjsEKNTMfzkqS2WGzOv1Bb0Iy6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_05,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 spamscore=0 mlxlogscore=978 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202250030
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

