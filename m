Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEF6338F79
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhCLOJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbhCLOIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:08:47 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453D0C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:47 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ci14so53458668ejc.7
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NddWNOk9wxp4607+mUQFDvyxxIPtdD8hsqo8IjCdLXU=;
        b=P6oLBzGKvuA38iCZQRlS/Sp8Ds0VwIykK/G9GOtH3IhLugBP/PlYJEjHZWitm74Nch
         4EFpYAp2A2/+CZj8pJCJwZkd71cujic8KqmsASiwpSE34Kckhoma7Ux3JucMFl2ZwsRk
         YjbzbC8Q7XF4gdjneaCvwzyHGfXfFcvhzWvOVxhGNh4FdHlGmbD+RsHyrkcESfBwj/Oh
         4barSku9tto6no6xpGHB5Cv6ag+0EwQ46HoDHCU1INnDat7/8fD6LU6ESsv49DLD5lgf
         os/tbXJ/dZDj12E71v/VxrL66GE8LkrLBZXVXh7FLc7DTVpTtnSTbLh4uJN3oqXAYrRG
         xu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NddWNOk9wxp4607+mUQFDvyxxIPtdD8hsqo8IjCdLXU=;
        b=U1cAHBcqCJ2W/jRpmRJSmZXBQrqT+bKUq6pS5n5w2IEUkJjjfIpIjaYk25howwIk9Y
         sj+VGBhxvapGhsnfEA+magfIIbIoReq88nzyF/dN/HXpTevO9yrMrgesTP/Mb+goIjOi
         Z5k4mBPyOCpBxPc+eaXenNVxDPWePKtFe1YfzaFeR0QOOBW2cRZDI058ZVwBp9QDhmPn
         sO+YMdJae7HGAQCvvEZsxYUpAQlZDO95Ii7lulV6KZtNDfcDaLN7tR+oGbUv3j41RIb0
         Cre/aLPKD/PmLa6tbEsdB+cbebNCkfkoRhuczj1nSfVsG/i+kc9c+Ni4Y786B0zNwXxh
         aWyA==
X-Gm-Message-State: AOAM530zvKgs7vH9MlaMDNmCV9P+P7q/73e1XATAKIERfS/Voes/VVBH
        bt8zZfLS5zZBDiG2GyffZQ145w==
X-Google-Smtp-Source: ABdhPJxp6MyeBqmdQRaSsZa6e2lUIA3Hb0rCGS8LbMz9FRLoWSuq+kC2ggiUNSFraN4G6QOaE4sGrw==
X-Received: by 2002:a17:906:4bce:: with SMTP id x14mr8545748ejv.383.1615558125392;
        Fri, 12 Mar 2021 06:08:45 -0800 (PST)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id s11sm3031673edt.27.2021.03.12.06.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:08:44 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH v3 net-next 3/3] net/sched: act_police: add support for packet-per-second policing
Date:   Fri, 12 Mar 2021 15:08:31 +0100
Message-Id: <20210312140831.23346-4-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210312140831.23346-1-simon.horman@netronome.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Allow a policer action to enforce a rate-limit based on packets-per-second,
configurable using a packet-per-second rate and burst parameters.

e.g.
tc filter add dev tap1 parent ffff: u32 match \
        u32 0 0 police pkts_rate 3000 pkts_burst 1000

