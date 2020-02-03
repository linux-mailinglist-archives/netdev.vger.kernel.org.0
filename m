Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660C9150797
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 14:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgBCNnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 08:43:49 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42743 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgBCNnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 08:43:49 -0500
Received: by mail-lj1-f195.google.com with SMTP id d10so14645403ljl.9
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 05:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0oZvLE0wV4+dIhVzJgWhi9Otxqj1OjNQ2STMZT4lrsQ=;
        b=FGlzeSoFcdzAK9/RZVx2dbmIManF4yO11To1sJ8dSAL6BqjVr0npej5BNrFf1qQfPO
         t9RYpcozJ5bGCsw3Hy9wQcu+WexOvlM95fHhXe41fOwZxEhaRq5z6rye0GDcGTP3O3rp
         XZkq8/3OurmZRup722kZMrV867kd52f5X5sSpAAtzM/aDLcOiVQQyzK6oT8jsv4M5oBx
         jqSp7o6eQTLQuqT7zqqwgXrJN8EJLU0Sm/wULFlZyPgtL9B3wtip7+MJ8YTvLrFhcr0d
         SkfnC0zTdrq4PJqOFtBpn+GgKAwraRxmFVOTTXTkGsVVHZl5DwARdEeXapVQ3KKuRgH0
         N7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0oZvLE0wV4+dIhVzJgWhi9Otxqj1OjNQ2STMZT4lrsQ=;
        b=tR/AAzNK1aHnUbpm86gzv1eGhz5/uKkRy3J85sxa7ZfaMkpEmHIdB5EejfqaWykzjq
         yNTLh5MSBODYZKHvx5PMkTdvhvDqHgthBX664K+nx5laXYdC99kZITlQmR9jRT5G6a9m
         lw1AR9xYH760pdMqSxOd6OVE8gPp37rXQMehQAjGbMIxUW435ITddBukrJoybCDc9Xzi
         0hrC244aH65fDxIOCt+f5FpejS+GTyRtoVSRrs6+UvOUkInr27WrWsFeK/VjvC5z6sk5
         vOLqVUAzoD36QRWDSVYG/+qJkyvnOihHXus1OHF/bLiLh/oBXs3kQZ2DKjZwLFlpWH/b
         srqg==
X-Gm-Message-State: APjAAAXAWBP07yEj0sJ+eumPhsypjyYVUu1H3JaL9EqIMMXM4uNCQ0LS
        DU7YlV5jg8BHTBS/5paefFi6RGOGxMrgRCh1ZFrgUg==
X-Google-Smtp-Source: APXvYqxDgAFxjGt4n1sPSbTTgTVYTNCCPllor6LZmhF9sHF00c5HSINZ3D5pbul6brCy2H0gvG3ldaEWdOOPusa6c+Y=
X-Received: by 2002:a2e:8e70:: with SMTP id t16mr13903334ljk.73.1580737426568;
 Mon, 03 Feb 2020 05:43:46 -0800 (PST)
MIME-Version: 1.0
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
In-Reply-To: <20200124132656.22156-1-o.rempel@pengutronix.de>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 3 Feb 2020 19:13:35 +0530
Message-ID: <CA+G9fYsxOouFBgCBacXzdimJUfZ3DXVAia6XL7kCvcQX7qgOnA@mail.gmail.com>
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com, Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-can@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jan 2020 at 18:57, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> All user space generated SKBs are owned by a socket (unless injected
> into the key via AF_PACKET). If a socket is closed, all associated skbs
> will be cleaned up.
>
> This leads to a problem when a CAN driver calls can_put_echo_skb() on a
> unshared SKB. If the socket is closed prior to the TX complete handler,
> can_get_echo_skb() and the subsequent delivering of the echo SKB to
> all registered callbacks, a SKB with a refcount of 0 is delivered.
>
> To avoid the problem, in can_get_echo_skb() the original SKB is now
> always cloned, regardless of shared SKB or not. If the process exists it
> can now safely discard its SKBs, without disturbing the delivery of the
> echo SKB.
>
> The problem shows up in the j1939 stack, when it clones the
> incoming skb, which detects the already 0 refcount.
>
> We can easily reproduce this with following example:
>
> testj1939 -B -r can0: &
> cansend can0 1823ff40#0123
>
> WARNING: CPU: 0 PID: 293 at lib/refcount.c:25 refcount_warn_saturate+0x108/0x174
> refcount_t: addition on 0; use-after-free.

