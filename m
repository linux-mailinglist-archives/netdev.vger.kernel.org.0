Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D848F6629FB
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbjAIPcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237198AbjAIPbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:44 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A968FEA;
        Mon,  9 Jan 2023 07:30:56 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 956E51648;
        Mon,  9 Jan 2023 16:30:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673278254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGv46D7gQHbV4r2vFEsGvofuAnLH9RGfLHYlLw3z8As=;
        b=PEgilRI8e8JgdbuJQlHSPKC7r/+jM46S7CttuPFSSJawqdOtgJyWhQdqSpjc8umRy7gM20
        kuLjsvumC9haW/kVQpCk5ytFhfPC5x3fT6OmUlYEhyHapN/wtI4W3pJBwjCVfwQMg3S4az
        O/R18+9lE3qitUNvrdOuZLWpBllChpF7m2J3BeDiweuvsbmNAgmCTu9wbs8SVq2QNAYKVp
        nHf7K7xdPsWLQilsfn67AhFXl1KDYorglkatvcyicKqJ0Imn40zokcPU4IhK9PPrxVtJOh
        lF3zavJWb/CV29dp/1kCYdmI/CDhu/licg2Tuv3oo5uwjcTIekVmJHwYljnppQ==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 09 Jan 2023 16:30:43 +0100
Subject: [PATCH net-next v3 03/11] net: mdio: mdiobus_register: update validation test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v3-3-ade1deb438da@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
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

Now that C45 uses its own read/write methods, the validation performed
when a bus is registers needs updating. All combinations of C22 and
C45 are supported, but both read and write methods must be provided,
read only busses are not supported etc.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - [al] be consistent with other checks
 - [mw] make the test a bit easier to read
v3:
 - [mw] use the original validation test style again but with double
   negation
---
 drivers/net/phy/mdio_bus.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index bde195864c17..c992a9fd8b01 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -526,8 +526,15 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	int i, err;
 	struct gpio_desc *gpiod;
 
-	if (NULL == bus || NULL == bus->name ||
-	    NULL == bus->read || NULL == bus->write)
+	if (!bus || !bus->name)
+		return -EINVAL;
+
+	/* An access method always needs both read and write operations */
+	if (!!bus->read != !!bus->write || !!bus->read_c45 != !!bus->write_c45)
+		return -EINVAL;
+
+	/* At least one method is mandatory */
+	if (!bus->read && !bus->read_c45)
 		return -EINVAL;
 
 	if (bus->parent && bus->parent->of_node)

-- 
2.30.2
