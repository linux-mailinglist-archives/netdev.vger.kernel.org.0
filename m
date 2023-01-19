Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3967867397E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjASNIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjASNIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:08:05 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC9E611F2;
        Thu, 19 Jan 2023 05:07:59 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D398E1693;
        Thu, 19 Jan 2023 14:07:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674133678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3UHdwuLPhXMunD6/Q87hv9DQ5vVyKhuoTXpWSJ50hAQ=;
        b=Yoyi9wo7/ZF287RuEL0Zgg/52fWFCovu59p10HaO7ExZWnSijGhagfN7KX0DoxF7oYxDSq
        M+KCaMyotjb4vR1ipKfm0jZurv/qtSEeHn3k2MBmoup4fqN7hyPZF0NL3kH3ZXnukz1I8Z
        zuOvBNd71Cwf9CpB0RuMm29LzZ9N4+CehbSluy0+PEndsy5dUvRG5kEczhVyBu+fC9Gcz6
        2rq2ExxRuOwclB7aNgylEVQylsdVw/oTTHc93iE33XwEfPJNC6soVVFuSt32RV9PQnLZds
        r5bbOdfF/JkFya9dsUK2HmYbukHd31JOGdpt8jrhfUYuhG8Thkf7gNUpgviUJQ==
From:   Michael Walle <michael@walle.cc>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wells Lu <wellslutw@gmail.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RESEND net-next 0/4] net: mdio: Remove support for building C45 muxed addresses
Date:   Thu, 19 Jan 2023 14:06:56 +0100
Message-Id: <20230119130700.440601-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Russell told me that his mailserver rejected my mail because of
an ill-formated "To:" header. Resending now with plain git-send-email
instead of b4 send.]

I've picked this older series from Andrew up and rebased it onto
the latest net-next.

With all drivers which support c45 now being converted to a seperate c22
and c45 access op, we can now remove the old MII_ADDR_C45 flag.

Andrew Lunn (3):
  net: phy: Remove fallback to old C45 method
  net: Remove C45 check in C22 only MDIO bus drivers
  net: mdio: Remove support for building C45 muxed addresses

Michael Walle (1):
  net: ngbe: Drop mdiobus_c45_regad()

 drivers/net/dsa/microchip/ksz_common.c         |  6 ------
 drivers/net/dsa/rzn1_a5psw.c                   |  6 ------
 drivers/net/dsa/sja1105/sja1105_mdio.c         |  6 ------
 drivers/net/ethernet/actions/owl-emac.c        |  6 ------
 drivers/net/ethernet/engleder/tsnep_main.c     |  6 ------
 drivers/net/ethernet/marvell/mvmdio.c          |  6 ------
 drivers/net/ethernet/mediatek/mtk_star_emac.c  |  6 ------
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c      |  6 ------
 drivers/net/ethernet/sunplus/spl2sw_mdio.c     |  6 ------
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c  |  4 ++--
 drivers/net/mdio/mdio-i2c.c                    |  6 ------
 drivers/net/mdio/mdio-ipq8064.c                |  8 --------
 drivers/net/mdio/mdio-mscc-miim.c              |  6 ------
 drivers/net/mdio/mdio-mvusb.c                  |  6 ------
 drivers/net/phy/mdio_bus.c                     | 10 ++--------
 include/linux/mdio.h                           | 18 ------------------
 16 files changed, 4 insertions(+), 108 deletions(-)

-- 
2.30.2

