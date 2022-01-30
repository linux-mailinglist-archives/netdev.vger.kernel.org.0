Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568404A351F
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 09:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354369AbiA3ITa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 03:19:30 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:56615 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234792AbiA3IT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 03:19:29 -0500
Received: from [10.59.106.37] (unknown [77.235.169.38])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A22C561EA1926;
        Sun, 30 Jan 2022 09:19:25 +0100 (CET)
Message-ID: <04a597dc-64aa-57e6-f7fb-17bd2ec58159@molgen.mpg.de>
Date:   Sun, 30 Jan 2022 09:19:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: BUG: Kernel NULL pointer dereference on write at 0x00000000
 (rtmsg_ifinfo_build_skb)
Content-Language: en-US
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <159db05f-539c-fe29-608b-91b036588033@molgen.mpg.de>
 <CAABZP2xampOLo8k93OLgaOfv9LreJ+f0g0_1mXwqtrv_LKewQg@mail.gmail.com>
 <3534d781-7d01-b42a-8974-0b1c367946f0@molgen.mpg.de>
 <CAABZP2zFDY-hrZqE=-c0uW8vFMH+Q9XezYd2DcBX4Wm+sxzK1g@mail.gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAABZP2zFDY-hrZqE=-c0uW8vFMH+Q9XezYd2DcBX4Wm+sxzK1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Zhouyi,


Am 30.01.22 um 01:21 schrieb Zhouyi Zhou:

> Thank you for your instructions, I learned a lot from this process.

Same on my end.

> On Sun, Jan 30, 2022 at 12:52 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:

