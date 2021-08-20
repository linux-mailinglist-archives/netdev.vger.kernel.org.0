Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF83F2D0E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbhHTNV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:21:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:28403 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240614AbhHTNV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:21:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="277790967"
X-IronPort-AV: E=Sophos;i="5.84,337,1620716400"; 
   d="scan'208";a="277790967"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2021 06:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,337,1620716400"; 
   d="scan'208";a="595670659"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 20 Aug 2021 06:20:48 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 91884580677;
        Fri, 20 Aug 2021 06:20:45 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net] net: stmmac: fix kernel panic due to NULL pointer dereference of plat->est
Date:   Fri, 20 Aug 2021 21:26:22 +0800
Message-Id: <20210820132622.4175839-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of taprio offload is not enabled, the error handling path
causes a kernel crash due to kernel NULL pointer deference.

Fix this by adding check for NULL before attempt to access 'plat->est'
on the mutex_lock() call.

The following kernel panic is observed without this patch:

RIP: 0010:mutex_lock+0x10/0x20
Call Trace:
tc_setup_taprio+0x482/0x560 [stmmac]
kmem_cache_alloc_trace+0x13f/0x490
taprio_disable_offload.isra.0+0x9d/0x180 [sch_taprio]
taprio_destroy+0x6c/0x100 [sch_taprio]
qdisc_create+0x2e5/0x4f0
tc_modify_qdisc+0x126/0x740
rtnetlink_rcv_msg+0x12b/0x380
_raw_spin_lock_irqsave+0x19/0x40
_raw_spin_unlock_irqrestore+0x18/0x30
create_object+0x212/0x340
rtnl_calcit.isra.0+0x110/0x110
netlink_rcv_skb+0x50/0x100
netlink_unicast+0x191/0x230
netlink_sendmsg+0x243/0x470
sock_sendmsg+0x5e/0x60
____sys_sendmsg+0x20b/0x280
copy_msghdr_from_user+0x5c/0x90
__mod_memcg_state+0x87/0xf0
 ___sys_sendmsg+0x7c/0xc0
lru_cache_add+0x7f/0xa0
_raw_spin_unlock+0x16/0x30
wp_page_copy+0x449/0x890
handle_mm_fault+0x921/0xfc0
__sys_sendmsg+0x59/0xa0
do_syscall_64+0x33/0x40
entry_SYSCALL_64_after_hwframe+0x44/0xa9
---[ end trace b1f19b24368a96aa ]---

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 4f3b6437b114..8160087ee92f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -884,11 +884,13 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
-	mutex_lock(&priv->plat->est->lock);
-	priv->plat->est->enable = false;
-	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
-			     priv->plat->clk_ptp_rate);
-	mutex_unlock(&priv->plat->est->lock);
+	if (priv->plat->est) {
+		mutex_lock(&priv->plat->est->lock);
+		priv->plat->est->enable = false;
+		stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
+				     priv->plat->clk_ptp_rate);
+		mutex_unlock(&priv->plat->est->lock);
+	}
 
 	priv->plat->fpe_cfg->enable = false;
 	stmmac_fpe_configure(priv, priv->ioaddr,
-- 
2.25.1

