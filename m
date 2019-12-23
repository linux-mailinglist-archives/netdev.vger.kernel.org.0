Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D20D129ACB
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLWUUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:20:20 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:35500 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:20:19 -0500
Received: by mail-pg1-f201.google.com with SMTP id f15so11216934pgk.2
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6CLddxOiqlpuryTo/OIgSRM2J2KWyQujjlTnXLQ5+eI=;
        b=VKHEMAYPV2TdLqhucTpIulDMQycbir7B0fhPlmMI8lSLoGrJ0bKWx0c/MQiOPygaPf
         vyvBIhruvLfFMTg5s2K4r1El0CyS0XIeRscX2Gu2DSwE70sabOOJh/8tvaTaTXoli+5D
         1xnloKU1Qvae1RWDrct3dtYImuAEG6hXhYub2n/m/GJmXl8QXfcXBgqgvEqlQAfIIHrV
         ou5fWDxSXH52dkMLEb1rFbqL0HCBHBU3gLqe9CUgiTniVYRC3kB+VFtAnm/2hqTMVTRg
         q1u8TzS4ZzT8Gb0OcQHu1PoeKCLAFZrfxe9mq1fXR7vEPAKhhrNzR5Tzznz+rP5UXguj
         3h/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6CLddxOiqlpuryTo/OIgSRM2J2KWyQujjlTnXLQ5+eI=;
        b=ATvGGY3YZaGD/OGV2nfUQ4zvSs52aNR12OVAgbu5k7MS0TBKYz7+ryfEv2higtcmL+
         MhizYt4vcyBtslYgtrdZ28PyOALERNH+/grQjxbLVtieVjVYbO4XbbCzomsqFSbKDmE1
         5QiTOHbk+03M8ytoBgPm/EPGoJ/PxgH6oZmtaij/OpZ9k7G3PElKiFbcT+fDMTFuv6pm
         1hF91QvMKg2mS2WUOJMIFIe+LrueTJ+vrCxDJnaXiu63QY1RUMIHKmOyfpW505959h4x
         9fk3DWsnEGswoPpifMvBNmPwVSckAFIAhdM8WzdCRDMcAa0l+fuqEZX0jFNUf+6iSJ0w
         cgIQ==
X-Gm-Message-State: APjAAAWsEnFnA098dqK5uEsYbBB4iP1tprEnDwHbEuTGvE0wA9KCrBFw
        Zb9kPOsXiV9OGrZZmykvz/fh9AXd4+wpqw==
X-Google-Smtp-Source: APXvYqxNh8twX4CFdr2yNPs0szGnFEsKSa5AwNiTbaU6AhY93gqO4TMpsOmaDvVu675016oFtREw9kldpUGw+Q==
X-Received: by 2002:a63:31d1:: with SMTP id x200mr31039681pgx.405.1577132418871;
 Mon, 23 Dec 2019 12:20:18 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:20:03 -0800
In-Reply-To: <20191223202005.104713-1-edumazet@google.com>
Message-Id: <20191223202005.104713-4-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202005.104713-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next 3/5] tcp_cubic: switch bictcp_clock() to usec resolution
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current 1ms clock feeds ca->round_start, ca->delay_min,
ca->last_ack.

This is quite problematic for data-center flows, where delay_min
is way below 1 ms.

This means Hystart Train detection triggers every time jiffies value
is updated, since "((s32)(now - ca->round_start) > ca->delay_min >> 4)"
expression becomes true.

This kind of random behavior can be solved by reusing the existing
usec timestamp that TCP keeps in tp->tcp_mstamp

Note that a followup patch will tweak things a bit, because
during slow start, GRO aggregation on receivers naturally
increases the RTT as TSO packets gradually come to ~64KB size.

To recap, right after this patch CUBIC Hystart train detection
is more aggressive, since short RTT flows might exit slow start at
cwnd = 20, instead of being possibly unbounded.

Following patch will address this problem.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 5eff762acd7fe1510eb39fc789b488de8ca648de..068775b91fb5790e6e60a6490b49e7a266e4ed51 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -40,8 +40,8 @@
 
 /* Number of delay samples for detecting the increase of delay */
 #define HYSTART_MIN_SAMPLES	8
-#define HYSTART_DELAY_MIN	(4U<<3)
-#define HYSTART_DELAY_MAX	(16U<<3)
+#define HYSTART_DELAY_MIN	(4000U)	/* 4 ms */
+#define HYSTART_DELAY_MAX	(16000U)	/* 16 ms */
 #define HYSTART_DELAY_THRESH(x)	clamp(x, HYSTART_DELAY_MIN, HYSTART_DELAY_MAX)
 
 static int fast_convergence __read_mostly = 1;
