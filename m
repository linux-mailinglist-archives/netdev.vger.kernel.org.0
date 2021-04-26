Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25EB36B60F
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhDZPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:46:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233923AbhDZPq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619451976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7vBOvHcHI2oZqmZM5Aa2gGUzST69IcIGKxor2uO4AfE=;
        b=dLMOnbbZZ2GgAPal4swKuz4Q8Oz2pm6RioPZ8PArpY6yfbCHJ2AuUgZhOOX1EsCCiLmIxF
        t/qENffm2gozl2QCDggaHCIKTaRgDHfLcpFuMnlCWN0IeNYZK3jpsYxf0/ySk7WQ3cFVPU
        LXP8VPzpeINTWFLpCtZV7vh9+F5TWrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-n4gEKu0mPo6RUeBd7L0vOw-1; Mon, 26 Apr 2021 11:46:12 -0400
X-MC-Unique: n4gEKu0mPo6RUeBd7L0vOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67B2A195D56E;
        Mon, 26 Apr 2021 15:46:04 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.192.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91D85610A8;
        Mon, 26 Apr 2021 15:46:01 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Shuang Li <shuali@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net/sched: act_ct: fix wild memory access when clearing fragments
Date:   Mon, 26 Apr 2021 17:45:51 +0200
Message-Id: <a72b5a4239942c5cc0152e4efba17b544a8a19fb.1619450967.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

while testing re-assembly/re-fragmentation using act_ct, it's possible to
observe a crash like the following one:

 KASAN: maybe wild-memory-access in range [0x0001000000000448-0x000100000000044f]
 CPU: 50 PID: 0 Comm: swapper/50 Tainted: G S                5.12.0-rc7+ #424
 Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.4.3 01/17/2017
 RIP: 0010:inet_frag_rbtree_purge+0x50/0xc0
 Code: 00 fc ff df 48 89 c3 31 ed 48 89 df e8 a9 7a 38 ff 4c 89 fe 48 89 df 49 89 c6 e8 5b 3a 38 ff 48 8d 7b 40 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00 75 59 48 8d bb d0 00 00 00 4c 8b 6b 40 48 89 f8 48
 RSP: 0018:ffff888c31449db8 EFLAGS: 00010203
 RAX: 0000200000000089 RBX: 000100000000040e RCX: ffffffff989eb960
 RDX: 0000000000000140 RSI: ffffffff97cfb977 RDI: 000100000000044e
 RBP: 0000000000000900 R08: 0000000000000000 R09: ffffed1186289350
 R10: 0000000000000003 R11: ffffed1186289350 R12: dffffc0000000000
 R13: 000100000000040e R14: 0000000000000000 R15: ffff888155e02160
 FS:  0000000000000000(0000) GS:ffff888c31440000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005600cb70a5b8 CR3: 0000000a2c014005 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  inet_frag_destroy+0xa9/0x150
  call_timer_fn+0x2d/0x180
  run_timer_softirq+0x4fe/0xe70
  __do_softirq+0x197/0x5a0
  irq_exit_rcu+0x1de/0x200
  sysvec_apic_timer_interrupt+0x6b/0x80
  </IRQ>

when act_ct temporarily stores an IP fragment, restoring the skb qdisc cb
results in putting random data in FRAG_CB(), and this causes those "wild"
memory accesses later, when the rbtree is purged. Never overwrite the skb
cb in case tcf_ct_handle_fragments() returns -EINPROGRESS.

Fixes: ae372cb1750f ("net/sched: act_ct: fix restore the qdisc_skb_cb after defrag")
Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_ct.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 16e888a9601d..48fdf7293dea 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -732,7 +732,8 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 #endif
 	}
 
-	*qdisc_skb_cb(skb) = cb;
+	if (err != -EINPROGRESS)
+		*qdisc_skb_cb(skb) = cb;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -967,7 +968,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	err = tcf_ct_handle_fragments(net, skb, family, p->zone, &defrag);
 	if (err == -EINPROGRESS) {
 		retval = TC_ACT_STOLEN;
-		goto out;
+		goto out_clear;
 	}
 	if (err)
 		goto drop;
@@ -1030,7 +1031,6 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-out:
 	qdisc_skb_cb(skb)->post_ct = true;
 out_clear:
 	tcf_action_update_bstats(&c->common, skb);
-- 
2.30.2

