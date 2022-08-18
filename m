Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB448598B24
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbiHRS35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345312AbiHRS34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:29:56 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19728AF49B
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:29:55 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id x19so3190377lfq.7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=PrI/uTUr8A7VJrv1eEkJYTbkSCqptusxjuQR2/FAlnc=;
        b=FDxRNdkTw5TAib3h4MX56uLywGOt21qCc5E97DJJo7BTbqe2wLozzhURmHTQdYMssV
         vxtCgPNiYF00nT8jBWO/Aja88nPjHK44w3TeybQSlavXE+ku0GmMARGs3lmoaM0gCmCs
         KgZHobhmJi3NDN4E8b840JFl7ZhjQIedxyj7Umx+7sTonsudOY9nAFEom3CGzOd1KAyf
         SReD6yjL6ws/TxfYKl6LXzo1Mt1A/0r2fL7w9BWd11p+cbnHCnozdPhdUTA+Y5NJwxBI
         4FhCx9RwAK/0PkWsgQkRkwBYb2b3UukudxHfIY1zV6Z7Bg3dX5V9m0RlB/ICWPRwW/4x
         4dHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=PrI/uTUr8A7VJrv1eEkJYTbkSCqptusxjuQR2/FAlnc=;
        b=dsZLhj5kUZBHer8ZQl5TWNqjJM4KeaIXsndAvFQT1Yuvif7wGPm3HoEdX8xCZE6awg
         zEa1CfwWY38DurUfbKyxqSqVdBH0HNOqkRNKIkWNnjrAaiA5jvoNPG/hNb5Xext5yLdA
         eVB6bEdNkdWjcPc0qxIexvSaF8VMJGutKPTw3W++qB5x7TGUJgCob0w7QaSUhZEj5qk1
         eqeUgRj3ifMBgCN349/p+Rf91sV9kGDFSJsJ/SRvboyXaSegDvEcRGsCBUwNHiMoVHdM
         hLC76jmKw03Xch68mxlpb9B/e8u1qvOL2WJFO1gaVDT6dvcBuWf8F/edY8l10rlQhpg5
         vdCQ==
X-Gm-Message-State: ACgBeo2N5XN2+8wuNwvaj5htaj0U3c8MyHnLOEBmB2LXEIcclssirYKW
        xnPIDX3LY69ZakZ21MTZUjQ8V80eWPLNvg+K
X-Google-Smtp-Source: AA6agR7F6bmMvJ86yh4reUoh/X+zHUXG0p+qrS4KLt5jmUCl0GMlDTpsZWHcoK+9Gie5tWjyit4qiw==
X-Received: by 2002:a05:6512:b99:b0:48b:2f0b:775 with SMTP id b25-20020a0565120b9900b0048b2f0b0775mr1412581lfv.217.1660847393225;
        Thu, 18 Aug 2022 11:29:53 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:41e5:9890:65ed:5ae7])
        by smtp.gmail.com with ESMTPSA id bi19-20020a0565120e9300b00492c4d2fcbfsm133878lfb.115.2022.08.18.11.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 11:29:52 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH 2/2] net: moxa: prevent double-mapping of DMA areas
Date:   Thu, 18 Aug 2022 21:29:48 +0300
Message-Id: <20220818182948.931712-2-saproj@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220818182948.931712-1-saproj@gmail.com>
References: <20220818182948.931712-1-saproj@gmail.com>
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

Fix the warning poping up after bringing the link down, then up:
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

Unmap RX memory areas in moxart_mac_stop(), so that moxart_mac_open()
will map them anew instead of double-mapping. To avoid code duplication,
create a new function moxart_mac_unmap_rx(). Nullify unmapped pointers to
prevent double-unmapping (ex: moxart_mac_stop(), then moxart_remove()).

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index edd1dab2ec43..22d0bf4a21e7 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -71,15 +71,23 @@ static int moxart_set_mac_address(struct net_device *ndev, void *addr)
 	return 0;
 }
 
-static void moxart_mac_free_memory(struct net_device *ndev)
+static void moxart_mac_unmap_rx(struct moxart_mac_priv_t *priv)
 {
-	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
 	int i;
 
 	for (i = 0; i < RX_DESC_NUM; i++)
-		if (priv->rx_mapping[i])
+		if (priv->rx_mapping[i]) {
 			dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
 					 priv->rx_buf_size, DMA_FROM_DEVICE);
+			priv->rx_mapping[i] = 0;
+		}
+}
+
+static void moxart_mac_free_memory(struct net_device *ndev)
+{
+	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
+
+	moxart_mac_unmap_rx(priv);
 
 	if (priv->tx_desc_base)
 		dma_free_coherent(&priv->pdev->dev,
@@ -205,6 +213,7 @@ static int moxart_mac_stop(struct net_device *ndev)
 	/* disable all functions */
 	writel(0, priv->base + REG_MAC_CTRL);
 
+	moxart_mac_unmap_rx(priv);
 	return 0;
 }
 
-- 
2.32.0

