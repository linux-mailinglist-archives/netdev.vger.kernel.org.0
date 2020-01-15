Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A23713C91F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAOQUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:20:44 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:59851 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgAOQUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:20:44 -0500
Received: by mail-pj1-f73.google.com with SMTP id c2so189006pjr.9
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 08:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PWPIZwE10+kg9nNITc8LMhTxjkxmuiuEriuRIGNfO7o=;
        b=Gp4Oqr5StRtMCJycuvYRRlH+3H1hu4P2eOm2aACn4KE2sbbsoSWPc0btlKDK08cnGr
         ipRCcRPax86rum9z/FQYyvMxdn1howVEZStqtC1C+7OcG6bZfCcRc1Yy7nBc8U7S+MWg
         qDng27sYT012/qlMcFgYPI1f+EpSegMUngAg4VRM7YYyFmWuQNoyizfYJStidKR/dSHr
         ZCZfYm9uO+QstW+S9Q0q1MpsZKj9pqpb22YB/iLz3qMYQdu32aQomzdgyKLJr97KP1Jp
         tTnewa1pJaqwDaQxLRmHI9GNZTZO4JBvSJEPmVJgRqsJxzQwFlybOEL/U7PjutB/LM72
         N7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PWPIZwE10+kg9nNITc8LMhTxjkxmuiuEriuRIGNfO7o=;
        b=a4vftgriaal+o7yOko56seUr0cQ3D3bBs2qDtdAzgl44HMZufooO3ocDrBmmRFf5da
         9NuA4E5MA8Unoar1VrsfqHDfIBnayUiQkA4XLZy9fTmIvcsylstgQBEiGFu0nb5P3fAb
         MHDrVTh9reWwp3qPsRDiNjEBVnYJUtBJNspN4PTo3yIZlkZONNvUYQ1HNlJ8vuWIZjQ1
         lEfOv8pQ3/I8MRGiDr9Ukf8h+KJ44gSd4R26pV+gZcbUGW5QbJOQkZZM6qTy3SkXsh0e
         MDXIJRALZ90GNhWaSRCoG3msMCMWhV8X3if5UoOa9kVsoX44FUQj05aEfLDXRcA/q2SH
         1drA==
X-Gm-Message-State: APjAAAWj38S2AUSjFnwWfMYN0fmFT44V6ig59ku3Qg9VgaY911GBZgOm
        alLIYAvmnARlxMxArCo374KMYqdpKdVspg==
X-Google-Smtp-Source: APXvYqwO+WhCUr3py3m7Z8do41pxgMsuzxem0/w9Ojh/rzfTma/j9mlZz8bzAtVPU8/MqL8L4k5ggMDxvUPyag==
X-Received: by 2002:a63:9548:: with SMTP id t8mr32876882pgn.205.1579105243584;
 Wed, 15 Jan 2020 08:20:43 -0800 (PST)
Date:   Wed, 15 Jan 2020 08:20:39 -0800
Message-Id: <20200115162039.113706-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v3 net] net/sched: act_ife: initalize ife->metalist earlier
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
v2,v3: addressed Davide feedbacks.

 net/sched/act_ife.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 5e6379028fc392031f4b84599f666a2c61f071d2..c1fcd85719d6a7fa86e65ebb89e82e0d931b7ea0 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -537,6 +537,9 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	}
 
 	ife = to_ife(*a);
+	if (ret == ACT_P_CREATED)
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

