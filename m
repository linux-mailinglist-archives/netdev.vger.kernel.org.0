Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150D44B148F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245351AbiBJRtC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 12:49:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245322AbiBJRtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:49:02 -0500
Received: from inet10.abb.com (spf.hitachienergy.com [138.225.1.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF9A25D1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:49:01 -0800 (PST)
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 21AHmeFT030461;
        Thu, 10 Feb 2022 18:48:40 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id 2184765B93DF;
        Thu, 10 Feb 2022 18:48:40 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [net-next 1/2] dt-bindings: phy: Add `tx-p2p-microvolt` property binding
Date:   Thu, 10 Feb 2022 18:48:22 +0100
Message-Id: <20220210174823.15488-1-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

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
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/phy/transmit-amplitude.yaml           | 103 +++++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml

diff --git a/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
new file mode 100644
index 00000000..51492fe
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
1.8.3.1

