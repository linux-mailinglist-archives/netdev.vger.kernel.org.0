Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6119E2870D2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgJHIii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgJHIih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:38:37 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9C5C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 01:38:36 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a200so3393550pfa.10
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 01:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=omHf6EPA8l7Pk+D1YzcJgVNQxRdXpIHAQlg82ACnwU8=;
        b=fqG+4VY+dTI+za7td8CdTs24pbYXgyHOHTMPwxJqgmtMqHxa410FXNWnKP3aCWEvQU
         LvhYmZtPveLFBqNFZyjmD7kC2MhLxAVyUYs8iGrfUEcKHDuKCZ6JMH3XTQWpzyl0S89r
         MtG5DXG+1Q9yqV+mwuYgydBvIQj/zkDbDIqpsJHGQAPsQs4TbxUH7bPu0mJZIZKHEEO1
         mOylC48a8OBelqErNGO8jeYc0UHLpGa5ARpUyKib8W0XUW+wyStEoM64AalIJfqoDooU
         34feVVtYPwpscMwmy8ejXBrqvQd59KM0ebmCWIRqV0bE7jyZe3GQrMrraGkKLf5VJhMj
         PJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=omHf6EPA8l7Pk+D1YzcJgVNQxRdXpIHAQlg82ACnwU8=;
        b=klNYuF/1EyDPpcjliKL1rCQT+wZ/jnAvRvPLUp5Cs2CLxG/ou5X+I5cgvmez39dAvB
         Qh1oUi4maPC4J/uhOFByADBRu5VNzaMenyxFOMFhwW2//ZVpeyzkjRHSg+C1dZk24qod
         cIfH3KqtL6VUEP/Yf6iR3l6eu4c7zA0buw6LgHPgLAIhHApDhTwsx+VEvmo8lC3RMSTS
         m8ZYV8S4yvlNzoaRLgzxtgJMwPPUnt3kAwgteWx0pL9ropMJzCTG9By+tm3n5CxGU3+v
         HhAmEuP3Qg36RGMMkdxdt43bnINGSmyG97PzPg5Jc0BhNjHN6Auii5rXZS1JDj0HHtAn
         YjHg==
X-Gm-Message-State: AOAM532T1EfLlFTS7m+3v/lBke6um2Lo297fbFYcs6UJy7q6SXUg2DIx
        DuPf1FMDy0bNBuuNsCgMyIM=
X-Google-Smtp-Source: ABdhPJz3VvQ9sxY7YlrWvOrUyWCGM/2V4pEciMr40nJ9RnfQggxW5NDXPwmWk5jvyx1w1QE156v7zg==
X-Received: by 2002:a17:90a:e453:: with SMTP id jp19mr7304391pjb.34.1602146316515;
        Thu, 08 Oct 2020 01:38:36 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id q24sm7203467pfn.72.2020.10.08.01.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 01:38:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: fix sctp_auth_init_hmacs() error path
Date:   Thu,  8 Oct 2020 01:38:31 -0700
Message-Id: <20201008083831.521769-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After freeing ep->auth_hmacs we have to clear the pointer
or risk use-after-free as reported by syzbot:

BUG: KASAN: use-after-free in sctp_auth_destroy_hmacs net/sctp/auth.c:509 [inline]
BUG: KASAN: use-after-free in sctp_auth_destroy_hmacs net/sctp/auth.c:501 [inline]
BUG: KASAN: use-after-free in sctp_auth_free+0x17e/0x1d0 net/sctp/auth.c:1070
Read of size 8 at addr ffff8880a8ff52c0 by task syz-executor941/6874

CPU: 0 PID: 6874 Comm: syz-executor941 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 sctp_auth_destroy_hmacs net/sctp/auth.c:509 [inline]
 sctp_auth_destroy_hmacs net/sctp/auth.c:501 [inline]
 sctp_auth_free+0x17e/0x1d0 net/sctp/auth.c:1070
 sctp_endpoint_destroy+0x95/0x240 net/sctp/endpointola.c:203
 sctp_endpoint_put net/sctp/endpointola.c:236 [inline]
 sctp_endpoint_free+0xd6/0x110 net/sctp/endpointola.c:183
 sctp_destroy_sock+0x9c/0x3c0 net/sctp/socket.c:4981
 sctp_v6_destroy_sock+0x11/0x20 net/sctp/socket.c:9415
 sk_common_release+0x64/0x390 net/core/sock.c:3254
 sctp_close+0x4ce/0x8b0 net/sctp/socket.c:1533
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:475
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43f278
Code: Bad RIP value.
RSP: 002b:00007fffe0995c38 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043f278
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004bf068 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6874:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x174/0x300 mm/slab.c:3554
 kmalloc include/linux/slab.h:554 [inline]
 kmalloc_array include/linux/slab.h:593 [inline]
 kcalloc include/linux/slab.h:605 [inline]
 sctp_auth_init_hmacs+0xdb/0x3b0 net/sctp/auth.c:464
 sctp_auth_init+0x8a/0x4a0 net/sctp/auth.c:1049
 sctp_setsockopt_auth_supported net/sctp/socket.c:4354 [inline]
 sctp_setsockopt+0x477e/0x97f0 net/sctp/socket.c:4631
 __sys_setsockopt+0x2db/0x610 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6874:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3422 [inline]
 kfree+0x10e/0x2b0 mm/slab.c:3760
 sctp_auth_destroy_hmacs net/sctp/auth.c:511 [inline]
 sctp_auth_destroy_hmacs net/sctp/auth.c:501 [inline]
 sctp_auth_init_hmacs net/sctp/auth.c:496 [inline]
 sctp_auth_init_hmacs+0x2b7/0x3b0 net/sctp/auth.c:454
 sctp_auth_init+0x8a/0x4a0 net/sctp/auth.c:1049
 sctp_setsockopt_auth_supported net/sctp/socket.c:4354 [inline]
 sctp_setsockopt+0x477e/0x97f0 net/sctp/socket.c:4631
 __sys_setsockopt+0x2db/0x610 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/auth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 9e289c770574f6009b1e854ee4b9b3d5f942d4d5..7e59d8a18f3e40368eb911b63ac9f514b1dcf095 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -494,6 +494,7 @@ int sctp_auth_init_hmacs(struct sctp_endpoint *ep, gfp_t gfp)
 out_err:
 	/* Clean up any successful allocations */
 	sctp_auth_destroy_hmacs(ep->auth_hmacs);
+	ep->auth_hmacs = NULL;
 	return -ENOMEM;
 }
 
-- 
2.28.0.806.g8561365e88-goog

