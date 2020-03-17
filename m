Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE311877BC
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 03:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgCQCNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 22:13:06 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:54186 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgCQCNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 22:13:06 -0400
Received: by mail-pl1-f201.google.com with SMTP id 2so11569529plb.20
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 19:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1hxOBIFOjPi7XWaz64ZUr6KOiu5/WGzYkl5zuVL/Og0=;
        b=PcNmOhwLDmbfV7lD2VJicKtN9BhWDWd2FxBtuyUedCFSyNuKkUNsZNpusVXd4UHLvx
         90CxRsGU0nDeHcTuYzowuh7y7ambJwNcHA8nAtQIwfmDeNzeWZQeAtUSMFhujDsOmIDi
         cTYbiACjnm4OC5RKzssE7COr9fb1tBbtHaF9VJGzxLiHZnsFUS6YTea97qRVwjAp/zwT
         At87Ut+k8I1VhArNs6qamUbfdRyhZXIsXzGeXCJIJrNu2sOrZKOZRTDIU/bu7lk1I5ox
         9dGK4/lblM0VPRqXTdzE3GWWUjrHSQ6YMjSBEI+L2CoIuPsm7r01EsatfnhHxAkLd1qE
         +QKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1hxOBIFOjPi7XWaz64ZUr6KOiu5/WGzYkl5zuVL/Og0=;
        b=oTvqyIj6doKJFVQhL9bBpAl7fAGVVJyPpURfsL82J1GQjtic2hig3GWFHdrsEzJTvo
         HWzginpGkfvQ41WGV6lnea+IxXGRAmTJmxw/UV3xdiODIL/HbL//jdvKo9Gb8p0loA/K
         RgHGWZuLHzTJg/6s0ocIa1jcHqrJSYIF1cB6WSoEj3pvzdibkoigLOrPfAVLjKljC2eJ
         MZq7VgQGYeEXLmeOwzuu7R5/ndgD9AuA2YnOMsKK5kvxtxN1w8pBcAl0bkVT4bDAUVM9
         zk67hcwFyNEwOKkAv+F18Wm/4S91KiJbJNqH6a74z//XKFuyWyt6hWqrl+6J9OKHLKE9
         1G9Q==
X-Gm-Message-State: ANhLgQ1UdUE2wmwEqRXIiGl7+jyMCjWJKEfa6lde87RkwSc4QRVgcFLn
        EbOdLNbiSTHsn1zLsvnvN2XLFVSUx6dIQw==
X-Google-Smtp-Source: ADFU+vuPWCMTns2G6MGij8x78H74ckO1RwqsbVpOsbYYK5b3bHCvxUMYXruTPHIRLaky2r2pXFQ17R0aVU1qpQ==
X-Received: by 2002:a63:3d44:: with SMTP id k65mr2813506pga.349.1584411183135;
 Mon, 16 Mar 2020 19:13:03 -0700 (PDT)
Date:   Mon, 16 Mar 2020 19:12:51 -0700
In-Reply-To: <20200317021251.75190-1-edumazet@google.com>
Message-Id: <20200317021251.75190-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200317021251.75190-1-edumazet@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v2 net-next 3/3] net_sched: sch_fq: enable use of hrtimer slack
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new attribute to control the fq qdisc hrtimer slack.

Default is set to 10 usec.

When/if packets are throttled, fq set up an hrtimer that can
lead to one interrupt per packet in the throttled queue.

By using a timer slack, we allow better use of timer interrupts,
by giving them a chance to call multiple timer callbacks
at each hardware interrupt.

Also, giving a slack allows FQ to dequeue batches of packets
instead of a single one, thus increasing xmit_more efficiency.

This has no negative effect on the rate a TCP flow can sustain,
since each TCP flow maintains its own precise vtime (tp->tcp_wstamp_ns)

v2: added strict netlink checking (as feedback from Jakub Kicinski)

Tested:
 1000 concurrent flows all using paced packets.
 1,000,000 packets sent per second.

Before the patch :

$ vmstat 2 10
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 60726784  23628 3485992    0    0   138     1  977  535  0 12 87  0  0
 0  0      0 60714700  23628 3485628    0    0     0     0 1568827 26462  0 22 78  0  0
 1  0      0 60716012  23628 3485656    0    0     0     0 1570034 26216  0 22 78  0  0
 0  0      0 60722420  23628 3485492    0    0     0     0 1567230 26424  0 22 78  0  0
 0  0      0 60727484  23628 3485556    0    0     0     0 1568220 26200  0 22 78  0  0
 2  0      0 60718900  23628 3485380    0    0     0    40 1564721 26630  0 22 78  0  0
 2  0      0 60718096  23628 3485332    0    0     0     0 1562593 26432  0 22 78  0  0
 0  0      0 60719608  23628 3485064    0    0     0     0 1563806 26238  0 22 78  0  0
 1  0      0 60722876  23628 3485236    0    0     0   130 1565874 26566  0 22 78  0  0
 1  0      0 60722752  23628 3484908    0    0     0     0 1567646 26247  0 22 78  0  0

After the patch, slack of 10 usec, we can see a reduction of interrupts
per second, and a small decrease of reported cpu usage.

