Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533E21583D1
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 20:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgBJTgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 14:36:19 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:44833 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgBJTgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 14:36:19 -0500
Received: by mail-pg1-f201.google.com with SMTP id o2so6028039pgj.11
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 11:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JPTDM7K/3wS7qW5jKO5zuhmn3oOubMZN67OuwVGZ5vo=;
        b=phFFU1Wnn+k8vqsh958u7G4KuuX2t6+d1QhSaIpYBVVkVpJjRb7wymwxjOa9EADa/Z
         SDFnaUmxFwE60zUKaANJ80fpM91y5uIjFxaH4QeIJDjw4yJ/jftVLerYL4GT8iN+673k
         XJeiUgUTb3CZKdueld4+GBxwqomBn5wUxP2zCPk0jRa+WdFVrzzXq2VyfhvBu36FF0u8
         rn4x0Y3ErALDcZ9wOygHx13Y5nxrCmrPhC/sZfjHEGT4H3iOs20k1uSesLkcOhWcdwyA
         dUN3dwwcRQoZ2R3PdYKiy87HAQY5ZKZHCpyFB3q7W7vsD7ZmeTdtaL1E1bvQ4rcn1Sh5
         d/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JPTDM7K/3wS7qW5jKO5zuhmn3oOubMZN67OuwVGZ5vo=;
        b=teprFSfA+j5A51IIv/edVLfIe2f0mng1cX81ynfvivNFBYnjDX53zJ5tAAbovt9rwa
         BL7larnBuU9+9+M6LJnCaSwheZc/40I/Z4AvovE0oay60FaByW7SQkJ1jPmux2BPhtsn
         EP8loucVq/tbLzIMkW+pbUGWgIKyGT/wmd0aQkvhVDuDfPT+D3kBD6lXNQvNS4pNdcpy
         7mZ3MSZHnHvzew43q5QiD20fqfIGf7Ue5mS4MgH7ENIQGtENx9AL4VZZteBVlq/l0pMa
         zeroiiRA/y0ub5obx29xr70ZdlBfWtCRZzFCTVxd2vDSO7v5b4Y7Cp7R8gn3pd75bvLZ
         pa1w==
X-Gm-Message-State: APjAAAXTc/Ly4EFOqLEL3LHjKJgtAk4egA8EwztxyVUySBMTrepdInxX
        S7uFohxPb3o6ZTP7IhRCi/RiyZvlZNk+IA==
X-Google-Smtp-Source: APXvYqwsi4j4XW2U9mQKj3TA/kgXzjXVmK1hSv9hq8PqpPDAC1AgjSR6/FxmGKyEXZ8wb+Qg3WcWRjGRGZfizg==
X-Received: by 2002:a63:f24b:: with SMTP id d11mr3092715pgk.381.1581363378425;
 Mon, 10 Feb 2020 11:36:18 -0800 (PST)
Date:   Mon, 10 Feb 2020 11:36:13 -0800
Message-Id: <20200210193613.59360-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] net/smc: fix leak of kernel memory to user space
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As nlmsg_put() does not clear the memory that is reserved,
it this the caller responsability to make sure all of this
memory will be written, in order to not reveal prior content.

While we are at it, we can provide the socket cookie even
if clsock is not set.

syzbot reported :

