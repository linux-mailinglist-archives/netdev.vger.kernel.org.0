Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6762C3F3EAA
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 10:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbhHVInG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 04:43:06 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:20232 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhHVInF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 04:43:05 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d59 with ME
        id kYiN2500A3riaq203YiNcX; Sun, 22 Aug 2021 10:42:24 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Aug 2021 10:42:24 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tanghui20@huawei.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: sunhme: Remove unused macros
Date:   Sun, 22 Aug 2021 10:42:21 +0200
Message-Id: <2afbd92d52cc58c5b91d95782d144194ce1a5669.1629621681.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usage of these macros has been removed in commit db1a8611c873
("sunhme: Convert to pure OF driver."). So they can be removed.

This simplifies code and helps for removing the wrappers in
include/linux/pci-dma-compat.h.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 drivers/net/ethernet/sun/sunhme.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index a2c1a404c52d..62f81b0d14ed 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -251,14 +251,6 @@ static u32 pci_hme_read_desc32(hme32 *p)
 	((__hp)->write_txd((__txd), (__flags), (__addr)))
 #define hme_read_desc32(__hp, __p) \
 	((__hp)->read_desc32(__p))
-#define hme_dma_map(__hp, __ptr, __size, __dir) \
-	((__hp)->dma_map((__hp)->dma_dev, (__ptr), (__size), (__dir)))
-#define hme_dma_unmap(__hp, __addr, __size, __dir) \
-	((__hp)->dma_unmap((__hp)->dma_dev, (__addr), (__size), (__dir)))
-#define hme_dma_sync_for_cpu(__hp, __addr, __size, __dir) \
-	((__hp)->dma_sync_for_cpu((__hp)->dma_dev, (__addr), (__size), (__dir)))
-#define hme_dma_sync_for_device(__hp, __addr, __size, __dir) \
-	((__hp)->dma_sync_for_device((__hp)->dma_dev, (__addr), (__size), (__dir)))
 #else
 #ifdef CONFIG_SBUS
 /* SBUS only compilation */
@@ -277,14 +269,6 @@ do {	(__txd)->tx_addr = (__force hme32)(u32)(__addr); \
 	(__txd)->tx_flags = (__force hme32)(u32)(__flags); \
 } while(0)
 #define hme_read_desc32(__hp, __p)	((__force u32)(hme32)*(__p))
-#define hme_dma_map(__hp, __ptr, __size, __dir) \
-	dma_map_single((__hp)->dma_dev, (__ptr), (__size), (__dir))
-#define hme_dma_unmap(__hp, __addr, __size, __dir) \
-	dma_unmap_single((__hp)->dma_dev, (__addr), (__size), (__dir))
-#define hme_dma_sync_for_cpu(__hp, __addr, __size, __dir) \
-	dma_dma_sync_single_for_cpu((__hp)->dma_dev, (__addr), (__size), (__dir))
-#define hme_dma_sync_for_device(__hp, __addr, __size, __dir) \
-	dma_dma_sync_single_for_device((__hp)->dma_dev, (__addr), (__size), (__dir))
 #else
 /* PCI only compilation */
 #define hme_write32(__hp, __reg, __val) \
@@ -305,14 +289,6 @@ static inline u32 hme_read_desc32(struct happy_meal *hp, hme32 *p)
 {
 	return le32_to_cpup((__le32 *)p);
 }
-#define hme_dma_map(__hp, __ptr, __size, __dir) \
-	pci_map_single((__hp)->dma_dev, (__ptr), (__size), (__dir))
-#define hme_dma_unmap(__hp, __addr, __size, __dir) \
-	pci_unmap_single((__hp)->dma_dev, (__addr), (__size), (__dir))
-#define hme_dma_sync_for_cpu(__hp, __addr, __size, __dir) \
-	pci_dma_sync_single_for_cpu((__hp)->dma_dev, (__addr), (__size), (__dir))
-#define hme_dma_sync_for_device(__hp, __addr, __size, __dir) \
-	pci_dma_sync_single_for_device((__hp)->dma_dev, (__addr), (__size), (__dir))
 #endif
 #endif
 
-- 
2.30.2

