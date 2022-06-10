Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982EF546B77
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350140AbiFJRGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349135AbiFJRGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:06:18 -0400
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C627FE2;
        Fri, 10 Jun 2022 10:06:14 -0700 (PDT)
Received: from mxbox2.masterlogin.de (unknown [192.168.10.89])
        by mxout2.routing.net (Postfix) with ESMTP id 015A060407;
        Fri, 10 Jun 2022 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1654880773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muhHy3u6o7qlrEhJK4TIIhDI8FS0kFjcupuOglkyEww=;
        b=Ea8GWlilsZRa7b9SZmJA/cus7/asdVVglnpJSOV5gEioGqrq7ZHA/W15M3iYNfAjiKHvaX
        Qsot5FRIG+5R8x2m/yr1E/9CBG22RHvZyFf1KqCRMDsimU4aHz4B7M8l/KaVCWBuwyJ22B
        3MWLvHbscK4z429CMe8yfYt27RMcPJU=
Received: from frank-G5.. (fttx-pool-217.61.154.155.bambit.de [217.61.154.155])
        by mxbox2.masterlogin.de (Postfix) with ESMTPSA id BA712100863;
        Fri, 10 Jun 2022 17:06:11 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>
Subject: [PATCH v4 5/6] dt-bindings: net: dsa: make reset optional and add rgmii-mode to mt7531
Date:   Fri, 10 Jun 2022 19:05:40 +0200
Message-Id: <20220610170541.8643-6-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610170541.8643-1-linux@fw-web.de>
References: <20220610170541.8643-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 608a6b67-0651-4348-8dfb-93f736e41a27
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

A board may have no independent reset-line, so reset cannot be used
inside switch driver.

E.g. on Bananapi-R2 Pro switch and gmac are connected to same reset-line.

Resets should be acquired only to 1 device/driver. This prevents reset to
be bound to switch-driver if reset is already used for gmac. If reset is
only used by switch driver it resets the switch *and* the gmac after the
mdio bus comes up resulting in mdio bus goes down. It takes some time
until all is up again, switch driver tries to read from mdio, will fail
and defer the probe. On next try the reset does the same again.

Make reset optional for such boards.

Allow port 5 as cpu-port and phy-mode rgmii for mt7531.

- MT7530 supports RGMII on port 5 and RGMII/TRGMII on port 6.
- MT7531 supports on port 5 RGMII and SGMII (dual-sgmii) and
  SGMII on port 6.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
v4:
 - add port 5 as CPU-Port
 - change description
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml      | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 112cfaa7e3f6..a3bf432960d8 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -55,6 +55,7 @@ description: |
     On mt7531:
       - "1000base-x"
       - "2500base-x"
+      - "rgmii"
       - "sgmii"
 
 
@@ -124,8 +125,8 @@ patternProperties:
         properties:
           reg:
             description:
-              Port address described must be 6 for CPU port and from 0 to
-              5 for user ports.
+              Port address described must be 5 or 6 for CPU port and from 0
+              to 5 for user ports.
 
         allOf:
           - $ref: dsa-port.yaml#
@@ -152,9 +153,6 @@ allOf:
       required:
         - resets
         - reset-names
-    else:
-      required:
-        - reset-gpios
 
   - dependencies:
       interrupt-controller: [ interrupts ]
-- 
2.34.1

