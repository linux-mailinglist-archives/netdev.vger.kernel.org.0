Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D8466D356
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbjAPXw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbjAPXwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:52:50 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4E522A11;
        Mon, 16 Jan 2023 15:52:49 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D8A0816EA;
        Tue, 17 Jan 2023 00:52:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OmJ+9CmwjBTs3CG9j8tedbOIS1gGBtjDkwnDw2VO6LM=;
        b=eItgcFr83H0p1PU0iNChDNdiOgj8KhYJ8woVXKsLke+s9Qzn4YWii5eReEsBuleyYQt6qF
        zdB3j5sZRNRt7IYX77xPINY9PI563Domlhi3UUM6iYnR/7cJNfvw2qJ9K/pFln4/WldMhR
        KLEda5zh67qih83Ir652RtZkToIDVhs+vwYaXJQkzFrYdR4NRzGcjoj7o0P9BTVYD+HGzh
        e91HRJCCAaJRUCf8LXpvVLVkoVWluGPxBaeiv+On9tzW4vLvj/LrS/kvi4VC8xZIjuV/fH
        dq6rAn7Pjrjnz7XuZr3iXlIGBZFY2xdOTT7geNfbJloqNBU6E5xeHvWycz+NAw==
From:   Michael Walle <michael@walle.cc>
Date:   Tue, 17 Jan 2023 00:52:21 +0100
Subject: [PATCH net-next 06/12] ixgbe: Use C45 mdiobus accessors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-6-0c53afa56aad@walle.cc>
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

From: Andrew Lunn <andrew@lunn.ch>

When performing a C45 bus transaction, make use of the c45 variants of
the bus read/write helpers. The ability to pass a special register
value is being removed to clean up the mdio bus driver API.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..59f9d82ce532 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8937,7 +8937,8 @@ ixgbe_mdio_read(struct net_device *netdev, int prtad, int devad, u16 addr)
 		int regnum = addr;
 
 		if (devad != MDIO_DEVAD_NONE)
-			regnum |= (devad << 16) | MII_ADDR_C45;
+			return mdiobus_c45_read(adapter->mii_bus, prtad,
+						devad, regnum);
 
 		return mdiobus_read(adapter->mii_bus, prtad, regnum);
 	}
@@ -8960,7 +8961,8 @@ static int ixgbe_mdio_write(struct net_device *netdev, int prtad, int devad,
 		int regnum = addr;
 
 		if (devad != MDIO_DEVAD_NONE)
-			regnum |= (devad << 16) | MII_ADDR_C45;
+			return mdiobus_c45_write(adapter->mii_bus, prtad, devad,
+						 regnum, value);
 
 		return mdiobus_write(adapter->mii_bus, prtad, regnum, value);
 	}

-- 
2.30.2
