Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F748E8EC6
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfJ2R5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:57:10 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:47841 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfJ2R5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:57:07 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2019 13:57:05 EDT
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0ABE822EE3;
        Tue, 29 Oct 2019 18:48:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572371333;
        bh=e1PTLm3kTFCklCK3oiHVFGQvwxFH6DrXm3LEg+OEI8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4NLtkxgSLXyxaYmtKxWmRFv/qyczxB0I25+PqIMTc3eGShbTlub7cs7A8VP9RCFD
         CxxAafyLM9d8M56Wgpzem4uHJ/m9OXwcgHdBOBZAhw8101fQ0OYATc/IgWc9FfIZBP
         x47Pua2KPXZA7d5rfRm6pG9JjIkdFZLWn1fuPD7A=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 1/3] dt-bindings: net: phy: Add reg-init property
Date:   Tue, 29 Oct 2019 18:48:17 +0100
Message-Id: <20191029174819.3502-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191029174819.3502-1-michael@walle.cc>
References: <20191029174819.3502-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the reg-init property to configure PHY registers.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 31 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 include/dt-bindings/net/phy.h                 | 18 +++++++++++
 3 files changed, 50 insertions(+)
 create mode 100644 include/dt-bindings/net/phy.h

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index f70f18ff821f..d2dda1f33119 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -153,6 +153,28 @@ properties:
       Delay after the reset was deasserted in microseconds. If
       this property is missing the delay will be skipped.
 
+  reg-init:
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32-matrix
+        items:
+          items:
+            - description:
+                Set this to zero to write clause-22 register.
+                Set the page ORed with PHY_REG_PAGE to write to
+                a paged register. Set to devad ORed with
+                PHY_REG_C45 to write a clause-45 register.
+            - description:
+                The PHY register.
+            - description:
+                Mask, if non-zero, ANDed with existing register
+                value.
+            - description:
+                Value, ORed with the masked value and written to
+                the register.
+    description:
+      A list of <page_or_devad reg mask value> tuples to configure
+      the PHY registers at startup.
+
 required:
   - reg
 
@@ -173,5 +195,14 @@ examples:
             reset-gpios = <&gpio1 4 1>;
             reset-assert-us = <1000>;
             reset-deassert-us = <2000>;
+
+            reg-init =
+                /* Fix RX and TX clock transition timing */
+                <(PHY_REG_PAGE | 2) 0x15 0xffcf 0>, /* Reg 2,21 Clear bits 4, 5 */
+                /* Adjust LED drive. */
+                <(PHY_REG_PAGE | 3) 0x11 0 0x442a>, /* Reg 3,17 <- 0442a */
+                /* irq, blink-activity, blink-link */
+                <(PHY_REG_PAGE | 3) 0x10 0 0x0242>; /* Reg 3,16 <- 0x0242 */
+
         };
     };
diff --git a/MAINTAINERS b/MAINTAINERS
index a69e6db80c79..493ea5e13c2c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6147,6 +6147,7 @@ F:	Documentation/networking/phy.rst
 F:	drivers/net/phy/
 F:	drivers/of/of_mdio.c
 F:	drivers/of/of_net.c
+F:	include/dt-bindings/net/phy.h
 F:	include/linux/*mdio*.h
 F:	include/linux/of_net.h
 F:	include/linux/phy.h
diff --git a/include/dt-bindings/net/phy.h b/include/dt-bindings/net/phy.h
new file mode 100644
index 000000000000..b37853144719
--- /dev/null
+++ b/include/dt-bindings/net/phy.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Device Tree constants for a generic network PHY
+ *
+ * Author: Michael Walle <michael@walle.cc>
+ *
+ */
+
+#ifndef _DT_BINDINGS_NET_PHY_H
+#define _DT_BINDINGS_NET_PHY_H
+
+/* PHY write selection bits */
+
+#define PHY_REG_C22	(0)
+#define PHY_REG_PAGE	(1 << 31)
+#define PHY_REG_C45	(1 << 30)
+
+#endif /* _DT_BINDINGS_NET_PHY_H */
-- 
2.20.1

