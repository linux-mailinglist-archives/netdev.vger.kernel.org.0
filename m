Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2E1444BE
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgAUTCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:02:50 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:37666 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgAUTCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:02:49 -0500
Received: by mail-pj1-f73.google.com with SMTP id dw15so2671351pjb.2
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1K9YpnOJqnSoX+G3kqAwOh7LunONzRnToZ4ZsIr8ack=;
        b=nZFGFlDBCepH30YMVX7ix92v64crCKow88/HdRokgcr2idQiYFlIJamIb82mEGl0Wq
         kIGL1kVDvcmnYPGZ3DqE4XYSGZ9FHUUEmKPYmkONDwQDzUseSGSIkf6th/DR052G4N1I
         6MesisDQDIG/YQRqLrxwSKB5mTKoGuUYIbvDw4vhzsqF5+FUphB12fGM2LWzhxiAupCU
         IMyhxSubyTNct4DI5+DSYUATl8Acr+ExIknHMpZymK6KTCDs0v15kACo17tODgtDtNwN
         VHdvaHfAjY1LvrgNH4KKWyU3zsnIzW+yr5geD46YZdmyITFznmZOK1XucBwehWPvAekX
         4rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1K9YpnOJqnSoX+G3kqAwOh7LunONzRnToZ4ZsIr8ack=;
        b=ROtukGF9AkvAK0IrPwT2gOe20Lezmh53blqU/qUzv9GAJYNaDZizXctQI/vrXIZsl3
         2CLtX7vTmIsFqa3/bGj0TMop3i7G96sGhuTaoJTiNy/BxSDoZy0K76HUZbgvsEOQemyH
         2Gp/WKYfzQ252bjTMvWw+RQ0NwZUhqTyDxLQFmK6GJrhg+kfY8P2DGOJjniCiDRGzEWV
         cqDy80B9xcQ4O8FnhYzcd4Oz9A0eUyBQOrJavH70f4OcVje1Q0epz0g/LeLiUrTmXrDO
         V6I9ccwWY4dlLwIPcfLr6xSFaCT3BxIFZqSFJHWdmuW4acv86lpFDskTpwWZdXktgBNr
         67kQ==
X-Gm-Message-State: APjAAAWrOB5b6ApBTqKcdloV22G1FDc9nt6zUArPPxug12o0vsvlx6ZB
        6Gtt772Y+vn/002xwXdg0ceY9iVy83rq1A==
X-Google-Smtp-Source: APXvYqw0Kf9Sa4AREHgHlj0BsTQrtmWlEt9yG9c0QEkGC5ZqFXYPq5wL1IQRSG5dBxhdNAtUbPR/XKgoo+krPA==
X-Received: by 2002:a63:eb15:: with SMTP id t21mr7193756pgh.365.1579633368092;
 Tue, 21 Jan 2020 11:02:48 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:02:20 -0800
Message-Id: <20200121190220.176759-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] net_sched: use validated TCA_KIND attribute in tc_new_tfilter()
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

sysbot found another issue in tc_new_tfilter().
We probably should use @name which contains the sanitized
version of TCA_KIND.

BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:608 [inline]
BUG: KMSAN: uninit-value in string+0x522/0x690 lib/vsprintf.c:689
CPU: 1 PID: 10753 Comm: syz-executor.1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 string_nocheck lib/vsprintf.c:608 [inline]
 string+0x522/0x690 lib/vsprintf.c:689
 vsnprintf+0x207d/0x31b0 lib/vsprintf.c:2574
 __request_module+0x2ad/0x11c0 kernel/kmod.c:143
 tcf_proto_lookup_ops+0x241/0x720 net/sched/cls_api.c:139
 tcf_proto_create net/sched/cls_api.c:262 [inline]
 tc_new_tfilter+0x2a4e/0x5010 net/sched/cls_api.c:2058
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
RSP: 002b:00007f88b3948c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f88b39496d4 RCX: 000000000045b349
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000099f R14: 00000000004cb163 R15: 000000000075bfd4

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

Fixes: 6f96c3c6904c ("net_sched: fix backward compatibility for TCA_KIND")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
---
 net/sched/cls_api.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 76e0d122616aec71f56ded2b10f696dc1a87c105..c2cdd0fc2e70990a8f1e871238fd32246dae0ed2 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2055,9 +2055,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 							       &chain_info));
 
 		mutex_unlock(&chain->filter_chain_lock);
-		tp_new = tcf_proto_create(nla_data(tca[TCA_KIND]),
-					  protocol, prio, chain, rtnl_held,
-					  extack);
+		tp_new = tcf_proto_create(name, protocol, prio, chain,
+					  rtnl_held, extack);
 		if (IS_ERR(tp_new)) {
 			err = PTR_ERR(tp_new);
 			goto errout_tp;
-- 
2.25.0.341.g760bfbb309-goog

