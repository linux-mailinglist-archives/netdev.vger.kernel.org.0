Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C4834F386
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhC3VaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbhC3V2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:28:55 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD71C061762;
        Tue, 30 Mar 2021 14:28:55 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x13so17607338wrs.9;
        Tue, 30 Mar 2021 14:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EIJ9USS096I8/QhfJFmu1+NqEl7x7ZUfIIqSiw9+Vg4=;
        b=qgrlefKAkKgrG8q0CFK92NXqzZanYI8GfhHDrmwUQPourZ/5jwtzPGeSOnwft8NZxX
         12RSWyO93KyZp0Mf3WA11Gb3vR3pOpOpZaAmh2u2erc3c4pykcBegdi6BjWN2jmu/nXJ
         pXV8BPFsP0Ev1xwx2GnsQDVQC4tHeCA+ySqWfs2xhtuJqbzfhZJKBSgGNmaKUH4CfzCi
         e29fN8GtnSJIDxJdFfbgbmEmaSlAe9vhMrmknxwWYzPFswjEeK3Lr4otrrOFxI8uuuiY
         THqwF11snW39YKFg1wkDbXJrLo/IBDOIREhd4yn4qKPBE8YePhCKNto2xcKr2MIFXcjr
         VfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EIJ9USS096I8/QhfJFmu1+NqEl7x7ZUfIIqSiw9+Vg4=;
        b=Ud9+O/G1E8ofP80TVR52WXYA25m3im6h3mo8dy57/ZEoF3oMdCVSp2y9K78+Duaktz
         nufV8nQMxrl0Ing3lE59XiVFBVzY9tE4QiM7jT6Cw58bUHGOwtZvqkRsFXiWuS427iWu
         CqcEdnY73S1T1HAjK4vTBWXYb5YIMcmmD7Ctsm2YyGAq2xEK8P48f4ycuOGQ1rGqceqr
         mmuA9Thpwurgqfp12+UUUkViNFwPzqIVAeq9yBFQwijnpLnW+ptwnFvSEw/88FBdsZuj
         Xu6llH+yFLbdt2/UIaD+j6c5mLLeS3rrrBETtOYIVVzVndPlCAp7Vdo/Q091D0Ss7Ffm
         VVnQ==
X-Gm-Message-State: AOAM530akK6iWiYS8ms/y7YIR4OqoFiLc8V8BWJVah+6QDciaCyn1Ne4
        LjU1E5aazBhPx6vIPGmp2DzVhRS48R0=
X-Google-Smtp-Source: ABdhPJyDpvCdJ1rsRZoaENLKzw34EPGcS0yPkxT5dcEaOYOl2bQOeKgMP1jrpCpTREvPfG6aBJ+Qpg==
X-Received: by 2002:a05:6000:221:: with SMTP id l1mr35029wrz.370.1617139733691;
        Tue, 30 Mar 2021 14:28:53 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.251.74])
        by smtp.gmail.com with ESMTPSA id c9sm332381wml.42.2021.03.30.14.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 14:28:53 -0700 (PDT)
