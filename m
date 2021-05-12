Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F9C37CC3B
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhELQna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241418AbhELQ1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 12:27:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9134960FE9;
        Wed, 12 May 2021 15:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834746;
        bh=w7MQPo40BFpcMq5VCjU0zjt+S9Il2st9uIC1fCR+z/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u50cFgHTrr7maEEVR3TuP0Clr/P0EtuFc1f3go+lcLk/XTOrgkKbFrL/CJ9TXDIBL
         AXsQVyEZ2z5zC2Qvfk71nB1hqFLU8JAGQ7CRc6sKFzLFEf3gO7LdB7UCqvRmhYgJbY
         JLHKVyUiabA1SkbPLMAONXRM8Y9l77ZRPMl8CBAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Gary Guo <gary@garyguo.net>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 5.12 066/677] net: xilinx: drivers need/depend on HAS_IOMEM
Date:   Wed, 12 May 2021 16:41:52 +0200
Message-Id: <20210512144839.418152599@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 46fd4471615c1bff9d87c411140807762c25667a upstream.

kernel test robot reports build errors in 3 Xilinx ethernet drivers.
They all use ioremap functions that are only available when HAS_IOMEM
is set/enabled. If it is not enabled, they all have build errors,
so make these 3 drivers depend on HAS_IOMEM.

ld: drivers/net/ethernet/xilinx/xilinx_emaclite.o: in function `xemaclite_of_probe':
xilinx_emaclite.c:(.text+0x9fc): undefined reference to `devm_ioremap_resource'

ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.o: in function `axienet_probe':
xilinx_axienet_main.c:(.text+0x942): undefined reference to `devm_ioremap_resource'

ld: drivers/net/ethernet/xilinx/ll_temac_main.o: in function `temac_probe':
ll_temac_main.c:(.text+0x1283): undefined reference to `devm_platform_ioremap_resource_byname'
ld: ll_temac_main.c:(.text+0x13ad): undefined reference to `devm_of_iomap'
ld: ll_temac_main.c:(.text+0x162e): undefined reference to `devm_platform_ioremap_resource'

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Zhang Changzhong <zhangchangzhong@huawei.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: stable@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -18,12 +18,14 @@ if NET_VENDOR_XILINX
 
 config XILINX_EMACLITE
 	tristate "Xilinx 10/100 Ethernet Lite support"
+	depends on HAS_IOMEM
 	select PHYLIB
 	help
 	  This driver supports the 10/100 Ethernet Lite from Xilinx.
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
+	depends on HAS_IOMEM
 	select PHYLINK
 	help
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
@@ -31,6 +33,7 @@ config XILINX_AXI_EMAC
 
 config XILINX_LL_TEMAC
 	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
+	depends on HAS_IOMEM
 	select PHYLIB
 	help
 	  This driver supports the Xilinx 10/100/1000 LocalLink TEMAC


