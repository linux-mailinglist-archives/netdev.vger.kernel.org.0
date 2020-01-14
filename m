Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D83B13B4C7
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 22:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgANVvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 16:51:33 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:54121 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgANVvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 16:51:33 -0500
Received: by mail-pj1-f74.google.com with SMTP id h6so8840809pju.3
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 13:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gnO4zpe9SDRAVhCs1LFD/btCnCoa4XrQf2CEJammFL4=;
        b=OSGDM7dyT+0GXFibySUE/agKCCSWOgAV7cCePC/ZkLo2kjna4UoPMKW+taGEcHUxO4
         A672Lx4JOBzAG4bsngjUnR1cdVbclOFGL4p2e4mp2AyCTSJ4fFoYtEkVwngQrbITtHIE
         M8qdAo1l7e9V9571g/3YKodXIELKy8d8j9CGwNkl1OFdZr71YHLDAOOJNSAiDx1X3k/k
         V1dWqV4hxPlQiRKHWgIdK3VrTSbJxqDbewaAOaiTNbxyINiU/R2d6BWO3WVI/8y2nKAt
         n95/nnFdqboJKONZ3+11hYe18BI0poZAXz+8ivXlK1NBHzT4ILRw0WKqRbW1ZuE3Lhcw
         aRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gnO4zpe9SDRAVhCs1LFD/btCnCoa4XrQf2CEJammFL4=;
        b=CORSZIx+sbj8Y5YLg2FFCW6Yb6KVocfCCBaICtggggmxkoAfX/CAVqWlPvCtrz7U/Q
         xrDji2aMOwFuHEefqE9+n0ZEEAo9KAvuWaSCXu3X8O80ex0qRQ4B8CUWlARUqSU+Sjhg
         R5Q4boEN8ev1r8wEG+9gxgW3goll6cABWWv7HVHGNatulypL2HjVMNFYOU8Gln2XciN3
         J1HbGRHccinODLNvsj4J/gYw2nr1efhjGaXh8Pz6pdFbJ9MQ0OfBob6rAeRV70GmE0Fr
         oytR1dU3c5EUjOY4mEceCGVjrkHt9AIpZPysnt1soz3PeEexi5g6KYlKZ2fdk2/UgaQi
         SO4A==
X-Gm-Message-State: APjAAAUw0JZ1ftoDiI87SLl0F6VxBEjWF8KCPHe8BZQt+mLO33nUM8dq
        9MaS6+t7XUmDE3Dxik5qe4L036y3w3Dnlg==
X-Google-Smtp-Source: APXvYqyEUnIhoxZWZhKIphMNYw+5FZI1qTBzoW9+90SGuOxnEqAgFgwzI/OTZhEvCNTdtKt/rn05i12BViNA5Q==
X-Received: by 2002:a63:2a49:: with SMTP id q70mr28589499pgq.265.1579038692507;
 Tue, 14 Jan 2020 13:51:32 -0800 (PST)
Date:   Tue, 14 Jan 2020 13:51:28 -0800
Message-Id: <20200114215128.87537-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH net] net/sched: act_ife: initalize ife->metalist earlier
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems better to init ife->metalist earlier in tcf_ife_init()
to avoid the following crash :

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10483 Comm: syz-executor216 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:_tcf_ife_cleanup net/sched/act_ife.c:412 [inline]
RIP: 0010:tcf_ife_cleanup+0x6e/0x400 net/sched/act_ife.c:431
Code: 48 c1 ea 03 80 3c 02 00 0f 85 94 03 00 00 49 8b bd f8 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8d 67 e8 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 5c 03 00 00 48 bb 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc90001dc6d00 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff864619c0 RCX: ffffffff815bfa09
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
RBP: ffffc90001dc6d50 R08: 0000000000000004 R09: fffff520003b8d8e
R10: fffff520003b8d8d R11: 0000000000000003 R12: ffffffffffffffe8
R13: ffff8880a79fc000 R14: ffff88809aba0e00 R15: 0000000000000000
FS:  0000000001b51880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563f52cce140 CR3: 0000000093541000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcf_action_cleanup+0x62/0x1b0 net/sched/act_api.c:119
 __tcf_action_put+0xfa/0x130 net/sched/act_api.c:135
 __tcf_idr_release net/sched/act_api.c:165 [inline]
 __tcf_idr_release+0x59/0xf0 net/sched/act_api.c:145
 tcf_idr_release include/net/act_api.h:171 [inline]
 tcf_ife_init+0x97c/0x1870 net/sched/act_ife.c:616
 tcf_action_init_1+0x6b6/0xa40 net/sched/act_api.c:944
 tcf_action_init+0x21a/0x330 net/sched/act_api.c:1000
 tcf_action_add+0xf5/0x3b0 net/sched/act_api.c:1410
 tc_ctl_action+0x390/0x488 net/sched/act_api.c:1465
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 11a94d7fd80f ("net/sched: act_ife: validate the control action inside init()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_ife.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 5e6379028fc392031f4b84599f666a2c61f071d2..cbc1cfd28d43acdb90a2db5338da2fa1848fbf52 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -530,6 +530,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 			return ret;
 		}
 		ret = ACT_P_CREATED;
+		INIT_LIST_HEAD(&ife->metalist);
 	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
 		kfree(p);
@@ -567,9 +568,6 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	}
 
 
-	if (ret == ACT_P_CREATED)
-		INIT_LIST_HEAD(&ife->metalist);
-
 	if (tb[TCA_IFE_METALST]) {
 		err = nla_parse_nested_deprecated(tb2, IFE_META_MAX,
 						  tb[TCA_IFE_METALST], NULL,
-- 
2.25.0.rc1.283.g88dfdc4193-goog

