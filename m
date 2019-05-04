Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246CC13BC8
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 20:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEDSnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 14:43:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43944 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfEDSnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 14:43:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id e67so4561650pfe.10
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 11:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=67EI03GUe5oPsSIfT/y8T5nqWWy3roMf0sW2glZKISc=;
        b=Nr7jkTnLyNQSDgXiiBNSfcgZUE6gAGynaQXj4tnSpCy8/9vRJkzSzofbc2u2qogNHT
         2p3BJOMR0gcQI8ub5w86MK6lPgaeruk0BibTn2z4WjJSItxsc7ug5p4PZTvv6tOIn++y
         XEC4FaSG88TnvZPJSBYochvowcohBRD4V2p6HZ1hrlgN9DG/BIrisVZC5iITs8fXwMTF
         +snc240/Z26VFc2QUKPqO8nEUC4I5zhs2GlfHI9mHOwHxDjbeukwN7i+Ai3r2m1c6MZ9
         Cvqnv6zXBeubo9dcePVU1hW8vAUZdN4RlEXhyaC26JIkFgKkFym0kFYx3jsptGm7ie02
         3eFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=67EI03GUe5oPsSIfT/y8T5nqWWy3roMf0sW2glZKISc=;
        b=Lm70xpZikGkxmiuJI5nyOVXD8J5zLs6FJ2kXWRxVDgT04EgBxnhmbmFt6xvUK4cfSc
         UFbgrlM61CWT4tGU63tRNVJU5eBZGAoOC1u+oxABOpiCe6yZP909oiBc5ulLg/J+XDJu
         li7v7fEMP176dO1hZ4nOykgtp+3pA03TWOssg30PpJXwt4DGseR945M0NAJbTCWT3NXX
         85Ls/miyUPD8FjFJMFJDZxq+sLzpfrTbrDhasDAulyvvf6r7L7pSlE7L2UurxzyyoYMP
         hcyEH1URXJeMfeTT7g3I6MLNTgaXHXFo+V0FidNWuYM2w0GyShzqAfPcWaHnkmpp2Iht
         29bQ==
X-Gm-Message-State: APjAAAXzfDIj9sgaVnpQMjo9Z9RFxLbrrru/ho+K3rocZLbQTn9OizUs
        uVrTe9qSjaBzX12UZ7ahTEOB8ygB
X-Google-Smtp-Source: APXvYqymC5QYgriCRCx5xrrLliYFV96hXINAnHS/t4vJr5Hws9kZpHOYZmpsV1hBiOuZiom7hWL/Ow==
X-Received: by 2002:a65:5c8c:: with SMTP id a12mr20468952pgt.452.1556995429947;
        Sat, 04 May 2019 11:43:49 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id d67sm11032002pfa.35.2019.05.04.11.43.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 11:43:48 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net-next v2] sch_htb: redefine htb qdisc overlimits
Date:   Sat,  4 May 2019 11:43:42 -0700
Message-Id: <20190504184342.1094-1-xiyou.wangcong@gmail.com>
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

Eric suggested we could fold this field into 'direct_pkts' as
we only use its 32bit on 64bit CPU, this saves one cache line.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_htb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index d27d9bc9d010..909370049fca 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -165,7 +165,8 @@ struct htb_sched {
 
 	/* non shaped skbs; let them go directly thru */
 	struct qdisc_skb_head	direct_queue;
-	long			direct_pkts;
+	u32			direct_pkts;
+	u32			overlimits;
 
 	struct qdisc_watchdog	watchdog;
 
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

