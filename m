Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71A1535AB
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBEQzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:55:50 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:44727 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBEQzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 11:55:50 -0500
Received: by mail-pl1-f201.google.com with SMTP id h8so1457064plr.11
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 08:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CKtfyNcSe6+GPZnKB2iG54pxA9v/TR8DxRN2eUzk3Y4=;
        b=PBVUh331aLszmxoN23gziaCS60r6xcc2T0l+xO2R/AbgbxoZLkbU8pdmhaWZXkoneF
         QGLkrDzv84Hw1EiiOIk5+crldeQU4D+lKRKJ5vjmYDS6aw+70mqw4Qb97dO4Qp/d0I3w
         rM+GFhCFX+KucMWprJCOnwQvUIg6O+Cv1At5sRja0VaspOZgDgwpCmKI0/wXVfTnA/ec
         bx2CZabcQ1A5NEkpB9ZS0Al2WnthkHywS8aUhTBTablazDca3T3LQE2dGZuz0ZYH5nL4
         gIMKhyNlmH6acpQIKaa4Lbai/OYEzG0GkIup/+bpUyFcKUB5Hz1MIc7natpPaH+tbLKg
         bbkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CKtfyNcSe6+GPZnKB2iG54pxA9v/TR8DxRN2eUzk3Y4=;
        b=XSzedW7sNR9XjhPDG9zuUMZPcp1Wp0h80HWgGu3mIpA5E7yDzHlSU54Y2ghhxiWrI1
         2at7+AVcCiHnodr/d8cdBOW9E6wKWwcUCRBI/HMHbkWUdQj1i1XSs1FbudvZTwgZ0jwG
         vHsgoTMApLdZsQWGsw2C8+dXoYgXACagNiq4PGxZyTpzRD8H1kIsho1nuxlIZQu9ArdJ
         nAduNOUQ/tcxphGJwlkA80HYtGZai45Mu/mqWTwlso+cPql38ZHQ88h6EdND9SFin4sl
         7bEIeSb6kVpHDLOPlvyYrtsyvXsu/YmfTMOVwklUAP9oSBmzvbcEbiFKGmvZ4e4+979g
         CUYQ==
X-Gm-Message-State: APjAAAXJzjnFkqiKTrLS6SUV2LOZ0FH8rEXpmWHJw8MvgBPeYQUbODbi
        T+2XuFv60eR5df6Q9MCvt4bMUbOrhnOf8A==
X-Google-Smtp-Source: APXvYqyk/OMjHOfD/DzjhDD+ao5H7mb7OYXtA2TFWcnGbNcsSZjf+6F9wOOa1+r4HcH0HBA+O6ishJfgAYAFVw==
X-Received: by 2002:a63:520a:: with SMTP id g10mr34572843pgb.298.1580921747800;
 Wed, 05 Feb 2020 08:55:47 -0800 (PST)
Date:   Wed,  5 Feb 2020 08:55:44 -0800
Message-Id: <20200205165544.242623-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] ipv6/addrconf: fix potential NULL deref in inet6_set_link_af()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__in6_dev_get(dev) called from inet6_set_link_af() can return NULL.

The needed check has been recently removed, let's add it back.

IPv6: ADDRCONF(NETDEV_CHANGE): lo: link becomes ready
general protection fault, probably for non-canonical address 0xdffffc0000000056: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000002b0-0x00000000000002b7]
CPU: 0 PID: 9698 Comm: syz-executor712 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:inet6_set_link_af+0x66e/0xae0 net/ipv6/addrconf.c:5733
Code: 38 d0 7f 08 84 c0 0f 85 20 03 00 00 48 8d bb b0 02 00 00 45 0f b6 64 24 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 1a 03 00 00 44 89 a3 b0 02 00
RSP: 0018:ffffc90005b06d40 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff86df39a6
RDX: 0000000000000056 RSI: ffffffff86df3e74 RDI: 00000000000002b0
RBP: ffffc90005b06e70 R08: ffff8880a2ac0380 R09: ffffc90005b06db0
R10: fffff52000b60dbe R11: ffffc90005b06df7 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880a1fcc424 R15: dffffc0000000000
FS:  0000000000c46880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f0494ca0d0 CR3: 000000009e4ac000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_setlink+0x2a9f/0x3720 net/core/rtnetlink.c:2754
 rtnl_group_changelink net/core/rtnetlink.c:3103 [inline]
 __rtnl_newlink+0xdd1/0x1790 net/core/rtnetlink.c:3257
 rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5438
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5456
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402e9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffd62fbcf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402e9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000008 R09: 00000000004002c8
R10: 0000000000000005 R11: 0000000000000246 R12: 0000000000401b70
R13: 0000000000401c00 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace cfa7664b8fdcdff3 ]---
RIP: 0010:inet6_set_link_af+0x66e/0xae0 net/ipv6/addrconf.c:5733
Code: 38 d0 7f 08 84 c0 0f 85 20 03 00 00 48 8d bb b0 02 00 00 45 0f b6 64 24 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 1a 03 00 00 44 89 a3 b0 02 00
RSP: 0018:ffffc90005b06d40 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff86df39a6
RDX: 0000000000000056 RSI: ffffffff86df3e74 RDI: 00000000000002b0
RBP: ffffc90005b06e70 R08: ffff8880a2ac0380 R09: ffffc90005b06db0
R10: fffff52000b60dbe R11: ffffc90005b06df7 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880a1fcc424 R15: dffffc0000000000
FS:  0000000000c46880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000004 CR3: 000000009e4ac000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 7dc2bccab0ee ("Validate required parameters in inet6_validate_link_af")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Bisected-and-reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 net/ipv6/addrconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 39d861d0037719ecb02a3341b923d412b5cdc0c1..cb493e15959c4d1bb68cf30f4099a8daa785bb84 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5718,6 +5718,9 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
 	struct nlattr *tb[IFLA_INET6_MAX + 1];
 	int err;
 
+	if (!idev)
+		return -EAFNOSUPPORT;
+
 	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
 		BUG();
 
-- 
2.25.0.341.g760bfbb309-goog

