Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9F64C3E5B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbiBYGY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbiBYGYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:24:53 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83C626929C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:24:21 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P4Svac008163
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EBTvMMRqxkQwn1BSA+RmW5yfo50w60wFArgqMd8Ur/I=;
 b=ep1mtWyVyDDP1XYdrB+ijtilH2EkL3MKChMCzAfj3VUa3PY6n2isnSZ/ranXlknhqCMu
 IgBplvIjQhwm+HEJMf6DmnTDJouAL7QZcHtYKahEnK9Gkj67wGNkP3siUdRjPmEPtC/v
 ZQy2xNzTWcziCa2HD+rZGgqBqvlUuM4msnSrI/Aj4Qt3rXlwTE2ZLv8b8+Uj661WRxX0
 HAVAq128l03mf37rbwLY7IS7dMUOCXJD3xXXe1o/pvie3QUmaa6j5Pgp1QtoKD+q2MxB
 VvOXSgk4Zqp8w6/FqBUjLgAB+rOPLBtK4wfw5PlJQaR7jj6tFsaEyjvw4CZ7rbiU52g9 ng== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eds7a9rj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:20 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P6MYBu024783
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:19 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 3ear6cxm5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:19 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P6OIAj30671108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:24:18 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F04D136060;
        Fri, 25 Feb 2022 06:24:18 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A40F13605D;
        Fri, 25 Feb 2022 06:24:17 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 06:24:17 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 4/8] ibmvnic: complete init_done on transport events
Date:   Thu, 24 Feb 2022 22:23:54 -0800
Message-Id: <20220225062358.1435652-5-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225062358.1435652-1-sukadev@linux.ibm.com>
References: <20220225062358.1435652-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wfvws5tiJgc69oBe6-_v-k7c_hWyP_h9
X-Proofpoint-ORIG-GUID: wfvws5tiJgc69oBe6-_v-k7c_hWyP_h9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_05,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250030
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we get a transport event, set the error and mark the init as
complete so the attempt to send crq-init or login fail sooner
rather than wait for the timeout.

Fixes: bbd669a868bb ("ibmvnic: Fix completion structure initialization")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d8911a2a4370..d461d2bffef1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5352,6 +5352,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			adapter->fw_done_rc = -EIO;
 			complete(&adapter->fw_done);
 		}
+
+		/* if we got here during crq-init, retry crq-init */
+		if (!completion_done(&adapter->init_done)) {
+			adapter->init_done_rc = -EAGAIN;
+			complete(&adapter->init_done);
+		}
+
 		if (!completion_done(&adapter->stats_done))
 			complete(&adapter->stats_done);
 		if (test_bit(0, &adapter->resetting))
-- 
2.27.0

