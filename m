Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E02444BCA
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 00:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhKCXvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 19:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhKCXvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 19:51:52 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C64BC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 16:49:15 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t7so3762001pgl.9
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 16:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QC0cuWhTYSPEOGjaK7avwxBC0/o5yGJMc18wALI2NuA=;
        b=MDUpdb6uJKkQfQVsC7kuSBR1IDaLQS4yn6IQoAmPyKzIxEGMkJvovRlN0ikGaECePA
         q5ooEWohAKbuSY+vBRMZs/eYiNWuD2hD0FOReUom2GlYDQ7TjzV2y0/NFa5z2VlDj5pz
         CW5R28ixckBsmL+Tj5l/K9I6N2DXOUN3nMslr+i4A1RDIiKpVzYdwLd0vazDVrpUYunX
         jVhRpi8DLdlLyYLic9SXHgJbY/8CfSvAmKNyx9Iul2emORUw9jPPL6tmpXedOosbnsYE
         iNPNktRW56vZscRHHrmYVB0OkHGrlyh0iORDPt7YkgqOCm3WXjt6VRGkr5fP007cqcRP
         TbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QC0cuWhTYSPEOGjaK7avwxBC0/o5yGJMc18wALI2NuA=;
        b=kdqp3N9cJTl0Bgt0gUeey8r34XlwJN3M+8CDpCdxvOsU9R+/hJstaSY3FI8wnhqcEt
         KoOEVU71SUPCu/phkcOfeKUAe4nvZZAdxtdsH90pKRA3cLiYwfq0BZtB/Uaar527BkWt
         nhS6TJHNb+tC4fiIYSX98hMwGouGsZdY3kHti5Wh0jtb62+u6k3QqQabhQHnBDlwbZB/
         v60/2Wew6KOh/n7fkb7XzkDVFKKoHnV1SipJowVcig0QG34uutcuN+kxikUwAPKa5wTT
         9GLm3IMiWt5SLuEHjUmDy3hBAKdN0i1jffu4thTEIWEUD0ERj+P7s3UA2dLGj4sqsan5
         9g3w==
X-Gm-Message-State: AOAM531mHhXvu3bUxaZcEqRn2aC7CNdgPrEHQsJ24pmTXm/8+LVXXP/0
        G4Z9SHcqPTbrg8PXg1sXfq0=
X-Google-Smtp-Source: ABdhPJxTHlXB0DEW0SWjg1H6hLydEFs7RWmeMNT2VhXRBi5reCw8MKHiAVtF2WZ2MfRa/XhSGiMQ/w==
X-Received: by 2002:aa7:8b56:0:b0:44b:e510:a208 with SMTP id i22-20020aa78b56000000b0044be510a208mr49000843pfd.56.1635983354438;
        Wed, 03 Nov 2021 16:49:14 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7008:77cc:ccad:9d5a])
        by smtp.gmail.com with ESMTPSA id p14sm2518475pjl.32.2021.11.03.16.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 16:49:14 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net] net: fix possible NULL deref in sock_reserve_memory
Date:   Wed,  3 Nov 2021 16:49:11 -0700
Message-Id: <20211103234911.4073969-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Sanity check in sock_reserve_memory() was not enough to prevent malicious
user to trigger a NULL deref.

In this case, the isse is that sk_prot->memory_allocated is NULL.

Use standard sk_has_account() helper to deal with this.

BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_add_return include/linux/atomic/atomic-instrumented.h:1218 [inline]
BUG: KASAN: null-ptr-deref in sk_memory_allocated_add include/net/sock.h:1371 [inline]
BUG: KASAN: null-ptr-deref in sock_reserve_memory net/core/sock.c:994 [inline]
BUG: KASAN: null-ptr-deref in sock_setsockopt+0x22ab/0x2b30 net/core/sock.c:1443
Write of size 8 at addr 0000000000000000 by task syz-executor.0/11270

CPU: 1 PID: 11270 Comm: syz-executor.0 Not tainted 5.15.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __kasan_report mm/kasan/report.c:446 [inline]
 kasan_report.cold+0x66/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_long_add_return include/linux/atomic/atomic-instrumented.h:1218 [inline]
 sk_memory_allocated_add include/net/sock.h:1371 [inline]
 sock_reserve_memory net/core/sock.c:994 [inline]
 sock_setsockopt+0x22ab/0x2b30 net/core/sock.c:1443
 __sys_setsockopt+0x4f8/0x610 net/socket.c:2172
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f56076d5ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5604c4b188 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f56077e8f60 RCX: 00007f56076d5ae9
RDX: 0000000000000049 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007f560772ff25 R08: 000000000000fec7 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffb61a100f R14: 00007f5604c4b300 R15: 0000000000022000
 </TASK>

Fixes: 2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Wei Wang <weiwan@google.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9862eefce21ede8644f84c99c539643ec31c7908..8f2b2f2c0e7b1decdb4a5c8d86327ed7caa62c99 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -976,7 +976,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	bool charged;
 	int pages;
 
-	if (!mem_cgroup_sockets_enabled || !sk->sk_memcg)
+	if (!mem_cgroup_sockets_enabled || !sk->sk_memcg || !sk_has_account(sk))
 		return -EOPNOTSUPP;
 
 	if (!bytes)
-- 
2.33.1.1089.g2158813163f-goog

