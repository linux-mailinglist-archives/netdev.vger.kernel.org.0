Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8609401B5E
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242192AbhIFMp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:45:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:4811 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241544AbhIFMp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 08:45:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10098"; a="280971784"
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="280971784"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 05:44:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="537009956"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Sep 2021 05:44:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 8D2EA198; Mon,  6 Sep 2021 15:44:51 +0300 (EEST)
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
Subject: [PATCH v1 net-next 1/2] net: wwan: iosm: Replace io.*64_lo_hi() with regular accessors
Date:   Mon,  6 Sep 2021 15:44:48 +0300
Message-Id: <20210906124449.20742-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The io.*_lo_hi() variants are not strictly needed on the x86 hardware
and especially the PCI bus. Replace them with regular accessors, but
leave headers in place in case of 32-bit build.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.c b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
index 06c94b1720b6..dadd8fada259 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
@@ -188,10 +188,10 @@ void ipc_mmio_config(struct iosm_mmio *ipc_mmio)
 	/* AP memory window (full window is open and active so that modem checks
 	 * each AP address) 0 means don't check on modem side.
 	 */
-	iowrite64_lo_hi(0, ipc_mmio->base + ipc_mmio->offset.ap_win_base);
-	iowrite64_lo_hi(0, ipc_mmio->base + ipc_mmio->offset.ap_win_end);
+	iowrite64(0, ipc_mmio->base + ipc_mmio->offset.ap_win_base);
+	iowrite64(0, ipc_mmio->base + ipc_mmio->offset.ap_win_end);
 
-	iowrite64_lo_hi(ipc_mmio->context_info_addr,
+	iowrite64(ipc_mmio->context_info_addr,
 			ipc_mmio->base + ipc_mmio->offset.context_info);
 }
 
@@ -201,7 +201,7 @@ void ipc_mmio_set_psi_addr_and_size(struct iosm_mmio *ipc_mmio, dma_addr_t addr,
 	if (!ipc_mmio)
 		return;
 
-	iowrite64_lo_hi(addr, ipc_mmio->base + ipc_mmio->offset.psi_address);
+	iowrite64(addr, ipc_mmio->base + ipc_mmio->offset.psi_address);
 	writel(size, ipc_mmio->base + ipc_mmio->offset.psi_size);
 }
 
-- 
2.33.0

