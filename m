Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA71474E9F
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbhLNXeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbhLNXep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:34:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1900C06173E;
        Tue, 14 Dec 2021 15:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFE06171C;
        Tue, 14 Dec 2021 23:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5A3C34600;
        Tue, 14 Dec 2021 23:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639524883;
        bh=6dXrC0FdP3B7Ezq06gX3Eh2HgFGakgLcBGUR+xmwRJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDUAediloFuCmcB9BNlhg5n0N1FHNME3+vDj6IfDmNGTx3CXxpawQ5sHfQnc2nA3t
         031Dm6ivnTlc9z0ghNmir0dw602lSydMwo3Jj7mT6myPNvQ23mVB9E2yq99wEAUYa3
         rq+jj9yTF1FrinGx0NanIEIY2akkclnQqPxPLMEXy/GtsbPAUV/rdNODjhoR4NO4Tm
         KHBTAeZLapyZ/cvwx1jXJtTUL6ut7HaIlHqe6UuhDE20PBBqFLclm4W0YCtMj3ZiyC
         qBt8j6QkTND9yE64RZOV0UhZZoDZPK89OiLbUArpOgWuropPGZkL2DzIpxtyrIW8zr
         q1khD+mYfSluQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH devicetree 2/2] dt-bindings: phy: Add `tx-amplitude-microvolt` property binding
Date:   Wed, 15 Dec 2021 00:34:32 +0100
Message-Id: <20211214233432.22580-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214233432.22580-1-kabel@kernel.org>
References: <20211214233432.22580-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Common PHYs often have the possibility to specify peak-to-peak voltage
on the differential pair - the default voltage sometimes needs to be
changed for a particular board.

Add properties `tx-amplitude-microvolt` and
`tx-amplitude-microvolt-names` for this purpose. The second property is
needed to specify

Example usage with only one voltage (it will be used for all supported
PHY modes, the `tx-amplitude-microvolt-names` property is not needed in
this case):

  tx-amplitude-microvolt = <915000>;

Example usage with voltages for multiple modes:

  tx-amplitude-microvolt = <915000>, <1100000>, <1200000>;
  tx-amplitude-microvolt-names = "2500base-x", "usb", "pcie";

Signed-off-by: Marek Behún <kabel@kernel.org>
---

I wanted to constrain the values allowed in the
`tx-amplitude-microvolt-names` property to:
- ethernet SerDes modes (sgmii, qsgmii, 10gbase-r, 2500base-x, ...)
- PCIe modes (pattern: ^pcie[1-6]?$)
- USB modes (pattern: ^usb((-host|-device|-otg)?-(ls|fs|hs|ss|ss\+|4))?$)
- DisplayPort modes (pattern: ^dp(-rbr|-hbr[23]?|-uhbr-(10|13.5|20))?$)
- Camera modes (mipi-dphy, mipi-dphy-univ, mipi-dphy-v2.5-univ)
- Storage modes (sata, ufs-hs, ufs-hs-a, ufs-hs-b)

But was unable to. The '-names' suffix implies string-array type, and
string-array type does not allow to specify a type for all items in a
simple way, i.e.:
  items:
    enum:
      - sgmii
      - sata
      - usb
      ...
Such constraint does work when changing ethernet controller's
`phy-connection-type` to array, see
https://lore.kernel.org/netdev/20211123164027.15618-2-kabel@kernel.org/

But it seems that string-array type prohibits this.

---
 .../devicetree/bindings/phy/phy.yaml          | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/phy.yaml b/Documentation/devicetree/bindings/phy/phy.yaml
index a5b6b04cff5b..8915065cf6c2 100644
--- a/Documentation/devicetree/bindings/phy/phy.yaml
+++ b/Documentation/devicetree/bindings/phy/phy.yaml
@@ -31,9 +31,29 @@ properties:
       Phandle to a regulator that provides power to the PHY. This regulator
       will be managed during the PHY power on/off sequence.
 
+  tx-amplitude-microvolt:
+    description:
+      Transmit amplitude voltages in microvolts, peak-to-peak. If this property
+      contains multiple values for various PHY modes, the
+      'tx-amplitude-microvolt-names' property must be provided and contain
+      corresponding mode names.
+
+  tx-amplitude-microvolt-names:
+    description: |
+      Names of the modes corresponding to voltages in the
+      'tx-amplitude-microvolt' property. Required only if multiple voltages
+      are provided.
+
+      If a value of 'default' is provided, the system should use it for any PHY
+      mode that is otherwise not defined here. If 'default' is not provided, the
+      system should use manufacturer default value.
+
 required:
   - '#phy-cells'
 
+dependencies:
+  tx-amplitude-microvolt-names: [ tx-amplitude-microvolt ]
+
 additionalProperties: true
 
 examples:
@@ -46,6 +66,8 @@ examples:
     phy: phy {
       #phy-cells = <1>;
       phy-supply = <&phy_regulator>;
+      tx-amplitude-microvolt = <915000>, <1100000>, <1200000>;
+      tx-amplitude-microvolt-names = "2500base-x", "usb-hs", "usb-ss";
     };
 
     ethernet-controller {
-- 
2.32.0

