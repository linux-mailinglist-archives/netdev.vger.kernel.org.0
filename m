Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B614BFC9A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbiBVPbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiBVPbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:31:12 -0500
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6F916203E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:30:45 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:c0fe:4675:4cef:99a5])
        by baptiste.telenet-ops.be with bizsmtp
        id yFWe260014Plfy301FWeNn; Tue, 22 Feb 2022 16:30:43 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nMX7d-001Yw6-D0; Tue, 22 Feb 2022 16:30:37 +0100
Date:   Tue, 22 Feb 2022 16:30:37 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc:     Marek Szyprowski <m.szyprowski@samsung.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
In-Reply-To: <da6abfe2-dafd-4aa1-adca-472137423ba4@samsung.com>
Message-ID: <alpine.DEB.2.22.394.2202221622570.372449@ramsan.of.borg>
References: <20220211233839.2280731-1-bigeasy@linutronix.de>        <20220211233839.2280731-3-bigeasy@linutronix.de>        <CGME20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54@eucas1p1.samsung.com> <da6abfe2-dafd-4aa1-adca-472137423ba4@samsung.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-147414761-1645543837=:372449"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-147414761-1645543837=:372449
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

 	Hi Sebastian,

On Wed, 16 Feb 2022, Marek Szyprowski wrote:
> On 12.02.2022 00:38, Sebastian Andrzej Siewior wrote:
>> Dave suggested a while ago (eleven years by now) "Let's make netif_rx()
>> work in all contexts and get rid of netif_rx_ni()". Eric agreed and
>> pointed out that modern devices should use netif_receive_skb() to avoid
>> the overhead.
>> In the meantime someone added another variant, netif_rx_any_context(),
>> which behaves as suggested.
>>
>> netif_rx() must be invoked with disabled bottom halves to ensure that
>> pending softirqs, which were raised within the function, are handled.
>> netif_rx_ni() can be invoked only from process context (bottom halves
>> must be enabled) because the function handles pending softirqs without
>> checking if bottom halves were disabled or not.
>> netif_rx_any_context() invokes on the former functions by checking
>> in_interrupts().
>>
>> netif_rx() could be taught to handle both cases (disabled and enabled
>> bottom halves) by simply disabling bottom halves while invoking
>> netif_rx_internal(). The local_bh_enable() invocation will then invoke
>> pending softirqs only if the BH-disable counter drops to zero.
>>
>> Eric is concerned about the overhead of BH-disable+enable especially in
>> regard to the loopback driver. As critical as this driver is, it will
>> receive a shortcut to avoid the additional overhead which is not needed.
>>
>> Add a local_bh_disable() section in netif_rx() to ensure softirqs are
>> handled if needed.
>> Provide __netif_rx() which does not disable BH and has a lockdep assert
>> to ensure that interrupts are disabled. Use this shortcut in the
>> loopback driver and in drivers/net/*.c.
>> Make netif_rx_ni() and netif_rx_any_context() invoke netif_rx() so they
>> can be removed once they are no more users left.
>>
>> Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft.net
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
>
> This patch landed in linux-next 20220215 as commit baebdf48c360 ("net:
> dev: Makes sure netif_rx() can be invoked in any context."). I found
> that it triggers the following warning on my test systems with USB CDC
> ethernet gadget:
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 876 at kernel/softirq.c:308
> __local_bh_disable_ip+0xbc/0xc0

Similar on rbtx4927 (CONFIG_NE2000=y), where I'm getting a slightly
different warning:

     Sending DHCP requests .
     ------------[ cut here ]------------
     WARNING: CPU: 0 PID: 0 at kernel/softirq.c:362 __local_bh_enable_ip+0x4c/0xc0
     Modules linked in:
     CPU: 0 PID: 0 Comm: swapper Not tainted 5.17.0-rc5-rbtx4927-00770-ga8ca72253967 #300
     Stack : 9800000000b80800 0000000000000008 0000000000000000 a5ba96d4be38c8b0
 	    0000000000000000 9800000000813c10 ffffffff80468188 9800000000813a90
 	    0000000000000001 9800000000813ab0 0000000000000000 20746f4e20726570
 	    0000000000000010 ffffffff802c1400 ffffffff8054ce76 722d302e37312e35
 	    0000000000000000 0000000000000000 0000000000000009 0000000000000000
 	    98000000008bfd40 000000000000004c 0000000006020283 0000000006020287
 	    0000000000000000 0000000000000000 0000000000000000 ffffffff80540000
 	    ffffffff804b8000 9800000000813c10 9800000000b80800 ffffffff801238bc
 	    0000000000000000 ffffffff80470000 0000000000000000 0000000000000009
 	    0000000000000000 ffffffff80108738 0000000000000000 ffffffff801238bc
 	    ...
     Call Trace:
     [<ffffffff80108738>] show_stack+0x68/0xf4
     [<ffffffff801238bc>] __warn+0xc0/0xf0
     [<ffffffff80123964>] warn_slowpath_fmt+0x78/0x94
     [<ffffffff80126408>] __local_bh_enable_ip+0x4c/0xc0
     [<ffffffff80341754>] netif_rx+0x20/0x30
     [<ffffffff8031d870>] ei_receive+0x2f0/0x36c
     [<ffffffff8031e624>] eip_interrupt+0x2dc/0x36c
     [<ffffffff8014f488>] __handle_irq_event_percpu+0x8c/0x134
     [<ffffffff8014f548>] handle_irq_event_percpu+0x18/0x60
     [<ffffffff8014f5c8>] handle_irq_event+0x38/0x60
     [<ffffffff80152008>] handle_level_irq+0x80/0xbc
     [<ffffffff8014eecc>] handle_irq_desc+0x24/0x3c
     [<ffffffff804014b8>] do_IRQ+0x18/0x24
     [<ffffffff801031b0>] handle_int+0x148/0x154
     [<ffffffff80104e18>] arch_local_irq_enable+0x18/0x24
     [<ffffffff8040148c>] default_idle_call+0x2c/0x3c
     [<ffffffff801445d0>] do_idle+0xcc/0x104
     [<ffffffff80144620>] cpu_startup_entry+0x18/0x20
     [<ffffffff80508e34>] start_kernel+0x6f4/0x738

     ---[ end trace 0000000000000000 ]---
     , OK
     IP-Config: Got DHCP answer from a.b.c.d, my address is a.b.c.e
     IP-Config: Complete:

Reverting baebdf48c3600807 ("net: dev: Makes sure netif_rx() can be
invoked in any context.") fixes the issue for me.

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
--8323329-147414761-1645543837=:372449--
