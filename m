Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B2B64475B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiLFPDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiLFPC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:02:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B832831FAB;
        Tue,  6 Dec 2022 06:56:36 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6E1wlI025010;
        Tue, 6 Dec 2022 14:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dQ9YEmmlCv66AcWx/hvss3YSGwtJlTY4LsOFA4Zl5hU=;
 b=SET76kGfExYRL+PHwXXG5G9PvrnofJi+06PYouNEqJrxreAxc3aYrGtwfUkMFnmT5m2L
 zjDUkBVqhr72i0hSSCJszYWlChgyirVrHjV9BYdwyumPR7Z69D41EoBIHhI84XfRkxbU
 aIfpg16spLguUIVSc3wv0O22wqdkkrqdmbQZ9mg3j+d00X/B1vFt7UsVDxoawmM5NWpY
 cnM2gppBu080+HU3dV//asDV2OhqqCh9+hP2kvtuyOIf7tzu3V877rD1yz8Uuwyv/LwP
 UXopwCmaBKuqseipWwmCztJZKVtvVtx7Ch9yzYudF85VPvij6KWeCgrVw23v2JYwUk0q Cg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma2h219v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:56:33 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6DD0uH008164;
        Tue, 6 Dec 2022 14:56:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3m9ktqh53a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:56:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6EuQAf37486934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 14:56:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69CBF20043;
        Tue,  6 Dec 2022 14:56:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A4FE20040;
        Tue,  6 Dec 2022 14:56:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  6 Dec 2022 14:56:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 2931CE0395; Tue,  6 Dec 2022 15:56:26 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net] s390/qeth: fix use-after-free in hsci
Date:   Tue,  6 Dec 2022 15:56:14 +0100
Message-Id: <20221206145614.1401170-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 62jLAulvrJD-aXXd1nupc_c4_XMKvLEt
X-Proofpoint-ORIG-GUID: 62jLAulvrJD-aXXd1nupc_c4_XMKvLEt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_10,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=995 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212060120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KASAN found that addr was dereferenced after br2dev_event_work was freed.

Fixes: f7936b7b2663 ("s390/qeth: Update MACs of LEARNING_SYNC device")
Reported-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 9dc935886e9f..c6ded3fdd715 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -758,7 +758,6 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	struct list_head *iter;
 	int err = 0;
 
-	kfree(br2dev_event_work);
 	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
 	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
 
@@ -815,6 +814,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	dev_put(brdev);
 	dev_put(lsyncdev);
 	dev_put(dstdev);
+	kfree(br2dev_event_work);
 }
 
 static int qeth_l2_br2dev_queue_work(struct net_device *brdev,
-- 
2.34.1

