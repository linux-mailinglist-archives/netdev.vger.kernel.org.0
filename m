Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408DD689B5F
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbjBCOQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjBCOQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:16:35 -0500
X-Greylist: delayed 606 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Feb 2023 06:15:53 PST
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DA41DBAC;
        Fri,  3 Feb 2023 06:15:52 -0800 (PST)
Received: from robin.home.jannau.net (p579ad32f.dip0.t-ipconnect.de [87.154.211.47])
        by soltyk.jannau.net (Postfix) with ESMTPSA id 7C41D26F703;
        Fri,  3 Feb 2023 14:56:33 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Date:   Fri, 03 Feb 2023 14:56:26 +0100
Subject: [PATCH RFC 1/3] dt-bindings: net: Add network-class schema for
 mac-address properties
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230203-dt-bindings-network-class-v1-1-452e0375200d@jannau.net>
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
In-Reply-To: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3851; i=j@jannau.net;
 h=from:subject:message-id; bh=yMGAL+QzO91nZgA/hAW/ks707rvfOrRSu4uh4kEKZwQ=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhuS7QhO4FF7sYJDV3GLdWfh7dun71QFHf+jfrf33UudGp
 PnUlB0dHaUsDGIcDLJiiixJ2i87GFbXKMbUPgiDmcPKBDKEgYtTACayl5nhnyJbH3u9c8bJlHuP
 fh3J96zhubFS/EZsnV+e3vPQDdk7bjMyzOy8skp+1bkdMy/GvJzwcEX0aQ1jbcfwBY/ZHhZcOap
 jzQ0A
X-Developer-Key: i=j@jannau.net; a=openpgp;
 fpr=8B336A6BE4E5695E89B8532B81E806F586338419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethernet-controller schema specifies "mac-address" and
"local-mac-address" but other network devices such as wireless network
adapters use mac addresses as well.
The Devicetree Specification, Release v0.3 specifies in section 4.3.1
a generic "Network Class Binding" with "address-bits", "mac-address",
"local-mac-address" and "max-frame-size". This schema specifies the
"address-bits" property and moves "local-mac-address" and "mac-address"
over from ethernet-controller.yaml.
The schema currently does not restrict MAC address size based on
address-bits.

Signed-off-by: Janne Grunau <j@jannau.net>
---
 .../bindings/net/ethernet-controller.yaml          | 18 +---------
 .../devicetree/bindings/net/network-class.yaml     | 40 ++++++++++++++++++++++
 2 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 00be387984ac..a5f6a09dfdea 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -17,23 +17,6 @@ properties:
     $ref: /schemas/types.yaml#/definitions/string
     description: Human readable label on a port of a box.
 
-  local-mac-address:
-    description:
-      Specifies the MAC address that was assigned to the network device.
-    $ref: /schemas/types.yaml#/definitions/uint8-array
-    minItems: 6
-    maxItems: 6
-
-  mac-address:
-    description:
-      Specifies the MAC address that was last used by the boot
-      program; should be used in cases where the MAC address assigned
-      to the device by the boot program is different from the
-      local-mac-address property.
-    $ref: /schemas/types.yaml#/definitions/uint8-array
-    minItems: 6
-    maxItems: 6
-
   max-frame-size:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
@@ -226,6 +209,7 @@ dependencies:
   pcs-handle-names: [pcs-handle]
 
 allOf:
+  - $ref: /schemas/net/network-class.yaml#
   - if:
       properties:
         phy-mode:
diff --git a/Documentation/devicetree/bindings/net/network-class.yaml b/Documentation/devicetree/bindings/net/network-class.yaml
new file mode 100644
index 000000000000..676aec1c458e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/network-class.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/network-class.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Network Class Bindings
+
+maintainers:
+  - Devicetree Specification Mailing List <devicetree-spec@vger.kernel.org>
+
+properties:
+  address-bits:
+    description:
+      Specifies number of address bits required to address the device described
+      by this node. This property specifies number of bits in MAC address.
+      If unspecified, the default value is 48.
+    default: 48
+    enum: [48, 64]
+
+  local-mac-address:
+    description:
+      Specifies MAC address that was assigned to the network device described by
+      the node containing this property.
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    minItems: 6
+    maxItems: 8
+
+  mac-address:
+    description:
+      Specifies the MAC address that was last used by the boot program. This
+      property should be used in cases where the MAC address assigned to the
+      device by the boot program is different from the
+      local-mac-address property. This property shall be used only if the value
+      differs from local-mac-address property value.
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    minItems: 6
+    maxItems: 8
+
+additionalProperties: true

-- 
2.39.1

