Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF1F19AB0
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 11:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfEJJfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 05:35:46 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:32828 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbfEJJfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 05:35:45 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 7FCB34346;
        Fri, 10 May 2019 11:35:42 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 2c4ea12c;
        Fri, 10 May 2019 11:35:41 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 0/5] of_get_mac_address fixes
Date:   Fri, 10 May 2019 11:35:13 +0200
Message-Id: <1557480918-9627-1-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series is hopefuly the last series of the fixes which are related
to the introduction of NVMEM support into of_get_mac_address.

First patch is removing `nvmem-mac-address` property which was wrong idea as
I've allocated the property with devm_kzalloc and then added it to DT, so then
2 entities would be refcounting the allocation.  So if the driver unbinds, the
buffer is freed, but DT code would be still referencing that memory.

Second patch fixes some unwanted references to the Linux API in the DT
bindings documentation.

Patches 3-5 should hopefully make compilers and thus kbuild test robot happy.

Cheers,

Petr

Petr Štetiar (5):
  of_net: remove nvmem-mac-address property
  dt-bindings: doc: net: remove Linux API references
  powerpc: tsi108: fix similar warning reported by kbuild test robot
  net: ethernet: fix similar warning reported by kbuild test robot
  net: wireless: mt76: fix similar warning reported by kbuild test robot

 .../devicetree/bindings/net/keystone-netcp.txt     |  6 ++---
 .../bindings/net/wireless/mediatek,mt76.txt        |  4 +--
 arch/powerpc/sysdev/tsi108_dev.c                   |  3 ++-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |  2 +-
 drivers/net/ethernet/arc/emac_main.c               |  2 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |  2 +-
 drivers/net/ethernet/davicom/dm9000.c              |  2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c          |  2 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |  2 +-
 drivers/net/ethernet/freescale/gianfar.c           |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  2 +-
 drivers/net/ethernet/marvell/mvneta.c              |  2 +-
 drivers/net/ethernet/marvell/sky2.c                |  2 +-
 drivers/net/ethernet/micrel/ks8851.c               |  2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |  2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |  2 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  2 +-
 drivers/net/ethernet/ti/cpsw.c                     |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  2 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  2 +-
 drivers/of/of_net.c                                | 29 +++++-----------------
 24 files changed, 33 insertions(+), 49 deletions(-)

-- 
1.9.1