Testing was unable to uncover a performance impact of this change on
existing features.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 include/net/sch_generic.h      | 14 +++++++
 include/net/tc_act/tc_police.h | 48 ++++++++++++++++++++--
 include/uapi/linux/pkt_cls.h   |  2 +
 net/sched/act_police.c         | 59 ++++++++++++++++++++++----
 net/sched/sch_generic.c        | 75 ++++++++++++++++++++++------------
 5 files changed, 162 insertions(+), 36 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 2d6eb60c58c8..f7a6e14491fb 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1242,6 +1242,20 @@ static inline void psched_ratecfg_getrate(struct tc_ratespec *res,
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
+void psched_ppscfg_precompute(struct psched_pktrate *r, u64 pktrate64);
+
 /* Mini Qdisc serves for specific needs of ingress/clsact Qdisc.
  * The fast path only needs to access filter list and to update stats
  */
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index ae117f7937d5..72649512dcdd 100644
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
 
@@ -99,14 +103,50 @@ static inline u32 tcf_police_burst(const struct tc_action *act)
 
 static inline u64 tcf_police_rate_pkt_ps(const struct tc_action *act)
 {
-	/* Not implemented */
-	return 0;
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->ppsrate.rate_pkts_ps;
 }
 
 static inline u32 tcf_police_burst_pkt(const struct tc_action *act)
 {
-	/* Not implemented */
-	return 0;
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+	u32 burst;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+
+	/*
+	 *  "rate" pkts     "burst" nanoseconds
+	 *  ------------ *  -------------------
+	 *    1 second          2^6 ticks
+	 *
+	 * ------------------------------------
+	 *        NSEC_PER_SEC nanoseconds
+	 *        ------------------------
+	 *              2^6 ticks
+	 *
+	 *    "rate" pkts    "burst" nanoseconds            2^6 ticks
+	 *  = ------------ * ------------------- * ------------------------
+	 *      1 second          2^6 ticks        NSEC_PER_SEC nanoseconds
+	 *
+	 *   "rate" * "burst"
+	 * = ---------------- pkts/nanosecond
+	 *    NSEC_PER_SEC^2
+	 *
+	 *
+	 *   "rate" * "burst"
+	 * = ---------------- pkts/second
+	 *     NSEC_PER_SEC
+	 */
+	burst = div_u64(params->tcfp_pkt_burst * params->ppsrate.rate_pkts_ps,
+			NSEC_PER_SEC);
+
+	return burst;
 }
 
 static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 7ea59cfe1fa7..025c40fef93d 100644
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
index 8d8452b1cdd4..0fab8de176d2 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -42,6 +42,8 @@ static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
 	[TCA_POLICE_RESULT]	= { .type = NLA_U32 },
 	[TCA_POLICE_RATE64]     = { .type = NLA_U64 },
 	[TCA_POLICE_PEAKRATE64] = { .type = NLA_U64 },
+	[TCA_POLICE_PKTRATE64]  = { .type = NLA_U64, .min = 1 },
+	[TCA_POLICE_PKTBURST64] = { .type = NLA_U64, .min = 1 },
 };
 
 static int tcf_police_init(struct net *net, struct nlattr *nla,
@@ -61,6 +63,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	bool exists = false;
 	u32 index;
 	u64 rate64, prate64;
+	u64 pps, ppsburst;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -142,6 +145,21 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 		}
 	}
 
