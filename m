Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF811DEBDA
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgEVPbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:31:10 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18625 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbgEVPbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:31:09 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec7efab0000>; Fri, 22 May 2020 08:28:43 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 22 May 2020 08:31:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 22 May 2020 08:31:09 -0700
Received: from ubuntu.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 May
 2020 15:31:07 +0000
From:   Leon Yu <leoyu@nvidia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Leon Yu <leoyu@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: stmmac: don't attach interface until resume finishes
Date:   Fri, 22 May 2020 23:29:43 +0800
Message-ID: <1590161383-8141-1-git-send-email-leoyu@nvidia.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590161323; bh=VB2D7nby06TiBHyXC2plrdVwB7fVkP01QEXkGaFMelg=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type;
        b=KC2gGbk9ZS3khsqAoF+ndCxIN315dVmQTwVAH2GCSNs0Ey+jEZC194onuZHApD5/L
         UrY5ZoBukEz7QGmeJ4jJz3Aqwk1J3low7N+Ql9S+BGlkb9R9iabFMPcCLMe9K5IFxW
         ZCkgFMMM6FRbNSbpD8ysQYvFzNX0bf7JUwYvtRqMzRwFyI5R/TtGhdxSw8ScrLgpD4
         DBZLZoAuxrW5UNZ+VjGvGoNruo7qqo3DPvxh6XKDeT8+DrYc5rtyZEhN36gM5iww1j
         yWOf8kJAyZlSUwgk5gPzQNZjPnZY7Zh5JtAgyZ4kChuGYUxjz6vxU9UeqQ2vRehq/y
         zkVLI9YL8PiEA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 14b41a2959fb ("net: stmmac: Delete txtimer in suspend") was the
first attempt to fix a race between mod_timer() and setup_timer()
during stmmac_resume(). However the issue still exists as the commit
only addressed half of the issue.

Same race can still happen as stmmac_resume() re-attaches interface
way too early - even before hardware is fully initialized.  Worse,
doing so allows network traffic to restart and stmmac_tx_timer_arm()
being called in the middle of stmmac_resume(), which re-init tx timers
in stmmac_init_coalesce().  timer_list will be corrupted and system
crashes as a result of race between mod_timer() and setup_timer().

  systemd--1995    2.... 552950018us : stmmac_suspend: 4994
  ksoftirq-9       0..s2 553123133us : stmmac_tx_timer_arm: 2276
  systemd--1995    0.... 553127896us : stmmac_resume: 5101
  systemd--320     7...2 553132752us : stmmac_tx_timer_arm: 2276
  (sd-exec-1999    5...2 553135204us : stmmac_tx_timer_arm: 2276
  ---------------------------------
  pc : run_timer_softirq+0x468/0x5e0
  lr : run_timer_softirq+0x570/0x5e0
  Call trace:
   run_timer_softirq+0x468/0x5e0
   __do_softirq+0x124/0x398
   irq_exit+0xd8/0xe0
   __handle_domain_irq+0x6c/0xc0
   gic_handle_irq+0x60/0xb0
   el1_irq+0xb8/0x180
   arch_cpu_idle+0x38/0x230
   default_idle_call+0x24/0x3c
   do_idle+0x1e0/0x2b8
   cpu_startup_entry+0x28/0x48
   secondary_start_kernel+0x1b4/0x208

Fix this by deferring netif_device_attach() to the end of
stmmac_resume().

Signed-off-by: Leon Yu <leoyu@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a999d6b33a64..1f319c9cee46 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5190,8 +5190,6 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
-	netif_device_attach(ndev);
-
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
@@ -5218,6 +5216,8 @@ int stmmac_resume(struct device *dev)
 
 	phylink_mac_change(priv->phylink, true);
 
+	netif_device_attach(ndev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_resume);
-- 
2.7.4

