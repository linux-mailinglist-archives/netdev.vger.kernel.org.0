Return-Path: <netdev+bounces-8715-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D527254FF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14CC1C20CEE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1896AAA;
	Wed,  7 Jun 2023 07:03:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25783D99
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:03:21 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED321732;
	Wed,  7 Jun 2023 00:03:20 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3575KDC2022645;
	Wed, 7 Jun 2023 00:03:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=k923a7Oxn1k2haeRkq4asJ9KrNimQZa4Ue+wkrhnX9g=;
 b=XeAGaidRrB/iL3X2hENXzlCCevc93bUGD0ulGN9z5QFWYz3qUf7K31sqDfh7Fy2z9YzZ
 9kyvy+AW3B+1qxcCCnbOql3gnwVU4OvwwBnlZMdvXYoC8VYEZOxChTQvQPqqMqAK9acC
 wuTF3ZCTMqTVY7LnGXdqkprf19t7mzkl03ds99uBLGZOarg2RGhvOFkY1QnovttNxBg/
 W1ebfx30wWu7ZtG4TdPVYWNaYuQIrUSg+FDMKUidH14HHjhQHdRGuptj5hEopASBqIKa
 +ntYcv2tJSxY8vVeLpJYFZD1JF4femYaYX9eyVuj/QKY1fwbj0x10mh3rJir2a2h25NF Ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r2a759tra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 00:03:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 7 Jun
 2023 00:03:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 7 Jun 2023 00:03:03 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
	by maili.marvell.com (Postfix) with ESMTP id 03AC53F708E;
	Wed,  7 Jun 2023 00:03:00 -0700 (PDT)
From: Sai Krishna <saikrishnag@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <dan.carpenter@linaro.org>
CC: Sai Krishna <saikrishnag@marvell.com>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>
Subject: [net PATCH] octeontx2-af: Fix pointer dereference before sanity check
Date: Wed, 7 Jun 2023 12:32:55 +0530
Message-ID: <20230607070255.2013980-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wMSWW6VGaA-pXum6hlxiUEb3zaKmJBgv
X-Proofpoint-GUID: wMSWW6VGaA-pXum6hlxiUEb3zaKmJBgv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_04,2023-06-06_02,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PTP pointer is being dereferenced before NULL, error check.
Fixed the same to avoid NULL dereference and smatch checker warning.

Fixes: 2ef4e45d99b1 ("octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon")
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 3411e2e47d46..6a7dfb181fa8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -449,12 +449,12 @@ static void ptp_remove(struct pci_dev *pdev)
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
-- 
2.25.1


