Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE11DE8F3
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfJUKCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:02:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727649AbfJUKCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:02:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571652152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zZyfpDlGwYZWv34frnqE5N2asU1OepDQnfe+9tzSxvw=;
        b=HVd8vo8vkrjxzcy02kfXpIkwtnuGGVYAdBhxyOe+vJM2zOkO6EnpN6jSECWYXxX4pzLAvj
        Sg9yf7icluy1NrmkLT0dwLY+9I4kIbVgccum7XnzULGtsPL+hYzaffGjlTnkzbP8zMVN4m
        8PS8M4rLCt9dR5YR4wSibQykaQ/Gw8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-m2NHc1JqOeWmleyT5n6MZg-1; Mon, 21 Oct 2019 06:02:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED9901800D79;
        Mon, 21 Oct 2019 10:02:27 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-54.ams2.redhat.com [10.36.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D243160606;
        Mon, 21 Oct 2019 10:02:20 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Hillf Danton <hdanton@sina.com>, Taehee Yoo <ap420073@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH net] net: openvswitch: free vport unless register_netdevice() succeeds
Date:   Mon, 21 Oct 2019 12:01:57 +0200
Message-Id: <3caa233b136b5104c817a52a5fdc02691e530528.1571651489.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: m2NHc1JqOeWmleyT5n6MZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

syzbot found the following crash on:

HEAD commit:    1e78030e Merge tag 'mmc-v5.3-rc1' of git://git.kernel.org/.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D148d3d1a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D30cef20daf3e997=
7
dashboard link: https://syzkaller.appspot.com/bug?extid=3D13210896153522fe1=
ee5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D136aa8c460000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D109ba792600000

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: memory leak
unreferenced object 0xffff8881207e4100 (size 128):
   comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
   hex dump (first 32 bytes):
     00 70 16 18 81 88 ff ff 80 af 8c 22 81 88 ff ff  .p........."....
     00 b6 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  ..#.............
   backtrace:
     [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.=
h:43 [inline]
     [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.=
c:130
     [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/v=
port-internal_dev.c:164
     [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c=
:199
     [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:19=
4
     [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datap=
ath.c:1614
     [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/gene=
tlink.c:629
     [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:65=
4
     [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlin=
k.c:2477
     [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
     [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:=
1302 [inline]
     [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netli=
nk.c:1328
     [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netli=
nk.c:1917
     [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
     [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
     [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
     [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
     [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
     [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
     [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363

BUG: memory leak
unreferenced object 0xffff88811723b600 (size 64):
   comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
   hex dump (first 32 bytes):
     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 02 00 00 00 05 35 82 c1  .............5..
   backtrace:
     [<00000000352f46d8>] kmemleak_alloc_recursive  include/linux/kmemleak.=
h:43 [inline]
     [<00000000352f46d8>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000352f46d8>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000352f46d8>] __do_kmalloc mm/slab.c:3653 [inline]
     [<00000000352f46d8>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<000000008e48f3d1>] kmalloc include/linux/slab.h:557 [inline]
     [<000000008e48f3d1>] ovs_vport_set_upcall_portids+0x54/0xd0  net/openv=
switch/vport.c:343
     [<00000000541e4f4a>] ovs_vport_alloc+0x7f/0xf0  net/openvswitch/vport.=
c:139
     [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/v=
port-internal_dev.c:164
     [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c=
:199
     [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:19=
4
     [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datap=
ath.c:1614
     [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/gene=
tlink.c:629
     [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:65=
4
     [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlin=
k.c:2477
     [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
     [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:=
1302 [inline]
     [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netli=
nk.c:1328
     [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netli=
nk.c:1917
     [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
     [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
     [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
     [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356

BUG: memory leak
unreferenced object 0xffff8881228ca500 (size 128):
   comm "syz-executor032", pid 7015, jiffies 4294944622 (age 7.880s)
   hex dump (first 32 bytes):
     00 f0 27 18 81 88 ff ff 80 ac 8c 22 81 88 ff ff  ..'........"....
     40 b7 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  @.#.............
   backtrace:
     [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.=
h:43 [inline]
     [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.=
c:130
     [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/v=
port-internal_dev.c:164
     [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c=
:199
     [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:19=
4
     [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datap=
ath.c:1614
     [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/gene=
tlink.c:629
     [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:65=
4
     [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlin=
k.c:2477
     [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
     [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:=
1302 [inline]
     [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netli=
nk.c:1328
     [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netli=
nk.c:1917
     [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
     [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
     [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
     [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
     [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
     [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
     [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The function in net core, register_netdevice(), may fail with vport's
destruction callback either invoked or not. After commit 309b66970ee2,
the duty to destroy vport is offloaded from the driver OTOH, which ends
up in the memory leak reported.

It is fixed by releasing vport unless device is registered successfully.
To do that, the callback assignment is defered until device is registered.

Reported-by: syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com
Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netde=
vice() is failed.")
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Greg Rose <gvrose8192@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
[sbrivio: this was sent to dev@openvswitch.org and never made its way
 to netdev -- resending original patch]
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
This patch was sent to dev@openvswitch.org and appeared on netdev
only as Pravin replied to it, giving his Acked-by. I contacted the
original author one month ago requesting to resend this to netdev,
but didn't get an answer, so I'm now resending the original patch.

 net/openvswitch/vport-internal_dev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-i=
nternal_dev.c
index 21c90d3a7ebf..58a7b8312c28 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -137,7 +137,7 @@ static void do_setup(struct net_device *netdev)
 =09netdev->priv_flags |=3D IFF_LIVE_ADDR_CHANGE | IFF_OPENVSWITCH |
 =09=09=09      IFF_NO_QUEUE;
 =09netdev->needs_free_netdev =3D true;
-=09netdev->priv_destructor =3D internal_dev_destructor;
+=09netdev->priv_destructor =3D NULL;
 =09netdev->ethtool_ops =3D &internal_dev_ethtool_ops;
 =09netdev->rtnl_link_ops =3D &internal_dev_link_ops;
=20
@@ -159,7 +159,6 @@ static struct vport *internal_dev_create(const struct v=
port_parms *parms)
 =09struct internal_dev *internal_dev;
 =09struct net_device *dev;
 =09int err;
-=09bool free_vport =3D true;
=20
 =09vport =3D ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
 =09if (IS_ERR(vport)) {
@@ -190,10 +189,9 @@ static struct vport *internal_dev_create(const struct =
vport_parms *parms)
=20
 =09rtnl_lock();
 =09err =3D register_netdevice(vport->dev);
-=09if (err) {
-=09=09free_vport =3D false;
+=09if (err)
 =09=09goto error_unlock;
-=09}
+=09vport->dev->priv_destructor =3D internal_dev_destructor;
=20
 =09dev_set_promiscuity(vport->dev, 1);
 =09rtnl_unlock();
@@ -207,8 +205,7 @@ static struct vport *internal_dev_create(const struct v=
port_parms *parms)
 error_free_netdev:
 =09free_netdev(dev);
 error_free_vport:
-=09if (free_vport)
-=09=09ovs_vport_free(vport);
+=09ovs_vport_free(vport);
 error:
 =09return ERR_PTR(err);
 }
--=20
2.20.1

