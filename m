Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A68760CDF7
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiJYNw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiJYNwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:52:55 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9E810EA37;
        Tue, 25 Oct 2022 06:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1666705974;
  x=1698241974;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p7U8I67mF6NDNUZeQCb+UeXPQC/C0xbRNq5j4mfvbug=;
  b=eSrO08GzoDE2pOgY4we/boRR05sdFJkAthUmJ0DNw4flBJAvMJ6JYP2z
   aDanOBKFhxuEKgsGtfTtlOG0nrnnVgYYARpLN9Cy/2cGKi+kufvNiCD3+
   cwcQlIBa+ESC5dz2OiA9kP88sABSjqhfib+vFTD4rBpCncN768jVl1gbC
   B+8N5DEB6JzPdl0kkK5urTBWmzg1VBp2zaSeuwJXh1LPK+Cvv1kq4DPLg
   r2Ew4DiQa6EH1++L+sK30X7qTS1xPKGF3gyzRBjmdPaoI32rMK2Y7fYtl
   y+BgblGgMenxBO4ZFDlONx/W4+WcGx4Ek/qzClBWgRsWPji3QXXD3FwTk
   w==;
From:   Camel Guo <camel.guo@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>, Camel Guo <camel.guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>,
        <kernel@axis.com>
Subject: [RFC net-next 0/2] DSA driver draft for MaxLinear's gsw1xx series switch
Date:   Tue, 25 Oct 2022 15:52:39 +0200
Message-ID: <20221025135243.4038706-1-camel.guo@axis.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,TO_EQ_FM_DIRECT_MX,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

Recently I had been working on implementing DSA driver for MaxLinear GSW145
switch. Here is my initial draft. Before proceeding futher, I am hoping to
get comments and cooperation as early/many as possible.

On my hand, I have an arm64 board with one GSW145 chip being connected via
MDIO management interface. According to the public datasheet of GSW145, the
chip itself on my board is in self-start (PS_NOWAIT=1b), managed switch
(PS_OP_MD=11) mode. On this board, only two slave ethernet ports (port0,
port1) of this chip are enabled.

As its datasheet says, this chip supports MDIO, SPI, UART management
interfaces in many operation modes (self-start/non-self-start,
managed/standalone). Unfortunately it is impossible for me to run this
draft on all of these combinations. It will be very helpful if anyone can
help to run it on different hardware setups and send the feedback back to
me.

I also noticed that lantiq_gswip.c looks similar as gsw145. I have no
access to the datasheet of the chip this file supports. Maybe they can be
merged together.

Best Regards
Camel Guo

Camel Guo (2):
  dt-bindings: net: dsa: add bindings for GSW Series switches
  net: dsa: Add driver for Maxlinear GSW1XX switch

 .../devicetree/bindings/net/dsa/mxl,gsw.yaml  | 140 +++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   9 +
 drivers/net/dsa/Kconfig                       |  16 +
 drivers/net/dsa/Makefile                      |   2 +
 drivers/net/dsa/gsw1xx.h                      |  27 +
 drivers/net/dsa/gsw1xx_core.c                 | 823 ++++++++++++++++++
 drivers/net/dsa/gsw1xx_mdio.c                 | 128 +++
 8 files changed, 1147 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
 create mode 100644 drivers/net/dsa/gsw1xx.h
 create mode 100644 drivers/net/dsa/gsw1xx_core.c
 create mode 100644 drivers/net/dsa/gsw1xx_mdio.c


base-commit: 6143eca3578f486e4d58fe6fb5e96a5699c86fbc
-- 
2.30.2

