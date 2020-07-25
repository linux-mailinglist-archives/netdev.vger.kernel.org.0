Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E257C22D7E1
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 15:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgGYNaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 09:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgGYNai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 09:30:38 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4219C0619D3
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 06:30:37 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k27so6928384pgm.2
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 06:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=EMYbr7n0D6vNEAvJoIbT6zQK/KqnPF7+Z/CU6mJsSu4=;
        b=Nyoyx7KdazlmJ7vCdftVGgpQcCvL2o37mEB/ivslt0Iwvg9BlTPKtcIsTKhsFpxta1
         6L8nu5AG0R6vQjeN+/uG6ODySLPfsfZ5y55Nqjv3DdkjZPMPf8c9Rmb+zFPutAj+Rsf9
         mfAZykjK1ggRsdIgjoOns+pBdtIXVZ5/qnMzMPo/jsxomsFmBqTKYyZ7RU5BBo14IEt8
         mPlQ4Q1Od+U1dEFdPc9ZhtEFjC6s6U1gpU6jSA7ZxyTvr80I1UTsQJ4vAAqC/H+VIEW/
         UA1oeA4BKBrGt1ZWoWFIMT9VdRR1x2recVy42SJ2+TRN3+AuFtAhJi4cwTXy1R3PCxdR
         7rJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=EMYbr7n0D6vNEAvJoIbT6zQK/KqnPF7+Z/CU6mJsSu4=;
        b=DDK6I+rmpxaupWUfDPJzOnih86bGR6ER88HQ2wNpSYDtNV0aor/k8MAd0+8rUTSqUY
         6hSDcAv/O8TiODbFccCkhfu4x9qd8HRwqGtCURhctuJQfSDATKo6N5Gbs5MHF9delXVb
         qa9aRBsJVaYPaNMmCVIY11xP1PvznomlusiyDDFB0BzmkVnNjPBLS30Is6ZOQtGyBbho
         vCMqcXADXhG6uaKIWjsXzTnXWHdLDnDK/aLRQW1vsezT/eZrgyVVD5vFi0ia/Hbhc30r
         NvOAqk0X59octCOSCVhHdkKQaxPK01ob+hQ2+l6CJXTwCoYbw3pbwniqFiBG/Ee1hsL/
         vH8A==
X-Gm-Message-State: AOAM5330WltgMFIA+Fq1vPIkqdkb9DIZFrvNnqydio+3x67z7eMWWeML
        HLsu4LbDQoFPgSSHpXBFyXdXOw==
X-Google-Smtp-Source: ABdhPJxwyCw6ikh29r+br5dnI9YZLKIGU4pH+TgxQL/Sn2xIjIz3PBi5DEkF60Z3AUT5RW7WzlBbtg==
X-Received: by 2002:a63:4542:: with SMTP id u2mr12296871pgk.138.1595683837217;
        Sat, 25 Jul 2020 06:30:37 -0700 (PDT)
Received: from localhost ([2406:7400:73:5836:d1f0:826d:1814:b78e])
        by smtp.gmail.com with ESMTPSA id q4sm9251237pjq.36.2020.07.25.06.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 06:30:36 -0700 (PDT)
Date:   Sat, 25 Jul 2020 19:00:31 +0530
From:   B K Karthik <bkkarthik@pesu.pes.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        skhan@linuxfounation.org
Subject: [PATCH] net: ipv6: fix slab-out-of-bounds Read in
 __xfrm6_tunnel_spi_check
Message-ID: <20200725133031.a5uxkpikopntgu4c@pesu.pes.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7vokk75m5ftkyn3w"
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7vokk75m5ftkyn3w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

use spi_byaddr instead of spi_byspi

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in __xfrm6_tunnel_spi_check+0x316/0x330 net/=
ipv6/xfrm6_tunnel.c:108
Read of size 8 at addr ffff8880a93a5e08 by task syz-executor.1/8482
CPU: 0 PID: 8482 Comm: syz-executor.1 Not tainted 5.8.0-rc5-next-20200716-s=
yzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __xfrm6_tunnel_spi_check+0x316/0x330 net/ipv6/xfrm6_tunnel.c:108
 __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_tunnel.c:131 [inline]
 xfrm6_tunnel_alloc_spi+0x296/0x8a0 net/ipv6/xfrm6_tunnel.c:174
 ipcomp6_tunnel_create net/ipv6/ipcomp6.c:84 [inline]
 ipcomp6_tunnel_attach net/ipv6/ipcomp6.c:124 [inline]
 ipcomp6_init_state net/ipv6/ipcomp6.c:159 [inline]
 ipcomp6_init_state+0x2af/0x700 net/ipv6/ipcomp6.c:139
 __xfrm_init_state+0x9a6/0x14b0 net/xfrm/xfrm_state.c:2498
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2525
 pfkey_msg2xfrm_state net/key/af_key.c:1291 [inline]
 pfkey_add+0x1a10/0x2b70 net/key/af_key.c:1508
 pfkey_process+0x66d/0x7a0 net/key/af_key.c:2834
 pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3673
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmmsg+0x195/0x480 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1d9
Code: Bad RIP value.
RSP: 002b:00007fe3fa739c78 EFLAGS: 00000246
 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000025a40 RCX: 000000000045c1d9
