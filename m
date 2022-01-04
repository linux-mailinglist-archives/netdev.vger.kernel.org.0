Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97595483C41
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiADH1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:27:55 -0500
Received: from marcansoft.com ([212.63.210.85]:45638 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233188AbiADH1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 02:27:54 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 9C59841F5D;
        Tue,  4 Jan 2022 07:27:44 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v2 01/35] dt-bindings: net: bcm4329-fmac: Add Apple properties & chips
Date:   Tue,  4 Jan 2022 16:26:24 +0900
Message-Id: <20220104072658.69756-2-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This binding is currently used for SDIO devices, but these chips are
also used as PCIe devices on DT platforms and may be represented in the
DT. Re-use the existing binding and add chip compatibles used by Apple
T2 and M1 platforms (the T2 ones are not known to be used in DT
platforms, but we might as well document them).

Then, add properties required for firmware selection and calibration on
M1 machines.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../net/wireless/brcm,bcm4329-fmac.yaml       | 37 +++++++++++++++++--
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index c11f23b20c4c..8b4147c64355 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Broadcom BCM4329 family fullmac wireless SDIO devices
+title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
 
 maintainers:
   - Arend van Spriel <arend@broadcom.com>
@@ -42,10 +42,16 @@ properties:
               - cypress,cyw43012-fmac
           - const: brcm,bcm4329-fmac
       - const: brcm,bcm4329-fmac
+      - enum:
+          - pci14e4,43dc  # BCM4355
+          - pci14e4,4464  # BCM4364
+          - pci14e4,4488  # BCM4377
+          - pci14e4,4425  # BCM4378
+          - pci14e4,4433  # BCM4387
 
   reg:
-    description: SDIO function number for the device, for most cases
-      this will be 1.
+    description: SDIO function number for the device (for most cases
+      this will be 1) or PCI device identifier.
 
   interrupts:
     maxItems: 1
@@ -75,6 +81,31 @@ properties:
     items:
       pattern: '^[A-Z][A-Z]-[A-Z][0-9A-Z]-[0-9]+$'
 
+  brcm,cal-blob:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: A per-device calibration blob for the Wi-Fi radio. This
+      should be filled in by the bootloader from platform configuration
+      data, if necessary, and will be uploaded to the device if present.
+
+  brcm,board-type:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: Overrides the board type, which is normally the compatible of
+      the root node. This can be used to decouple the overall system board or
+      device name from the board type for WiFi purposes, which is used to
+      construct firmware and NVRAM configuration filenames, allowing for
+      multiple devices that share the same module or characteristics for the
+      WiFi subsystem to share the same firmware/NVRAM files. On Apple platforms,
+      this should be the Apple module-instance codename prefixed by "apple,",
+      e.g. "apple,honshu".
+
+  apple,antenna-sku:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: Antenna SKU used to identify a specific antenna configuration
+      on Apple platforms. This is use to build firmware filenames, to allow
+      platforms with different antenna configs to have different firmware and/or
+      NVRAM. This would normally be filled in by the bootloader from platform
+      configuration data.
+
 required:
   - compatible
   - reg
-- 
2.33.0

