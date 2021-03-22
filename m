Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91813345045
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhCVTvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230358AbhCVTuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 15:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ECBD61934;
        Mon, 22 Mar 2021 19:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616442634;
        bh=fUkAvUEnpGs/liXmslPmPf6wYjnwcEdyGtAIoM2gdUQ=;
        h=From:To:Cc:Subject:Date:From;
        b=rL1dolayHEwYBnzrtQL4Cu6iuawqzTyvCsH5KqarIVAkOR9WI6GN93GzOwof4GNIc
         aJcQjHEX/0jZqwvqvdGprc9Cxef9EGW5Hd++mGkv4VvFM3c4bM1cUTwii64/GyGise
         7vBauPjxuX8Kuun5WLfQeS404EKcAngsnmrkL6DqJZNoXrWWj7RMBfcZtv5awtqpGj
         XzJQ6CHzNtxxMaLKI2FWGZSspDq8EZMX/go3crIE/sxje1inHf7oRRxZ8VUlJWbW/3
         fxpqZzxdiHOGw63nPK5zCyVB3MiSb0Gd/0WtvhX5di6VaLo7Mo/rTOw4Mp7PV6428f
         YHTUuzF9Bnc/g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC net-next 1/2] dt-bindings: ethernet-controller: create a type for PHY interface modes
Date:   Mon, 22 Mar 2021 20:49:58 +0100
Message-Id: <20210322195001.28036-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to be able to define a property describing an array of PHY
interface modes, we need to change the current scalar
`phy-connection-type`, which lists the possible PHY interface modes, to
an array of length 1 (otherwise we would need to define the same list at
two different places).

Moreover Rob Herring says that we cannot reuse the values of a property;
we need to $ref a type.

Move the definition of possible PHY interface modes from the
`phy-connection-type` property to an array type definition
`phy-connection-type-array`, and simply reference this type in the
original property.

Signed-off-by: Marek Behún <kabel@kernel.org>
---

Is `phy-connection-type` prefered over `phy-mode`? If not, maybe the
type could be called `phy-modes-array`...

---
 .../bindings/net/ethernet-controller.yaml     | 89 ++++++++++---------
 1 file changed, 48 insertions(+), 41 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4b7d1e5d003c..0ee25ecbffde 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -53,50 +53,12 @@ properties:
     const: mac-address
 
   phy-connection-type:
+    $ref: "#/$defs/phy-connection-type-array"
     description:
       Specifies interface type between the Ethernet device and a physical
       layer (PHY) device.
-    enum:
-      # There is not a standard bus between the MAC and the PHY,
-      # something proprietary is being used to embed the PHY in the
-      # MAC.
-      - internal
-      - mii
-      - gmii
-      - sgmii
-      - qsgmii
-      - tbi
-      - rev-mii
-      - rmii
-
-      # RX and TX delays are added by the MAC when required
-      - rgmii
-
-      # RGMII with internal RX and TX delays provided by the PHY,
-      # the MAC should not add the RX or TX delays in this case
-      - rgmii-id
-
-      # RGMII with internal RX delay provided by the PHY, the MAC
-      # should not add an RX delay in this case
-      - rgmii-rxid
-
-      # RGMII with internal TX delay provided by the PHY, the MAC
-      # should not add an TX delay in this case
-      - rgmii-txid
-      - rtbi
-      - smii
-      - xgmii
-      - trgmii
-      - 1000base-x
-      - 2500base-x
-      - 5gbase-r
-      - rxaui
-      - xaui
-
-      # 10GBASE-KR, XFI, SFI
-      - 10gbase-kr
-      - usxgmii
-      - 10gbase-r
+    minItems: 1
+    maxItems: 1
 
   phy-mode:
     $ref: "#/properties/phy-connection-type"
@@ -226,4 +188,49 @@ properties:
 
 additionalProperties: true
 
+'$defs':
+  phy-connection-type-array:
+    items:
+      enum:
+        # There is not a standard bus between the MAC and the PHY,
+        # something proprietary is being used to embed the PHY in the
+        # MAC.
+        - internal
+        - mii
+        - gmii
+        - sgmii
+        - qsgmii
+        - tbi
+        - rev-mii
+        - rmii
+
+        # RX and TX delays are added by the MAC when required
+        - rgmii
+
+        # RGMII with internal RX and TX delays provided by the PHY,
+        # the MAC should not add the RX or TX delays in this case
+        - rgmii-id
+
+        # RGMII with internal RX delay provided by the PHY, the MAC
+        # should not add an RX delay in this case
+        - rgmii-rxid
+
+        # RGMII with internal TX delay provided by the PHY, the MAC
+        # should not add an TX delay in this case
+        - rgmii-txid
+        - rtbi
+        - smii
+        - xgmii
+        - trgmii
+        - 1000base-x
+        - 2500base-x
+        - 5gbase-r
+        - rxaui
+        - xaui
+
+        # 10GBASE-KR, XFI, SFI
+        - 10gbase-kr
+        - usxgmii
+        - 10gbase-r
+
 ...
-- 
2.26.2

