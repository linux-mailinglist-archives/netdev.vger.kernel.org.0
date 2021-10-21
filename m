Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898EE435E7C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhJUKBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhJUKBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:01:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02023C06174E;
        Thu, 21 Oct 2021 02:59:23 -0700 (PDT)
Date:   Thu, 21 Oct 2021 11:59:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634810361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OL0pK6Dja6OFwt9P0STH6Hk8jRb77fx4V/3DfAlCWo0=;
        b=r1lvf6V5x2mK5X2V4JCDNxR5auizhnZfBhP2mBdfxThmqxVGpmWSSv4XBBcRhgcxoDmboj
        EHhfbmzy7Z9eOLDNuFYcxqjjDt9cR/WCXhlSO+mR9bOjRKFszXUvIWNRZe4jsg4ZPPZVCv
        N80EdD3728XW8algd6sZgRqZpeO/4Jciz0DgRXUbXMPsmGcIYC8suWTe0q5KqYv1G9EyY0
        Q2qmC4rUZTANCwfLhuRpHYxPcFmOHo5H7Rc9jl91y3yfvQJv8eUXUKdN0gicRv7qgQZ+M6
        koNGRsoUd8n1hMnQL9wvdmC9Hl9VS9QS/XFXVosNW1BUl6mMjQ0SXYgIjaouQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634810361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OL0pK6Dja6OFwt9P0STH6Hk8jRb77fx4V/3DfAlCWo0=;
        b=UQB6HYxcIOKLxWaoVFz9VyzWlzlDLqFogQlynBRAxMZ7DB7jUh84ay7K3of1ZgrazTK9VH
        dgVNE4puyyICrMDg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH net-next] net: stats: Read the statistics in
 ___gnet_stats_copy_basic() instead of adding.
Message-ID: <20211021095919.bi3szpt3c2kcoiso@linutronix.de>
References: <CA+G9fYu8oby3LZ732W5xR0VS0WZ8D1XFWOuP-Tu7wogULcuNCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYu8oby3LZ732W5xR0VS0WZ8D1XFWOuP-Tu7wogULcuNCA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the rework, the statistics code always adds up the byte and packet
value(s). On 32bit architectures a seqcount_t is used in
gnet_stats_basic_sync to ensure that the 64bit values are not modified
during the read since two 32bit loads are required. The usage of a
seqcount_t requires a lock to ensure that only one writer is active at a
time. This lock leads to disabled preemption during the update.

The lack of disabling preemption is now creating a warning as reported
by Naresh since the query done by gnet_stats_copy_basic() is in
preemptible context.

For ___gnet_stats_copy_basic() there is no need to disable preemption
since the update is performed on stack and can't be modified by another
writer. Instead of disabling preemption, to avoid the warning,
simply create a read function to just read the values and return as u64.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 67c9e6270f301 ("net: sched: Protect Qdisc::bstats with u64_stats")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/gen_stats.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 15c270e22c5ef..a10335b4ba2d0 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -171,20 +171,51 @@ void gnet_stats_add_basic(struct gnet_stats_basic_sync *bstats,
 }
 EXPORT_SYMBOL(gnet_stats_add_basic);
 
+static void gnet_stats_read_basic(u64 *ret_bytes, u64 *ret_packets,
+				  struct gnet_stats_basic_sync __percpu *cpu,
+				  struct gnet_stats_basic_sync *b, bool running)
+{
+	unsigned int start;
+
+	if (cpu) {
+		u64 t_bytes = 0, t_packets = 0;
+		int i;
+
+		for_each_possible_cpu(i) {
+			struct gnet_stats_basic_sync *bcpu = per_cpu_ptr(cpu, i);
+			unsigned int start;
+			u64 bytes, packets;
+
+			do {
+				start = u64_stats_fetch_begin_irq(&bcpu->syncp);
+				bytes = u64_stats_read(&bcpu->bytes);
+				packets = u64_stats_read(&bcpu->packets);
+			} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
+
+			t_bytes += bytes;
+			t_packets += packets;
+		}
+		*ret_bytes = t_bytes;
+		*ret_packets = t_packets;
+		return;
+	}
+	do {
+		if (running)
+			start = u64_stats_fetch_begin_irq(&b->syncp);
+		*ret_bytes = u64_stats_read(&b->bytes);
+		*ret_packets = u64_stats_read(&b->packets);
+	} while (running && u64_stats_fetch_retry_irq(&b->syncp, start));
+}
+
 static int
 ___gnet_stats_copy_basic(struct gnet_dump *d,
 			 struct gnet_stats_basic_sync __percpu *cpu,
 			 struct gnet_stats_basic_sync *b,
 			 int type, bool running)
 {
-	struct gnet_stats_basic_sync bstats;
 	u64 bstats_bytes, bstats_packets;
 
-	gnet_stats_basic_sync_init(&bstats);
-	gnet_stats_add_basic(&bstats, cpu, b, running);
-
-	bstats_bytes = u64_stats_read(&bstats.bytes);
-	bstats_packets = u64_stats_read(&bstats.packets);
+	gnet_stats_read_basic(&bstats_bytes, &bstats_packets, cpu, b, running);
 
 	if (d->compat_tc_stats && type == TCA_STATS_BASIC) {
 		d->tc_stats.bytes = bstats_bytes;
-- 
2.33.0

