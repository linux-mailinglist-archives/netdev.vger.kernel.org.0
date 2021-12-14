Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374C4473C00
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 05:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhLNEcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 23:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhLNEcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 23:32:15 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D051AC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:32:14 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id o14so12696014plg.5
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zreLB0MY/5jhxrif1BXpVZ3nSi5948HHRn5Ovxn0/iE=;
        b=lIy8ducLYJsWnOf6eYGch06bLM9F49f46BeWbBarfuS/ZlMM6QneLV7Du6zTHBnApG
         JZ/V55vJPdKEo9OVsvqgZ4MN0TkH/BQeZv1aMIDE2499j5Jz+0RjZyIVo7zYiy+1tsVV
         hT62SYhAqGrQFS3xeSSkQIEWmOyjX6rkefDqIWWFAp8wE2rasuTbqFjhoOMMvQlTtVTN
         g8zNzLM3j+llzzKt+qU6ILGWy6a1Q2m2eYhq5ZSR7oVQFpLiIVPPJywM3Jk32PMGo+XB
         oBGIx4KDRVCUYOsWXfNLRMe432C/EzY3HjMGcfR+EvVpxlGHz0IwrsNiRU+gU5Zo/tF2
         sirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zreLB0MY/5jhxrif1BXpVZ3nSi5948HHRn5Ovxn0/iE=;
        b=YJirjYIgsdu4xDPUiYLq7HpuOKdfo2+gDEosw94dMgQEhgSmBi0un2oZhBMCkZbpwW
         kmV1NncNZwtlFAz287GsAHnUYXcHYvt9fkBRRDtdhB4eSLvddGazWi/Cdk+AWiWSukNe
         Bjygy5A1GsyRY+LNaVkHXvKc14587s2+IJMulFkEGSZJAu0sS5ArnD+pzKhlVXsfAJ8J
         T1arGtSyY9rIGf/DxWoqLOF2KlQ4bvsHFhztyBurC9a+KfqkC9e+OddEYQK+Z1lJO4ET
         W8xf+EtFOaNHm4zyoTJydcBmoSGqRCqemRMAu1N0xMUOZztjNGObCQVnICe1zR9MPUrR
         LmRg==
X-Gm-Message-State: AOAM532sZj9klH8axlRRoTjHWD8hYhScxM+2HgsV1YYwPdAd9ZVP7d3c
        c/lI4kGp7Nies6UBywiVCM0=
X-Google-Smtp-Source: ABdhPJy9dGCcTUs0Q4G8nfPaETs0Ug+n0KaoXORhQiEnlOmOo3fj14KbfJHz7In+qWPF89flpli0ig==
X-Received: by 2002:a17:902:d2c3:b0:146:6c28:191e with SMTP id n3-20020a170902d2c300b001466c28191emr2835953plc.7.1639456334303;
        Mon, 13 Dec 2021 20:32:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5cbb:7251:72ab:eb48])
        by smtp.gmail.com with ESMTPSA id f7sm14229490pfv.89.2021.12.13.20.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 20:32:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] mptcp: adjust to use netns refcount tracker
Date:   Mon, 13 Dec 2021 20:32:08 -0800
Message-Id: <20211214043208.3543046-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

MPTCP can change sk_net_refcnt after sock_create_kern() call.

We need to change its corresponding get_net() to avoid
a splat at release time, as in :

refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 3599 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 1 PID: 3599 Comm: syz-fuzzer Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d b1 99 a1 09 31 ff 89 de e8 5d 3a 9c fd 84 db 75 e0 e8 74 36 9c fd 48 c7 c7 60 00 05 8a c6 05 91 99 a1 09 01 e8 cc 4b 27 05 <0f> 0b eb c4 e8 58 36 9c fd 0f b6 1d 80 99 a1 09 31 ff 89 de e8 28
RSP: 0018:ffffc90001f5fab0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888021873a00 RSI: ffffffff815f1e28 RDI: fffff520003ebf48
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ebbce R11: 0000000000000000 R12: 1ffff920003ebf5b
R13: 00000000ffffffef R14: ffffffff8d2fcd94 R15: ffffc90001f5fd10
FS:  000000c00008a090(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0a5b59e300 CR3: 000000001cbe6000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 ref_tracker_free+0x4fe/0x610 lib/ref_tracker.c:101
 netns_tracker_free include/net/net_namespace.h:327 [inline]
 put_net_track include/net/net_namespace.h:341 [inline]
 __sk_destruct+0x4a6/0x920 net/core/sock.c:2042
 sk_destruct+0xbd/0xe0 net/core/sock.c:2058
 __sk_free+0xef/0x3d0 net/core/sock.c:2069
 sk_free+0x78/0xa0 net/core/sock.c:2080
 sock_put include/net/sock.h:1911 [inline]
 __mptcp_close_ssk+0x435/0x590 net/mptcp/protocol.c:2276
 __mptcp_destroy_sock+0x35f/0x830 net/mptcp/protocol.c:2702
 mptcp_close+0x5f8/0x7f0 net/mptcp/protocol.c:2750
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:476
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: ffa84b5ffb37 ("net: add netns refcount tracker to struct sock")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Florian Westphal <fw@strlen.de>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b8dd3441f7d00357dfac6121f6288b9300ea5201..24bc9d5e87be44542f5094cda39dcc59f8f9f10d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1534,7 +1534,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	 * needs it.
 	 */
 	sf->sk->sk_net_refcnt = 1;
-	get_net(net);
+	get_net_track(net, &sf->sk->ns_tracker, GFP_KERNEL);
 	sock_inuse_add(net, 1);
 	err = tcp_set_ulp(sf->sk, "mptcp");
 	release_sock(sf->sk);
-- 
2.34.1.173.g76aa8bc2d0-goog