@@ -53,7 +53,7 @@ static int tcp_friendliness __read_mostly = 1;
 static int hystart __read_mostly = 1;
 static int hystart_detect __read_mostly = HYSTART_ACK_TRAIN | HYSTART_DELAY;
 static int hystart_low_window __read_mostly = 16;
-static int hystart_ack_delta __read_mostly = 2;
+static int hystart_ack_delta_us __read_mostly = 2000;
 
 static u32 cube_rtt_scale __read_mostly;
 static u32 beta_scale __read_mostly;
@@ -77,8 +77,8 @@ MODULE_PARM_DESC(hystart_detect, "hybrid slow start detection mechanisms"
 		 " 1: packet-train 2: delay 3: both packet-train and delay");
 module_param(hystart_low_window, int, 0644);
 MODULE_PARM_DESC(hystart_low_window, "lower bound cwnd for hybrid slow start");
-module_param(hystart_ack_delta, int, 0644);
-MODULE_PARM_DESC(hystart_ack_delta, "spacing between ack's indicating train (msecs)");
+module_param(hystart_ack_delta_us, int, 0644);
+MODULE_PARM_DESC(hystart_ack_delta_us, "spacing between ack's indicating train (usecs)");
 
 /* BIC TCP Parameters */
 struct bictcp {
@@ -89,7 +89,7 @@ struct bictcp {
 	u32	bic_origin_point;/* origin point of bic function */
 	u32	bic_K;		/* time to origin point
 				   from the beginning of the current epoch */
-	u32	delay_min;	/* min delay (msec << 3) */
+	u32	delay_min;	/* min delay (usec) */
 	u32	epoch_start;	/* beginning of an epoch */
 	u32	ack_cnt;	/* number of acks */
 	u32	tcp_cwnd;	/* estimated tcp cwnd */
@@ -117,13 +117,9 @@ static inline void bictcp_reset(struct bictcp *ca)
 	ca->found = 0;
 }
 
-static inline u32 bictcp_clock(void)
+static inline u32 bictcp_clock_us(const struct sock *sk)
 {
-#if HZ < 1000
-	return ktime_to_ms(ktime_get_real());
-#else
-	return jiffies_to_msecs(jiffies);
-#endif
+	return tcp_sk(sk)->tcp_mstamp;
 }
 
 static inline void bictcp_hystart_reset(struct sock *sk)
@@ -131,7 +127,7 @@ static inline void bictcp_hystart_reset(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct bictcp *ca = inet_csk_ca(sk);
 
-	ca->round_start = ca->last_ack = bictcp_clock();
+	ca->round_start = ca->last_ack = bictcp_clock_us(sk);
 	ca->end_seq = tp->snd_nxt;
 	ca->curr_rtt = ~0U;
 	ca->sample_cnt = 0;
@@ -276,7 +272,7 @@ static inline void bictcp_update(struct bictcp *ca, u32 cwnd, u32 acked)
 	 */
 
 	t = (s32)(tcp_jiffies32 - ca->epoch_start);
-	t += msecs_to_jiffies(ca->delay_min >> 3);
+	t += usecs_to_jiffies(ca->delay_min);
 	/* change the unit from HZ to bictcp_HZ */
 	t <<= BICTCP_HZ;
 	do_div(t, HZ);
@@ -382,12 +378,12 @@ static void hystart_update(struct sock *sk, u32 delay)
 	struct bictcp *ca = inet_csk_ca(sk);
 
 	if (hystart_detect & HYSTART_ACK_TRAIN) {
-		u32 now = bictcp_clock();
+		u32 now = bictcp_clock_us(sk);
 
 		/* first detection parameter - ack-train detection */
-		if ((s32)(now - ca->last_ack) <= hystart_ack_delta) {
+		if ((s32)(now - ca->last_ack) <= hystart_ack_delta_us) {
 			ca->last_ack = now;
-			if ((s32)(now - ca->round_start) > ca->delay_min >> 4) {
+			if ((s32)(now - ca->round_start) > ca->delay_min >> 1) {
 				ca->found = 1;
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
@@ -421,9 +417,6 @@ static void hystart_update(struct sock *sk, u32 delay)
 	}
 }
 
-/* Track delayed acknowledgment ratio using sliding window
- * ratio = (15*ratio + sample) / 16
- */
 static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
@@ -438,7 +431,7 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
 	if (ca->epoch_start && (s32)(tcp_jiffies32 - ca->epoch_start) < HZ)
 		return;
 
-	delay = (sample->rtt_us << 3) / USEC_PER_MSEC;
+	delay = sample->rtt_us;
 	if (delay == 0)
 		delay = 1;
 
-- 
2.24.1.735.g03f4e72817-goog

