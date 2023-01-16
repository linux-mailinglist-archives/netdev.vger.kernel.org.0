Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4831366D366
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbjAPXx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbjAPXxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:53:16 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1829D22DE8;
        Mon, 16 Jan 2023 15:52:52 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 377561AA3;
        Tue, 17 Jan 2023 00:52:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VAC3lvYePixzcXebo4E3nrWp2H/ZNlz8TyV8NSReGQs=;
        b=GX7X6H8lc5xEN2+bG0vGPNrbHpUIAQOgt5cogS4U1N7qThjjN2kBzzYQp/8KzT84ti0igo
        xSB7LtanZuOWOoFLF//R6xu0DEVnKAgh2gmiPE8/wZoeTLTCRdhRpTvFILbtntC9hLuBLj
        CnLtT1FJ5lt9YoGY5oDs0zZjipTZSuzptW13uvMVmynj6dYqNfnd42XKFSNgMGotGTUKE8
        BXzciw/3UQuIntlC/9InYkjZ7/KD6wG+fCP+B75yawvNq2My4riw29+tbN+fKgvqe1mdeQ
        IY10rHas3nLp7tewG0aHGrt5ZwAbQkMfxwLieYn3rr2+MYMWJ09/jxb5QTziBA==
From:   Michael Walle <michael@walle.cc>
Date:   Tue, 17 Jan 2023 00:52:27 +0100
Subject: [PATCH net-next 12/12] net: ethernet: renesas: rswitch: C45 only transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-12-0c53afa56aad@walle.cc>
References: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
In-Reply-To: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Byungho An <bh74.an@samsung.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
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

The rswitch MDIO bus driver only supports C45 transfers. Update the
function names to make this clear, pass the mmd as a parameter, and
register the accessors to the _c45 ops of the bus driver structure.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/renesas/rswitch.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 6441892636db..885fdb077b62 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1024,34 +1024,18 @@ static int rswitch_etha_set_access(struct rswitch_etha *etha, bool read,
 	return ret;
 }
 
-static int rswitch_etha_mii_read(struct mii_bus *bus, int addr, int regnum)
+static int rswitch_etha_mii_read_c45(struct mii_bus *bus, int addr, int devad,
+				     int regad)
 {
 	struct rswitch_etha *etha = bus->priv;
-	int mode, devad, regad;
-
-	mode = regnum & MII_ADDR_C45;
-	devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
-	regad = regnum & MII_REGADDR_C45_MASK;
-
-	/* Not support Clause 22 access method */
-	if (!mode)
-		return -EOPNOTSUPP;
 
 	return rswitch_etha_set_access(etha, true, addr, devad, regad, 0);
 }
 
-static int rswitch_etha_mii_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+static int rswitch_etha_mii_write_c45(struct mii_bus *bus, int addr, int devad,
+				      int regad, u16 val)
 {
 	struct rswitch_etha *etha = bus->priv;
-	int mode, devad, regad;
-
-	mode = regnum & MII_ADDR_C45;
-	devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
-	regad = regnum & MII_REGADDR_C45_MASK;
-
-	/* Not support Clause 22 access method */
-	if (!mode)
-		return -EOPNOTSUPP;
 
 	return rswitch_etha_set_access(etha, false, addr, devad, regad, val);
 }
@@ -1142,8 +1126,8 @@ static int rswitch_mii_register(struct rswitch_device *rdev)
 	mii_bus->name = "rswitch_mii";
 	sprintf(mii_bus->id, "etha%d", rdev->etha->index);
 	mii_bus->priv = rdev->etha;
-	mii_bus->read = rswitch_etha_mii_read;
-	mii_bus->write = rswitch_etha_mii_write;
+	mii_bus->read_c45 = rswitch_etha_mii_read_c45;
+	mii_bus->write_c45 = rswitch_etha_mii_write_c45;
 	mii_bus->parent = &rdev->priv->pdev->dev;
 
 	mdio_np = rswitch_get_mdio_node(rdev);

-- 
2.30.2
