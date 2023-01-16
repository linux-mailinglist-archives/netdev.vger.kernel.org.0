Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7F566BE77
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjAPM6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjAPM47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:56:59 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2081620059;
        Mon, 16 Jan 2023 04:55:45 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 12FAB16EC;
        Mon, 16 Jan 2023 13:55:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673873738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AmefAQEWD+GXbgOk3BMV9ynZkxYglIuiK7s798TPecY=;
        b=sLKvbJrI4kgqXVv0pEyIqGsNsTL/zk7yE0HThyFFkMmz/0rL8L46ETSp/M2C0OK5DLoXWT
        hIZ5SC4WG761f39d6rCOdGeKQX6iOI5FJp0GUBhh5L1nRnI/5bZbFJw/myihMni8gH/jyz
        hWsb962vtJC7Uof5rECX095OR++UDFZnmcNWvPM2WM4T7frVlwzFjAY0HafVGNTVYH6eIa
        9odv6m9nZ3CVvnGVh+x8ybF5zJAvxIiaBwMrs6o1/lItG+yZCcHPSsF8YXi7ENJArrdPx9
        XtMC2MoIHkjkhaTJrsB+UC+OY6qqAW/BSZhNftyh8yjqV+XOvVJx+yF/uOJBOA==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 16 Jan 2023 13:55:17 +0100
Subject: [PATCH net-next 5/6] net: phy: Decide on C45 capabilities based on
 presence of method
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-remove-probe-capabilities-v1-5-5aa29738a023@walle.cc>
References: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Some PHYs provide invalid IDs in C22 space. If C45 is supported on the
bus an attempt can be made to get the IDs from the C45 space. Decide
on this based on the presence of the C45 read method in the bus
structure. This will allow the unreliable probe_capabilities to be
removed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0d371a0a49f2..9ba8f973f26f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -946,7 +946,7 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	 * probe with C45 to see if we're able to get a valid PHY ID in the C45
 	 * space, if successful, create the C45 PHY device.
 	 */
-	if (!is_c45 && phy_id == 0 && bus->probe_capabilities >= MDIOBUS_C45) {
+	if (!is_c45 && phy_id == 0 && bus->read_c45) {
 		r = get_phy_c45_ids(bus, addr, &c45_ids);
 		if (!r)
 			return phy_device_create(bus, addr, phy_id,

-- 
2.30.2
