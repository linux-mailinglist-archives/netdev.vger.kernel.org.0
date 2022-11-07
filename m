Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE71961FE8E
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 20:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiKGT0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 14:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbiKGTZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 14:25:55 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB46E2AC73;
        Mon,  7 Nov 2022 11:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5ieiAxhifSMyQ4MxSnOsIKCi9Eh84IdHGfPjBjh2Hno=; b=fh+rYeK17i703PklQYs1GnZj8Y
        f5vZfagQdzCt9wXjqfxtHNlZIdAM53JDmm+IwWUapnaFa4G6gsdpTOpbgj6ZtC11spai+rqg8ir6l
        jNiDa95qAoAoe/9Ydlgi2YCvzf8hPn5twSqDAP+MxbLGHFG63nzZ9/RTqm8v68cWJXHU=;
Received: from p200300daa72ee1007849d74f78949f6c.dip0.t-ipconnect.de ([2003:da:a72e:e100:7849:d74f:7894:9f6c] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1os7HI-000LCc-Ht; Mon, 07 Nov 2022 19:55:24 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full
Date:   Mon,  7 Nov 2022 19:54:52 +0100
Message-Id: <20221107185452.90711-14-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107185452.90711-1-nbd@nbd.name>
References: <20221107185452.90711-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improves handling of DMA ring overflow.
Clarify other WDMA drop related comment.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 ++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 50756c8aa871..4bd06ab1a2b5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3529,9 +3529,12 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-		/* PSE should not drop port8 and port9 packets */
+		/* PSE should not drop port8 and port9 packets from WDMA Tx */
 		mtk_w32(eth, 0x00000300, PSE_DROP_CFG);
 
+		/* PSE should drop packets to port 8/9 on WDMA Rx ring full */
+		mtk_w32(eth, 0x00000300, PSE_PPE0_DROP);
+
 		/* PSE Free Queue Flow Control  */
 		mtk_w32(eth, 0x01fa01f4, PSE_FQFC_CFG2);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index bf8c7d11df9f..226022346369 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -124,6 +124,7 @@
 #define PSE_FQFC_CFG1		0x100
 #define PSE_FQFC_CFG2		0x104
 #define PSE_DROP_CFG		0x108
+#define PSE_PPE0_DROP		0x110
 
 /* PSE Input Queue Reservation Register*/
 #define PSE_IQ_REV(x)		(0x140 + (((x) - 1) << 2))
-- 
2.38.1

