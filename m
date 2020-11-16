Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD72B4463
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgKPNFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:05:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7921 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbgKPNFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:05:37 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CZTnr59Mdz6v92;
        Mon, 16 Nov 2020 21:05:20 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 16 Nov 2020 21:05:30 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Michal.Kalderon@cavium.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] qed: fix error return code in qed_iwarp_ll2_start()
Date:   Mon, 16 Nov 2020 21:07:13 +0800
Message-ID: <1605532033-27373-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 469981b17a4f ("qed: Add unaligned and packed packet processing")
Fixes: fcb39f6c10b2 ("qed: Add mpa buffer descriptors for storing and processing mpa fpdus")
Fixes: 1e28eaad07ea ("qed: Add iWARP support for fpdu spanned over more than two tcp packets")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 512cbef..a998611 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2754,14 +2754,18 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	iwarp_info->partial_fpdus = kcalloc((u16)p_hwfn->p_rdma_info->num_qps,
 					    sizeof(*iwarp_info->partial_fpdus),
 					    GFP_KERNEL);
-	if (!iwarp_info->partial_fpdus)
+	if (!iwarp_info->partial_fpdus) {
+		rc = -ENOMEM;
 		goto err;
+	}
 
 	iwarp_info->max_num_partial_fpdus = (u16)p_hwfn->p_rdma_info->num_qps;
 
 	iwarp_info->mpa_intermediate_buf = kzalloc(buff_size, GFP_KERNEL);
-	if (!iwarp_info->mpa_intermediate_buf)
+	if (!iwarp_info->mpa_intermediate_buf) {
+		rc = -ENOMEM;
 		goto err;
+	}
 
 	/* The mpa_bufs array serves for pending RX packets received on the
 	 * mpa ll2 that don't have place on the tx ring and require later
@@ -2771,8 +2775,10 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	iwarp_info->mpa_bufs = kcalloc(data.input.rx_num_desc,
 				       sizeof(*iwarp_info->mpa_bufs),
 				       GFP_KERNEL);
-	if (!iwarp_info->mpa_bufs)
+	if (!iwarp_info->mpa_bufs) {
+		rc = -ENOMEM;
 		goto err;
+	}
 
 	INIT_LIST_HEAD(&iwarp_info->mpa_buf_pending_list);
 	INIT_LIST_HEAD(&iwarp_info->mpa_buf_list);
-- 
2.9.5

