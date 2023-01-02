Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB0B65B5E9
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbjABRaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 12:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbjABRaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 12:30:13 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68A319F
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 09:30:12 -0800 (PST)
Received: from dude05.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::54])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1pCOdJ-0003fo-Io; Mon, 02 Jan 2023 18:29:57 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
Date:   Mon, 02 Jan 2023 18:29:33 +0100
Subject: [PATCH v2 1/2] dt-bindings: net: Add rfkill-gpio binding
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230102-rfkill-gpio-dt-v2-1-d1b83758c16d@pengutronix.de>
References: <20230102-rfkill-gpio-dt-v2-0-d1b83758c16d@pengutronix.de>
In-Reply-To: <20230102-rfkill-gpio-dt-v2-0-d1b83758c16d@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
X-Mailer: b4 0.11.0-dev-e429b
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::54
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a device tree binding document for GPIO controlled rfkill switches.
The label and radio-type properties correspond to the name and type
properties used for ACPI, respectively. The shutdown-gpios property
is the same as defined for ACPI.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
- Drop quotes from $id and $schema (Krzysztof)
- Use generic label property (Rob, Krzysztof)
- Rename type property to radio-type (Rob)
- Reorder list of radio types alphabetically (Krzysztof)
- Drop reset-gpios property (Rob, Krzysztof)
- Use generic node name in example (Rob, Krzysztof)
---
 .../devicetree/bindings/net/rfkill-gpio.yaml       | 51 ++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/rfkill-gpio.yaml b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
new file mode 100644
index 000000000000..9630c8466fac
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/rfkill-gpio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: GPIO controlled rfkill switch
+
+maintainers:
+  - Johannes Berg <johannes@sipsolutions.net>
+  - Philipp Zabel <p.zabel@pengutronix.de>
+
+properties:
+  compatible:
+    const: rfkill-gpio
+
+  label:
+    description: rfkill switch name, defaults to node name
+
+  radio-type:
+    description: rfkill radio type
+    enum:
+      - bluetooth
+      - fm
+      - gps
+      - nfc
+      - ultrawideband
+      - wimax
+      - wlan
+      - wwan
+
+  shutdown-gpios:
+    maxItems: 1
+
+required:
+  - compatible
+  - radio-type
+  - shutdown-gpios
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    rfkill {
+        compatible = "rfkill-gpio";
+        label = "rfkill-pcie-wlan";
+        radio-type = "wlan";
+        shutdown-gpios = <&gpio2 25 GPIO_ACTIVE_HIGH>;
+    };

-- 
2.30.2
