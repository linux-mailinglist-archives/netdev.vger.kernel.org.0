Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749461FEADD
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFRFXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgFRFXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 01:23:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C95C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 22:23:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w9so5371266ybt.2
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 22:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=iHRcHsI5tmOPTYIcFbMvq65ROIUbbGna0uzyQnK/lZw=;
        b=LeYuclsXEUuuGV7/OMFKj7PXlcbtG1mdsrFMcIHx654wLQZ83PmRoNd2DniPRKUehz
         1KqKEju29SJuDRDfICOm+kEs3+yZtFiHr1o4T0DcJVz9qvZRDZj5gAqDGI6k0hDez4sv
         YdPLXAe16xsTZpr/Y78PCkIYKQV4UNywvogG1IGIR0iIxa0VxNtGGC6j2Bg3qs1NvOuJ
         4QNCdMs4vo9LZznZwyCMMn7gEpqUGXNW7heRSR6Hey9crrz4suJRn1RusTZC+NGyaWkC
         vzvGX0w2/BHQdRQXgnfkVqCA/pvZLYavgBs3tX8vWYqO+DynxpMq3mEpo1s7xgoI4kSG
         Fxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=iHRcHsI5tmOPTYIcFbMvq65ROIUbbGna0uzyQnK/lZw=;
        b=n/eMuoNE8kM6Z4+MD76Dx2jUcgMGrPDwKeDWT1nThJTF7EmdCZ+ZjeNMkGxLB3+EGy
         84gApR2eyzSss3S+cx5hN17NCix5NsgaysH/hmLFPfAu3sy0RB6jCAWQuz8cltVEEU5h
         mgBmk/88UmxhH+ImywxkIbt7dE07cRrg8H5JcQwgHa5ldjlGe24VYR1BXYV4SN3l3kBf
         O0gWizDlY+Pp+bh1aLk8pcqNICz1KiMQItRV5ASmytyXNRFt3lGxHyFlx+YFxCP1N0i8
         xI0rcRPDu5bQE6Oy1xINyvSka18jZpaxQ70V3BaZZg6MLz3FShW0eu8jrgzud1fQnguI
         gGhw==
X-Gm-Message-State: AOAM533ErC9TVmNh7fheIKJ+QY9O3jntnm2HedvvhEcEGFD9ObdHvJus
        zoyi5IUDdmNOPASiyrtbYoOYZXPvCQmZUQ==
X-Google-Smtp-Source: ABdhPJw7N2NaBDDRjiRGoONm/Uyr/eeohZklDWylT13DXbiMWUwRT8/pdzJWcs7k6Y8WV7qAHsZ3rd2IKtuZqw==
X-Received: by 2002:a25:5186:: with SMTP id f128mr4015169ybb.293.1592457817719;
 Wed, 17 Jun 2020 22:23:37 -0700 (PDT)
