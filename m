Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBE066BA43
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjAPJ1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjAPJ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:27:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70080166E9;
        Mon, 16 Jan 2023 01:27:27 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30G94gNp016267;
        Mon, 16 Jan 2023 09:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Mx4Bncrl5DXxBU+OhNDK8Rb0fMdhzVxzZ9MxR22lOMg=;
 b=OFhDAC++wMbB6cGPisRPfJw0fkbdkRSfNdOWlXkphmxaeomvPVFpzWji0OMgDTFfVc9j
 x2+Js+MwCroEAi8ahnZCSREJ4x0AH8c4aCzDPY+qnQNETS+IWzsQK/lwb5cg6742I6mw
 3P7TipaiB2x+J3qrw4BZ+xB80mRLhmX8IDNaYcElII05mOAoQBX6OL7kppkHNRUqVgaq
 k7xVtQ9k9AxemVkBG1ucBMk0/p1adnLs3ozH31Swu8ltJbZlmdfTJGq4vjCpewGrLy7O
 xlW8QPbENzw8UNOzCwuUC/ER4Oh7upHTnpdnrEoLAap3IslIjYCkNPlN3BCOfxunEJQN pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n53mt8mea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:22 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30G953j5018862;
        Mon, 16 Jan 2023 09:27:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n53mt8mdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30G0nSbh004659;
        Mon, 16 Jan 2023 09:27:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16j705-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30G9RGBY52101440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 09:27:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 830F52005A;
        Mon, 16 Jan 2023 09:27:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBE2B2004B;
        Mon, 16 Jan 2023 09:27:15 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.177.79])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 09:27:15 +0000 (GMT)
From:   Jan Karcher <jaka@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: [net-next 2/8] net/ism: Add missing calls to disable bus-mastering
Date:   Mon, 16 Jan 2023 10:27:06 +0100
Message-Id: <20230116092712.10176-3-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116092712.10176-1-jaka@linux.ibm.com>
References: <20230116092712.10176-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rrc9eM_ifFydFMaqB9WeTdE-6oitaUZi
X-Proofpoint-GUID: 2try_93TCB4Oodd-PI2LncXX1rfvOUtt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_07,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=882 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index dfd401d9e362..e253949aa975 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -582,6 +582,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_free:
 	smcd_free_dev(ism->smcd);
 err_resource:
+	pci_clear_master(pdev);
 	pci_release_mem_regions(pdev);
 err_disable:
 	pci_disable_device(pdev);
@@ -612,6 +613,7 @@ static void ism_remove(struct pci_dev *pdev)
 	ism_dev_exit(ism);
 
 	smcd_free_dev(ism->smcd);
+	pci_clear_master(pdev);
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
 	dev_set_drvdata(&pdev->dev, NULL);
-- 
2.25.1

