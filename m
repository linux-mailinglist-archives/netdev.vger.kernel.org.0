Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026EA29F446
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgJ2Suq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:50:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55724 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgJ2Sup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 14:50:45 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201029185033euoutp01ce65c8f54ba830bc8e81c0f429a1c136~Ciyrd8VC41635616356euoutp01X
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 18:50:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201029185033euoutp01ce65c8f54ba830bc8e81c0f429a1c136~Ciyrd8VC41635616356euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603997433;
        bh=rjGb/q462jUGsbZXYDSlLsq4C4w7bm1hZhL3PvZ+/BM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=GQZ3dH6SHe90H2Z3hUvqyrnx3Ca79sjlVe+IrKW0YVav1LT3iV5bnPj+eyofptyzv
         80zwDJ2WuTb3CaESBWwm1TTqAMYA5AVYnvPY9QIR2ADLSiQgMOnXktZ5d49AF/h7js
         Ini9Ztz0g5IKmh+VYpB5p9OUPx2W3QrEv7GW2nx4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201029185023eucas1p2789b4a808985c7f2eb40fbf81295a592~Ciyif_ZTi1649416494eucas1p2F;
        Thu, 29 Oct 2020 18:50:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id F2.43.06318.FEE0B9F5; Thu, 29
        Oct 2020 18:50:23 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201029185023eucas1p21872d74eeb62643a3ff364af7cf2c6eb~CiyiBvPrf2458024580eucas1p2k;
        Thu, 29 Oct 2020 18:50:23 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201029185023eusmtrp295679aeb95ca4ee4965895ccea5796c7~CiyiBC3So3194531945eusmtrp2M;
        Thu, 29 Oct 2020 18:50:23 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-17-5f9b0eefd97f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id EE.F3.06017.FEE0B9F5; Thu, 29
        Oct 2020 18:50:23 +0000 (GMT)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201029185022eusmtip1fe8aabd81a175186daff7d8ee008e7e0~Ciyhfy5HZ1231412314eusmtip1f;
        Thu, 29 Oct 2020 18:50:22 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] net: stmmac: Fix channel lock initialization
Date:   Thu, 29 Oct 2020 19:50:11 +0100
Message-Id: <20201029185011.4749-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djP87rv+WbHG6xabGyx8clpRouNM9az
        WjxZv4jNYs75FhaLe4vesVpc2NbHarHp8TVWi65rT1gt1h65y24x7+9aVotjC8Qs/r/eyujA
        47Fl5U0mj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvQ4uM/Q4+mPvcweW/Z/ZvT4vEkugCuK
        yyYlNSezLLVI3y6BK+PcapmCVqGKybfOsDYwPuTvYuTkkBAwkWg5OoUNxBYSWMEo8WpbdBcj
        F5D9hVFi+uY77BDOZ0aJ2c+OscN0rN+6hRWiYzmjxKcFRnAd3fdPM4Mk2AQMJbredrGBJEQE
        jjNKHOjrYwJxmAW2MEm8nN8L1i4sYCtx+Oh3FhCbRUBV4tyjbWA2r4CNxM6DC5gg1slLrN5w
        gBmkWUJgHrvEvtuPoRIuEg1PTjFC2MISr45vgbpPRuL/zvlMEA3NjBIPz61lh3B6GCUuN82A
        6rCWuHPuF9CBHEA3aUqs36UPEXaU2P+qkRkkLCHAJ3HjrSBImBnInLRtOlSYV6KjTQiiWk1i
        1vF1cGsPXrjEDGF7SCzrvsoICaJYiQ8P37FMYJSbhbBrASPjKkbx1NLi3PTUYuO81HK94sTc
        4tK8dL3k/NxNjMBUc/rf8a87GPf9STrEKMDBqMTDe+H2zHgh1sSy4srcQ4wSHMxKIrxOZ0/H
        CfGmJFZWpRblxxeV5qQWH2KU5mBREuc1XvQyVkggPbEkNTs1tSC1CCbLxMEp1cA4pfPwP/7d
        Ad7dHWqVpdMZXOsjunU3dTEZNi945bO5+J+N/CMdzs6VfLvr3NcX7K5fF2tysixOJWzi9nVX
        +Wo35J0Sjf4eO/fmevbtU27v+XRM4/3loH0XM8rPvzxV+Tnw5qsZrVmPPsZss+/d9XRXvqLB
        ooz5Ty1/Plh8qigx7pM1e+b8442+SizFGYmGWsxFxYkALiyw2DEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xu7rv+WbHGyy4JWKx8clpRouNM9az
        WjxZv4jNYs75FhaLe4vesVpc2NbHarHp8TVWi65rT1gt1h65y24x7+9aVotjC8Qs/r/eyujA
        47Fl5U0mj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvQ4uM/Q4+mPvcweW/Z/ZvT4vEkugCtK
        z6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+PcapmC
        VqGKybfOsDYwPuTvYuTkkBAwkVi/dQtrFyMXh5DAUkaJdU1L2CESMhInpzWwQtjCEn+udbFB
        FH1ilGj73M0GkmATMJToetsFZosInGaUuHw8HaSIWWAHk8TeA7fBJgkL2EocPvqdBcRmEVCV
        OPdoG5jNK2AjsfPgAiaIDfISqzccYJ7AyLOAkWEVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZG
        YIhvO/Zzyw7GrnfBhxgFOBiVeHgv3J4ZL8SaWFZcmXuIUYKDWUmE1+ns6Tgh3pTEyqrUovz4
        otKc1OJDjKZAyycyS4km5wPjL68k3tDU0NzC0tDc2NzYzEJJnLdD4GCMkEB6YklqdmpqQWoR
        TB8TB6dUA2PW0pOhkleVWlotrSrmvfCItCqb19rsWu++pvmlwAWHk97S/7/XTImrvCzx9vC/
        9o7zC1oapz7y3VYZ+/+ndaYtV8RaE59X93Rm/y640Pi2e3Pz0VnV7GkLOdVU/3it36PMN2mH
        hEvNir3vHrVcuvlbwDjipWa9zqbFe38rMZU9zLR3ajHj7VNiKc5INNRiLipOBAAlU3dPhwIA
        AA==
