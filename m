Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557E5FE3F8
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 18:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfKOR37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 12:29:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727543AbfKOR37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 12:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573838998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dGGiRcZVt/xKnRXOsViCHDxtV7FrJ04tzkKnrySTVds=;
        b=M1vU1WkK15GOxudb50I1bNf8ujc+UQ2cSGbFr9r/1+XjlpnUfHUJVm11bQ9pEg3/kp5Kc6
        EjYakMB0hc+cT37WPLmSmLW4ufC8wI4imF13oWcjsxc60JkRgtGa0Y4pjpRp0u3ihl5obH
        A6Jp1Hc41CzzDp3ZB1fJQq5zqb6wWL8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-HhLnWmG0NOesoHHZz7ifZA-1; Fri, 15 Nov 2019 12:29:56 -0500
Received: by mail-wr1-f72.google.com with SMTP id u2so8072339wrm.7
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 09:29:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/daV/dPSVb+iBpjY/djj2B3L1MHbd3IX+jtbxB3uR7g=;
        b=WkkDdL8WpTneWxLQ9jeXyk+qRMczcxO0xQklcDaOSEoSlZcBvcI3n9voy+yVJ3zl2x
         YfOgzguGMHqVo+Tzsx94sb1lFnfXZjjnICuqzMxG736YVB2Dm0Wv4PArfI8ZBE9xq8IB
         xzHeXZLqmER58mXxy5W966rUCQBqABNuRpOXgRQ/O2rAMryM7MJqAr78wgOPjnYX7Nq4
         818cPBmNs1iI/kkZtcxZIoPgOC+rHFlWX9Q2dMpG72Hi5gN4EY3M1Cz2QwfsvBOwPPJ8
         s/p176p/fGMye7efUmeMBqhLVmr3ljRR1gO4f0xxPavYmCc+k972xyGsFif7kodhTsnM
         9uuw==
X-Gm-Message-State: APjAAAW6xVTbd+XqP5OayalR/xWk5ZVEDzTqNcI+h9ssCQ0DSfvLYfa9
        yb/ArlxVg+AlY70F7fDh30CU+7IcwgX1N/NrWQTJLOWQSBtjUY5OwZyqbnBTJy78SnGhM3vScZ6
        bVQmCsUGjCXKTUQV4
X-Received: by 2002:a1c:80c7:: with SMTP id b190mr16355491wmd.3.1573838995078;
        Fri, 15 Nov 2019 09:29:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqznzr7GxS0wBTNdXWJkn0okkwVF5qA2nOCACEINjMqi4uOWmfm97MbYPVtjinM/cYGLmbbZ/Q==
X-Received: by 2002:a1c:80c7:: with SMTP id b190mr16355468wmd.3.1573838994786;
        Fri, 15 Nov 2019 09:29:54 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id n17sm11651902wrp.40.2019.11.15.09.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 09:29:54 -0800 (PST)
Date:   Fri, 15 Nov 2019 18:29:52 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] ipmr: Fix skb headroom in ipmr_get_route().
Message-ID: <01fff31a5e934c1023624a2f00660e06d8d5e9b7.1573838861.git.gnault@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: HhLnWmG0NOesoHHZz7ifZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In route.c, inet_rtm_getroute_build_skb() creates an skb with no
headroom. This skb is then used by inet_rtm_getroute() which may pass
it to rt_fill_info() and, from there, to ipmr_get_route(). The later
might try to reuse this skb by cloning it and prepending an IPv4
header. But since the original skb has no headroom, skb_push() triggers
skb_under_panic():

skbuff: skb_under_panic: text:00000000ca46ad8a len:80 put:20 head:00000000c=
d28494e data:000000009366fd6b tail:0x3c end:0xec0 dev:veth0
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:108!
invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 6 PID: 587 Comm: ip Not tainted 5.4.0-rc6+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 0=
4/01/2014
RIP: 0010:skb_panic+0xbf/0xd0
Code: 41 a2 ff 8b 4b 70 4c 8b 4d d0 48 c7 c7 20 76 f5 8b 44 8b 45 bc 48 8b =
55 c0 48 8b 75 c8 41 54 41 57 41 56 41 55 e8 75 dc 7a ff <0f> 0b 0f 1f 44 0=
0 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
RSP: 0018:ffff888059ddf0b0 EFLAGS: 00010286
RAX: 0000000000000086 RBX: ffff888060a315c0 RCX: ffffffff8abe4822
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88806c9a79cc
RBP: ffff888059ddf118 R08: ffffed100d9361b1 R09: ffffed100d9361b0
R10: ffff88805c68aee3 R11: ffffed100d9361b1 R12: ffff88805d218000
R13: ffff88805c689fec R14: 000000000000003c R15: 0000000000000ec0
FS:  00007f6af184b700(0000) GS:ffff88806c980000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc8204a000 CR3: 0000000057b40006 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 skb_push+0x7e/0x80
 ipmr_get_route+0x459/0x6fa
 rt_fill_info+0x692/0x9f0
 inet_rtm_getroute+0xd26/0xf20
 rtnetlink_rcv_msg+0x45d/0x630
 netlink_rcv_skb+0x1a5/0x220
 rtnetlink_rcv+0x15/0x20
 netlink_unicast+0x305/0x3a0
 netlink_sendmsg+0x575/0x730
 sock_sendmsg+0xb5/0xc0
 ___sys_sendmsg+0x497/0x4f0
 __sys_sendmsg+0xcb/0x150
 __x64_sys_sendmsg+0x48/0x50
 do_syscall_64+0xd2/0xac0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Actually the original skb used to have enough headroom, but the
reserve_skb() call was lost with the introduction of
inet_rtm_getroute_build_skb() by commit 404eb77ea766 ("ipv4: support
sport, dport and ip_proto in RTM_GETROUTE").

We could reserve some headroom again in inet_rtm_getroute_build_skb(),
but this function shouldn't be responsible for handling the special
case of ipmr_get_route(). Let's handle that directly in
ipmr_get_route() by calling skb_realloc_headroom() instead of
skb_clone().

Fixes: 404eb77ea766 ("ipv4: support sport, dport and ip_proto in RTM_GETROU=
TE")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/ipmr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 716d5472c022..58007439cffd 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2289,7 +2289,8 @@ int ipmr_get_route(struct net *net, struct sk_buff *s=
kb,
 =09=09=09rcu_read_unlock();
 =09=09=09return -ENODEV;
 =09=09}
-=09=09skb2 =3D skb_clone(skb, GFP_ATOMIC);
+
+=09=09skb2 =3D skb_realloc_headroom(skb, sizeof(struct iphdr));
 =09=09if (!skb2) {
 =09=09=09read_unlock(&mrt_lock);
 =09=09=09rcu_read_unlock();
--=20
2.21.0

