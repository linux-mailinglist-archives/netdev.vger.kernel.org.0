Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86FE2139D6
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgGCMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 08:10:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16008 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726340AbgGCMKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 08:10:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063Bxfc3006576;
        Fri, 3 Jul 2020 05:10:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=WqOONQnx9b/MqroZWVBhJszzLXhbo4Ab184y9HOYD2I=;
 b=bCc6ClquyLVScSUcEHx0v4EgS+T5gv0rbNM2wBy923KMMVDg/DLF6Grld+7C0XXwHru5
 f6ZU2hdag8RgLRp/fK9K/5uyfuEdX39sMgRRSSbWrPu0ap+Iv8TSGg6/bQxeAsuurGKh
 88edSNl7m9PZI9bA9fNtURgtfCasfRk+vAv23vO1JxbWemMeP1hyygUmnDNwKznci6dz
 g67sb1E93sGgPSN7mG+2l6SRBomr/yW5TTbShesvPcRrCU1illtYmxUJAdLP79PEZsRf
 zm+iHejrCHloY4jh1v4GvlWQ2CEIEWp3aYLGAex5vixp9HshwcYfCP11l/61xegNh+g8 Sw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mp1n88-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 05:10:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 05:10:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 05:10:04 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id EEB753F704B;
        Fri,  3 Jul 2020 05:10:02 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v2 4/4] bnx2x: Perform Idlechk dump during the debug collection.
Date:   Fri, 3 Jul 2020 17:39:50 +0530
Message-ID: <1593778190-1818-5-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593778190-1818-1-git-send-email-skalluru@marvell.com>
References: <1593778190-1818-1-git-send-email-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
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

