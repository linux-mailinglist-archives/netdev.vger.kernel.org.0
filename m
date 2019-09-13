Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E7EB1BEE
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387995AbfIMLER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42687 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387858AbfIMLER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:04:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 97AEF1DB0;
        Fri, 13 Sep 2019 11:04:16 +0000 (UTC)
Received: from elisabeth (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3532E5C219;
        Fri, 13 Sep 2019 11:04:10 +0000 (UTC)
Date:   Fri, 13 Sep 2019 13:04:05 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Hillf Danton <hdanton@sina.com>, ovs dev <dev@openvswitch.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: openvswitch: free vport unless
 register_netdevice() succeeds
Message-ID: <20190913130405.20580eae@elisabeth>
In-Reply-To: <CAOrHB_AoBJ37+gFNysZr+v1ySXWZP1CHTw0SDR826fWGgFRZ+g@mail.gmail.com>
References: <20190809035515.13968-1-hdanton@sina.com>
        <CAOrHB_AoBJ37+gFNysZr+v1ySXWZP1CHTw0SDR826fWGgFRZ+g@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 13 Sep 2019 11:04:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Aug 2019 00:34:55 -0700
Pravin Shelar <pshelar@ovn.org> wrote:

> On Thu, Aug 8, 2019 at 8:55 PM Hillf Danton <hdanton@sina.com> wrote:
> >
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    1e78030e Merge tag 'mmc-v5.3-rc1' of git://git.kernel.org/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=148d3d1a600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=30cef20daf3e9977
> > dashboard link: https://syzkaller.appspot.com/bug?extid=13210896153522fe1ee5
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136aa8c4600000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109ba792600000
> >
> > =====================================================================
> > BUG: memory leak
> > unreferenced object 0xffff8881207e4100 (size 128):
> >    comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
> >    hex dump (first 32 bytes):
> >      00 70 16 18 81 88 ff ff 80 af 8c 22 81 88 ff ff  .p........."....
> >      00 b6 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  ..#.............
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
> >
> > BUG: memory leak
> > unreferenced object 0xffff88811723b600 (size 64):
> >    comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
> >    hex dump (first 32 bytes):
> >      01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 02 00 00 00 05 35 82 c1  .............5..
> >    backtrace:
> >      [<00000000352f46d8>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
> >      [<00000000352f46d8>] slab_post_alloc_hook mm/slab.h:522 [inline]
> >      [<00000000352f46d8>] slab_alloc mm/slab.c:3319 [inline]
> >      [<00000000352f46d8>] __do_kmalloc mm/slab.c:3653 [inline]
> >      [<00000000352f46d8>] __kmalloc+0x169/0x300 mm/slab.c:3664
> >      [<000000008e48f3d1>] kmalloc include/linux/slab.h:557 [inline]
> >      [<000000008e48f3d1>] ovs_vport_set_upcall_portids+0x54/0xd0  net/openvswitch/vport.c:343
> >      [<00000000541e4f4a>] ovs_vport_alloc+0x7f/0xf0  net/openvswitch/vport.c:139
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
> >
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
> > =====================================================================
> >
> > The function in net core, register_netdevice(), may fail with vport's
> > destruction callback either invoked or not. After commit 309b66970ee2,
> > the duty to destroy vport is offloaded from the driver OTOH, which ends
> > up in the memory leak reported.
> >
> > It is fixed by releasing vport unless device is registered successfully.
> > To do that, the callback assignment is defered until device is registered.
> >
> > Reported-by: syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com
> > Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netdevice() is failed.")
> > Cc: Taehee Yoo <ap420073@gmail.com>
> > Cc: Greg Rose <gvrose8192@gmail.com>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Cc: Ying Xue <ying.xue@windriver.com>
> > Cc: Andrey Konovalov <andreyknvl@google.com>
> > Signed-off-by: Hillf Danton <hdanton@sina.com>
> > ---
> >
> > --- a/net/openvswitch/vport-internal_dev.c
> > +++ b/net/openvswitch/vport-internal_dev.c
> > @@ -137,7 +137,7 @@ static void do_setup(struct net_device *
> >         netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_OPENVSWITCH |
> >                               IFF_NO_QUEUE;
> >         netdev->needs_free_netdev = true;
> > -       netdev->priv_destructor = internal_dev_destructor;
> > +       netdev->priv_destructor = NULL;
> >         netdev->ethtool_ops = &internal_dev_ethtool_ops;
> >         netdev->rtnl_link_ops = &internal_dev_link_ops;
> >
> > @@ -159,7 +159,6 @@ static struct vport *internal_dev_create
> >         struct internal_dev *internal_dev;
> >         struct net_device *dev;
> >         int err;
> > -       bool free_vport = true;
> >
> >         vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
> >         if (IS_ERR(vport)) {
> > @@ -190,10 +189,9 @@ static struct vport *internal_dev_create
> >
> >         rtnl_lock();
> >         err = register_netdevice(vport->dev);
> > -       if (err) {
> > -               free_vport = false;
> > +       if (err)
> >                 goto error_unlock;
> > -       }
> > +       vport->dev->priv_destructor = internal_dev_destructor;
> >  
> 
> Looks good.
> Acked-by: Pravin B Shelar <pshelar@ovn.org>

Pravin, Hillf,

It looks like this patch was never posted to netdev, so it wasn't
picked up by Patchwork -- am I missing something? If not, Hillf, can
you please re-send this patch to the list? Thanks.

-- 
Stefano
