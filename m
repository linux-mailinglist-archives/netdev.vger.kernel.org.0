Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058EC1AF319
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 20:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDRSPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 14:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgDRSPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 14:15:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B9D20724;
        Sat, 18 Apr 2020 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587233707;
        bh=KtXXKvkVx6nmTgkrhaXXeJdQ0VBttc8MSA5biUMFsqQ=;
        h=From:To:Cc:Subject:Date:From;
        b=mZK6C8xriOzlOLhzPA+VSzfm+EUGTXGNXDO3l4P7tiVGYEO0qcojJR+8PoWnon19w
         HKquJE5GZkfoFHYjP4RqBurmxQ13BamYSZ/BgnfV0yeGlrRbqFb7QN/PBtlsR6idfq
         EuGG1cqIJM9CjoBroVtm35bewlJOddyyGLl14yfM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jPrzd-004UT4-4q; Sat, 18 Apr 2020 19:15:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH] net: stmmac: dwmac-meson8b: Add missing boundary to RGMII TX clock array
Date:   Sat, 18 Apr 2020 19:14:57 +0100
Message-Id: <20200418181457.3193175-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org, peppe.cavallaro@st.com, alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net, khilman@baylibre.com, martin.blumenstingl@googlemail.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running with KASAN on a VIM3L systems leads to the following splat
when probing the Ethernet device:

==================================================================
BUG: KASAN: global-out-of-bounds in _get_maxdiv+0x74/0xd8
Read of size 4 at addr ffffa000090615f4 by task systemd-udevd/139
CPU: 1 PID: 139 Comm: systemd-udevd Tainted: G            E     5.7.0-rc1-00101-g8624b7577b9c #781
Hardware name: amlogic w400/w400, BIOS 2020.01-rc5 03/12/2020
Call trace:
 dump_backtrace+0x0/0x2a0
 show_stack+0x20/0x30
 dump_stack+0xec/0x148
 print_address_description.isra.12+0x70/0x35c
 __kasan_report+0xfc/0x1d4
 kasan_report+0x4c/0x68
 __asan_load4+0x9c/0xd8
 _get_maxdiv+0x74/0xd8
 clk_divider_bestdiv+0x74/0x5e0
 clk_divider_round_rate+0x80/0x1a8
 clk_core_determine_round_nolock.part.9+0x9c/0xd0
 clk_core_round_rate_nolock+0xf0/0x108
 clk_hw_round_rate+0xac/0xf0
 clk_factor_round_rate+0xb8/0xd0
 clk_core_determine_round_nolock.part.9+0x9c/0xd0
 clk_core_round_rate_nolock+0xf0/0x108
 clk_core_round_rate_nolock+0xbc/0x108
 clk_core_set_rate_nolock+0xc4/0x2e8
 clk_set_rate+0x58/0xe0
 meson8b_dwmac_probe+0x588/0x72c [dwmac_meson8b]
 platform_drv_probe+0x78/0xd8
 really_probe+0x158/0x610
 driver_probe_device+0x140/0x1b0
 device_driver_attach+0xa4/0xb0
 __driver_attach+0xcc/0x1c8
 bus_for_each_dev+0xf4/0x168
 driver_attach+0x3c/0x50
 bus_add_driver+0x238/0x2e8
 driver_register+0xc8/0x1e8
 __platform_driver_register+0x88/0x98
 meson8b_dwmac_driver_init+0x28/0x1000 [dwmac_meson8b]
 do_one_initcall+0xa8/0x328
 do_init_module+0xe8/0x368
 load_module+0x3300/0x36b0
 __do_sys_finit_module+0x120/0x1a8
 __arm64_sys_finit_module+0x4c/0x60
 el0_svc_common.constprop.2+0xe4/0x268
 do_el0_svc+0x98/0xa8
 el0_svc+0x24/0x68
 el0_sync_handler+0x12c/0x318
 el0_sync+0x158/0x180

The buggy address belongs to the variable:
 div_table.63646+0x34/0xfffffffffffffa40 [dwmac_meson8b]

Memory state around the buggy address:
 ffffa00009061480: fa fa fa fa 00 00 00 01 fa fa fa fa 00 00 00 00
 ffffa00009061500: 05 fa fa fa fa fa fa fa 00 04 fa fa fa fa fa fa
>ffffa00009061580: 00 03 fa fa fa fa fa fa 00 00 00 00 00 00 fa fa
                                                             ^
 ffffa00009061600: fa fa fa fa 00 01 fa fa fa fa fa fa 01 fa fa fa
 ffffa00009061680: fa fa fa fa 00 01 fa fa fa fa fa fa 04 fa fa fa
==================================================================

Digging into this indeed shows that the clock divider array is
lacking a final fence, and that the clock subsystems goes in the
weeds. Oh well.

Let's add the empty structure that indicates the end of the array.

Fixes: bd6f48546b9c ("net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 0e2fa14f14237..a3934ca6a043b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -119,6 +119,7 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
 		{ .div = 5, .val = 5, },
 		{ .div = 6, .val = 6, },
 		{ .div = 7, .val = 7, },
+		{ /* end of array */ }
 	};
 
 	clk_configs = devm_kzalloc(dev, sizeof(*clk_configs), GFP_KERNEL);
-- 
2.26.1

