Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F6B52584D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359492AbiELX2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359476AbiELX2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:28:30 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070F06CAA0;
        Thu, 12 May 2022 16:28:22 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc4a.ng.seznam.cz (email-smtpc4a.ng.seznam.cz [10.23.10.105])
        id 3eb179d5da1daaeb3f6cd8bb;
        Fri, 13 May 2022 01:28:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1652398094; bh=tT36BMt5RTU18kDO/6Ppl9i81ue3qKeiDBo4NGebNnA=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:X-szn-frgn:
         X-szn-frgc;
        b=Ygm3WjqxUvy3wSpYRyW/gxOnCYmbfhg3lLHBeZsaQ4o0JCGSQ7xTldV9hJyv9Pvo5
         hxHpZzJhR6jFhqgxbgiCH2CePbCZ6D1/vyvQoYKgKGwevcjTLZl7uUuNq8MfxO5DCA
         buHnpQ40J8Sf1x5fZkx6xDOqCcqfqLO5M3N12ZA8=
Received: from localhost.localdomain (ip-89-176-234-80.net.upcbroadband.cz [89.176.234.80])
        by email-relay29.ng.seznam.cz (Seznam SMTPD 1.3.136) with ESMTP;
        Fri, 13 May 2022 01:28:07 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        pisa@cmp.felk.cvut.cz
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        ondrej.ille@gmail.com, martin.jerabek01@gmail.com,
        matej.vasilevski@seznam.cz
Subject: [RFC PATCH 2/3] dt-bindings: can: ctucanfd: add properties for HW timestamping
Date:   Fri, 13 May 2022 01:27:06 +0200
Message-Id: <20220512232706.24575-3-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <19d3cfc5-0b85-4380-b2d4-fdbbd8edd303>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for CTU CAN-FD IP core with necessary properties
to enable HW timestamping for platform devices. Since the timestamping
counter is provided by the system integrator usign those IP cores in
their FPGA design, we need to have the properties specified in device tree.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 .../bindings/net/can/ctu,ctucanfd.yaml        | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
index fb34d971dcb3..c3693dadbcd8 100644
--- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
@@ -41,9 +41,35 @@ properties:
 
   clocks:
     description: |
-      phandle of reference clock (100 MHz is appropriate
-      for FPGA implementation on Zynq-7000 system).
+      Phandle of reference clock (100 MHz is appropriate for FPGA
+      implementation on Zynq-7000 system). If you wish to use timestamps
+      from the core, add a second phandle with the clock used for timestamping
+      (can be the same as the first clock).
+    maxItems: 2
+
+  clock-names:
+    description: |
+      Specify clock names for the "clocks" property. The first clock name
+      doesn't matter, the second has to be "ts_clk". Timestamping frequency
+      is then obtained from the "ts_clk" clock. This takes precedence over
+      the ts-frequency property.
+      You can omit this property if you don't need timestamps.
+    maxItems: 2
+
+  ts-used-bits:
+    description: width of the timestamping counter
+    maxItems: 1
+    items:
+      minimum: 8
+      maximum: 64
+
+  ts-frequency:
+    description: |
+      Frequency of the timestamping counter. Set this if you want to get
+      timestamps, but you didn't set the timestamping clock in clocks property.
     maxItems: 1
+    items:
+      minimum: 1
 
 required:
   - compatible
@@ -58,6 +84,8 @@ examples:
     ctu_can_fd_0: can@43c30000 {
       compatible = "ctu,ctucanfd";
       interrupts = <0 30 4>;
-      clocks = <&clkc 15>;
+      clocks = <&clkc 15>, <&clkc 15>;
+      clock-names = "can_clk", "ts_clk";
       reg = <0x43c30000 0x10000>;
+      ts-used-bits = <64>;
     };
-- 
2.25.1