$ vmstat 2 10
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 60722564  23628 3484728    0    0   133     1  696  545  0 13 87  0  0
 1  0      0 60722568  23628 3484824    0    0     0     0 977278 25469  0 20 80  0  0
 0  0      0 60716396  23628 3484764    0    0     0     0 979997 25326  0 20 80  0  0
 0  0      0 60713844  23628 3484960    0    0     0     0 981394 25249  0 20 80  0  0
 2  0      0 60720468  23628 3484916    0    0     0     0 982860 25062  0 20 80  0  0
 1  0      0 60721236  23628 3484856    0    0     0     0 982867 25100  0 20 80  0  0
 1  0      0 60722400  23628 3484456    0    0     0     8 982698 25303  0 20 80  0  0
 0  0      0 60715396  23628 3484428    0    0     0     0 981777 25176  0 20 80  0  0
 0  0      0 60716520  23628 3486544    0    0     0    36 978965 27857  0 21 79  0  0
 0  0      0 60719592  23628 3486516    0    0     0    22 977318 25106  0 20 80  0  0

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_fq.c             | 21 +++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index ea39287d59c812da7fc94379de41c2ba20e86557..7307a29a103e5191acd829c745860b637721be30 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -911,6 +911,8 @@ enum {
 
 	TCA_FQ_CE_THRESHOLD,	/* DCTCP-like CE-marking threshold */
 
+	TCA_FQ_TIMER_SLACK,	/* timer slack */
+
 	__TCA_FQ_MAX
 };
 
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 371ad84def3b6f1b5f0d0704b67723d0a8af22c6..4c060134c7362dcf0d049404cc65066d2c95cb90 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -121,6 +121,8 @@ struct fq_sched_data {
 	u64		stat_flows_plimit;
 	u64		stat_pkts_too_long;
 	u64		stat_allocation_errors;
+
+	u32		timer_slack; /* hrtimer slack in ns */
 	struct qdisc_watchdog watchdog;
 };
 
@@ -504,8 +506,9 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 		head = &q->old_flows;
 		if (!head->first) {
 			if (q->time_next_delayed_flow != ~0ULL)
-				qdisc_watchdog_schedule_ns(&q->watchdog,
-							   q->time_next_delayed_flow);
+				qdisc_watchdog_schedule_range_ns(&q->watchdog,
+							q->time_next_delayed_flow,
+							q->timer_slack);
 			return NULL;
 		}
 	}
@@ -735,6 +738,8 @@ static int fq_resize(struct Qdisc *sch, u32 log)
 }
 
 static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
+	[TCA_FQ_UNSPEC]			= { .strict_start_type = TCA_FQ_TIMER_SLACK },
+
 	[TCA_FQ_PLIMIT]			= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_PLIMIT]		= { .type = NLA_U32 },
 	[TCA_FQ_QUANTUM]		= { .type = NLA_U32 },
@@ -747,6 +752,7 @@ static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
 	[TCA_FQ_ORPHAN_MASK]		= { .type = NLA_U32 },
 	[TCA_FQ_LOW_RATE_THRESHOLD]	= { .type = NLA_U32 },
 	[TCA_FQ_CE_THRESHOLD]		= { .type = NLA_U32 },
+	[TCA_FQ_TIMER_SLACK]		= { .type = NLA_U32 },
 };
 
 static int fq_change(struct Qdisc *sch, struct nlattr *opt,
@@ -833,6 +839,9 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 		q->ce_threshold = (u64)NSEC_PER_USEC *
 				  nla_get_u32(tb[TCA_FQ_CE_THRESHOLD]);
 
+	if (tb[TCA_FQ_TIMER_SLACK])
+		q->timer_slack = nla_get_u32(tb[TCA_FQ_TIMER_SLACK]);
+
 	if (!err) {
 		sch_tree_unlock(sch);
 		err = fq_resize(sch, fq_log);
@@ -884,6 +893,8 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt,
 	q->orphan_mask		= 1024 - 1;
 	q->low_rate_threshold	= 550000 / 8;
 
+	q->timer_slack = 10 * NSEC_PER_USEC; /* 10 usec of hrtimer slack */
+
 	/* Default ce_threshold of 4294 seconds */
 	q->ce_threshold		= (u64)NSEC_PER_USEC * ~0U;
 
@@ -924,7 +935,8 @@ static int fq_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_FQ_LOW_RATE_THRESHOLD,
 			q->low_rate_threshold) ||
 	    nla_put_u32(skb, TCA_FQ_CE_THRESHOLD, (u32)ce_threshold) ||
-	    nla_put_u32(skb, TCA_FQ_BUCKETS_LOG, q->fq_trees_log))
+	    nla_put_u32(skb, TCA_FQ_BUCKETS_LOG, q->fq_trees_log) ||
+	    nla_put_u32(skb, TCA_FQ_TIMER_SLACK, q->timer_slack))
 		goto nla_put_failure;
 
 	return nla_nest_end(skb, opts);
@@ -947,7 +959,8 @@ static int fq_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	st.flows_plimit		  = q->stat_flows_plimit;
 	st.pkts_too_long	  = q->stat_pkts_too_long;
 	st.allocation_errors	  = q->stat_allocation_errors;
-	st.time_next_delayed_flow = q->time_next_delayed_flow - ktime_get_ns();
+	st.time_next_delayed_flow = q->time_next_delayed_flow + q->timer_slack -
+				    ktime_get_ns();
 	st.flows		  = q->flows;
 	st.inactive_flows	  = q->inactive_flows;
 	st.throttled_flows	  = q->throttled_flows;
-- 
2.25.1.481.gfbce0eb801-goog