X-CMS-MailID: 20201029185023eucas1p21872d74eeb62643a3ff364af7cf2c6eb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201029185023eucas1p21872d74eeb62643a3ff364af7cf2c6eb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201029185023eucas1p21872d74eeb62643a3ff364af7cf2c6eb
References: <CGME20201029185023eucas1p21872d74eeb62643a3ff364af7cf2c6eb@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0366f7e06a6b ("net: stmmac: add ethtool support for get/set
channels") refactored channel initialization, but during that operation,
the spinlock initialization got lost. Fix this. This fixes the following
lockdep warning:

meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 331 Comm: kworker/1:2H Not tainted 5.9.0-rc3+ #1858
Hardware name: Hardkernel ODROID-N2 (DT)
Workqueue: kblockd blk_mq_run_work_fn
Call trace:
 dump_backtrace+0x0/0x1d0
 show_stack+0x14/0x20
 dump_stack+0xe8/0x154
 register_lock_class+0x58c/0x590
 __lock_acquire+0x7c/0x1790
 lock_acquire+0xf4/0x440
 _raw_spin_lock_irqsave+0x80/0xb0
 stmmac_tx_timer+0x4c/0xb0 [stmmac]
 call_timer_fn+0xc4/0x3e8
 run_timer_softirq+0x2b8/0x6c0
 efi_header_end+0x114/0x5f8
 irq_exit+0x104/0x110
 __handle_domain_irq+0x60/0xb8
 gic_handle_irq+0x58/0xb0
 el1_irq+0xbc/0x180
 _raw_spin_unlock_irqrestore+0x48/0x90
 mmc_blk_rw_wait+0x70/0x160
 mmc_blk_mq_issue_rq+0x510/0x830
 mmc_mq_queue_rq+0x13c/0x278
 blk_mq_dispatch_rq_list+0x2a0/0x698
 __blk_mq_do_dispatch_sched+0x254/0x288
 __blk_mq_sched_dispatch_requests+0x190/0x1d8
 blk_mq_sched_dispatch_requests+0x34/0x70
 __blk_mq_run_hw_queue+0xcc/0x148
 blk_mq_run_work_fn+0x20/0x28
 process_one_work+0x2a8/0x718
 worker_thread+0x48/0x460
 kthread+0x134/0x160
 ret_from_fork+0x10/0x1c

Fixes: 0366f7e06a6b ("net: stmmac: add ethtool support for get/set channels")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 220626a8d499..d833908b660a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4757,6 +4757,7 @@ static void stmmac_napi_add(struct net_device *dev)
 
 		ch->priv_data = priv;
 		ch->index = queue;
+		spin_lock_init(&ch->lock);
 
 		if (queue < priv->plat->rx_queues_to_use) {
 			netif_napi_add(dev, &ch->rx_napi, stmmac_napi_poll_rx,
-- 
2.17.1

