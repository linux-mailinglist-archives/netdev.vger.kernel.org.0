Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5576E115E0D
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 19:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfLGSte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 13:49:34 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:43390 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfLGSte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 13:49:34 -0500
Received: by mail-pf1-f202.google.com with SMTP id x199so6180531pfc.10
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 10:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kCUsKgJsQgVQNMPa5tQnNd1XDP0U7mXeLCPaUbkyDfs=;
        b=rcN4KBNLNT1B3Dpg0Nd2Pnhz6pMlQmNbL3i8TeE/lNu48XzBbjczCG2lzPRRdz1miU
         Zlcz5+zHQXfsyKpY0UCq5INSZ2sUQxO7lBdCfs4FVycZ/uKhe7eUFFYUhx6SCj7b+Lgo
         cJQ5MISgi8Dl/gQCorbT9F/vCckfEjInmBdoU9ltv6gQAnuL8rdSsI28or67fc6shlkY
         khVZwDV5T1yiIvPY+QL1/PEliEFVXBlSNBZDbmlodg43NF9bS6Rvc1a9cuxy1tC7kIJZ
         AS81VGsSBREb0Us5Zx5If3N/kmPYRlXTVa4rvYWsHeLeojTM8Rc9qITHoodHeBxa6CyA
         UURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kCUsKgJsQgVQNMPa5tQnNd1XDP0U7mXeLCPaUbkyDfs=;
        b=SJrwXOsKFCkbowl/w7bVP7mhITmrmgDUZR1rPTZ+SmdqE03pJ3UGniB3t9LKep6/Hm
         ucNFP/4W5AweE6vUcJiUUXdboXEN91i3dGI4Ofop/O2L/pGhoYKnmyFF7LCuo+AoweSZ
         K/nyYN1mlelKuB5Q4PEYGO2Tgwjsi2+3zUoHENwEO19rnt9BbFaXUzI+aw2hQd2dSR+9
         xXmBiL5C77z22PT8y9mELDuQSIbPdEKi9fjL2ALfJuE1BIjdiFXbvVjtSVb5iLBAZWhB
         12Q5x8PSZJDjOL1jZTXUQC0xbqUPy6gB9DuoUqsK/73biwNbJGhhteQNbNP1IOYJ+lvN
         rYIg==
X-Gm-Message-State: APjAAAXF0RNPG8Tho3wIOdwUEFppB7f4a+evKC5GkMVaK698IU70thDE
        /grLXrbWwtA5TgS3SHwn6lbRh4rDd423AQ==
X-Google-Smtp-Source: APXvYqzHWUQFmMYCmMIGDFDR621R1mqYuXm7FfZ7UJualYiJwg4PgBBuPpA5h2bkEEkKY+QgbJ+iY9cZB/kiHw==
X-Received: by 2002:a63:4f54:: with SMTP id p20mr10422532pgl.246.1575744573030;
 Sat, 07 Dec 2019 10:49:33 -0800 (PST)
Date:   Sat,  7 Dec 2019 10:49:30 -0800
Message-Id: <20191207184930.130132-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net] net_sched: validate TCA_KIND attribute in tc_chain_tmplt_add()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new tcf_proto_check_kind() helper to make sure user
provided value is well formed.

BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:606 [inline]
BUG: KMSAN: uninit-value in string+0x4be/0x600 lib/vsprintf.c:668
CPU: 0 PID: 12358 Comm: syz-executor.1 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
 __msan_warning+0x64/0xc0 mm/kmsan/kmsan_instr.c:245
 string_nocheck lib/vsprintf.c:606 [inline]
 string+0x4be/0x600 lib/vsprintf.c:668
 vsnprintf+0x218f/0x3210 lib/vsprintf.c:2510
 __request_module+0x2b1/0x11c0 kernel/kmod.c:143
 tcf_proto_lookup_ops+0x171/0x700 net/sched/cls_api.c:139
 tc_chain_tmplt_add net/sched/cls_api.c:2730 [inline]
 tc_ctl_chain+0x1904/0x38a0 net/sched/cls_api.c:2850
 rtnetlink_rcv_msg+0x115a/0x1580 net/core/rtnetlink.c:5224
 netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5242
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf3e/0x1020 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x110f/0x1330 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
 __sys_sendmsg net/socket.c:2356 [inline]
 __do_sys_sendmsg net/socket.c:2365 [inline]
 __se_sys_sendmsg+0x305/0x460 net/socket.c:2363
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2363
 do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45a649
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0790795c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a649
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000006
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f07907966d4
R13: 00000000004c8db5 R14: 00000000004df630 R15: 00000000ffffffff

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:149 [inline]
 kmsan_internal_poison_shadow+0x5c/0x110 mm/kmsan/kmsan.c:132
 kmsan_slab_alloc+0x97/0x100 mm/kmsan/kmsan_hooks.c:86
 slab_alloc_node mm/slub.c:2773 [inline]
 __kmalloc_node_track_caller+0xe27/0x11a0 mm/slub.c:4381
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x306/0xa10 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
 netlink_sendmsg+0x783/0x1330 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
 __sys_sendmsg net/socket.c:2356 [inline]
 __do_sys_sendmsg net/socket.c:2365 [inline]
 __se_sys_sendmsg+0x305/0x460 net/socket.c:2363
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2363
 do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 6f96c3c6904c ("net_sched: fix backward compatibility for TCA_KIND")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
---
 net/sched/cls_api.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3c335fd9bcb0d1a3303372b975726c221c136dca..9b54079429b9d999596586fc5198bef3cef86287 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2735,13 +2735,19 @@ static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
 			      struct netlink_ext_ack *extack)
 {
 	const struct tcf_proto_ops *ops;
+	char name[IFNAMSIZ];
 	void *tmplt_priv;
 
 	/* If kind is not set, user did not specify template. */
 	if (!tca[TCA_KIND])
 		return 0;
 
-	ops = tcf_proto_lookup_ops(nla_data(tca[TCA_KIND]), true, extack);
+	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
+		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
+		return -EINVAL;
+	}
+
+	ops = tcf_proto_lookup_ops(name, true, extack);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 	if (!ops->tmplt_create || !ops->tmplt_destroy || !ops->tmplt_dump) {
-- 
2.24.0.393.g34dc348eaf-goog

