Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E076144B45A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244787AbhKIU7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 15:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240544AbhKIU7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 15:59:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CA7C061764;
        Tue,  9 Nov 2021 12:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=io+S8wCULLmvLhnauHLk8AUTXaXOEWfxvjfG3NBW+zc=; b=PBuQp3iHbchkeGx7A50hzzZ1xG
        NuPQ3LSXHuvUXvp3V6y8dRKECTE6jqpeXUZ+jOgZRk9LtmnforGpeRdPwoSBWjm+yeweIsWo9vWk1
        0qsLYsA94fJ8KsLS9gtRn/cDloZ0LxK1MBbOClUfKsyLbltSHLKZ/Ucdw6cVykCAmg5I8o7BJf/A+
        D2XJkz5lJAJPFMiM1QxXcfQbODGDO2DmxuEvLN8d2k3QfBracd+/SOtmNxCYqvdsfGtiuM9vnyj5d
        iK+6Bm9SYxD39C66fI5yKPcHjBEJnSMOITyEgJuZe6nWR2AVkNNpQISU0Ci+E28jSvVt6s0vy0wlj
        fg2wQm1Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkYAY-003FWh-E2; Tue, 09 Nov 2021 20:56:38 +0000
Date:   Tue, 9 Nov 2021 12:56:38 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>,
        Julia Lawall <julia.lawall@inria.fr>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, jeyu@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, mcgrof@kernel.org
Subject: Re: [PATCH] module: Fix implicit type conversion
Message-ID: <YYrghnBqTq5ZF2ZR@bombadil.infradead.org>
References: <1635473169-1848729-1-git-send-email-jiasheng@iscas.ac.cn>
 <alpine.LSU.2.21.2111081925580.1710@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2111081925580.1710@pobox.suse.cz>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 07:31:05PM +0100, Miroslav Benes wrote:
