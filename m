Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6042D587088
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbiHASsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiHASss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:48:48 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F8C23167;
        Mon,  1 Aug 2022 11:48:46 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc18b.ng.seznam.cz (email-smtpc18b.ng.seznam.cz [10.23.18.21])
        id 3b05ad68dfa97e563ad80c06;
        Mon, 01 Aug 2022 20:47:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1659379678; bh=c1KvwmLZdhUEgVU2jOvEY2ue8LwpFkky/fI9KKH782c=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:X-szn-frgn:
         X-szn-frgc;
        b=NdUz349Q2575gq7510ym8thaMPAbXwoYgGVLWhbhhcF1t/qL0vm9VYE1wPA4PVDTb
         4RDbDoDzO/PKhNsgHCdbcmxXkAdNGURuSZUyrzZ22rf67ZCXm7ZUFTerl/BrO5nB8c
         D7ZCxIjFn+ocxQ+2d57wOpvSvQY0sVoc6wY3Wyyc=
Received: from localhost.localdomain (2a02:8308:900d:2400:95cc:114a:1ae8:6a72 [2a02:8308:900d:2400:95cc:114a:1ae8:6a72])
        by email-relay1.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Mon, 01 Aug 2022 20:47:54 +0200 (CEST)  
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
Subject: [PATCH v2 2/3] dt-bindings: can: ctucanfd: add another clock for HW timestamping
Date:   Mon,  1 Aug 2022 20:46:55 +0200
Message-Id: <20220801184656.702930-3-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <d69395e2-1ddf-49ed-ada9-f5667a57026f>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add second clock phandle to specify the timestamping clock.
You can even use the same clock as the core, or define a fixed-clock
if you need something custom.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 .../bindings/net/can/ctu,ctucanfd.yaml        | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
index 4635cb96fc64..90390530f909 100644
--- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
@@ -44,9 +44,23 @@ properties:
 
   clocks:
     description: |
-      phandle of reference clock (100 MHz is appropriate
-      for FPGA implementation on Zynq-7000 system).
-    maxItems: 1
+      Phandle of reference clock (100 MHz is appropriate for FPGA
+      implementation on Zynq-7000 system). If you wish to use timestamps
+      from the controller, add a second phandle with the clock used for
+      timestamping. The timestamping clock is optional, if you don't
+      add it here, the driver will use the primary clock frequency for
+      timestamp calculations. If you need something custom, define
+      a fixed-clock oscillator and reference it.
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
@@ -61,6 +75,7 @@ examples:
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

