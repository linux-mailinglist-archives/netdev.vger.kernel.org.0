Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E015129AD8
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfLWU2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:28:12 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:33152 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfLWU2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:28:11 -0500
Received: by mail-pg1-f202.google.com with SMTP id x24so10091110pgl.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nKu4Nf5lomBleAao937WS1G/XEYFtthoweeyAGHX+s4=;
        b=sKKYknPYpQvrTfXLtQ/C1CtY1LIggquKVAHqDF9wEtwbcG8YSaO8NsjltG+yiKSA9N
         K81OHTk4Rr53elKAVA24+g6nCDP83775baXY8YrxWIYnQ1DhzBaNvzWWSTbSTuBky7uu
         ZCbw1LU8xMO9vuQ6E/O87oCKi6HC9fUwwXkLfqvdyDkQCJf8kTMN6hUgCzhwnD+ljIkC
         el671D4Mi3MvVPXp3U+/RJ8uxNfAUkaJzw9D0+XzuTHBuz0CSNERvWG3UV5bcjXp87Jg
         mTl6SML8grwa59hNI1migHHpadOQWT5EWg6geiCAQgCgzVLyJCXem36n44YWgj0kcwE1
         sdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nKu4Nf5lomBleAao937WS1G/XEYFtthoweeyAGHX+s4=;
        b=C1dY5MMAsihZbWeSfpj+HvLvtWicr0XJBTAKaEr9Y/DPIQqyrysDj//JwdIMHRX9sC
         Hq4UPKuDG7PTLJ56aYZhoCWseOzuHNM1NDlINLwo2o2pnY1K9hGdmEtkxD4VLjDPfJhK
         KvdoK76Ky4ro4ruwO0FuG01XeElPcz2LbbuwuXcqlX5D8gKfHUdbiARssIrJl9YjH0pT
         6x2s/jW61j2Kc6YiJi/jfbwH1g7JovsmUvmj8f/x6zjzWWOoKW16H3jbSIZf6sXnG6PP
         TDU2u4k0QhgdrhQxyWz5USnl+4BXH6HouzvF+sEIUDuuQsA18rxx73AqNWDWdTqWFKOv
         xuoA==
X-Gm-Message-State: APjAAAVS/R81d5eW/+y8skjMcinWfww7BsWEvNBNNw1aAyr0RR3idJMO
        NuRN2RKtpLbaQ7rmtTWEOnmLfd7pKugXgw==
X-Google-Smtp-Source: APXvYqxIItOP7eAOHE+/hE5UsCSpAuHo82o/KLIU1m9RAumsAKrgUEa0TXOuFIDx+TSUXmT38Cu8siIHwKkZyw==
X-Received: by 2002:a65:49ca:: with SMTP id t10mr34188322pgs.37.1577132891073;
 Mon, 23 Dec 2019 12:28:11 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:27:53 -0800
In-Reply-To: <20191223202754.127546-1-edumazet@google.com>
Message-Id: <20191223202754.127546-5-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next v2 4/5] tcp_cubic: tweak Hystart detection for short
 RTT flows
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

After switching ca->delay_min to usec resolution, we exit
slow start prematurely for very low RTT flows, setting
snd_ssthresh to 20.

The reason is that delay_min is fed with RTT of small packet
trains. Then as cwnd is increased, TCP sends bigger TSO packets.

LRO/GRO aggregation and/or interrupt mitigation strategies
on receiver tend to inflate RTT samples.

Fix this by adding to delay_min the expected delay of
two TSO packets, given current pacing rate.

Tested:

Sender uses pfifo_fast qdisc

Before :
$ nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
  11348
  11707
  11562
  11428
  11773
  11534
   9878
  11693
  10597
  10968
TcpExtTCPHystartTrainDetect     10                 0.0
TcpExtTCPHystartTrainCwnd       200                0.0

After :
$ nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
  14877
  14517
  15797
  18466
  17376
  14833
  17558
  17933
  16039
  18059
TcpExtTCPHystartTrainDetect     10                 0.0
TcpExtTCPHystartTrainCwnd       1670               0.0

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 068775b91fb5790e6e60a6490b49e7a266e4ed51..0e5428ed04fe4e50627e21a53c3d17f9f2dade4d 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -436,8 +436,27 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
 		delay = 1;
 
 	/* first time call or link delay decreases */
-	if (ca->delay_min == 0 || ca->delay_min > delay)
-		ca->delay_min = delay;
+	if (ca->delay_min == 0 || ca->delay_min > delay) {
+		unsigned long rate = READ_ONCE(sk->sk_pacing_rate);
+
+		/* Account for TSO/GRO delays.
+		 * Otherwise short RTT flows could get too small ssthresh,
+		 * since during slow start we begin with small TSO packets
+		 * and could lower ca->delay_min too much.
+		 * Ideally even with a very small RTT we would like to have
+		 * at least one TSO packet being sent and received by GRO,
+		 * and another one in qdisc layer.
+		 * We apply another 100% factor because @rate is doubled at
+		 * this point.
+		 * We cap the cushion to 1ms.
+		 */
+		if (rate)
+			delay += min_t(u64, USEC_PER_MSEC,
+				       div64_ul((u64)GSO_MAX_SIZE *
+						4 * USEC_PER_SEC, rate));
+		if (ca->delay_min == 0 || ca->delay_min > delay)
+			ca->delay_min = delay;
+	}
 
 	/* hystart triggers when cwnd is larger than some threshold */
 	if (!ca->found && hystart && tcp_in_slow_start(tp) &&
-- 
2.24.1.735.g03f4e72817-goog

