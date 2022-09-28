Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F985EE665
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiI1UDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbiI1UDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:03:45 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C52A7B1F4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:03:43 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id s18so8651903qtx.6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=loHgHlWbpFZ+zsk+Erbuc+MoA3TNdg/sFkR8FOQtyy4=;
        b=UwXcj5XrCQ+ur1L3PbJOcFE4pZ+j6s5kyvdcmct0Hzu3S1l0NmOPps9TiNCAsw5QJr
         aPT8UkjcTKhbBHXAgJqQcJ/MIg3LfLhAzC9D+qIA66/F2CVIdUHDIZv6t0Kh7cGOLJ18
         87UyDp2DjQiNuW5VP5usbqR+OmRJ2hwncWF2I3WAEtWo/b2gcbM+pUWQgN4+MQ04YOVo
         t73jmTpHHGVoMx0nIMAMLPabb0XfdghmnujL1t/MmloJZSbhM4XknqQGymhb0jMt7wNH
         t8w94i5buNSem1KGPOovmNuQE/Tz3M1MEGtxLYepvsv4SEd21nz2JIkAEuAOTvTvF+jV
         EGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=loHgHlWbpFZ+zsk+Erbuc+MoA3TNdg/sFkR8FOQtyy4=;
        b=h6Q2+L1vMW6GOlSY+ZpzEmouG4Xy0Gb39fZox9QgJeiBDja3fdlct0NAtubu9sptZQ
         xk46xU8vfU7mX1vzFQWGtvYzQwbQMeL42jVNey7a6lNkeBkqBR00+bMy9ubiOXZtwGvl
         DVcbD7PpscV9Om+HrruPG7qmlFc4g5ZkdTj75Iu4Zd8WcHWxDJp2U67EAl7HsqJBu8Fp
         /yPFva23HA/mAaRplVFv8kJf4jFPh+fNKdtL1CmU4kt8o3t6GhFSIcPcT33Lq6xKL+Qj
         y49oBzngjWPfpfqP72ScVRkRxXRgzx5MXY6NQwBOsJkcOkC70UYXqmv/fz+XsNmzmpTd
         mwzg==
X-Gm-Message-State: ACrzQf0i00EiFCLK6OlxRZW5j2flxs0nfEP8YFXVRAGhF1IKz7VjOfpj
        LWif2msmyqnOjYBUkfGHMZY=
X-Google-Smtp-Source: AMsMyM5ZqPkdcTLuOrvic4fYnwESnytuwuqx90eFPkK/fZJ+0H0YWwFTGBYIrEJ4dDB5tBGgWEEvYQ==
X-Received: by 2002:ac8:5f09:0:b0:35c:dc80:93c1 with SMTP id x9-20020ac85f09000000b0035cdc8093c1mr28462989qta.657.1664395422225;
        Wed, 28 Sep 2022 13:03:42 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:317:7b08:e610:d4fb:f28d])
        by smtp.gmail.com with ESMTPSA id f8-20020a05620a280800b006b929a56a2bsm3802895qkp.3.2022.09.28.13.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 13:03:41 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Kevin Yang <yyd@google.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH net] tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited
Date:   Wed, 28 Sep 2022 16:03:31 -0400
Message-Id: <20220928200331.2997272-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

This commit fixes a bug in the tracking of max_packets_out and
is_cwnd_limited. This bug can cause the connection to fail to remember
that is_cwnd_limited is true, causing the connection to fail to grow
cwnd when it should, causing throughput to be lower than it should be.

The following event sequence is an example that triggers the bug:

 (a) The connection is cwnd_limited, but packets_out is not at its
     peak due to TSO deferral deciding not to send another skb yet.
     In such cases the connection can advance max_packets_seq and set
     tp->is_cwnd_limited to true and max_packets_out to a small
     number.

(b) Then later in the round trip the connection is pacing-limited (not
     cwnd-limited), and packets_out is larger. In such cases the
     connection would raise max_packets_out to a bigger number but
     (unexpectedly) flip tp->is_cwnd_limited from true to false.

This commit fixes that bug.

One straightforward fix would be to separately track (a) the next
window after max_packets_out reaches a maximum, and (b) the next
window after tp->is_cwnd_limited is set to true. But this would
require consuming an extra u32 sequence number.

