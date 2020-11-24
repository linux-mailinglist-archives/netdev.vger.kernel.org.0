Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD27B2C1E27
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 07:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgKXGYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 01:24:33 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8392 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728586AbgKXGYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 01:24:33 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CgDWJ1Wk4z6vQq;
        Tue, 24 Nov 2020 14:24:12 +0800 (CST)
Received: from euler.huawei.com (10.175.124.27) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 14:24:21 +0800
From:   Wei Li <liwei391@huawei.com>
To:     Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Timur Tabi <timur@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
CC:     <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH] net: fs_enet: Fix incorrect IS_ERR_VALUE macro usages
Date:   Tue, 24 Nov 2020 14:24:09 +0800
Message-ID: <20201124062409.1142-1-liwei391@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IS_ERR_VALUE macro should be used only with unsigned long type.
Especially it works incorrectly with unsigned shorter types on
64bit machines.

Fixes: 976de6a8c304 ("fs_enet: Be an of_platform device when CONFIG_PPC_CPM_NEW_BINDING is set.")
Fixes: 4c35630ccda5 ("[POWERPC] Change rheap functions to use ulongs instead of pointers")
Signed-off-by: Wei Li <liwei391@huawei.com>
---
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c | 2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
index b47490be872c..e2117ad46130 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
@@ -107,7 +107,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 
 	fep->fcc.mem = (void __iomem *)cpm2_immr;
 	fpi->dpram_offset = cpm_dpalloc(128, 32);
-	if (IS_ERR_VALUE(fpi->dpram_offset)) {
+	if (IS_ERR_VALUE((unsigned long)(int)fpi->dpram_offset)) {
 		ret = fpi->dpram_offset;
 		goto out_fcccp;
 	}
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
index 64300ac13e02..90f82df0b1bb 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
@@ -136,7 +136,7 @@ static int allocate_bd(struct net_device *dev)
 
 	fep->ring_mem_addr = cpm_dpalloc((fpi->tx_ring + fpi->rx_ring) *
 					 sizeof(cbd_t), 8);
-	if (IS_ERR_VALUE(fep->ring_mem_addr))
+	if (IS_ERR_VALUE((unsigned long)(int)fep->ring_mem_addr))
 		return -ENOMEM;
 
 	fep->ring_base = (void __iomem __force*)
-- 
2.17.1

