Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8911D4932A1
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 02:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350824AbiASB4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 20:56:38 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:39838 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343660AbiASB4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 20:56:37 -0500
Received: by mail-oi1-f180.google.com with SMTP id e81so1797550oia.6;
        Tue, 18 Jan 2022 17:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wf3QfWa0o4iQEIPew7kPqgEBCS1aITPaR6wQQYpPFcE=;
        b=ANKLwyGRj9c2JbPwC8b3bskU6/U/QzPM3QK8g+48aBoztvxIVNdW9u38VDK6XgSAlA
         rYFjAlD+Le8ZecD3rLVQMsUmAqZFE8D6apAEmkgmLJuggdNmON57Q+ePT7/xCutSJ6Rk
         960Xprr7uwO65VmbEsF4hKqHh6RYiyk8206xNCQU8Cds9TrnzdU/+jInpflzgXnRBCnA
         /hBar71+HuflptXPambv0/D27WQacKJTJsLqASYPW19oi9Z5ZgyDaK2rl23Ipon6PF8p
         9WwG5JxrkOs05LLVWrNFi82dOFk+FdqQQ6eJXoCB5pV1n4Zh7mN0CTcXRjCICwC92nzJ
         xkUA==
X-Gm-Message-State: AOAM532MbV96XmpV4N8QekZcepWQND/BkBtfimiEyMZf/HXDauSqnJI/
        TsWteRcpd/LRxDUd7BhT1g==
X-Google-Smtp-Source: ABdhPJygcWIZ8vtMALAbJS4CYqdRCdtB02s/KRTBFTnN1u7t+XEdKdjiET5AluiBIzT3XI7OU09Xxg==
X-Received: by 2002:aca:1a08:: with SMTP id a8mr1148354oia.22.1642557396376;
        Tue, 18 Jan 2022 17:56:36 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id e69sm7912096ote.1.2022.01.18.17.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 17:56:35 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Sriram Dash <sriram.dash@samsung.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: Fix array schemas encoded as matrices
Date:   Tue, 18 Jan 2022 19:56:26 -0600
Message-Id: <20220119015627.2443334-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The YAML DT encoding has leaked into some array properties. Properties
which are defined as an array should have a schema that's just an array.
That means there should only be a single level of 'minItems',
'maxItems', and/or 'items'.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/media/nxp,imx7-mipi-csi2.yaml    | 12 ++--
 .../bindings/media/nxp,imx8mq-mipi-csi2.yaml  | 12 ++--
 .../bindings/net/can/bosch,m_can.yaml         | 52 ++++++++--------
 .../bindings/net/ethernet-controller.yaml     | 59 +++++++++----------
 4 files changed, 62 insertions(+), 73 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml b/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
index 1ef849dc74d7..e2e6e9aa0fe6 100644
--- a/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
@@ -81,14 +81,12 @@ properties:
               data-lanes:
                 description:
                   Note that 'fsl,imx7-mipi-csi2' only supports up to 2 data lines.
+                minItems: 1
                 items:
-                  minItems: 1
-                  maxItems: 4
-                  items:
-                    - const: 1
-                    - const: 2
-                    - const: 3
-                    - const: 4
+                  - const: 1
+                  - const: 2
+                  - const: 3
+                  - const: 4
 
             required:
               - data-lanes
diff --git a/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml b/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml
index d13c9233a7c8..2a14e3b0e004 100644
--- a/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml
@@ -87,14 +87,12 @@ properties:
 
             properties:
               data-lanes:
+                minItems: 1
                 items:
-                  minItems: 1
-                  maxItems: 4
-                  items:
-                    - const: 1
-                    - const: 2
-                    - const: 3
-                    - const: 4
+                  - const: 1
+                  - const: 2
+                  - const: 3
+                  - const: 4
 
             required:
               - data-lanes
diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index fb547e26c676..401ab7cdb379 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -76,33 +76,31 @@ properties:
       M_CAN user manual for details.
     $ref: /schemas/types.yaml#/definitions/int32-array
     items:
