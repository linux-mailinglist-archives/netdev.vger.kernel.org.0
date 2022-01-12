Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9432848CAC9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356119AbiALSQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:16:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356121AbiALSQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:16:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03520B8202D;
        Wed, 12 Jan 2022 18:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8360BC36AE5;
        Wed, 12 Jan 2022 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642011368;
        bh=J7F1bUADdGWlMHvynFP562AieLiEYMIBcsKTpe9EoMA=;
        h=From:To:Cc:Subject:Date:From;
        b=KQJGwu2zKzZ7CKlTuhdL1yof+jHa8eS22zW41Zdrd/dvL0YtMjCFm6qDLihvd+N6I
         3/RZeRUTC5cuV9A0YIPf2nYuAGRWKfpoFXwTSVGP5fWAsvJY7TABfK4rE9ZSw9dO/7
         KFAuIObzERpezDLX0/08qkkDHxr45wAQPhsUxw1paTW1OX1K/dqNoPqSGJ1mpLzGd+
         X9tzqantNSikvWEbHQPwH26hJemh8VKBs18fCmAmPwSeZSLq/QBeEkxn19kAIYv0sA
         JY0mR7PVqfe2IbHc/kcxG86O4TpK2GoOmZZOepZVUjtXPdD/yFhu80WYWXbhX80JH9
         BCSwZdQHL6W6Q==
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
Subject: [PATCH devicetree v2] dt-bindings: phy: Add `tx-p2p-microvolt` property binding
Date:   Wed, 12 Jan 2022 19:16:02 +0100
Message-Id: <20220112181602.13661-1-kabel@kernel.org>
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
selecting it for validation if either of the `tx-p2p-microvolt`,
`tx-p2p-microvolt-names` properties is set for a node.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../bindings/phy/transmit-amplitude.yaml      | 110 ++++++++++++++++++
 1 file changed, 110 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml

diff --git a/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
new file mode 100644
index 000000000000..90a491b75f61
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
@@ -0,0 +1,110 @@
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
+select:
+  anyOf:
+    - required:
+      - 'tx-p2p-microvolt'
+    - required:
+      - 'tx-p2p-microvolt-names'
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

