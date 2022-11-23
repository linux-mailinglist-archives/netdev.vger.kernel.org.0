Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04113635AEC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiKWLEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiKWLDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:03:47 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14623264AC;
        Wed, 23 Nov 2022 02:59:54 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN8ekNG013797;
        Wed, 23 Nov 2022 02:59:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=TyQeAQTDZ7xHaJZDFDLgCRDDirE7+0j1lc98jV5AzRc=;
 b=K/qm/eGnQPH2UHFT5TbprUm0Ce/fEi/N7/gCQNY20nCnSQTLoZeCOjuEjC6pKQSEVxi1
 cPcXVebL4MAmXy6NhsmOSNzxoE1TpxIdW369xUBzzzzInnWuR3evH6oj25L4ywST7kEz
 c+dJ3ifrKUV0aQ57AX8YLdYwnQXw4XumeGrcPn5Gubn9CDSoIbxRW0HOhHVBkf/nFj65
 0lf36AZKrdDJ96QE3uWXEVuxntzkb95ymTMuWzVmregly2xXzIYRVtjlLO8PmBhQBh0U
 LUGlzOvz/6jz45W12tY1bQLaJ2U3shMGk7SfaAOE/kVGwq8pDjQQkRJPlLE9X6JppdEh Og== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m1g7j8ecj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 02:59:46 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Nov
 2022 02:59:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Nov 2022 02:59:44 -0800
Received: from localhost.localdomain (unknown [10.28.36.166])
        by maili.marvell.com (Postfix) with ESMTP id EF4013F708F;
        Wed, 23 Nov 2022 02:59:40 -0800 (PST)
From:   Suman Ghosh <sumang@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <jerinj@marvell.com>, <gakula@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [net PATCH V2] octeontx2-pf: Fix pfc_alloc_status array overflow
Date:   Wed, 23 Nov 2022 16:29:38 +0530
Message-ID: <20221123105938.2824933-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: heu1bj4xM5KoVp5eHu8KpBzaT1UrtfBb
X-Proofpoint-GUID: heu1bj4xM5KoVp5eHu8KpBzaT1UrtfBb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_05,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses pfc_alloc_status array overflow occurring for
send queue index value greater than PFC priority. Queue index can be
greater than supported PFC priority for multiple scenarios (e.g. QoS,
during non zero SMQ allocation for a PF/VF).
In those scenarios the API should return default tx scheduler '0'.
This is causing mbox errors as otx2_get_smq_idx returing invalid smq value.

Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
---
Changes since v1:
- Updated commit message.

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

