Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C78546B53
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbiFJRGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbiFJRGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:06:11 -0400
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FB618B28;
        Fri, 10 Jun 2022 10:06:09 -0700 (PDT)
Received: from mxbox2.masterlogin.de (unknown [192.168.10.89])
        by mxout3.routing.net (Postfix) with ESMTP id 759B7604C3;
        Fri, 10 Jun 2022 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1654880766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pDrlZAy3kJCxHKJSLpDfcRAgAZ5uvq2tLGud8Ozt00E=;
        b=xGbp7x7si1B6h/1C0Jfk2q+eiwlESBh2O7MtEPJYQy5+n8FyxKi1gr5ZLtWFqJvIA7JeGb
        jQ+iU5pw0t5w9zxkPGnUQxZb+fdh8IYzcOYTKrLHZaPKaqUKEiaU95Yt6i1na3AnZk3Zlg
        meTpB1Zadm2jjbOo3eHT8wMlmkp+eTg=
Received: from frank-G5.. (fttx-pool-217.61.154.155.bambit.de [217.61.154.155])
        by mxbox2.masterlogin.de (Postfix) with ESMTPSA id 6F413100863;
        Fri, 10 Jun 2022 17:06:04 +0000 (UTC)
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
Subject: [PATCH v4 0/6] Support mt7531 on BPI-R2 Pro
Date:   Fri, 10 Jun 2022 19:05:35 +0200
Message-Id: <20220610170541.8643-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 2b0c5315-20fe-4f65-8769-27f3112e1833
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

This Series add Support for the mt7531 switch on Bananapi R2 Pro board.

This board uses port5 of the switch to conect to the gmac0 of the
rk3568 SoC.

Currently CPU-Port is hardcoded in the mt7530 driver to port 6.

Compared to v1 the reset-Patch was dropped as it was not needed and
CPU-Port-changes are completely rewriten based on suggestions/code from
Vladimir Oltean (many thanks to this).
In DTS Patch i only dropped the status-property that was not
needed/ignored by driver.

Due to the Changes i also made a regression test on mt7623 bpi-r2
(mt7623 soc + mt7530) and bpi-r64 (mt7622 soc + mt7531) with cpu-
port 6. Tests were done directly (ipv4 config on dsa user port)
and with vlan-aware bridge including vlan that was tagged outgoing
on dsa user port.

v4: 
- rebase on 5.19-rc1
- some changes in bindings-document and fix wrong squashing from v3

Frank Wunderlich (6):
  dt-bindings: net: dsa: convert binding for mediatek switches
  net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}
  net: dsa: mt7530: rework mt753[01]_setup
  net: dsa: mt7530: get cpu-port via dp->cpu_dp instead of constant
  dt-bindings: net: dsa: make reset optional and add rgmii-mode to
    mt7531
  arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board

 .../bindings/net/dsa/mediatek,mt7530.yaml     | 404 ++++++++++++++++++
 .../devicetree/bindings/net/dsa/mt7530.txt    | 327 --------------
 .../boot/dts/rockchip/rk3568-bpi-r2-pro.dts   |  48 +++
 drivers/net/dsa/mt7530.c                      |  82 ++--
 drivers/net/dsa/mt7530.h                      |   1 -
 5 files changed, 505 insertions(+), 357 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt

-- 
2.34.1

