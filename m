Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B551678458
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjAWSSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbjAWSSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:18:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79828CC1C;
        Mon, 23 Jan 2023 10:18:41 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NHVB7j024504;
        Mon, 23 Jan 2023 18:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Mx4Bncrl5DXxBU+OhNDK8Rb0fMdhzVxzZ9MxR22lOMg=;
 b=ZdvAnfuZP1NwUrgXGPTukDdVy5nSyQ+7OBlKNIeLcTRQg7SNfpraCP0nB1IIE/8ZbUGz
 XzCXUOpemt5eYIY8AF5yV2ZKRpCT+kOibUL8SFuTKkUAzJZ281vqfeJr3kooFZTI+LeF
 yJQXkFZq1/7Zg5sIlGwHYgBtHRACuRXqdHNk/lZNmztBCw/ytEzm7oODCK9d++z9YuZz
 Pfk2xTRXUTS/lZSG1zpxZRMOSLxk0LP2c0UaMjcYkaeH/lvUHQQrDWlBiIaB0T9vQFl9
 BQHE5Ys5rM1osxgBnaGf3PzmJxDjV2rn6NhqIs/iXcqWtdeaWK45Qz/BFQzx4FHcSIOo NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9xpx14j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:33 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30NI7we0034524;
        Mon, 23 Jan 2023 18:18:32 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9xpx14gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:32 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30NFOjc0005785;
        Mon, 23 Jan 2023 18:18:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n87p69y5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NIIQpY46072262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 18:18:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7735F2004D;
        Mon, 23 Jan 2023 18:18:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C92620040;
        Mon, 23 Jan 2023 18:18:25 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.149])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 18:18:25 +0000 (GMT)
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
Subject: [net-next v2 2/8] net/ism: Add missing calls to disable bus-mastering
Date:   Mon, 23 Jan 2023 19:17:46 +0100
Message-Id: <20230123181752.1068-3-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2VRydLSTckUhYHiZAvnJXDGEQk-QeTjF
X-Proofpoint-ORIG-GUID: DEjz34pPtplr8BUGigWjIvR6z6yKLa6l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=846
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

