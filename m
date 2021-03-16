Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB0833D239
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhCPK5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:57:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41406 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbhCPK4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 06:56:37 -0400
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615892196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IZFIyq8QjO9IzJy8ERce9DkaIJm6FXVDllpVcmz2698=;
        b=3cQb/UKFQzVceWYunxv/539OJlsv9KqR6v+S9WfYStOHwe5VwidNZBY/LjHG7JF1KBCCPn
        h+5Gb5HMmuli33sCRIvoOJmCAxqVWpLNOiVnxnqWPStg1BV0NFr+GTY266tLxC1ch2DqTK
        t27TXaaY40i8TID7lSjiY10+dR5vtDJqqKkWqeN0jyj2IB7NT4GRBbWQxJyQAX0ifOQXmx
        lb4ihbq9JU8KprnBpRcSgY6VIW3n4SqGuwmlix6+NaMvhrMOS/rJeg/SC6rllR+xetfAWP
        Yd6cc2vcXoWrBe5L8RnOVclqENY6iEQ22AwD2lmlzKH0KQYg0vEzneVeHl/3UA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615892196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IZFIyq8QjO9IzJy8ERce9DkaIJm6FXVDllpVcmz2698=;
        b=jup7JqZFX9R26g4yCTjfDwWRyJXYL84hHA9HOsxdZr2MBMNmV13fwc1HB7bTSzhY8srzdr
        ngwNEk0ge7oknUCQ==
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <sebastian.siewior@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v1 2/2] net: xfrm: Use sequence counter with associated spinlock
Date:   Tue, 16 Mar 2021 11:56:30 +0100
Message-Id: <20210316105630.1020270-3-a.darwish@linutronix.de>
In-Reply-To: <20210316105630.1020270-1-a.darwish@linutronix.de>
References: <20210316105630.1020270-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sequence counter write section must be serialized or its internal
state can get corrupted. A plain seqcount_t does not contain the
information of which lock must be held to guaranteee write side
serialization.

For xfrm_state_hash_generation, use seqcount_spinlock_t instead of plain
seqcount_t.  This allows to associate the spinlock used for write
serialization with the sequence counter. It thus enables lockdep to
verify that the write serialization lock is indeed held before entering
the sequence counter write section.

If lockdep is disabled, this lock association is compiled out and has
neither storage size nor runtime overhead.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 include/net/netns/xfrm.h | 2 +-
 net/xfrm/xfrm_state.c    | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index b59d73d529ba..e816b6a3ef2b 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -73,7 +73,7 @@ struct netns_xfrm {
 	struct dst_ops		xfrm6_dst_ops;
 #endif
 	spinlock_t		xfrm_state_lock;
-	seqcount_t		xfrm_state_hash_generation;
+	seqcount_spinlock_t	xfrm_state_hash_generation;
 
 	spinlock_t xfrm_policy_lock;
 	struct mutex xfrm_cfg_mutex;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ffd315cff984..4496f7efa220 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2665,7 +2665,8 @@ int __net_init xfrm_state_init(struct net *net)
 	net->xfrm.state_num = 0;
 	INIT_WORK(&net->xfrm.state_hash_work, xfrm_hash_resize);
 	spin_lock_init(&net->xfrm.xfrm_state_lock);
-	seqcount_init(&net->xfrm.xfrm_state_hash_generation);
+	seqcount_spinlock_init(&net->xfrm.xfrm_state_hash_generation,
+			       &net->xfrm.xfrm_state_lock);
 	return 0;
 
 out_byspi:
-- 
2.30.2

