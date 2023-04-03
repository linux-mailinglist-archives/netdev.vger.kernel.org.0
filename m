Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8205A6D3B52
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 03:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjDCBR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 21:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjDCBR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 21:17:26 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7465BB2;
        Sun,  2 Apr 2023 18:17:25 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pj8p1-0004fx-1g;
        Mon, 03 Apr 2023 03:17:23 +0200
Date:   Mon, 3 Apr 2023 02:17:19 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next v2 01/14] net: dsa: mt7530: make some noise if
 register read fails
Message-ID: <67c4fd130d34a197660cf0ed321c1323f8901296.1680483896.git.daniel@makrotopia.org>
References: <cover.1680483895.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680483895.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simply returning the negative error value instead of the read value
doesn't seem like a good idea. Return 0 instead and add WARN_ON_ONCE(1)
so this kind of error will not go unnoticed.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mt7530.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a0d99af897ace..18d4aa6bb9968 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -224,9 +224,10 @@ mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
 	/* MT7530 uses 31 as the pseudo port */
 	ret = bus->write(bus, 0x1f, 0x1f, page);
 	if (ret < 0) {
+		WARN_ON_ONCE(1);
 		dev_err(&bus->dev,
 			"failed to read mt7530 register\n");
-		return ret;
+		return 0;
 	}
 
 	lo = bus->read(bus, 0x1f, r);
-- 
2.40.0

