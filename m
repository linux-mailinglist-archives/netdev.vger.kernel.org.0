Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5278F88A1
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKLGfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:35:22 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:59262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbfKLGfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 01:35:22 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 56C3283795D75D7FDCD4;
        Tue, 12 Nov 2019 14:35:19 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Tue, 12 Nov 2019 14:35:08 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>,
        <grygorii.strashko@ti.com>, <tony@atomide.com>,
        <brouer@redhat.com>, <jakub.kicinski@netronome.com>,
        <ivan.khoronzhuk@linaro.org>, <tglx@linutronix.de>,
        <maowenan@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] net: ethernet: ti: Add dependency for TI_DAVINCI_EMAC
Date:   Tue, 12 Nov 2019 14:33:58 +0800
Message-ID: <20191112063358.73800-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If TI_DAVINCI_EMAC=y and GENERIC_ALLOCATOR is not set,
below erros can be seen:
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_desc_pool_destroy.isra.14':
davinci_cpdma.c:(.text+0x359): undefined reference to `gen_pool_size'
davinci_cpdma.c:(.text+0x365): undefined reference to `gen_pool_avail'
davinci_cpdma.c:(.text+0x373): undefined reference to `gen_pool_avail'
davinci_cpdma.c:(.text+0x37f): undefined reference to `gen_pool_size'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `__cpdma_chan_free':
davinci_cpdma.c:(.text+0x4a2): undefined reference to `gen_pool_free_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_chan_submit_si':
davinci_cpdma.c:(.text+0x66c): undefined reference to `gen_pool_alloc_algo_owner'
davinci_cpdma.c:(.text+0x805): undefined reference to `gen_pool_free_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_ctlr_create':
davinci_cpdma.c:(.text+0xabd): undefined reference to `devm_gen_pool_create'
davinci_cpdma.c:(.text+0xb79): undefined reference to `gen_pool_add_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_check_free_tx_desc':
davinci_cpdma.c:(.text+0x16c6): undefined reference to `gen_pool_avail'

This patch mades TI_DAVINCI_EMAC select GENERIC_ALLOCATOR.

Fixes: 99f629718272 ("net: ethernet: ti: cpsw: drop TI_DAVINCI_CPDMA config option")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 834afca3..137632b 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -22,6 +22,7 @@ config TI_DAVINCI_EMAC
 	depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 ) || COMPILE_TEST
 	select TI_DAVINCI_MDIO
 	select PHYLIB
+	select GENERIC_ALLOCATOR
 	---help---
 	  This driver supports TI's DaVinci Ethernet .
 
-- 
2.7.4