Instead, to save space we track only the most important
information. Specifically, we track the strongest available signal of
the degree to which the cwnd is fully utilized:

(1) If the connection is cwnd-limited then we remember that fact for
the current window.

(2) If the connection not cwnd-limited then we track the maximum
number of outstanding packets in the current window.

In particular, note that the new logic cannot trigger the buggy
(a)/(b) sequence above because with the new logic a condition where
tp->packets_out > tp->max_packets_out can only trigger an update of
tp->is_cwnd_limited if tp->is_cwnd_limited is false.

This first showed up in a testing of a BBRv2 dev branch, but this
buggy behavior highlighted a general issue with the
tcp_cwnd_validate() logic that can cause cwnd to fail to increase at
the proper rate for any TCP congestion control, including Reno or
CUBIC.

Fixes: ca8a22634381 ("tcp: make cwnd-limited checks measurement-based, and gentler")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h   |  2 +-
 include/net/tcp.h     |  5 ++++-
 net/ipv4/tcp.c        |  2 ++
 net/ipv4/tcp_output.c | 19 ++++++++++++-------
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a9fbe22732c3..4791fd801945 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -295,7 +295,7 @@ struct tcp_sock {
 	u32	packets_out;	/* Packets which are "in flight"	*/
 	u32	retrans_out;	/* Retransmitted packets out		*/
 	u32	max_packets_out;  /* max packets_out in last window */
-	u32	max_packets_seq;  /* right edge of max_packets_out flight */
+	u32	cwnd_usage_seq;  /* right edge of cwnd usage tracking flight */
 
 	u16	urg_data;	/* Saved octet of OOB data and control flags */
 	u8	ecn_flags;	/* ECN status bits.			*/
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d10962b9f0d0..95c1d51393ac 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1295,11 +1295,14 @@ static inline bool tcp_is_cwnd_limited(const struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
+	if (tp->is_cwnd_limited)
+		return true;
+
 	/* If in slow start, ensure cwnd grows to twice what was ACKed. */
 	if (tcp_in_slow_start(tp))
 		return tcp_snd_cwnd(tp) < 2 * tp->max_packets_out;
 
-	return tp->is_cwnd_limited;
+	return false;
 }
 
 /* BBR congestion control needs pacing.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e373dde1f46f..997a80ce1e13 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3137,6 +3137,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tcp_snd_cwnd_set(tp, TCP_INIT_CWND);
 	tp->snd_cwnd_cnt = 0;
+	tp->is_cwnd_limited = 0;
+	tp->max_packets_out = 0;
 	tp->window_clamp = 0;
 	tp->delivered = 0;
 	tp->delivered_ce = 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 290019de766d..c69f4d966024 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1875,15 +1875,20 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 	const struct tcp_congestion_ops *ca_ops = inet_csk(sk)->icsk_ca_ops;
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	/* Track the maximum number of outstanding packets in each
-	 * window, and remember whether we were cwnd-limited then.
+	/* Track the strongest available signal of the degree to which the cwnd
+	 * is fully utilized. If cwnd-limited then remember that fact for the
+	 * current window. If not cwnd-limited then track the maximum number of
+	 * outstanding packets in the current window. (If cwnd-limited then we
+	 * chose to not update tp->max_packets_out to avoid an extra else
+	 * clause with no functional impact.)
 	 */
-	if (!before(tp->snd_una, tp->max_packets_seq) ||
-	    tp->packets_out > tp->max_packets_out ||
-	    is_cwnd_limited) {
-		tp->max_packets_out = tp->packets_out;
-		tp->max_packets_seq = tp->snd_nxt;
+	if (!before(tp->snd_una, tp->cwnd_usage_seq) ||
+	    is_cwnd_limited ||
+	    (!tp->is_cwnd_limited &&
+	     tp->packets_out > tp->max_packets_out)) {
 		tp->is_cwnd_limited = is_cwnd_limited;
+		tp->max_packets_out = tp->packets_out;
+		tp->cwnd_usage_seq = tp->snd_nxt;
 	}
 
 	if (tcp_is_cwnd_limited(sk)) {
-- 
2.37.3.998.g577e59143f-goog

