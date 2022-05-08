Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CEF51EEB8
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiEHPfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiEHPfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688A7E03D
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=DCZYZ0yB3du2Yx3dle/nGwTO3YFSBhtrt6ga5RdYq5A=; b=d/QWFYl0VYQWzHL4bT+OoHnkmb
        5lUFtO5cIwomLAhIMYlqF6JFwatKsuXfrMzRi2ZYkz5+eW/yTjFTG8UnpfRaKIli3XpA8eJ6v4NiT
        evinGCDemL4QdIOunDO+NBwEd3wtT6uaxR2vi1tgWy1H23i2GHoqt2T7JSQadWT7SGHw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisI-001n9c-VY; Sun, 08 May 2022 17:31:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: [PATCH net-next 00/10] net: mdio: Start separating C22 and C45
Date:   Sun,  8 May 2022 17:30:39 +0200
Message-Id: <20220508153049.427227-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set starts the separation of C22 and C45 MDIO bus
transactions at the API level to the MDIO Bus drivers. C45 read and
write ops are added to the MDIO bus driver structure, and the MDIO
core will try to use these ops if requested to perform a C45
transfer. If not available a fallback to the older API is made, to
allow backwards compatibility until all drivers are converted.

A few drivers are then converted to this new API,

Andrew Lunn (10):
  net: mdio: Add dedicated C45 API to MDIO bus drivers
  net: mdio: mdiobus_register: Update validation test
  net: mdio: C22 is now optional, EOPNOTSUPP if not provided
  net: mdio: Move mdiobus_c45_addr() next to users
  net: mdio: mdio-bitbang: Separate C22 and C45 transactions
  net: mdio: mvmdio: Convert XSMI bus to new API
  net: ethernet: freescale: xgmac: Separate C22 and C45 transactions for
    xgmac
  net: ethernet: freescale: fec: Separate C22 and C45 transactions for
    xgmac
  net: dsa: Separate C22 and C45 MDIO bus transaction methods
  net: dsa: mv88e6xxx: Separate C22 and C45 transactions

 drivers/net/dsa/mt7530.c                    |  92 +++++-----
 drivers/net/dsa/mt7530.h                    |  15 +-
 drivers/net/dsa/mv88e6xxx/chip.c            | 175 +++++++++++++-----
 drivers/net/dsa/mv88e6xxx/chip.h            |   7 +
 drivers/net/dsa/mv88e6xxx/global2.c         |  66 ++++---
 drivers/net/dsa/mv88e6xxx/global2.h         |  18 +-
 drivers/net/dsa/mv88e6xxx/phy.c             |  32 ++++
 drivers/net/dsa/mv88e6xxx/phy.h             |   4 +
 drivers/net/dsa/mv88e6xxx/serdes.c          |   8 +-
 drivers/net/ethernet/freescale/fec_main.c   | 149 ++++++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c | 154 ++++++++++++----
 drivers/net/ethernet/marvell/mvmdio.c       |  24 +--
 drivers/net/ethernet/renesas/sh_eth.c       |  37 +++-
 drivers/net/mdio/mdio-bitbang.c             |  77 +++++---
 drivers/net/phy/mdio_bus.c                  | 193 +++++++++++++++++++-
 include/linux/mdio-bitbang.h                |   6 +-
 include/linux/mdio.h                        |  38 +---
 include/linux/phy.h                         |   5 +
 include/net/dsa.h                           |   4 +
 net/dsa/slave.c                             |  35 +++-
 20 files changed, 836 insertions(+), 303 deletions(-)

-- 
2.36.0

