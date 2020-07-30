Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56918233C4E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgG3Xxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbgG3Xxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:53:54 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E90C061575
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:53:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f4so19652218plo.3
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=khT0jKK2X0OeO4rXseCf89a7fokdlSElFCQ5cebNuPI=;
        b=QVxbGwhwWxuMh1UyRFlwAGnXjgjysWlsTFqPskZS2oYSY+AVDA3hIsTdNB4lMfFgu/
         4qzWiIMjP/6+Es4/hTrXGAJw9NKDLQ6sdGWk5BdMoYUV9Xt59ZUIZkpjEkNn/gByqMDi
         4lfpWHrGdKm2VfRcH6Z61pKciIJU3KlxoMrpTEXVWvS5VECMwLpEGesUtWDN377xQ51z
         8GU951ssr8VSRW3aYPPhdLbt6wa0gbY2q6mTq8SMlSvDjvNWnPiF5MQBdeeJo9IuI8Iz
         Ukwl881YB9LsX4QnaHkysPNnZ35aVOYfai411kR+HjVVbimQEqkmHY2U/nd2CUGqLBDU
         1aDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=khT0jKK2X0OeO4rXseCf89a7fokdlSElFCQ5cebNuPI=;
        b=edMbYZVclj8jCzkKBCpGd4VAJh4S5jJ0A+8fuczXmBt2xUrA1H7pmTr7ity5rYoW7s
         VSfoXil2oYELMkBKM2mBDQrMpIOogTwiGqBlhqi1XBOF9aytfXpO4AcpEUDcXmnGNPFK
         N5z0sqy1cCmMre+q/lMu0Wt0GyiRTjA3nLXpPkHZjg4Wz3dzKM+GYYELd75SLpA7064c
         LhnJ0ck8+O3w0pZz+1sO+v80dv/ovcYhJrRij4XqgiW97FFkdFJaT1kYI1TmcRfXo8OS
         KnoPmAfUt8l8459zbZc6OIJCsSsylJKw0TOm8QXu08l2CkvDtmNFvDze2Jwk6EplTgSR
         IpWw==
X-Gm-Message-State: AOAM530i45kaNHY7tWSIoiCm88G6EnL61DmwwkyLS4o4ajoYsXJDZsYM
        hU/A7qARXZL/5o1hFYnvmO4qrDcPmsQ=
X-Google-Smtp-Source: ABdhPJwgExA9QHaeRmO9kz08jJv/48YAq5p2FYJSUZDWaKLlHtYYqMwtRWO2ENptUkBnc7elnQA72uC/QTY=
X-Received: by 2002:a17:90a:a502:: with SMTP id a2mr1479432pjq.15.1596153233623;
 Thu, 30 Jul 2020 16:53:53 -0700 (PDT)
Date:   Thu, 30 Jul 2020 23:49:16 +0000
Message-Id: <20200730234916.2708735-1-jfwang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH net-next] tcp: apply a floor of 1 for RTT samples from TCP timestamps
From:   Jianfeng Wang <jfwang@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jianfeng Wang <jfwang@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Kevin Yang <yyd@google.com>, Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For retransmitted packets, TCP needs to resort to using TCP timestamps
for computing RTT samples. In the common case where the data and ACK
fall in the same 1-millisecond interval, TCP senders with millisecond-
granularity TCP timestamps compute a ca_rtt_us of 0. This ca_rtt_us
of 0 propagates to rs->rtt_us.

This value of 0 can cause performance problems for congestion control
modules. For example, in BBR, the zero min_rtt sample can bring the
min_rtt and BDP estimate down to 0, reduce snd_cwnd and result in a
low throughput. It would be hard to mitigate this with filtering in
the congestion control module, because the proper floor to apply would
depend on the method of RTT sampling (using timestamp options or
internally-saved transmission timestamps).

This fix applies a floor of 1 for the RTT sample delta from TCP
timestamps, so that seq_rtt_us, ca_rtt_us, and rs->rtt_us will be at
least 1 * (USEC_PER_SEC / TCP_TS_HZ).

Note that the receiver RTT computation in tcp_rcv_rtt_measure() and
min_rtt computation in tcp_update_rtt_min() both already apply a floor
of 1 timestamp tick, so this commit makes the code more consistent in
avoiding this edge case of a value of 0.

Signed-off-by: Jianfeng Wang <jfwang@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/tcp_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a018bafd7bdf..b725288b7e67 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2950,6 +2950,8 @@ static bool tcp_ack_update_rtt(struct sock *sk, const int flag,
 		u32 delta = tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;
 
 		if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
+			if (!delta)
+				delta = 1;
 			seq_rtt_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
 			ca_rtt_us = seq_rtt_us;
 		}
-- 
2.28.0.163.g6104cc2f0b6-goog

