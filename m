Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDDC4E5876
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343544AbiCWSgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237928AbiCWSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:36:01 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0B664BDD;
        Wed, 23 Mar 2022 11:34:30 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 277FB22238;
        Wed, 23 Mar 2022 19:34:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648060469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vO8LtpVxs/SG4LP+EIbUtQ6dKdMIxW7dBZiiQyLBuXk=;
        b=Ojck0E/1HtzFGDLB7IviQABkc8mkQhaVxZ1xkUdO+LHddkCoZimaRkbq5qr0D9iMgAqr09
        yee0RLnWdYvoCS6P8az7IAuy3E2Cdqj59WnJfJgDiU+pg2hI8WhhZxGsiqscTzb/PaCFWI
        e2Kz7P0IQwl9ynDm5z8FpKynicfU9ic=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next 0/5] net: phy: C45-over-C22 access
Date:   Wed, 23 Mar 2022 19:34:14 +0100
Message-Id: <20220323183419.2278676-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the result of this discussion:
https://lore.kernel.org/netdev/240354b0a54b37e8b5764773711b8aa3@walle.cc/

The goal here is to get the GYP215 and LAN8814 running on the Microchip
LAN9668 SoC. The LAN9668 suppports one external bus and unfortunately, the
LAN8814 has a bug which makes it impossible to use C45 on that bus.
Fortunately, it was the intention of the GPY215 driver to be used on a C22
bus. But I think this could have never really worked, because the
phy_get_c45_ids() will always do c45 accesses and thus on MDIO bus drivers
which will correctly check for the MII_ADDR_C45 flag and return -EOPNOTSUPP
the function call will fail and thus gpy_probe() will fail. This series
tries to fix that and will lay the foundation to add a workaround for the
LAN8814 bug by forcing an MDIO bus to be c22-only.

At the moment, the probe_capabilities is taken into account to decide if
we have to use C45-over-C22. What is still missing from this series is the
handling of a device tree property to restrict the probe_capabilities to
c22-only.

Since net-next is closed, this is marked as RFC to get some early feedback.

Michael Walle (5):
  net: phy: mscc-miim: reject clause 45 register accesses
  net: phy: support indirect c45 access in get_phy_c45_ids()
  net: phy: mscc-miim: add probe_capabilities
  net: phy: introduce is_c45_over_c22 flag
  net: phylink: handle the new is_c45_over_c22 property

 drivers/net/mdio/mdio-mscc-miim.c |  7 ++++
 drivers/net/phy/mxl-gpy.c         |  2 +-
 drivers/net/phy/phy_device.c      | 65 ++++++++++++++++++++++++++-----
 drivers/net/phy/phylink.c         |  2 +-
 include/linux/phy.h               |  4 +-
 5 files changed, 68 insertions(+), 12 deletions(-)

-- 
2.30.2

