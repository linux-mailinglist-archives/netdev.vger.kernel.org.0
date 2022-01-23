Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3F74971A8
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 14:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiAWNfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 08:35:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43598 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiAWNfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 08:35:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D988A60C44;
        Sun, 23 Jan 2022 13:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8773C340E3;
        Sun, 23 Jan 2022 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642944942;
        bh=97ow4mr2hoPRA8eArh0X3eL1rrzpCmRBTFEWp4Jvymk=;
        h=From:To:Cc:Subject:Date:From;
        b=if3BN29iYXtSRxD4acqxEipwls9xP5cH4Bx7OZTASO+cJs6w/y9GIrCTVZ3NoIQIF
         62SqYzhbYnoaB9Fp6JswnI9331305ZVkdikk06Lxind4GofkJvuIDD4mua9petOomv
         V9D7N5QGy6N3sg3RsrAUBo3d/E2mx84empaRnqiLYRD6u0l93EhCyvXYocgqFWM77q
         q+4Q/6XnDAseDMFhpRcRwNRvjVtq7A9jnfp1ftZDZ3PQoGNLHXTAj0MQUk85uzCU+q
         IEoh+7p9QL3Kf+pVrx+HRUdQIw03QQDUuevYb+HIVdfNWyDczw4wrCzeuuA0GtQkNc
         JuRfiLtRDfUfg==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: dwmac-sun8i: fix double disable and unprepare "stmmaceth" clk
Date:   Sun, 23 Jan 2022 21:28:05 +0800
Message-Id: <20220123132805.758-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warnings on Allwinner D1 platform:

