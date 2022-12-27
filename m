Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869AB6570C5
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiL0XIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiL0XHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:43 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C22F8FC1;
        Tue, 27 Dec 2022 15:07:28 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 0BF7A1691;
        Wed, 28 Dec 2022 00:07:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bhgExHn/ar4TfzsxVA1DWmb/VXmvJMEz1zy1qxzkSM=;
        b=0BRwE3+CnQZBCkueooc1hgIlxrIo0V225AOr2XwrlQzWPJ8ugeR1BDPDeamA7dPiMF3K0L
        /X/SEQZVotNLcfcLXxD1873LIdC8taHCSWHIMC9YVTfIX5Au7z9DL3sBb1cDeTF2Thcc8M
        B3SV0iGKSP1k6BI8a6CExi7RIQd1FG5nCKzmcuFPl4PPV7ByXGS+uxrwK5bDgV4RjZNHuT
        7RTutdIP9lS65jHnOHgKOLG+AXCjTl33MypfVk5RqDVfFPu2kPRF88yPMC197dzrpcyuUY
        F/JvMQfaw1Yr77z2UPiPI6otSBkWBFJujTj7u/s3/ZDIwLsZ+yJa/CSAO26xxw==
From:   Michael Walle <michael@walle.cc>
Date:   Wed, 28 Dec 2022 00:07:18 +0100
Subject: [PATCH RFC net-next v2 02/12] net: pcs: pcs-xpcs: Use C45 MDIO API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-2-ddb37710e5a7@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
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

Convert the PCS-XPCS driver to make use of the C45 MDIO bus API for
modify_change().

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - [al] new patch
---
 drivers/net/pcs/pcs-xpcs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index f6a038a1d51e..bc428a816719 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -199,9 +199,7 @@ int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 static int xpcs_modify_changed(struct dw_xpcs *xpcs, int dev, u32 reg,
 			       u16 mask, u16 set)
 {
-	u32 reg_addr = mdiobus_c45_addr(dev, reg);
-
-	return mdiodev_modify_changed(xpcs->mdiodev, reg_addr, mask, set);
+	return mdiodev_c45_modify_changed(xpcs->mdiodev, dev, reg, mask, set);
 }
 
 static int xpcs_read_vendor(struct dw_xpcs *xpcs, int dev, u32 reg)

-- 
2.30.2
