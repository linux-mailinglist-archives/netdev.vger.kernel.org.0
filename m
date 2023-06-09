Return-Path: <netdev+bounces-9511-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026807298DE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D24B81C21124
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9950C16415;
	Fri,  9 Jun 2023 11:58:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BDEA93C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:58:41 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A854235A7;
	Fri,  9 Jun 2023 04:58:37 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 358NXwkk009064;
	Fri, 9 Jun 2023 04:58:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=KYGy8FJirVbuRnOVRPtreeZfJtNYkKc3HOJaujzKkpo=;
 b=FU/7oJwebanhVsP8Sab5iEBNJb38AR6TzsKJgEvPBxzdl3FfEy9LsI8NCzLlRTucUjNn
 LxV2l2G7K62w0hKPtpYcYstPz2AJsSAO2ReGNVSpQqGv6pbjkGF3WNifUDyb5sB6q3hq
 5lTIcQXEhsUnRBrNVNY91vCYbT4E6mmF4e/NgjXC95Der5H3y1swD/S0TW4jJ4Gj4xSn
 ls/Tb1G8KBCmJtzYPhcPUbK+OstLLgZEyTMczVyMpP0JMjNQ4r6S0c9q/FxeeKO/dt45
 0H1xz1HKVVF52luj3svdmeSWa2QbBwC4IOMMiiy/6mauB9FU9MT5mrgGq32XZ0rjRM52 Ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3r329c78cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Fri, 09 Jun 2023 04:58:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 9 Jun
 2023 04:58:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 9 Jun 2023 04:58:19 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
	by maili.marvell.com (Postfix) with ESMTP id 590313F7057;
	Fri,  9 Jun 2023 04:58:14 -0700 (PDT)
From: Sai Krishna <saikrishnag@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <dan.carpenter@linaro.org>, <maciej.fijalkowski@intel.com>
CC: Sai Krishna <saikrishnag@marvell.com>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>
Subject: [net PATCH v2] octeontx2-af: Move validation of ptp pointer before its usage
Date: Fri, 9 Jun 2023 17:28:06 +0530
Message-ID: <20230609115806.2625564-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: sTtX79zfJY4Vc5BymOZw9Udj_QeotfA2
X-Proofpoint-ORIG-GUID: sTtX79zfJY4Vc5BymOZw9Udj_QeotfA2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-09_08,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Moved PTP pointer validation before its use to avoid smatch warning.
Also used kzalloc/kfree instead of devm_kzalloc/devm_kfree.

Fixes: 2ef4e45d99b1 ("octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon")
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
v2:
    - Addressed review comments given by Maciej Fijalkowski
	1. Modified patch title, commit message
	2. Used kzalloc/kfree instead of devm_kzalloc/devm_kfree

 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 3411e2e47d46..248316c4a53f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -388,11 +388,10 @@ static int ptp_extts_on(struct ptp *ptp, int on)
 static int ptp_probe(struct pci_dev *pdev,
 		     const struct pci_device_id *ent)
 {
-	struct device *dev = &pdev->dev;
 	struct ptp *ptp;
 	int err;
 
-	ptp = devm_kzalloc(dev, sizeof(*ptp), GFP_KERNEL);
+	ptp = kzalloc(sizeof(struct ptp), GFP_KERNEL);
 	if (!ptp) {
 		err = -ENOMEM;
 		goto error;
@@ -428,7 +427,7 @@ static int ptp_probe(struct pci_dev *pdev,
 	return 0;
 
 error_free:
-	devm_kfree(dev, ptp);
+	kfree(ptp);
 
 error:
 	/* For `ptp_get()` we need to differentiate between the case
@@ -449,16 +448,17 @@ static void ptp_remove(struct pci_dev *pdev)
 	struct ptp *ptp = pci_get_drvdata(pdev);
 	u64 clock_cfg;
 
-	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
-		hrtimer_cancel(&ptp->hrtimer);
-
 	if (IS_ERR_OR_NULL(ptp))
 		return;
 
+	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
+		hrtimer_cancel(&ptp->hrtimer);
+
 	/* Disable PTP clock */
 	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
 	clock_cfg &= ~PTP_CLOCK_CFG_PTP_EN;
 	writeq(clock_cfg, ptp->reg_base + PTP_CLOCK_CFG);
+	kfree(ptp);
 }
 
 static const struct pci_device_id ptp_id_table[] = {
-- 
2.25.1