FYI,
This issue noticed in our Linaro test farm
On linux next version 5.5.0-next-20200203 running on beagleboard x15 arm device.

Thanks for providing fix for this case.

Warning log.
[    0.013414] ------------[ cut here ]------------
[    0.013420] WARNING: CPU: 0 PID: 0 at
/usr/src/kernel/lib/refcount.c:25 refcount_warn_saturate+0x108/0x174
[    0.013424] refcount_t: addition on 0; use-after-free.
[    0.013427] Modules linked in:
[    0.013435] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-next-20200203 #1
[    0.013439] Hardware name: Generic DRA74X (Flattened Device Tree)
[    0.013442] Backtrace:
[    0.013448] [<c040fac4>] (dump_backtrace) from [<c040fdf8>]
(show_stack+0x20/0x24)
[    0.013452]  r7:c23f2e68 r6:00000000 r5:600000d3 r4:c23f2e68
[    0.013456] [<c040fdd8>] (show_stack) from [<c14144d0>]
(dump_stack+0xe8/0x114)
[    0.013459] [<c14143e8>] (dump_stack) from [<c04595cc>] (__warn+0x100/0x118)
[    0.013463]  r10:efca9a50 r9:c0957770 r8:00000019 r7:c1c2343c
r6:00000009 r5:00000000
[    0.013467]  r4:c2201b7c r3:be2d277f
[    0.013470] [<c04594cc>] (__warn) from [<c0459668>]
(warn_slowpath_fmt+0x84/0xc0)
[    0.013474]  r9:00000009 r8:c0957770 r7:00000019 r6:c1c2343c
r5:c1c2345c r4:c2208708
[    0.013478] [<c04595e8>] (warn_slowpath_fmt) from [<c0957770>]
(refcount_warn_saturate+0x108/0x174)
[    0.013481]  r9:c2a36014 r8:c2a35c56 r7:c2a35c56 r6:00000007
r5:efca9a50 r4:efca9a70
[    0.013485] [<c0957668>] (refcount_warn_saturate) from [<c1419a30>]
(kobject_get+0xa8/0xac)
[    0.013489] [<c1419988>] (kobject_get) from [<c112aa6c>]
(of_node_get+0x24/0x2c)
[    0.013492]  r4:efca9a44
[    0.013495] [<c112aa48>] (of_node_get) from [<c11298fc>]
(of_fwnode_get+0x44/0x50)
[    0.013499]  r5:efca9a50 r4:00000007
[    0.013502] [<c11298b8>] (of_fwnode_get) from [<c0cbbdc8>]
(fwnode_get_nth_parent+0x3c/0x6c)
[    0.013507] [<c0cbbd8c>] (fwnode_get_nth_parent) from [<c1428624>]
(fwnode_full_name_string+0x3c/0xa8)
[    0.013510]  r7:c2a35c56 r6:c1c54319 r5:c189c7d0 r4:00000007
[    0.013514] [<c14285e8>] (fwnode_full_name_string) from
[<c142a04c>] (device_node_string+0x48c/0x4ec)
[    0.013518]  r10:ffffffff r9:c1bde730 r8:efca9a44 r7:c2a35c56
r6:c1c54319 r5:c2a36014
[    0.013521]  r4:c2208708
[    0.013525] [<c1429bc4>] (device_node_string) from [<c142bc1c>]
(pointer+0x43c/0x4e0)
[    0.013529]  r10:c2a36014 r9:c2201d3c r8:c2201e90 r7:00000002
r6:00000000 r5:c2a36014
[    0.013532]  r4:c2a35c56
[    0.013535] [<c142b7e0>] (pointer) from [<c142be88>] (vsnprintf+0x1c8/0x414)
[    0.013539]  r7:00000002 r6:c1d5b4e8 r5:c1d5b4e6 r4:c2a35c56
[    0.013542] [<c142bcc0>] (vsnprintf) from [<c142c0e8>] (vscnprintf+0x14/0x2c)
[    0.013546]  r10:00000000 r9:00000000 r8:ffffffff r7:c2a352e8
r6:00000028 r5:600000d3
[    0.013549]  r4:000003e0
[    0.013553] [<c142c0d4>] (vscnprintf) from [<c04db300>]
(vprintk_store+0x44/0x220)
[    0.013556]  r5:600000d3 r4:c2a352e8
[    0.013560] [<c04db2bc>] (vprintk_store) from [<c04db8a0>]
(vprintk_emit+0xa0/0x2fc)
[    0.013564]  r10:00000001 r9:ffffffff r8:00000000 r7:00000000
r6:00000028 r5:600000d3
[    0.013567]  r4:c2a352e8
[    0.013571] [<c04db800>] (vprintk_emit) from [<c04dbb2c>]
(vprintk_default+0x30/0x38)
[    0.013575]  r10:efca9a44 r9:00000001 r8:00000000 r7:ffffe000
r6:c2201e8c r5:c1d5b4c4
[    0.013578]  r4:c21aa590
[    0.013582] [<c04dbafc>] (vprintk_default) from [<c04dc9d4>]
(vprintk_func+0xe0/0x168)
[    0.013585] [<c04dc8f4>] (vprintk_func) from [<c04dc1ec>] (printk+0x40/0x5c)
[    0.013589]  r7:00000000 r6:c23d2350 r5:efca9a44 r4:c2208708
[    0.013592] [<c04dc1ac>] (printk) from [<c112b7c8>]
(of_node_release+0xb0/0xcc)
[    0.013596]  r3:00000008 r2:00000000 r1:efca9a44 r0:c1d5b4c4
[    0.013599]  r4:efca9a70
[    0.013602] [<c112b718>] (of_node_release) from [<c1419c28>]
(kobject_put+0x11c/0x23c)
[    0.013606]  r5:c2422cb8 r4:efca9a70
[    0.013609] [<c1419b0c>] (kobject_put) from [<c112aa98>]
(of_node_put+0x24/0x28)
[    0.013613]  r7:e98f7980 r6:c2201ef4 r5:00000000 r4:e98f7940
[    0.013616] [<c112aa74>] (of_node_put) from [<c20474a0>]
(of_clk_init+0x1a4/0x248)
[    0.013620] [<c20472fc>] (of_clk_init) from [<c20140dc>]
(omap_clk_init+0x4c/0x68)
[    0.013624]  r10:efc8b8c0 r9:c2433054 r8:00000000 r7:c2208700
r6:00000066 r5:c20dab64
[    0.013627]  r4:c2434500
[    0.013631] [<c2014090>] (omap_clk_init) from [<c2014afc>]
(omap4_sync32k_timer_init+0x18/0x3c)
[    0.013634]  r5:c20dab64 r4:c2433000
[    0.013638] [<c2014ae4>] (omap4_sync32k_timer_init) from
[<c2014de8>] (omap5_realtime_timer_init+0x1c/0x258)
[    0.013642] [<c2014dcc>] (omap5_realtime_timer_init) from
[<c2005954>] (time_init+0x30/0x44)
[    0.013645]  r9:c2433054 r8:00000000 r7:c2208700 r6:00000066
r5:c20dab64 r4:c2433000
[    0.013649] [<c2005924>] (time_init) from [<c20012dc>]
(start_kernel+0x590/0x720)
[    0.013652] [<c2000d4c>] (start_kernel) from [<00000000>] (0x0)
[    0.013656]  r10:30c5387d r9:412fc0f2 r8:8ffdc000 r7:00000000
r6:30c0387d r5:00000000
[    0.013659]  r4:c2000330
[    0.013662] irq event stamp: 0
[    0.013665] hardirqs last  enabled at (0): [<00000000>] 0x0
[    0.013669] hardirqs last disabled at (0): [<00000000>] 0x0
[    0.013672] softirqs last  enabled at (0): [<00000000>] 0x0
[    0.013676] softirqs last disabled at (0): [<00000000>] 0x0
[    0.013679] ---[ end trace ec9a61ce578d03f8 ]---
[    0.013683] ------------[ cut here ]------------a

full test log link,
https://lkft.validation.linaro.org/scheduler/job/1158386#L3711


-- 
Linaro LKFT
https://lkft.linaro.org
