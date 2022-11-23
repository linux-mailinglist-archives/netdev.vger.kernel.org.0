Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE6D634F5E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiKWFKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiKWFKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:10:36 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE31E677D;
        Tue, 22 Nov 2022 21:10:34 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMK8hLG018733;
        Tue, 22 Nov 2022 21:10:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=TV6BMAeIiWmo9w705vQkZmR+KDIeD1FDKBzuZo4LV90=;
 b=PTXb3rby5648WkFexDtZw6K2grEy6WPqPzQol0gZF6zjSOs8h8Wquhb583QtCO2XJEZs
 9811qQmlclsJ+w/kqgIKSMT5QeNIN1FY/NBvedyDT5i83h+tdahY6edSrBhKu9uMHCpG
 ORHapraemOoesYYt/TAw8SX12bsCRWfhzIRph83vjqOQZhP1buLELaf8lOrmVQK/YJ/J
 JQF5Hytg9ZJpAeMtG290HiLMhUl85Q/i2xbYuFku8eLZIcoJJbNB19kB2//Dp0XDC3LV
 yftos3zHlEp2K2H72aRBIJaKKtodmcoNY0fMNnwP05J+pNH5CZ3zGDDExLmn7dB/AoNM +A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kxyhs5u0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 21:10:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Nov
 2022 21:10:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Nov 2022 21:10:19 -0800
Received: from localhost.localdomain (unknown [10.28.36.166])
        by maili.marvell.com (Postfix) with ESMTP id E72D33F7043;
        Tue, 22 Nov 2022 21:10:13 -0800 (PST)
From:   Suman Ghosh <sumang@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <jerinj@marvell.com>, <gakula@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [net PATCH] octeontx2-pf: Fix pfc_alloc_status array overflow
Date:   Wed, 23 Nov 2022 10:40:10 +0530
Message-ID: <20221123051010.2725917-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: w_6lzc0g2MEEq3Fd_EunJefyQO_39v2n
X-Proofpoint-ORIG-GUID: w_6lzc0g2MEEq3Fd_EunJefyQO_39v2n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_02,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses pfc_alloc_status array overflow occurring for
send queue index value greater than PFC priority. This is causing
mbox errors as otx2_get_smq_idx returing invalid smq value.

Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")

Signed-off-by: Suman Ghosh <sumang@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 282db6fe3b08..67aa02bb2b85 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -884,7 +884,7 @@ static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
 static inline u16 otx2_get_smq_idx(struct otx2_nic *pfvf, u16 qidx)
 {
 #ifdef CONFIG_DCB
-	if (pfvf->pfc_alloc_status[qidx])
+	if (qidx < NIX_PF_PFC_PRIO_MAX && pfvf->pfc_alloc_status[qidx])
 		return pfvf->pfc_schq_list[NIX_TXSCH_LVL_SMQ][qidx];
 #endif
 
-- 
2.25.1

