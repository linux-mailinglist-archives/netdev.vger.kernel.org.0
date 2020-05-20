Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC721DB228
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETLp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:45:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65407 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETLp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:45:59 -0400
Received: from fsav109.sakura.ne.jp (fsav109.sakura.ne.jp [27.133.134.236])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 04KBjaVW034253;
        Wed, 20 May 2020 20:45:36 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav109.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp);
 Wed, 20 May 2020 20:45:36 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 04KBjU9E034122
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 20 May 2020 20:45:36 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>
Cc:     netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] tipc: Disable preemption when calling send_msg method.
Date:   Wed, 20 May 2020 20:45:29 +0900
Message-Id: <20200520114529.3433-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 2.18.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting that tipc_udp_send_msg() is calling dst_cache_get()
without preemption disabled [1]. Since b->media->send_msg() is called
with RCU lock already held, we can also disable preemption at that point.

[1] https://syzkaller.appspot.com/bug?id=dc6352b92862eb79373fe03fdf9af5928753e057

Reported-by: syzbot+1a68504d96cd17b33a05@syzkaller.appspotmail.com
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 net/tipc/bearer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 34ca7b789eba..e5cf91665881 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -516,6 +516,7 @@ void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
 	struct tipc_msg *hdr = buf_msg(skb);
 	struct tipc_bearer *b;
 
+	preempt_disable();
 	rcu_read_lock();
 	b = bearer_get(net, bearer_id);
 	if (likely(b && (test_bit(0, &b->up) || msg_is_reset(hdr)))) {
@@ -528,6 +529,7 @@ void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
 		kfree_skb(skb);
 	}
 	rcu_read_unlock();
+	preempt_enable();
 }
 
 /* tipc_bearer_xmit() -send buffer to destination over bearer
@@ -543,6 +545,7 @@ void tipc_bearer_xmit(struct net *net, u32 bearer_id,
 	if (skb_queue_empty(xmitq))
 		return;
 
+	preempt_disable();
 	rcu_read_lock();
 	b = bearer_get(net, bearer_id);
 	if (unlikely(!b))
@@ -560,6 +563,7 @@ void tipc_bearer_xmit(struct net *net, u32 bearer_id,
 		}
 	}
 	rcu_read_unlock();
+	preempt_enable();
 }
 
 /* tipc_bearer_bc_xmit() - broadcast buffers to all destinations
@@ -574,6 +578,7 @@ void tipc_bearer_bc_xmit(struct net *net, u32 bearer_id,
 	struct sk_buff *skb, *tmp;
 	struct tipc_msg *hdr;
 
+	preempt_disable();
 	rcu_read_lock();
 	b = bearer_get(net, bearer_id);
 	if (unlikely(!b || !test_bit(0, &b->up)))
@@ -591,6 +596,7 @@ void tipc_bearer_bc_xmit(struct net *net, u32 bearer_id,
 			b->media->send_msg(net, skb, b, dst);
 	}
 	rcu_read_unlock();
+	preempt_enable();
 }
 
 /**
-- 
2.18.2

