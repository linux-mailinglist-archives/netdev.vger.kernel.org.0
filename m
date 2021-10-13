Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F32042CF1E
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhJMXXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhJMXXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 19:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F0E8610CE;
        Wed, 13 Oct 2021 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634167259;
        bh=n7BXvPLigLzcROSkXhiYOaoGmDt3FNTnukgsfSYaSmk=;
        h=From:To:Cc:Subject:Date:From;
        b=KhZRpBRuoW22HuxOVTLjBlHDiDTPcMjJ635XAWz/vN0M2G5aAQ7mQl+QxkpQ/WjiL
         3dSkXIBOyfdOhlmpgVHSIxtMVQaFpFarlOVX3MXGfPwqzN4AQSkHUoikE7lPxHn9Mo
         jDksWBqFx8cvWvJT19xDHxQFo4ndm0cVqfw4PczHEEvIUB0vDX4YXTcQPQlxxtbx2L
         gN1h3u3hsZM4Sg1ANhuhmZhLFQv9up6uR08qR5c9e+FayeitVgFro0pIvD8P4N+aKb
         pc6M80WVtDTAbckSjqZkbmtwolbteekriaP/bkmdAYSI+Kymi2Opukf0Lm8x6jfCDH
         OTLWkmR4Nu6dg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        U-Boot Mailing List <u-boot@lists.denx.de>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luka Kovacic <luka.kovacic@sartura.hr>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot environment NVMEM provider
Date:   Thu, 14 Oct 2021 01:20:48 +0200
Message-Id: <20211013232048.16559-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree bindings for U-Boot environment NVMEM provider.

U-Boot environment can be stored at a specific offset of a MTD device,
EEPROM, MMC, NAND or SATA device, on an UBI volume, or in a file on a
filesystem.

The environment can contain information such as device's MAC address,
which should be used by the ethernet controller node.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../bindings/nvmem/denx,u-boot-env.yaml       | 88 +++++++++++++++++++
 include/dt-bindings/nvmem/u-boot-env.h        | 18 ++++
 2 files changed, 106 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
 create mode 100644 include/dt-bindings/nvmem/u-boot-env.h

diff --git a/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml b/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
new file mode 100644
index 000000000000..56505c08e622
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
@@ -0,0 +1,88 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/nvmem/denx,u-boot-env.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: U-Boot environment NVMEM Device Tree Bindings
+
+maintainers:
+  - Marek Behún <kabel@kernel.org>
+
+description:
+  This binding represents U-Boot's environment NVMEM settings which can be
+  stored on a specific offset of an EEPROM, MMC, NAND or SATA device, or
+  an UBI volume, or in a file on a filesystem.
+
+properties:
+  compatible:
+    const: denx,u-boot-env
+
+  path:
+    description:
+      The path to the file containing the environment if on a filesystem.
+    $ref: /schemas/types.yaml#/definitions/string
+
+patternProperties:
+  "^[^=]+$":
+    type: object
+
+    description:
+      This node represents one U-Boot environment variable, which is also one
+      NVMEM data cell.
+
+    properties:
+      name:
+        description:
+          If the variable name contains characters not allowed in device tree node
+          name, use this property to specify the name, otherwise the variable name
+          is equal to node name.
+        $ref: /schemas/types.yaml#/definitions/string
+
+      type:
+        description:
+          Type of the variable. Since variables, even integers and MAC addresses,
+          are stored as strings in U-Boot environment, for proper conversion the
+          type needs to be specified. Use one of the U_BOOT_ENV_TYPE_* prefixed
+          definitions from include/dt-bindings/nvmem/u-boot-env.h.
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 0
+        maximum: 5
+
+    required:
+      - type
+
+required:
+  - compatible
+
+additionalProperties: true
+
+examples:
+  - |
+
+    #include <dt-bindings/nvmem/u-boot-env.h>
+
+    spi-flash {
+        partitions {
+            compatible = "fixed-partitions";
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            partition@180000 {
+                compatible = "denx,u-boot-env";
+                label = "u-boot-env";
+                reg = <0x180000 0x10000>;
+
+                eth0_addr: ethaddr {
+                    type = <U_BOOT_ENV_TYPE_MAC_ADDRESS>;
+                };
+            };
+        };
+    };
+
+    ethernet-controller {
+        nvmem-cells = <&eth0_addr>;
+        nvmem-cell-names = "mac-address";
+    };
+
+...
diff --git a/include/dt-bindings/nvmem/u-boot-env.h b/include/dt-bindings/nvmem/u-boot-env.h
new file mode 100644
index 000000000000..760e5b240619
--- /dev/null
+++ b/include/dt-bindings/nvmem/u-boot-env.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Macros for U-Boot environment NVMEM device tree bindings.
+ *
+ * Copyright (C) 2021 Marek Behún <kabel@kernel.org>
+ */
+
+#ifndef __DT_BINDINGS_NVMEM_U_BOOT_ENV_H
+#define __DT_BINDINGS_NVMEM_U_BOOT_ENV_H
+
+#define U_BOOT_ENV_TYPE_STRING		0
+#define U_BOOT_ENV_TYPE_ULONG		1
+#define U_BOOT_ENV_TYPE_BOOL		2
+#define U_BOOT_ENV_TYPE_MAC_ADDRESS	3
+#define U_BOOT_ENV_TYPE_ULONG_HEX	4
+#define U_BOOT_ENV_TYPE_ULONG_DEC	5
+
+#endif /* __DT_BINDINGS_NVMEM_U_BOOT_ENV_H */
-- 
2.32.0

