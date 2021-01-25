Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7419C3049F2
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732154AbhAZFUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbhAYPpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:45:06 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65511C061352
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:18:30 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id kg20so18083652ejc.4
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mWsIBoL1wxPD3KrXTwekJa08rW2herWg76na+QWjqW4=;
        b=YvdkchP2IIv3J1CgrOg4GczXKYSeYRFe03MhzM8HMJesDzD5/88LfyUojlqkHoUHCB
         818WpRJu/ha7Im/rhXFWtokP8s0dwwSvy5MdOq+oxxi7L3d+2F02KR749hmcGa6UCgSM
         F7l8xnc2/kdtXREFfvBbxTlM+r+gzZcHPzwQUJ4I2qiRqONGEiHpLZie8OqpjYHZA+ev
         UZ4Cs6vTicKXSZZoY/vZMVp2Lw1rDIz0M7zIgstR0C1gtZHgM8mX1y1JOpXoduxjYscH
         WgfV5BWqaxftq54zBgAsZjFbxOPjbCkTXcU5D1hxCkyiyrzfuYi/j7SRJqvEM2cUejL6
         XS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mWsIBoL1wxPD3KrXTwekJa08rW2herWg76na+QWjqW4=;
        b=e44USd0gBKexX1hy9EH+U0D7Fh3ETjJezmLbazq25hpDjYD2ZX6laAzb3ad2hn/wxC
         6S8WLsNrXLQhvqm1lt4CS2s5ml52j/ptEP+h3P9WxUnTdFZTsyOZBVTrVPRzOPlaHUsW
         KOhkEBZRyFSzZrwivPwRJbA6IFIc1iszjDM3Z/pGLHsYUQtX5QS+kSmGi3Vlw1AXZV/K
         P1yyILpmyeAZwDNC1vU/saMGbk+z33SP6mxEmIiALz3o5C0PJ9CMH0crukY7PHmqP++q
         /CzrGXulovVL8RAM2tBr6heW4oEJxsUYY4OgPT2TGoIV/juUGR8ZXArj7la+tNoW+wij
         eybQ==
X-Gm-Message-State: AOAM531bGl7iQjIFzTdLTo2Cw+uwlof3Yif18y2uEEPXmVADhn2g00QJ
        t4skvnNgoPwwdZwq9JM2s6h0AQ==
X-Google-Smtp-Source: ABdhPJz5LP501szz0cvPS/IVK+/eyNEtNQCKoEGa8C9BEc7jV2cxP0rso8oukUduRwkFufPq2RV2zQ==
X-Received: by 2002:a17:906:f246:: with SMTP id gy6mr674025ejb.264.1611587909083;
        Mon, 25 Jan 2021 07:18:29 -0800 (PST)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id n2sm949684ejl.1.2021.01.25.07.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 07:18:28 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH RFC net-next] net/sched: act_police: add support for packet-per-second policing
Date:   Mon, 25 Jan 2021 16:18:19 +0100
Message-Id: <20210125151819.8313-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Allow a policer action to enforce a rate-limit based on packets-per-second,
configurable using a packet-per-second rate and burst parameters. This may
be used in conjunction with existing byte-per-second rate limiting in the
same policer action.

e.g.
tc filter add dev tap1 parent ffff: u32 match \
              u32 0 0 police pkts_rate 3000 pkts_burst 1000

Testing was unable to uncover a performance impact of this change on
existing features.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 include/net/sch_generic.h      | 15 ++++++++++++++
 include/net/tc_act/tc_police.h |  4 ++++
 include/uapi/linux/pkt_cls.h   |  2 ++
 net/sched/act_police.c         | 37 +++++++++++++++++++++++++++++++---
 net/sched/sch_generic.c        | 32 +++++++++++++++++++++++++++++
 5 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 639e465a108f..1a93ad634fee 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1234,6 +1234,21 @@ static inline void psched_ratecfg_getrate(struct tc_ratespec *res,
 	res->linklayer = (r->linklayer & TC_LINKLAYER_MASK);
 }
 
