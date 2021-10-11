Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C28429287
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbhJKOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:50:13 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:31611 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhJKOuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1633963329;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=gFpR3noEQbyBfgeNBxMsroJzP2vhabFGl4TpXnW84AA=;
    b=c49Qt1sLOnqoCIkUu9BECP5Ev5Ljl83QrAcF4G89TU/4JeaeZ607N/ElYRO7kHRtZp
    /Wv11ruh7FUmsrWQg/aNNVcbc8JGprY8DkwJDPfWXdyCXXJyEwE0yRVQSNudlvs5kw8U
    Rrn25tx0Kxw6Tq7GMC2R9qD83s18KCHpYMypknXRqaXGp4wGskDvGqcWiAOLVzPB55vg
    BWe1g27VF3Nfp6bg3TeG8umSXtkmq1v9iCwcL0VYQ7iCh1DVt9MDhTKHDbO3PwSB2Lig
    DaEYKNGkBc40ZmFafC35AVApW+Qgrap8imH+plZnslHjL8r3F1MguyEl7dzEXSnoIyJl
    j2bg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXTbAOHjRHIhr3eFeIrw=="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.33.8 SBL|AUTH)
    with ESMTPSA id 301038x9BEg8tv9
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 11 Oct 2021 16:42:08 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v2 3/4] dt-bindings: net: Add schema for Qualcomm BAM-DMUX
Date:   Mon, 11 Oct 2021 16:17:35 +0200
Message-Id: <20211011141733.3999-4-stephan@gerhold.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011141733.3999-1-stephan@gerhold.net>
References: <20211011141733.3999-1-stephan@gerhold.net>
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
Changes since RFC: None.
---
 .../bindings/net/qcom,bam-dmux.yaml           | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
new file mode 100644
index 000000000000..33e125e70cb4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
@@ -0,0 +1,87 @@
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
2.33.0

