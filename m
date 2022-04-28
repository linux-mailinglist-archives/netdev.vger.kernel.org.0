Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5DB5132BD
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345638AbiD1LoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345591AbiD1LoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:44:10 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65AB6160A;
        Thu, 28 Apr 2022 04:40:56 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6DCF022248;
        Thu, 28 Apr 2022 13:40:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651146054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JiqBZQ8WhL/HQE3t9cKCnkvxEmKUyQmiYVcw2DHH7vU=;
        b=Llz0IEVyKKiZbUNetON7vPZE3J79hfcmVS88zCke5AyvvzwIySsM+PiCkBj4MTXMRadyJK
        q99b3vauhfJxqqfv7uCb+pbNxEnxmz1Q6CRrYl19KOWCEB6iEsgTCyGEXuBjBTZWqPNcKG
        l89th19gkY44IZUl7d5Tuo0E906cZAg=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/2] dt-bindings: net: lan966x: remove PHY reset
Date:   Thu, 28 Apr 2022 13:40:48 +0200
Message-Id: <20220428114049.1456382-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428114049.1456382-1-michael@walle.cc>
References: <20220428114049.1456382-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY reset was intended to be a phandle for a special PHY reset
driver for the integrated PHYs as well as any external PHYs. It turns
out, that the culprit is how the reset of the switch device is done.
In particular, the switch reset also affects other subsystems like
the GPIO and the SGPIO block and it happens to be the case that the
reset lines of the external PHYs are connected to a common GPIO line.
Thus as soon as the switch issues a reset during probe time, all the
external PHYs will go into reset because all the GPIO lines will
switch to input and the pull-down on that signal will take effect.

So even if there was a special PHY reset driver, it (1) won't fix
the root cause of the problem and (2) it won't fix all the other
consumers of GPIO lines which will also be reset.

It turns out, the Ocelot SoC has the same weird behavior (or the
lack of a dedicated switch reset) and there the problem is already
solved and all the bits and pieces are already there and this PHY
reset property isn't not needed at all.

There are no users of this binding. Just remove it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index 131dc5a652de..f3ed708de0eb 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -53,12 +53,10 @@ properties:
   resets:
     items:
       - description: Reset controller used for switch core reset (soft reset)
-      - description: Reset controller used for releasing the phy from reset
 
   reset-names:
     items:
       - const: switch
-      - const: phy
 
   ethernet-ports:
     type: object
-- 
2.30.2