+struct psched_pktrate {
+	u64	rate_pkts_ps; /* packets per second */
+	u32	mult;
+	u8	shift;
+};
+
+static inline u64 psched_pkt2t_ns(const struct psched_pktrate *r,
+				  unsigned int pkt_num)
+{
+	return ((u64)pkt_num * r->mult) >> r->shift;
+}
+
+void psched_ppscfg_precompute(struct psched_pktrate *r,
+			      u64 pktrate64);
+
 /* Mini Qdisc serves for specific needs of ingress/clsact Qdisc.
  * The fast path only needs to access filter list and to update stats
  */
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index 6d1e26b709b5..b106460a8d66 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -10,10 +10,13 @@ struct tcf_police_params {
 	s64			tcfp_burst;
 	u32			tcfp_mtu;
 	s64			tcfp_mtu_ptoks;
+	s64			tcfp_pkt_burst;
 	struct psched_ratecfg	rate;
 	bool			rate_present;
 	struct psched_ratecfg	peak;
 	bool			peak_present;
+	struct psched_pktrate	ppsrate;
+	bool			pps_present;
 	struct rcu_head rcu;
 };
 
@@ -24,6 +27,7 @@ struct tcf_police {
 	spinlock_t		tcfp_lock ____cacheline_aligned_in_smp;
 	s64			tcfp_toks;
 	s64			tcfp_ptoks;
+	s64			tcfp_pkttoks;
 	s64			tcfp_t_c;
 };
 
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42fb0ec..bffa54e73785 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -190,6 +190,8 @@ enum {
 	TCA_POLICE_PAD,
 	TCA_POLICE_RATE64,
 	TCA_POLICE_PEAKRATE64,
+	TCA_POLICE_PKTRATE64,
+	TCA_POLICE_PKTBURST64,
 	__TCA_POLICE_MAX
 #define TCA_POLICE_RESULT TCA_POLICE_RESULT
 };
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 8d8452b1cdd4..d700b2105535 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -42,6 +42,8 @@ static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
 	[TCA_POLICE_RESULT]	= { .type = NLA_U32 },
 	[TCA_POLICE_RATE64]     = { .type = NLA_U64 },
 	[TCA_POLICE_PEAKRATE64] = { .type = NLA_U64 },
