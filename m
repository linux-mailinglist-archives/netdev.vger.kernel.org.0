Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91D6563251
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 13:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiGALLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 07:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiGALLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 07:11:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 959BD80497;
        Fri,  1 Jul 2022 04:11:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C217113E;
        Fri,  1 Jul 2022 04:11:20 -0700 (PDT)
Received: from e126311.manchester.arm.com (unknown [10.57.71.169])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09F193F66F;
        Fri,  1 Jul 2022 04:11:16 -0700 (PDT)
Date:   Fri, 1 Jul 2022 12:11:10 +0100
From:   Kajetan Puchalski <kajetan.puchalski@arm.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [Regression] stress-ng udp-flood causes kernel panic on Ampere Altra
Message-ID: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While running the udp-flood test from stress-ng on Ampere Altra (Mt.
Jade platform) I encountered a kernel panic caused by NULL pointer
dereference within nf_conntrack.

The issue is present in the latest mainline (5.19-rc4), latest stable
(5.18.8), as well as multiple older stable versions. The last working
stable version I found was 5.15.40.

Through bisecting I've traced the issue back to mainline commit
719774377622bc4025d2a74f551b5dc2158c6c30 (netfilter: conntrack: convert to refcount_t api),
on kernels from before this commit the test runs fine. As far as I can tell, this commit was
included in stable with version 5.15.41, thus causing the regression
compared to 5.15.40. It was included in the mainline with version 5.16.

The issue is very consistently reproducible as well, running this
command resulted in the same kernel panic every time I tried it on
different kernels from after the change in question was merged.

stress-ng --udp-flood 0 -t 1m --metrics-brief --perf

The commit was not easily revertible so I can't say whether reverting it
on the latest mainline would fix the problem or not.

Here's the decoded kernel panic in question for reference:

