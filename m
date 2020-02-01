Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B6D14F5E2
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 03:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgBACEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 21:04:02 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37331 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBACEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 21:04:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so4549178pga.4;
        Fri, 31 Jan 2020 18:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ro9iu9VNOuWviWh4OwZbe94+Deahhttu3CMtreUHnJg=;
        b=qld644UZy5MSMdAtQDkFv4eR5rOeOIeuYYfxUs23Icnpl5o/mtxhvzILGSb2z3jyMK
         c4iUPxDxY0Yui24NWEKH6kWwdJHWBYIaJbb+XuE5HNcq0q1qMCIs1vanew6u6v1GhJw9
         T2PcbubEr4HNdp7sRw4LVM3gfCDjNnqxxPI5MEdEgxq/gTu7B14se15UnnzgPmYO7Y1F
         Onh2bVuPh9sw+R1MxRUdtJ3k/kMPZ9sED/MwqC3dx7ii9eVo7Fg0SxP6ejCYvW5RGAcO
         xRR9sNJU9jPBC74vhh33HTE/r8mAT9q+SVPXs4nUv4T2HKAfxu1oG4uYc+5fw45hAwru
         Ohgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ro9iu9VNOuWviWh4OwZbe94+Deahhttu3CMtreUHnJg=;
        b=IcVRLYIlaDcnL0qteqVsSduG1ECSMDvzeAxdFpw4GB8RviPfOI2PdGoeq+FcDnMOm7
         UXOXRatc0wabPBDojZQyTwkUo5NZkhxaiHSkAeQ3RYGdxDbwF5pKICnSRLLVBRE/T9e3
         D13d6I+ikmLwnu38kyek/i7ad09mOQByr9rrHjowxLDszbystf0KoJBFDEpDj6wKZ5ZE
         rNb6AgjbNsCRLxGIq9WkKzjx3BHtQkynmMx9P/BUshqt/ZAXG9V2XAeXE9GBHBmT9hOz
         6xDYJpMkB+YzwZ+zA7z31b3F/QnHsV5yKdTp74/pDHugKU4XkTuCq/m8DRHW79mXWrOy
         bxEQ==
X-Gm-Message-State: APjAAAXWwLut/pOdjPjxVFGuaz5QHJ8cXXHCNKhn6LAspHs0WebDkqGg
        aBmI2A1NpvrXBi7Z6rena7I=
X-Google-Smtp-Source: APXvYqx+2t7NY80ATnmYXbW5lMP4yKLfBufkJ9KD/yZ72OykzVDh9Voe5Bf4K1yXya/3K/FKiTxm4w==
X-Received: by 2002:a63:8e:: with SMTP id 136mr13129030pga.319.1580522641354;
        Fri, 31 Jan 2020 18:04:01 -0800 (PST)
Received: from Asurada-Nvidia.nvidia.com (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id p3sm11744575pfg.184.2020.01.31.18.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 18:04:00 -0800 (PST)
From:   Nicolin Chen <nicoleotsuka@gmail.com>
To:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: Delete txtimer in suspend()
Date:   Fri, 31 Jan 2020 18:01:24 -0800
Message-Id: <20200201020124.5989-1-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running v5.5 with a rootfs on NFS, memory abort may happen in
the system resume stage:
 Unable to handle kernel paging request at virtual address dead00000000012a
 [dead00000000012a] address between user and kernel address ranges
 pc : run_timer_softirq+0x334/0x3d8
 lr : run_timer_softirq+0x244/0x3d8
 x1 : ffff800011cafe80 x0 : dead000000000122
 Call trace:
  run_timer_softirq+0x334/0x3d8
  efi_header_end+0x114/0x234
  irq_exit+0xd0/0xd8
  __handle_domain_irq+0x60/0xb0
  gic_handle_irq+0x58/0xa8
  el1_irq+0xb8/0x180
  arch_cpu_idle+0x10/0x18
  do_idle+0x1d8/0x2b0
  cpu_startup_entry+0x24/0x40
  secondary_start_kernel+0x1b4/0x208
 Code: f9000693 a9400660 f9000020 b4000040 (f9000401)
 ---[ end trace bb83ceeb4c482071 ]---
 Kernel panic - not syncing: Fatal exception in interrupt
 SMP: stopping secondary CPUs
 SMP: failed to stop secondary CPUs 2-3
 Kernel Offset: disabled
 CPU features: 0x00002,2300aa30
 Memory Limit: none
 ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

It's found that stmmac_xmit() and stmmac_resume() sometimes might
run concurrently, possibly resulting in a race condition between
mod_timer() and setup_timer(), being called by stmmac_xmit() and
stmmac_resume() respectively.

Since the resume() runs setup_timer() every time, it'd be safer to
have del_timer_sync() in the suspend() as the counterpart.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ff1cbfc834b0..5836b21edd7e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4974,6 +4974,7 @@ int stmmac_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	u32 chan;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -4987,6 +4988,9 @@ int stmmac_suspend(struct device *dev)
 
 	stmmac_disable_all_queues(priv);
 
+	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
+		del_timer_sync(&priv->tx_queue[chan].txtimer);
+
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 
-- 
2.17.1

