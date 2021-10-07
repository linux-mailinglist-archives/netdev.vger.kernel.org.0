Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04BF424B72
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbhJGBJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240107AbhJGBJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6725761002;
        Thu,  7 Oct 2021 01:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633568831;
        bh=gM27mBqZ5M+/U0dirTjGNiWPRzVCu0IbSF/hNQQ6sr8=;
        h=From:To:Cc:Subject:Date:From;
        b=BwZHTR9xTM52Ni+ostn8gbDRy1FeWzT4xPBpUrDgIie/Fz7p1eRZKlOP9aJSPLK3N
         BuW33ucDqUyxKFUTW6LQM6llNIRVhaZK/Vh2a8DYfwuq1rejm55num0Q5+K3qMu/ZX
         kj0d2vvuP808CJ4HKDtOTKYDhTQnmuu6e6sVHmU5X0WT5uhiRBgwlZQUyx3CmJAXSm
         IWOiKhjEwRi1HJ0PimN241orR5Xk1DkytVm+B9ZsjA8yS9ovlSn5EAU7ftNSQMgKdk
         0MzFjCOFO51WCG1GFBhH0k68lv/2ReWv3e9feL0EPsZuX1amPt1X/ckpMV262t/YSS
         W3vEcgE/ZEwjg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, rafael@kernel.org, saravanak@google.com,
        mw@semihalf.com, andrew@lunn.ch, jeremy.linton@arm.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, heikki.krogerus@linux.intel.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/9] net: add a helpers for loading netdev->dev_addr from FW
Date:   Wed,  6 Oct 2021 18:06:53 -0700
Message-Id: <20211007010702.3438216-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're trying to make all writes to netdev->dev_addr go via helpers.
A lot of places pass netdev->dev_addr to of_get_ethdev_address() and
device_get_ethdev_addr() so this set adds new functions which wrap
the functionality.

v2 performs suggested code moves, adds a couple additional clean ups
on the device property side, and an extra patch converting drivers
which can benefit from device_get_ethdev_address().

v3 removes OF_NET and corrects kdoc.

Jakub Kicinski (9):
  of: net: move of_net under net/
  of: net: add a helper for loading netdev->dev_addr
  ethernet: use of_get_ethdev_address()
  device property: move mac addr helpers to eth.c
  eth: fwnode: change the return type of mac address helpers
  eth: fwnode: remove the addr len from mac helpers
  eth: fwnode: add a helper for loading netdev->dev_addr
  ethernet: use device_get_ethdev_address()
  ethernet: make more use of device_get_ethdev_address()

 drivers/base/property.c                       | 63 ---------------
 drivers/net/ethernet/allwinner/sun4i-emac.c   |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  2 +-
 drivers/net/ethernet/amd/Kconfig              |  2 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 drivers/net/ethernet/arc/Kconfig              |  4 +-
 drivers/net/ethernet/arc/emac_main.c          |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |  2 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c  |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c    |  2 +-
 .../net/ethernet/broadcom/bgmac-platform.c    |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 drivers/net/ethernet/cadence/macb_main.c      |  2 +-
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  2 +-
 .../net/ethernet/cavium/thunder/thunder_bgx.c |  6 +-
 drivers/net/ethernet/ethoc.c                  |  2 +-
 drivers/net/ethernet/ezchip/Kconfig           |  2 +-
 drivers/net/ethernet/ezchip/nps_enet.c        |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  7 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c  |  2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c     |  2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 drivers/net/ethernet/korina.c                 |  2 +-
 drivers/net/ethernet/lantiq_xrx200.c          |  2 +-
 drivers/net/ethernet/litex/Kconfig            |  2 +-
 drivers/net/ethernet/litex/litex_liteeth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c     |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 drivers/net/ethernet/micrel/ks8851_common.c   |  2 +-
 drivers/net/ethernet/microchip/enc28j60.c     |  5 +-
 drivers/net/ethernet/mscc/Kconfig             |  2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  5 +-
 drivers/net/ethernet/qualcomm/qca_spi.c       |  2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c      |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  2 +-
 .../ethernet/samsung/sxgbe/sxgbe_platform.c   |  2 +-
 drivers/net/ethernet/smsc/smsc911x.c          |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  9 +--
 drivers/net/ethernet/socionext/sni_ave.c      |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  2 +-
 drivers/net/wireless/ath/ath10k/core.c        |  2 +-
 drivers/of/Kconfig                            |  4 -
 drivers/of/Makefile                           |  1 -
 include/linux/etherdevice.h                   |  6 ++
 include/linux/of_net.h                        |  8 +-
 include/linux/property.h                      |  5 +-
 net/core/Makefile                             |  1 +
 net/core/net-sysfs.c                          |  2 +-
 {drivers/of => net/core}/of_net.c             | 25 ++++++
 net/ethernet/eth.c                            | 79 +++++++++++++++++++
 61 files changed, 176 insertions(+), 144 deletions(-)
 rename {drivers/of => net/core}/of_net.c (85%)

-- 
2.31.1

