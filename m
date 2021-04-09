Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B35435A248
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhDIPt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDIPt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:49:58 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A54C061760;
        Fri,  9 Apr 2021 08:49:43 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m11so4495903pfc.11;
        Fri, 09 Apr 2021 08:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xHH7am/lvrcMVvHS3IG65IXeZaw+G+lRCAfJKJXQ5Ak=;
        b=iiiz8bhasod5v22D/048u4jpaHuVPSmWzqBdvUCb6HvjRMfVs0mMHd2isZ/RRmNllr
         op4xqTAhA4H3z6JhcwcPNTA3zgdBd2eEEr58C0dXXiYEyY39D0SweR/eWUyD0g5/BW7J
         AMszpliwby/yFBTGA/jSqR879jtfIJnMnXxXKL6BBHrRNxHhEuyWGBsiuKXunrvI1dhj
         C8hXJ3W8/KoGVmdKHYDCWGJDHP7O+fdIFt3w1MzR1hqoFPOjSIaTcjWqQUE2TAdGLc5J
         jTqZjVnV+IWhMaHLQoU1ps6S3PV/Pni0rHgiK+W/B+bOA5ut1DhZjHQpN6ihBEDboEaF
         wmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xHH7am/lvrcMVvHS3IG65IXeZaw+G+lRCAfJKJXQ5Ak=;
        b=SMH03y4+hib0WO2CmzcwzEx7fGn5hk5KaTJS5cxxwUIOz+1GODgi72WtHd3yXJrl/f
         JocjR5E/vdlJnYAHn0TYtDfwUqpcwjpmgEno6yrTn9phR+Wu9UQZeWehJVCM0V8H4oGk
         59/+AmoA3KI4frrDV2fInI5MM1as7ftaNbEuaCiBDVutXiavxHKU2DiDYbobTENLViHs
         lbmN+qYtI+i0dtBDuzHgRFxBfAU88U5FEH4ErvPhmj16SyvFns2TBdctyptedHFIyY7k
         UX6omyTM3tQmI4MpCdvFSOqUI8gSNm7PjfbTyODTy/F08/NGFBHY9H9J5gxhGlVft2K3
         ofzg==
X-Gm-Message-State: AOAM5313C/VFK5b8QB8oWNctHHFyw1K5lPPUbs0KSN6kEt7dv+0J9oVF
        wzFGJGNsBwMRwWq85qniMSHj4nmLJ5s=
X-Google-Smtp-Source: ABdhPJwx1E72+Q2aGbOcTkfSWo4lgw2AR5wBsnu+q6h0A60nbwnI9kCzBNzUZZeEaQx+O8dvffYtyA==
X-Received: by 2002:aa7:96d6:0:b029:23f:5b6b:3072 with SMTP id h22-20020aa796d60000b029023f5b6b3072mr13228722pfq.81.1617983383142;
        Fri, 09 Apr 2021 08:49:43 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:dbf:152b:ea58:1a81])
        by smtp.gmail.com with ESMTPSA id y2sm2912016pgp.2.2021.04.09.08.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 08:49:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Luigi Rizzo <lrizzo@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] netfilter: nft_limit: avoid possible divide error in nft_limit_init
Date:   Fri,  9 Apr 2021 08:49:39 -0700
Message-Id: <20210409154939.43020-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

div_u64() divides u64 by u32.

nft_limit_init() wants to divide u64 by u64, use the appropriate
math function (div64_u64)

divide error: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8390 Comm: syz-executor188 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:div_u64_rem include/linux/math64.h:28 [inline]
RIP: 0010:div_u64 include/linux/math64.h:127 [inline]
RIP: 0010:nft_limit_init+0x2a2/0x5e0 net/netfilter/nft_limit.c:85
Code: ef 4c 01 eb 41 0f 92 c7 48 89 de e8 38 a5 22 fa 4d 85 ff 0f 85 97 02 00 00 e8 ea 9e 22 fa 4c 0f af f3 45 89 ed 31 d2 4c 89 f0 <49> f7 f5 49 89 c6 e8 d3 9e 22 fa 48 8d 7d 48 48 b8 00 00 00 00 00
RSP: 0018:ffffc90009447198 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000200000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff875152e6 RDI: 0000000000000003
RBP: ffff888020f80908 R08: 0000200000000000 R09: 0000000000000000
R10: ffffffff875152d8 R11: 0000000000000000 R12: ffffc90009447270
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000097a300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200001c4 CR3: 0000000026a52000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2675 [inline]
 nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2713
 nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5160
 nf_tables_newset+0x1997/0x3150 net/netfilter/nf_tables_api.c:4321
 nfnetlink_rcv_batch+0x85a/0x21b0 net/netfilter/nfnetlink.c:456
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:580 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:598
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c26844eda9d4 ("netfilter: nf_tables: Fix nft limit burst handling")
Fixes: 3e0f64b7dd31 ("netfilter: nft_limit: fix packet ratelimiting")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Diagnosed-by: Luigi Rizzo <lrizzo@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/nft_limit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 0e2c315c3b5ed5503b93ea0972d06a111ca6a4ab..82ec27bdf94120f89c8c475f02e56d0d64f9e385 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -76,13 +76,13 @@ static int nft_limit_init(struct nft_limit *limit,
 		return -EOVERFLOW;
 
 	if (pkts) {
-		tokens = div_u64(limit->nsecs, limit->rate) * limit->burst;
+		tokens = div64_u64(limit->nsecs, limit->rate) * limit->burst;
 	} else {
 		/* The token bucket size limits the number of tokens can be
 		 * accumulated. tokens_max specifies the bucket size.
 		 * tokens_max = unit * (rate + burst) / rate.
 		 */
-		tokens = div_u64(limit->nsecs * (limit->rate + limit->burst),
+		tokens = div64_u64(limit->nsecs * (limit->rate + limit->burst),
 				 limit->rate);
 	}
 
-- 
2.31.1.295.g9ea45b61b8-goog

