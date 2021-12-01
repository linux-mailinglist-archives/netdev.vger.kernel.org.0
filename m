Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5D4645BC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346574AbhLAEQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346543AbhLAEQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:16:09 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDDEC06175E;
        Tue, 30 Nov 2021 20:12:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nn15-20020a17090b38cf00b001ac7dd5d40cso246003pjb.3;
        Tue, 30 Nov 2021 20:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KYMDVSre6+yLu8zD+7T8spnd61FbSvWPFURC895A/Tk=;
        b=Ghs9h0Wn3m4GG42iSZLt5BTn7S2LUyXpA+w/Xs7MsHuanlP1am/7Khp9yh4vfsRNNF
         jkCQ2cTLm8tSfWSqheDaIOfjCnC/nDgG9U1sg39deZhOCFMknAKaOsezXsuVMYvWuhEi
         iAiIAhM/tjxp8lMsYh2vbj3guQios5F45ko5+mydZOJzA4Ej2lSA/2O7/RVUj8DHzEGK
         UfbZRbvjbUJ6fOcRWLM0kS+qGJrjUDZ1cReMRgutYKlTSufvyLasSPIr/eoJdCIo2qce
         sFKAwk7+mjopTLR63E7Ccp72qELJ39fqn1+fQrsv84dOW428n/WpydNGSTY/eKxF6Rzx
         L3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KYMDVSre6+yLu8zD+7T8spnd61FbSvWPFURC895A/Tk=;
        b=uLP07ZKR18CdGlBx5P1NoDieZdrUfNKVdW6jGiPT8xmvEPnDT0PuqTk0CuaKHAXooJ
         kiW1D4qwfUT8bmcj3vbj2LtLoPHK9r9rHJrzz2v1bueFzKYnRrfQkV9j7s10iI3qSkzE
         /vxQZ/rtD3MdPihGG7E5Hkd4aoyUuZj+w66ToXBVjySrC7nILwWkG+flnKLqjaVeS+XG
         xGTeP26FVffaRmpT0zXX/fOuk1dNgn3/ssUB89xU8htY87iJDWApzJLtz5YkMCgJg6yU
         01aARrcDKHSUEIC3BDobEsA3cjtLe/Vni28IrQ9OtXKHg7ELnEWA5QNCJFr8faSfo24f
         Gqgg==
X-Gm-Message-State: AOAM530Eov3sZgmegqSpvJAPSQDQm5EBoMxgAhLb6QWbYwwad3iEQpEO
        NEdTeb1gNwvk0ZbMUwj2+sy+svFzY+4=
X-Google-Smtp-Source: ABdhPJz+AGJrWdIboGE4ESLzP2gQL0G1mkxQUQYapwquMrl2Sdr59PkdZxUMOJWz2TJCza5Ier3z6w==
X-Received: by 2002:a17:90a:e389:: with SMTP id b9mr4173549pjz.235.1638331961253;
        Tue, 30 Nov 2021 20:12:41 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:40 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH net-next 5/7] dt-bindings: net: Convert AMAC to YAML
Date:   Tue, 30 Nov 2021 20:12:26 -0800
Message-Id: <20211201041228.32444-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201041228.32444-1-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Broadcom AMAC Device Tree binding to YAML to help with
schema and dtbs checking.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/brcm,amac.txt     | 30 -------
 .../devicetree/bindings/net/brcm,amac.yaml    | 88 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 3 files changed, 89 insertions(+), 31 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,amac.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,amac.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,amac.txt b/Documentation/devicetree/bindings/net/brcm,amac.txt
deleted file mode 100644
index 0120ebe93262..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,amac.txt
+++ /dev/null
@@ -1,30 +0,0 @@
-Broadcom AMAC Ethernet Controller Device Tree Bindings
--------------------------------------------------------------
-
-Required properties:
- - compatible:	"brcm,amac"
-		"brcm,nsp-amac"
-		"brcm,ns2-amac"
- - reg:		Address and length of the register set for the device. It
-		contains the information of registers in the same order as
-		described by reg-names
- - reg-names:	Names of the registers.
-		"amac_base":	Address and length of the GMAC registers
-		"idm_base":	Address and length of the GMAC IDM registers
-				(required for NSP and Northstar2)
-		"nicpm_base":	Address and length of the NIC Port Manager
-				registers (required for Northstar2)
- - interrupts:	Interrupt number
-
-The MAC address will be determined using the optional properties
-defined in ethernet.txt.
-
-Examples:
-
-amac0: ethernet@18022000 {
-	compatible = "brcm,nsp-amac";
-	reg = <0x18022000 0x1000>,
-	      <0x18110000 0x1000>;
-	reg-names = "amac_base", "idm_base";
-	interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
-};
diff --git a/Documentation/devicetree/bindings/net/brcm,amac.yaml b/Documentation/devicetree/bindings/net/brcm,amac.yaml
new file mode 100644
index 000000000000..d9de68aba7d3
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,amac.yaml
@@ -0,0 +1,88 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,amac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom AMAC Ethernet Controller Device Tree Bindings
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,amac
+    then:
+      properties:
+        reg:
+          minItems: 1
+          maxItems: 2
+        reg-names:
+          minItems: 1
+          maxItems: 2
+          items:
+            - const: amac_base
+            - const: idm_base
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,nsp-amac
+    then:
+      properties:
+        reg:
+          minItems: 2
+          maxItems: 2
+        reg-names:
+          items:
+            - const: amac_base
+            - const: idm_base
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,ns2-amac
+    then:
+      properties:
+        reg:
+          minItems: 3
+          maxItems: 3
+        reg-names:
+          items:
+            - const: amac_base
+            - const: idm_base
+            - const: nicpm_base
+
+properties:
+  compatible:
+    enum:
+      - brcm,amac
+      - brcm,nsp-amac
+      - brcm,ns2-amac
+
+  interrupts:
+    maxItems: 1
+
+
+unevaluatedProperties: false
+
+examples:
+  - |
+   #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+   amac0: ethernet@18022000 {
+      compatible = "brcm,nsp-amac";
+      reg = <0x18022000 0x1000>,
+            <0x18110000 0x1000>;
+      reg-names = "amac_base", "idm_base";
+      interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
+   };
diff --git a/MAINTAINERS b/MAINTAINERS
index eb0f6caf0062..6b32420bd9bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3872,7 +3872,7 @@ M:	Rafał Miłecki <rafal@milecki.pl>
 M:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/brcm,amac.txt
+F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
 F:	drivers/net/ethernet/broadcom/bgmac*
 F:	drivers/net/ethernet/broadcom/unimac.h
 
-- 
2.25.1

