Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C3C493ADC
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 14:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354670AbiASNL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 08:11:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54114 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354498AbiASNL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 08:11:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B277B81837;
        Wed, 19 Jan 2022 13:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B7EC340E1;
        Wed, 19 Jan 2022 13:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642597884;
        bh=RHxDuyEXa0btBE9bl6vNwhNZUf3Bjj1q/NWYIKk6LYc=;
        h=From:To:Cc:Subject:Date:From;
        b=bvjdcT3RIZPs1sbwonlpWqzItBLu9YPViD9HLGl+cC7dXG4WjzL6OhAPMk3hDRa5i
         cKpYdsgSe46oiCrjJ/3HKrKQAEjwSOKCM35sk5Z0VKUlwFt2CJxKrORi7GRdKMcDy1
         h0T1rvgpwIJAbKdeoHhLwOf91PrDlDt41r9Q3dWjML0a7089fwnTOgBXlgNkH360tf
         vH6f91TQy/ae+kmQoFF3cZZ7j9k9GgRSCRGm8Y3bkuyeKpGzf7gzlFRuNzBLy5m6Ji
         XdGozlyuqp2sQw3JGCb49Mq7MOWmv6HNgb2qMqGzvRnCioNSZIrGgsNySXt/FXuwap
         a8yifnjktjXqw==
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
Subject: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt` property binding
Date:   Wed, 19 Jan 2022 14:11:17 +0100
Message-Id: <20220119131117.30245-1-kabel@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Common PHYs and network PCSes often have the possibility to specify
peak-to-peak voltage on the differential pair - the default voltage
sometimes needs to be changed for a particular board.

Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
purpose. The second property is needed to specify the mode for the
corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
is to be used only for speficic mode. More voltage-mode pairs can be
specified.

Example usage with only one voltage (it will be used for all supported
PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
case):

  tx-p2p-microvolt = <915000>;

Example usage with voltages for multiple modes:

  tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
  tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";

Add these properties into a separate file phy/transmit-amplitude.yaml,
which should be referenced by any binding that uses it.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
Change since v2:
- removed 'select:' as requested by Rob. Instead the schema should be
  referenced by any binding that uses it. This also fixed indentation
  warnings from Rob's bot, since they warned about lines in the select
  statement
---
 .../bindings/phy/transmit-amplitude.yaml      | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml

diff --git a/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
new file mode 100644
index 000000000000..51492fe738ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
@@ -0,0 +1,103 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/transmit-amplitude.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Common PHY and network PCS transmit amplitude property binding
+
+description:
+  Binding describing the peak-to-peak transmit amplitude for common PHYs
+  and network PCSes.
+
+maintainers:
+  - Marek Behún <kabel@kernel.org>
+
+properties:
+  tx-p2p-microvolt:
+    description:
+      Transmit amplitude voltages in microvolts, peak-to-peak. If this property
+      contains multiple values for various PHY modes, the
+      'tx-p2p-microvolt-names' property must be provided and contain
+      corresponding mode names.
+
+  tx-p2p-microvolt-names:
+    description: |
+      Names of the modes corresponding to voltages in the 'tx-p2p-microvolt'
+      property. Required only if multiple voltages are provided.
+
+      If a value of 'default' is provided, the system should use it for any PHY
+      mode that is otherwise not defined here. If 'default' is not provided, the
+      system should use manufacturer default value.
+    minItems: 1
+    maxItems: 16
+    items:
+      enum:
+        - default
+
+        # ethernet modes
+        - sgmii
+        - qsgmii
+        - xgmii
+        - 1000base-x
+        - 2500base-x
+        - 5gbase-r
+        - rxaui
+        - xaui
+        - 10gbase-kr
+        - usxgmii
+        - 10gbase-r
+        - 25gbase-r
+
+        # PCIe modes
+        - pcie
+        - pcie1
+        - pcie2
+        - pcie3
+        - pcie4
+        - pcie5
+        - pcie6
+
+        # USB modes
+        - usb
+        - usb-ls
+        - usb-fs
+        - usb-hs
+        - usb-ss
+        - usb-ss+
+        - usb-4
+
+        # storage modes
+        - sata
+        - ufs-hs
+        - ufs-hs-a
+        - ufs-hs-b
+
+        # display modes
+        - lvds
+        - dp
+        - dp-rbr
+        - dp-hbr
+        - dp-hbr2
+        - dp-hbr3
+        - dp-uhbr-10
+        - dp-uhbr-13.5
+        - dp-uhbr-20
+
+        # camera modes
+        - mipi-dphy
+        - mipi-dphy-univ
+        - mipi-dphy-v2.5-univ
+
+dependencies:
+  tx-p2p-microvolt-names: [ tx-p2p-microvolt ]
+
+additionalProperties: true
+
+examples:
+  - |
+    phy: phy {
+      #phy-cells = <1>;
+      tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
+      tx-p2p-microvolt-names = "2500base-x", "usb-hs", "usb-ss";
+    };
-- 
2.34.1

