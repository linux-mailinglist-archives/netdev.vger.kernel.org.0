Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B018A52BE8C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbiEROzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238851AbiEROy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:54:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806C81DB5B2
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QjWvAe5dEJjDyoC2IMky/s17OubBaU/he0qgyWdmoIY=; b=xDIA531rdMo7wiVGuMBBYa7d/s
        2hTgCuBON9Pzm3OOb2m3W8cCrZUumR66E9OSUtUMbq6U5naEswsCwoMqITAA/yUiuMk17qvUUQw9v
        bc0d3eKvVXlZkUOOgYm0xw7DsI1DNARpz7yZKy1U7qnJhIbltG91U4TshnkSK6haJYSSy3136HB2M
        Hw7sLp1A/mvWaO9MFt6aBiApQNE4CaHQaK7HvSoWls5a8DF4Qihgs2Tu5+1VMh6i/cKwE0DK3EoIK
        Vkjl2nidkC3uc5P8y8c9J9MDHMsaIqty395M+KZLfGspEG01EfEfFegitrcZpnBkFVJzDn2vXQb6g
        BBk7K7bg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38612 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nrL4U-0002E9-5Y; Wed, 18 May 2022 15:54:42 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nrL4U-00AM4q-2X; Wed, 18 May 2022 15:54:42 +0100
In-Reply-To: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
References: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 03/12] net: mtk_eth_soc: add mask and update PCS
 speed definitions
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nrL4U-00AM4q-2X@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 May 2022 15:54:42 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PCS speed setting is a two bit field, but it is defined as two
separate bits. Add a bitfield mask for the speed definitions, an
 use the FIELD_PREP() macro to define each PCS speed.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 085f53d23f25..4f97195159f3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -17,6 +17,7 @@
 #include <linux/phylink.h>
 #include <linux/rhashtable.h>
 #include <linux/dim.h>
+#include <linux/bitfield.h>
 #include "mtk_ppe.h"
 
 #define MTK_QDMA_PAGE_SIZE	2048
@@ -493,9 +494,10 @@
 #define SGMSYS_SGMII_MODE		0x20
 #define SGMII_IF_MODE_BIT0		BIT(0)
 #define SGMII_SPEED_DUPLEX_AN		BIT(1)
-#define SGMII_SPEED_10			0x0
-#define SGMII_SPEED_100			BIT(2)
-#define SGMII_SPEED_1000		BIT(3)
+#define SGMII_SPEED_MASK		GENMASK(3, 2)
+#define SGMII_SPEED_10			FIELD_PREP(SGMII_SPEED_MASK, 0)
+#define SGMII_SPEED_100			FIELD_PREP(SGMII_SPEED_MASK, 1)
+#define SGMII_SPEED_1000		FIELD_PREP(SGMII_SPEED_MASK, 2)
 #define SGMII_DUPLEX_FULL		BIT(4)
 #define SGMII_IF_MODE_BIT5		BIT(5)
 #define SGMII_REMOTE_FAULT_DIS		BIT(8)
-- 
2.30.2

