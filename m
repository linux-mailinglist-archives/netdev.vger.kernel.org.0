Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FDF401B60
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbhIFMqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:46:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:49846 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242222AbhIFMqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 08:46:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10098"; a="305521653"
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="305521653"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 05:44:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="448600974"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 06 Sep 2021 05:44:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 97ECE15D; Mon,  6 Sep 2021 15:44:51 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 net-next 2/2] net: wwan: iosm: Unify IO accessors used in the driver
Date:   Mon,  6 Sep 2021 15:44:49 +0300
Message-Id: <20210906124449.20742-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906124449.20742-1-andriy.shevchenko@linux.intel.com>
References: <20210906124449.20742-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we have readl()/writel()/ioread*()/iowrite*() APIs in use.
Let's unify to use only ioread*()/iowrite*() variants.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.c b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
index dadd8fada259..09f94c123531 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
@@ -69,7 +69,7 @@ void ipc_mmio_update_cp_capability(struct iosm_mmio *ipc_mmio)
 	unsigned int ver;
 
 	ver = ipc_mmio_get_cp_version(ipc_mmio);
-	cp_cap = readl(ipc_mmio->base + ipc_mmio->offset.cp_capability);
+	cp_cap = ioread32(ipc_mmio->base + ipc_mmio->offset.cp_capability);
 
 	ipc_mmio->has_mux_lite = (ver >= IOSM_CP_VERSION) &&
 				 !(cp_cap & DL_AGGR) && !(cp_cap & UL_AGGR);
@@ -150,8 +150,8 @@ enum ipc_mem_exec_stage ipc_mmio_get_exec_stage(struct iosm_mmio *ipc_mmio)
 	if (!ipc_mmio)
 		return IPC_MEM_EXEC_STAGE_INVALID;
 
-	return (enum ipc_mem_exec_stage)readl(ipc_mmio->base +
-					      ipc_mmio->offset.exec_stage);
+	return (enum ipc_mem_exec_stage)ioread32(ipc_mmio->base +
+						 ipc_mmio->offset.exec_stage);
 }
 
 void ipc_mmio_copy_chip_info(struct iosm_mmio *ipc_mmio, void *dest,
@@ -167,8 +167,8 @@ enum ipc_mem_device_ipc_state ipc_mmio_get_ipc_state(struct iosm_mmio *ipc_mmio)
 	if (!ipc_mmio)
 		return IPC_MEM_DEVICE_IPC_INVALID;
 
-	return (enum ipc_mem_device_ipc_state)
-		readl(ipc_mmio->base + ipc_mmio->offset.ipc_status);
+	return (enum ipc_mem_device_ipc_state)ioread32(ipc_mmio->base +
+						       ipc_mmio->offset.ipc_status);
 }
 
 enum rom_exit_code ipc_mmio_get_rom_exit_code(struct iosm_mmio *ipc_mmio)
@@ -176,8 +176,8 @@ enum rom_exit_code ipc_mmio_get_rom_exit_code(struct iosm_mmio *ipc_mmio)
 	if (!ipc_mmio)
 		return IMEM_ROM_EXIT_FAIL;
 
-	return (enum rom_exit_code)readl(ipc_mmio->base +
-					 ipc_mmio->offset.rom_exit_code);
+	return (enum rom_exit_code)ioread32(ipc_mmio->base +
+					    ipc_mmio->offset.rom_exit_code);
 }
 
 void ipc_mmio_config(struct iosm_mmio *ipc_mmio)
@@ -202,7 +202,7 @@ void ipc_mmio_set_psi_addr_and_size(struct iosm_mmio *ipc_mmio, dma_addr_t addr,
 		return;
 
 	iowrite64(addr, ipc_mmio->base + ipc_mmio->offset.psi_address);
-	writel(size, ipc_mmio->base + ipc_mmio->offset.psi_size);
+	iowrite32(size, ipc_mmio->base + ipc_mmio->offset.psi_size);
 }
 
 void ipc_mmio_set_contex_info_addr(struct iosm_mmio *ipc_mmio, phys_addr_t addr)
@@ -218,6 +218,8 @@ void ipc_mmio_set_contex_info_addr(struct iosm_mmio *ipc_mmio, phys_addr_t addr)
 
 int ipc_mmio_get_cp_version(struct iosm_mmio *ipc_mmio)
 {
-	return ipc_mmio ? readl(ipc_mmio->base + ipc_mmio->offset.cp_version) :
-			  -EFAULT;
+	if (ipc_mmio)
+		return ioread32(ipc_mmio->base + ipc_mmio->offset.cp_version);
+
+	return -EFAULT;
 }
-- 
2.33.0

