Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6F63774C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiKXLQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiKXLQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:16:06 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8533A6F801;
        Thu, 24 Nov 2022 03:16:01 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 912B51C0003;
        Thu, 24 Nov 2022 11:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669288560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cjEyF9Ie26j30k+xWS+sGbqXthb9SDc8p5d5gfhe8Yc=;
        b=nlUfaEqhj6VJFwAc1HEeUT9yQvapv1nOxwPe7EzGqZ/RX+fZgGzR10X8Uz4HSzIZW1c8UG
        7ZUWG7aTC4waMHwVqTf7Y5ph89CLnwPRoGuwlq66roTmHyAiMiu2zlCYyNVK2HV58z5Pcw
        4BSkrCRn6q/LGdnvpm9QslMPqm+NG1ZiVQK08lCZaQ518MvtlIj/diXH75cNcWJnkibhC6
        4RHsdz1dWdTk1BxyhKAq3HD1Ub7bkM4T9IhvNjgpCjsUh96Vseq/yxvE2UHcVZcTMgcx+8
        grW27/0y4wDO0RhuplgEcnawE+cti8RiBbkXdsWOivEaqGYTdE+7DD+YAyL2lw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Marcin Wojtas <mw@semihalf.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next v2 0/7] Marvell nvmem mac addresses support
Date:   Thu, 24 Nov 2022 12:15:49 +0100
Message-Id: <20221124111556.264647-1-miquel.raynal@bootlin.com>
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

Changes in v2:
* Bindings:
  - Add Rob's tags.
  - Use "additionalProperties: \n type: object" in both yaml files.
  - Add missing PCI properties to the prestera example as suggested.
  - Added a limitation over the number of register entries in the
    dfx-server description.
* Drivers:
  - Export the of_ helper retrieving MAC addresses from nvmem cells.
  - Add a comment in mvpp2 to say that the nvmem lookup only is valid on
    OF enabled platforms as suggested by Marcin.

Miquel Raynal (7):
  Revert "dt-bindings: marvell,prestera: Add description for device-tree
    bindings"
  dt-bindings: net: marvell,dfx-server: Convert to yaml
  dt-bindings: net: marvell,prestera: Convert to yaml
  dt-bindings: net: marvell,prestera: Describe PCI devices of the
    prestera family
  of: net: export of_get_mac_address_nvmem()
  net: marvell: prestera: Avoid unnecessary DT lookups
  net: mvpp2: Consider NVMEM cells as possible MAC address source

 .../bindings/net/marvell,dfx-server.yaml      | 62 +++++++++++++
 .../bindings/net/marvell,prestera.txt         | 81 -----------------
 .../bindings/net/marvell,prestera.yaml        | 91 +++++++++++++++++++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 ++
 .../ethernet/marvell/prestera/prestera_main.c | 15 +--
 include/linux/of_net.h                        |  6 ++
 net/core/of_net.c                             |  5 +-
 7 files changed, 173 insertions(+), 94 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.yaml

-- 
2.34.1

