Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA2C347641
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhCXKhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233524AbhCXKgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:36:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F47619FB;
        Wed, 24 Mar 2021 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616582195;
        bh=sAWXXg1sOTQ3susDlTKm6scF3n+aU9DBk5jYc6+G7MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9dUStdo1tt1JA6wXidItI2BdsZ6MuPoLufQsgkV47/8VS1hEBiKNr78hPFmOWQUP
         cqI5/vJpT39xA7+viaJv+vpA9UhYGdab5Oe9eYKdYxNmKmzDezuL3TxaD1MBJRPnrT
         NHjqsNueH6rLUbc6JlqZ7AShK4XFdKH0iwnNPfzNefmQGhtJDYMT8U5UFf4F0wIqZs
         XdTCFeDp4lhrmhXw7rcw+qwYiuAQysu0OzOjbp+n/3Nka64htwovyGPWK78Cf/f4dQ
         ZxvF7AYvRV4mEjsnUt52wdU8gDA5ELtPGKv9iOI4e/vyXPZ+pus+JWm/SjRTHyRtzl
         Jh+cqoqLBFdGg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/2] dt-bindings: ethernet-phy: define `supported-mac-connection-types` property
Date:   Wed, 24 Mar 2021 11:35:56 +0100
Message-Id: <20210324103556.11338-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324103556.11338-1-kabel@kernel.org>
References: <20210324103556.11338-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An ethernet PHY may support PHY interface modes that are not wired on a
specific board (or are broken for some other reason).

For example the Marvell 88X3310 PHY supports connecting the MAC with the
PHY with `xaui` and `rxaui`, the MAC can also support these modes, but
it is possible for a board not to have them wired (since these modes use
multiple SerDes lanes).

In order for the kernel to know which modes are supported on the board,
we need to specify them in the device tree.

Define a new ethernet PHY property `supported-mac-connection-types`,
which lists the supported modes. If this property is missing, all modes
supported by the PHY and MAC are presumed to be supported by the board.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../devicetree/bindings/net/ethernet-phy.yaml  | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 2766fe45bb98..3706760b5637 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -136,6 +136,23 @@ properties:
       used. The absence of this property indicates the muxers
       should be configured so that the external PHY is used.
 
+  supported-mac-connection-types:
+    $ref: "ethernet-controller.yaml#/$defs/phy-connection-type-array"
+    description:
+      The PHY device may support different interface types for
+      connecting the Ethernet MAC device to the PHY device (i.e.
+      rgmii, sgmii, xaui, ...), but not all of these interface
+      types must necessarily be supported for a specific board
+      (not all of them are wired, or there may be some known bug
+      for a specific mode, ...).
+      This property specifies a list of interface modes to the
+      MAC supported by the PHY hardware that are also supported
+      by the board.
+      If this property is missing, all modes supported by the
+      PHY are presumend to be supported by the board.
+    minItems: 1
+    maxItems: 64
+
   resets:
     maxItems: 1
 
@@ -196,5 +213,6 @@ examples:
             reset-gpios = <&gpio1 4 1>;
             reset-assert-us = <1000>;
             reset-deassert-us = <2000>;
+            supported-mac-connection-types = "xaui", "rxaui";
         };
     };
-- 
2.26.2

