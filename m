Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E5B227FFD
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 14:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgGUMeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 08:34:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14760 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728557AbgGUMeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 08:34:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LCUkpq005293;
        Tue, 21 Jul 2020 05:34:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=DaZuwUO/TcS9ZuQiy3Nn6fvXyTsD1erOQw5npeidbjU=;
 b=rxoyn12HxRk9CPtkh6xeKvrddDhTgc1OvKs0zyStqdBaVMEzuO0n0R+8p+/BNwmYpKqv
 bYzMJRhEBB97b+VP2Rh+8T5SToSWHxvG3wL/Gu1TrvGdTbuy+DsCk2Sw9FAmuVg3zeGR
 W7iO3a7ZkA64PKshHWtD+P++N/ZLfnaLjEUNI+Kye/zGeveA2Y6YPiuUQop22NwwTDaM
 kytRNoePaV7hIdRo4A1UxsoHIb1ciHJke5fdsGiXKc8K0x/llGUHH+d37GLiHu8H1kVh
 9F0zwsRvWLkyElLUFUJQxDLMQZ430lwSHj+wtD8DNobtzs/cK7TVV8ekhVcQG0IlGjXJ gQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkjr1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 05:34:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 05:34:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 05:34:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 05:34:17 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id C966A3F703F;
        Tue, 21 Jul 2020 05:34:15 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Yuval Basson <ybason@marvell.com>,
        "Michal Kalderon" <mkalderon@marvell.com>
Subject: [PATCH net-next] qed: Fix ILT and XRCD bitmap memory leaks
Date:   Tue, 21 Jul 2020 14:34:26 +0300
Message-ID: <20200721113426.32260-1-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_08:2020-07-21,2020-07-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Free ILT lines used for XRC-SRQ's contexts.
- Free XRCD bitmap

Fixes: b8204ad878ce7 ("qed: changes to ILT to support XRC")
Fixes: 7bfb399eca460 ("qed: Add XRC to RoCE")
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Basson <ybason@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c  | 5 +++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 5362dc1..6c221e9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2335,6 +2335,11 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 		elem_size = SRQ_CXT_SIZE;
 		p_blk = &p_cli->pf_blks[SRQ_BLK];
 		break;
+	case QED_ELEM_XRC_SRQ:
+		p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_TSDM];
+		elem_size = XRC_SRQ_CXT_SIZE;
+		p_blk = &p_cli->pf_blks[SRQ_BLK];
+		break;
 	case QED_ELEM_TASK:
 		p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_CDUT];
 		elem_size = TYPE1_TASK_CXT_SIZE(p_hwfn);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index e5648ca..a4bcde5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -379,6 +379,7 @@ static void qed_rdma_resc_free(struct qed_hwfn *p_hwfn)
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->srq_map, 1);
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->real_cid_map, 1);
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->xrc_srq_map, 1);
+	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->xrcd_map, 1);
 
 	kfree(p_rdma_info->port);
 	kfree(p_rdma_info->dev);
-- 
1.8.3.1

