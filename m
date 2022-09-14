Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1E95B90E8
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiINXOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiINXOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:14:08 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC492895D0;
        Wed, 14 Sep 2022 16:14:05 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc25a.ko.seznam.cz (email-smtpc25a.ko.seznam.cz [10.53.18.34])
        id 5e651455bac9c76b5fb8b53b;
        Thu, 15 Sep 2022 01:13:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1663197199; bh=KfzDDufQO0EmyWPeN8vROr7WTX1Av+h27clBNarB/G0=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding;
        b=bumWD9bZYR6ZznmdEYs95TRJ8vSBbhVxa7X+DOAU1vsNXyARV0U1ERC2p3mfhPBeB
         rYwltjHo6uYSuFKdmcx36wq7nTRHCSduFCrW02+hkfuZGwrXjVJvqd4aomNvhwnWKr
         08Fx4DQdjFIEZVl2JLaHUacWIEzckteE1/pEvq20=
Received: from localhost.localdomain (2a02:8308:900d:2400:4bcc:f22e:1266:5194 [2a02:8308:900d:2400:4bcc:f22e:1266:5194])
        by email-relay23.ko.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Thu, 15 Sep 2022 01:13:18 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: [PATCH v3 1/3] dt-bindings: can: ctucanfd: add another clock for HW timestamping
Date:   Thu, 15 Sep 2022 01:12:47 +0200
Message-Id: <20220914231249.593643-2-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914231249.593643-1-matej.vasilevski@seznam.cz>
References: <20220914231249.593643-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add second clock phandle to specify the timestamping clock.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 .../bindings/net/can/ctu,ctucanfd.yaml        | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
index 4635cb96fc64..432f0e3ed828 100644
--- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
@@ -44,9 +44,19 @@ properties:
 
   clocks:
     description: |
-      phandle of reference clock (100 MHz is appropriate
-      for FPGA implementation on Zynq-7000 system).
-    maxItems: 1
+      Phandle of reference clock (100 MHz is appropriate for FPGA
+      implementation on Zynq-7000 system). Optionally add a phandle to
+      the timestamping clock connected to timestamping counter, if used.
+    minItems: 1
+    items:
+      - description: core clock
+      - description: timestamping clock
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core-clk
+      - const: ts-clk
 
 required:
   - compatible
@@ -61,6 +71,7 @@ examples:
     ctu_can_fd_0: can@43c30000 {
       compatible = "ctu,ctucanfd";
       interrupts = <0 30 4>;
-      clocks = <&clkc 15>;
+      clocks = <&clkc 15>, <&clkc 16>;
+      clock-names = "core-clk", "ts-clk";
       reg = <0x43c30000 0x10000>;
     };
-- 
2.25.1

