Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801F32DF8F0
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 06:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgLUFpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 00:45:20 -0500
Received: from conuserg-11.nifty.com ([210.131.2.78]:48319 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgLUFpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 00:45:20 -0500
Received: from grover.flets-west.jp (softbank126090214151.bbtec.net [126.90.214.151]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 0BL5he2h002409;
        Mon, 21 Dec 2020 14:43:41 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 0BL5he2h002409
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1608529421;
        bh=e6mwI8FgifDUtyuo21tLkik32VJAE+v6rGZYzeQP2oA=;
        h=From:To:Cc:Subject:Date:From;
        b=jdLhyu2beAgKxb/AGLCuC6zovCCO/tcCQFsNzmh5hZOuomgMkJVmy0D25sZieipoy
         oVJ5Ibnkay/E2sp1z1mikMi8/M+Nu50FXDfLyq79dkKYBalgthKm2cXq4DoC+SDTWY
         gX+wnGApOFK5xOBmeTB0URnuijYknUQPE+3ijbtZdFmq7A91g1wEjuj7N0Gf6+O+/S
         KRizEHZ6VgmPU2C+C/zonk5CdlJVH+YVgKWKaOPcRYzj39lPjVxY54I5jVNa469mHV
         +hSQla2c4l6vMw4c/7hoI68MTChEpNG/gM3iTU4I8zf/YgBsCvh3wXy0cUJ67WbZrf
         RJe0lnv5ER2iw==
X-Nifty-SrcIP: [126.90.214.151]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] net: lantiq_etop: check the result of request_irq()
Date:   Mon, 21 Dec 2020 14:43:23 +0900
Message-Id: <20201221054323.247483-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The declaration of request_irq() in <linux/interrupt.h> is marked as
__must_check.

Without the return value check, I see the following warnings:

drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_hw_init':
drivers/net/ethernet/lantiq_etop.c:273:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
  273 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/lantiq_etop.c:281:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
  281 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 drivers/net/ethernet/lantiq_etop.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 2d0c52f7106b..960494f9752b 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -264,13 +264,18 @@ ltq_etop_hw_init(struct net_device *dev)
 	for (i = 0; i < MAX_DMA_CHAN; i++) {
 		int irq = LTQ_DMA_CH0_INT + i;
 		struct ltq_etop_chan *ch = &priv->ch[i];
+		int ret;
 
 		ch->idx = ch->dma.nr = i;
 		ch->dma.dev = &priv->pdev->dev;
 
 		if (IS_TX(i)) {
 			ltq_dma_alloc_tx(&ch->dma);
-			request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
+			ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
+			if (ret) {
+				netdev_err(dev, "failed to request irq\n");
+				return ret;
+			}
 		} else if (IS_RX(i)) {
 			ltq_dma_alloc_rx(&ch->dma);
 			for (ch->dma.desc = 0; ch->dma.desc < LTQ_DESC_NUM;
@@ -278,7 +283,11 @@ ltq_etop_hw_init(struct net_device *dev)
 				if (ltq_etop_alloc_skb(ch))
 					return -ENOMEM;
 			ch->dma.desc = 0;
-			request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
+			ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
+			if (ret) {
+				netdev_err(dev, "failed to request irq\n");
+				return ret;
+			}
 		}
 		ch->dma.irq = irq;
 	}
-- 
2.27.0

