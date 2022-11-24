Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472CF63774E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiKXLQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiKXLQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:16:07 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D89C6F80D;
        Thu, 24 Nov 2022 03:16:04 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 43B231C0017;
        Thu, 24 Nov 2022 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669288563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MoXoOBgoqLKm04ioCway0yV4BL/d9ZBN4dkNElWwDRE=;
        b=n+x5z0mkgFB5Od5zIPKjH1Eu1g7DFQ646CwWPGzL0xEcxXi+vXEjpJV66KRx57uxmyJE4V
        yVg9wfM5aJNu30BckLlBZRKvc/tLP0QNw9XeO0N5JaNSfdXuFt/xXzefOCfP7srFumO2ss
        xAq2pY98HmHEQFV9CXJfJC0vhhUsWjN17X6woqtkKME54udjrs6YB5Q9We4oWKsjIkkI0+
        OPdWmc/CEtP9wA6TauNtLCTlgxjphIa8Y6mi6n9Lpk81Bzf80OrFnEPCLo74VzZ6b7Azzq
        WYZ1SW0UoDotxZOphbpkZ7tgjhA/i10IFAC2vNgcTrpfPeWWw3ee6o+pwBx0ZA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Marcin Wojtas <mw@semihalf.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 1/7] Revert "dt-bindings: marvell,prestera: Add description for device-tree bindings"
Date:   Thu, 24 Nov 2022 12:15:50 +0100
Message-Id: <20221124111556.264647-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124111556.264647-1-miquel.raynal@bootlin.com>
References: <20221124111556.264647-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 40acc05271abc2852c32622edbebd75698736b9b.

marvell,prestera.txt is an old file describing the old Alleycat3
standalone switches. The commit mentioned above actually hacked these
bindings to add support for a device tree property for a more modern
version of the IP connected over PCI, using only the generic compatible
in order to retrieve the device node from the prestera driver to read
one static property.

The problematic property discussed here is "base-mac-provider". The
original intent was to point to a nvmem device which could produce the
relevant nvmem-cell. This property has never been acked by DT
maintainers and fails all the layering that has been brought with the nvmem
bindings by pointing at a nvmem producer, bypassing the existing nvmem
bindings, rather than a nvmem cell directly. Furthermore, the property
cannot even be used upstream because it expected the ONIE tlv driver to
produce a specific cell, driver which used nacked bindings and thus was
never merged, replaced by a more integrated concept: the nvmem-layout.

So let's forget about this temporary addition, safely avoiding the need
for any backward compatibility handling. A new (yaml) binding file will
be brought with the prestera bindings, and there we will actually
include a description of the modern IP over PCI, including the right way
to point to a nvmem cell.

Cc: Vadym Kochan <vadym.kochan@plvision.eu>
Cc: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/marvell,prestera.txt         | 34 -------------------
 1 file changed, 34 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/Documentation/devicetree/bindings/net/marvell,prestera.txt
index e28938ddfdf5..83370ebf5b89 100644
--- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
+++ b/Documentation/devicetree/bindings/net/marvell,prestera.txt
@@ -45,37 +45,3 @@ dfx-server {
 	ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
 	reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
 };
-
-Marvell Prestera SwitchDev bindings
------------------------------------
-Optional properties:
-- compatible: must be "marvell,prestera"
-- base-mac-provider: describes handle to node which provides base mac address,
-	might be a static base mac address or nvme cell provider.
-
-Example:
-
-eeprom_mac_addr: eeprom-mac-addr {
-       compatible = "eeprom,mac-addr-cell";
-       status = "okay";
-
-       nvmem = <&eeprom_at24>;
-};
-
-prestera {
-       compatible = "marvell,prestera";
-       status = "okay";
-
-       base-mac-provider = <&eeprom_mac_addr>;
-};
-
-The current implementation of Prestera Switchdev PCI interface driver requires
-that BAR2 is assigned to 0xf6000000 as base address from the PCI IO range:
-
-&cp0_pcie0 {
-	ranges = <0x81000000 0x0 0xfb000000 0x0 0xfb000000 0x0 0xf0000
-		0x82000000 0x0 0xf6000000 0x0 0xf6000000 0x0 0x2000000
-		0x82000000 0x0 0xf9000000 0x0 0xf9000000 0x0 0x100000>;
-	phys = <&cp0_comphy0 0>;
-	status = "okay";
-};
-- 
2.34.1

