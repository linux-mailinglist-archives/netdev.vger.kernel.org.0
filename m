Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D0A12D081
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfL3OG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:06:26 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:39515 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbfL3OGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 09:06:25 -0500
Received: by mail-pj1-f73.google.com with SMTP id c67so13432813pje.4
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 06:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yfMMU8Pu7gT1rnx6o68HRWo86yxf3vb1ceNg5Yd8YaI=;
        b=BmaP1tprVMX+ZVJmtYx5r1cVRxkZFm5/cS/NmfT/BdJNxgC+iCAfR2FmCZABOAUByB
         F/SbdK5MM856qQrnB69/Dp61utDVr5cn0Azocv2VS5R5rzXIl5yh2uu6qZBKjjz8bQDo
         AnYsMepytdnn9vP94Lc8vuK3Xjphxz3vTvbtnL3HQCdQ9dkfoAS1Mqtc/CIPF2hJGGng
         DLuudgx+FkSAt4k9YGgkYEU6m8mPdq2/tQ+fXXIa7TO2W1WLVUEbr/9Yl7mgGnPCqcJy
         i42shu9Hkon4w/P8IcANvEM3JmSAWfKJa6UvBYnKrdW8fvrFPJ9Eaf5P+cqHcHp++byD
         fElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yfMMU8Pu7gT1rnx6o68HRWo86yxf3vb1ceNg5Yd8YaI=;
        b=clOicy0WQV1+p0UMhZGR8MpgeEjLRGBRFRD6Fn06028PO4WRPRqSu9vORukE4rMSUD
         yywyFvceeSEBMu4RKaaeBgfu+8jdRbzNE7NLAAr+maMnk6AZ3bQLF7W3PcUIhlEjEmSB
         9tTma0taB80/8E2wPOdH29Dzk9mLTHpOLDx1amca6euBHjwC8d3cxRjfhNqewI2JiQid
         ir84i/coN+yqZdfdJgJOC2DiVvayT7FGgs0zSgcQFywuxDhaJ40u0b5AJE9OUkoCG26k
         a7pVzsaLjW/6yKb7A1Q6mYPk5m9wzmSLsa5WKIrgfg9W5TBJvTGIgqnuTMgW9lKQ2M7u
         woHg==
X-Gm-Message-State: APjAAAUowDRb/sErXDTM3npG8pfCSwN2Vk7g2HbclpE+VC+6GQivqybW
        xVTax9bt2DlIa457gVaFk1EFc+6w6BwShQ==
X-Google-Smtp-Source: APXvYqxV9dRIbs7TIx/ySS1GTw0bZOXCL44NvQVhtDUwveT/YgjFqizECppH4ePULL0WM2KFr5WQ0rOVVyqnbA==
X-Received: by 2002:a63:f64a:: with SMTP id u10mr70021397pgj.16.1577714783605;
 Mon, 30 Dec 2019 06:06:23 -0800 (PST)
Date:   Mon, 30 Dec 2019 06:06:19 -0800
Message-Id: <20191230140619.137147-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] tcp_cubic: refactor code to perform a divide only when needed
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

Neal Cardwell suggested to not change ca->delay_min
and apply the ack delay cushion only when Hystart ACK train
is still under consideration. This should avoid a 64bit
divide unless needed.

Tested:

40Gbit(mlx4) testbed (with sch_fq as packet scheduler)

$ echo -n 'file tcp_cubic.c +p'  >/sys/kernel/debug/dynamic_debug/control
$ nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
  14815
  16280
  15293
  15563
  11574
  15145
  14789
  18548
  16972
  12520
TcpExtTCPHystartTrainDetect     10                 0.0
TcpExtTCPHystartTrainCwnd       1396               0.0
$ dmesg | tail -10
[ 4873.951350] hystart_ack_train (116 > 93) delay_min 24 (+ ack_delay 69) cwnd 80
[ 4875.155379] hystart_ack_train (55 > 50) delay_min 21 (+ ack_delay 29) cwnd 160
[ 4876.333921] hystart_ack_train (69 > 62) delay_min 23 (+ ack_delay 39) cwnd 130
[ 4877.519037] hystart_ack_train (69 > 60) delay_min 22 (+ ack_delay 38) cwnd 130
[ 4878.701559] hystart_ack_train (87 > 63) delay_min 24 (+ ack_delay 39) cwnd 160
[ 4879.844597] hystart_ack_train (93 > 50) delay_min 21 (+ ack_delay 29) cwnd 216
[ 4880.956650] hystart_ack_train (74 > 67) delay_min 20 (+ ack_delay 47) cwnd 108
[ 4882.098500] hystart_ack_train (61 > 57) delay_min 23 (+ ack_delay 34) cwnd 130
[ 4883.262056] hystart_ack_train (72 > 67) delay_min 21 (+ ack_delay 46) cwnd 130
[ 4884.418760] hystart_ack_train (74 > 67) delay_min 29 (+ ack_delay 38) cwnd 152

10Gbit(bnx2x) testbed (with sch_fq as packet scheduler)

$ echo -n 'file tcp_cubic.c +p'  >/sys/kernel/debug/dynamic_debug/control
$ nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpk52 -l -4000000; done;nstat|egrep "Hystart"
   7050
   7065
   7100
   6900
   7202
   7263
   7189
   6869
   7463
   7034
