Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12209658334
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiL1Qo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 11:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiL1Qoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 11:44:34 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657BE1CB1B;
        Wed, 28 Dec 2022 08:40:15 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 94A29126D;
        Wed, 28 Dec 2022 17:40:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672245613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OF6pNjdZAXe8urQNvfbusgLAE7XXO8YnOK8O7h3K4sk=;
        b=Ah1y53r1SoaYhGaLT1mCfX0ZzP3dffDssK1tuulZ5b3k/asOK0d/ha5BdoFml52iFM1pXV
        kfrp17rsGQU0nMTHTp1Ol5x85QL7TWcPDfByIakREo3aXIme0FvsQgDm5gJ1ce4L8xNAwk
        3N4qkbT1Ur7KeqdgNnwvazdIa2GFZTUMNFxvuHSi/yMGpqsRDYIKyEaPHtPF5XkXfyrBOX
        uUn8M4yxcJUcevUCn9SW78t1TXZNoI5zMxWgxA6JFbHkKr+foIAJiFHmTrEUlCAB2igNR4
        RUVvPJZE/4TwFUFuSoeof6Pl6KkcDIsXoJ9iWO5hzl8HbNIuUgn4K15WEfgONw==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 0/2] net: phy: mxl-gpy: broken interrupt fixes
Date:   Wed, 28 Dec 2022 17:40:06 +0100
Message-Id: <20221228164008.1653348-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GPY215 has a broken interrupt pin. This patch series tries to
workaround that and because in general that is not possible, disables the
interrupts by default and falls back to polling mode. There is an opt-in
via the devicetree.

The devicetree binding is missing for now because there is still an
ongoing discussion. I'm sending this, because I want to get some feedback
on the new handling in the phy core. As Andrew pointed out, we cannot
change the irq in the PHY's .probe() because a MAC driver might overwrite
it afterwards, e.g. the stmmac does so. Instead introduce a new flag which
can be set by the PHY driver and which is evaluated just before the PHY is
attached and thus the interrupt is requested.

Btw. I'm not sure dev_flags is the correct place here. I couldn't see
when to use dev_flags and when to use the plain one-bit properties in the
struct phy_device. The latter seems to be used internally, but of course
there is at least one exception, the .mac_managed_pm is set by the MAC
drivers.

v2:
 - new handling of how to disable the interrupts

Michael Walle (2):
  net: phy: allow a phy to opt-out of interrupt handling
  net: phy: mxl-gpy: disable interrupts on GPY215 by default

 drivers/net/phy/mxl-gpy.c    | 5 +++++
 drivers/net/phy/phy_device.c | 7 +++++++
 include/linux/phy.h          | 2 ++
 3 files changed, 14 insertions(+)

-- 
2.30.2

