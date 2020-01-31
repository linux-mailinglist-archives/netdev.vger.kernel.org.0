Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF914F536
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 00:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgAaX1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 18:27:09 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:38757 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgAaX1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 18:27:08 -0500
Received: by mail-pl1-f202.google.com with SMTP id t17so4550430ply.5
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 15:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LoShAQX3tPUZD1jc9JW0rORq+uOX0ffru868fqsgKyA=;
        b=bY10y9PIgdyIBd55WEymxKkjJeZ9CNdJnc2f3wzYKE2V/7SkCQD7lxavhl8eE/F4We
         m+Cjcp6NEcw+Fxe/EZw3iTulLIF5F5mDxPhO77TewyWZtGqwLQzlUjUSdJJRsRFIPXbg
         Js1P2n0UBJGwUD86B4FlCNwqXKgFHHJdbCTpoClPII4k7OkjNnxSZW6znFY1ibOqECmK
         ZweQDmJT3ZNa5N1ve8NNpUq2vrZRsmYfoPQCnNo4qfNWZBY6yDXk85hhRuMKJ8ln//SP
         grT71b6yEyczbXv0WXE+CshOL9pbwFYQthny65iN4/472sNZ+6NNbr8opvLFdi0c5hnp
         xRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LoShAQX3tPUZD1jc9JW0rORq+uOX0ffru868fqsgKyA=;
        b=Rd3MNbycQodN6w+Ae7E18LBjQc1/Nl+L6XhaZXvbulyK2JML1lCxSwZITWAkkPC9+U
         31UjqARId6kAi0ebDqk7EMgsrNaiOQgdRkZDgWCPOe9/qjJ7WP4YSLNqLpj8p2kTiyUp
         U5UfjPlfocfEiLwkmCDQXW5ThRxBAEuTzt9s/ZfIUlGwXiVWbc6YLVRkhWo7Y1Ys6xhx
         /cZbCq+00EYealOmgcDzD66PlW9AYsXgcXJVoY98C/yDxMFA039pLXTlP22MtsJC4DWA
         jd63M1oxGQV8oRs7S0KCbVp0XdzzgjpnHFJlHbigV9/MTU3za8N2YHdKPgKeqNTg+dyE
         l8xw==
X-Gm-Message-State: APjAAAXxwe4OeETfRPA55CdLrPpQiByGhuaq5h08+N7qjfbLGA5wrxDT
        uO5V9SraXt0vJ+aRl3TI6y+EDEz8azaFfg==
X-Google-Smtp-Source: APXvYqwNCv2JrQevDFp/6iA4Ks0jTAAXGS16skdOFugvCM0qxttr40/FhX0zFPQuZ6baCHGvv+0CI6LIe4YTRA==
X-Received: by 2002:a63:bc01:: with SMTP id q1mr13629747pge.442.1580513227683;
 Fri, 31 Jan 2020 15:27:07 -0800 (PST)
Date:   Fri, 31 Jan 2020 15:27:04 -0800
Message-Id: <20200131232704.161648-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] cls_rsvp: fix rsvp_policy
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NLA_BINARY can be confusing, since .len value represents
the max size of the blob.

cls_rsvp really wants user space to provide long enough data
for TCA_RSVP_DST and TCA_RSVP_SRC attributes.

BUG: KMSAN: uninit-value in rsvp_get net/sched/cls_rsvp.h:258 [inline]
BUG: KMSAN: uninit-value in gen_handle net/sched/cls_rsvp.h:402 [inline]
BUG: KMSAN: uninit-value in rsvp_change+0x1ae9/0x4220 net/sched/cls_rsvp.h:572
CPU: 1 PID: 13228 Comm: syz-executor.1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 rsvp_get net/sched/cls_rsvp.h:258 [inline]
 gen_handle net/sched/cls_rsvp.h:402 [inline]
 rsvp_change+0x1ae9/0x4220 net/sched/cls_rsvp.h:572
 tc_new_tfilter+0x31fe/0x5010 net/sched/cls_api.c:2104
 rtnetlink_rcv_msg+0xcb7/0x1570 net/core/rtnetlink.c:5415
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45b349
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f269d43dc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f269d43e6d4 RCX: 000000000045b349
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009c2 R14: 00000000004cb338 R15: 000000000075bfd4

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2774 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4382
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 6fa8c0144b77 ("[NET_SCHED]: Use nla_policy for attribute validation in classifiers")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/cls_rsvp.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index c22624131949746e5f0f25654a5efce7466d9727..d36949d9382c41dda54d12269fe1e8ff9c7e397f 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -463,10 +463,8 @@ static u32 gen_tunnel(struct rsvp_head *data)
 
 static const struct nla_policy rsvp_policy[TCA_RSVP_MAX + 1] = {
 	[TCA_RSVP_CLASSID]	= { .type = NLA_U32 },
-	[TCA_RSVP_DST]		= { .type = NLA_BINARY,
-				    .len = RSVP_DST_LEN * sizeof(u32) },
-	[TCA_RSVP_SRC]		= { .type = NLA_BINARY,
-				    .len = RSVP_DST_LEN * sizeof(u32) },
+	[TCA_RSVP_DST]		= { .len = RSVP_DST_LEN * sizeof(u32) },
+	[TCA_RSVP_SRC]		= { .len = RSVP_DST_LEN * sizeof(u32) },
 	[TCA_RSVP_PINFO]	= { .len = sizeof(struct tc_rsvp_pinfo) },
 };
 
-- 
2.25.0.341.g760bfbb309-goog