[  869.372868] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  869.381708] Mem abort info:
[  869.384490]   ESR = 0x0000000096000044
[  869.388245]   EC = 0x25: DABT (current EL), IL = 32 bits
[  869.393681]   SET = 0, FnV = 0
[  869.396723]   EA = 0, S1PTW = 0
[  869.399859]   FSC = 0x04: level 0 translation fault
[  869.404731] Data abort info:
[  869.407606]   ISV = 0, ISS = 0x00000044
[  869.411437]   CM = 0, WnR = 1
[  869.414398] user pgtable: 4k pages, 48-bit VAs, pgdp=000008002f6b9000
[  869.420834] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  869.427621] Internal error: Oops: 96000044 [#1] SMP
[  869.432488] Modules linked in: sctp ip6_udp_tunnel udp_tunnel dccp_ipv4 dccp xt_conntrack xt_MASQUERADE xt_addrtype iptable_filter iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc ipmi_devintf ipmi_msghandler overlay cppc_cpufreq drm ip_tables x_tables btrfs blake2b_generic libcrc32c xor xor_neon raid6_pq zstd_compress nvme mlx5_core crct10dif_ce nvme_core mlxfw
[  869.466986] CPU: 13 PID: 100864 Comm: stress-ng-udp-f Not tainted 5.19.0-rc4-custom-kajpuc01-teo #15
[  869.476107] Hardware name: WIWYNN Mt.Jade Server System B81.03001.0005/Mt.Jade Motherboard, BIOS 1.08.20220218 (SCP: 1.08.20220218) 2022/02/18
[  869.488872] pstate: 40400009 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  869.495821] pc : __nf_ct_delete_from_lists (/home/kajpuc01/linux/./include/linux/list_nulls.h:108) nf_conntrack
[  869.502174] lr : __nf_ct_delete_from_lists (/home/kajpuc01/linux/net/netfilter/nf_conntrack_core.c:628) nf_conntrack
[  869.508523] sp : ffff800055acb6d0
[  869.511825] x29: ffff800055acb6d0 x28: ffffa1a42f9c8ac0 x27: 0000000000000000
[  869.518949] x26: ffffa1a3f531c780 x25: 000000000000ef6d x24: ffff4005eddfc500
[  869.526072] x23: ffff4005eddfc520 x22: ffff4005eddfc558 x21: ffffa1a42f9c8ac0
[  869.533195] x20: 0000000000000000 x19: 0000000000023923 x18: 0000000000000000
[  869.540319] x17: 0000000000000000 x16: ffffa1a42d8c3bb0 x15: 0000ffffffec5ff0
[  869.547442] x14: 4e4e4e4e4e4e4e4e x13: 4e4e4e4e4e4e4e4e x12: 4e4e4e4e4e4e4e4e
[  869.554565] x11: 0000000000000000 x10: 000000000100007f x9 : ffffa1a3f5304074
[  869.561688] x8 : 0000000000000000 x7 : 00113ec6b282834e x6 : ffff800055acb6c8
[  869.568811] x5 : dd7051c45787c585 x4 : abfc59e3b0a2b492 x3 : 0000000000000000
[  869.575934] x2 : 0000000000000001 x1 : 0000000000000000 x0 : 000000000001dedb
[  869.583058] Call trace:
[  869.585492] __nf_ct_delete_from_lists (/home/kajpuc01/linux/./include/linux/list_nulls.h:108) nf_conntrack
[  869.591494] nf_ct_delete (/home/kajpuc01/linux/./include/linux/bottom_half.h:33) nf_conntrack
[  869.596368] early_drop (/home/kajpuc01/linux/net/netfilter/nf_conntrack_core.c:1400) nf_conntrack
[  869.601154] __nf_conntrack_alloc (/home/kajpuc01/linux/net/netfilter/nf_conntrack_core.c:1610) nf_conntrack
[  869.606808] init_conntrack.isra.0 (/home/kajpuc01/linux/net/netfilter/nf_conntrack_core.c:1716) nf_conntrack
[  869.612549] nf_conntrack_in (/home/kajpuc01/linux/net/netfilter/nf_conntrack_core.c:1832) nf_conntrack
[  869.617769] ipv4_conntrack_local (/home/kajpuc01/linux/net/netfilter/nf_conntrack_proto.c:214) nf_conntrack
[  869.623249] nf_hook_slow (/home/kajpuc01/linux/net/netfilter/core.c:621)
[  869.626814] __ip_local_out (/home/kajpuc01/linux/net/ipv4/ip_output.c:118)
[  869.630640] ip_local_out (/home/kajpuc01/linux/net/ipv4/ip_output.c:125)
[  869.634117] ip_send_skb (/home/kajpuc01/linux/net/ipv4/ip_output.c:1572)
[  869.637508] udp_send_skb.isra.0 (/home/kajpuc01/linux/net/ipv4/udp.c:968)
[  869.641767] udp_sendmsg (/home/kajpuc01/linux/net/ipv4/udp.c:1254)
[  869.645329] inet_sendmsg (/home/kajpuc01/linux/net/ipv4/af_inet.c:821)
[  869.648807] sock_sendmsg (/home/kajpuc01/linux/net/socket.c:717)
[  869.652284] __sys_sendto (/home/kajpuc01/linux/net/socket.c:2119)
[  869.655847] __arm64_sys_sendto (/home/kajpuc01/linux/net/socket.c:2127)
[  869.659845] invoke_syscall (/home/kajpuc01/linux/./arch/arm64/include/asm/current.h:19)
[  869.663584] el0_svc_common.constprop.0 (/home/kajpuc01/linux/arch/arm64/kernel/syscall.c:75)
[  869.668449] do_el0_svc (/home/kajpuc01/linux/arch/arm64/kernel/syscall.c:207)
[  869.671753] el0_svc (/home/kajpuc01/linux/./arch/arm64/include/asm/daifflags.h:28)
[  869.674796] el0t_64_sync_handler (/home/kajpuc01/linux/arch/arm64/kernel/entry-common.c:643)
[  869.678966] el0t_64_sync (/home/kajpuc01/linux/arch/arm64/kernel/entry.S:581)
[ 869.682618] Code: 72001c1f 54fffc01 d503201f a9410700 (f9000020)
All code
========
   0:	72001c1f 	tst	w0, #0xff
   4:	54fffc01 	b.ne	0xffffffffffffff84  // b.any
   8:	d503201f 	nop
   c:	a9410700 	ldp	x0, x1, [x24, #16]
  10:*	f9000020 	str	x0, [x1]		<-- trapping instruction

Code starting with the faulting instruction
===========================================
   0:	f9000020 	str	x0, [x1]
[  869.688700] ---[ end trace 0000000000000000 ]---
[  869.693306] Kernel panic - not syncing: Oops: Fatal exception in interrupt
[  869.700168] SMP: stopping secondary CPUs
[  869.704219] Kernel Offset: 0x21a4251b0000 from 0xffff800008000000
[  869.710300] PHYS_OFFSET: 0x80000000
[  869.713775] CPU features: 0x000,0042e015,19805c82
[  869.718467] Memory Limit: none
[  869.721509] ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

The contents of /proc/cpuinfo:

processor	: 0
BogoMIPS	: 50.00
Features	: fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp ssbs
CPU implementer	: 0x41
CPU architecture: 8
CPU variant	: 0x3
CPU part	: 0xd0c
CPU revision	: 1

(The same type of CPU is repeated 160 times, only including one for brevity)

/proc/version:
Linux version 5.19.0-rc4-custom-kajpuc01-teo gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #37 SMP Thu Jun 30 14:53:25 UTC 2022

The distirbution is Ubuntu 20.04.3 LTS, the architecture is aarch64.

Please let me know if I can provide any more details or try any more
tests.

Regards,
Kajetan
