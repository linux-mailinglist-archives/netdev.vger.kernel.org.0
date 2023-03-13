Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75826B84F9
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjCMWm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCMWmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:42:55 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B15D7907BB;
        Mon, 13 Mar 2023 15:42:45 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id C7A5BE0EB3;
        Tue, 14 Mar 2023 01:42:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=E+SweRvzgDjVFlkaravB0VQvVr+lr/xjXdJLlqkPtRU=; b=Wr1rvYXKZAuE
        j6DQqmf5SLfAA2Pc3RJbB+0xULqdMJ7qZ7uqLZYKwuh3IYjonb6V7PfWMi+mph90
        wn1IdTZJHuaLYnG3D0fOMNiOGTBININL2TO/dcHkciSX15ERP9hOeTlhfvK67DAs
        jRLKtLkfGEhjQTi3Dv40RVUkkdZb12U=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id A57FAE0E6A;
        Tue, 14 Mar 2023 01:42:44 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:44 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 02/13] net: stmmac: Omit last desc flag for non-linear jumbos in chain-mode
Date:   Tue, 14 Mar 2023 01:42:26 +0300
Message-ID: <20230313224237.28757-3-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed similar to the ring mode we need not to set the LS flag in a Tx
DMA descriptor of the last chunk of the linear jumbo-SKB data if it's
supposed to have additional fragments attached. That buffers will be
used to initialized further Tx DMA descriptors later in the common
stmmac_rx() code. The LS flag will be set for the last of them then.

A similar fix has been introduced for the ring-mode in the
commit 58f2ce6f6161 ("net: stmmac: fix jumbo frame sending with
non-linear skbs"). But for some reason it hasn't been done for the
chained descriptors.

Fixes: 58f2ce6f6161 ("net: stmmac: fix jumbo frame sending with non-linear skbs")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
index 2e8744ac6b91..60e4fa5060ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
@@ -73,7 +73,8 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 			tx_q->tx_skbuff_dma[entry].len = len;
 			/* last descriptor can be set now */
 			stmmac_prepare_tx_desc(priv, desc, 0, len, csum,
-					STMMAC_CHAIN_MODE, 1, true, skb->len);
+					STMMAC_CHAIN_MODE, 1,
+					!skb_is_nonlinear(skb), skb->len);
 			len = 0;
 		}
 	}
-- 
2.39.2


