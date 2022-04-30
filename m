Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6EC515D2F
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376697AbiD3NHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiD3NHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:07:24 -0400
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDCC8071F;
        Sat, 30 Apr 2022 06:04:01 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout3.routing.net (Postfix) with ESMTP id DA8BC6054A;
        Sat, 30 Apr 2022 13:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1651323839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=E/DjbKxcbIiIW9rYKpEMs3z/xZdjhL53L8stR7y8sO4=;
        b=c/b2QyYwrIXU5MbbqgvfcAfL4FUW9cZZKO0WzmDYe7xspvdKnTqhl3uEd3tymKqcZ2zZ59
        UG0RabZgG7IZYViF/AZ6N+MnHtUdzPBYfsByChAIUePYmEx8natLwxwu3IcmdSKWNz/JFn
        //VNzhNLCclCBauqbsf/bSVec02HjAg=
Received: from localhost.localdomain (fttx-pool-80.245.72.211.bambit.de [80.245.72.211])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 5AC8B3600EF;
        Sat, 30 Apr 2022 13:03:57 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v2 0/4] Support mt7531 on BPI-R2 Pro
Date:   Sat, 30 Apr 2022 15:03:43 +0200
Message-Id: <20220430130347.15190-1-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: b931c4e7-0a19-447e-82b1-0aeac9a6c684
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Due to the Changes i also made a regression Test on mt7623 bpi-r2 using
mt7530 with cpu-port 6. Tests were done directly (ipv4 config on dsa user
port) and with vlan-aware bridge including vlan that was tagged outgoing
on dsa user port.

Frank Wunderlich (4):
  net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}
  net: dsa: mt7530: rework mt753[01]_setup
  net: dsa: mt7530: get cpu-port via dp->cpu_dp instead of constant
  arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board

 .../boot/dts/rockchip/rk3568-bpi-r2-pro.dts   | 48 +++++++++++
 drivers/net/dsa/mt7530.c                      | 81 ++++++++++++-------
 drivers/net/dsa/mt7530.h                      |  1 -
 3 files changed, 100 insertions(+), 30 deletions(-)

-- 
2.25.1

