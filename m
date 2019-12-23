Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C82129ACC
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfLWUUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:20:23 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:42906 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:20:22 -0500
Received: by mail-pf1-f202.google.com with SMTP id p126so6700085pfb.9
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nKu4Nf5lomBleAao937WS1G/XEYFtthoweeyAGHX+s4=;
        b=UdyKbTOnTgb8Tef/GRcMO2z6s7LTE/5IcnR49BlubfNX7JI+QNYzXz+tysUc6Jy2X1
         6FC8ABi4jfDaIf119UrWXA2i4nuKnaY52bASyfVqWChsXasE26yQF27oP7I8TuNCtppa
         sSv3WhN/Q+5QclsegfRrZSDx00/WTr3c/b1dgb1hcbrTPqaHxFT2koSAJibTDWLHJnwI
         dVnNO8phlL77jNpjmBRyl8UeRWh94dM58sHidP2RnYDaEakWPN4A1uePc51vOMt444HD
         VA4wytSfg3yBj4m90KLKCatANprGkg1U8gR7J1QG+uKEoc/rYjcDsgY3v0h2AjQ9uzdO
         /XMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nKu4Nf5lomBleAao937WS1G/XEYFtthoweeyAGHX+s4=;
        b=PVVb+GtAdo/VTII5V3xvp5YI8NKNIE2dxtE4bqOfW7bchp0rSl5NSkolSkwTZQ6ViF
         MUCwXhZEC2m7Tf/LE5vftPuMVARzcr+LrVdpLvPkN6VD7r2pbYKH8iuUBsVb/BKKU+F2
         jlqbJKCP+Z5w3O2P6Rsa6pZ5z+bGlBNKwkdbu9D1szAaosO42JF89zRtDUSPnPm0Iopq
         Hshbsl51OnM/gAoHxUyYl8ibgTIMcVpm35kcMB6zozRsZWfMXDWQHiXeot9lwFETY3u6
         xWYOvr5DDsQSQ9cVjE4kHeHMeQcgAb+CsGmXdvuE4AO+AYOsl/E6Lsx4oLAodoye4YqU
         7/7g==
X-Gm-Message-State: APjAAAU5P8ZUUKoBMiqqD6jULMjB7JP9ukvGWbxlb/TxoNGkbU64T4Eq
        L5dcPwaqicubhJBV0wy6aYrkHQj4A3Gkvg==
X-Google-Smtp-Source: APXvYqzJABChd5xyFyKsJRcPqX6UxtEqgsMpL5QSe68ElzzSHwGS8ZwM0XyfytALP2XG2Wt0qacPDP66xi8n3Q==
X-Received: by 2002:a65:66ce:: with SMTP id c14mr34262456pgw.262.1577132421992;
 Mon, 23 Dec 2019 12:20:21 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:20:04 -0800
In-Reply-To: <20191223202005.104713-1-edumazet@google.com>
Message-Id: <20191223202005.104713-5-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202005.104713-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next 4/5] tcp_cubic: tweak Hystart detection for short RTT flows
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

