Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C994A3B079F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhFVOny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhFVOnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:43:52 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F4C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:41:36 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 332B3829DD;
        Tue, 22 Jun 2021 16:41:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624372892;
        bh=RjyIwcg5fUhUIzD3eS6xz7N3932Q9h5VTjIC7gYpgdU=;
        h=From:To:Cc:Subject:Date:From;
        b=URAWQAhpk2P6CAnrYm4ST7Bt18IETl4mXe5WtaGjt0oNlTBqhZGve6ikEoacHSFuc
         0DSIVcgmoNnJeFki+DqoI7cC2luTxzOr/U0845nyGW+H1UFhos1gY6P1qFzq1CJO4W
         +fK6PVOIIjTwGtg0qpeneg0mdAeQFbWQdn/eoqahfCQePyYG0BmsocdrKk9GfmKEhJ
         PUs4wJvreubkPnACbQFsIS5D9SS1soYZ6w3HmRK4S/c8QOlCsvBjDhCl8eEx1YInG1
         bdf1nciG0reGZ38qONRpR26IHQubVfPT8I5HAWkqVee42xY6ka8+VGT3TOEBKGBO86
         r8ZTf7pGHfDXQ==
From:   Lukasz Majewski <lukma@denx.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org, Lukasz Majewski <lukma@denx.de>
Subject: [RFC 0/3] net: imx: Provide support for L2 switch as switchdev accelerator
Date:   Tue, 22 Jun 2021 16:41:08 +0200
Message-Id: <20210622144111.19647-1-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a followup for the earlier effort [1]
to bring support for L2 switch IP block on some NXP devices.

This time it augment the fec driver, so the L2 switch is treated
as a HW network accelerator. This is minimal, yet functional
driver, which enables bridging between imx28 ENET-MAC ports.

Links:
[1] - https://lwn.net/ml/linux-kernel/20201125232459.378-1-lukma@denx.de/

Lukasz Majewski (3):
  ARM: dts: imx28: Add description for L2 switch on XEA board
  net: Provide switchdev driver for NXP's More Than IP L2 switch
  net: imx: Adjust fec_main.c to provide support for L2 switch

 arch/arm/boot/dts/imx28-xea.dts               |  42 ++
 drivers/net/ethernet/freescale/Kconfig        |   1 +
 drivers/net/ethernet/freescale/Makefile       |   1 +
 drivers/net/ethernet/freescale/fec.h          |  36 ++
 drivers/net/ethernet/freescale/fec_main.c     | 139 +++++-
 drivers/net/ethernet/freescale/mtipsw/Kconfig |  11 +
 .../net/ethernet/freescale/mtipsw/Makefile    |   3 +
 .../net/ethernet/freescale/mtipsw/fec_mtip.c  | 438 ++++++++++++++++++
 .../net/ethernet/freescale/mtipsw/fec_mtip.h  | 213 +++++++++
 9 files changed, 860 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/Kconfig
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/Makefile
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/fec_mtip.c
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/fec_mtip.h

-- 
2.20.1

