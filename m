Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C592309B0B
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhAaH7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhAaH4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:56:08 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9234EC061573
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:55:21 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id j12so9417685pfj.12
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7uaxEmHwj7AQ7ZFWM2mecUlQzLzTculEaiCDusTlzfA=;
        b=HvxK2tws2puLxYPGhLTbJtYGsfNhPXEx1aCT0bUEZ/7D7T/Z0cHvCi9go24Fd8XXT+
         ps64m3GUINCLWJF4krjqsjdUGiQnxMEfAdVWUwUrxvqd3PBLgewN9B4eit4Bn7t18Aeq
         mDcpH7GEA0fwkZ6glLLtsCh2e8JJQh/CSnm4iZTkEIJbNuDcRnc8UA6hMDQIEExQjaET
         mcuVqSEjP1amd2VtRx4xX4dp80O8nCMBErh2F96XYCkiqa4Os8lNH2bxscMKnID6pMWD
         aPVG/Y98oKk+H7M05sjzCIEHayETcY5aATGK9BXJeI7Ld/ntGtAtQXTCW9N7oKu9XBRF
         Voqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7uaxEmHwj7AQ7ZFWM2mecUlQzLzTculEaiCDusTlzfA=;
        b=uP7JJAvxSZui4wS9pkXteqA8R3rcCREYZqZsTt6kMPirKa2S/1kMqRLTWOn1LfdokL
         uAeHB0/sHs5Y7tbIgru5r4fBfeWqNKS6L9QCu7ISQd6xRPRbDwtUolZ1GkZlWvX6FBev
         ZBrTqdkjjlXP37yMij7QmN9yOogTc7jc8va6brTzqUqo0F+D1YZO4RcdW7QshJJuXcl2
         PxYFCyiDdUWo+SdAP5OMY7EZKJ7wRyOtOSI0hHqIepfI3BhMaaYjLIg9lKP922o5O9Un
         yW/8SWmMeZz4JdXanIdt1YSUZf1x6H87qoi3UnkgqgGzLRHRK6+ZU+UfEWyLVl4HjA4G
         Taug==
X-Gm-Message-State: AOAM5338G8VoD0kBBBegKRDmTVt71/x+EdA5tBC6D5vsLYitVxwEhACb
        56BO2r7N1AkgmAKyKLyb5V4=
X-Google-Smtp-Source: ABdhPJwH/9TkW305yU9gVnOPFQI9Yrk2JECGQSO0Lry4AdJ38YBcdqaphPMsSKknjXan5l18QIVO0w==
X-Received: by 2002:aa7:9f5d:0:b029:1c5:b700:a59c with SMTP id h29-20020aa79f5d0000b02901c5b700a59cmr11628910pfr.74.1612079721209;
        Sat, 30 Jan 2021 23:55:21 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id h23sm13931290pgh.64.2021.01.30.23.55.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Jan 2021 23:55:20 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [PATCH net-next v2 4/4] net: dpaa2: Use napi_alloc_frag_align() to avoid the memory waste
Date:   Sun, 31 Jan 2021 15:44:26 +0800
Message-Id: <20210131074426.44154-5-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210131074426.44154-1-haokexin@gmail.com>
References: <20210131074426.44154-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_alloc_frag_align() will guarantee that a correctly align
buffer address is returned. So use this function to simplify the buffer
alloc and avoid the unnecessary memory waste.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
v2: No change.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 41e225baf571..882b32a04f5e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -764,12 +764,11 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 	/* Prepare the HW SGT structure */
 	sgt_buf_size = priv->tx_data_offset +
 		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
-	sgt_buf = napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
+	sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
 	if (unlikely(!sgt_buf)) {
 		err = -ENOMEM;
 		goto sgt_buf_alloc_failed;
 	}
-	sgt_buf = PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
 	memset(sgt_buf, 0, sgt_buf_size);
 
 	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
-- 
2.29.2

