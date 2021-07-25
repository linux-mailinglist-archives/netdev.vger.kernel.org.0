Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1743D4DB4
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 15:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhGYMoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 08:44:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230192AbhGYMob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 08:44:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16PDOxm2009473;
        Sun, 25 Jul 2021 06:24:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=LeXLe+G5LjuEOWNPODiztD78RoMAIYm9/yu+Kv29a5c=;
 b=gHfaFkahav0Ps2DxcX2CNTLSwwqnrirTFnGej4juBXOJqEF+yIr/ID4nWtDnD4lOg0hS
 xQT1JwYLMc8/YsXgMf59In6FR+qEqi6AAmbPk+KYOAtsTKnVSqJ7N+Ga1ky9dZbzUMR5
 QuspTSkFGPwoTf52EZAsw566dDoge7QRZmdsQs1Cb7oZZrFtYCkjd6jzhZbJ9NY07Tge
 EFat/YzU8j/ANpi2nsX7JlkbJkhHDLojGwNOyHOYekXIX5zFwB7Moiwktnq+Aq0dmjsz
 OutjmidlPdMbZEtaPwq+gM7YlbaHFA1mT44w/fZ3osd6UbYb74iANTU2HUJOyTh943+S TQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a0jcmjdce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 25 Jul 2021 06:24:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 25 Jul
 2021 06:24:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 25 Jul 2021 06:24:56 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 6074B3F70B2;
        Sun, 25 Jul 2021 06:24:55 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH] octeontx2-af: Do NIX_RX_SW_SYNC twice
Date:   Sun, 25 Jul 2021 18:54:52 +0530
Message-ID: <1627219492-16140-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: GWMYS_6B0Kf6k_HzI-Irhj7K2PDC-GLZ
X-Proofpoint-ORIG-GUID: GWMYS_6B0Kf6k_HzI-Irhj7K2PDC-GLZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-25_03:2021-07-23,2021-07-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NIX_RX_SW_SYNC ensures all existing transactions are finished and
pkts are written to LLC/DRAM, queues should be teared down after
successful SW_SYNC. Due to a HW errata, in some rare scenarios
an existing transaction might end after SW_SYNC operation. To
ensure operation is fully done, do the SW_SYNC twice.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 3006766..4bfbbdf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -196,11 +196,22 @@ static void nix_rx_sync(struct rvu *rvu, int blkaddr)
 {
 	int err;
 
-	/*Sync all in flight RX packets to LLC/DRAM */
+	/* Sync all in flight RX packets to LLC/DRAM */
 	rvu_write64(rvu, blkaddr, NIX_AF_RX_SW_SYNC, BIT_ULL(0));
 	err = rvu_poll_reg(rvu, blkaddr, NIX_AF_RX_SW_SYNC, BIT_ULL(0), true);
 	if (err)
-		dev_err(rvu->dev, "NIX RX software sync failed\n");
+		dev_err(rvu->dev, "SYNC1: NIX RX software sync failed\n");
+
+	/* SW_SYNC ensures all existing transactions are finished and pkts
+	 * are written to LLC/DRAM, queues should be teared down after
+	 * successful SW_SYNC. Due to a HW errata, in some rare scenarios
+	 * an existing transaction might end after SW_SYNC operation. To
+	 * ensure operation is fully done, do the SW_SYNC twice.
+	 */
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_SW_SYNC, BIT_ULL(0));
+	err = rvu_poll_reg(rvu, blkaddr, NIX_AF_RX_SW_SYNC, BIT_ULL(0), true);
+	if (err)
+		dev_err(rvu->dev, "SYNC2: NIX RX software sync failed\n");
 }
 
 static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
-- 
2.7.4