[    1.604695] ------------[ cut here ]------------
[    1.609328] bus-emac already disabled
[    1.613015] WARNING: CPU: 0 PID: 38 at drivers/clk/clk.c:952 clk_core_disable+0xcc/0xec
[    1.621039] CPU: 0 PID: 38 Comm: kworker/u2:1 Not tainted 5.14.0-rc4#1
[    1.627653] Hardware name: Allwinner D1 NeZha (DT)
[    1.632443] Workqueue: events_unbound deferred_probe_work_func
[    1.638286] epc : clk_core_disable+0xcc/0xec
[    1.642561]  ra : clk_core_disable+0xcc/0xec
[    1.646835] epc : ffffffff8023c2ec ra : ffffffff8023c2ec sp : ffffffd00411bb10
[    1.654054]  gp : ffffffff80ec9988 tp : ffffffe00143a800 t0 : ffffffff80ed6a6f
[    1.661272]  t1 : ffffffff80ed6a60 t2 : 0000000000000000 s0 : ffffffe001509e00
[    1.668489]  s1 : 0000000000000001 a0 : 0000000000000019 a1 : ffffffff80e80bd8
[    1.675707]  a2 : 00000000ffffefff a3 : 00000000000000f4 a4 : 0000000000000002
[    1.682924]  a5 : 0000000000000001 a6 : 0000000000000030 a7 : 00000000028f5c29
[    1.690141]  s2 : 0000000000000800 s3 : ffffffe001375000 s4 : ffffffe01fdf7a80
[    1.697358]  s5 : ffffffe001375010 s6 : ffffffff8001fc10 s7 : ffffffffffffffff
[    1.704577]  s8 : 0000000000000001 s9 : ffffffff80ecb248 s10: ffffffe001b80000
[    1.711794]  s11: ffffffe001b80760 t3 : 0000000000000062 t4 : ffffffffffffffff
[    1.719012]  t5 : ffffffff80e0f6d8 t6 : ffffffd00411b8f0
[    1.724321] status: 8000000201800100 badaddr: 0000000000000000 cause: 0000000000000003
[    1.732233] [<ffffffff8023c2ec>] clk_core_disable+0xcc/0xec
[    1.737810] [<ffffffff80240430>] clk_disable+0x38/0x78
[    1.742956] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
[    1.748451] [<ffffffff8031a500>] stmmac_remove_config_dt+0x1c/0x4c
[    1.754646] [<ffffffff8031c8ec>] sun8i_dwmac_probe+0x378/0x82c
[    1.760484] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
[    1.765975] [<ffffffff8029a6c8>] platform_probe+0x64/0xf0
[    1.771382] [<ffffffff8029833c>] really_probe.part.0+0x8c/0x30c
[    1.777305] [<ffffffff8029865c>] __driver_probe_device+0xa0/0x148
[    1.783402] [<ffffffff8029873c>] driver_probe_device+0x38/0x138
[    1.789324] [<ffffffff802989cc>] __device_attach_driver+0xd0/0x170
[    1.795508] [<ffffffff802988f8>] __driver_attach_async_helper+0xbc/0xc0
[    1.802125] [<ffffffff802965ac>] bus_for_each_drv+0x68/0xb4
[    1.807701] [<ffffffff80298d1c>] __device_attach+0xd8/0x184
[    1.813277] [<ffffffff802967b0>] bus_probe_device+0x98/0xbc
[    1.818852] [<ffffffff80297904>] deferred_probe_work_func+0x90/0xd4
[    1.825122] [<ffffffff8001f8b8>] process_one_work+0x1e4/0x390
[    1.830872] [<ffffffff8001fd80>] worker_thread+0x31c/0x4d8
[    1.836362] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    1.841335] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    1.846304] [<ffffffff8001fa60>] process_one_work+0x38c/0x390
[    1.852054] [<ffffffff80026564>] kthread+0x124/0x160
[    1.857021] [<ffffffff8002643c>] set_kthread_struct+0x5c/0x60
[    1.862770] [<ffffffff80001f08>] ret_from_syscall_rejected+0x8/0xc
[    1.868956] ---[ end trace 8d5c6046255f84a0 ]---
[    1.873675] ------------[ cut here ]------------
[    1.878366] bus-emac already unprepared
[    1.882378] WARNING: CPU: 0 PID: 38 at drivers/clk/clk.c:810 clk_core_unprepare+0xe4/0x168
[    1.890673] CPU: 0 PID: 38 Comm: kworker/u2:1 Tainted: G        W	5.14.0-rc4 #1
[    1.898674] Hardware name: Allwinner D1 NeZha (DT)
[    1.903464] Workqueue: events_unbound deferred_probe_work_func
[    1.909305] epc : clk_core_unprepare+0xe4/0x168
[    1.913840]  ra : clk_core_unprepare+0xe4/0x168
[    1.918375] epc : ffffffff8023d6cc ra : ffffffff8023d6cc sp : ffffffd00411bb10
[    1.925593]  gp : ffffffff80ec9988 tp : ffffffe00143a800 t0 : 0000000000000002
[    1.932811]  t1 : ffffffe01f743be0 t2 : 0000000000000040 s0 : ffffffe001509e00
[    1.940029]  s1 : 0000000000000001 a0 : 000000000000001b a1 : ffffffe00143a800
[    1.947246]  a2 : 0000000000000000 a3 : 00000000000000f4 a4 : 0000000000000001
[    1.954463]  a5 : 0000000000000000 a6 : 0000000005fce2a5 a7 : 0000000000000001
[    1.961680]  s2 : 0000000000000800 s3 : ffffffff80afeb90 s4 : ffffffe01fdf7a80
[    1.968898]  s5 : ffffffe001375010 s6 : ffffffff8001fc10 s7 : ffffffffffffffff
[    1.976115]  s8 : 0000000000000001 s9 : ffffffff80ecb248 s10: ffffffe001b80000
[    1.983333]  s11: ffffffe001b80760 t3 : ffffffff80b39120 t4 : 0000000000000001
[    1.990550]  t5 : 0000000000000000 t6 : ffffffe001600002
[    1.995859] status: 8000000201800120 badaddr: 0000000000000000 cause: 0000000000000003
[    2.003771] [<ffffffff8023d6cc>] clk_core_unprepare+0xe4/0x168
[    2.009609] [<ffffffff802403a0>] clk_unprepare+0x24/0x3c
[    2.014929] [<ffffffff8031a508>] stmmac_remove_config_dt+0x24/0x4c
[    2.021125] [<ffffffff8031c8ec>] sun8i_dwmac_probe+0x378/0x82c
[    2.026965] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
[    2.032463] [<ffffffff8029a6c8>] platform_probe+0x64/0xf0
[    2.037871] [<ffffffff8029833c>] really_probe.part.0+0x8c/0x30c
[    2.043795] [<ffffffff8029865c>] __driver_probe_device+0xa0/0x148
[    2.049892] [<ffffffff8029873c>] driver_probe_device+0x38/0x138
[    2.055815] [<ffffffff802989cc>] __device_attach_driver+0xd0/0x170
[    2.061999] [<ffffffff802988f8>] __driver_attach_async_helper+0xbc/0xc0
[    2.068616] [<ffffffff802965ac>] bus_for_each_drv+0x68/0xb4
[    2.074193] [<ffffffff80298d1c>] __device_attach+0xd8/0x184
[    2.079769] [<ffffffff802967b0>] bus_probe_device+0x98/0xbc
[    2.085345] [<ffffffff80297904>] deferred_probe_work_func+0x90/0xd4
[    2.091616] [<ffffffff8001f8b8>] process_one_work+0x1e4/0x390
[    2.097367] [<ffffffff8001fd80>] worker_thread+0x31c/0x4d8
[    2.102858] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    2.107830] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    2.112800] [<ffffffff8001fa60>] process_one_work+0x38c/0x390
[    2.118551] [<ffffffff80026564>] kthread+0x124/0x160
[    2.123520] [<ffffffff8002643c>] set_kthread_struct+0x5c/0x60
[    2.129268] [<ffffffff80001f08>] ret_from_syscall_rejected+0x8/0xc
[    2.135455] ---[ end trace 8d5c6046255f84a1 ]---

