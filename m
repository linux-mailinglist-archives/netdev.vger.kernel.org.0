Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3060C507BFA
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 23:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358019AbiDSVg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 17:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiDSVgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 17:36:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8455C37A17;
        Tue, 19 Apr 2022 14:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17419B81CA3;
        Tue, 19 Apr 2022 21:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06759C385A7;
        Tue, 19 Apr 2022 21:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650404047;
        bh=axzcmyLd7p+Fc3Qf2VB/qPBm1itrpTBc1zfNl2VVXI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYif/kYKLOSCXaTQCJBuoMxgpd10sVKXqRi3/7AkrzwDmQlppEWHP3Cem34n1GpI1
         GN9f5xM2d6bGue6qvuQo+N7DyvzIgkqJQCom6BcgjG+fl1ERTHzKIGMvyOXN9ukNlh
         OXq+djSUSA2m8s8aSI4gNro/1xt5bfx/0JrpnyMa8++wCMyNWFX5Lxy4Hhl5xOk1lN
         k8AN6gO9dpVT0vagqHIitkwzT6XhKkJQdsxTWzVFG8d7aiqeHgCHK3RF5hFxp+O+fY
         fJRwQmOob7lVqGGWjPhvC7pHEIePd0OtLkIJbUiRNHdEX0ribGvqQZmrW8rJlkU+GZ
         QAtexF0AUIbrg==
Date:   Tue, 19 Apr 2022 14:34:05 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, Fangrui Song <i@maskray.me>
Subject: Re: BUG: Kernel NULL pointer dereference on write at 0x00000000
 (rtmsg_ifinfo_build_skb)
Message-ID: <Yl8qzShoizi4h5to@dev-arch.thelio-3990X>
References: <159db05f-539c-fe29-608b-91b036588033@molgen.mpg.de>
 <CAABZP2xampOLo8k93OLgaOfv9LreJ+f0g0_1mXwqtrv_LKewQg@mail.gmail.com>
 <3534d781-7d01-b42a-8974-0b1c367946f0@molgen.mpg.de>
 <CAABZP2zFDY-hrZqE=-c0uW8vFMH+Q9XezYd2DcBX4Wm+sxzK1g@mail.gmail.com>
 <04a597dc-64aa-57e6-f7fb-17bd2ec58159@molgen.mpg.de>
 <CAABZP2yb7-xa4F_2c6tuzkv7x902wU-hqgD_pqRooGC6C7S20A@mail.gmail.com>
 <f41550c7-26c0-cf81-7de9-aa924434a565@molgen.mpg.de>
 <Yg2h2Q2vXFkkLGTh@dev-arch.archlinux-ax161>
 <265b1953-36b4-6a65-1a36-67a61248f27f@molgen.mpg.de>
 <YhOv6m3K7rsPjTA8@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhOv6m3K7rsPjTA8@archlinux-ax161>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 08:29:46AM -0700, Nathan Chancellor wrote:
