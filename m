Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7EB4959FC
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378726AbiAUGfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60466 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378717AbiAUGfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05s8b029343;
        Thu, 20 Jan 2022 22:35:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/jIxyvw54NwOPJ58tv5V/JCkhzY9QNffEELGBiE5n+U=;
 b=NU5/6w4xDfomRcbsfhPA5vwIobftGHPS3y3IG7ao+si/dZXlBNkldnxIrYGMDrjntiXy
 dbsSAJb/x+IxKBBFeocNUDs/qodmTayX1b3GkXbpizhN2EYVOLFQiQoGMZ4Z5/F6HQPn
 naIZ0x1C4Ui9qvyeaOLMOk/iAWIhho2GVDzPU+GK34I8wx0/3XlyGbb3YXw8tGMlYDEw
 i+VFvm5QkC6HgnecJKT+K31KaxC5GpQui2NPo7EEQ6qizvjBHN6scMVbtD6xA60WCfAp
 ow9to7ohEf4Oi6qhAFig9jn1jAgvPsyKCk19b1Ny5QmlhTl0FiLjIK8SQxZ9uuL8pHpd aA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:11 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 22:35:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:10 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 36CB83F7060;
        Thu, 20 Jan 2022 22:35:06 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 5/9] octeontx2-pf: cn10k: Ensure valid pointers are freed to aura
Date:   Fri, 21 Jan 2022 12:04:43 +0530
Message-ID: <1642746887-30924-6-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: PNTL6XVQwNZxo5fOsvCoj7aKjferjr1k
X-Proofpoint-ORIG-GUID: PNTL6XVQwNZxo5fOsvCoj7aKjferjr1k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

While freeing SQB pointers to aura, driver first memcpy to
target address and then triggers lmtst operation to free pointer
to the aura. We need to ensure(by adding dmb barrier)that memcpy
is finished before pointers are freed to the aura. This patch also
adds the missing sq context structure entry in debugfs.

Fixes: ef6c8da71eaf ("octeontx2-pf: cn10K: Reserve LMTST lines per core")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c  | 2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index a09a507..d1eddb7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1224,6 +1224,8 @@ static void print_nix_cn10k_sq_ctx(struct seq_file *m,
 	seq_printf(m, "W3: head_offset\t\t\t%d\nW3: smenq_next_sqb_vld\t\t%d\n\n",
 		   sq_ctx->head_offset, sq_ctx->smenq_next_sqb_vld);
 
+	seq_printf(m, "W3: smq_next_sq_vld\t\t%d\nW3: smq_pend\t\t\t%d\n",
+		   sq_ctx->smq_next_sq_vld, sq_ctx->smq_pend);
 	seq_printf(m, "W4: next_sqb \t\t\t%llx\n\n", sq_ctx->next_sqb);
 	seq_printf(m, "W5: tail_sqb \t\t\t%llx\n\n", sq_ctx->tail_sqb);
 	seq_printf(m, "W6: smenq_sqb \t\t\t%llx\n\n", sq_ctx->smenq_sqb);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 61e5281..14509fc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -603,6 +603,7 @@ static inline void __cn10k_aura_freeptr(struct otx2_nic *pfvf, u64 aura,
 			size++;
 		tar_addr |=  ((size - 1) & 0x7) << 4;
 	}
+	dma_wmb();
 	memcpy((u64 *)lmt_info->lmt_addr, ptrs, sizeof(u64) * num_ptrs);
 	/* Perform LMTST flush */
 	cn10k_lmt_flush(val, tar_addr);
-- 
2.7.4

