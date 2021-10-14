Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4963E42E0A6
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhJNSBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhJNSBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:01:31 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6199CC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:59:26 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c4so4695329pls.6
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RtR0fpetHdR7o5VKdxi3VWPD93sMNN5aIEFL6lbWxOk=;
        b=myxXQY+LFL0rEzTRl0P4qCea2mhjsvCsopeKFlpC3fRHqvBeKkP3ssZges8bvMPwMu
         Ew5DzClFHYEApBnTv8bK7i9kR/KKRdd2YX5Inf9tEHUFjBrEhATQC8wBNTBosvv9eheG
         6WrylxSVJbSI+FUyZYWUquTD1WV/nSV6hWH+v88C3yDIaGK9YKtJsicOh5baIes4OH46
         QGBsR20sfIYfLChwqvw8TE4gtZWAl3pjc+lsVxtKh1xW0eVJlEpMX7Q+dGaZPQNkU8h8
         fzqmlQm3lSRVgcsBE9W4eOastJuePn8av1mSq5DQxDB0dg5zZRvHc5Tjg7mXEt4UpE+Q
         /UVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RtR0fpetHdR7o5VKdxi3VWPD93sMNN5aIEFL6lbWxOk=;
        b=Pk8yyCf+jzmVXF/8JY7xlfx/7EYXXPAl3ocrkSQnx1UFpGsTqFiZ1cg95Jx9ItzmUH
         6Trv5MZmkf4mizEbfNiXb7leKV4tB1ydIqjtA+uDc49xx/UCKhT6YfM7u3dXBXow3IHE
         uo41Qk2wJfgsd/e/xpuShYAhD6pA5xpQ/jK3goL02pbwpNYRR/72mx2V0nEC+OPU7H+6
         6WLf4nILQ81R5kn8HcMLZHWNJgDDwwDRnY3KOnwwNGRWMuBDwBOqrrVafRp0NUOiU4ej
         hosOxvpfnnsWQGWq2WFIymf2ns6xxBPIFEa7dJ9TTI8thQ+cLZYTOFKHV9Jzuc5bfI1C
         cskw==
X-Gm-Message-State: AOAM53357eje1hN4y/FQrNKTjLWJL1Jr3ISngMxHXc5AMI31wE+g4MIA
        Bw4uY19prTUFSVAYWem7sbo=
X-Google-Smtp-Source: ABdhPJwEQUTigMx0ghrREFF3cqEMoDYWUJ3NVSdXmuBNMBdLdjHd43kXnDpYUQL/qInatybPb7UEQA==
X-Received: by 2002:a17:90a:c6:: with SMTP id v6mr22148734pjd.172.1634234365952;
        Thu, 14 Oct 2021 10:59:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b87e:a3bd:898a:99c6])
        by smtp.gmail.com with ESMTPSA id i123sm3060831pfg.157.2021.10.14.10.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 10:59:25 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>, Bob Briscoe <in@bobbriscoe.net>
Subject: [PATCH net-next 2/2] fq_codel: implement L4S style ce_threshold_ect1 marking
Date:   Thu, 14 Oct 2021 10:59:18 -0700
Message-Id: <20211014175918.60188-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211014175918.60188-1-eric.dumazet@gmail.com>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low Latency,
Low Loss, Scalable Throughput (L4S) style marking, along with ce_threshold.

If enabled, only packets with ECT(1) can be transformed to CE
if their sojourn time is above the ce_threshold.

Note that this new option does not change rules for codel law.
In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
the default when fq_codel qdisc is created), ECT(0) packets can
still get CE if codel law (as governed by limit/target) decides so.

Section 4.3.b of current draft [1] states:

b.  A scheduler with per-flow queues such as FQ-CoDel or FQ-PIE can
    be used for L4S.  For instance within each queue of an FQ-CoDel
    system, as well as a CoDel AQM, there is typically also ECN
    marking at an immediate (unsmoothed) shallow threshold to support
    use in data centres (see Sec.5.2.7 of [RFC8290]).  This can be
    modified so that the shallow threshold is solely applied to
    ECT(1) packets.  Then if there is a flow of non-ECN or ECT(0)
    packets in the per-flow-queue, the Classic AQM (e.g.  CoDel) is
    applied; while if there is a flow of ECT(1) packets in the queue,
    the shallower (typically sub-millisecond) threshold is applied.

Tested:

tc qd replace dev eth1 root fq_codel ce_threshold_ect1 50usec

netperf ... -t TCP_STREAM -- K dctcp

tc -s -d qd sh dev eth1
qdisc fq_codel 8022: root refcnt 32 limit 10240p flows 1024 quantum 9212 target 5ms ce_threshold_ect1 49us interval 100ms memory_limit 32Mb ecn drop_batch 64
 Sent 14388596616 bytes 9543449 pkt (dropped 0, overlimits 0 requeues 152013)
 backlog 0b 0p requeues 152013
  maxpacket 68130 drop_overlimit 0 new_flow_count 95678 ecn_mark 0 ce_mark 7639
  new_flows_len 0 old_flows_len 0

[1] L4S current draft:
https://datatracker.ietf.org/doc/html/draft-ietf-tsvwg-l4s-arch

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Ingemar Johansson S <ingemar.s.johansson@ericsson.com>
Cc: Tom Henderson <tomh@tomh.org>
Cc: Bob Briscoe <in@bobbriscoe.net>
---
 include/net/codel.h            |  2 ++
 include/net/codel_impl.h       | 18 +++++++++++++++---
 include/uapi/linux/pkt_sched.h |  1 +
 net/mac80211/sta_info.c        |  1 +
 net/sched/sch_fq_codel.c       | 15 +++++++++++----
 5 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/net/codel.h b/include/net/codel.h
