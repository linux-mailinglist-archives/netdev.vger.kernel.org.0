Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7746862E75B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbiKQV4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240921AbiKQV4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:56:07 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462036D48A;
        Thu, 17 Nov 2022 13:56:01 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8AB501C0003;
        Thu, 17 Nov 2022 21:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668722160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zNmqXmrBbcTNgLtoIA7DR43d6CFoTKHtYTDfSnIwJT8=;
        b=jeh5ac9IpZEJRqXqOYME4oV0/qD8l8wriBZxtyHww+YKrtKe0qzYEhEb4FLSoI39XQYEX5
        vNXKgA9jxTahGm3HhAj3tI8sJ35FM6IaLSazwxmfY34JWFc99ukRL+5Oou+XTOmsEdXAyT
        YGyXeuyfdhMbI/Zy4dFJrg4Z9hbjIeyTOHgNB/G+PQvUmPRu8gS/TlWHBf3Yz29ZAc6pfD
        MZRkXtL3u286attLAiQ+c4sVBqg3qpNXkGAZz9xMV5LAXz2RDfMF10JQv/wMR5Cs2LueKB
        AmVHP7Z8v60YeDhtUNax8qgd71rDtDopkS1JpnHVbAACWNe0vvs0ky+txCdF2A==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 0/6] Marvell nvmem mac addresses support
Date:   Thu, 17 Nov 2022 22:55:51 +0100
Message-Id: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Now that we are aligned on how to make information available from static
storage media to drivers like Ethernet controller drivers or switch
drivers by using nvmem cells and going through the whole nvmem
infrastructure, here are two driver updates to reflect these changes.

Prior to the driver updates, I propose:
* Reverting binding changes which should have never been accepted like
  that.
* A conversion of the (old) Prestera and DFX server bindings (optional,
  can be dropped if not considered necessary).
* A better description of the more recent Prestera PCI switch.

Please mind that this series cannot break anything since retrieving the
MAC address Prestera driver has never worked upstream, because the (ONIE
tlv) driver supposed to export the MAC address has not been accepted in
its original form and has been updated to the nvmem-layout
infrastructure (bindings have been merged, the code remains to be
applied).

Thanks,
Miquèl

Miquel Raynal (6):
  Revert "dt-bindings: marvell,prestera: Add description for device-tree
    bindings"
  dt-bindings: net: marvell,dfx-server: Convert to yaml
  dt-bindings: net: marvell,prestera: Convert to yaml
  dt-bindings: net: marvell,prestera: Describe PCI devices of the
    prestera family
  net: marvell: prestera: Avoid unnecessary DT lookups
  net: mvpp2: Consider NVMEM cells as possible MAC address source

 .../bindings/net/marvell,dfx-server.yaml      | 60 +++++++++++++
 .../bindings/net/marvell,prestera.txt         | 81 -----------------
 .../bindings/net/marvell,prestera.yaml        | 86 +++++++++++++++++++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  6 ++
 .../ethernet/marvell/prestera/prestera_main.c | 15 +---
 5 files changed, 156 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.yaml

-- 
2.34.1

