Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63ADB121A2
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 20:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfEBSGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 14:06:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37676 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBSGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 14:06:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id g3so1513691pfi.4
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 11:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPMACVp79GS//al7ZHAcheTzC8tw3WbRMUcAunoVbxM=;
        b=oUVoMGz9zF/pPCKZMRozRdi18Af/VZkW5Z5l3h0cADJcE7RUGXoYdOLwOqkVk0rWHy
         NKadeCC54To4Dni6Yy5hoa9AH1V7UBl2N6dAQedGqfpXD9B9J4czPQcd4PI4NWhkDIrb
         1/5WLaj4VhjIGki7wU3hZrHisoK1ztKP+SECYoZ/1j6O+K4ZBQiDbG3NBQ/ARPnVrdzw
         ZLqLg8+BFUKQVeCRpjC6zql3u8At8tnja9mHeUEylQFobVw+cwB+ONkMVoj4sOOQgaP4
         vU0xbxra2nKAU5Zn5+JcztpwWb0bOPle2V087Xij0UM95oBcl4RG7xiZTYP16ZT3kC9j
         bBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPMACVp79GS//al7ZHAcheTzC8tw3WbRMUcAunoVbxM=;
        b=rMsajsV2anahqGJQVzwrYJE/s8SKVR8cbpe+XZZxO7vlycIdeZaTzsbbO8LVMhQUSv
         33oHrVv2HA8HPPamDwvi65ZOY8rXCDaNQs5wf/KlRF8+NOA3SVMA2TjY2xzcUWm044SM
         svT1SrMdpHZvUdfvbVjafGfFPM9Gg1oLhCa8fJ4PJTpTvURK4Ef6dgeOzyMFhxWTfzpg
         Tph4TIuLpXmMLAOBP8GVEjtGJsjUGiyuSvqLbDBv019MkrO8NWzAY2rdVGlny98HfyCZ
         ENSg2SR4f5ATGDoysP0sFvfMNqud39NRV5P+2e7BJIzDI0gh+6zP+xzAECx43sKTJNyS
         NgcA==
X-Gm-Message-State: APjAAAUUfPXNC/24/2wN1UjOc9/rAc/dv/FZ+5cq67QsVGl4w3po2JSe
        GnxwNbimRGPWjXX9ln48vN4OruQG
X-Google-Smtp-Source: APXvYqyjlKC8Jb0cZvrQAXqscd/bREzDEAE6lyFrc4Lh+O/xGgmuoo0Fm+SvtiRs9IN3VnwwQ2AZdg==
X-Received: by 2002:a65:60d0:: with SMTP id r16mr5197031pgv.229.1556820384536;
        Thu, 02 May 2019 11:06:24 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id n188sm36039462pfn.64.2019.05.02.11.06.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 11:06:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net-next] sch_htb: redefine htb qdisc overlimits
Date:   Thu,  2 May 2019 11:06:10 -0700
Message-Id: <20190502180610.10369-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 3c75f6ee139d ("net_sched: sch_htb: add per class overlimits counter")
we added an overlimits counter for each HTB class which could
properly reflect how many times we use up all the bandwidth
on each class. However, the overlimits counter in HTB qdisc
does not, it is way bigger than the sum of each HTB class.
In fact, this qdisc overlimits counter increases when we have
no skb to dequeue, which happens more often than we run out of
bandwidth.

It makes more sense to make this qdisc overlimits counter just
be a sum of each HTB class, in case people still get confused.

I have verified this patch with one single HTB class, where HTB
qdisc counters now always match HTB class counters as expected.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_htb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index d27d9bc9d010..cece0d455985 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -177,6 +177,7 @@ struct htb_sched {
 	int			row_mask[TC_HTB_MAXDEPTH];
 
 	struct htb_level	hlevel[TC_HTB_MAXDEPTH];
+	u32			overlimits;
 };
 
 /* find class in global hash table using given handle */
@@ -533,8 +534,10 @@ htb_change_class_mode(struct htb_sched *q, struct htb_class *cl, s64 *diff)
 	if (new_mode == cl->cmode)
 		return;
 
-	if (new_mode == HTB_CANT_SEND)
+	if (new_mode == HTB_CANT_SEND) {
 		cl->overlimits++;
+		q->overlimits++;
+	}
 
 	if (cl->prio_activity) {	/* not necessary: speed optimization */
 		if (cl->cmode != HTB_CANT_SEND)
@@ -937,7 +940,6 @@ static struct sk_buff *htb_dequeue(struct Qdisc *sch)
 				goto ok;
 		}
 	}
-	qdisc_qstats_overlimit(sch);
 	if (likely(next_event > q->now))
 		qdisc_watchdog_schedule_ns(&q->watchdog, next_event);
 	else
@@ -1048,6 +1050,7 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest;
 	struct tc_htb_glob gopt;
 
+	sch->qstats.overlimits = q->overlimits;
 	/* Its safe to not acquire qdisc lock. As we hold RTNL,
 	 * no change can happen on the qdisc parameters.
 	 */
-- 
2.20.1

