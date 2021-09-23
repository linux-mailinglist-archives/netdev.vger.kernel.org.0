Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CE2415BDB
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 12:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240385AbhIWKSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 06:18:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53088 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240357AbhIWKSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 06:18:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18N72UPj015967;
        Thu, 23 Sep 2021 03:16:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=qwmFlCOsrjaR+djX6xnHZhCUgHrcIa4selpNvxHVzgk=;
 b=CbUHPCwsd1kKOJL40VsiogPTtrLOex/Q0aurzoybPzuG+5kiIBKu1nhybk+19uq70xNJ
 3HYlOu11wO6QwSyFpc6TGKwIeC8hbN88WjSv+qmllsPOOLql1vFzcU8MjyvDjlsK7GxY
 kzk67kDE8SHTi/Ewfm8CFii4mMjIkIyrm5y4HJKL/TdtoXNYXI8bFkyRf3fl8sI8m1+X
 eKEugRZ8wUCCntCGWbgBKyQLREg4oOUpbDsL7mkwenQn+wPSe2eY0ETmtQ1PeuTeL59G
 u3vN2EnwXsEsL8jEJgI7L4k/VuqVOIj16Uy/BfQvuXEX0Jlyy9jHGkj54r7RfmvCoYLe ig== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b8awj2mss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 03:16:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 03:16:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Sep 2021 03:16:36 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 174DC3F707C;
        Thu, 23 Sep 2021 03:16:36 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 18NAGNab022784;
        Thu, 23 Sep 2021 03:16:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 18NAG7mv022775;
        Thu, 23 Sep 2021 03:16:07 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>
Subject: [PATCH net 1/1] atlantic: Fix issue in the pm resume flow.
Date:   Thu, 23 Sep 2021 03:16:05 -0700
Message-ID: <20210923101605.22739-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: TLwQJxLSuLcX58ToyYZPXR1oFwm7MxQt
X-Proofpoint-ORIG-GUID: TLwQJxLSuLcX58ToyYZPXR1oFwm7MxQt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-23_03,2021-09-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After fixing hibernation resume flow, another usecase was found which
should be explicitly handled - resume when device is in "down" state.
Invoke aq_nic_init jointly with aq_nic_start only if ndev was already
up during suspend/hibernate. We still need to perform nic_deinit() if
caller requests for it, to handle the freeze/resume scenarios.

Fixes: 57f780f1c433 ("atlantic: Fix driver resume flow.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index dee9ff74d6d6..d4b1976ee69b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -413,13 +413,13 @@ static int atl_resume_common(struct device *dev, bool deep)
 	if (deep) {
 		/* Reinitialize Nic/Vecs objects */
 		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+	}
 
+	if (netif_running(nic->ndev)) {
 		ret = aq_nic_init(nic);
 		if (ret)
 			goto err_exit;
-	}
 
-	if (netif_running(nic->ndev)) {
 		ret = aq_nic_start(nic);
 		if (ret)
 			goto err_exit;
-- 
2.27.0

