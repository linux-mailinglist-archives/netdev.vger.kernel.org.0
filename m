Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07674301BF7
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbhAXNAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAXNA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 08:00:27 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C4CC061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 04:59:46 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id jx18so1289850pjb.5
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 04:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=1je9icuwBJ1UZSJUVy0sS3F10fijSU8vN9AFDaLbwK0=;
        b=ICCcLduMS1OcSi170owp5Sm4Lh306QH+3s2zWorIz5qKIDzep5xYeMuwW28+KnExcm
         G2te1vFaEcJTM5Xdpmj58/zSneRoy+YMkg/U+t/3gb7v4uHQTnDL+sBVo0Phs6b9R0KX
         z7NXP+8xjpnZmHM1AGps9XQmVXAyC+SYhxI/MBcWI12Ks0KpQEJoYB1qEVBhcBZ64UkG
         +tbzdsVyb1XAuU8P0paLZC3RTFaao7ue1rA5QuH5ZP7S+5YEtZDLDEl+bp3o6zmtypwF
         6awCG5vblLr1/JT0WDQrlcW0UlPgYKUB6hUlvDhIXiAa0HKlFuODEb0QnXErjuJS2qb/
         ZVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1je9icuwBJ1UZSJUVy0sS3F10fijSU8vN9AFDaLbwK0=;
        b=WEhMTWZbSdSAaEfAXlxersRuOQA8n26NPBhmdxYq45gvxQOzZHTGP3y+q7hdu//j9p
         oFlzfe7348J+Rxyay9PsoTZih5pe/TVLqhZ4NgBE2ApWroN4xr8aj+ELIoREgkGpEFtI
         FB972A4iVTkZo4yGxTzektY0OrL6D0qQDwHgRI1qEZxs2hsSGnNOiM5NHkmr4nlkcfUP
         ECo0C4K21widH1u0b7aLurAdu76iljsV98ziw9mwe9d7OPrh09fGM1xNgd7Pa0RxlI04
         agE9fVu/UAJnwQ+to4CgnoQPwPFcUKT7op2bkwUwJsjxhSDdj07wFQUvjbFdTT+9j1cG
         vXOw==
X-Gm-Message-State: AOAM531oNKVc+W7kAqzogxfp8OovXznbOyowOwaz/DjJykq5vuOvIhjp
        3HDAFGHncYA4Q2Dj6reuyf3q9OKVTw==
X-Google-Smtp-Source: ABdhPJyLkRfF5WawfqgnIk+ac/5O5qwZIpLRV7N7uq7X/4h7Fn2IqRbZ1C9SjuCxSxzkfxsozmb/Jg==
X-Received: by 2002:a17:90a:aa8a:: with SMTP id l10mr1732393pjq.86.1611493186430;
        Sun, 24 Jan 2021 04:59:46 -0800 (PST)
Received: from DESKTOP (softbank126012184080.bbtec.net. [126.12.184.80])
        by smtp.gmail.com with ESMTPSA id 14sm13695154pfy.55.2021.01.24.04.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 04:59:46 -0800 (PST)
Date:   Sun, 24 Jan 2021 21:59:43 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] rxrpc: Fix memory leak in rxrpc_lookup_local
Message-ID: <20210124125943.GA20333@DESKTOP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
Then release ref in __rxrpc_put_peer and rxrpc_put_peer_locked.

	struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
	-               peer->local = local;
	+               peer->local = rxrpc_get_local(local);

rxrpc_discard_prealloc also need ref release in discarding.

syzbot report:
BUG: memory leak
unreferenced object 0xffff8881080ddc00 (size 256):
  comm "syz-executor339", pid 8462, jiffies 4294942238 (age 12.350s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 c0 00 08 81 88 ff ff  ................
  backtrace:
    [<000000002b6e495f>] kmalloc include/linux/slab.h:552 [inline]
    [<000000002b6e495f>] kzalloc include/linux/slab.h:682 [inline]
    [<000000002b6e495f>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<000000002b6e495f>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000006b43a77b>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<00000000fd447a55>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<000000007fd8867c>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<0000000063d80ec1>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000073c5efa>] setup_net+0xde/0x2d0 net/core/net_namespace.c:342
    [<00000000a6744d5b>] copy_net_ns+0x19f/0x3e0 net/core/net_namespace.c:483
    [<0000000017d3aec3>] create_new_namespaces+0x199/0x4f0 kernel/nsproxy.c:110
    [<00000000186271ef>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:226
    [<000000002de7bac4>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2957
    [<00000000349b12ba>] __do_sys_unshare kernel/fork.c:3025 [inline]
    [<00000000349b12ba>] __se_sys_unshare kernel/fork.c:3023 [inline]
    [<00000000349b12ba>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3023
    [<000000006d178ef7>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000637076d4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
Reported-and-tested-by: syzbot+305326672fed51b205f7@syzkaller.appspotmail.com
---
Dear David Howells

syzbot reported memory leak in rxrpc_lookup_local.

I send a patch that passed syzbot reproducer test.
Please consider this memory leak and patch.

syzbot link:
https://syzkaller.appspot.com/bug?id=80b2343d6c19226dfa59e33b151c168d96253420

Regards.
---
 net/rxrpc/call_accept.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 8df1964db333..a0b033954cea 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -197,6 +197,7 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	tail = b->peer_backlog_tail;
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_peer *peer = b->peer_backlog[tail];
+		rxrpc_put_local(peer->local);
 		kfree(peer);
 		tail = (tail + 1) & (size - 1);
 	}
-- 
2.25.1

