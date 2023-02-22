Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70F369ED67
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjBVDS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjBVDSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:18:54 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF4120D1A;
        Tue, 21 Feb 2023 19:18:13 -0800 (PST)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 295E185911;
        Wed, 22 Feb 2023 04:17:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1677035864;
        bh=/wkBfCiDB2H+8jQXuE/Wg7h5jRHBQLfIUesCiVu6w1s=;
        h=From:To:Cc:Subject:Date:From;
        b=KF8fJ5cr8nPWJMzphqAIj/vUElnXd1igzS9U63PYu7xYIlCEQ2wSmfDACzMNc/2dG
         oYg3sFlDg7wCJDZuIOCneulA5+8WpdTjmB4TQUuGtpgnPv4ZmfIFKSy0rCmwYSwRNy
         0fWMHWMmOEb25jcUxDM3uG7Ac/aBd7qYylDsaYUm6bz2jLXNtvnJ96WeHkM5Dsm42O
         eYmGkQDEWCkF5IyPBccTC7SM5Djw0beaIqLHPDhrzhj//nDRtTnEOJ77hg6tlHzDBc
         ZisXKQUSoUx4Hs4D5PS2tXQeI+j022D3VUQiP5GQURNonP3zyaE7XKNSVMwo7nOv+R
         v8AAncsyaRt1g==
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: [PATCH] net: dsa: microchip: Fix gigabit set and get function for KSZ87xx
Date:   Wed, 22 Feb 2023 04:17:38 +0100
Message-Id: <20230222031738.189025-1-marex@denx.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per KSZ8794 [1] datasheet DS00002134D page 54 TABLE 4-4: PORT REGISTERS,
it is Register 86 (0x56): Port 4 Interface Control 6 which contains the
Is_1Gbps field.

Currently, the driver uses PORT read function on register P_XMII_CTRL_1
to access the P_GMII_1GBIT_M, i.e. Is_1Gbps, bit. The problem is, the
register P_XMII_CTRL_1 address is already 0x56, which is the converted
PORT register address instead of the offset within PORT register space
that PORT read function expects and converts into the PORT register
address internally. The incorrectly double-converted register address
becomes 0xa6, which is what the PORT read function ultimatelly accesses,
and which is a non-existent register on the KSZ8794/KSZ8795 .

The correct value for P_XMII_CTRL_1 is 0x6, which gets converted into
port address 0x56, which is Register 86 (0x56): Port 4 Interface Control 6
per KSZ8794 datasheet, i.e. the correct register address.

To make this worse, there are multiple other call sites which read and
even write the P_XMII_CTRL_1 register, one of them is ksz_set_xmii(),
which is responsible for configuration of RGMII delays. These delays
are incorrectly configured and a non-existent register is written
without this change.

Fix the P_XMII_CTRL_1 register offset to resolve these problems.

[1] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/KSZ8794CNX-Data-Sheet-DS00002134.pdf

Fixes: 46f80fa8981b ("net: dsa: microchip: add common gigabit set and get function")
Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Arun Ramadoss <arun.ramadoss@microchip.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: UNGLinuxDriver@microchip.com
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: stable@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 729b36eeb2c46..7fc2155d93d6e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -319,7 +319,7 @@ static const u16 ksz8795_regs[] = {
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
 	[P_XMII_CTRL_0]			= 0x06,
-	[P_XMII_CTRL_1]			= 0x56,
+	[P_XMII_CTRL_1]			= 0x06,
 };
 
 static const u32 ksz8795_masks[] = {
-- 
2.39.1