TcpExtTCPHystartTrainDetect     10                 0.0
TcpExtTCPHystartTrainCwnd       3199               0.0
$ dmesg | tail -10
[  176.920012] hystart_ack_train (161 > 141) delay_min 83 (+ ack_delay 58) cwnd 264
[  179.144645] hystart_ack_train (164 > 159) delay_min 120 (+ ack_delay 39) cwnd 444
[  181.354527] hystart_ack_train (214 > 168) delay_min 125 (+ ack_delay 43) cwnd 436
[  183.539565] hystart_ack_train (170 > 147) delay_min 96 (+ ack_delay 51) cwnd 326
[  185.727309] hystart_ack_train (177 > 160) delay_min 61 (+ ack_delay 99) cwnd 128
[  187.947142] hystart_ack_train (184 > 167) delay_min 123 (+ ack_delay 44) cwnd 367
[  190.166680] hystart_ack_train (230 > 153) delay_min 116 (+ ack_delay 37) cwnd 444
[  192.327285] hystart_ack_train (210 > 206) delay_min 86 (+ ack_delay 120) cwnd 152
[  194.511392] hystart_ack_train (173 > 151) delay_min 94 (+ ack_delay 57) cwnd 239
[  196.736023] hystart_ack_train (149 > 146) delay_min 105 (+ ack_delay 41) cwnd 399

Fixes: 42f3a8aaae66 ("tcp_cubic: tweak Hystart detection for short RTT flows")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Neal Cardwell <ncardwell@google.com>
Link: https://www.spinics.net/lists/netdev/msg621886.html
Link: https://www.spinics.net/lists/netdev/msg621797.html
---
 net/ipv4/tcp_cubic.c | 51 ++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index d02bb283c6890e1692e714e053515c6e4981d83a..8f8eefd3a3ce116aa8fa2b7ef85c7eb503fa8da7 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -372,6 +372,26 @@ static void bictcp_state(struct sock *sk, u8 new_state)
 	}
 }
 
+/* Account for TSO/GRO delays.
+ * Otherwise short RTT flows could get too small ssthresh, since during
+ * slow start we begin with small TSO packets and ca->delay_min would
+ * not account for long aggregation delay when TSO packets get bigger.
+ * Ideally even with a very small RTT we would like to have at least one
+ * TSO packet being sent and received by GRO, and another one in qdisc layer.
+ * We apply another 100% factor because @rate is doubled at this point.
+ * We cap the cushion to 1ms.
+ */
+static u32 hystart_ack_delay(struct sock *sk)
+{
+	unsigned long rate;
+
+	rate = READ_ONCE(sk->sk_pacing_rate);
+	if (!rate)
+		return 0;
+	return min_t(u64, USEC_PER_MSEC,
+		     div64_ul((u64)GSO_MAX_SIZE * 4 * USEC_PER_SEC, rate));
+}
+
 static void hystart_update(struct sock *sk, u32 delay)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -385,7 +405,8 @@ static void hystart_update(struct sock *sk, u32 delay)
 		if ((s32)(now - ca->last_ack) <= hystart_ack_delta_us) {
 			ca->last_ack = now;
 
-			threshold = ca->delay_min;
+			threshold = ca->delay_min + hystart_ack_delay(sk);
+
 			/* Hystart ack train triggers if we get ack past
 			 * ca->delay_min/2.
 			 * Pacing might have delayed packets up to RTT/2
@@ -396,6 +417,9 @@ static void hystart_update(struct sock *sk, u32 delay)
 
 			if ((s32)(now - ca->round_start) > threshold) {
 				ca->found = 1;
+				pr_debug("hystart_ack_train (%u > %u) delay_min %u (+ ack_delay %u) cwnd %u\n",
+					 now - ca->round_start, threshold,
+					 ca->delay_min, hystart_ack_delay(sk), tp->snd_cwnd);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
 				NET_ADD_STATS(sock_net(sk),
@@ -447,30 +471,11 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
 		delay = 1;
 
 	/* first time call or link delay decreases */
-	if (ca->delay_min == 0 || ca->delay_min > delay) {
-		unsigned long rate = READ_ONCE(sk->sk_pacing_rate);
-
-		/* Account for TSO/GRO delays.
-		 * Otherwise short RTT flows could get too small ssthresh,
-		 * since during slow start we begin with small TSO packets
-		 * and could lower ca->delay_min too much.
-		 * Ideally even with a very small RTT we would like to have
-		 * at least one TSO packet being sent and received by GRO,
-		 * and another one in qdisc layer.
-		 * We apply another 100% factor because @rate is doubled at
-		 * this point.
-		 * We cap the cushion to 1ms.
-		 */
-		if (rate)
-			delay += min_t(u64, USEC_PER_MSEC,
-				       div64_ul((u64)GSO_MAX_SIZE *
-						4 * USEC_PER_SEC, rate));
-		if (ca->delay_min == 0 || ca->delay_min > delay)
-			ca->delay_min = delay;
-	}
+	if (ca->delay_min == 0 || ca->delay_min > delay)
+		ca->delay_min = delay;
 
 	/* hystart triggers when cwnd is larger than some threshold */
-	if (!ca->found && hystart && tcp_in_slow_start(tp) &&
+	if (!ca->found && tcp_in_slow_start(tp) && hystart &&
 	    tp->snd_cwnd >= hystart_low_window)
 		hystart_update(sk, delay);
 }
-- 
2.24.1.735.g03f4e72817-goog

