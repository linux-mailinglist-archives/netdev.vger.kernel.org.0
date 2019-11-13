Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13CFFA4C6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfKMCSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729264AbfKMBzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E822247D;
        Wed, 13 Nov 2019 01:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610149;
        bh=UOl0yxohjGVB5kn0B0kvKXhbib289mdwk/+Id492Zgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AO4fSVfrdxw/o3ms0W7AS739XhpAXG80qJzaUqvnMDFHtnd+Xvf/rwFFz+shT5wb
         wlKzJDvqBsTDJOpwF0Gc9L7lDlkBO09izYuIOpbGToayzBOMMVoOaDf7fCTd/0/QVS
         ctQ2b3w78RO5n2CpsqS5j+d+6PHxbVTqmJdhCO1A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 194/209] net: sched: avoid writing on noop_qdisc
Date:   Tue, 12 Nov 2019 20:50:10 -0500
Message-Id: <20191113015025.9685-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f98ebd47fd0da1717267ce1583a105d8cc29a16a ]

While noop_qdisc.gso_skb and noop_qdisc.skb_bad_txq are not used
in other places, it seems not correct to overwrite their fields
in dev_init_scheduler_queue().

noop_qdisc is essentially a shared and read-only object, even if
it is not marked as const because of some implementation detail.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 30e32df5f84a7..8a4d01e427a22 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -577,6 +577,18 @@ struct Qdisc noop_qdisc = {
 	.dev_queue	=	&noop_netdev_queue,
 	.running	=	SEQCNT_ZERO(noop_qdisc.running),
 	.busylock	=	__SPIN_LOCK_UNLOCKED(noop_qdisc.busylock),
+	.gso_skb = {
+		.next = (struct sk_buff *)&noop_qdisc.gso_skb,
+		.prev = (struct sk_buff *)&noop_qdisc.gso_skb,
+		.qlen = 0,
+		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.gso_skb.lock),
+	},
+	.skb_bad_txq = {
+		.next = (struct sk_buff *)&noop_qdisc.skb_bad_txq,
+		.prev = (struct sk_buff *)&noop_qdisc.skb_bad_txq,
+		.qlen = 0,
+		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.skb_bad_txq.lock),
+	},
 };
 EXPORT_SYMBOL(noop_qdisc);
 
@@ -1253,8 +1265,6 @@ static void dev_init_scheduler_queue(struct net_device *dev,
 
 	rcu_assign_pointer(dev_queue->qdisc, qdisc);
 	dev_queue->qdisc_sleeping = qdisc;
-	__skb_queue_head_init(&qdisc->gso_skb);
-	__skb_queue_head_init(&qdisc->skb_bad_txq);
 }
 
 void dev_init_scheduler(struct net_device *dev)
-- 
2.20.1

