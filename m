Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B561445AD60
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhKWU3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240362AbhKWU3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:29:02 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB940C0613F7
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:25:40 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id p17so143705pgj.2
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wfofEtvqW3xTk34fqti34HhJKeVtJLbfMhejzypz+ek=;
        b=nScr7TZ0CeQdWRzgXkh08wUsgfIZ6PnUTP7dIitT/JuFr3uWByRzU16dXfbvDrzZxa
         B261trhEJqv42oFjrOWaDUlSTQEH9uUI9SswGnKXvAtyL7+VmktOBTq2nQyXRXGBklmL
         SXqLl3CykSQsrWe9NTOxh6fzmPWINcrdTdmjPzOpnv9e/f4bguekwj2VG5DuQrYY0j0j
         HROzSf8vISSSZubOVS+UsSPffTWEoAgNi8d2I1jMlszLD/JMTeZV3PgfTtccacdGDD/A
         1UDC7uoWJobKzh2XZYmQT7issv3reEahxWyb5Gq6hvBhetla/AqmuA976dtAd6lmKZO/
         QZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wfofEtvqW3xTk34fqti34HhJKeVtJLbfMhejzypz+ek=;
        b=xWFHuocKSDnA+a/F42ClXPtr9a3BmXjFrtgBg4SrTITovHVZmKGn/0YVEhg0t2KZTp
         Ihm/yE7tRTPep1g0qkpJWlRVwssCzGKGpdpjQ3Cz/hbp3II2P+hO1mvcOXg5KhMfNLvw
         gYpJMbpvoaLM5drDMCLXkY15VEjf6JUh1gDArVgg8vT2L4epx1fPYVgyHstX7pf/sC3p
         b06Bt7ADLNKY7XxudubcoHg309zK/pZ84Kop1YLtDhKlFNF2jw8vpgaoKc6Zu5ApVxa+
         wonk6mxtlbgaZYqMR1Ww0R7wnl/ODSiHNW1aZPtjXns9oHY+7i3z1dYehL+QAxBPO3Tp
         nPig==
X-Gm-Message-State: AOAM532uaxE05LjSqCEBNSPhR0cgLhBMqCTLe6tN6RuPlHHssSBwpMJc
        JgKRPH5IB3q0wezZTUcXL+0Ar3uFo28=
X-Google-Smtp-Source: ABdhPJyYrT5FicSYA6xvTuEQMzNnW7DDnGgzGs1pACWQN6L3tEiA2HM8nCUK4NJ1VFoJr7JzvAr5Gw==
X-Received: by 2002:a05:6a00:848:b0:49f:b215:e002 with SMTP id q8-20020a056a00084800b0049fb215e002mr8242886pfk.47.1637699140432;
        Tue, 23 Nov 2021 12:25:40 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8b31:9924:47bf:5e47])
        by smtp.gmail.com with ESMTPSA id g10sm14610419pfc.180.2021.11.23.12.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:25:39 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH net] tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows
Date:   Tue, 23 Nov 2021 12:25:35 -0800
Message-Id: <20211123202535.1843771-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While testing BIG TCP patch series, I was expecting that TCP_RR workloads
with 80KB requests/answers would send one 80KB TSO packet,
then being received as a single GRO packet.

It turns out this was not happening, and the root cause was that
cubic Hystart ACK train was triggering after a few (2 or 3) rounds of RPC.

Hystart was wrongly setting CWND/SSTHRESH to 30, while my RPC
needed a budget of ~20 segments.

Ideally these TCP_RR flows should not exit slow start.

Cubic Hystart should reset itself at each round, instead of assuming
every TCP flow is a bulk one.

Note that even after this patch, Hystart can still trigger, depending
on scheduling artifacts, but at a higher CWND/SSTHRESH treshold,
keeping optimal TSO packet sizes.

Tested:

ip link set dev eth0 gro_ipv6_max_size 131072 gso_ipv6_max_size 131072
nstat -n; netperf -H ... -t TCP_RR  -l 5  -- -r 80000,80000 -K cubic; nstat|egrep "Ip6InReceives|Hystart|Ip6OutRequests"

Before:

   8605
Ip6InReceives                   87541              0.0
Ip6OutRequests                  129496             0.0
TcpExtTCPHystartTrainDetect     1                  0.0
TcpExtTCPHystartTrainCwnd       30                 0.0

After:

  8760
Ip6InReceives                   88514              0.0
Ip6OutRequests                  87975              0.0

Fixes: ae27e98a5152 ("[TCP] CUBIC v2.3")
Co-developed-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_cubic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 5e9d9c51164c4d23a90ebd2be0d7bf85098b47dc..e07837e23b3fd2435c87320945528abdee9817cc 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -330,8 +330,6 @@ static void cubictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		return;
 
 	if (tcp_in_slow_start(tp)) {
-		if (hystart && after(ack, ca->end_seq))
-			bictcp_hystart_reset(sk);
 		acked = tcp_slow_start(tp, acked);
 		if (!acked)
 			return;
@@ -391,6 +389,9 @@ static void hystart_update(struct sock *sk, u32 delay)
 	struct bictcp *ca = inet_csk_ca(sk);
 	u32 threshold;
 
+	if (after(tp->snd_una, ca->end_seq))
+		bictcp_hystart_reset(sk);
+
 	if (hystart_detect & HYSTART_ACK_TRAIN) {
 		u32 now = bictcp_clock_us(sk);
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