>> Am 29.01.22 um 03:23 schrieb Zhouyi Zhou:
>>
>>> I don't have an IBM machine, but I tried to analyze the problem using
>>> my x86_64 kvm virtual machine, I can't reproduce the bug using my
>>> x86_64 kvm virtual machine.
>>
>> No idea, if it’s architecture specific.
>>
>>> I saw the panic is caused by registration of sit device (A sit device
>>> is a type of virtual network device that takes our IPv6 traffic,
>>> encapsulates/decapsulates it in IPv4 packets, and sends/receives it
>>> over the IPv4 Internet to another host)
>>>
>>> sit device is registered in function sit_init_net:
>>> 1895    static int __net_init sit_init_net(struct net *net)
>>> 1896    {
>>> 1897        struct sit_net *sitn = net_generic(net, sit_net_id);
>>> 1898        struct ip_tunnel *t;
>>> 1899        int err;
>>> 1900
>>> 1901        sitn->tunnels[0] = sitn->tunnels_wc;
>>> 1902        sitn->tunnels[1] = sitn->tunnels_l;
>>> 1903        sitn->tunnels[2] = sitn->tunnels_r;
>>> 1904        sitn->tunnels[3] = sitn->tunnels_r_l;
>>> 1905
>>> 1906        if (!net_has_fallback_tunnels(net))
>>> 1907            return 0;
>>> 1908
>>> 1909        sitn->fb_tunnel_dev = alloc_netdev(sizeof(struct ip_tunnel), "sit0",
>>> 1910                           NET_NAME_UNKNOWN,
>>> 1911                           ipip6_tunnel_setup);
>>> 1912        if (!sitn->fb_tunnel_dev) {
>>> 1913            err = -ENOMEM;
>>> 1914            goto err_alloc_dev;
>>> 1915        }
>>> 1916        dev_net_set(sitn->fb_tunnel_dev, net);
>>> 1917        sitn->fb_tunnel_dev->rtnl_link_ops = &sit_link_ops;
>>> 1918        /* FB netdevice is special: we have one, and only one per netns.
>>> 1919         * Allowing to move it to another netns is clearly unsafe.
>>> 1920         */
>>> 1921        sitn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
>>> 1922
>>> 1923        err = register_netdev(sitn->fb_tunnel_dev);
>>> register_netdev on line 1923 will call if_nlmsg_size indirectly.
>>>
>>> On the other hand, the function that calls the paniced strlen is if_nlmsg_size:
>>> (gdb) disassemble if_nlmsg_size
>>> Dump of assembler code for function if_nlmsg_size:
>>>      0xffffffff81a0dc20 <+0>:    nopl   0x0(%rax,%rax,1)
>>>      0xffffffff81a0dc25 <+5>:    push   %rbp
>>>      0xffffffff81a0dc26 <+6>:    push   %r15
>>>      0xffffffff81a0dd04 <+228>:    je     0xffffffff81a0de20 <if_nlmsg_size+512>
>>>      0xffffffff81a0dd0a <+234>:    mov    0x10(%rbp),%rdi
>>>      ...
>>>    => 0xffffffff81a0dd0e <+238>:    callq  0xffffffff817532d0 <strlen>
>>>      0xffffffff81a0dd13 <+243>:    add    $0x10,%eax
>>>      0xffffffff81a0dd16 <+246>:    movslq %eax,%r12
>>
>> Excuse my ignorance, would that look the same for ppc64le?
>> Unfortunately, I didn’t save the problematic `vmlinuz` file, but on a
>> current build (without rcutorture) I have the line below, where strlen
>> shows up.
>>
>>       (gdb) disassemble if_nlmsg_size
>>       […]
>>       0xc000000000f7f82c <+332>: bl      0xc000000000a10e30 <strlen>
>>       […]
>>
>>> and the C code for 0xffffffff81a0dd0e is following (line 524):
>>> 515    static size_t rtnl_link_get_size(const struct net_device *dev)
>>> 516    {
>>> 517        const struct rtnl_link_ops *ops = dev->rtnl_link_ops;
>>> 518        size_t size;
>>> 519
>>> 520        if (!ops)
>>> 521            return 0;
>>> 522
>>> 523        size = nla_total_size(sizeof(struct nlattr)) + /* IFLA_LINKINFO */
>>> 524               nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_KIND */
>>
>> How do I connect the disassemby output with the corresponding line?
> I use "make  ARCH=powerpc CC=powerpc64le-linux-gnu-gcc-9
> CROSS_COMPILE=powerpc64le-linux-gnu- -j 16" to cross compile kernel
> for powerpc64le in my Ubuntu 20.04 x86_64.
> 
> gdb-multiarch ./vmlinux
> (gdb)disassemble if_nlmsg_size
> [...]
> 0xc00000000191bf40 <+112>:    bl      0xc000000001c28ad0 <strlen>
> [...]
> (gdb) break *0xc00000000191bf40
> Breakpoint 1 at 0xc00000000191bf40: file ./include/net/netlink.h, line 1112.
> 
> But in include/net/netlink.h:1112, I can't find the call to strlen
> 1110static inline int nla_total_size(int payload)
> 1111{
> 1112        return NLA_ALIGN(nla_attr_size(payload));
> 1113}
> This may be due to the compiler wrongly encode the debug information, I guess.

`rtnl_link_get_size()` contains:

             size = nla_total_size(sizeof(struct nlattr)) + /* 
IFLA_LINKINFO */
                    nla_total_size(strlen(ops->kind) + 1);  /* 
IFLA_INFO_KIND */

Is that inlined(?) and the code at fault?

>>> But ops is assigned the value of sit_link_ops in function sit_init_net
>>> line 1917, so I guess something must happened between the calls.
>>>
>>> Do we have KASAN in IBM machine? would KASAN help us find out what
>>> happened in between?
>>
>> Unfortunately, KASAN is not support on Power, I have, as far as I can
>> see. From `arch/powerpc/Kconfig`:
>>
>>           select HAVE_ARCH_KASAN                  if PPC32 && PPC_PAGE_SHIFT <= 14
>>           select HAVE_ARCH_KASAN_VMALLOC          if PPC32 && PPC_PAGE_SHIFT <= 14
>>
> en, agree, I invoke "make  menuconfig  ARCH=powerpc
> CC=powerpc64le-linux-gnu-gcc-9 CROSS_COMPILE=powerpc64le-linux-gnu- -j
> 16", I can't find KASAN under Memory Debugging, I guess we should find
> the bug by bisecting instead.

I do not know, if it is a regression, as it was the first time I tried 
to run a Linux kernel built with rcutorture on real hardware.

>>> Hope I can be of more helpful.
>>
>> Some distributions support multi-arch, so they easily allow
>> crosscompiling for different architectures.
> I use "make  ARCH=powerpc CC=powerpc64le-linux-gnu-gcc-9
> CROSS_COMPILE=powerpc64le-linux-gnu- -j 16" to cross compile kernel
> for powerpc64le in my Ubuntu 20.04 x86_64. But I can't boot the
> compiled kernel using "qemu-system-ppc64le -M pseries -nographic -smp
> 4 -net none -m 4G -kernel arch/powerpc/boot/zImage". I will continue
> to explore it.

Oh, that does not sound good. But I have not tried that in a long time 
either. It’s a separate issue, but maybe some of the PPC 
maintainers/folks could help.


Kind regards,

Paul