+	[TCA_POLICE_PKTRATE64]  = { .type = NLA_U64 },
+	[TCA_POLICE_PKTBURST64] = { .type = NLA_U64 },
 };
 
 static int tcf_police_init(struct net *net, struct nlattr *nla,
@@ -61,6 +63,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	bool exists = false;
 	u32 index;
 	u64 rate64, prate64;
+	u64 pps, ppsburst;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -183,6 +186,16 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	if (tb[TCA_POLICE_AVRATE])
 		new->tcfp_ewma_rate = nla_get_u32(tb[TCA_POLICE_AVRATE]);
 
+	if (tb[TCA_POLICE_PKTRATE64] && tb[TCA_POLICE_PKTBURST64]) {
+		pps = nla_get_u64(tb[TCA_POLICE_PKTRATE64]);
+		ppsburst = nla_get_u64(tb[TCA_POLICE_PKTBURST64]);
+		if (pps) {
+			new->pps_present = true;
+			new->tcfp_pkt_burst = PSCHED_TICKS2NS(ppsburst);
+			psched_ppscfg_precompute(&new->ppsrate, pps);
+		}
+	}
+
 	spin_lock_bh(&police->tcf_lock);
 	spin_lock_bh(&police->tcfp_lock);
 	police->tcfp_t_c = ktime_get_ns();
@@ -217,8 +230,8 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
 	struct tcf_police *police = to_police(a);
+	s64 now, toks, ppstoks = 0, ptoks = 0;
 	struct tcf_police_params *p;
-	s64 now, toks, ptoks = 0;
 	int ret;
 
 	tcf_lastuse_update(&police->tcf_tm);
@@ -236,7 +249,7 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
-		if (!p->rate_present) {
+		if (!p->rate_present && !p->pps_present) {
 			ret = p->tcfp_result;
 			goto end;
 		}
@@ -251,14 +264,22 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			ptoks -= (s64)psched_l2t_ns(&p->peak,
 						    qdisc_pkt_len(skb));
 		}
+		if (p->pps_present) {
+			ppstoks = min_t(s64, now - police->tcfp_t_c, p->tcfp_pkt_burst);
+			ppstoks += police->tcfp_pkttoks;
+			if (ppstoks > p->tcfp_pkt_burst)
+				ppstoks = p->tcfp_pkt_burst;
+			ppstoks -= (s64)psched_pkt2t_ns(&p->ppsrate, 1);
+		}
 		toks += police->tcfp_toks;
 		if (toks > p->tcfp_burst)
 			toks = p->tcfp_burst;
 		toks -= (s64)psched_l2t_ns(&p->rate, qdisc_pkt_len(skb));
-		if ((toks|ptoks) >= 0) {
+		if ((toks | ptoks | ppstoks) >= 0) {
 			police->tcfp_t_c = now;
 			police->tcfp_toks = toks;
 			police->tcfp_ptoks = ptoks;
+			police->tcfp_pkttoks = ppstoks;
 			spin_unlock_bh(&police->tcfp_lock);
 			ret = p->tcfp_result;
 			goto inc_drops;
@@ -331,6 +352,16 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 				      TCA_POLICE_PAD))
 			goto nla_put_failure;
 	}
+	if (p->pps_present) {
+		if (nla_put_u64_64bit(skb, TCA_POLICE_PKTRATE64,
+				      police->params->ppsrate.rate_pkts_ps,
+				      TCA_POLICE_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(skb, TCA_POLICE_PKTBURST64,
+				      PSCHED_NS2TICKS(p->tcfp_pkt_burst),
+				      TCA_POLICE_PAD))
+			goto nla_put_failure;
+	}
 	if (nla_put(skb, TCA_POLICE_TBF, sizeof(opt), &opt))
 		goto nla_put_failure;
 	if (p->tcfp_result &&
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 49eae93d1489..209e34ee4bd3 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1361,6 +1361,38 @@ void psched_ratecfg_precompute(struct psched_ratecfg *r,
 }
 EXPORT_SYMBOL(psched_ratecfg_precompute);
 
+void psched_ppscfg_precompute(struct psched_pktrate *r,
+			      u64 pktrate64)
+{
+	memset(r, 0, sizeof(*r));
+	r->rate_pkts_ps = pktrate64;
+	r->mult = 1;
+	/* The deal here is to replace a divide by a reciprocal one
+	 * in fast path (a reciprocal divide is a multiply and a shift)
+	 *
+	 * Normal formula would be :
+	 *  time_in_ns = (NSEC_PER_SEC * pkt_num) / pktrate64
+	 *
+	 * We compute mult/shift to use instead :
+	 *  time_in_ns = (len * mult) >> shift;
+	 *
+	 * We try to get the highest possible mult value for accuracy,
+	 * but have to make sure no overflows will ever happen.
+	 */
+	if (r->rate_pkts_ps > 0) {
+		u64 factor = NSEC_PER_SEC;
+
+		for (;;) {
+			r->mult = div64_u64(factor, r->rate_pkts_ps);
+			if (r->mult & (1U << 31) || factor & (1ULL << 63))
+				break;
+			factor <<= 1;
+			r->shift++;
+		}
+	}
+}
+EXPORT_SYMBOL(psched_ppscfg_precompute);
+
 static void mini_qdisc_rcu_func(struct rcu_head *head)
 {
 }
-- 
2.20.1

