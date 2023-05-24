Return-Path: <netdev+bounces-5069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FFE70F952
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9BB91C20DC1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F4218C28;
	Wed, 24 May 2023 14:55:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F39A182CF
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:55:48 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3401BB;
	Wed, 24 May 2023 07:55:16 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34OE6t7b013109;
	Wed, 24 May 2023 14:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=rodPNwLfHsIuiQQiFeOVrCe92jgLqk9u0QoV1c2yRD8=;
 b=qaUymqObmWxB5kJp2iCdhHnw5MWUbt3kyZWFk80U/DlfHfT4NN7ph4lEAje6mTrXWKgL
 PeSRuB/YxES7NoXMUMPnNT9+AkNIuBkh6mJ0KZOVo8H10d/MMA7gWRTvDdO7zUhbBGG8
 bwM4ekNpuVwjM7r/zRIFMgbTWJ1C+YbezOrSh5oRrnGCsVMJZlFG9DHgF+KNUR+xTFoG
 gJwtNFLPWJlNw8dfdcUJI5vbHN6y5t8uNXllK13V3LkX/bILdjTXUycDl4L8noTons1n
 h2CMRfZnUmR4NHPBcmvxYkl5xbP5CPPuZNbt+72xPd19njPkhVi53fmQygTKqxs+Oh5z 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qskj5atqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 14:53:32 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34OEKIQm030082;
	Wed, 24 May 2023 14:53:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qskj5atpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 14:53:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34O5NMMv007529;
	Wed, 24 May 2023 14:53:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qppdk20y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 14:53:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34OErOYQ20775540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 May 2023 14:53:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98C422004B;
	Wed, 24 May 2023 14:53:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5151520043;
	Wed, 24 May 2023 14:53:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 May 2023 14:53:23 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 24 May 2023 16:53:06 +0200
Subject: [PATCH v10 3/6] s390/pci: prepare is_passed_through() for
 dma-iommu
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230310-dma_iommu-v10-3-f1fbd8310854@linux.ibm.com>
References: <20230310-dma_iommu-v10-0-f1fbd8310854@linux.ibm.com>
In-Reply-To: <20230310-dma_iommu-v10-0-f1fbd8310854@linux.ibm.com>
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
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFLyVO7mfZh4PKS7PnkHo+TsJp9LC2Odt9T96bLaemGrv
 PmuCecTO0pZGMQ4GGTFFFkWdTn7rSuYYronqL8DZg4rE8gQBi5OAZjI0RaG/xHF6T+zw1esyuKb
 WqpYJquQwbWz/v0/3/2e/zSPnfy0fzfDLyb7lSlWot/eJrJeMS25p6p60q311oVvS5kirr/T3yR
 0nR0A
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rh7nK0exsIolAwSfDfy2oZp5BFw_d50C
X-Proofpoint-ORIG-GUID: gnzQurOWWq47wHike23feg71THAQQ-3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_09,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305240119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
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


