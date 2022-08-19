Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE89599A51
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348465AbiHSLAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348462AbiHSLAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:00:40 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0F0F4C94
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:00:38 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id x25so4182471ljm.5
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=tSTH0dMQ3Hn7nnYYjfye4F+WniCFcDLaWnq76H1vgUs=;
        b=Occ5cQ0KLbQNgCdi1sZZEMwiBezl0+sUqSYtuskM0xG8mpLzRedxmv2uuE/qZi2sQx
         czEIc4U4vhBMt8SOANUKFYIKQoYnJnB3Lr4sutjC4k3ad7xW+lohlLZlMfSeKvWOaRnl
         2Cs178sZxgtgwIaSpLDw9h4bhlCyzIt6nvgJaDa+Jt+nj9KqRrTvfvRviYkexthuJ10W
         QrzL2uqh5c1j0HvNgvdENLy1XDJO2y/oYRvnMzR0Bk/RC1qQ/Va8bGzCxhwlZVzrwCGP
         /XQ0OQyke/a3ioucFlhT+Z2hEtNP0NxDRGALJuOIZkA7renW4tcT8/T8uYagxxkiBxY+
         Gd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=tSTH0dMQ3Hn7nnYYjfye4F+WniCFcDLaWnq76H1vgUs=;
        b=7s6GiojjNo3fTEdN4G3KHgeJce46WLaaghZKJ5BOVTz9L9gj0vIhRqQ3dJRv5U7l0X
         j8P/GQbjKfSX1DJPW2/cHhBDUHN0mZD2H3txcOQ70nKwGHM/3aewaZzPcH2CxaQts87n
         eFYWQQRm82eMIKyNZDjv8ifscX2W4aoQpKToHMy1qVzihYl///03Kt3Puh6PqGAKD+9k
         0BGZb/J5YQ5tN155s0JW0rBbUjb7+4+ZU1PCRGOX6PqRbVso30r8VMrBK0BN7JH8Jalw
         qyV6brD7iYM6+8B9DmRa+sBjaTk9N6V6NTqS0ndG5Gjo0IcLWyhpzrYuDFcqABNsZ1O5
         y/TQ==
X-Gm-Message-State: ACgBeo1UnTIDJqJ6itQvMnvoMZCfFl+cnxkXL1bUDYjHVwTxf9eR0caA
        FkzRyTKPdnV72E3KtzsKCS3YDGvjIszesQ==
X-Google-Smtp-Source: AA6agR62Rnctg/7nAJH6LkXAIgb54vjQOaSd8jPMZaVZwYiWNpZFp0VEYtoxCC6nrkJej7o4GoBGyA==
X-Received: by 2002:a2e:3316:0:b0:261:8a31:bdeb with SMTP id d22-20020a2e3316000000b002618a31bdebmr2144573ljc.45.1660906836916;
        Fri, 19 Aug 2022 04:00:36 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:420c:712e:ff27:3a07])
        by smtp.gmail.com with ESMTPSA id t2-20020a05651c204200b00261b9ccb18esm389095ljo.10.2022.08.19.04.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:00:36 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH] net: moxa: get rid of asymmetry in DMA mapping/unmapping
Date:   Fri, 19 Aug 2022 14:00:33 +0300
Message-Id: <20220819110033.1230475-1-saproj@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since priv->rx_mapping[i] is maped in moxart_mac_open(), we
should unmap it from moxart_mac_stop(). It fixes 2 warnings.

1. During error unwinding in moxart_mac_probe(): "goto init_fail;",
then moxart_mac_free_memory() calls dma_unmap_single() with
priv->rx_mapping[i] pointers zeroed.

WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:963 check_unmap+0x704/0x980
DMA-API: moxart-ethernet 92000000.mac: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=1600 bytes]
CPU: 0 PID: 1 Comm: swapper Not tainted 5.19.0+ #60
Hardware name: Generic DT based system
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x34/0x44
 dump_stack_lvl from __warn+0xbc/0x1f0
 __warn from warn_slowpath_fmt+0x94/0xc8
 warn_slowpath_fmt from check_unmap+0x704/0x980
 check_unmap from debug_dma_unmap_page+0x8c/0x9c
 debug_dma_unmap_page from moxart_mac_free_memory+0x3c/0xa8
 moxart_mac_free_memory from moxart_mac_probe+0x190/0x218
 moxart_mac_probe from platform_probe+0x48/0x88
 platform_probe from really_probe+0xc0/0x2e4

2. After commands:
 ip link set dev eth0 down
 ip link set dev eth0 up

WARNING: CPU: 0 PID: 55 at kernel/dma/debug.c:570 add_dma_entry+0x204/0x2ec
DMA-API: moxart-ethernet 92000000.mac: cacheline tracking EEXIST, overlapping mappings aren't supported
CPU: 0 PID: 55 Comm: ip Not tainted 5.19.0+ #57
Hardware name: Generic DT based system
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x34/0x44
 dump_stack_lvl from __warn+0xbc/0x1f0
 __warn from warn_slowpath_fmt+0x94/0xc8
 warn_slowpath_fmt from add_dma_entry+0x204/0x2ec
 add_dma_entry from dma_map_page_attrs+0x110/0x328
 dma_map_page_attrs from moxart_mac_open+0x134/0x320
 moxart_mac_open from __dev_open+0x11c/0x1ec
 __dev_open from __dev_change_flags+0x194/0x22c
 __dev_change_flags from dev_change_flags+0x14/0x44
 dev_change_flags from devinet_ioctl+0x6d4/0x93c
 devinet_ioctl from inet_ioctl+0x1ac/0x25c

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 19009a6bd33a..ff34dfd06ecc 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -71,11 +71,6 @@ static int moxart_set_mac_address(struct net_device *ndev, void *addr)
 static void moxart_mac_free_memory(struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
-	int i;
-
-	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
-				 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
 		dma_free_coherent(&priv->pdev->dev,
@@ -187,6 +182,7 @@ static int moxart_mac_open(struct net_device *ndev)
 static int moxart_mac_stop(struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
+	int i;
 
 	napi_disable(&priv->napi);
 
@@ -198,6 +194,11 @@ static int moxart_mac_stop(struct net_device *ndev)
 	/* disable all functions */
 	writel(0, priv->base + REG_MAC_CTRL);
 
+	/* unmap areas mapped in moxart_mac_setup_desc_ring() */
+	for (i = 0; i < RX_DESC_NUM; i++)
+		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
+				 priv->rx_buf_size, DMA_FROM_DEVICE);
+
 	return 0;
 }
 
@@ -560,7 +561,6 @@ static int moxart_mac_probe(struct platform_device *pdev)
 static int moxart_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
-
 	unregister_netdev(ndev);
 	devm_free_irq(&pdev->dev, ndev->irq, ndev);
 	moxart_mac_free_memory(ndev);
-- 
2.32.0

