Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72B05842F0
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiG1PUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiG1PUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:20:46 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C112F10553;
        Thu, 28 Jul 2022 08:20:45 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5757B2223A;
        Thu, 28 Jul 2022 17:20:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1659021644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fFIZqjl9Xdeou0OpLXOqWAWk/6YIgnLvQdwC0/Dd+kA=;
        b=c9bZrRryhARl4VvYznHahJwHAkssHnSxppxqzXpUo0vDDKYpYPITReS0Ir2w+PcaBOHolK
        suD158OeL9MLCdyWxDwqyo0zJwCmVu7Sqa9KNcu2Xkvyfgt01jJXFKb+2wPJ6RZO1g6OLg
        JqnUOcb4ULqO9Tmc8l7KKcsFfF5tqCM=
From:   Michael Walle <michael@walle.cc>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <mwalle@kernel.org>
Subject: [PATCH] wilc1000: fix DMA on stack objects
Date:   Thu, 28 Jul 2022 17:20:37 +0200
Message-Id: <20220728152037.386543-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <mwalle@kernel.org>

Sometimes wilc_sdio_cmd53() is called with addresses pointing to an
object on the stack. E.g. wilc_sdio_write_reg() will call it with an
address pointing to one of its arguments. Detect whether the buffer
address is not DMA-able in which case a bounce buffer is used. The bounce
buffer itself is protected from parallel accesses by sdio_claim_host().

Fixes: 5625f965d764 ("wilc1000: move wilc driver out of staging")
Signed-off-by: Michael Walle <mwalle@kernel.org>
---
The bug itself probably goes back way more, but I don't know if it makes
any sense to use an older commit for the Fixes tag. If so, please suggest
one.

The bug leads to an actual error on an imx8mn SoC with 1GiB of RAM. But the
error will also be catched by CONFIG_DEBUG_VIRTUAL:
[    9.817512] virt_to_phys used for non-linear address: (____ptrval____) (0xffff80000a94bc9c)

 .../net/wireless/microchip/wilc1000/sdio.c    | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 7962c11cfe84..e988bede880c 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -27,6 +27,7 @@ struct wilc_sdio {
 	bool irq_gpio;
 	u32 block_size;
 	int has_thrpt_enh3;
+	u8 *dma_buffer;
 };
 
 struct sdio_cmd52 {
@@ -89,6 +90,9 @@ static int wilc_sdio_cmd52(struct wilc *wilc, struct sdio_cmd52 *cmd)
 static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 {
 	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
+	bool need_bounce_buf = false;
+	u8 *buf = cmd->buffer;
 	int size, ret;
 
 	sdio_claim_host(func);
@@ -100,12 +104,20 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 	else
 		size = cmd->count;
 
+	if ((!virt_addr_valid(buf) || object_is_on_stack(buf)) &&
+	    !WARN_ON_ONCE(size > WILC_SDIO_BLOCK_SIZE)) {
+		need_bounce_buf = true;
+		buf = sdio_priv->dma_buffer;
+	}
+
 	if (cmd->read_write) {  /* write */
-		ret = sdio_memcpy_toio(func, cmd->address,
-				       (void *)cmd->buffer, size);
+		if (need_bounce_buf)
+			memcpy(buf, cmd->buffer, size);
+		ret = sdio_memcpy_toio(func, cmd->address, buf, size);
 	} else {        /* read */
-		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer,
-					 cmd->address,  size);
+		ret = sdio_memcpy_fromio(func, buf, cmd->address, size);
+		if (need_bounce_buf)
+			memcpy(cmd->buffer, buf, size);
 	}
 
 	sdio_release_host(func);
@@ -127,6 +139,12 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	if (!sdio_priv)
 		return -ENOMEM;
 
+	sdio_priv->dma_buffer = kzalloc(WILC_SDIO_BLOCK_SIZE, GFP_KERNEL);
+	if (!sdio_priv->dma_buffer) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
 	ret = wilc_cfg80211_init(&wilc, &func->dev, WILC_HIF_SDIO,
 				 &wilc_hif_sdio);
 	if (ret)
@@ -160,6 +178,7 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	irq_dispose_mapping(wilc->dev_irq_num);
 	wilc_netdev_cleanup(wilc);
 free:
+	kfree(sdio_priv->dma_buffer);
 	kfree(sdio_priv);
 	return ret;
 }
@@ -171,6 +190,7 @@ static void wilc_sdio_remove(struct sdio_func *func)
 
 	clk_disable_unprepare(wilc->rtc_clk);
 	wilc_netdev_cleanup(wilc);
+	kfree(sdio_priv->dma_buffer);
 	kfree(sdio_priv);
 }
 
-- 
2.30.2

