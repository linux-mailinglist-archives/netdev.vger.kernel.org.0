Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0B2220476
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 07:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgGOFpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 01:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgGOFpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 01:45:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65044C061755;
        Tue, 14 Jul 2020 22:45:13 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t18so972519ilh.2;
        Tue, 14 Jul 2020 22:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JhRZT9i1v7GcuLm6ORXS3TFTt48PH6OqHbkbULMIMhE=;
        b=DDi4dM3MTBZWg5lQ0l1BAgKMQWlhelIBmL8Kv18f5ui4wVhzSYdfsb/0Oi1pDYOrwA
         Z14/bJpZRuWX8afZKsabJtfVtD3gL8gzL+NFpAbsqam5X2Pg+yKnO/uYVUspe95k/Mhs
         4Ir2oUOtnKi4+uKHOfYrEEQ5RrbQ/9JHZlyaS65gecDAqeE+f6TI8/e2AWTMOYSnPlG7
         wuFnoVDwZSa/ntYmcrli5Wnlh1svthhxMCoFHCkcQDg6MfoIusoqbSGuPQRTfzrlSKAg
         r8mJUtyHsOei1aCxVEQFKaAISA0Z94DzKq2OGp1dqjAF2ZLv42czTbfgzoh0ZrsNfdxi
         wz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JhRZT9i1v7GcuLm6ORXS3TFTt48PH6OqHbkbULMIMhE=;
        b=behEU6CXZnCIqzmuP/NmRIZjTH/m5FEgqF5vl3MTxJ/LkOEgbne4cgtHs927Gs1DwD
         rybRQK/FL0p+i5VKLF1ffeTu95lIu+eHgAzbPmpzQBvj+qYhYw2pdClAE2L3WfNnSH75
         tMW3bPEK7zl34/ALdOXKgUAuKYD5huh8kwlx5M4F0loiblMlpKYOy+gSjdzdX07I9/62
         Dl9mLjNYv+QaJzOOw/xTtf2eeElNBOy1e8UaxWgq9pLyj7LmL8my4y3uz3GpsZgX+Ypp
         +RUkJYv5R7lIBk8WCUNNZ9cR98hBmEKWzg0kl2h47X1XSYNgPPyb6s+EiHQ85uLe8Rbp
         tjww==
X-Gm-Message-State: AOAM531gAyXliQwlKEHCsIuOX+sdG4roy8DZgkd9vZ5g5Bc7lZH7j+eh
        6zyJ0kLqM1B1ZyCThyNz9I2vnmuOiZphuigKY/Y=
X-Google-Smtp-Source: ABdhPJwbZMNVuswFRSky8i6X0mphBIbKGgbHA4lUZxGuiHM3oqApfKubXm9Xg98rz1c8w2EIFzibzqwOkSZbnMN3fnU=
X-Received: by 2002:a05:6e02:147:: with SMTP id j7mr8400611ilr.22.1594791912788;
 Tue, 14 Jul 2020 22:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200715014930.323472-1-chenweilong@huawei.com>
In-Reply-To: <20200715014930.323472-1-chenweilong@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 14 Jul 2020 22:45:01 -0700
Message-ID: <CAM_iQpUgkVnYh=ETvbqEiXSD8kS22Xc10JA6HU5W9nXNMzaJJg@mail.gmail.com>
Subject: Re: [PATCH v4 net] rtnetlink: Fix memory(net_device) leak when
 ->newlink fails
To:     Weilong Chen <chenweilong@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 6:27 PM Weilong Chen <chenweilong@huawei.com> wrote:
>
> When vlan_newlink call register_vlan_dev fails, it might return error
> with dev->reg_state = NETREG_UNREGISTERED. The rtnl_newlink should
> free the memory. But currently rtnl_newlink only free the memory which
> state is NETREG_UNINITIALIZED.
>
> BUG: memory leak
> unreferenced object 0xffff8881051de000 (size 4096):
>   comm "syz-executor139", pid 560, jiffies 4294745346 (age 32.445s)
>   hex dump (first 32 bytes):
>     76 6c 61 6e 32 00 00 00 00 00 00 00 00 00 00 00  vlan2...........
>     00 45 28 03 81 88 ff ff 00 00 00 00 00 00 00 00  .E(.............
>   backtrace:
>     [<0000000047527e31>] kmalloc_node include/linux/slab.h:578 [inline]
>     [<0000000047527e31>] kvmalloc_node+0x33/0xd0 mm/util.c:574
>     [<000000002b59e3bc>] kvmalloc include/linux/mm.h:753 [inline]
>     [<000000002b59e3bc>] kvzalloc include/linux/mm.h:761 [inline]
>     [<000000002b59e3bc>] alloc_netdev_mqs+0x83/0xd90 net/core/dev.c:9929
>     [<000000006076752a>] rtnl_create_link+0x2c0/0xa20 net/core/rtnetlink.c:3067
>     [<00000000572b3be5>] __rtnl_newlink+0xc9c/0x1330 net/core/rtnetlink.c:3329
>     [<00000000e84ea553>] rtnl_newlink+0x66/0x90 net/core/rtnetlink.c:3397
>     [<0000000052c7c0a9>] rtnetlink_rcv_msg+0x540/0x990 net/core/rtnetlink.c:5460
>     [<000000004b5cb379>] netlink_rcv_skb+0x12b/0x3a0 net/netlink/af_netlink.c:2469
>     [<00000000c71c20d3>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>     [<00000000c71c20d3>] netlink_unicast+0x4c6/0x690 net/netlink/af_netlink.c:1329
>     [<00000000cca72fa9>] netlink_sendmsg+0x735/0xcc0 net/netlink/af_netlink.c:1918
>     [<000000009221ebf7>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<000000009221ebf7>] sock_sendmsg+0x109/0x140 net/socket.c:672
>     [<000000001c30ffe4>] ____sys_sendmsg+0x5f5/0x780 net/socket.c:2352
>     [<00000000b71ca6f3>] ___sys_sendmsg+0x11d/0x1a0 net/socket.c:2406
>     [<0000000007297384>] __sys_sendmsg+0xeb/0x1b0 net/socket.c:2439
>     [<000000000eb29b11>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
>     [<000000006839b4d0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Fixes: e51fb152318ee6 ("rtnetlink: fix a memory leak when ->newlink fails")

This bug is apparently not introduced by my commit above.

It should be commit cb626bf566eb4433318d35681286c494f0,
right? That commit introduced NETREG_UNREGISTERED on the path.
