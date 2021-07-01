Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E833B8B74
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 02:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbhGAA4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAA4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 20:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC196124B;
        Thu,  1 Jul 2021 00:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625100831;
        bh=X1Yit87ebjU7Q0XF7mRkUpCYj5/wowh8TWqrZoeyU4Y=;
        h=From:To:Cc:Subject:Date:From;
        b=SKl4Fpadc7lo6ehwAu0BJ1KKR2gfNrh+iGLFwYrT4deSd1kJtk7bf7870Z7vavLdU
         fTXJWecinMaBCmyaNQRZHFfBh9PfEZXuphZ1FIlIX76ebVgO7O06P2R+323DKiXLeA
         KAj2VQG8mSZQGBoh6jr1Kg0lOKc8LTw6qzGyeL9im84FyVlHcAqhIKK9FVx0x8dzIt
         JbYVT+irzZulaA45GEkkBmE7tfHqnXrdi5FU0n06HR33wSG1y7balaRDRDjvzGyCb6
         ZNvdNew/IIayHwGsRUN/dIXSjcprzzqXO+7AEa65Vo7ulMBxmDVVgQcmBhaUv/NdzY
         +YXgAXKVMu9TQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Peter Rosin <peda@axentia.se>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next] dt-bindings: ethernet-controller: document signal multiplexer
Date:   Thu,  1 Jul 2021 02:53:47 +0200
Message-Id: <20210701005347.8280-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are devices where the MAC signals from the ethernet controller are
not directly connected to an ethernet PHY or a SFP cage, but to a
multiplexer, so that the device can switch between the endpoints.

For example on Turris Omnia the WAN controller is connected to a SerDes
switch, which multiplexes the SerDes lanes between SFP cage and ethernet
PHY, depending on whether a SFP module is present (MOD_DEF0 GPIO from
the SFP cage).

Document how to describe such a situation for an ethernet controller in
the device tree bindings.

Example usage could then look like:
  &eth2 {
    status = "okay";
    phys = <&comphy5 2>;
    buffer-manager = <&bm>;
    bm,pool-long = <2>;
    bm,pool-short = <3>;

    signal-multiplexer {
      compatible = "gpio-signal-multiplexer";
      gpios = <&pcawan 4 GPIO_ACTIVE_LOW>;

      endpoint@0 {
        phy-mode = "sgmii";
	phy-handle = <&phy1>;
      };

      endpoint@1 {
        sfp = <&sfp>;
	phy-mode = "sgmii";
	managed = "in-band-status";
      };
    };
  };

Signed-off-by: Marek Behún <kabel@kernel.org>
---
I wonder if this is the proper way to do this.

We already have framework for multiplexers in Linux, in drivers/mux.
But as I understand it, that framework is meant to be used when the
multiplexer state is to be set by kernel, while here it is possible
that the multiplexer state can be (and on Turris Omnia is) set by
the user plugging a SFP module into the SFP cage.

We theoretically could add a method for getting mux state into the mux
framework and state notification support. But using the mux framework
to solve this case in phylink would be rather complicated, especially
since mux framework is abstract, and if the multiplexer state is
determined by the MOD_DEF0 GPIO, which is also used by SFP code, the
implementation would get rather complicate in phylink...

I wonder whether driver implementation complexity should play a role
when proposing device tree bindings :-)

Some thoughts?
---
 .../bindings/net/ethernet-controller.yaml     | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index b0933a8c295a..a7770edaec2b 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -226,6 +226,66 @@ properties:
           required:
             - speed
 
+  signal-multiplexer:
+    type: object
+    description:
+      Specifies that the signal pins (for example SerDes lanes) are connected
+      to a multiplexer from which they can be multiplexed to several different
+      endpoints, depending on the multiplexer configuration. (For example SerDes
+      lanes can be switched between an ethernet PHY and a SFP cage.)
+
+    properties:
+      compatible:
+        const: gpio-signal-multiplexer
+
+      gpios:
+        maxItems: 1
+        description:
+          GPIO to determine which endpoint the multiplexer is switched to.
+
+    patternProperties:
+      "^endpoint@[01]$":
+        type: object
+        description:
+          Specifies a multiplexer endpoint settings. Each endpoint can have
+          different settings. (For example in the case when multiplexing between
+          an ethernet PHY and a SFP cage, the SFP cage endpoint should specify
+          SFP phandle, while the PHY endpoint should specify PHY handle.)
+
+        properties:
+          reg:
+            enum: [ 0, 1 ]
+
+          phy-connection-type:
+            $ref: #/properties/phy-connection-type
+
+          phy-mode:
+            $ref: #/properties/phy-mode
+
+          phy-handle:
+            $ref: #/properties/phy-handle
+
+          phy:
+            $ref: #/properties/phy
+
+          phy-device:
+            $ref: #/properties/phy-device
+
+          sfp:
+            $ref: #/properties/sfp
+
+          managed:
+            $ref: #/properties/managed
+
+          fixed-link:
+            $ref: #/properties/fixed-link
+
+        required:
+          - reg
+
+    required:
+      - gpios
+
 additionalProperties: true
 
 ...
-- 
2.31.1

