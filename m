Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61DE4600A6
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355799AbhK0Rry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:47:54 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.171]:22145 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355743AbhK0Rpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:45:52 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Nov 2021 12:45:52 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1638034591;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=jADl+0pzwalMNbG9yT9wWk2B3jNKOzevQ6az2e/MJF8=;
    b=F+tlBKLvD62KK2AerYnY+XNWaDMwC6U3QqMwoPNhaFMf+KiN3uCIdf/r06KvtAaP2N
    oge6qsLCGjmcnI2UsA+EG1+of+1MrckH53MsEbWsRz7ysNu+fbnkGdFG4Cv9mL6cJNOc
    yY9o8b6wHLPYCno8O2EuI25vaaeihCT4SABihfWiN3BzZY4NSjQQ7zaUK5Xut+CY/dOC
    VsvzCYsMCjTQ6Zng8to50Fx03D5JUsSyumraMRmw049+vK3m4W1G2mYAzPaOmV5/LP1+
    ImF2HHuUpvG5OKa9IRBDK0+eOu9dyb2w6KrEQNGV4uKGqKF+LIUw7v5HfJjqrKWPPmFx
    /hCw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXQ7UOGqRde+a0fiL/b+s="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.34.10 AUTH)
    with ESMTPSA id j03bcbxARHaUFuJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 27 Nov 2021 18:36:30 +0100 (CET)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v3 1/2] dt-bindings: net: Add schema for Qualcomm BAM-DMUX
Date:   Sat, 27 Nov 2021 18:31:07 +0100
Message-Id: <20211127173108.3992-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211127173108.3992-1-stephan@gerhold.net>
References: <20211127173108.3992-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BAM Data Multiplexer provides access to the network data channels of
modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
MSM8974. It is built using a simple protocol layer on top of a DMA engine
(Qualcomm BAM) and bidirectional interrupts to coordinate power control.

The device tree node combines the incoming interrupt with the outgoing
interrupts (smem-states) as well as the two DMA channels, which allows
the BAM-DMUX driver to request all necessary resources.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
Changes in v2: Clarify that bam-dmux does not directly describe a hardware
               block but actually a "firmware convention" that combines
               different hardware blocks that are described separately.
Changes since RFC: None.
---
 .../bindings/net/qcom,bam-dmux.yaml           | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
new file mode 100644
index 000000000000..b30544410d09
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
@@ -0,0 +1,92 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,bam-dmux.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm BAM Data Multiplexer
+
+maintainers:
+  - Stephan Gerhold <stephan@gerhold.net>
+
+description: |
+  The BAM Data Multiplexer provides access to the network data channels
+  of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
+  or MSM8974. It is built using a simple protocol layer on top of a DMA engine
+  (Qualcomm BAM DMA) and bidirectional interrupts to coordinate power control.
+
+  Note that this schema does not directly describe a hardware block but rather
+  a firmware convention that combines several other hardware blocks (such as the
+  DMA engine). As such it is specific to a firmware version, not a particular
+  SoC or hardware version.
+
+properties:
+  compatible:
+    const: qcom,bam-dmux
+
+  interrupts:
+    description:
+      Interrupts used by the modem to signal the AP.
+      Both interrupts must be declared as IRQ_TYPE_EDGE_BOTH.
+    items:
+      - description: Power control
+      - description: Power control acknowledgment
+
+  interrupt-names:
+    items:
+      - const: pc
+      - const: pc-ack
+
+  qcom,smem-states:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description: State bits used by the AP to signal the modem.
+    items:
+      - description: Power control
+      - description: Power control acknowledgment
+
+  qcom,smem-state-names:
+    description: Names for the state bits used by the AP to signal the modem.
+    items:
+      - const: pc
+      - const: pc-ack
+
+  dmas:
+    items:
+      - description: TX DMA channel phandle
+      - description: RX DMA channel phandle
+
+  dma-names:
+    items:
+      - const: tx
+      - const: rx
+
+required:
+  - compatible
+  - interrupts
+  - interrupt-names
+  - qcom,smem-states
+  - qcom,smem-state-names
+  - dmas
+  - dma-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    mpss: remoteproc {
+        bam-dmux {
+            compatible = "qcom,bam-dmux";
+
+            interrupt-parent = <&modem_smsm>;
+            interrupts = <1 IRQ_TYPE_EDGE_BOTH>, <11 IRQ_TYPE_EDGE_BOTH>;
+            interrupt-names = "pc", "pc-ack";
+
+            qcom,smem-states = <&apps_smsm 1>, <&apps_smsm 11>;
+            qcom,smem-state-names = "pc", "pc-ack";
+
+            dmas = <&bam_dmux_dma 4>, <&bam_dmux_dma 5>;
+            dma-names = "tx", "rx";
+        };
+    };
-- 
2.34.1