the dwmmac-sun8i driver will get the "stmmaceth" clk as tx_clk during
driver initialization. If stmmac_dvr_probe() fails due to various
reasons, sun8i_dwmac_exit() will disable and unprepare the "stmmaceth"
clk, then stmmac_remove_config_dt() will disable and unprepare the
clk again.

Currently, there's no other usage of tx_clk except preparing and
enabling, we can fix the above warnings by simply removing the tx_clk
and all its usage, we rely on the common stmmac_probe_config_dt()
routine to prepare and enable the stmmaceth clk.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 20 +------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 617d0e4c6495..d97469825e53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -57,7 +57,6 @@ struct emac_variant {
 };
 
 /* struct sunxi_priv_data - hold all sunxi private data
- * @tx_clk:	reference to MAC TX clock
  * @ephy_clk:	reference to the optional EPHY clock for the internal PHY
  * @regulator:	reference to the optional regulator
  * @rst_ephy:	reference to the optional EPHY reset for the internal PHY
@@ -68,7 +67,6 @@ struct emac_variant {
  * @mux_handle:	Internal pointer used by mdio-mux lib
  */
 struct sunxi_priv_data {
-	struct clk *tx_clk;
 	struct clk *ephy_clk;
 	struct regulator *regulator;
 	struct reset_control *rst_ephy;
@@ -579,22 +577,14 @@ static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 		}
 	}
 
-	ret = clk_prepare_enable(gmac->tx_clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Could not enable AHB clock\n");
-		goto err_disable_regulator;
-	}
-
 	if (gmac->use_internal_phy) {
 		ret = sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
 		if (ret)
-			goto err_disable_clk;
+			goto err_disable_regulator;
 	}
 
 	return 0;
 
-err_disable_clk:
-	clk_disable_unprepare(gmac->tx_clk);
 err_disable_regulator:
 	if (gmac->regulator)
 		regulator_disable(gmac->regulator);
@@ -1043,8 +1033,6 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 	if (gmac->variant->soc_has_internal_phy)
 		sun8i_dwmac_unpower_internal_phy(gmac);
 
-	clk_disable_unprepare(gmac->tx_clk);
-
 	if (gmac->regulator)
 		regulator_disable(gmac->regulator);
 }
@@ -1167,12 +1155,6 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	gmac->tx_clk = devm_clk_get(dev, "stmmaceth");
-	if (IS_ERR(gmac->tx_clk)) {
-		dev_err(dev, "Could not get TX clock\n");
-		return PTR_ERR(gmac->tx_clk);
-	}
-
 	/* Optional regulator for PHY */
 	gmac->regulator = devm_regulator_get_optional(dev, "phy");
 	if (IS_ERR(gmac->regulator)) {
-- 
2.34.1

