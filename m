Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AAF1CF6F0
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgELOWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:22:36 -0400
Received: from muru.com ([72.249.23.125]:53996 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgELOWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 10:22:35 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id E8BE48047;
        Tue, 12 May 2020 14:23:22 +0000 (UTC)
Date:   Tue, 12 May 2020 07:22:30 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>
Subject: Re: [PATCH net v4] net: ethernet: ti: Remove TI_CPTS_MOD workaround
Message-ID: <20200512142230.GF37466@atomide.com>
References: <20200512100230.17752-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512100230.17752-1-grygorii.strashko@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* Grygorii Strashko <grygorii.strashko@ti.com> [200512 10:03]:
> From: Clay McClure <clay@daemons.net>
> 
> My recent commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on
> PTP_1588_CLOCK") exposes a missing dependency in defconfigs that select
> TI_CPTS without selecting PTP_1588_CLOCK, leading to linker errors of the
> form:
> 
> drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
> cpsw.c:(.text+0x680): undefined reference to `cpts_unregister'
>  ...
> 
> That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
> cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
> configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
> functions) _is_ enabled. So we end up compiling calls to functions that
> don't exist, resulting in the linker errors.
> 
> This patch fixes build errors and restores previous behavior by:
>  - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
>  - remove TI_CPTS_MOD and, instead, add dependencies from CPTS in
>    TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV as below:
> 
>    config TI_CPSW_SWITCHDEV
>    ...
>     depends on TI_CPTS || !TI_CPTS
> 
>    which will ensure proper dependencies PTP_1588_CLOCK -> TI_CPTS ->
> TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV and build type selection.
> 
> Note. For NFS boot + CPTS all of above configs have to be built-in.

This builds and boots on BBB and beagle x15 with NFSroot so:

Tested-by: Tony Lindgren <tony@atomide.com>

However, there's at least one more issue left that shows up at least
on ti81xx dra62x-j5eco-evm on v5.7-rc5 that has commit b46b2b7ba6e1
("ARM: dts: Fix dm814x Ethernet by changing to use rgmii-id mode").

I think this is a different issue though, any ideas?

Regards,

Tony


[    7.278339] 8<--- cut here ---
[    7.281421] Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0169004
[    7.289116] pgd = (ptrval)
[    7.291836] [f0169004] *pgd=ae83a811, *pte=4a101653, *ppte=4a101453
[    7.298154] Internal error: : 1008 [#1] SMP ARM
[    7.302707] Modules linked in:
[    7.305789] CPU: 0 PID: 73 Comm: kworker/0:3 Not tainted 5.7.0-rc5-dirty #1969
[    7.313042] Hardware name: Generic ti814x (Flattened Device Tree)
[    7.319190] Workqueue: pm pm_runtime_work
[    7.323241] PC is at davinci_mdio_runtime_suspend+0xc/0x8c
[    7.328753] LR is at __rpm_callback+0x84/0x154
[    7.333218] pc : [<c0703c98>]    lr : [<c063f2a4>]    psr: a0000013
[    7.339513] sp : eed7be80  ip : fffffffa  fp : 00000008
[    7.344761] r10: ffffe000  r9 : eed3ba40  r8 : 00000000
[    7.350010] r7 : 00000000  r6 : c063c810  r5 : c063c810  r4 : eed1c010
[    7.356568] r3 : f0169000  r2 : 000000d4  r1 : eed1c010  r0 : eed1c010
[    7.363129] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    7.370297] Control: 10c5387d  Table: 80004019  DAC: 00000051
[    7.376069] Process kworker/0:3 (pid: 73, stack limit = 0x(ptrval))
[    7.382367] Stack: (0xeed7be80 to 0xeed7c000)
[    7.386755] be80: eed1c010 c063c810 c063c810 00000000 00000000 c0e051c8 ffffe000 c063f2a4
[    7.394978] bea0: eed1c010 c063c810 0000000a 00000000 00000000 c063f394 eed1c010 c063c810
[    7.403202] bec0: 0000000a c063f4f0 c0e00018 ef4e2400 ee979880 c0e088c0 00000000 00000001
[    7.411425] bee0: 00000000 ef4e2400 eed7bf44 c09293e8 00000000 ea441c81 0efa67ff eed1c0f4
[    7.419648] bf00: eed5ca80 ef4e2000 ff7edc00 00000000 00000000 c0ebf890 ffffe000 c0640af0
[    7.427871] bf20: eed1c0f4 c0155338 ee979880 ef4e2000 00000008 eed5ca80 eed5ca94 ef4e2000
[    7.436094] bf40: 00000008 ef4e2018 c0e03d00 ef4e2000 ffffe000 c0155eb0 ffffe000 eed5ca80
[    7.444318] bf60: c0155e84 00000000 eed5a880 eed5a840 eed7a000 eed5ca80 c0155e84 ee915eac
[    7.452542] bf80: eed5a85c c015bf38 00000001 eed5a880 c015be04 00000000 00000000 00000000
[    7.460763] bfa0: 00000000 00000000 00000000 c0100168 00000000 00000000 00000000 00000000
[    7.468985] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.477207] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    7.485450] [<c0703c98>] (davinci_mdio_runtime_suspend) from [<c063f2a4>] (__rpm_callback+0x84/0x154)
[    7.494720] [<c063f2a4>] (__rpm_callback) from [<c063f394>] (rpm_callback+0x20/0x80)
[    7.502506] [<c063f394>] (rpm_callback) from [<c063f4f0>] (rpm_suspend+0xfc/0x6ac)
[    7.510117] [<c063f4f0>] (rpm_suspend) from [<c0640af0>] (pm_runtime_work+0x88/0xa4)
[    7.517916] [<c0640af0>] (pm_runtime_work) from [<c0155338>] (process_one_work+0x228/0x568)
[    7.526317] [<c0155338>] (process_one_work) from [<c0155eb0>] (worker_thread+0x2c/0x5d4)
[    7.534460] [<c0155eb0>] (worker_thread) from [<c015bf38>] (kthread+0x134/0x148)
[    7.541900] [<c015bf38>] (kthread) from [<c0100168>] (ret_from_fork+0x14/0x2c)
[    7.549155] Exception stack(0xeed7bfb0 to 0xeed7bff8)
[    7.554233] bfa0:                                     00000000 00000000 00000000 00000000
[    7.562455] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.570676] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    7.577331] Code: e8bd8070 e92d47f0 e5909040 e5993004 (e5935004)
[    7.583459] ---[ end trace 42a064f19df2a2ea ]---
[    7.588333] 8<--- cut here ---
