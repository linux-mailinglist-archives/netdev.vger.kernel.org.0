Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB2141C03
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 05:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgASEpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 23:45:10 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:40228 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgASEpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 23:45:10 -0500
Received: by mail-pf1-f202.google.com with SMTP id d127so18081395pfa.7
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 20:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=UBEVW2R3vaaEdDuvXYwq7UQgnVKgNKhMQtECBBN2oTk=;
        b=BoZG9ikwg8GZ6CDhPoQFK3UKMuQ6lE5ncPwS6+y4UtGUOrPdbqIdSTaDrua8El6xYO
         Tv3rdZXtSw605WOdJhduVSLJsBAsMM8tVudecMQiLNa4fPZwcoNjyii0hi+j/gR//lwK
         ouNVsLQ1tP78lu8VI+bNo2jRtmHkxnpeN/KmPCYtFu+bqiXPQMrc33GvsGB9pkWAJhOu
         aVK2pKqt7xl3Rql8A0ICdosZRN9DoEnW/sJEDzbZZp/lmzU9hYFCxtgK+Bn5Dz0CCZnI
         f2BlvHluw2gqH4XEspYdlbV6edjNlR3i/EjRoAv7n1GvKO1nSaqJNTctrrRH67tVMXll
         icGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=UBEVW2R3vaaEdDuvXYwq7UQgnVKgNKhMQtECBBN2oTk=;
        b=sZwtw7K9DWKmmFUiQQuFR03g3qb3xPsIa29L6mZpmTFdJCz3WAodZXiJ/a0DJyfpkZ
         kUjDDZ8KnGKFBh2ZkOgWffTbz0g3lOQhs/yBxnhvEtjMtB4OAmXllWJcSB02bTqZ1Jxb
         kxaxNTgJTb4KJeMqGkN9eTgBoh/1ejo1b60iYcm30YbNjOT2MkyrEJQHNfDwd0wErc6c
         ByK72kdKP5+8md0HBmrNrAquNu7pxd8OdWskajRsa7dGQ1Rpr+vSHOMp/tu4g/F8veiS
         5RrCEoor9mk6XzHcZPWmqTqJsXxSxz0KzGEz1lgvwyNwC637a0aN+oLaEkJnGngimEPJ
         3aLw==
X-Gm-Message-State: APjAAAWnNyebSbBITmM2mDqi1hCx8ODDwRfD7CHF/1bMoCDZdD4M1lp1
        qfHEkze5thD6mYQZHgZdWP3k4UNmPPWdVA==
X-Google-Smtp-Source: APXvYqwXDJswG0IxGtvY24yvZrnv3uxO+O+LYbTgQfDUlY+v3YjeiIN3nAKNQYtwfQi7ZR16wTz4jCLl7706cg==
X-Received: by 2002:a63:f403:: with SMTP id g3mr54471438pgi.62.1579409109143;
 Sat, 18 Jan 2020 20:45:09 -0800 (PST)
Date:   Sat, 18 Jan 2020 20:45:06 -0800
Message-Id: <20200119044506.209726-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] net: sched: act_ctinfo: fix memory leak
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        "Kevin 'ldir' Darbyshire-Bryant" <ldir@darbyshire-bryant.me.uk>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a cleanup method to properly free ci->params

BUG: memory leak
unreferenced object 0xffff88811746e2c0 (size 64):
  comm "syz-executor617", pid 7106, jiffies 4294943055 (age 14.250s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    c0 34 60 84 ff ff ff ff 00 00 00 00 00 00 00 00  .4`.............
  backtrace:
    [<0000000015aa236f>] kmemleak_alloc_recursive include/linux/kmemleak.h:=
43 [inline]
    [<0000000015aa236f>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<0000000015aa236f>] slab_alloc mm/slab.c:3320 [inline]
    [<0000000015aa236f>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<000000002c946bd1>] kmalloc include/linux/slab.h:556 [inline]
    [<000000002c946bd1>] kzalloc include/linux/slab.h:670 [inline]
    [<000000002c946bd1>] tcf_ctinfo_init+0x21a/0x530 net/sched/act_ctinfo.c=
:236
    [<0000000086952cca>] tcf_action_init_1+0x400/0x5b0 net/sched/act_api.c:=
944
    [<000000005ab29bf8>] tcf_action_init+0x135/0x1c0 net/sched/act_api.c:10=
00
    [<00000000392f56f9>] tcf_action_add+0x9a/0x200 net/sched/act_api.c:1410
    [<0000000088f3c5dd>] tc_ctl_action+0x14d/0x1bb net/sched/act_api.c:1465
    [<000000006b39d986>] rtnetlink_rcv_msg+0x178/0x4b0 net/core/rtnetlink.c=
:5424
    [<00000000fd6ecace>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.=
c:2477
    [<0000000047493d02>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000bdcf8286>] netlink_unicast_kernel net/netlink/af_netlink.c:13=
02 [inline]
    [<00000000bdcf8286>] netlink_unicast+0x223/0x310 net/netlink/af_netlink=
.c:1328
    [<00000000fc5b92d9>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink=
.c:1917
    [<00000000da84d076>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<00000000da84d076>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<0000000042fb2eee>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<000000008f23f67e>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<00000000d838e4f6>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<00000000289a9cb1>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<00000000289a9cb1>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<00000000289a9cb1>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424

Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 net/sched/act_ctinfo.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 40038c321b4a970dc940714ccda4b39f0d261d6a..19649623493b158b3008c82ce24=
09ae80ffa6dc6 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -360,6 +360,16 @@ static int tcf_ctinfo_search(struct net *net, struct t=
c_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
=20
+static void tcf_ctinfo_cleanup(struct tc_action *a)
+{
+	struct tcf_ctinfo *ci =3D to_ctinfo(a);
+	struct tcf_ctinfo_params *cp;
+
+	cp =3D rcu_dereference_protected(ci->params, 1);
+	if (cp)
+		kfree_rcu(cp, rcu);
+}
+
 static struct tc_action_ops act_ctinfo_ops =3D {
 	.kind	=3D "ctinfo",
 	.id	=3D TCA_ID_CTINFO,
@@ -367,6 +377,7 @@ static struct tc_action_ops act_ctinfo_ops =3D {
 	.act	=3D tcf_ctinfo_act,
 	.dump	=3D tcf_ctinfo_dump,
 	.init	=3D tcf_ctinfo_init,
+	.cleanup=3D tcf_ctinfo_cleanup,
 	.walk	=3D tcf_ctinfo_walker,
 	.lookup	=3D tcf_ctinfo_search,
 	.size	=3D sizeof(struct tcf_ctinfo),
--=20
2.25.0.341.g760bfbb309-goog

