Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F53013C88D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAOP6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:58:07 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:39404 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgAOP6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:58:07 -0500
Received: by mail-pj1-f74.google.com with SMTP id c67so175700pje.4
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 07:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XWFu0zRU5N4mSb4WDThjtOAIFUiVOcjxXOC405YIlug=;
        b=LKXcbaPu33AY4Fq3yLhv6J8oORXMPw9HQPOZY9c18OlnhzlHBUZr5M7bb/zYL1Vwof
         FuOkfTvUp6eQWht5UiIIQ0QAhNTEZHfwagStRilZmHGlX3olclaJ713002NZN6YoRavd
         75q2iUv7ldx3pkcMQ5wjrNVrKdwzZTOct+03hT3Iqc3CVuRxMDPGf3hRXyoHVSsKKrfT
         pFVU9M3SQZYNargxgsIVq38ne25we2SNoqcGEHlbG/vYh202VQUzt2BP8AqlcoKHhmK/
         9+Ps8wyOOvlKdNVsoHafgwfXkLlxGaJRxkd/5fiItgftxhwZdogIwVgNE0SHayoqLDs4
         dXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XWFu0zRU5N4mSb4WDThjtOAIFUiVOcjxXOC405YIlug=;
        b=gfAhmIOkdORBCXxhFmDPDbpVOaMyUUPaUrKCpcP6E0JKiXGMTWwbuIDMrof0oBhYba
         nCFwrBqf4ldPok8FXOz+jVPXS5LyBulDUHax3ptsMudSzyFmzhRVE+BmgHHXHSnVWJK2
         bYEzEIuYqFFnRPJqm2AbR6vTXqlG7bS1OzZGGDakT4ovs8WT3K34B9zXHmNo/PzbrAct
         MHrDCQYlwRGvqVZw+t2ZGu1DM63Mv55AXpX+IcsAE438NdisdKojud0gGl0yfOf7P7Hb
         2eYKh7CHl8DcnmyFyZeaTfa07Ij3gIsRvozHBcljsnrXDq7ocrij6R0Vf+upEtGko2eu
         8Y3g==
X-Gm-Message-State: APjAAAUMarY3xQtO1EXiBflQx5uL0Xhr806NHhhoNogm67LYTLqCaCE7
        tsVmFCibQLypK+DylW8CqD/fLX7i54xhZA==
X-Google-Smtp-Source: APXvYqyaJN4rog3Ic/g59md1IKZwx4AyGTR7CM/F9DRTGL6PQgPlRf5qC0zWPiuhDOEiMncIj5LwjiTiB0e4jg==
X-Received: by 2002:a63:d442:: with SMTP id i2mr34878455pgj.349.1579103886700;
 Wed, 15 Jan 2020 07:58:06 -0800 (PST)
Date:   Wed, 15 Jan 2020 07:58:03 -0800
Message-Id: <20200115155803.4573-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v2 net] net/sched: act_ife: initalize ife->metalist earlier
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
v2: addressed Davide feedback.
 net/sched/act_ife.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 5e6379028fc392031f4b84599f666a2c61f071d2..ab748701374f65028c79cb789d065305430ea4c5 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -537,6 +537,9 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	}
 
 	ife = to_ife(*a);
+	if (ret = ACT_P_CREATED)
+		INIT_LIST_HEAD(&ife->metalist);
+
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
@@ -566,10 +569,6 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 		p->eth_type = ife_type;
 	}
 
-
-	if (ret == ACT_P_CREATED)
-		INIT_LIST_HEAD(&ife->metalist);
-
 	if (tb[TCA_IFE_METALST]) {
 		err = nla_parse_nested_deprecated(tb2, IFE_META_MAX,
 						  tb[TCA_IFE_METALST], NULL,
-- 
2.25.0.rc1.283.g88dfdc4193-goog

