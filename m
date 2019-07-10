Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597016472C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfGJNkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:40:25 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:43929 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfGJNkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:40:25 -0400
Received: by mail-ua1-f73.google.com with SMTP id z42so363499uac.10
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 06:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hiJ8datrPrACNhvXckFlv/XrEYflYRGsSb7qn5RmtHk=;
        b=ifax73568iijfUWptwz4gN8xWwWqT3Qt4agDT8xUOXt1nLDKb7aJTKb7tCGHLhQik/
         CpAcQqujmXw4CPPsSie9YpmZNtZfB0GM/JSVvx1qTFQaaK1MwNkQuWBYLtTcrOiJVNA1
         IXUTSvBgOGA0THSQJGOvuOzZY6D3uh13jGw+7OuuzKylNV1Ve5LwuGzY12HmQLbWOq4k
         cfWrMWvzOutQEzlSHRi+5GjkBGkiTQHz/VHXHhDLc8zZsvsxHw7Q2Z8YpldBhVa4pYM+
         AiaOV4SsgY/Ow34Ysdya66aQ0XXXN7+ZzFhwidPD+ZSAXHqYFnP96IqEgcuVTAsUcDhK
         fqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hiJ8datrPrACNhvXckFlv/XrEYflYRGsSb7qn5RmtHk=;
        b=TV3psNcuZTLesRj1A+p0cHEqYv26S5AC22R9R+kZHamQAE66LXCOtDxs00dduuHyUh
         OJYiZ3h0NIPzE9YFuwSq1RqUpCUN20jVC8untIpv6C+/O0tphlFEP800+xfLUHEN7ITX
         U0OWSGL8L7R0zyyn7XH4kuJnLrx/A7w+Sjlv1Giz7iFhe6y7sy3Lxc9NEfsZZUHsrz2g
         VxieM/elZqvpJDvsgXU8VhOdaCAIrCHyAn6wldsVT0nwZMWyIdSSgXIe3JFR6msuA4Y/
         qZJJ79xKJBcUOoW0k2rDkfI9BhQQCdbeXmXyyF/NO6vCRWx/7C7mI6t7Z8pPCrhsIqwM
         PF5Q==
X-Gm-Message-State: APjAAAUAasR3Ryr/TDVB21sp7j3f49A1PZKWhRFD8r9hkXafRK0DVcyW
        Lkm4hod+UdBhTEzDNTH1sNIazxFs3rTPOA==
X-Google-Smtp-Source: APXvYqztUovtslwIqEKqmVWpK+ns3ggBOHc/tA+aATcnvTO9DVCzvm/1sjnI4V0SOdbn+U5nHitRNxVU+UsZ9Q==
X-Received: by 2002:a1f:3f45:: with SMTP id m66mr10131027vka.17.1562766023159;
 Wed, 10 Jul 2019 06:40:23 -0700 (PDT)
Date:   Wed, 10 Jul 2019 06:40:11 -0700
In-Reply-To: <20190710134011.221210-1-edumazet@google.com>
Message-Id: <20190710134011.221210-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190710134011.221210-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] ipv6: fix static key imbalance in fl_create()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fl_create() should call static_branch_deferred_inc() only in
case of success.

Also we should not call fl_free() in error path, as this could
cause a static key imbalance.

jump label: negative count!
WARNING: CPU: 0 PID: 15907 at kernel/jump_label.c:221 static_key_slow_try_dec kernel/jump_label.c:221 [inline]
WARNING: CPU: 0 PID: 15907 at kernel/jump_label.c:221 static_key_slow_try_dec+0x1ab/0x1d0 kernel/jump_label.c:206
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 15907 Comm: syz-executor.2 Not tainted 5.2.0-rc6+ #62
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 panic+0x2cb/0x744 kernel/panic.c:219
 __warn.cold+0x20/0x4d kernel/panic.c:576
 report_bug+0x263/0x2b0 lib/bug.c:186
 fixup_bug arch/x86/kernel/traps.c:179 [inline]
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
 invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
RIP: 0010:static_key_slow_try_dec kernel/jump_label.c:221 [inline]
RIP: 0010:static_key_slow_try_dec+0x1ab/0x1d0 kernel/jump_label.c:206
Code: c0 e8 e9 3e e5 ff 83 fb 01 0f 85 32 ff ff ff e8 5b 3d e5 ff 45 31 ff eb a0 e8 51 3d e5 ff 48 c7 c7 40 99 92 87 e8 13 75 b7 ff <0f> 0b eb 8b 4c 89 e7 e8 a9 c0 1e 00 e9 de fe ff ff e8 bf 6d b7 ff
RSP: 0018:ffff88805f9c7450 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000000000000
RDX: 000000000000e3e1 RSI: ffffffff815adb06 RDI: ffffed100bf38e7c
RBP: ffff88805f9c74e0 R08: ffff88806acf0700 R09: ffffed1015d060a9
R10: ffffed1015d060a8 R11: ffff8880ae830547 R12: ffffffff89832ce0
R13: ffff88805f9c74b8 R14: 1ffff1100bf38e8b R15: 00000000ffffff01
 __static_key_slow_dec_deferred+0x65/0x110 kernel/jump_label.c:272
 fl_free+0xa9/0xe0 net/ipv6/ip6_flowlabel.c:121
 fl_create+0x6af/0x9f0 net/ipv6/ip6_flowlabel.c:457
 ipv6_flowlabel_opt+0x80e/0x2730 net/ipv6/ip6_flowlabel.c:624
 do_ipv6_setsockopt.isra.0+0x2119/0x4100 net/ipv6/ipv6_sockglue.c:825
 ipv6_setsockopt+0xf6/0x170 net/ipv6/ipv6_sockglue.c:944
 tcp_setsockopt net/ipv4/tcp.c:3131 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3125
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3130
 __sys_setsockopt+0x253/0x4b0 net/socket.c:2080
 __do_sys_setsockopt net/socket.c:2096 [inline]
 __se_sys_setsockopt net/socket.c:2093 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2093
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4597c9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2670556c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00000000004597c9
RDX: 0000000000000020 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 000000000000fdf7 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00007f26705576d4
R13: 00000000004cec00 R14: 00000000004dd520 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..

Fixes: 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases exist")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/ip6_flowlabel.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index ad284b1fd308a646f27f715f35d9759fd50c5902..d64b83e856428195c1ecc963a263155c8b4528d0 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -435,8 +435,6 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 	}
 	fl->dst = freq->flr_dst;
 	atomic_set(&fl->users, 1);
-	if (fl_shared_exclusive(fl) || fl->opt)
-		static_branch_deferred_inc(&ipv6_flowlabel_exclusive);
 	switch (fl->share) {
 	case IPV6_FL_S_EXCL:
 	case IPV6_FL_S_ANY:
@@ -451,10 +449,15 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 		err = -EINVAL;
 		goto done;
 	}
+	if (fl_shared_exclusive(fl) || fl->opt)
+		static_branch_deferred_inc(&ipv6_flowlabel_exclusive);
 	return fl;
 
 done:
-	fl_free(fl);
+	if (fl) {
+		kfree(fl->opt);
+		kfree(fl);
+	}
 	*err_p = err;
 	return NULL;
 }
-- 
2.22.0.410.gd8fdbe21b5-goog

