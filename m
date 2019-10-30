Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F397DE9907
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfJ3JQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:16:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbfJ3JQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 05:16:47 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C0635D07DE9A63F65658;
        Wed, 30 Oct 2019 17:16:44 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 30 Oct 2019 17:16:36 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>
CC:     <ecree@solarflare.com>, <mhabets@solarflare.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH] sfc: should check the return value after allocating memory
Date:   Wed, 30 Oct 2019 17:12:45 +0800
Message-ID: <1572426765-43211-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kcalloc may fails to allocate memory, hence if it is in that case,
We should drop out in time.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/ethernet/sfc/efx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 2fef740..712380a 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -3040,6 +3040,8 @@ static int efx_init_struct(struct efx_nic *efx,
 	/* Failure to allocate is not fatal, but may degrade ARFS performance */
 	efx->rps_hash_table = kcalloc(EFX_ARFS_HASH_TABLE_SIZE,
 				      sizeof(*efx->rps_hash_table), GFP_KERNEL);
+	if (!efx->rps_hash_table)
+		goto fail;
 #endif
 	efx->phy_op = &efx_dummy_phy_operations;
 	efx->mdio.dev = net_dev;
-- 
1.7.12.4