BUG: KMSAN: uninit-value in __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
BUG: KMSAN: uninit-value in __fswab32 include/uapi/linux/swab.h:59 [inline]
BUG: KMSAN: uninit-value in __swab32p include/uapi/linux/swab.h:179 [inline]
BUG: KMSAN: uninit-value in __be32_to_cpup include/uapi/linux/byteorder/little_endian.h:82 [inline]
BUG: KMSAN: uninit-value in get_unaligned_be32 include/linux/unaligned/access_ok.h:30 [inline]
BUG: KMSAN: uninit-value in ____bpf_skb_load_helper_32 net/core/filter.c:240 [inline]
BUG: KMSAN: uninit-value in ____bpf_skb_load_helper_32_no_cache net/core/filter.c:255 [inline]
BUG: KMSAN: uninit-value in bpf_skb_load_helper_32_no_cache+0x14a/0x390 net/core/filter.c:252
CPU: 1 PID: 5262 Comm: syz-executor.5 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
 __fswab32 include/uapi/linux/swab.h:59 [inline]
 __swab32p include/uapi/linux/swab.h:179 [inline]
 __be32_to_cpup include/uapi/linux/byteorder/little_endian.h:82 [inline]
 get_unaligned_be32 include/linux/unaligned/access_ok.h:30 [inline]
 ____bpf_skb_load_helper_32 net/core/filter.c:240 [inline]
 ____bpf_skb_load_helper_32_no_cache net/core/filter.c:255 [inline]
 bpf_skb_load_helper_32_no_cache+0x14a/0x390 net/core/filter.c:252

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_kmalloc_large+0x73/0xc0 mm/kmsan/kmsan_hooks.c:128
 kmalloc_large_node_hook mm/slub.c:1406 [inline]
 kmalloc_large_node+0x282/0x2c0 mm/slub.c:3841
 __kmalloc_node_track_caller+0x44b/0x1200 mm/slub.c:4368
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 netlink_dump+0x44b/0x1ab0 net/netlink/af_netlink.c:2224
 __netlink_dump_start+0xbb2/0xcf0 net/netlink/af_netlink.c:2352
 netlink_dump_start include/linux/netlink.h:233 [inline]
 smc_diag_handler_dump+0x2ba/0x300 net/smc/smc_diag.c:242
 sock_diag_rcv_msg+0x211/0x610 net/core/sock_diag.c:256
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
 sock_diag_rcv+0x63/0x80 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 kernel_sendmsg+0x433/0x440 net/socket.c:679
 sock_no_sendpage+0x235/0x300 net/core/sock.c:2740
 kernel_sendpage net/socket.c:3776 [inline]
 sock_sendpage+0x1e1/0x2c0 net/socket.c:937
 pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:458
 splice_from_pipe_feed fs/splice.c:512 [inline]
 __splice_from_pipe+0x539/0xed0 fs/splice.c:636
 splice_from_pipe fs/splice.c:671 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:844
 do_splice_from fs/splice.c:863 [inline]
 do_splice fs/splice.c:1170 [inline]
 __do_sys_splice fs/splice.c:1447 [inline]
 __se_sys_splice+0x2380/0x3350 fs/splice.c:1427
 __x64_sys_splice+0x6e/0x90 fs/splice.c:1427
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/smc_diag.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index f38727ecf8b220b398f3ef622df1eccd03da1c56..e1f64f4ba2361432a58ce1d19ec0ecd41462971e 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -39,16 +39,15 @@ static void smc_diag_msg_common_fill(struct smc_diag_msg *r, struct sock *sk)
 {
 	struct smc_sock *smc = smc_sk(sk);
 
+	memset(r, 0, sizeof(*r));
 	r->diag_family = sk->sk_family;
+	sock_diag_save_cookie(sk, r->id.idiag_cookie);
 	if (!smc->clcsock)
 		return;
 	r->id.idiag_sport = htons(smc->clcsock->sk->sk_num);
 	r->id.idiag_dport = smc->clcsock->sk->sk_dport;
 	r->id.idiag_if = smc->clcsock->sk->sk_bound_dev_if;
-	sock_diag_save_cookie(sk, r->id.idiag_cookie);
 	if (sk->sk_protocol == SMCPROTO_SMC) {
-		memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
-		memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
 		r->id.idiag_src[0] = smc->clcsock->sk->sk_rcv_saddr;
 		r->id.idiag_dst[0] = smc->clcsock->sk->sk_daddr;
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.25.0.341.g760bfbb309-goog

