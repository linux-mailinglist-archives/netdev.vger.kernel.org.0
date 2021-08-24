Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1743F58D1
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhHXHU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhHXHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:20:25 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07DEC061575;
        Tue, 24 Aug 2021 00:19:41 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g184so447494pgc.6;
        Tue, 24 Aug 2021 00:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bGy+Odlh1NNX+SVQo45RJ9LRSk2xxUJvjKlteUtof4o=;
        b=qwDkdhUQgNa4eLNy5eQ42gaALhmbE8kxY4T8hAOW5WIXGk2PsV3/STX1wsdqMCvTBh
         NIjjFt7DTtSTRmT2kSw2xKgxvKiB3IJSU+1p/rCyfu8784a8SdrX0vCS0OBmYsmc/vw7
         oFaHyqYsglXPedUTL5WNjTTBSlI1YY6pkaz8B06hyX+6dx+0bX4KZiev5jAX0wKIWZpm
         Zy57pWqnR6JWr8fhQcZwOv/k4oBJLftgQUN+evNSY9f01mMJrnT9bX2jSCfYN8DUBFF8
         DD6dZcJbkqbW7jyi0piidGkwDQ/nTa+pxDV1Ps8LWIOq3jRxEdFCxcOL2YCA8+3guWNl
         jP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bGy+Odlh1NNX+SVQo45RJ9LRSk2xxUJvjKlteUtof4o=;
        b=k/RUG6PWcGFvnQBXcEzZdEVLVEdO63xOnE2TIS2aD0LZ6VUEAN5lD1LFtS8IgjQVQk
         2LChqGncqmI7YMH2RUMof0V40GnH6TnzRbomGcI6/ONKTMXWezk2FbNOFA0WGisdhUwl
         /dQk1PhGm0KhZApZbMllWmZ82uVJb38bbsstEfwU5W8Ysoi/FEz3yeHFwdLrTM01hIOF
         CUt0cvld8ZfopEXn3LKIbUsDgmXwDcxyoVvi8FYbXbs+Xy9tCITQD1jCF/5RmH87x0hy
         ByyXW1TBqUHatQKLfSYYAoeUD/X4iPhezwBYuZjP65me82JPdkDnrWF+XE2/l8M59VBZ
         AByA==
X-Gm-Message-State: AOAM530xiqI+1kTcVhwbaHXHaoieIE+k++JPsMHqMvrgMYsuVn5IVtYm
        ErSRCcovRtpCI5xYzzb7060=
X-Google-Smtp-Source: ABdhPJwxrBq1c63ij1GbBbxt/Iby9FrVpNK1Mfz4X/UQbaQ2sx4Wk8WSrxRnZUZYCCoSSAKW1jIdtA==
X-Received: by 2002:a63:df0d:: with SMTP id u13mr35067158pgg.417.1629789581510;
        Tue, 24 Aug 2021 00:19:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id a4sm16868817pfa.203.2021.08.24.00.19.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 00:19:41 -0700 (PDT)
From:   Jiang Biao <benbjiang@gmail.com>
To:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, benbjiang@tencent.com,
        Jiang Biao <tcs_robot@tencent.com>
Subject: [PATCH] ipv4/mptcp: fix divide error
Date:   Tue, 24 Aug 2021 15:19:26 +0800
Message-Id: <20210824071926.68019-1-benbjiang@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiang Biao <benbjiang@tencent.com>

From: Jiang Biao <tcs_robot@tencent.com>

There is a fix divide error reported,
divide error: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:tcp_tso_autosize build/../net/ipv4/tcp_output.c:1975 [inline]
RIP: 0010:tcp_tso_segs+0x14f/0x250 build/../net/ipv4/tcp_output.c:1992
Code: 38 d0 7c 08 84 d2 0f 85 d6 00 00 00 8b 83 8c 03 00 00 48 8d bb 9e 03 00 00 48 89 f9 2d 41 01 00 00 4c 39 e8 49 0f 47 c5 31 d2 <41> f7 f4 48 ba 00 00 00 00 00 fc ff df 39 e8 0f 42 c5 48 c1 e9 03
RSP: 0018:ffffc9000205f558 EFLAGS: 00010246
RAX: 000000000000febf RBX: ffff88801ed48000 RCX: ffff88801ed4839e
RDX: 0000000000000000 RSI: ffff888102ad2340 RDI: ffff88801ed4839e
RBP: 0000000000000002 R08: ffffffff8796862a R09: 000000000000003f
R10: 0000000000000001 R11: 000000000000000a R12: 0000000000000000
R13: 000000000024705b R14: 000000000000000a R15: ffff88801ed48350
FS:  00007f923ce99700(0000) GS:ffff888023e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4f25fa3000 CR3: 0000000088b09000 CR4: 0000000000752ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 tcp_write_xmit+0x135/0x5d50 build/../net/ipv4/tcp_output.c:2623
 __tcp_push_pending_frames+0xab/0x390 build/../net/ipv4/tcp_output.c:2874
 tcp_push+0x473/0x6f0 build/../net/ipv4/tcp.c:736
 mptcp_push_release.isra.32+0x17c/0x280 build/../net/mptcp/protocol.c:1437
 __mptcp_push_pending+0x451/0x530 build/../net/mptcp/protocol.c:1478
 mptcp_sendmsg+0x1759/0x1c00 build/../net/mptcp/protocol.c:1697
 inet_sendmsg+0xa1/0xd0 build/../net/ipv4/af_inet.c:821
 sock_sendmsg_nosec build/../net/socket.c:703 [inline]
 sock_sendmsg+0xc9/0x120 build/../net/socket.c:723
 ____sys_sendmsg+0x375/0x820 build/../net/socket.c:2392
 ___sys_sendmsg+0x10a/0x180 build/../net/socket.c:2446
 __sys_sendmmsg+0x193/0x470 build/../net/socket.c:2532
 __do_sys_sendmmsg build/../net/socket.c:2561 [inline]
 __se_sys_sendmmsg build/../net/socket.c:2558 [inline]
 __x64_sys_sendmmsg+0x99/0x100 build/../net/socket.c:2558
 do_syscall_x64 build/../arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x34/0xb0 build/../arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

It's introduced by non-initialized info->mss_now in __mptcp_push_pending.
Fix it by adding protection in mptcp_push_release.

Signed-off-by: Jiang Biao <tcs_robot@tencent.com>
---
 net/mptcp/protocol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a88924947815..bfb3cd85bf19 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1433,8 +1433,10 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 			       struct mptcp_sendmsg_info *info)
 {
+	int mss_now = info->mss_now ? info->mss_now : tcp_current_mss(ssk);
+
 	mptcp_set_timeout(sk, ssk);
-	tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
+	tcp_push(ssk, 0, mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
 	release_sock(ssk);
 }

--
2.21.0

