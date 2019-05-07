Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC971593C
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfEGFfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbfEGFfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:35:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65D6E21479;
        Tue,  7 May 2019 05:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207304;
        bh=1vZz/Jewo+yp+EJ+sf4G3CsR6Ir32kRIJt59tst0XvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL3K71XyVn70krjcS8SQ8hEjtv3rUIGiuAf58UVEP60krtzR9qiKiaWeDfoDmRUnK
         2f4npxtuSHBwryW7Qws72n8Hcg365djF/fTMbHFwbMEDbTA9sqN/SAL4ap8ttdJ9L+
         UHfnCBLzBLrQmtRKwqEPN3PRXZwyoYfNSPn4t7Ww=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Michal Soltys <soltys@ziu.info>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 74/99] netfilter: never get/set skb->tstamp
Date:   Tue,  7 May 2019 01:32:08 -0400
Message-Id: <20190507053235.29900-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 916f6efae62305796e012e7c3a7884a267cbacbf ]

setting net.netfilter.nf_conntrack_timestamp=1 breaks xmit with fq
scheduler.  skb->tstamp might be "refreshed" using ktime_get_real(),
but fq expects CLOCK_MONOTONIC.

This patch removes all places in netfilter that check/set skb->tstamp:

1. To fix the bogus "start" time seen with conntrack timestamping for
   outgoing packets, never use skb->tstamp and always use current time.
2. In nfqueue and nflog, only use skb->tstamp for incoming packets,
   as determined by current hook (prerouting, input, forward).
3. xt_time has to use system clock as well rather than skb->tstamp.
   We could still use skb->tstamp for prerouting/input/foward, but
   I see no advantage to make this conditional.

Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Cc: Eric Dumazet <edumazet@google.com>
Reported-by: Michal Soltys <soltys@ziu.info>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c |  7 ++-----
 net/netfilter/nfnetlink_log.c     |  2 +-
 net/netfilter/nfnetlink_queue.c   |  2 +-
 net/netfilter/xt_time.c           | 23 ++++++++++++++---------
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1982faf21ebb..d7ac2f82bb6d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -983,12 +983,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 	/* set conntrack timestamp, if enabled. */
 	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp) {
-		if (skb->tstamp == 0)
-			__net_timestamp(skb);
+	if (tstamp)
+		tstamp->start = ktime_get_real_ns();
 
-		tstamp->start = ktime_to_ns(skb->tstamp);
-	}
 	/* Since the lookup is lockless, hash insertion must be done after
 	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
 	 * guarantee that no other CPU can find the conntrack before the above
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b1f9c5303f02..0b3347570265 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -540,7 +540,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			goto nla_put_failure;
 	}
 
-	if (skb->tstamp) {
+	if (hooknum <= NF_INET_FORWARD && skb->tstamp) {
 		struct nfulnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(skb->tstamp);
 		ts.sec = cpu_to_be64(kts.tv_sec);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0dcc3592d053..e057b2961d31 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -582,7 +582,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (nfqnl_put_bridge(entry, skb) < 0)
 		goto nla_put_failure;
 
-	if (entskb->tstamp) {
+	if (entry->state.hook <= NF_INET_FORWARD && entskb->tstamp) {
 		struct nfqnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(entskb->tstamp);
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index c13bcd0ab491..8dbb4d48f2ed 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -163,19 +163,24 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	s64 stamp;
 
 	/*
-	 * We cannot use get_seconds() instead of __net_timestamp() here.
+	 * We need real time here, but we can neither use skb->tstamp
+	 * nor __net_timestamp().
+	 *
+	 * skb->tstamp and skb->skb_mstamp_ns overlap, however, they
+	 * use different clock types (real vs monotonic).
+	 *
 	 * Suppose you have two rules:
-	 * 	1. match before 13:00
-	 * 	2. match after 13:00
+	 *	1. match before 13:00
+	 *	2. match after 13:00
+	 *
 	 * If you match against processing time (get_seconds) it
 	 * may happen that the same packet matches both rules if
-	 * it arrived at the right moment before 13:00.
+	 * it arrived at the right moment before 13:00, so it would be
+	 * better to check skb->tstamp and set it via __net_timestamp()
+	 * if needed.  This however breaks outgoing packets tx timestamp,
+	 * and causes them to get delayed forever by fq packet scheduler.
 	 */
-	if (skb->tstamp == 0)
-		__net_timestamp((struct sk_buff *)skb);
-
-	stamp = ktime_to_ns(skb->tstamp);
-	stamp = div_s64(stamp, NSEC_PER_SEC);
+	stamp = get_seconds();
 
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		/* Adjust for local timezone */
-- 
2.20.1

