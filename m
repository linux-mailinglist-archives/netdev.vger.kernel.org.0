Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E25347640
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhCXKhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhCXKge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EEAB61A08;
        Wed, 24 Mar 2021 10:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616582193;
        bh=B+kZlNE6ljpqmUxCiAVwPVI4YEuUbs4lWKzfgZcbKY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKlY8U17Ny34GXYvrieV4atKMVlsf6yIp1yayQwCknrrjwIzLbTpKtgTpSIvesyj2
         eyR14mV3STj2ZduV37uE5V9/y8LiPTXHkuwLr82Wfzfeij/ZQwdBf55RgV0scuYXJK
         XEcqTWiC3+Cnz6ElZxFwqyZjPsnbaOHeXnWCy18Ob1CTvxkJcbsRubp5g00XIxizZm
         IGbMPXZeRHa4uUw6/L+UH/1IJgR5Oh6PjETvvdu7EPssEjNeduFnsk0qG/y4uhUzcV
         m+HoqRtXIULWh3ukSEizEwzX4slPADFveosBITY3/HlPS4CmjrosvstPvRfyUD6uqs
         QIygWRNLgD+Ig==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 1/2] dt-bindings: ethernet-controller: create a type for PHY interface modes
Date:   Wed, 24 Mar 2021 11:35:55 +0100
Message-Id: <20210324103556.11338-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324103556.11338-1-kabel@kernel.org>
References: <20210324103556.11338-1-kabel@kernel.org>
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

