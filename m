Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A549CF3D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbiAZQIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:08:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42686 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbiAZQIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:08:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5E3F619B0;
        Wed, 26 Jan 2022 16:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BC5C340E6;
        Wed, 26 Jan 2022 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643213291;
        bh=olUcBg3FaL1fnk1cDciqRO5ZpKQRH3h5GR/QbkRPeRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LbTLiB70ys6NKZX+KVQu5wfXONcysAOQLgBhB/R2f/YXUuPFHn8vmuF9LGYznN/Ol
         WPdTbRwDCZN1m4sj1STFBfAJwxkJDe2Mhslq0zL/WcpRs8nV1ax6ZVBOQqkvIDyWj4
         VmarIHU66955y9TPUrCoLnDosXB3yUexNEjXHmBmpfpIYjKGbLYsC/XeSv+FGow/jf
         ULJgpRb/0N7fTQtuaXfne4rLWlZb8YEeYq6aHvxbl5pMwS54KP8v1wZbza1mpOnEHU
         ni1xw1Nx9KS2qkV6lZM1U1OgiwpsCOgVSbfEy+vpDxSABy+dU2GYaya8/TBnkbuXsx
         5J46yQOOQohPQ==
Date:   Thu, 27 Jan 2022 00:00:31 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Samuel Holland <samuel@sholland.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: Re: [PATCH] net: stmmac: dwmac-sun8i: fix double disable and
 unprepare "stmmaceth" clk
Message-ID: <YfFwH9gHdN3fnx22@xhacker>
References: <20220123132805.758-1-jszhang@kernel.org>
 <38c41c04-abde-4d55-ed7c-515b6bba9c54@sholland.org>
 <YfFkz1d9onk+ITGg@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfFkz1d9onk+ITGg@xhacker>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:12:28PM +0800, Jisheng Zhang wrote:
> On Sun, Jan 23, 2022 at 01:43:37PM -0600, Samuel Holland wrote:
> > On 1/23/22 7:28 AM, Jisheng Zhang wrote:
> > > Fix warnings on Allwinner D1 platform:
> > > 
> > > [    1.604695] ------------[ cut here ]------------
> > > [    1.609328] bus-emac already disabled
> > > [    1.613015] WARNING: CPU: 0 PID: 38 at drivers/clk/clk.c:952 clk_core_disable+0xcc/0xec
> > > [    1.621039] CPU: 0 PID: 38 Comm: kworker/u2:1 Not tainted 5.14.0-rc4#1
> > > [    1.627653] Hardware name: Allwinner D1 NeZha (DT)
> > > [    1.632443] Workqueue: events_unbound deferred_probe_work_func
> > > [    1.638286] epc : clk_core_disable+0xcc/0xec
> > > [    1.642561]  ra : clk_core_disable+0xcc/0xec
> > > [    1.646835] epc : ffffffff8023c2ec ra : ffffffff8023c2ec sp : ffffffd00411bb10
> > > [    1.654054]  gp : ffffffff80ec9988 tp : ffffffe00143a800 t0 : ffffffff80ed6a6f
> > > [    1.661272]  t1 : ffffffff80ed6a60 t2 : 0000000000000000 s0 : ffffffe001509e00
> > > [    1.668489]  s1 : 0000000000000001 a0 : 0000000000000019 a1 : ffffffff80e80bd8
> > > [    1.675707]  a2 : 00000000ffffefff a3 : 00000000000000f4 a4 : 0000000000000002
> > > [    1.682924]  a5 : 0000000000000001 a6 : 0000000000000030 a7 : 00000000028f5c29
> > > [    1.690141]  s2 : 0000000000000800 s3 : ffffffe001375000 s4 : ffffffe01fdf7a80
> > > [    1.697358]  s5 : ffffffe001375010 s6 : ffffffff8001fc10 s7 : ffffffffffffffff
> > > [    1.704577]  s8 : 0000000000000001 s9 : ffffffff80ecb248 s10: ffffffe001b80000
> > > [    1.711794]  s11: ffffffe001b80760 t3 : 0000000000000062 t4 : ffffffffffffffff
> > > [    1.719012]  t5 : ffffffff80e0f6d8 t6 : ffffffd00411b8f0
> > > [    1.724321] status: 8000000201800100 badaddr: 0000000000000000 cause: 0000000000000003
> > > [    1.732233] [<ffffffff8023c2ec>] clk_core_disable+0xcc/0xec
> > > [    1.737810] [<ffffffff80240430>] clk_disable+0x38/0x78
> > > [    1.742956] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
> > > [    1.748451] [<ffffffff8031a500>] stmmac_remove_config_dt+0x1c/0x4c
> > > [    1.754646] [<ffffffff8031c8ec>] sun8i_dwmac_probe+0x378/0x82c
> > > [    1.760484] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
> > > [    1.765975] [<ffffffff8029a6c8>] platform_probe+0x64/0xf0
> > > [    1.771382] [<ffffffff8029833c>] really_probe.part.0+0x8c/0x30c
> > > [    1.777305] [<ffffffff8029865c>] __driver_probe_device+0xa0/0x148
> > > [    1.783402] [<ffffffff8029873c>] driver_probe_device+0x38/0x138
> > > [    1.789324] [<ffffffff802989cc>] __device_attach_driver+0xd0/0x170
> > > [    1.795508] [<ffffffff802988f8>] __driver_attach_async_helper+0xbc/0xc0
> > > [    1.802125] [<ffffffff802965ac>] bus_for_each_drv+0x68/0xb4
> > > [    1.807701] [<ffffffff80298d1c>] __device_attach+0xd8/0x184
> > > [    1.813277] [<ffffffff802967b0>] bus_probe_device+0x98/0xbc
> > > [    1.818852] [<ffffffff80297904>] deferred_probe_work_func+0x90/0xd4
> > > [    1.825122] [<ffffffff8001f8b8>] process_one_work+0x1e4/0x390
> > > [    1.830872] [<ffffffff8001fd80>] worker_thread+0x31c/0x4d8
> > > [    1.836362] [<ffffffff80026bf4>] kthreadd+0x94/0x188
> > > [    1.841335] [<ffffffff80026bf4>] kthreadd+0x94/0x188
> > > [    1.846304] [<ffffffff8001fa60>] process_one_work+0x38c/0x390
> > > [    1.852054] [<ffffffff80026564>] kthread+0x124/0x160
> > > [    1.857021] [<ffffffff8002643c>] set_kthread_struct+0x5c/0x60
> > > [    1.862770] [<ffffffff80001f08>] ret_from_syscall_rejected+0x8/0xc
> > > [    1.868956] ---[ end trace 8d5c6046255f84a0 ]---
> > > [    1.873675] ------------[ cut here ]------------
> > > [    1.878366] bus-emac already unprepared
> > > [    1.882378] WARNING: CPU: 0 PID: 38 at drivers/clk/clk.c:810 clk_core_unprepare+0xe4/0x168
> > > [    1.890673] CPU: 0 PID: 38 Comm: kworker/u2:1 Tainted: G        W	5.14.0-rc4 #1
> > > [    1.898674] Hardware name: Allwinner D1 NeZha (DT)
> > > [    1.903464] Workqueue: events_unbound deferred_probe_work_func
> > > [    1.909305] epc : clk_core_unprepare+0xe4/0x168
> > > [    1.913840]  ra : clk_core_unprepare+0xe4/0x168
> > > [    1.918375] epc : ffffffff8023d6cc ra : ffffffff8023d6cc sp : ffffffd00411bb10
> > > [    1.925593]  gp : ffffffff80ec9988 tp : ffffffe00143a800 t0 : 0000000000000002
> > > [    1.932811]  t1 : ffffffe01f743be0 t2 : 0000000000000040 s0 : ffffffe001509e00
> > > [    1.940029]  s1 : 0000000000000001 a0 : 000000000000001b a1 : ffffffe00143a800
> > > [    1.947246]  a2 : 0000000000000000 a3 : 00000000000000f4 a4 : 0000000000000001
> > > [    1.954463]  a5 : 0000000000000000 a6 : 0000000005fce2a5 a7 : 0000000000000001
> > > [    1.961680]  s2 : 0000000000000800 s3 : ffffffff80afeb90 s4 : ffffffe01fdf7a80
> > > [    1.968898]  s5 : ffffffe001375010 s6 : ffffffff8001fc10 s7 : ffffffffffffffff
> > > [    1.976115]  s8 : 0000000000000001 s9 : ffffffff80ecb248 s10: ffffffe001b80000
> > > [    1.983333]  s11: ffffffe001b80760 t3 : ffffffff80b39120 t4 : 0000000000000001
> > > [    1.990550]  t5 : 0000000000000000 t6 : ffffffe001600002
> > > [    1.995859] status: 8000000201800120 badaddr: 0000000000000000 cause: 0000000000000003
> > > [    2.003771] [<ffffffff8023d6cc>] clk_core_unprepare+0xe4/0x168
> > > [    2.009609] [<ffffffff802403a0>] clk_unprepare+0x24/0x3c
> > > [    2.014929] [<ffffffff8031a508>] stmmac_remove_config_dt+0x24/0x4c
> > > [    2.021125] [<ffffffff8031c8ec>] sun8i_dwmac_probe+0x378/0x82c
> > > [    2.026965] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
> > > [    2.032463] [<ffffffff8029a6c8>] platform_probe+0x64/0xf0
> > > [    2.037871] [<ffffffff8029833c>] really_probe.part.0+0x8c/0x30c
> > > [    2.043795] [<ffffffff8029865c>] __driver_probe_device+0xa0/0x148
> > > [    2.049892] [<ffffffff8029873c>] driver_probe_device+0x38/0x138
> > > [    2.055815] [<ffffffff802989cc>] __device_attach_driver+0xd0/0x170
> > > [    2.061999] [<ffffffff802988f8>] __driver_attach_async_helper+0xbc/0xc0
> > > [    2.068616] [<ffffffff802965ac>] bus_for_each_drv+0x68/0xb4
> > > [    2.074193] [<ffffffff80298d1c>] __device_attach+0xd8/0x184
> > > [    2.079769] [<ffffffff802967b0>] bus_probe_device+0x98/0xbc
> > > [    2.085345] [<ffffffff80297904>] deferred_probe_work_func+0x90/0xd4
> > > [    2.091616] [<ffffffff8001f8b8>] process_one_work+0x1e4/0x390
> > > [    2.097367] [<ffffffff8001fd80>] worker_thread+0x31c/0x4d8
> > > [    2.102858] [<ffffffff80026bf4>] kthreadd+0x94/0x188
> > > [    2.107830] [<ffffffff80026bf4>] kthreadd+0x94/0x188
> > > [    2.112800] [<ffffffff8001fa60>] process_one_work+0x38c/0x390
> > > [    2.118551] [<ffffffff80026564>] kthread+0x124/0x160
> > > [    2.123520] [<ffffffff8002643c>] set_kthread_struct+0x5c/0x60
> > > [    2.129268] [<ffffffff80001f08>] ret_from_syscall_rejected+0x8/0xc
> > > [    2.135455] ---[ end trace 8d5c6046255f84a1 ]---
> > > 
> > > the dwmmac-sun8i driver will get the "stmmaceth" clk as tx_clk during
> > > driver initialization. If stmmac_dvr_probe() fails due to various
> > > reasons, sun8i_dwmac_exit() will disable and unprepare the "stmmaceth"
> > > clk, then stmmac_remove_config_dt() will disable and unprepare the
> > > clk again.
> > 
> > This should still be balanced, because both stmmac_probe_config_dt and
> > sun8i_dwmac_init prepare/enable the clock, so the dwmac-sun8i glue layer calls
> > stmmac_dvr_probe with the clock having an enable count of 2. It looks like the
> > underlying issue is that commit 5ec55823438e ("net: stmmac: add clocks
> > management for gmac driver") introduces unbalanced runtime PM.
> 
> I added some printk then retested, the problem is triggered as below:
> 
> stmmac_probe_config_dt() enable the clk
> sun8i_dwmac_init() enble the clk again
> stmmac_dvr_probe() succeed, but it calls pm_runtime_put(), so rpm will
> disable the clk
> sun8i_dwmac_reset() fails due to various reason
> sun8i_dwmac_exit() disable the clk, this is fine
> stmmac_remove_config_dt() disable the clk again, so ccf complains.
> 
> The key here is: whether we should let stmmac_dvr_probe() calls
> pm_runtime_put() or let stmmac users to determine whether we could
> let rpm go?
> If we keep current behavior: stmmac users need to take care
> the code after stmmac_dvr_probe, including error handling code path,
> if we touch access registers, we need to call pm_runtime_get_sync()
> firstly.
> 
> Since the commit 5ec55823438e has been in for a long time, I'll submit
> a patch to follow this way.
> 

After reading the code and commit history, I found some users suffering
from the runtimepm issues, for example, dwmac-rk.c, so I changed my
idea. I think it's better to let stmmac users to call pm_runtime_put():

First of all, only the users know whether it's safe to finally
keep the mac runtime suspended after probe.

Secondly, if the users need to do platform specific operations after
stmmac_dvr_probe(), especially needs to access some registers, we have
to resume the mac firstly. The error handling code path also needs to
take care of it. It looks a bit strange resume immediately resume the
mac after suspending it.

Any suggestion is welcome.

PS: Since this would partially revert commit 5ec55823438e, I add Joakim
into the email thread.

Thanks