> Hi Paul,
> 
> On Mon, Feb 21, 2022 at 12:17:40PM +0100, Paul Menzel wrote:
> > Am 17.02.22 um 02:16 schrieb Nathan Chancellor:
> > 
> > > On Wed, Feb 16, 2022 at 02:19:51PM +0100, Paul Menzel wrote:
> > > > [Cc: +LLVM/clang build support folks]
> > 
> > […]
> > 
> > > > To recap: On a ppc64le machine, building Linux in Ubuntu 21.10 with *llvm*
> > > > and *clang* 1:13.0-53~exp1
> > > > 
> > > >      $ clang --version
> > > >      Ubuntu clang version 13.0.0-2
> > > >      Target: powerpc64le-unknown-linux-gnu
> > > >      Thread model: posix
> > > >      InstalledDir: /usr/bin
> > > > 
> > > > results in a segmentation fault, while it works when building with GCC.
> > > > 
> > > >      $ gcc --version
> > > >      gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0
> > > 
> > > Thank you for keying us in. I am going to have a bit of a brain dump
> > > here based on the information I have uncovered after a couple of hours
> > > of debugging.
> > > 
> > > TL;DR: It seems like something is broken with __read_mostly + ld.lld
> > > before 14.0.0.
> > > 
> > > My initial reproduction steps (boot-qemu.sh comes from
> > > https://github.com/ClangBuiltLinux/boot-utils):
> > > 
> > > $ clang --version
> > > clang version 13.0.1 (Fedora 13.0.1-1.fc37)
> > > Target: x86_64-redhat-linux-gnu
> > > Thread model: posix
> > > InstalledDir: /usr/bin
> > > 
> > > $ powerpc64le-linux-gnu-as --version
> > > GNU assembler version 2.37-2.fc36
> > > Copyright (C) 2021 Free Software Foundation, Inc.
> > > This program is free software; you may redistribute it under the terms of
> > > the GNU General Public License version 3 or later.
> > > This program has absolutely no warranty.
> > > This assembler was configured for a target of `powerpc64le-linux-gnu'.
> > > 
> > > $ curl -LSso .config https://lore.kernel.org/all/f41550c7-26c0-cf81-7de9-aa924434a565@molgen.mpg.de/3-linux-5.17-rc4-rcu-dev-config.txt
> > > 
> > > $ scripts/config --set-val INITRAMFS_SOURCE '""'
> > > 
> > > $ make -skj"$(nproc)" ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1 LLVM_IAS=0 all
> > > 
> > > $ boot-qemu.sh -a ppc64le -k . -t 45s
> > > QEMU location: /usr/bin
> > > 
> > > QEMU version: QEMU emulator version 6.2.0 (qemu-6.2.0-5.fc37)
> > > 
> > > + timeout --foreground 45s stdbuf -oL -eL qemu-system-ppc64 -initrd \
> > > /home/nathan/cbl/github/boot-utils-ro/images/ppc64le/rootfs.cpio -device \
> > > ipmi-bmc-sim,id=bmc0 -device isa-ipmi-bt,bmc=bmc0,irq=10 -L \
> > > /home/nathan/cbl/github/boot-utils-ro/images/ppc64le/ -bios skiboot.lid \
> > > -machine powernv8 -display none -kernel \
> > > /home/nathan/cbl/src/linux/arch/powerpc/boot/zImage.epapr -m 2G \
> > > -nodefaults -serial mon:stdio
> > > ...
> > > [    1.478028][    T1] BUG: Kernel NULL pointer dereference on read at 0x00000000
> > > [    1.478630][    T1] Faulting instruction address: 0xc00000000090bee0
> > > [    1.479521][    T1] Oops: Kernel access of bad area, sig: 11 [#1]
> > > [    1.480036][    T1] LE PAGE_SIZE=64K MMU=Hash PREEMPT SMP NR_CPUS=16 NUMA PowerNV
> > > [    1.480853][    T1] Modules linked in:
> > > [    1.481265][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc4-00001-gfa15c7cb550f #1
> > > [    1.481967][    T1] NIP:  c00000000090bee0 LR: c000000000d96b60 CTR: c0000000000d5b4c
> > > [    1.482596][    T1] REGS: c000000007443330 TRAP: 0380   Not tainted  (5.17.0-rc4-00001-gfa15c7cb550f)
> > > [    1.483305][    T1] MSR:  9000000002009033 <SF,HV,VEC,EE,ME,IR,DR,RI,LE>  CR: 22800a87  XER: 00000000
> > > [    1.484277][    T1] CFAR: c000000000d96b5c IRQMASK: 0
> > > [    1.484277][    T1] GPR00: c000000000d96b54 c0000000074435d0 c0000000028bc600 0000000000000000
> > > [    1.484277][    T1] GPR04: ffffffffffffffff ffffffffff1ea558 ffffffffff1ebfe4 c00000000261ae88
> > > [    1.484277][    T1] GPR08: 0000000000000003 0000000000000004 c00000000261ae88 0000000000000000
> > > [    1.484277][    T1] GPR12: 0000000000800000 c000000002a60000 c000000000012518 0000000000000000
> > > [    1.484277][    T1] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> > > [    1.484277][    T1] GPR20: 0000000000000000 c0000000027bff80 0000000000000cc0 0000000000000000
> > > [    1.484277][    T1] GPR24: 0000000000000010 0000000000000000 0000000000000000 0000000000000000
> > > [    1.484277][    T1] GPR28: c0000000028fcfd8 c000000007b83000 0000000000000000 c0000000074435d0
> > > [    1.490325][    T1] NIP [c00000000090bee0] strlen+0x10/0x30
> > > [    1.490788][    T1] LR [c000000000d96b60] if_nlmsg_size+0x2b0/0x390
> > > [    1.491319][    T1] Call Trace:
> > > [    1.491573][    T1] [c0000000074435d0] [c000000000d96b54] if_nlmsg_size+0x2a4/0x390 (unreliable)
> > > [    1.492291][    T1] [c000000007443680] [c000000000d96790] rtmsg_ifinfo_build_skb+0x80/0x1a0
> > > [    1.492958][    T1] [c000000007443740] [c000000000d97590] rtmsg_ifinfo+0x70/0xd0
> > > [    1.493559][    T1] [c000000007443790] [c000000000d7d528] register_netdevice+0x5d8/0x670
> > > [    1.494205][    T1] [c000000007443820] [c000000000d7d94c] register_netdev+0x4c/0x80
> > > [    1.494823][    T1] [c000000007443850] [c000000000f826d8] sit_init_net+0x1b8/0x200
> > > [    1.495426][    T1] [c0000000074438d0] [c000000000d63b5c] ops_init+0x14c/0x1c0
> > > [    1.496014][    T1] [c000000007443930] [c000000000d6314c] register_pernet_operations+0xec/0x1e0
> > > [    1.496716][    T1] [c000000007443990] [c000000000d633d0] register_pernet_device+0x60/0xd0
> > > [    1.497372][    T1] [c0000000074439e0] [c000000002085194] sit_init+0x54/0x160
> > > [    1.497950][    T1] [c000000007443a70] [c000000000011c58] do_one_initcall+0x108/0x3e0
> > > [    1.498573][    T1] [c000000007443c70] [c000000002006190] do_initcall_level+0xe4/0x1c4
> > > [    1.499219][    T1] [c000000007443cc0] [c00000000200604c] do_initcalls+0x84/0xe4
> > > [    1.499799][    T1] [c000000007443d40] [c000000002005da8] kernel_init_freeable+0x160/0x1ec
> > > [    1.500444][    T1] [c000000007443da0] [c00000000001254c] kernel_init+0x3c/0x270
> > > [    1.501042][    T1] [c000000007443e10] [c00000000000cd64] ret_from_kernel_thread+0x5c/0x64
> > > [    1.501721][    T1] Instruction dump:
> > > [    1.502202][    T1] eb81ffe0 7c0803a6 4e800020 00000000 00000000 00000000 60000000 60000000
> > > [    1.502934][    T1] 3883ffff 60000000 60000000 60000000 <8ca40001> 28050000 4082fff8 7c632050
> > > [    1.504028][    T1] ---[ end trace 0000000000000000 ]---
> > > ...
> > > 
> > > First thing was figuring out where the NULL pointer dereference happens,
> > > which appears to the "strlen(ops->kind)" in rtnl_link_get_size():
> > > 
> > > 515 static size_t rtnl_link_get_size(const struct net_device *dev)
> > > 516 {
> > > 517 	const struct rtnl_link_ops *ops = dev->rtnl_link_ops;
> > > 518 	size_t size;
> > > 519
> > > 520 	if (!ops)
> > > 521 		return 0;
> > > 522
> > > 523 	size = nla_total_size(sizeof(struct nlattr)) + /* IFLA_LINKINFO */
> > > 524 	       nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_KIND */
> > > 
> > > which I confirmed some really rudimentary printk debugging:
> > > 
> > > [    1.476862][    T1] nathan: rtnl_link_get_size(): name: sit0, ops: c0000000028fcfd8, ops->kind: (null)
> > > 
> > > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > > index 710da8a36729..c8d928e83aec 100644
> > > --- a/net/core/rtnetlink.c
> > > +++ b/net/core/rtnetlink.c
> > > @@ -520,6 +520,9 @@ static size_t rtnl_link_get_size(const struct net_device *dev)
> > >   	if (!ops)
> > >   		return 0;
> > > +	pr_err("nathan: %s(): name: %s, ops: %px, ops->kind: %s\n", __func__,
> > > +	       dev->name, ops, ops->kind);
> > > +
> > >   	size = nla_total_size(sizeof(struct nlattr)) + /* IFLA_LINKINFO */
> > >   	       nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_KIND */
> > > 
> > > Okay... how did sit0 end up with a NULL kind...? It is very clearly
> > > defined as "sit":
> > > 
> > > 1830 static struct rtnl_link_ops sit_link_ops __read_mostly = {
> > > 1831 	.kind		= "sit",
> > > 
> > > Adding some more debug prints to net/ipv6/sit.c:
> > > 
> > > diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> > > index c0b138c20992..7b9edbed2fcd 100644
> > > --- a/net/ipv6/sit.c
> > > +++ b/net/ipv6/sit.c
> > > @@ -1920,6 +1920,12 @@ static int __net_init sit_init_net(struct net *net)
> > >   	 */
> > >   	sitn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
> > > +	pr_err("nathan: %s(): &sit_link_ops: %px\n", __func__, &sit_link_ops);
> > > +	pr_err("nathan: %s(): sit_link_ops.kind: %s\n", __func__, sit_link_ops.kind);
> > > +	pr_err("nathan: %s(): sit_link_ops.maxtype: %u\n", __func__, sit_link_ops.maxtype);
> > > +	pr_err("nathan: %s(): sitn->fb_tunnel_dev->rtnl_link_ops: %px\n", __func__, sitn->fb_tunnel_dev->rtnl_link_ops);
> > > +	pr_err("nathan: %s(): sitn->fb_tunnel_dev->rtnl_link_ops->kind: %s\n", __func__, sitn->fb_tunnel_dev->rtnl_link_ops->kind);
> > > +
> > >   	err = register_netdev(sitn->fb_tunnel_dev);
> > >   	if (err)
> > >   		goto err_reg_dev;
> > > 
> > > reveals:
> > > 
> > > [    1.471920][    T1] sit: nathan: sit_init_net(): &sit_link_ops: c0000000028fcfd8
> > > [    1.472534][    T1] sit: nathan: sit_init_net(): sit_link_ops.kind: (null)
> > > [    1.473088][    T1] sit: nathan: sit_init_net(): sit_link_ops.maxtype: 20
> > > [    1.473639][    T1] sit: nathan: sit_init_net(): sitn->fb_tunnel_dev->rtnl_link_ops: c0000000028fcfd8
> > > [    1.474370][    T1] sit: nathan: sit_init_net(): sitn->fb_tunnel_dev->rtnl_link_ops->kind: (null)
> > > 
> > > This is super bizarre, as the maxtype member appears to have the correct
> > > value, but how is kind's initial getting dropped on the floor?
> > > 
> > > Removing the __read_mostly annotation "fixes" it:
> > > 
> > > [    1.481708][    T1] sit: nathan: sit_init_net(): &sit_link_ops: c0000000027d3f60
> > > [    1.482319][    T1] sit: nathan: sit_init_net(): sit_link_ops.kind: sit
> > > [    1.482878][    T1] sit: nathan: sit_init_net(): sit_link_ops.maxtype: 20
> > > [    1.483429][    T1] sit: nathan: sit_init_net(): sitn->fb_tunnel_dev->rtnl_link_ops: c0000000027d3f60
> > > [    1.484174][    T1] sit: nathan: sit_init_net(): sitn->fb_tunnel_dev->rtnl_link_ops->kind: sit
> > > ...
> > > Linux version 5.17.0-rc4-00001-g956f02ad5c31-dirty (nathan@dev-fedora.archlinux-ax161) (clang version 13.0.1 (Fedora 13.0.1-1.fc37), LLD 13.0.1) #2 SMP PREEMPT Wed Feb 16 13:29:49 MST 2022
> > > ...
> > > 
> > > diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> > > index 7b9edbed2fcd..f109c7a0233b 100644
> > > --- a/net/ipv6/sit.c
> > > +++ b/net/ipv6/sit.c
> > > @@ -70,7 +70,7 @@ static void ipip6_tunnel_setup(struct net_device *dev);
> > >   static void ipip6_dev_free(struct net_device *dev);
> > >   static bool check_6rd(struct ip_tunnel *tunnel, const struct in6_addr *v6dst,
> > >   		      __be32 *v4dst);
> > > -static struct rtnl_link_ops sit_link_ops __read_mostly;
> > > +static struct rtnl_link_ops sit_link_ops;
> > >   static unsigned int sit_net_id __read_mostly;
> > >   struct sit_net {
> > > @@ -1827,7 +1827,7 @@ static void ipip6_dellink(struct net_device *dev, struct list_head *head)
> > >   		unregister_netdevice_queue(dev, head);
> > >   }
> > > -static struct rtnl_link_ops sit_link_ops __read_mostly = {
> > > +static struct rtnl_link_ops sit_link_ops = {
> > >   	.kind		= "sit",
> > >   	.maxtype	= IFLA_IPTUN_MAX,
> > >   	.policy		= ipip6_policy,
> > > 
> > > Switching to ld.bfd also resolves it:
> > > 
> > > [    1.470405][    T1] sit: nathan: sit_init_net(): &sit_link_ops: c0000000028acfd8
> > > [    1.471016][    T1] sit: nathan: sit_init_net(): sit_link_ops.kind: sit
> > > [    1.471534][    T1] sit: nathan: sit_init_net(): sit_link_ops.maxtype: 20
> > > [    1.472062][    T1] sit: nathan: sit_init_net(): sitn->fb_tunnel_dev->rtnl_link_ops: c0000000028acfd8
> > > [    1.472790][    T1] sit: nathan: sit_init_net(): sitn->fb_tunnel_dev->rtnl_link_ops->kind: sit
> > > ...
> > > Linux version 5.17.0-rc4-00001-g956f02ad5c31 (nathan@dev-fedora.archlinux-ax161) (clang version 13.0.1 (Fedora 13.0.1-1.fc37), GNU ld version 2.37-2.fc36) #3 SMP PREEMPT Wed Feb 16 13:33:42 MST 2022
> > > ...
> > > 
> > > I tested with ToT LLVM (or at least, close to it, since there is an
> > > unrelated ld.lld regression there) and I could not reproduce it there,
> > > so I did a reverse bisect to see what commit fixes this issue in LLVM 14
> > > and I landed on:
> > > 
> > > commit 55c14d6dbfd8e7b86c15d2613fea3490078e2ae4
> > > Author: Fangrui Song <i@maskray.me>
> > > Date:   Thu Nov 25 14:12:34 2021 -0800
> > > 
> > >      [ELF] Simplify DynamicSection content computation. NFC
> > > 
> > >      The new code computes the content twice, but avoides the tricky
> > >      std::function<uint64_t()>. Removed 13KiB code in a Release build.
> > > 
> > >   lld/ELF/SyntheticSections.cpp | 117 ++++++++++++++++--------------------------
> > >   lld/ELF/SyntheticSections.h   |  12 +----
> > >   2 files changed, 44 insertions(+), 85 deletions(-)
> > > 
> > > That's... interesting, given that commit title says No Functional
> > > Change, even though there clearly is one. That commit has a couple
> > > mentions of PowerPC synthetic sections, so it is possible that the
> > > new content calculation lines up with ld.bfd?
> > > 
> > > I am not really sure where to go from here, as I don't fully understand
> > > what the problem was before that LLD change. I'll see if I can do some
> > > more investigation tomorrow (unless someone wants to beat me to it ;)
> > 
> > Thank you for looking into this, and sharing your analysis.
> > 
> > I built LLVM/clang from the master branch, rebuilt, but can still reproduce
> > this.
> > 
> >     $ git clone --depth=1 https://github.com/llvm/llvm-project.git
> >     $ cd llvm-project/
> >     $ git log --oneline
> >     41cb504b7 [mlir][linalg][bufferize][NFC] Move interface impl to Linalg
> > Transforms
> >     $ mkdir build
> >     $ cd build
> >     $ cmake -DLLVM_ENABLE_PROJECTS=clang -G "Unix Makefiles"
> 
> Since this is something related to ld.lld, not clang, this should be:
> 
> ... -DLLVM_ENABLE_PROJECTS="clang;lld" ...
> 
> > -DCMAKE_BUILD_TYPE=Release -DLLVM_INSTALL_UTILS=ON
> > -DCMAKE_INSTALL_PREFIX=/scratch/local2/llvm ../llvm
> >     $ make -j20
> >     $ make -j20 clang-check
> 
> You can also do 'check-lld' if you want.
> 
> >     $ make install
> >     $ /scratch/local2/llvm/bin/clang --version
> >     clang version 15.0.0 (https://github.com/llvm/llvm-project.git
> > 41cb504b7c4b18ac15830107431a0c1eec73a6b2)
> >     Target: powerpc64le-unknown-linux-gnu
> >     Thread model: posix
> >     InstalledDir: /scratch/local2/llvm/bin
> > 
> > Then build Linux after `make clean` with `/scratch/local2/llvm/bin` in the
> > path.
> > 
> >     $ LLVM=1 LLVM_IAS=0 eatmydata make -j20
> > 
> >     $ qemu-system-ppc64 -enable-kvm -nographic -smp cores=1,threads=1 -net
> > none -enable-kvm -M pseries -nodefaults -device spapr-vscsi -serial stdio -m
> > 512 -kernel /dev/shm/linux/vmlinux -append "debug_boot_weak_hash panic=-1
> > console=ttyS0 rcupdate.rcu_cpu_stall_suppress_at_boot=1
> > torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000
> > rcupdate.rcu_self_test=1 rcutorture.onoff_interval=1000
> > rcutorture.onoff_holdoff=30 rcutorture.n_barrier_cbs=4
> > rcutorture.stat_interval=15 rcutorture.shutdown_secs=420
> > rcutorture.test_no_idle_hz=1 rcutorture.verbose=1"
> >     […]
> >     Preparing to boot Linux version 5.17.0-rc5-00178-ga4b9a8fb20e7
> > (pmenzel@flughafenberlinbrandenburgwillybrandt.molgen.mpg.de) (clang version
> > 15.0.0 (https://github.com/llvm/llvm-project.git
> > 41cb504b7c4b18ac15830107431a0c1eec73a6b2), LLD 13.0.0) #29 SMP PREEMPT Mon
> 
>                                              ^ still using ld.lld 13.0.0.
> 
> If you want to test the master branch, I would checkout LLVM at
> 460830a9c664e8cce959c660648faa7747ad8bdc, as the next commit introduces
> a boot regression unrelated to this issue:
> 
> https://github.com/ClangBuiltLinux/linux/issues/1581
> 
> That should at least confirm this is resolved in a newer release.
> 
> > Feb 21 10:58:54 CET 2022
> >     […]
> >     [    0.465889][    T1] BUG: Kernel NULL pointer dereference on read at
> > 0x00000000
> >     [    0.466749][    T1] Faulting instruction address: 0xc0000000008fc300
> >     [    0.467507][    T1] Oops: Kernel access of bad area, sig: 11 [#1]
> >     […]
> 
> I do intend to do further analysis at some point over the next few days
> to see if I can figure out exactly why that commit that I mentioned
> above fixes the issue then we can look into what we should do about it
> in the kernel sources.

Sorry for taking so long to get back to this. For me, commit
d79976918852 ("powerpc/64: Add UADDR64 relocation support") resolves
this for ld.lld 13.x. I have started a separate thread about whether or
not this commit is suitable for stable, specifically 5.17 and 5.15:

https://lore.kernel.org/Yl8pNxSGUgeHZ1FT@dev-arch.thelio-3990X/

Cheers,
Nathan