+	if ((tb[TCA_POLICE_PKTRATE64] && !tb[TCA_POLICE_PKTBURST64]) ||
+	    (!tb[TCA_POLICE_PKTRATE64] && tb[TCA_POLICE_PKTBURST64])) {
+		NL_SET_ERR_MSG(extack,
+			       "Both or neither packet-per-second burst and rate must be provided");
+		err = -EINVAL;
+		goto failure;
+	}
+
+	if (tb[TCA_POLICE_PKTRATE64] && R_tab) {
+		NL_SET_ERR_MSG(extack,
+			       "packet-per-second and byte-per-second rate limits not allowed in same action");
+		err = -EINVAL;
+		goto failure;
+	}
+
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (unlikely(!new)) {
 		err = -ENOMEM;
@@ -183,6 +201,14 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	if (tb[TCA_POLICE_AVRATE])
 		new->tcfp_ewma_rate = nla_get_u32(tb[TCA_POLICE_AVRATE]);
 
+	if (tb[TCA_POLICE_PKTRATE64]) {
+		pps = nla_get_u64(tb[TCA_POLICE_PKTRATE64]);
+		ppsburst = nla_get_u64(tb[TCA_POLICE_PKTBURST64]);
+		new->pps_present = true;
+		new->tcfp_pkt_burst = PSCHED_TICKS2NS(ppsburst);
+		psched_ppscfg_precompute(&new->ppsrate, pps);
+	}
+
 	spin_lock_bh(&police->tcf_lock);
 	spin_lock_bh(&police->tcfp_lock);
 	police->tcfp_t_c = ktime_get_ns();
@@ -217,8 +243,8 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
 	struct tcf_police *police = to_police(a);
+	s64 now, toks, ppstoks = 0, ptoks = 0;
 	struct tcf_police_params *p;
-	s64 now, toks, ptoks = 0;
 	int ret;
 
 	tcf_lastuse_update(&police->tcf_tm);
@@ -236,7 +262,7 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
-		if (!p->rate_present) {
+		if (!p->rate_present && !p->pps_present) {
 			ret = p->tcfp_result;
 			goto end;
 		}
@@ -251,14 +277,23 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			ptoks -= (s64)psched_l2t_ns(&p->peak,
 						    qdisc_pkt_len(skb));
 		}
-		toks += police->tcfp_toks;
-		if (toks > p->tcfp_burst)
-			toks = p->tcfp_burst;
-		toks -= (s64)psched_l2t_ns(&p->rate, qdisc_pkt_len(skb));
-		if ((toks|ptoks) >= 0) {
+		if (p->rate_present) {
+			toks += police->tcfp_toks;
+			if (toks > p->tcfp_burst)
+				toks = p->tcfp_burst;
+			toks -= (s64)psched_l2t_ns(&p->rate, qdisc_pkt_len(skb));
+		} else if (p->pps_present) {
+			ppstoks = min_t(s64, now - police->tcfp_t_c, p->tcfp_pkt_burst);
+			ppstoks += police->tcfp_pkttoks;
+			if (ppstoks > p->tcfp_pkt_burst)
+				ppstoks = p->tcfp_pkt_burst;
+			ppstoks -= (s64)psched_pkt2t_ns(&p->ppsrate, 1);
+		}
+		if ((toks | ptoks | ppstoks) >= 0) {
 			police->tcfp_t_c = now;
 			police->tcfp_toks = toks;
 			police->tcfp_ptoks = ptoks;
+			police->tcfp_pkttoks = ppstoks;
 			spin_unlock_bh(&police->tcfp_lock);
 			ret = p->tcfp_result;
 			goto inc_drops;
@@ -331,6 +366,16 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
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
index 49eae93d1489..44991ea726fc 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1325,6 +1325,48 @@ void dev_shutdown(struct net_device *dev)
 	WARN_ON(timer_pending(&dev->watchdog_timer));
 }
 
+/**
+ * psched_ratecfg_precompute__() - Pre-compute values for reciprocal division
+ * @rate:   Rate to compute reciprocal division values of
+ * @mult:   Multiplier for reciprocal division
+ * @shift:  Shift for reciprocal division
+ *
+ * The multiplier and shift for reciprocal division by rate are stored
+ * in mult and shift.
+ *
+ * The deal here is to replace a divide by a reciprocal one
+ * in fast path (a reciprocal divide is a multiply and a shift)
+ *
+ * Normal formula would be :
+ *  time_in_ns = (NSEC_PER_SEC * len) / rate_bps
+ *
+ * We compute mult/shift to use instead :
+ *  time_in_ns = (len * mult) >> shift;
+ *
+ * We try to get the highest possible mult value for accuracy,
+ * but have to make sure no overflows will ever happen.
+ *
+ * reciprocal_value() is not used here it doesn't handle 64-bit values.
+ */
+static void psched_ratecfg_precompute__(u64 rate, u32 *mult, u8 *shift)
+{
+	u64 factor = NSEC_PER_SEC;
+
+	*mult = 1;
+	*shift = 0;
+
+	if (rate <= 0)
+		return;
+
+	for (;;) {
+		*mult = div64_u64(factor, rate);
+		if (*mult & (1U << 31) || factor & (1ULL << 63))
+			break;
+		factor <<= 1;
+		(*shift)++;
+	}
+}
+
 void psched_ratecfg_precompute(struct psched_ratecfg *r,
 			       const struct tc_ratespec *conf,
 			       u64 rate64)
@@ -1333,34 +1375,17 @@ void psched_ratecfg_precompute(struct psched_ratecfg *r,
 	r->overhead = conf->overhead;
 	r->rate_bytes_ps = max_t(u64, conf->rate, rate64);
 	r->linklayer = (conf->linklayer & TC_LINKLAYER_MASK);
-	r->mult = 1;
-	/*
-	 * The deal here is to replace a divide by a reciprocal one
-	 * in fast path (a reciprocal divide is a multiply and a shift)
-	 *
-	 * Normal formula would be :
-	 *  time_in_ns = (NSEC_PER_SEC * len) / rate_bps
-	 *
-	 * We compute mult/shift to use instead :
-	 *  time_in_ns = (len * mult) >> shift;
-	 *
-	 * We try to get the highest possible mult value for accuracy,
-	 * but have to make sure no overflows will ever happen.
-	 */
-	if (r->rate_bytes_ps > 0) {
-		u64 factor = NSEC_PER_SEC;
-
-		for (;;) {
-			r->mult = div64_u64(factor, r->rate_bytes_ps);
-			if (r->mult & (1U << 31) || factor & (1ULL << 63))
-				break;
-			factor <<= 1;
-			r->shift++;
-		}
-	}
+	psched_ratecfg_precompute__(r->rate_bytes_ps, &r->mult, &r->shift);
 }
 EXPORT_SYMBOL(psched_ratecfg_precompute);
 
+void psched_ppscfg_precompute(struct psched_pktrate *r, u64 pktrate64)
+{
+	r->rate_pkts_ps = pktrate64;
+	psched_ratecfg_precompute__(r->rate_pkts_ps, &r->mult, &r->shift);
+}
+EXPORT_SYMBOL(psched_ppscfg_precompute);
+
 static void mini_qdisc_rcu_func(struct rcu_head *head)
 {
 }
-- 
2.20.1

