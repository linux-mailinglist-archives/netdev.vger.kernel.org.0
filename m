Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC0F4A62F5
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiBARu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiBARu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:50:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FEDC061714;
        Tue,  1 Feb 2022 09:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4AB9CE1A59;
        Tue,  1 Feb 2022 17:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DB8C340EB;
        Tue,  1 Feb 2022 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643737824;
        bh=pcBEAiJy6A2HwZd9563pmFy1sMOqcq7pdb7o0wdfzXo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=RbHdVZP+VOfh7KRE4SV9zaHdcI1rgB4sPMRViFMIXguabKu8oSQBwQXK4MNHlW4Di
         6Kih+Wqx5s6rrrwnAxGLTlDbLklvU6fWfBoTgvYvavS69I/gibOznMN3zg0nIihEn7
         J6+oOhazAyi4Iy9vBFYXyYdNBWfqC6W6ZqrHQMvujP1yX/WHoZ35moGFwzwCMjte8I
         nZllRIhcXlUz++1R1NzLBl3X9LYuf6WMXopkH8U320kqbxcWKR5LP232PLqHRqXy2e
         BiqkUcsJf5vVIOP/vhgbEEPfvY3ZMA3Oh9JVtYIhafP08+75tc9YboDGJQfZfPuec3
         shL8qYq6OVMnA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id BAEBB5C0326; Tue,  1 Feb 2022 09:50:23 -0800 (PST)
Date:   Tue, 1 Feb 2022 09:50:23 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Josh Triplett <josh@joshtriplett.org>,
        rcu <rcu@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: BUG: Kernel NULL pointer dereference on write at 0x00000000
 (rtmsg_ifinfo_build_skb)
Message-ID: <20220201175023.GW4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <159db05f-539c-fe29-608b-91b036588033@molgen.mpg.de>
 <CAABZP2xampOLo8k93OLgaOfv9LreJ+f0g0_1mXwqtrv_LKewQg@mail.gmail.com>
 <3534d781-7d01-b42a-8974-0b1c367946f0@molgen.mpg.de>
 <CAABZP2zFDY-hrZqE=-c0uW8vFMH+Q9XezYd2DcBX4Wm+sxzK1g@mail.gmail.com>
 <04a597dc-64aa-57e6-f7fb-17bd2ec58159@molgen.mpg.de>
 <CAABZP2yb7-xa4F_2c6tuzkv7x902wU-hqgD_pqRooGC6C7S20A@mail.gmail.com>
 <20220130174421.GS4285@paulmck-ThinkPad-P17-Gen-1>
 <CAABZP2w8ysVFmxRo7CMSHunnU0GqtS=+bU6tLqcsXDUyf60-Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAABZP2w8ysVFmxRo7CMSHunnU0GqtS=+bU6tLqcsXDUyf60-Dw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 09:08:40AM +0800, Zhouyi Zhou wrote:
> Thank Paul for joining us!
> 
> On Mon, Jan 31, 2022 at 1:44 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sun, Jan 30, 2022 at 09:24:44PM +0800, Zhouyi Zhou wrote:
> > > Dear Paul
> > >
> > > On Sun, Jan 30, 2022 at 4:19 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> > > >
> > > > Dear Zhouyi,
> > > >
> > > >
> > > > Am 30.01.22 um 01:21 schrieb Zhouyi Zhou:
> > > >
> > > > > Thank you for your instructions, I learned a lot from this process.
> > > >
> > > > Same on my end.
> > > >
> > > > > On Sun, Jan 30, 2022 at 12:52 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> > > >
> > > > >> Am 29.01.22 um 03:23 schrieb Zhouyi Zhou:
> > > > >>
> > > > >>> I don't have an IBM machine, but I tried to analyze the problem using
> > > > >>> my x86_64 kvm virtual machine, I can't reproduce the bug using my
> > > > >>> x86_64 kvm virtual machine.
> > > > >>
> > > > >> No idea, if it’s architecture specific.
> > > > >>
> > > > >>> I saw the panic is caused by registration of sit device (A sit device
> > > > >>> is a type of virtual network device that takes our IPv6 traffic,
> > > > >>> encapsulates/decapsulates it in IPv4 packets, and sends/receives it
> > > > >>> over the IPv4 Internet to another host)
> > > > >>>
> > > > >>> sit device is registered in function sit_init_net:
> > > > >>> 1895    static int __net_init sit_init_net(struct net *net)
> > > > >>> 1896    {
> > > > >>> 1897        struct sit_net *sitn = net_generic(net, sit_net_id);
> > > > >>> 1898        struct ip_tunnel *t;
> > > > >>> 1899        int err;
> > > > >>> 1900
> > > > >>> 1901        sitn->tunnels[0] = sitn->tunnels_wc;
> > > > >>> 1902        sitn->tunnels[1] = sitn->tunnels_l;
> > > > >>> 1903        sitn->tunnels[2] = sitn->tunnels_r;
> > > > >>> 1904        sitn->tunnels[3] = sitn->tunnels_r_l;
> > > > >>> 1905
> > > > >>> 1906        if (!net_has_fallback_tunnels(net))
> > > > >>> 1907            return 0;
> > > > >>> 1908
> > > > >>> 1909        sitn->fb_tunnel_dev = alloc_netdev(sizeof(struct ip_tunnel), "sit0",
> > > > >>> 1910                           NET_NAME_UNKNOWN,
> > > > >>> 1911                           ipip6_tunnel_setup);
> > > > >>> 1912        if (!sitn->fb_tunnel_dev) {
> > > > >>> 1913            err = -ENOMEM;
> > > > >>> 1914            goto err_alloc_dev;
> > > > >>> 1915        }
> > > > >>> 1916        dev_net_set(sitn->fb_tunnel_dev, net);
> > > > >>> 1917        sitn->fb_tunnel_dev->rtnl_link_ops = &sit_link_ops;
> > > > >>> 1918        /* FB netdevice is special: we have one, and only one per netns.
> > > > >>> 1919         * Allowing to move it to another netns is clearly unsafe.
> > > > >>> 1920         */
> > > > >>> 1921        sitn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
> > > > >>> 1922
> > > > >>> 1923        err = register_netdev(sitn->fb_tunnel_dev);
> > > > >>> register_netdev on line 1923 will call if_nlmsg_size indirectly.
> > > > >>>
> > > > >>> On the other hand, the function that calls the paniced strlen is if_nlmsg_size:
> > > > >>> (gdb) disassemble if_nlmsg_size
> > > > >>> Dump of assembler code for function if_nlmsg_size:
> > > > >>>      0xffffffff81a0dc20 <+0>:    nopl   0x0(%rax,%rax,1)
> > > > >>>      0xffffffff81a0dc25 <+5>:    push   %rbp
> > > > >>>      0xffffffff81a0dc26 <+6>:    push   %r15
> > > > >>>      0xffffffff81a0dd04 <+228>:    je     0xffffffff81a0de20 <if_nlmsg_size+512>
> > > > >>>      0xffffffff81a0dd0a <+234>:    mov    0x10(%rbp),%rdi
> > > > >>>      ...
> > > > >>>    => 0xffffffff81a0dd0e <+238>:    callq  0xffffffff817532d0 <strlen>
> > > > >>>      0xffffffff81a0dd13 <+243>:    add    $0x10,%eax
> > > > >>>      0xffffffff81a0dd16 <+246>:    movslq %eax,%r12
> > > > >>
> > > > >> Excuse my ignorance, would that look the same for ppc64le?
> > > > >> Unfortunately, I didn’t save the problematic `vmlinuz` file, but on a
> > > > >> current build (without rcutorture) I have the line below, where strlen
> > > > >> shows up.
> > > > >>
> > > > >>       (gdb) disassemble if_nlmsg_size
> > > > >>       […]
> > > > >>       0xc000000000f7f82c <+332>: bl      0xc000000000a10e30 <strlen>
> > > > >>       […]
> > > > >>
> > > > >>> and the C code for 0xffffffff81a0dd0e is following (line 524):
> > > > >>> 515    static size_t rtnl_link_get_size(const struct net_device *dev)
> > > > >>> 516    {
> > > > >>> 517        const struct rtnl_link_ops *ops = dev->rtnl_link_ops;
> > > > >>> 518        size_t size;
> > > > >>> 519
> > > > >>> 520        if (!ops)
> > > > >>> 521            return 0;
> > > > >>> 522
> > > > >>> 523        size = nla_total_size(sizeof(struct nlattr)) + /* IFLA_LINKINFO */
> > > > >>> 524               nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_KIND */
> > > > >>
> > > > >> How do I connect the disassemby output with the corresponding line?
> > > > > I use "make  ARCH=powerpc CC=powerpc64le-linux-gnu-gcc-9
> > > > > CROSS_COMPILE=powerpc64le-linux-gnu- -j 16" to cross compile kernel
> > > > > for powerpc64le in my Ubuntu 20.04 x86_64.
> > > > >
> > > > > gdb-multiarch ./vmlinux
> > > > > (gdb)disassemble if_nlmsg_size
> > > > > [...]
> > > > > 0xc00000000191bf40 <+112>:    bl      0xc000000001c28ad0 <strlen>
> > > > > [...]
> > > > > (gdb) break *0xc00000000191bf40
> > > > > Breakpoint 1 at 0xc00000000191bf40: file ./include/net/netlink.h, line 1112.
> > > > >
> > > > > But in include/net/netlink.h:1112, I can't find the call to strlen
> > > > > 1110static inline int nla_total_size(int payload)
> > > > > 1111{
> > > > > 1112        return NLA_ALIGN(nla_attr_size(payload));
> > > > > 1113}
> > > > > This may be due to the compiler wrongly encode the debug information, I guess.
> > > >
> > > > `rtnl_link_get_size()` contains:
> > > >
> > > >              size = nla_total_size(sizeof(struct nlattr)) + /*
> > > > IFLA_LINKINFO */
> > > >                     nla_total_size(strlen(ops->kind) + 1);  /*
> > > > IFLA_INFO_KIND */
> > > >
> > > > Is that inlined(?) and the code at fault?
> > > Yes, that is inlined! because
> > > (gdb) disassemble if_nlmsg_size
> > > Dump of assembler code for function if_nlmsg_size:
> > > [...]
> > > 0xc00000000191bf38 <+104>:    beq     0xc00000000191c1f0 <if_nlmsg_size+800>
> > > 0xc00000000191bf3c <+108>:    ld      r3,16(r31)
> > > 0xc00000000191bf40 <+112>:    bl      0xc000000001c28ad0 <strlen>
> > > [...]
> > > (gdb)
> > > (gdb) break *0xc00000000191bf40
> > > Breakpoint 1 at 0xc00000000191bf40: file ./include/net/netlink.h, line 1112.
> > > (gdb) break *0xc00000000191bf38
> > > Breakpoint 2 at 0xc00000000191bf38: file net/core/rtnetlink.c, line 520.
> >
> > I suggest building your kernel with CONFIG_DEBUG_INFO=y if you are not
> > already doing so.  That gives gdb a lot more information about things
> > like inlining.
> I check my .config file, CONFIG_DEBUG_INFO=y is here:
> linux-next$ grep CONFIG_DEBUG_INFO .config
> CONFIG_DEBUG_INFO=y
> Then I invoke "make clean" and rebuild the kernel, the behavior of gdb
> and vmlinux remain unchanged, sorry for that

Glad you were already on top of this one!

> I am trying to reproduce the bug on my bare metal x86_64 machines in
> the coming days, and am also trying to work with Mr Menzel after he
> comes back to the office.

This URL used to allow community members such as yourself to request
access to Power systems: https://osuosl.org/services/powerdev/

In case that helps.

							Thanx, Paul

> Thanks
> Zhouyi
> >
> >                                                         Thanx, Paul
> >
> > > > >>> But ops is assigned the value of sit_link_ops in function sit_init_net
> > > > >>> line 1917, so I guess something must happened between the calls.
> > > > >>>
> > > > >>> Do we have KASAN in IBM machine? would KASAN help us find out what
> > > > >>> happened in between?
> > > > >>
> > > > >> Unfortunately, KASAN is not support on Power, I have, as far as I can
> > > > >> see. From `arch/powerpc/Kconfig`:
> > > > >>
> > > > >>           select HAVE_ARCH_KASAN                  if PPC32 && PPC_PAGE_SHIFT <= 14
> > > > >>           select HAVE_ARCH_KASAN_VMALLOC          if PPC32 && PPC_PAGE_SHIFT <= 14
> > > > >>
> > > > > en, agree, I invoke "make  menuconfig  ARCH=powerpc
> > > > > CC=powerpc64le-linux-gnu-gcc-9 CROSS_COMPILE=powerpc64le-linux-gnu- -j
> > > > > 16", I can't find KASAN under Memory Debugging, I guess we should find
> > > > > the bug by bisecting instead.
> > > >
> > > > I do not know, if it is a regression, as it was the first time I tried
> > > > to run a Linux kernel built with rcutorture on real hardware.
> > > I tried to add some debug statements to the kernel to locate the bug
> > > more accurately,  you can try it when you're not busy in the future,
> > > or just ignore it if the following patch looks not very effective ;-)
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 1baab07820f6..969ac7c540cc 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -9707,6 +9707,9 @@ int register_netdevice(struct net_device *dev)
> > >       *    Prevent userspace races by waiting until the network
> > >       *    device is fully setup before sending notifications.
> > >       */
> > > +    if (dev->rtnl_link_ops)
> > > +        printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", dev->rtnl_link_ops,
> > > +               dev->rtnl_link_ops->kind, __FUNCTION__);
> > >      if (!dev->rtnl_link_ops ||
> > >          dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
> > >          rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL);
> > > @@ -9788,6 +9791,9 @@ int register_netdev(struct net_device *dev)
> > >
> > >      if (rtnl_lock_killable())
> > >          return -EINTR;
> > > +    if (dev->rtnl_link_ops)
> > > +        printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", dev->rtnl_link_ops,
> > > +               dev->rtnl_link_ops->kind, __FUNCTION__);
> > >      err = register_netdevice(dev);
> > >      rtnl_unlock();
> > >      return err;
> > > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > > index e476403231f0..e08986ae6238 100644
> > > --- a/net/core/rtnetlink.c
> > > +++ b/net/core/rtnetlink.c
> > > @@ -520,6 +520,8 @@ static size_t rtnl_link_get_size(const struct
> > > net_device *dev)
> > >      if (!ops)
> > >          return 0;
> > >
> > > +    printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", ops,
> > > +           ops->kind, __FUNCTION__);
> > >      size = nla_total_size(sizeof(struct nlattr)) + /* IFLA_LINKINFO */
> > >             nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_KIND */
> > >
> > > @@ -1006,6 +1008,9 @@ static size_t rtnl_proto_down_size(const struct
> > > net_device *dev)
> > >  static noinline size_t if_nlmsg_size(const struct net_device *dev,
> > >                       u32 ext_filter_mask)
> > >  {
> > > +    if (dev->rtnl_link_ops)
> > > +        printk(KERN_INFO "%lx IFLA_INFO_KIND  %s %s\n", dev->rtnl_link_ops,
> > > +               dev->rtnl_link_ops->kind, __FUNCTION__);
> > >      return NLMSG_ALIGN(sizeof(struct ifinfomsg))
> > >             + nla_total_size(IFNAMSIZ) /* IFLA_IFNAME */
> > >             + nla_total_size(IFALIASZ) /* IFLA_IFALIAS */
> > > @@ -3825,7 +3830,9 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type,
> > > struct net_device *dev,
> > >      struct net *net = dev_net(dev);
> > >      struct sk_buff *skb;
> > >      int err = -ENOBUFS;
> > > -
> > > +    if (dev->rtnl_link_ops)
> > > +        printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", dev->rtnl_link_ops,
> > > +               dev->rtnl_link_ops->kind, __FUNCTION__);
> > >      skb = nlmsg_new(if_nlmsg_size(dev, 0), flags);
> > >      if (skb == NULL)
> > >          goto errout;
> > > @@ -3861,7 +3868,9 @@ static void rtmsg_ifinfo_event(int type, struct
> > > net_device *dev,
> > >
> > >      if (dev->reg_state != NETREG_REGISTERED)
> > >          return;
> > > -
> > > +    if (dev->rtnl_link_ops)
> > > +        printk(KERN_INFO "%lx IFLA_INFO_KIND  %s %s\n", dev->rtnl_link_ops,
> > > +               dev->rtnl_link_ops->kind, __FUNCTION__);
> > >      skb = rtmsg_ifinfo_build_skb(type, dev, change, event, flags, new_nsid,
> > >                       new_ifindex);
> > >      if (skb)
> > > @@ -3871,6 +3880,9 @@ static void rtmsg_ifinfo_event(int type, struct
> > > net_device *dev,
> > >  void rtmsg_ifinfo(int type, struct net_device *dev, unsigned int change,
> > >            gfp_t flags)
> > >  {
> > > +    if (dev->rtnl_link_ops)
> > > +        printk(KERN_INFO "%lx IFLA_INFO_KIND  %s %s\n", dev->rtnl_link_ops,
> > > +               dev->rtnl_link_ops->kind, __FUNCTION__);
> > >      rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
> > >                 NULL, 0);
> > >  }
> > > diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> > > index c0b138c20992..fa5b2725811c 100644
> > > --- a/net/ipv6/sit.c
> > > +++ b/net/ipv6/sit.c
> > > @@ -1919,6 +1919,8 @@ static int __net_init sit_init_net(struct net *net)
> > >       * Allowing to move it to another netns is clearly unsafe.
> > >       */
> > >      sitn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
> > > -
> > > +    printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n",
> > > +           sitn->fb_tunnel_dev->rtnl_link_ops,
> > > +           sitn->fb_tunnel_dev->rtnl_link_ops->kind, __FUNCTION__);
> > >      err = register_netdev(sitn->fb_tunnel_dev);
> > >      if (err)
> > >          goto err_reg_dev;
> > > >
> > > > >>> Hope I can be of more helpful.
> > > > >>
> > > > >> Some distributions support multi-arch, so they easily allow
> > > > >> crosscompiling for different architectures.
> > > > > I use "make  ARCH=powerpc CC=powerpc64le-linux-gnu-gcc-9
> > > > > CROSS_COMPILE=powerpc64le-linux-gnu- -j 16" to cross compile kernel
> > > > > for powerpc64le in my Ubuntu 20.04 x86_64. But I can't boot the
> > > > > compiled kernel using "qemu-system-ppc64le -M pseries -nographic -smp
> > > > > 4 -net none -m 4G -kernel arch/powerpc/boot/zImage". I will continue
> > > > > to explore it.
> > > >
> > > > Oh, that does not sound good. But I have not tried that in a long time
> > > > either. It’s a separate issue, but maybe some of the PPC
> > > > maintainers/folks could help.
> > > I will do further research on this later.
> > >
> > > Thanks for your time
> > > Kind regards
> > > Zhouyi
> > > >
> > > >
> > > > Kind regards,
> > > >
> > > > Paul
