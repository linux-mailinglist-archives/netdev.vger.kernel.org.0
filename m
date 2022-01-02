Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C89482ABC
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 11:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiABKXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 05:23:47 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:59285 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiABKXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 05:23:46 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 3y1dnH4CtFGqt3y1dntg15; Sun, 02 Jan 2022 11:23:45 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 02 Jan 2022 11:23:45 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     benve@cisco.com, _govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] enic: Remove usage of the deprecated "pci-dma-compat.h" API
Date:   Sun,  2 Jan 2022 11:23:39 +0100
Message-Id: <5080845d91e115300252298fe17fac5333458491.1641118952.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [1], Christoph Hellwig has proposed to remove the wrappers in
include/linux/pci-dma-compat.h.

Some reasons why this API should be removed have been given by Julia
Lawall in [2].

A coccinelle script has been used to perform the needed transformation
Only relevant parts are given below.

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

[1]: https://lore.kernel.org/kernel-janitors/20200421081257.GA131897@infradead.org/
[2]: https://lore.kernel.org/kernel-janitors/alpine.DEB.2.22.394.2007120902170.2424@hadrien/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/cisco/enic/enic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic.h b/drivers/net/ethernet/cisco/enic/enic.h
index c67a16a48d62..52aaf1bb5205 100644
--- a/drivers/net/ethernet/cisco/enic/enic.h
+++ b/drivers/net/ethernet/cisco/enic/enic.h
@@ -304,7 +304,7 @@ static inline bool enic_is_notify_intr(struct enic *enic, int intr)
 
 static inline int enic_dma_map_check(struct enic *enic, dma_addr_t dma_addr)
 {
-	if (unlikely(pci_dma_mapping_error(enic->pdev, dma_addr))) {
+	if (unlikely(dma_mapping_error(&enic->pdev->dev, dma_addr))) {
 		net_warn_ratelimited("%s: PCI dma mapping failed!\n",
 				     enic->netdev->name);
 		enic->gen_stats.dma_map_error++;
-- 
2.32.0