Subject: Re: BUG: use-after-free in macvlan_broadcast
To:     Hao Sun <sunhao.th@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CACkBjsb662gQciPNLhfGRRuzBbzTUA0=_UhR2=2tx=rJQXZ=fQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1a456302-319a-5c0a-a819-3d2b8a44dc4b@gmail.com>
Date:   Tue, 30 Mar 2021 23:28:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsb662gQciPNLhfGRRuzBbzTUA0=_UhR2=2tx=rJQXZ=fQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/21 12:11 PM, Hao Sun wrote:
> Hi
> 
> When using Healer(https://github.com/SunHao-0/healer/tree/dev) to fuzz
> the Linux kernel, I found a use-after-free vulnerability in
> macvlan_broadcast.
> Hope the report can help you locate the problem.
> 
> Details:
> commit:   5695e5161 Linux 5.11
> git tree:       upstream
> kernel config and reproducing program can be found in the attachment.
> report:
> ==================================================================
> BUG: KASAN: use-after-free in macvlan_broadcast+0x595/0x6e0
> Read of size 4 at addr ffff88806ae70801 by task syz-executor392/8448
> 
> CPU: 0 PID: 8448 Comm: syz-executor392 Not tainted 5.4.0 #14

Why is 5.4.0  printed if your tree is linux-5.11 ?


You describe something that has been fixed already in linux-5.5


> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  dump_stack+0xf3/0x16a
>  print_address_description.constprop.0.cold+0xd3/0x372
>  __kasan_report.cold+0x75/0x9b
>  kasan_report+0x12/0x20
>  macvlan_broadcast+0x595/0x6e0
>  macvlan_start_xmit+0x40e/0x630
>  dev_direct_xmit+0x3f6/0x5f0
>  packet_sendmsg+0x233b/0x5a60
>  sock_sendmsg+0xd7/0x130
>  __sys_sendto+0x21e/0x330
>  __x64_sys_sendto+0xe1/0x1b0
>  do_syscall_64+0xbf/0x640
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x453d6d
> Code: c3 e8 77 2c 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff89ba8378 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000453d6d
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 0000000000000040 R08: 0000000020000280 R09: 0000000000000014
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 00007fff89ba83e8 R14: 00007fff89ba83f0 R15: 0000000000000000
> 
> Allocated by task 8448:
>  save_stack+0x1b/0x80
>  __kasan_kmalloc.constprop.0+0xc2/0xd0
>  __kmalloc_node_track_caller+0x116/0x410
>  __kmalloc_reserve.isra.0+0x35/0xd0
>  __alloc_skb+0xf3/0x5c0
>  rtmsg_fib+0x16f/0x11a0
>  fib_table_insert+0x66e/0x1560
>  fib_magic+0x406/0x570
>  fib_add_ifaddr+0x39a/0x520
>  fib_netdev_event+0x3d0/0x560
>  notifier_call_chain+0xc0/0x230
>  __dev_notify_flags+0x125/0x2d0
>  dev_change_flags+0x104/0x160
>  do_setlink+0x999/0x32a0
>  __rtnl_newlink+0xac8/0x14c0
>  rtnl_newlink+0x68/0xa0
>  rtnetlink_rcv_msg+0x4a4/0xb70
>  netlink_rcv_skb+0x15e/0x410
>  netlink_unicast+0x4d4/0x690
>  netlink_sendmsg+0x8ae/0xd00
>  sock_sendmsg+0xd7/0x130
>  __sys_sendto+0x21e/0x330
>  __x64_sys_sendto+0xe1/0x1b0
>  do_syscall_64+0xbf/0x640
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 8448:
>  save_stack+0x1b/0x80
>  __kasan_slab_free+0x126/0x170
>  kfree+0xfa/0x460
>  skb_free_head+0x8b/0xa0
>  pskb_expand_head+0x2bd/0xe80
>  netlink_trim+0x203/0x260
>  netlink_broadcast_filtered+0x61/0xbd0
>  nlmsg_notify+0x15b/0x1a0
>  rtmsg_fib+0x2eb/0x11a0
>  fib_table_insert+0x66e/0x1560
>  fib_magic+0x406/0x570
>  fib_add_ifaddr+0x39a/0x520
>  fib_netdev_event+0x3d0/0x560
>  notifier_call_chain+0xc0/0x230
>  __dev_notify_flags+0x125/0x2d0
>  dev_change_flags+0x104/0x160
>  do_setlink+0x999/0x32a0
>  __rtnl_newlink+0xac8/0x14c0
>  rtnl_newlink+0x68/0xa0
>  rtnetlink_rcv_msg+0x4a4/0xb70
>  netlink_rcv_skb+0x15e/0x410
>  netlink_unicast+0x4d4/0x690
>  netlink_sendmsg+0x8ae/0xd00
>  sock_sendmsg+0xd7/0x130
>  __sys_sendto+0x21e/0x330
>  __x64_sys_sendto+0xe1/0x1b0
>  do_syscall_64+0xbf/0x640
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> The buggy address belongs to the object at ffff88806ae70800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 1 bytes inside of
>  1024-byte region [ffff88806ae70800, ffff88806ae70c00)
> The buggy address belongs to the page:
> page:ffffea0001ab9c00 refcount:1 mapcount:0 mapping:ffff88806b802280
> index:0x0 compound_mapcount: 0
> raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88806b802280
> raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88806ae70700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88806ae70780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff88806ae70800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff88806ae70880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88806ae70900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
