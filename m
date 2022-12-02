Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDB064059B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiLBLQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiLBLQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:16:44 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88455D20B4
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 03:16:42 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3c9960ad866so45991437b3.4
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 03:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wHICa9Uq5ifJuLaUResZQnW4YoHbUiE3XjqihlfnpNA=;
        b=WEQTsg6eKY+MHMpr/DN8ql0FLsnbbNe+Ky1tLsqqrC1vopalmpW3AFnGL/QBUamUCJ
         N/YdRc5NzkObmWTHw5hr8uMmRseeOmgtjM+sDK52Hw+HhUA+7mVpJti+2LZIJtyuB+5a
         eS+0NiHVTs0FeeUNawE8FHDWHxo/39qQS5zjq88ANtmP3PUFNOd+JwbOORBZBao+y3Xg
         TU8L2uSBIIGeDSe/ehlmRwxI6+ABguDxXPpWxrzY4zPgyodTL497031BDHmYpuaLr/nz
         NN6GF0eh1q8mayrVszx2bCJ/VwqG316sa8nPjYAZKijS9godj0nPN4iqhNQWFdhO5Dfc
         1T8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wHICa9Uq5ifJuLaUResZQnW4YoHbUiE3XjqihlfnpNA=;
        b=cmqChb4JuThyn7qxcsJ6tct1GHP9w+pzCdgaSPjaUo+sc0W0NfIAdJ+nUs9o4W22iL
         kqUiJ0hMypYZ3aDepwXAS2IWRjiuC67U9ftmDsL/J2I5ga3F1RikCeYDwwvbUQcy5K+p
         PWIKc0kzhzaRtm/Dv0GBSjJFL3M4jHSX7BbEAys6mUEp0FiS6gD/5iJNmN6O7UCMj0v3
         F+bEfnOdqzknh3UC4pZS064jRnK/BooVPY3piS9kiq+eevYOMRpDwqUjutH2Mm0jgHGe
         ZfqOR1adINI2eZvFH1v7HmlheUWibJ0eulGf7i/gFs3cbanSwG5QvZMBrff6O7YZtUOC
         ENpA==
X-Gm-Message-State: ANoB5pmIzwuGL4ifb4ETHZE6ynPLD8IQ1owbzd15zxxNmmBBRGkprZSk
        yZnLqDBTicIQTgMevYacgKlFZfYZCpl19A==
X-Google-Smtp-Source: AA0mqf4xV8MDrdaJaGQ/ZOneQdOHYnzefNR95TB4qSFrq9JMgjjLWHlkQqKWx7dNcAYO9ZWkYWbpNBKcfu3pWA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:5243:0:b0:3d2:2098:c5fb with SMTP id
 g64-20020a815243000000b003d22098c5fbmr14647059ywb.121.1669979801877; Fri, 02
 Dec 2022 03:16:41 -0800 (PST)
Date:   Fri,  2 Dec 2022 11:16:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202111640.2745533-1-edumazet@google.com>
Subject: [PATCH net] bpf, sockmap: fix race in sock_map_free()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_map_free() calls release_sock(sk) without owning a reference
on the socket. This can cause use-after-free as syzbot found [1]

Jakub Sitnicki already took care of a similar issue
in sock_hash_free() in commit 75e68e5bf2c7 ("bpf, sockhash:
Synchronize delete from bucket list on map free")

[1]
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 3785 at lib/refcount.c:31 refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 3785 Comm: kworker/u4:6 Not tainted 6.1.0-rc7-syzkaller-00103-gef4d3ea40565 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound bpf_map_free_deferred
RIP: 0010:refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
Code: 68 8b 31 c0 e8 75 71 15 fd 0f 0b e9 64 ff ff ff e8 d9 6e 4e fd c6 05 62 9c 3d 0a 01 48 c7 c7 80 bb 68 8b 31 c0 e8 54 71 15 fd <0f> 0b e9 43 ff ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c a2 fe ff
RSP: 0018:ffffc9000456fb60 EFLAGS: 00010246
RAX: eae59bab72dcd700 RBX: 0000000000000004 RCX: ffff8880207057c0
RDX: 0000000000000000 RSI: 0000000000000201 RDI: 0000000000000000
RBP: 0000000000000004 R08: ffffffff816fdabd R09: fffff520008adee5
R10: fffff520008adee5 R11: 1ffff920008adee4 R12: 0000000000000004
R13: dffffc0000000000 R14: ffff88807b1c6c00 R15: 1ffff1100f638dcf
FS: 0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30c30000 CR3: 000000000d08e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__refcount_dec include/linux/refcount.h:344 [inline]
refcount_dec include/linux/refcount.h:359 [inline]
__sock_put include/net/sock.h:779 [inline]
tcp_release_cb+0x2d0/0x360 net/ipv4/tcp_output.c:1092
release_sock+0xaf/0x1c0 net/core/sock.c:3468
sock_map_free+0x219/0x2c0 net/core/sock_map.c:356
process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
kthread+0x266/0x300 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
</TASK>

Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Song Liu <songliubraving@fb.com>
---
 net/core/sock_map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 81beb16ab1ebfcb166f51f89a029fe1c28a629a4..22fa2c5bc6ec9652c4e4a904990a5b7635c20cb6 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -349,11 +349,13 @@ static void sock_map_free(struct bpf_map *map)
 
 		sk = xchg(psk, NULL);
 		if (sk) {
+			sock_hold(sk);
 			lock_sock(sk);
 			rcu_read_lock();
 			sock_map_unref(sk, psk);
 			rcu_read_unlock();
 			release_sock(sk);
+			sock_put(sk);
 		}
 	}
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

