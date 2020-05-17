Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A185F1D64E8
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 02:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgEQAea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 20:34:30 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54858 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgEQAea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 20:34:30 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Pjnv1KX1z1qrLN;
        Sun, 17 May 2020 02:34:22 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Pjnp1W1dz1shfq;
        Sun, 17 May 2020 02:34:22 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id eDGXNAMlNLJu; Sun, 17 May 2020 02:34:21 +0200 (CEST)
X-Auth-Info: cUgqsxB3Upftsm7+usZ847YNb16Ht4Bt6lAu3nd0vhw=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 02:34:20 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
Date:   Sun, 17 May 2020 02:33:34 +0200
Message-Id: <20200517003354.233373-1-marex@denx.de>
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

Marek Vasut (20):
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
  net: ks8851: Drop define debug and pr_fmt()

 drivers/net/ethernet/micrel/Kconfig           |    2 +
 drivers/net/ethernet/micrel/Makefile          |    2 +
 drivers/net/ethernet/micrel/ks8851.h          |  142 +-
 .../micrel/{ks8851.c => ks8851_common.c}      |  698 ++-------
 drivers/net/ethernet/micrel/ks8851_mll.c      | 1393 -----------------
 drivers/net/ethernet/micrel/ks8851_par.c      |  351 +++++
 drivers/net/ethernet/micrel/ks8851_spi.c      |  481 ++++++
 7 files changed, 1116 insertions(+), 1953 deletions(-)
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

