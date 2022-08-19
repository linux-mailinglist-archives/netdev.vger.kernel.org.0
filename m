Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EA8599AC4
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348604AbiHSLGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348601AbiHSLFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:05:54 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39531FEC40
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:05:24 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t5so408375lfk.3
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=s/ZeXXVEUhVlm7w7CmXPrxbBAhrC1oXl78f1W6e8nX4=;
        b=O1pvDs1HPo+6FY4u7jSGXPVfrBLxDf8p6sH2PdLFaKruRjuCP1pfWn7RhtHC/zkAKf
         /bLeMuTbUwnaTjcfqZuCZaHBowE1CpCQlwgr8ainX0ec9EBieeXdJ45PvGtuHwyZmXIz
         nIylq+y/lCfbfQMGdetGTUCSZP/tqM5sXx8jUPdb7Kkxn7m6FO+YIN37KQ3Ltd81B9Au
         srJutIC81pgVNP7t2AbJ8zLb69WC6FXVoZt3kruVjMPwOeV0ISJKjoY7Fx07m5OW7SGt
         3VMSQ/DBS5gjnd/otg/6Wb0j4GgQUjIjBX5/IHAbanSk1RffaRmwGaax3Xmtj9hRtq6t
         rsvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=s/ZeXXVEUhVlm7w7CmXPrxbBAhrC1oXl78f1W6e8nX4=;
        b=BabiZjDPKaTAOfJxo0mZftrIS1svUXi4c8dxQBw+7+evoiz34QaenmZgzwUPadWSu/
         BRtR5pAwgA4K/UOHQNhIyHiFOw69KKBfcIxraoI7wbKpHRDznYHmwra/YzSJDKvImSLa
         Lk64mPfR99XzxDO72puyooiVfuuyLvBV46t5KzUuuS2RiDbkILnFBltvif02DR61XrG4
         h2tOAdxk5Ct3y+j0yC2EAbFnkJAUfj95/Y8kV6fEYy5ZgC2MJOb4z/iJdQLfz4WZXSO2
         Opsr8xCUzVUkd3Z0wojdidgHAQ1MVZqwzHiUTNPbtRSgpUVLJKWROEngc79ReO/b7aXh
         VKUA==
X-Gm-Message-State: ACgBeo3Ye6do3t+cLA4zOxi7iL7Ut5xYkLRbCYPOorYQLpYTHvRQgupe
        LS2UlEAmZne0wXmuSJoNubuHiv0vmauNBw==
X-Google-Smtp-Source: AA6agR5VrxxcuVisc19A2nkvEmUFgEH3gQQz2C12eziCNhHKh6tgFuZhukei7yUNtf9BNfdW7XDq8Q==
X-Received: by 2002:ac2:4e0f:0:b0:48b:7a5f:91c8 with SMTP id e15-20020ac24e0f000000b0048b7a5f91c8mr2477642lfr.430.1660907122290;
        Fri, 19 Aug 2022 04:05:22 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:420c:712e:ff27:3a07])
        by smtp.gmail.com with ESMTPSA id c24-20020a056512239800b00492b0723a96sm597751lfv.118.2022.08.19.04.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:05:21 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH v2] net: moxa: get rid of asymmetry in DMA mapping/unmapping
Date:   Fri, 19 Aug 2022 14:05:19 +0300
Message-Id: <20220819110519.1230877-1-saproj@gmail.com>
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
should unmap it from moxart_mac_stop(). Fixes 2 warnings.

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

v1 -> v2:
Extraneous change removed.

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 19009a6bd33a..9e57d23e57bf 100644
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
 
-- 
2.32.0

