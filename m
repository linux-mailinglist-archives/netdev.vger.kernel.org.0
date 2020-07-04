Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF121442B
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 06:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGDEn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 00:43:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35412 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725849AbgGDEn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 00:43:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0644dw8l017226;
        Fri, 3 Jul 2020 21:43:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=WqOONQnx9b/MqroZWVBhJszzLXhbo4Ab184y9HOYD2I=;
 b=gdnyAW2U6dv289Uw7I/6tB3HJpX+F3ikcuLt5MQ9Gi07fW/I00b5IMnc4xwyMytFSTAm
 Rbjp2vheA2w8h/bhUBWTp4X+RCu+bodU/PSh8YjTFetPXrJVzvGuzyihF3HJifjUML7J
 fCgVezQv9iFIzzuW4eC8t1xogSlHsD53Kis1jac/cfIGVoGUAGylsCX2i1MmRxZZMxoN
 Y4QD8NPIBkr15/ZqB9PtGzWZy8rgzJdRkQE/U2MZoyuw3+Br++5q5aLBrmkFRFzghM9T
 YWIVeQNQGDhNngMur0PnSwB5Hg69WsdLtMa+AzX4dmt5jUj5rNhthoOSWmIyGrJkHd2G kA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 321m92xaye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 21:43:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 21:43:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 21:43:57 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id A4B223F703F;
        Fri,  3 Jul 2020 21:43:55 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v3 3/3] bnx2x: Perform Idlechk dump during the debug collection.
Date:   Sat, 4 Jul 2020 10:13:44 +0530
Message-ID: <1593837824-26657-4-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593837824-26657-1-git-send-email-skalluru@marvell.com>
References: <1593837824-26657-1-git-send-email-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-04_03:2020-07-02,2020-07-04 signatures=0
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
index 06dfb90..7c2194f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1176,9 +1176,18 @@ void bnx2x_panic_dump(struct bnx2x *bp, bool disable_int)
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

