Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585D926F87F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgIRIi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:38:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40842 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726109AbgIRIi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 04:38:57 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 969FC7390C3D0E5E2409;
        Fri, 18 Sep 2020 16:38:54 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 16:38:45 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <fmanlunas@marvell.com>, <sburla@marvell.com>,
        <dchickles@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: ethernet: Remove set but not used variable
Date:   Fri, 18 Sep 2020 16:39:38 +0800
Message-ID: <20200918083938.21046-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/cavium/liquidio/octeon_device.c: In function lio_pci_readq:
drivers/net/ethernet/cavium/liquidio/octeon_device.c:1327:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/cavium/liquidio/octeon_device.c: In function lio_pci_writeq:
drivers/net/ethernet/cavium/liquidio/octeon_device.c:1358:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]

these variable is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
index ac32facaa427..fbde7c58c4db 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -1324,7 +1324,7 @@ u64 lio_pci_readq(struct octeon_device *oct, u64 addr)
 {
 	u64 val64;
 	unsigned long flags;
-	u32 val32, addrhi;
+	u32 addrhi;
 
 	spin_lock_irqsave(&oct->pci_win_lock, flags);
 
@@ -1339,10 +1339,10 @@ u64 lio_pci_readq(struct octeon_device *oct, u64 addr)
 	writel(addrhi, oct->reg_list.pci_win_rd_addr_hi);
 
 	/* Read back to preserve ordering of writes */
-	val32 = readl(oct->reg_list.pci_win_rd_addr_hi);
+	readl(oct->reg_list.pci_win_rd_addr_hi);
 
 	writel(addr & 0xffffffff, oct->reg_list.pci_win_rd_addr_lo);
-	val32 = readl(oct->reg_list.pci_win_rd_addr_lo);
+	readl(oct->reg_list.pci_win_rd_addr_lo);
 
 	val64 = readq(oct->reg_list.pci_win_rd_data);
 
@@ -1355,7 +1355,6 @@ void lio_pci_writeq(struct octeon_device *oct,
 		    u64 val,
 		    u64 addr)
 {
-	u32 val32;
 	unsigned long flags;
 
 	spin_lock_irqsave(&oct->pci_win_lock, flags);
@@ -1365,7 +1364,7 @@ void lio_pci_writeq(struct octeon_device *oct,
 	/* The write happens when the LSB is written. So write MSB first. */
 	writel(val >> 32, oct->reg_list.pci_win_wr_data_hi);
 	/* Read the MSB to ensure ordering of writes. */
-	val32 = readl(oct->reg_list.pci_win_wr_data_hi);
+	readl(oct->reg_list.pci_win_wr_data_hi);
 
 	writel(val & 0xffffffff, oct->reg_list.pci_win_wr_data_lo);
 
-- 
2.17.1

