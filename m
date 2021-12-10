Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA7147040F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 16:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbhLJPpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbhLJPpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 10:45:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C476AC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 07:41:46 -0800 (PST)
Date:   Fri, 10 Dec 2021 16:41:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639150905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=55q71Ac1XS8sQfIoKaexOVqxKhcp5MXGhA2VcK/z6uI=;
        b=JSs/YSOnjPLI/c4DF5AB6CGu0i2Ij2RXPnjCiXftuRttTc4Ngk9M0o8QEpzU61VDglZwVl
        jnrUohEHfYwaIxiEQn2mWYSDKIvAX+yBIke5Fi+F6O+HReSixWfc7QPllZ9XLEhlbalMdj
        zzhcubnp2SbD00u+zgj0ngtpiC8An/5YqfAPvz2KwM/3jagyObtxdm7zIgRr8mDlrjW1F/
        Bv265ld1cKQcpPeoS791aLYnVNmLMysNuEoxPc01EZKps5lKWCT4jXT1XJS++kkRtdULLK
        U6a7XjYLN1ai/ACYb0WcOcNQB4IXenI5pzx9ps9GppuRRoexqbkASzZZOTn2fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639150905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=55q71Ac1XS8sQfIoKaexOVqxKhcp5MXGhA2VcK/z6uI=;
        b=FsbGpWV4gUpDSQ0akwiTfVlONeysi79Lyz8jF+fF209q1JlKk729w5Y7wxL2N9GdYGxIiD
        Dn6uO0pVSsxWimBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock in
 __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <YbN1OL0I1ja4Fwkb@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The root-lock is dropped before dev_hard_start_xmit() is invoked and after
setting the __QDISC___STATE_RUNNING bit. If the Qdisc owner is preempted
by another sender/task with a higher priority then this new sender won't
be able to submit packets to the NIC directly instead they will be
enqueued into the Qdisc. The NIC will remain idle until the Qdisc owner
is scheduled again and finishes the job.

By serializing every task on the ->busylock then the task will be
preempted by a sender only after the Qdisc has no owner.

Always serialize on the busylock on PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2a352e668d103..4a701cf2e2c10 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3836,8 +3836,16 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	 * separate lock before trying to get qdisc main lock.
 	 * This permits qdisc->running owner to get the lock more
 	 * often and dequeue packets faster.
+	 * On PREEMPT_RT it is possible to preempt the qdisc owner during xmit
+	 * and then other tasks will only enqueue packets. The packets will be
+	 * sent after the qdisc owner is scheduled again. To prevent this
+	 * scenario the task always serialize on the lock.
 	 */
-	contended = qdisc_is_running(q);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		contended = qdisc_is_running(q);
+	else
+		contended = true;
+
 	if (unlikely(contended))
 		spin_lock(&q->busylock);
 
-- 
2.34.1

