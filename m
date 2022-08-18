Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BF5598B26
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbiHRS34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244206AbiHRS3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:29:53 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C946B441D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:29:52 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id e15so3255656lfs.0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=5Z8GPpCKHwNJr7jDXVFuE6h8UWLWF6JkdRM56A4A+6o=;
        b=ClU6jSJEcC6POMvRy3eoa0i4bV+W/k6gXK1uG7E0AhIAJqIAXg7FSa1pDQu0oYkSzr
         04Hbbz9n7H+LE75uSB81Ma2C/2Rzais59z0xITPrsssh2AspMT5w0kRHO6YaZRguaI0q
         g8MSNntHluUxhVjufmfweiY0j1ez/d290LyO1IMcP5mqxsA3j1L+NSs6UiGksGwnyr+h
         XgRLwiy9pa43RRdyxcBBj9Ed3Zyg0elJQIbPTsZPb+wPRRZL2qiaBAsqe68/STa2Ib5/
         hPqShI0D9mIu1rdVd7VmXdW4s0wTSXVIewI0i1yvz/jh+bA0aywNgQsmhjTxBrKCGJlA
         X+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=5Z8GPpCKHwNJr7jDXVFuE6h8UWLWF6JkdRM56A4A+6o=;
        b=bBrhOzfl/LuPKmxKZ1HYHa6+XpPXDv8Vd4A4VhlfxQSxGqzTlWgFD9dd/I6pWGTHVf
         doJNTXCupaxk9DFXbdhBEcUvaI9gipdjB/bPPkaWubXJEAl0V5T4kQYH9g2X+o2kiut1
         cG8/dGfVbfuM66lbev5U1HWhJ5wS0Z3hdPQcK0C+Yv80nkvrh/06c+Z7VSfVgY4cOQEw
         yLUJiHF/pVPtF5L1eaY8vuh2W6y+hso7wpL5QB6dmGwxqnBH6xAM7Sc/9295WiwCYqVG
         oV3ram0ufjatSLdql11gf7kEkh4hqn5anu27mnfWF/M0f6hyS3oEndvyaMj7JjIgXpJe
         EuuQ==
X-Gm-Message-State: ACgBeo3/8w/WWVfc7xv/QW2X53NIJQDspQyOJz++A/913CUEOuHboz0u
        mUYmpgRSjvGCrQaM9YbVGPWncbcQ8kLNA6WK
X-Google-Smtp-Source: AA6agR7C6e0YeQk9gapG+V4CUOyqCncJ7KB0HfuacixmqpUAH2Xdt3529xnmqkKrEhL1A1eZhICowA==
X-Received: by 2002:a05:6512:3183:b0:48b:a2c9:2632 with SMTP id i3-20020a056512318300b0048ba2c92632mr1249176lfe.408.1660847391040;
        Thu, 18 Aug 2022 11:29:51 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:41e5:9890:65ed:5ae7])
        by smtp.gmail.com with ESMTPSA id bi19-20020a0565120e9300b00492c4d2fcbfsm133878lfb.115.2022.08.18.11.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 11:29:50 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH 1/2] net: moxa: do not call dma_unmap_single() with null
Date:   Thu, 18 Aug 2022 21:29:47 +0300
Message-Id: <20220818182948.931712-1-saproj@gmail.com>
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

It fixes a warning during error unwinding:

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

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index f11f1cb92025..edd1dab2ec43 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -77,8 +77,9 @@ static void moxart_mac_free_memory(struct net_device *ndev)
 	int i;
 
 	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
-				 priv->rx_buf_size, DMA_FROM_DEVICE);
+		if (priv->rx_mapping[i])
+			dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
+					 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
 		dma_free_coherent(&priv->pdev->dev,
-- 
2.32.0