Date:   Wed, 17 Jun 2020 22:23:25 -0700
Message-Id: <20200618052325.78441-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net] net: increment xmit_recursion level in dev_direct_xmit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back in commit f60e5990d9c1 ("ipv6: protect skb->sk accesses
from recursive dereference inside the stack") Hannes added code
so that IPv6 stack would not trust skb->sk for typical cases
where packet goes through 'standard' xmit path (__dev_queue_xmit())

Alas af_packet had a dev_direct_xmit() path that was not
dealing yet with xmit_recursion level.

Also change sk_mc_loop() to dump a stack once only.

Without this patch, syzbot was able to trigger :

[1]
[  153.567378] WARNING: CPU: 7 PID: 11273 at net/core/sock.c:721 sk_mc_loop=
+0x51/0x70
[  153.567378] Modules linked in: nfnetlink ip6table_raw ip6table_filter ip=
table_raw iptable_nat nf_nat nf_conntrack nf_defrag_ipv4 nf_defrag_ipv6 ipt=
able_filter macsec macvtap tap macvlan 8021q hsr wireguard libblake2s blake=
2s_x86_64 libblake2s_generic udp_tunnel ip6_udp_tunnel libchacha20poly1305 =
poly1305_x86_64 chacha_x86_64 libchacha curve25519_x86_64 libcurve25519_gen=
eric netdevsim batman_adv dummy team bridge stp llc w1_therm wire i2c_mux_p=
ca954x i2c_mux cdc_acm ehci_pci ehci_hcd mlx4_en mlx4_ib ib_uverbs ib_core =
mlx4_core
[  153.567386] CPU: 7 PID: 11273 Comm: b159172088 Not tainted 5.8.0-smp-DEV=
 #273
[  153.567387] RIP: 0010:sk_mc_loop+0x51/0x70
[  153.567388] Code: 66 83 f8 0a 75 24 0f b6 4f 12 b8 01 00 00 00 31 d2 d3 =
e0 a9 bf ef ff ff 74 07 48 8b 97 f0 02 00 00 0f b6 42 3a 83 e0 01 5d c3 <0f=
> 0b b8 01 00 00 00 5d c3 0f b6 87 18 03 00 00 5d c0 e8 04 83 e0
[  153.567388] RSP: 0018:ffff95c69bb93990 EFLAGS: 00010212
[  153.567388] RAX: 0000000000000011 RBX: ffff95c6e0ee3e00 RCX: 00000000000=
00007
[  153.567389] RDX: ffff95c69ae50000 RSI: ffff95c6c30c3000 RDI: ffff95c6c30=
c3000
[  153.567389] RBP: ffff95c69bb93990 R08: ffff95c69a77f000 R09: 00000000000=
00008
[  153.567389] R10: 0000000000000040 R11: 00003e0e00026128 R12: ffff95c6c30=
c3000
[  153.567390] R13: ffff95c6cc4fd500 R14: ffff95c6f84500c0 R15: ffff95c69aa=
13c00
[  153.567390] FS:  00007fdc3a283700(0000) GS:ffff95c6ff9c0000(0000) knlGS:=
0000000000000000
[  153.567390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  153.567391] CR2: 00007ffee758e890 CR3: 0000001f9ba20003 CR4: 00000000001=
606e0
[  153.567391] Call Trace:
[  153.567391]  ip6_finish_output2+0x34e/0x550
[  153.567391]  __ip6_finish_output+0xe7/0x110
[  153.567391]  ip6_finish_output+0x2d/0xb0
[  153.567392]  ip6_output+0x77/0x120
[  153.567392]  ? __ip6_finish_output+0x110/0x110
[  153.567392]  ip6_local_out+0x3d/0x50
[  153.567392]  ipvlan_queue_xmit+0x56c/0x5e0
[  153.567393]  ? ksize+0x19/0x30
[  153.567393]  ipvlan_start_xmit+0x18/0x50
[  153.567393]  dev_direct_xmit+0xf3/0x1c0
[  153.567393]  packet_direct_xmit+0x69/0xa0
[  153.567394]  packet_sendmsg+0xbf0/0x19b0
[  153.567394]  ? plist_del+0x62/0xb0
[  153.567394]  sock_sendmsg+0x65/0x70
[  153.567394]  sock_write_iter+0x93/0xf0
[  153.567394]  new_sync_write+0x18e/0x1a0
[  153.567395]  __vfs_write+0x29/0x40
[  153.567395]  vfs_write+0xb9/0x1b0
[  153.567395]  ksys_write+0xb1/0xe0
[  153.567395]  __x64_sys_write+0x1a/0x20
[  153.567395]  do_syscall_64+0x43/0x70
[  153.567396]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  153.567396] RIP: 0033:0x453549
[  153.567396] Code: Bad RIP value.
[  153.567396] RSP: 002b:00007fdc3a282cc8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000001
[  153.567397] RAX: ffffffffffffffda RBX: 00000000004d32d0 RCX: 00000000004=
53549
[  153.567397] RDX: 0000000000000020 RSI: 0000000020000300 RDI: 00000000000=
00003
[  153.567398] RBP: 00000000004d32d8 R08: 0000000000000000 R09: 00000000000=
00000
[  153.567398] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004=
d32dc
[  153.567398] R13: 00007ffee742260f R14: 00007fdc3a282dc0 R15: 00007fdc3a2=
83700
[  153.567399] ---[ end trace c1d5ae2b1059ec62 ]---

f60e5990d9c1 ("ipv6: protect skb->sk accesses from recursive dereference in=
side the stack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/dev.c  | 2 ++
 net/core/sock.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388141f6fd7c66c0e8349514a326e5106db2..b16e2d3151ee30e555a89069021=
b197a084bce58 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4192,10 +4192,12 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_=
id)
=20
 	local_bh_disable();
=20
+	dev_xmit_recursion_inc();
 	HARD_TX_LOCK(dev, txq, smp_processor_id());
 	if (!netif_xmit_frozen_or_drv_stopped(txq))
 		ret =3D netdev_start_xmit(skb, dev, txq, false);
 	HARD_TX_UNLOCK(dev, txq);
+	dev_xmit_recursion_dec();
=20
 	local_bh_enable();
=20
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1f0220b1f925ebcfaa847632ec0dbe0b9b..94391da277544e12c8a9c9eb52c=
51b0678b46dc4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -718,7 +718,7 @@ bool sk_mc_loop(struct sock *sk)
 		return inet6_sk(sk)->mc_loop;
 #endif
 	}
-	WARN_ON(1);
+	WARN_ON_ONCE(1);
 	return true;
 }
 EXPORT_SYMBOL(sk_mc_loop);
--=20
2.27.0.290.gba653c62da-goog

