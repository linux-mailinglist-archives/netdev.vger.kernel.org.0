Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D46243D1E
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 18:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHMQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 12:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHMQSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 12:18:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10973C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 09:18:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e12so7290298ybc.18
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 09:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CZZOdgRLVSI2SQumMEtqWFogrJhuJBY/r0BTePFJIaw=;
        b=TkSVtekVqK74m+OE+DzpR0De5BgRUGHS9UwPPBXIovv/w+sj+lPnWYbHUh1w8xrq2l
         esaZt2i0of+NA9fSy+EPonmtTYiHrhzxmftVIuEL8YA4CHiwymUXkG6DHznzt/36WFGa
         SYhjpnJuyr9m4DqBM/Uw97DeKpmiRxG4tw48Y+t6E14sMuo7lPbFyp+VLpGyMxYdyK+d
         kpwOuLPGFfasRlZTT2zJuzNbBWkfxh4wl5Eky/XRHv5zEQkuJCzEJVjU8b0Jvjc3uFGt
         X51Nwy+8isRyR72cOnd9hcUY+kwx5fHjKMtt6XJt8TL+kpjLDFnnTGJymeIBlljYELI9
         EYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CZZOdgRLVSI2SQumMEtqWFogrJhuJBY/r0BTePFJIaw=;
        b=cOvqHwfYxc/Ta2Sc43rSb0zXnJhxJDNxCzeoOJapyjEQToIiAkjLpUgfsYHQtRJtfG
         /hIIqL3uVtTlT00lCI8M+K6V5WpRXzNejNEED6yGe/fO5Ed7v/9+vUdexb7LY1Cx98bJ
         1KDbUlKys5tD9xes79emwIdzBFTZgMqFXDLA4ClO5a4rnATiQCLtMzHck0ry1IFII8dW
         Ged7amRBI5aBdvrQXIcbGm/3juEirvexHhwDe/5lEk9ug2YqlXrYvMZCoJDSncIDkdxo
         1vTMLDXvAWoI9DiNtJvCnUheKo1Q8g+LeYyegKjvKSTuUtxENA/tac6n4I7L0uxCm6V2
         QuKQ==
X-Gm-Message-State: AOAM530p+s1Fr4mwhUXXGwDCbp9NRN4R2oyb5WsciGFULKxmn0wu0S+r
        TFe3iYPxwpyQ2Y/Lj9rUJQ7sNprJYXqqog==
X-Google-Smtp-Source: ABdhPJxtbch6smsWJKS8Jg8XZK7+C+0ljiIqiCrjVZ8fEqElh+cMO0K7oYpb6hKL5AUn82ZhKGTlLskMpAs4nA==
X-Received: by 2002:a25:8891:: with SMTP id d17mr6982547ybl.209.1597335517194;
 Thu, 13 Aug 2020 09:18:37 -0700 (PDT)
Date:   Thu, 13 Aug 2020 09:18:34 -0700
Message-Id: <20200813161834.4021638-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net] can: j1939: fix kernel-infoleak in j1939_sk_sock2sockaddr_can()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found that at least 2 bytes of kernel information
were leaked during getsockname() on AF_CAN CAN_J1939 socket.

Since struct sockaddr_can has in fact two holes, simply
clear the whole area before filling it with useful data.

BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
CPU: 0 PID: 8466 Comm: syz-executor511 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 kmsan_internal_check_memory+0x238/0x3d0 mm/kmsan/kmsan.c:423
 kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
 instrument_copy_to_user include/linux/instrumented.h:91 [inline]
 _copy_to_user+0x18e/0x260 lib/usercopy.c:39
 copy_to_user include/linux/uaccess.h:186 [inline]
 move_addr_to_user+0x3de/0x670 net/socket.c:237
 __sys_getsockname+0x407/0x5e0 net/socket.c:1909
 __do_sys_getsockname net/socket.c:1920 [inline]
 __se_sys_getsockname+0x91/0xb0 net/socket.c:1917
 __x64_sys_getsockname+0x4a/0x70 net/socket.c:1917
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440219
Code: Bad RIP value.
RSP: 002b:00007ffe5ee150c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000033
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440219
RDX: 0000000020000240 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a20
R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000

Local variable ----address@__sys_getsockname created at:
 __sys_getsockname+0x91/0x5e0 net/socket.c:1894
 __sys_getsockname+0x91/0x5e0 net/socket.c:1894

Bytes 2-3 of 24 are uninitialized
Memory access of size 24 starts at ffff8880ba2c7de8
Data copied to user address 0000000020000100

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Robin van der Gracht <robin@protonic.nl>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: linux-can@vger.kernel.org
---
 net/can/j1939/socket.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 78ff9b3f1d40c732ba39b2402b5099ba84f8a4a5..3db0973e6d31ddf5267d8c56d3b8cedb800e78fd 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -553,6 +553,11 @@ static int j1939_sk_connect(struct socket *sock, struct sockaddr *uaddr,
 static void j1939_sk_sock2sockaddr_can(struct sockaddr_can *addr,
 				       const struct j1939_sock *jsk, int peer)
 {
+	/* There are two holes (2 bytes and 3 bytes) to clear to avoid
+	 * leaking kernel information to user space.
+	*/
+	memset(addr, 0, J1939_MIN_NAMELEN);
+
 	addr->can_family = AF_CAN;
 	addr->can_ifindex = jsk->ifindex;
 	addr->can_addr.j1939.pgn = jsk->addr.pgn;
-- 
2.28.0.220.ged08abb693-goog

