Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D582904E7
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407395AbgJPMSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407387AbgJPMSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:18:11 -0400
X-Greylist: delayed 455 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Oct 2020 05:18:10 PDT
Received: from forward104p.mail.yandex.net (forward104p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92919C061755;
        Fri, 16 Oct 2020 05:18:10 -0700 (PDT)
Received: from mxback21j.mail.yandex.net (mxback21j.mail.yandex.net [IPv6:2a02:6b8:0:1619::221])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 9A54B4B01C6D;
        Fri, 16 Oct 2020 15:10:33 +0300 (MSK)
Received: from iva6-2d18925256a6.qloud-c.yandex.net (iva6-2d18925256a6.qloud-c.yandex.net [2a02:6b8:c0c:7594:0:640:2d18:9252])
        by mxback21j.mail.yandex.net (mxback/Yandex) with ESMTP id bmeH7k81eS-AWEWY0Po;
        Fri, 16 Oct 2020 15:10:33 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1602850233;
        bh=TdL1UjfRFoVfBC9zIYZuV9TNWFx2bflF7mNPxJ/0RP4=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=qLlJlSVCMyjBvsN7nu3GaXATCGTg/5Tv3aZh7md0lxF1URjqMZt+PNejoNPd9EwD4
         TzPbjkUF+oDO+3R8lgmvifnOKD97GNwaNKss6dX1bHTL40zcMV9vE7AxoDgVmqHT/t
         o7uyS7dYvmdRVkNNNTja3y9EL5joePCyQcLzTw/A=
Authentication-Results: mxback21j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva6-2d18925256a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id NJraWbc8kA-AVnW2qeE;
        Fri, 16 Oct 2020 15:10:32 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Aleksandr Nogikh <a.nogikh@yandex.ru>
To:     stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org
Cc:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        rdunlap@infradead.org, dave.taht@gmail.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksandr Nogikh <nogikh@google.com>,
        syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com
Subject: [PATCH] netem: prevent division by zero in tabledist
Date:   Fri, 16 Oct 2020 12:10:07 +0000
Message-Id: <20201016121007.2378114-1-a.nogikh@yandex.ru>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Currently it is possible to craft a special netlink RTM_NEWQDISC
command that result in jitter being equal to 0x80000000. It is enough
to set 32 bit jitter to 0x02000000 (it will later be multiplied by
2^6) or set 64 bit jitter via TCA_NETEM_JITTER64. This causes an
overflow during the generation of uniformly districuted numbers in
tabledist, which in turn leads to division by zero (sigma != 0, but
sigma * 2 is 0).

The related fragment of code needs 32-bit division - see commit
9b0ed89 ("netem: remove unnecessary 64 bit modulus"), so
switching to 64 bit is not an option.

Fix the issue by preventing 32 bit integer overflows in
tabledist. Also, instead of truncating s64 integer to s32, truncate it
to u32, as negative standard deviation does not make sense anyway.

Reported-by: syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
 net/sched/sch_netem.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 84f82771cdf5..d8b0bf1b5346 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -315,7 +315,7 @@ static bool loss_event(struct netem_sched_data *q)
  * std deviation sigma.  Uses table lookup to approximate the desired
  * distribution, and a uniformly-distributed pseudo-random source.
  */
-static s64 tabledist(s64 mu, s32 sigma,
+static s64 tabledist(s64 mu, u32 sigma,
 		     struct crndstate *state,
 		     const struct disttable *dist)
 {
@@ -329,8 +329,14 @@ static s64 tabledist(s64 mu, s32 sigma,
 	rnd = get_crandom(state);
 
 	/* default uniform distribution */
-	if (dist == NULL)
+	if (!dist) {
+		/* Sigma is too big to perform 32 bit division.
+		 * Use the widest possible deviation.
+		 */
+		if ((u64)sigma * 2ULL >= U32_MAX)
+			return mu + rnd - U32_MAX / 2;
 		return ((rnd % (2 * sigma)) + mu) - sigma;
+	}
 
 	t = dist->table[rnd % dist->size];
 	x = (sigma % NETEM_DIST_SCALE) * t;
@@ -533,7 +539,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		u64 now;
 		s64 delay;
 
-		delay = tabledist(q->latency, q->jitter,
+		/* tabledist is unable to handle 64 bit jitters yet, so we adjust it beforehand */
+		u32 constrained_jitter = q->jitter > 0 ? min_t(u32, q->jitter, U32_MAX) : 0;
+
+		delay = tabledist(q->latency, constrained_jitter,
 				  &q->delay_cor, q->delay_dist);
 
 		now = ktime_get_ns();

base-commit: bbf5c979011a099af5dc76498918ed7df445635b
-- 
2.29.0.rc1.297.gfa9743e501-goog

