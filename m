Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDA52125BF
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgGBOKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:10:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21220 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729550AbgGBOKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:10:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062DlEkH030545;
        Thu, 2 Jul 2020 07:10:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=z0amd0JE2xpLt2eGP7eUpoO2MMlEg/XyUE9gjExJtvA=;
 b=rZW0GSvnV7UuKcgB9BhWLrqiE890JAOfyk4Tntg0smulP/FwXQXS0pyP73h57SumKPLy
 2avKB3iTca+3lDzeD8/U8xh4t5mcPIFJ1LCkwfaVu8lYiu0avIb9A3BApoxuXYonljJw
 qE+/fb6BGp3FrIOzh3613vtetK+gO8T35mq1pLIc3XLnsIgwqN0mGG6oamYsdMP6ohZb
 U2KVP4QUtSWqdG3kM1ouQegyNu98/QKDeEEpJBRKs3NQPKXVVWV5B+7+ecPd5L0d5cPD
 hnnc5ex+f1iMukdA7SWTd/bcf52+aaCXeX+W2DhrA7tfIoDH7whPs46reyvko+dfuCb6 lA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mnwja6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 07:10:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 07:10:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 07:10:43 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id E3A703F703F;
        Thu,  2 Jul 2020 07:10:41 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 4/4] bnx2x: Perform Idlechk dump during the debug collection.
Date:   Thu, 2 Jul 2020 19:40:29 +0530
Message-ID: <1593699029-18937-5-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593699029-18937-1-git-send-email-skalluru@marvell.com>
References: <1593699029-18937-1-git-send-email-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds driver changes to perform Idlechk dump during the debug
data collection.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index db5107e7..e89e7a8 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1169,9 +1169,18 @@ void bnx2x_panic_dump(struct bnx2x *bp, bool disable_int)
 	}
 #endif
 	if (IS_PF(bp)) {
+		int tmp_msg_en = bp->msg_enable;
+
 		bnx2x_fw_dump(bp);
+		bp->msg_enable |= NETIF_MSG_HW;
+		BNX2X_ERR("Idle check (1st round) ----------\n");
+		bnx2x_idle_chk(bp);
+		BNX2X_ERR("Idle check (2nd round) ----------\n");
+		bnx2x_idle_chk(bp);
+		bp->msg_enable = tmp_msg_en;
 		bnx2x_mc_assert(bp);
 	}
+
 	BNX2X_ERR("end crash dump -----------------\n");
 }
 
-- 
1.8.3.1

