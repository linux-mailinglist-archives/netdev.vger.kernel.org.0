Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FAB3F636D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhHXQyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:54:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231201AbhHXQxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:53:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O7c76G001613;
        Tue, 24 Aug 2021 09:53:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=lNPVqn0k38IXwKZ1vXKfrriM19JpVt8TqzItKaJOQhM=;
 b=PU2KI6YestZz5Q0CNAOnVgPeNahmFmqD1r1qFWDwUtIl6nWbZhDmnPMc85HBwJUEz+3i
 K7TO8OpvDGYcNBZd209rJD9LMhk2MnG/jC2p1ZguxL7s37XGpnv2loAFrzMz7moDMjIn
 USSlJo06GTVgBCRRntU1PBMnyYNA+G+2S+ijruu4qsJU7bNbli6/gaKyofrpRgAtGnHD
 YAd9CybOeKjzF0D8kmOyE2yNKew7xm4uv5FbnjAlOKhydpCrnwO5G1W9n/Qxvt+dB3Ud
 sJJY+C+zlRZaK3/IzcSfGKazfhSuvVrZ4M9oxO/B/H07LFkLzcfoqdSPL2j0lTKQLztP sQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3amkrkbtpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 09:53:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 24 Aug
 2021 09:53:00 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Tue, 24 Aug 2021 09:52:59 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <keescook@chromium.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: [PATCH] qede: Fix memset corruption
Date:   Tue, 24 Aug 2021 19:52:49 +0300
Message-ID: <20210824165249.7063-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: S8IRZnkZe_ASu-uCQj8Ez45_bP-Kho0Z
X-Proofpoint-ORIG-GUID: S8IRZnkZe_ASu-uCQj8Ez45_bP-Kho0Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_05,2021-08-24_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to Kees Cook who detected the problem of memset that starting
from not the first member, but sized for the whole struct.
The better change will be to remove the redundant memset and to clear
only the msix_cnt member.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index d400e9b235bf..a0f20c5337d0 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1866,6 +1866,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2419,7 +2420,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	goto out;
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
-- 
2.22.0