-      items:
-        - description: The 'offset' is an address offset of the Message RAM where
-            the following elements start from. This is usually set to 0x0 if
-            you're using a private Message RAM.
-          default: 0
-        - description: 11-bit Filter 0-128 elements / 0-128 words
-          minimum: 0
-          maximum: 128
-        - description: 29-bit Filter 0-64 elements / 0-128 words
-          minimum: 0
-          maximum: 64
-        - description: Rx FIFO 0 0-64 elements / 0-1152 words
-          minimum: 0
-          maximum: 64
-        - description: Rx FIFO 1 0-64 elements / 0-1152 words
-          minimum: 0
-          maximum: 64
-        - description: Rx Buffers 0-64 elements / 0-1152 words
-          minimum: 0
-          maximum: 64
-        - description: Tx Event FIFO 0-32 elements / 0-64 words
-          minimum: 0
-          maximum: 32
-        - description: Tx Buffers 0-32 elements / 0-576 words
-          minimum: 0
-          maximum: 32
-    maxItems: 1
+      - description: The 'offset' is an address offset of the Message RAM where
+          the following elements start from. This is usually set to 0x0 if
+          you're using a private Message RAM.
+        default: 0
+      - description: 11-bit Filter 0-128 elements / 0-128 words
+        minimum: 0
+        maximum: 128
+      - description: 29-bit Filter 0-64 elements / 0-128 words
+        minimum: 0
+        maximum: 64
+      - description: Rx FIFO 0 0-64 elements / 0-1152 words
+        minimum: 0
+        maximum: 64
+      - description: Rx FIFO 1 0-64 elements / 0-1152 words
+        minimum: 0
+        maximum: 64
+      - description: Rx Buffers 0-64 elements / 0-1152 words
+        minimum: 0
+        maximum: 64
+      - description: Tx Event FIFO 0-32 elements / 0-64 words
+        minimum: 0
+        maximum: 32
+      - description: Tx Buffers 0-32 elements / 0-576 words
+        minimum: 0
+        maximum: 32
 
   power-domains:
     description:
diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 47b5f728701d..34c5463abcec 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -17,9 +17,8 @@ properties:
     description:
       Specifies the MAC address that was assigned to the network device.
     $ref: /schemas/types.yaml#/definitions/uint8-array
-    items:
-      - minItems: 6
-        maxItems: 6
+    minItems: 6
+    maxItems: 6
 
   mac-address:
     description:
@@ -28,9 +27,8 @@ properties:
       to the device by the boot program is different from the
       local-mac-address property.
     $ref: /schemas/types.yaml#/definitions/uint8-array
-    items:
-      - minItems: 6
-        maxItems: 6
+    minItems: 6
+    maxItems: 6
 
   max-frame-size:
     $ref: /schemas/types.yaml#/definitions/uint32
@@ -164,33 +162,30 @@ properties:
           type: array
         then:
           deprecated: true
-          minItems: 1
-          maxItems: 1
           items:
-            items:
-              - minimum: 0
-                maximum: 31
-                description:
-                  Emulated PHY ID, choose any but unique to the all
-                  specified fixed-links
-
-              - enum: [0, 1]
-                description:
-                  Duplex configuration. 0 for half duplex or 1 for
-                  full duplex
-
-              - enum: [10, 100, 1000, 2500, 10000]
-                description:
-                  Link speed in Mbits/sec.
-
-              - enum: [0, 1]
-                description:
-                  Pause configuration. 0 for no pause, 1 for pause
-
-              - enum: [0, 1]
-                description:
-                  Asymmetric pause configuration. 0 for no asymmetric
-                  pause, 1 for asymmetric pause
+            - minimum: 0
+              maximum: 31
+              description:
+                Emulated PHY ID, choose any but unique to the all
+                specified fixed-links
+
+            - enum: [0, 1]
+              description:
+                Duplex configuration. 0 for half duplex or 1 for
+                full duplex
+
+            - enum: [10, 100, 1000, 2500, 10000]
+              description:
+                Link speed in Mbits/sec.
+
+            - enum: [0, 1]
+              description:
+                Pause configuration. 0 for no pause, 1 for pause
+
+            - enum: [0, 1]
+              description:
+                Asymmetric pause configuration. 0 for no asymmetric
+                pause, 1 for asymmetric pause
 
 
       - if:
-- 
2.32.0

