Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD10D607D74
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiJURYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJURYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:24:34 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1673A1146E
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 10:24:31 -0700 (PDT)
Received: from jupiter.universe (dyndsl-037-138-189-087.ewe-ip-backbone.de [37.138.189.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 4A5CD660226D;
        Fri, 21 Oct 2022 18:24:30 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666373070;
        bh=gen1/fy7A3678eOhQrY2FyxvyBfzVMxM5cZuLTNcfxg=;
        h=From:To:Cc:Subject:Date:From;
        b=WjH72eSkpt6cPaaqKOfkiCfZm7nCxegMsTCW4cpKg6l6+touZvz/t+QIYEqZ8U55v
         /AsRiUhqMzGkF7hLjPZfKzKhK1IqmLf/FNRwprDVYXDDMBXW1kjwkv70RuKQHM8W+p
         NWKYtRT8TP/WbJWq0do1BKrDdqdID2TchoByABezEq8QhRnxmSTGlHQaRnw/YcnMCO
         D/kKAU/1SGVU8b8xxwDLzT0ojAEYv5YsRJ7XxbFBAnur5lt7TXnKqth4GV0Z9RhOSk
         PZTdrDdRCg5EsMNnMmk4V2FhR3dEeJV/t6d0YDVU8R9Es6KgoChvEVyXBS1noI8fZo
         Tj3x+DlPUNAUw==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 6E72148082E; Fri, 21 Oct 2022 19:24:28 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        kernel@collabora.com,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 1/1] net: stmmac: rk3588: Allow multiple gmac controller
Date:   Fri, 21 Oct 2022 19:24:22 +0200
Message-Id: <20221021172422.88534-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

RK3588(s) can have multiple gmac controllers.
Re-use rk3568 logic to distinguish them.

Fixes: 2f2b60a0ec28 ("net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
This is required to access gmac1, which is the only existing controller
in the rk3588s (slim variant of rk3588).
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index f7269d79a385..6656d76b6766 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1243,6 +1243,12 @@ static const struct rk_gmac_ops rk3588_ops = {
 	.set_rgmii_speed = rk3588_set_gmac_speed,
 	.set_rmii_speed = rk3588_set_gmac_speed,
 	.set_clock_selection = rk3588_set_clock_selection,
+	.regs_valid = true,
+	.regs = {
+		0xfe1b0000, /* gmac0 */
+		0xfe1c0000, /* gmac1 */
+		0x0, /* sentinel */
+	},
 };
 
 #define RV1108_GRF_GMAC_CON0		0X0900
-- 
2.35.1