index a6e428f801350809322aaff08d92904e059c3b5a..5e8b181b76b829d6af3c57809d9bc5f0578dd112 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -102,6 +102,7 @@ static inline u32 codel_time_to_us(codel_time_t val)
  * @interval:	width of moving time window
  * @mtu:	device mtu, or minimal queue backlog in bytes.
  * @ecn:	is Explicit Congestion Notification enabled
+ * @ce_threshold_ect1: if ce_threshold only marks ECT(1) packets
  */
 struct codel_params {
 	codel_time_t	target;
@@ -109,6 +110,7 @@ struct codel_params {
 	codel_time_t	interval;
 	u32		mtu;
 	bool		ecn;
+	bool		ce_threshold_ect1;
 };
 
 /**
diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
index d289b91dcd65ecdc96dc0c9bf85d4a4be6961022..7af2c3eb3c43c24364519120aad5be77522854a6 100644
--- a/include/net/codel_impl.h
+++ b/include/net/codel_impl.h
@@ -54,6 +54,7 @@ static void codel_params_init(struct codel_params *params)
 	params->interval = MS2TIME(100);
 	params->target = MS2TIME(5);
 	params->ce_threshold = CODEL_DISABLED_THRESHOLD;
+	params->ce_threshold_ect1 = false;
 	params->ecn = false;
 }
 
@@ -246,9 +247,20 @@ static struct sk_buff *codel_dequeue(void *ctx,
 						    vars->rec_inv_sqrt);
 	}
 end:
-	if (skb && codel_time_after(vars->ldelay, params->ce_threshold) &&
-	    INET_ECN_set_ce(skb))
-		stats->ce_mark++;
+	if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
+		bool set_ce = true;
+
+		if (params->ce_threshold_ect1) {
+			/* Note: if skb_get_dsfield() returns -1, following
+			 * gives INET_ECN_MASK, which is != INET_ECN_ECT_1.
+			 */
+			u8 ecn = skb_get_dsfield(skb) & INET_ECN_MASK;
+
+			set_ce = (ecn == INET_ECN_ECT_1);
+		}
+		if (set_ce && INET_ECN_set_ce(skb))
+			stats->ce_mark++;
+	}
 	return skb;
 }
 
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index ec88590b3198441f18cc9def7bd40c48f0bc82a1..6be9a84cccfa79bace1f3f7123d02f484b67a25e 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -840,6 +840,7 @@ enum {
 	TCA_FQ_CODEL_CE_THRESHOLD,
 	TCA_FQ_CODEL_DROP_BATCH_SIZE,
 	TCA_FQ_CODEL_MEMORY_LIMIT,
+	TCA_FQ_CODEL_CE_THRESHOLD_ECT1,
 	__TCA_FQ_CODEL_MAX
 };
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 2b5acb37587f7068e2d11fe842ec963a556f1eb1..a39830418434d4bb74d238373f63a4858230fce5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -513,6 +513,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->cparams.target = MS2TIME(20);
 	sta->cparams.interval = MS2TIME(100);
 	sta->cparams.ecn = true;
+	sta->cparams.ce_threshold_ect1 = false;
 
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index bb0cd6d3d2c2749d54e26368fb2558beedea85c9..033d65d06eb136ff704cddd3ee950a5c3a5d9831 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -362,6 +362,7 @@ static const struct nla_policy fq_codel_policy[TCA_FQ_CODEL_MAX + 1] = {
 	[TCA_FQ_CODEL_CE_THRESHOLD] = { .type = NLA_U32 },
 	[TCA_FQ_CODEL_DROP_BATCH_SIZE] = { .type = NLA_U32 },
 	[TCA_FQ_CODEL_MEMORY_LIMIT] = { .type = NLA_U32 },
+	[TCA_FQ_CODEL_CE_THRESHOLD_ECT1] = { .type = NLA_U8 },
 };
 
 static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
@@ -408,6 +409,9 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 		q->cparams.ce_threshold = (val * NSEC_PER_USEC) >> CODEL_SHIFT;
 	}
 
+	if (tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1])
+		q->cparams.ce_threshold_ect1 = !!nla_get_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1]);
+
 	if (tb[TCA_FQ_CODEL_INTERVAL]) {
 		u64 interval = nla_get_u32(tb[TCA_FQ_CODEL_INTERVAL]);
 
@@ -544,10 +548,13 @@ static int fq_codel_dump(struct Qdisc *sch, struct sk_buff *skb)
 			q->flows_cnt))
 		goto nla_put_failure;
 
-	if (q->cparams.ce_threshold != CODEL_DISABLED_THRESHOLD &&
-	    nla_put_u32(skb, TCA_FQ_CODEL_CE_THRESHOLD,
-			codel_time_to_us(q->cparams.ce_threshold)))
-		goto nla_put_failure;
+	if (q->cparams.ce_threshold != CODEL_DISABLED_THRESHOLD) {
+		if (nla_put_u32(skb, TCA_FQ_CODEL_CE_THRESHOLD,
+				codel_time_to_us(q->cparams.ce_threshold)))
+			goto nla_put_failure;
+		if (nla_put_u8(skb, TCA_FQ_CODEL_CE_THRESHOLD_ECT1, q->cparams.ce_threshold_ect1))
+			goto nla_put_failure;
+	}
 
 	return nla_nest_end(skb, opts);
 
-- 
2.33.0.1079.g6e70778dc9-goog

