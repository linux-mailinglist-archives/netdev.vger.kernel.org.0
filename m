Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9375C1D2364
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbgENAIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:08:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46289 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732871AbgENAIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:08:10 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49MsLw3X4Zz1qs4G;
        Thu, 14 May 2020 02:08:03 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49MsLq0YsBz1qql9;
        Thu, 14 May 2020 02:08:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id FGV454qE_zRi; Thu, 14 May 2020 02:08:01 +0200 (CEST)
X-Auth-Info: nFUiQv7MENDWOjl0V7Nwi/uQQTTbmN9or++k8YbI2UI=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 02:08:01 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V5 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
Date:   Thu, 14 May 2020 02:07:28 +0200
Message-Id: <20200514000747.159320-1-marex@denx.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
of silicon, except the former has an SPI interface, while the later has a
parallel bus interface. Thus far, Linux has two separate drivers for each
and they are diverging considerably.

This series unifies them into a single driver with small SPI and parallel
bus specific parts. The approach here is to first separate out the SPI
specific parts into a separate file, then add parallel bus accessors in
another separate file and then finally remove the old parallel bus driver.
The reason for replacing the old parallel bus driver is because the SPI
bus driver is much higher quality.

Marek Vasut (19):
  net: ks8851: Factor out spi->dev in probe()/remove()
  net: ks8851: Rename ndev to netdev in probe
  net: ks8851: Replace dev_err() with netdev_err() in IRQ handler
  net: ks8851: Pass device node into ks8851_init_mac()
  net: ks8851: Use devm_alloc_etherdev()
  net: ks8851: Use dev_{get,set}_drvdata()
  net: ks8851: Remove ks8851_rdreg32()
  net: ks8851: Use 16-bit writes to program MAC address
  net: ks8851: Use 16-bit read of RXFC register
  net: ks8851: Factor out bus lock handling
  net: ks8851: Factor out SKB receive function
  net: ks8851: Split out SPI specific entries in struct ks8851_net
  net: ks8851: Split out SPI specific code from probe() and remove()
  net: ks8851: Factor out TX work flush function
  net: ks8851: Permit overridding interrupt enable register
  net: ks8851: Implement register, FIFO, lock accessor callbacks
  net: ks8851: Separate SPI operations into separate file
  net: ks8851: Implement Parallel bus operations
  net: ks8851: Remove ks8851_mll.c

 drivers/net/ethernet/micrel/Kconfig           |    2 +
 drivers/net/ethernet/micrel/Makefile          |    2 +
 drivers/net/ethernet/micrel/ks8851.h          |  141 +-
 .../micrel/{ks8851.c => ks8851_common.c}      |  697 ++-------
 drivers/net/ethernet/micrel/ks8851_mll.c      | 1393 -----------------
 drivers/net/ethernet/micrel/ks8851_par.c      |  348 ++++
 drivers/net/ethernet/micrel/ks8851_spi.c      |  482 ++++++
 7 files changed, 1112 insertions(+), 1953 deletions(-)
 rename drivers/net/ethernet/micrel/{ks8851.c => ks8851_common.c} (62%)
 delete mode 100644 drivers/net/ethernet/micrel/ks8851_mll.c
 create mode 100644 drivers/net/ethernet/micrel/ks8851_par.c
 create mode 100644 drivers/net/ethernet/micrel/ks8851_spi.c

Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>

-- 
2.25.1

