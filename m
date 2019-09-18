Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612FDB6D10
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 21:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732149AbfIRT5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 15:57:19 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:41302 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731334AbfIRT5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 15:57:19 -0400
Received: by mail-ua1-f74.google.com with SMTP id p9so339360uar.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 12:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qj/PWOX8PXx3eMIU0mtkJzRF48BxrlQuVs41FPZOFko=;
        b=B+8ZIb24Felr0ZfdRZEQv+khxUihd/4UxZcGRP/LAi7g3+FmzRM+Km7E4Gl/4ECy3W
         R1Y2QwI2m0i2z1n0OgUpYgLafBSa5vp54C15VZppDqEEsUWxUziMSqmQ0bfCH4kfuKpD
         l63jv5whtAVONSYTls2Ylde1dJbnwjX6Ac1HPqXaMZJf/PBTUAwGQMYR8Q+QR6hHVqoP
         ZvYLHW/zloPNBJz5EUyyrIwZuLCNn/btqz82+LdfL+9Kv2Js3az/tMs3y1b5KPdlwO8y
         BT2xJFC8+o0s8gaV0WkCxMb4t9yZNtVdqTT1FzWZj/8EQ8w4GJHiZvdXq+WVG6igp0bl
         WW1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qj/PWOX8PXx3eMIU0mtkJzRF48BxrlQuVs41FPZOFko=;
        b=iUlSVUWT7TcoumSTiIEqImLyapinjnJVXU7TfBFyisypDqO69eEXsvrDa2w+4jlpEy
         UjfSS7hkPpayAoEfMgLAc7cY7iX3LnllWcF/YNFMZwA0bf9WodnWHoKvY2/5w2V4b5D+
         3G6MoLLG88bxbTg148p23E1y5dcK5W/cBjUNufWhukQ4HpswsCYlh2jgpkFLz0Oz+dY/
         5JEYG+W1XlJoll9YTtekoVBqNYvxGXtMAPNUlDeR8M4vGJ+3weLSbD5EHAyRpkHEaJqa
         YSjkyQZsI3iMNssLI5JkdXei2cNqLrbMIBylLYlPEtjL/DzcKQNv3jR0Evz7b5LRsPsr
         IsEg==
X-Gm-Message-State: APjAAAVs2ddj4w3+sC0PrhbWJZBjbSv9W4xQiMvZkpeXSGkKEZGdfDo5
        aEJmWeZw9zbFDFZIR+YRQYe3ZENat1YAPw==
X-Google-Smtp-Source: APXvYqzcen0bPRNPlFFs1mEzLXs2VfD+SXGgItfbyfq2mAdXJRRm3KEv1DJBh/yFRgynTXL2hLLi+aCndfjahA==
X-Received: by 2002:a67:db93:: with SMTP id f19mr3267338vsk.49.1568836637904;
 Wed, 18 Sep 2019 12:57:17 -0700 (PDT)
Date:   Wed, 18 Sep 2019 12:57:04 -0700
Message-Id: <20190918195704.218413-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH net] net: sched: fix possible crash in tcf_action_destroy()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the allocation done in tcf_exts_init() failed,
we end up with a NULL pointer in exts->actions.

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8198 Comm: syz-executor.3 Not tainted 5.3.0-rc8+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_action_destroy+0x71/0x160 net/sched/act_api.c:705
Code: c3 08 44 89 ee e8 4f cb bb fb 41 83 fd 20 0f 84 c9 00 00 00 e8 c0 c9 bb fb 48 89 d8 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <80> 3c 08 00 0f 85 c0 00 00 00 4c 8b 33 4d 85 f6 0f 84 9d 00 00 00
RSP: 0018:ffff888096e16ff0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: 0000000000040000 RSI: ffffffff85b6ab30 RDI: 0000000000000000
RBP: ffff888096e17020 R08: ffff8880993f6140 R09: fffffbfff11cae67
R10: fffffbfff11cae66 R11: ffffffff88e57333 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888096e177a0 R15: 0000000000000001
FS:  00007f62bc84a700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000758040 CR3: 0000000088b64000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcf_exts_destroy+0x38/0xb0 net/sched/cls_api.c:3030
 tcindex_set_parms+0xf7f/0x1e50 net/sched/cls_tcindex.c:488
 tcindex_change+0x230/0x318 net/sched/cls_tcindex.c:519
 tc_new_tfilter+0xa4b/0x1c70 net/sched/cls_api.c:2152
 rtnetlink_rcv_msg+0x838/0xb00 net/core/rtnetlink.c:5214
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
 __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]

Fixes: 90b73b77d08e ("net: sched: change action API to use array of pointers to actions")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/cls_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index efd3cfb80a2ad775dc8ab3c4900bd73d52c7aaad..9aef93300f1c11791acbb9262dfe77996872eafe 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3027,8 +3027,10 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 void tcf_exts_destroy(struct tcf_exts *exts)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
-	kfree(exts->actions);
+	if (exts->actions) {
+		tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
+		kfree(exts->actions);
+	}
 	exts->nr_actions = 0;
 #endif
 }
-- 
2.23.0.237.gc6a4ce50a0-goog

