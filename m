Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D065C662598
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbjAIMaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbjAIMaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:30:25 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7835D1ADB9;
        Mon,  9 Jan 2023 04:30:23 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 5DF19164B;
        Mon,  9 Jan 2023 13:30:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673267421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZ7Vzky1BdtRbR9tf/hknfjGnQGFjK6uHVN2tAqUR48=;
        b=RTuO1odZs0w2M76H1FEFV3eKQe4v7gCl+bT2ZnjEt5Qsgwg0U+Y08UHRB4sFCq3Afoc5zm
        yFsMW9hmL7gCwSWYrB7duIRSnOkTCUxqKlH5hfC4lio1b9KPqGd7FEEmLunkIXDQHkJiKV
        sOujvZpTEM4svfbe+haAMl1RWfVV4v7sg5etKaJwDhq0fmfmCcGXgU/EgadIKnSOGejs8+
        u+rZVfqze4ZR1Rh1q8V2uap/lx2zWSgQcsuCHr7S/d3E6oYISzuQTcMMld3k/mCs1sa0Zm
        jUR0hMtuCdDrevOGSw9JLWPl89hP5ST4fKBk1xBwVf638Z4yCzs33kr47q830g==
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear GPY2xx bindings
Date:   Mon,  9 Jan 2023 13:30:11 +0100
Message-Id: <20230109123013.3094144-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109123013.3094144-1-michael@walle.cc>
References: <20230109123013.3094144-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the device tree bindings for the MaxLinear GPY2xx PHYs, which
essentially adds just one flag: maxlinear,use-broken-interrupts.

One might argue, that if interrupts are broken, just don't use
the interrupt property in the first place. But it needs to be more
nuanced. First, this interrupt line is also used to wake up systems by
WoL, which has nothing to do with the (broken) PHY interrupt handling.

Second and more importantly, there are devicetrees which have this
property set. Thus, within the driver we have to switch off interrupt
handling by default as a workaround. But OTOH, a systems designer who
knows the hardware and knows there are no shared interrupts for example,
can use this new property as a hint to the driver that it can enable the
interrupt nonetheless.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../bindings/net/maxlinear,gpy2xx.yaml        | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml

diff --git a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
new file mode 100644
index 000000000000..d71fa9de2b64
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/maxlinear,gpy2xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MaxLinear GPY2xx PHY
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Michael Walle <michael@walle.cc>
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  maxlinear,use-broken-interrupts:
+    description: |
+      Interrupts are broken on some GPY2xx PHYs in that they keep the
+      interrupt line asserted even after the interrupt status register is
+      cleared. Thus it is blocking the interrupt line which is usually bad
+      for shared lines. By default interrupts are disabled for this PHY and
+      polling mode is used. If one can live with the consequences, this
+      property can be used to enable interrupt handling.
+
+      Affected PHYs (as far as known) are GPY215B and GPY215C.
+    type: boolean
+
+dependencies:
+  maxlinear,use-broken-interrupts: [ interrupts ]
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            reg = <0>;
+            interrupts-extended = <&intc 0>;
+            maxlinear,use-broken-interrupts;
+        };
+    };
+
+...
-- 
2.30.2