> [CCing Luis]
> 
> Hi,
> 
> On Fri, 29 Oct 2021, Jiasheng Jiang wrote:
> 
> > The variable 'cpu' is defined as unsigned int.
> > However in the for_each_possible_cpu, its values is assigned to -1.
> > That doesn't make sense and in the cpumask_next() it is implicitly
> > type conversed to int.
> > It is universally accepted that the implicit type conversion is
> > terrible.
> > Also, having the good programming custom will set an example for
> > others.
> > Thus, it might be better to change the definition of 'cpu' from
> > unsigned int to int.
> 
> Frankly, I don't see a benefit of changing this. It seems fine to me. 
> Moreover this is not, by far, the only place in the kernel with the same 
> pattern.
> 
> Miroslav
> 
> > Fixes: 10fad5e ("percpu, module: implement and use is_kernel/module_percpu_address()")
> > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > ---
> >  kernel/module.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 927d46c..f10d611 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -632,7 +632,7 @@ static void percpu_modcopy(struct module *mod,
> >  bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr)
> >  {
> >  	struct module *mod;
> > -	unsigned int cpu;
> > +	int cpu;
> >  
> >  	preempt_disable();

If we're going to do this we we must ask, is it really worth it and
moving forward then add a semantic patch rule which will pick up on
misuses.

@ finds_for_each_cpu_unsigned_int @
identifier x;
iterator name for_each_possible_cpu;
iterator name for_each_online_cpu;
iterator name for_each_present_cpu;
statement S;
@@

-unsigned
int x;
<+...
(
for_each_possible_cpu(x) S
|
for_each_online_cpu(x) S
|
for_each_present_cpu(x) S
)
...+>


This produces:

 arch/arm/mm/cache-b15-rac.c                        |  2 +-
 arch/arm/mm/cache-uniphier.c                       |  2 +-
 arch/arm64/kernel/mte.c                            |  2 +-
 arch/arm64/kernel/smp.c                            |  2 +-
 arch/arm64/kvm/arm.c                               |  2 +-
 arch/ia64/kernel/smp.c                             |  2 +-
 arch/ia64/kernel/topology.c                        |  2 +-
 arch/ia64/mm/contig.c                              |  4 ++--
 arch/mips/kernel/mips-cm.c                         |  2 +-
 arch/mips/kernel/mips-cpc.c                        |  2 +-
 arch/mips/kernel/smp.c                             |  6 +++---
 arch/mips/mm/init.c                                |  2 +-
 arch/openrisc/kernel/smp.c                         |  2 +-
 arch/parisc/kernel/topology.c                      |  2 +-
 arch/powerpc/kernel/cacheinfo.c                    |  4 ++--
 arch/powerpc/kernel/iommu.c                        |  2 +-
 arch/powerpc/kernel/setup_32.c                     |  4 ++--
 arch/powerpc/kernel/setup_64.c                     |  8 ++++----
 arch/powerpc/kernel/smp.c                          |  2 +-
 arch/powerpc/mm/numa.c                             |  2 +-
 arch/powerpc/platforms/ps3/interrupt.c             |  2 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |  6 +++---
 arch/powerpc/platforms/pseries/mobility.c          |  2 +-
 arch/powerpc/platforms/pseries/setup.c             |  2 +-
 arch/s390/pci/pci_irq.c                            |  4 ++--
 arch/sh/kernel/topology.c                          |  2 +-
 arch/sh/mm/cache-j2.c                              |  6 +++---
 arch/sparc/kernel/iommu-common.c                   |  2 +-
 arch/sparc/kernel/smp_64.c                         |  4 ++--
 arch/x86/events/amd/uncore.c                       |  4 ++--
 arch/x86/kernel/apic/apic_numachip.c               |  2 +-
 arch/x86/kernel/apic/bigsmp_32.c                   |  2 +-
 arch/x86/kernel/apic/x2apic_cluster.c              |  2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c                 |  2 +-
 arch/x86/kernel/cpu/mce/apei.c                     |  2 +-
 arch/x86/kernel/cpu/microcode/core.c               |  2 +-
 arch/x86/kernel/setup_percpu.c                     |  4 ++--
 arch/x86/kernel/smpboot.c                          |  4 ++--
 arch/x86/mm/cpu_entry_area.c                       |  2 +-
 arch/x86/mm/pti.c                                  |  2 +-
 arch/x86/xen/mmu_pv.c                              |  2 +-
 arch/x86/xen/smp_pv.c                              |  4 ++--
 arch/xtensa/kernel/irq.c                           |  2 +-
 arch/xtensa/kernel/smp.c                           |  4 ++--
 arch/xtensa/kernel/traps.c                         |  2 +-
 drivers/base/arch_numa.c                           |  2 +-
 drivers/base/arch_topology.c                       |  2 +-
 drivers/block/rnbd/rnbd-clt.c                      |  2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  4 ++--
 drivers/cpufreq/cpufreq_ondemand.c                 |  2 +-
 drivers/cpufreq/intel_pstate.c                     |  2 +-
 drivers/cpufreq/qcom-cpufreq-nvmem.c               |  4 ++--
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |  4 ++--
 drivers/idle/intel_idle.c                          |  2 +-
 drivers/iommu/iova.c                               |  4 ++--
 drivers/irqchip/irq-bcm6345-l1.c                   |  2 +-
 drivers/irqchip/irq-gic.c                          |  2 +-
 drivers/irqchip/irq-jcore-aic.c                    |  2 +-
 drivers/irqchip/irq-mips-gic.c                     |  2 +-
 drivers/macintosh/rack-meter.c                     |  2 +-
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  2 +-
 drivers/net/ethernet/marvell/mvneta.c              |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  4 ++--
 drivers/pci/controller/pcie-iproc-msi.c            |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |  2 +-
 drivers/scsi/bnx2i/bnx2i_init.c                    |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |  2 +-
 drivers/scsi/fcoe/fcoe.c                           |  6 +++---
 drivers/scsi/fcoe/fcoe_transport.c                 |  2 +-
 drivers/scsi/libfc/fc_exch.c                       |  4 ++--
 drivers/scsi/libfc/fc_lport.c                      |  2 +-
 drivers/soc/bcm/brcmstb/biuctrl.c                  |  2 +-
 drivers/xen/events/events_base.c                   |  2 +-
 drivers/xen/events/events_fifo.c                   |  2 +-
 fs/fscache/main.c                                  |  2 +-
 kernel/cpu.c                                       |  4 ++--
 kernel/livepatch/transition.c                      | 12 ++++++------
 kernel/module.c                                    |  2 +-
 kernel/relay.c                                     |  8 ++++----
 kernel/sched/deadline.c                            |  2 +-
 kernel/sched/rt.c                                  |  2 +-
 kernel/smpboot.c                                   |  4 ++--
 kernel/stop_machine.c                              |  2 +-
 kernel/taskstats.c                                 |  2 +-
 kernel/trace/trace_hwlat.c                         |  4 ++--
 lib/cpu_rmap.c                                     |  6 +++---
 lib/test_lockup.c                                  |  2 +-
 mm/kmemleak.c                                      |  4 ++--
 mm/percpu-vm.c                                     |  4 ++--
 mm/percpu.c                                        |  8 ++++----
 mm/slub.c                                          |  2 +-
 mm/swap_slots.c                                    |  2 +-
 net/core/dev.c                                     |  2 +-
 net/ipv4/netfilter/arp_tables.c                    |  2 +-
 net/ipv4/netfilter/ip_tables.c                     |  2 +-
 net/ipv4/route.c                                   |  2 +-
 net/ipv6/netfilter/ip6_tables.c                    |  2 +-
 net/netfilter/x_tables.c                           |  4 ++--
 net/rds/page.c                                     |  2 +-
 net/sunrpc/svc.c                                   |  2 +-
 102 files changed, 148 insertions(+), 148 deletions(-)
