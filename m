Return-Path: <netdev+bounces-2558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8602070281B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A87E1C20951
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EBCBA5D;
	Mon, 15 May 2023 09:17:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BC28BEB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:17:19 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCFD35B5;
	Mon, 15 May 2023 02:17:18 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34F9908n021216;
	Mon, 15 May 2023 09:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=rodPNwLfHsIuiQQiFeOVrCe92jgLqk9u0QoV1c2yRD8=;
 b=Ip4Kk6KLTgQeDyCln7BamdjEMifcHiU5FrAfDKQeXr6lMt5S8J2khv2ssn1+JwLWthwU
 o+oOiby+XTHcjPnAwXEis4CNewl9KkMgDNnesWFZTHwT1Sz0jIjXwPIfK7SYCzMivx3a
 wEtLX2iCBuSZiE/m+f8PAa4wPG6V4aVbbn7/w/0/O1rxr0kGLJF0iA87u5a+ax70r/kE
 fRmJAcBPcFBQC+tbp8z3qpL69HuFqjOZPsHAAhI4QTkx+lHZy/Es5oC8KSglASiQ81U1
 tNRc2K87KAVRQTBb1F+3QYxpk6EG3ohDGeyDRpaYayorjgNwLVlwSTjiWDszaMDtt0s/ rg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkg78k3f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 09:16:33 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34F9G7YK013166;
	Mon, 15 May 2023 09:16:29 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkg78k38w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 09:16:29 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34F97tbJ009450;
	Mon, 15 May 2023 09:16:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qj264rt8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 09:16:20 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34F9GGK651184124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 May 2023 09:16:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8BD020040;
	Mon, 15 May 2023 09:16:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7F0A2004E;
	Mon, 15 May 2023 09:16:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 May 2023 09:16:15 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Mon, 15 May 2023 11:15:53 +0200
Subject: [PATCH v9 3/6] s390/pci: prepare is_passed_through() for dma-iommu
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230310-dma_iommu-v9-3-65bb8edd2beb@linux.ibm.com>
References: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
In-Reply-To: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
To: Joerg Roedel <joro@8bytes.org>, Matthew Rosato <mjrosato@linux.ibm.com>,
        Will Deacon <will@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gerd Bayer <gbayer@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Yong Wu <yong.wu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-tegra@vger.kernel.org, linux-doc@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1902;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=JnpBPtIA02SvkModRZiVKujLXSYwAXU0tTNoKrRKqJY=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFISf0RNE3DSWbUtwTI/6fKHVP5NYZuupLbZ77jzbtpBz
 4ufCsNiO0pZGMQ4GGTFFFkWdTn7rSuYYronqL8DZg4rE8gQBi5OAZhIxlmG/+4vL59dGfTYl/GA
 45Oa9F69EKfdHw9VV37717Zvcjyv+3GGf9acy2fnbEjzsu6WSprM8Nv8WURwyYL1ukJLBT/f9Vv
 xgBkA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n6Hf-MCaUSzMZVFFH4ZkAQGIN2BF4c-E
X-Proofpoint-ORIG-GUID: z9QuOV8xCrXzlc97SDldpzRutquerwCA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305150078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With the IOMMU always controlled through the IOMMU driver testing for
zdev->s390_domain is not a valid indication of the device being
passed-through. Instead test if zdev->kzdev is set.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/pci/pci_event.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index b9324ca2eb94..4ef5a6a1d618 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -59,9 +59,16 @@ static inline bool ers_result_indicates_abort(pci_ers_result_t ers_res)
 	}
 }
 
-static bool is_passed_through(struct zpci_dev *zdev)
+static bool is_passed_through(struct pci_dev *pdev)
 {
-	return zdev->s390_domain;
+	struct zpci_dev *zdev = to_zpci(pdev);
+	bool ret;
+
+	mutex_lock(&zdev->kzdev_lock);
+	ret = !!zdev->kzdev;
+	mutex_unlock(&zdev->kzdev_lock);
+
+	return ret;
 }
 
 static bool is_driver_supported(struct pci_driver *driver)
@@ -176,7 +183,7 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 	}
 	pdev->error_state = pci_channel_io_frozen;
 
-	if (is_passed_through(to_zpci(pdev))) {
+	if (is_passed_through(pdev)) {
 		pr_info("%s: Cannot be recovered in the host because it is a pass-through device\n",
 			pci_name(pdev));
 		goto out_unlock;
@@ -239,7 +246,7 @@ static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_state_t es)
 	 * we will inject the error event and let the guest recover the device
 	 * itself.
 	 */
-	if (is_passed_through(to_zpci(pdev)))
+	if (is_passed_through(pdev))
 		goto out;
 	driver = to_pci_driver(pdev->dev.driver);
 	if (driver && driver->err_handler && driver->err_handler->error_detected)

-- 
2.39.2


