Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D738B131162
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 12:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgAFLXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 06:23:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgAFLXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 06:23:02 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 006BERJe018337;
        Mon, 6 Jan 2020 03:23:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=lsAgJHhrfBIBhCQOwgLGiSyDnYR0MbOdDxUKAH9KUoo=;
 b=J0lwTmipRFBNRIxbdtiFEVTHEdCbxJWoB0oFHWmJm/UswVXlxUcr9F9dUMunQlUJVbqm
 Z/6k910Wfe89O4s9GXcufC/cxCvRgp7qO3+r1cF4X7OM5rbw1bWNgiWt/5z5TGp1Fib9
 YqK3dNN37pDNKQ/qIxStc/Nphuj0eOWZgqIYsZOdhGrQzMxGoi2OB3jBc3lptqcLgz2i
 u4WQZcqfKeXkMj7FcvBaw9KYs3acqBA95BnutTnbtwBPNGRQoL63P/NyWHpC7GlDR29C
 XLFU5L4FdCVTj/sHWLx0Y5ltL1Q8aFL3y4Ba0iPGstRcHpVbAV3yVyfkEwxkt+u/D2Xt 3A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xau3sn4a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jan 2020 03:23:00 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jan
 2020 03:22:58 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jan 2020 03:22:58 -0800
Received: from NN-LT0019.marvell.com (unknown [10.9.16.57])
        by maili.marvell.com (Postfix) with ESMTP id 2D42C3F704D;
        Mon,  6 Jan 2020 03:22:56 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 1/3] net: atlantic: broken link status on old fw
Date:   Mon, 6 Jan 2020 14:22:28 +0300
Message-ID: <6fc4153775b4b86713686adbc867230aa0c82286.1578059294.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.24.1.windows.2
In-Reply-To: <cover.1578059294.git.irusskikh@marvell.com>
References: <cover.1578059294.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-06_04:2020-01-06,2020-01-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Last code/checkpatch cleanup did a copy paste error where code from
firmware 3 API logic was moved to firmware 1 logic.

This resulted in FW1.x users would never see the link state as active.

Fixes: 7b0c342f1f67 ("net: atlantic: code style cleanup")
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 8910b62e67ed..f547baa6c954 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -667,9 +667,7 @@ int hw_atl_utils_mpi_get_link_status(struct aq_hw_s *self)
 	u32 speed;
 
 	mpi_state = hw_atl_utils_mpi_get_state(self);
-	speed = mpi_state & (FW2X_RATE_100M | FW2X_RATE_1G |
-			     FW2X_RATE_2G5 | FW2X_RATE_5G |
-			     FW2X_RATE_10G);
+	speed = mpi_state >> HW_ATL_MPI_SPEED_SHIFT;
 
 	if (!speed) {
 		link_status->mbps = 0U;
-- 
2.20.1