RDX: 0400000000000282 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 000000000078bf48 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007fffec91896f R14: 00007fe3fa73a9c0 R15: 000000000078bf0c
Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x16e/0x2c0 mm/slab.c:3550
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 device_private_init drivers/base/core.c:2763 [inline]
 device_add+0x1008/0x1c40 drivers/base/core.c:2813
 netdev_register_kobject+0x17d/0x3b0 net/core/net-sysfs.c:1888
 register_netdevice+0xd29/0x1540 net/core/dev.c:9523
 register_netdev+0x2d/0x50 net/core/dev.c:9654
 ip6gre_init_net+0x3c4/0x5e0 net/ipv6/ip6_gre.c:1587
 ops_init+0xaf/0x470 net/core/net_namespace.c:151
 __register_pernet_operations net/core/net_namespace.c:1140 [inline]
 register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1217
 register_pernet_device+0x26/0x70 net/core/net_namespace.c:1304
 ip6gre_init+0x1f/0x132 net/ipv6/ip6_gre.c:2327
 do_one_initcall+0x10a/0x7b0 init/main.c:1201
 do_initcall_level init/main.c:1274 [inline]
 do_initcalls init/main.c:1290 [inline]
 do_basic_setup init/main.c:1310 [inline]
 kernel_init_freeable+0x4f4/0x5a3 init/main.c:1507
 kernel_init+0xd/0x1c0 init/main.c:1401
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
The buggy address belongs to the object at ffff8880a93a5c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 8 bytes to the right of
 512-byte region [ffff8880a93a5c00, ffff8880a93a5e00)
The buggy address belongs to the page:
page:0000000064ff38cf refcount:1 mapcount:0 mapping:0000000000000000 index:=
0x0 pfn:0xa93a5
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00028deec8 ffffea00027a5388 ffff8880aa000600
raw: 0000000000000000 ffff8880a93a5000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff8880a93a5d00: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a93a5d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a93a5e00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                      ^
 ffff8880a93a5e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a93a5f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Reported-by: syzbot+7da3fdf292816554b942@syzkaller.appspotmail.com
Signed-off-by: B K Karthik <bkkarthik@pesu.pes.edu>
---
 net/ipv6/xfrm6_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 25b7ebda2fab..cab7693ccfe3 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, =
u32 spi)
 {
 	struct xfrm6_tunnel_net *xfrm6_tn =3D xfrm6_tunnel_pernet(net);
 	struct xfrm6_tunnel_spi *x6spi;
-	int index =3D xfrm6_tunnel_spi_hash_byspi(spi);
+	int index =3D xfrm6_tunnel_spi_hash_byaddr(spi);
=20
 	hlist_for_each_entry(x6spi,
-			     &xfrm6_tn->spi_byspi[index],
+			     &xfrm6_tn->spi_byaddr[index],
 			     list_byspi) {
 		if (x6spi->spi =3D=3D spi)
 			return -1;
--=20
2.20.1


--7vokk75m5ftkyn3w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEIF+jd5Z5uS7xKTfpQZdt+T1HgiEFAl8cM/YACgkQQZdt+T1H
giEupwv+JTzXmBCABHQw0f46S6vnc5BwFopYFHl6anfOlgTdIz6L5//whnw//U51
jhXvvTFMCnGWOusS4qZVs7c1yp8AwgI34a+NNaNjFTmwB1kOyKQmhb94e3MwITYp
GSnmDtKPDemrMWMg7PjcMuD60Q1a+8rMeyPYt5CQHj94nysC21XcQzyGSzHvPCcX
llEd5t5s9nA8Zqkv2esjo+aBDQdDTlwl+jx/p0JpYyiY2SOPF7RKbCAJLokAAHt7
bmADG3MuvkSl/P1Ipxac9IYafbyx24HKOypjhX9Yyok5ejOt6rL13JCUL4ED5ISp
fAwhGo5WPUqIyjC80FM+LaK7m69cru3CN2JavOw2K49LYtEQsMI9cV+oJmYKRWW1
7wtaJgmF2/nWlOPePq04ro+gCtZGmDJlhbLpMkVtKXsqgGnk7Qn6sTJWCZX73PF0
UytvTgWWz6Im+OUz8Br9W4iQWtWqs6F2m+iXXOMDE3fcxy5S1iNv+fh9HYEknL1x
UZZ9juF+
=Kx9e
-----END PGP SIGNATURE-----

--7vokk75m5ftkyn3w--
