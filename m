Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CEE8547D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389390AbfHGUbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:31:34 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:37119 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389079AbfHGUbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:31:33 -0400
X-Originating-IP: 209.85.221.174
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id EE93D240002;
        Wed,  7 Aug 2019 20:31:30 +0000 (UTC)
Received: by mail-vk1-f174.google.com with SMTP id m17so18329110vkl.2;
        Wed, 07 Aug 2019 13:31:30 -0700 (PDT)
X-Gm-Message-State: APjAAAVcbxDHPtqhuDkWbLqHoK3XDZu04v1gyrYrlluhTdtNG3BHxSTq
        bj0SpekyJqwIQsqViBmgJ3wq/PU92/YGoLSyMfU=
X-Google-Smtp-Source: APXvYqzLIZg3NZan6L53I92NHzP9wEor6WTCAAsmzD1hD6JhV6I8I489qLTumtcPds3oThIv3GtsqqkyvL/duMokZ5Y=
X-Received: by 2002:a1f:1b0a:: with SMTP id b10mr4289060vkb.19.1565209889563;
 Wed, 07 Aug 2019 13:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190806115932.3044-1-hdanton@sina.com>
In-Reply-To: <20190806115932.3044-1-hdanton@sina.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 7 Aug 2019 13:32:40 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BmuAxdch-nbaTS-1eXN-0goUb5UXtYDr==0KeM9vVsRw@mail.gmail.com>
Message-ID: <CAOrHB_BmuAxdch-nbaTS-1eXN-0goUb5UXtYDr==0KeM9vVsRw@mail.gmail.com>
Subject: Re: memory leak in internal_dev_create
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 5:00 AM Hillf Danton <hdanton@sina.com> wrote:
>
>
> On Tue, 06 Aug 2019 01:58:05 -0700
> > Hello,
> >
> > syzbot found the following crash on:
> >

...
> > BUG: memory leak
> > unreferenced object 0xffff8881228ca500 (size 128):
> >    comm "syz-executor032", pid 7015, jiffies 4294944622 (age 7.880s)
> >    hex dump (first 32 bytes):
> >      00 f0 27 18 81 88 ff ff 80 ac 8c 22 81 88 ff ff  ..'........"....
> >      40 b7 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  @.#.............
> >    backtrace:
> >      [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
> >      [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
> >      [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
> >      [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
> >      [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
> >      [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
> >      [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.c:130
> >      [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
> >      [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
> >      [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
> >      [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
> >      [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
> >      [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
> >      [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
> >      [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
> >      [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
> >      [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
> >      [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
> >      [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
> >      [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
> >      [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
> >      [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
> >      [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
> >      [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
> >      [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363
>
>
> Always free vport manually unless register_netdevice() succeeds.
>
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -137,7 +137,7 @@ static void do_setup(struct net_device *
>         netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_OPENVSWITCH |
>                               IFF_NO_QUEUE;
>         netdev->needs_free_netdev = true;
> -       netdev->priv_destructor = internal_dev_destructor;
> +       netdev->priv_destructor = NULL;
>         netdev->ethtool_ops = &internal_dev_ethtool_ops;
>         netdev->rtnl_link_ops = &internal_dev_link_ops;
>
> @@ -159,7 +159,6 @@ static struct vport *internal_dev_create
>         struct internal_dev *internal_dev;
>         struct net_device *dev;
>         int err;
> -       bool free_vport = true;
>
>         vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
>         if (IS_ERR(vport)) {
> @@ -190,10 +189,9 @@ static struct vport *internal_dev_create
>
>         rtnl_lock();
>         err = register_netdevice(vport->dev);
> -       if (err) {
> -               free_vport = false;
> +       if (err)
>                 goto error_unlock;
> -       }
> +       vport->dev->priv_destructor = internal_dev_destructor;
>
I am not sure why have you moved this assignment out of do_setup().

Otherwise patch looks good to me.

Thanks.
>         dev_set_promiscuity(vport->dev, 1);
>         rtnl_unlock();
> @@ -207,8 +205,7 @@ error_unlock:
>  error_free_netdev:
>         free_netdev(dev);
>  error_free_vport:
> -       if (free_vport)
> -               ovs_vport_free(vport);
> +       ovs_vport_free(vport);
>  error:
>         return ERR_PTR(err);
>  }
> --
>
