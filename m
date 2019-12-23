Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38EF129ACD
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfLWUU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:20:28 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:52464 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:20:27 -0500
Received: by mail-pl1-f201.google.com with SMTP id x10so8741997plo.19
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A3DbLOdyNAUecDRtpjaIblc9q6MqYgAuowRkHmUyU4c=;
        b=hmcmKEWIYS5+IZErHJxOhg6/bOV+WGSqGmCbbIf/J1CduPghIsBIJ6zD0HRag5k61y
         V20b54QuSfLd1uFqBrK7QKdw8ngjQp03TRwq4bxDyl2TVBjmQ6urrey/vqgya+S4FDnl
         oMqsSdXHgYXzkqvzclR/0bluGfhVo/Oa1mmzmyCOoYXinaiJdjOYbDqxryuSQUkA8mxe
         47tfklQ2YKEavuLBI6ZY8Wg8R2L5tzpOtRmg7kcXIs8y93HraMhPH0OpA+HR7OpkmtOH
         r7RF+ATpylZrXAWEtlUOMAD3Hm9+XWTk4LXBEwqazUhxidHQblbs2vqGgfIx1I8VcdEx
         YJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A3DbLOdyNAUecDRtpjaIblc9q6MqYgAuowRkHmUyU4c=;
        b=HHAVWXA0F/JZgGnoHomQfeniIK5aSwyLIJNVVHnkkjVWKU3/LUsocFy5fHcrPQnvEm
         ZVN4r7BTf5rrgazFSp7tqmuGq1kAHtu4nqFrK3FSSFVsk4ZFFTVIKZFP3IquIrvTiT9N
         m9Hqdh6t9AZNoejNZqUdFbH5bi4+bzN+E+PdZGyEcxkWpVnzGhxLGHySfVTC4u9OPXbZ
         CI67+kvo9j5mr8cLzq4gu/enUA7Uznv3GaMG41PO2R2xmUyQCR6NhVK/77HrPUlkV2DI
         +VGqam1j4spfehb8EKmMcfkqLkZqV0ehelGfb4eM2rddE39mnlAQXrFXp6mc4GJl02qA
         QLqQ==
X-Gm-Message-State: APjAAAWrgdUOtjcF9ozohhKwFHodc+vWhx5/w3XkHuTjQPs6q4huYgRs
        tz3RDARd0WGRvj8UKIk6xSVH1mGgZWGLSA==
X-Google-Smtp-Source: APXvYqzJgbC0UCI2O4aB/BN9YJwxLZeACEWwqrWxltqpO/No2jQNGWRy540T51MQ825BHNFk7t+W6bKiMyKvFg==
X-Received: by 2002:a63:4723:: with SMTP id u35mr32124107pga.194.1577132425509;
 Mon, 23 Dec 2019 12:20:25 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:20:05 -0800
In-Reply-To: <20191223202005.104713-1-edumazet@google.com>
Message-Id: <20191223202005.104713-6-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202005.104713-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next 5/5] tcp_cubic: make Hystart aware of pacing
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

For years we disabled Hystart ACK train detection at Google
because it was fooled by TCP pacing.

ACK train detection uses a simple heuristic, detecting if
we receive ACK past half the RTT, to exit slow start before
hitting the bottleneck and experience massive drops.

But pacing by design might delay packets up to RTT/2,
so we need to tweak the Hystart logic to be aware of this
extra delay.

Tested:
 Added a 100 usec delay at receiver.

Before:
nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
   9117
   7057
   9553
   8300
   7030
   6849
   9533
  10126
   6876
   8473
TcpExtTCPHystartTrainDetect     10                 0.0
TcpExtTCPHystartTrainCwnd       1230               0.0

After :
nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
   9845
  10103
  10866
  11096
  11936
  11487
  11773
  12188
  11066
  11894
TcpExtTCPHystartTrainDetect     10                 0.0
TcpExtTCPHystartTrainCwnd       6462               0.0

Disabling Hystart ACK Train detection gives similar numbers

echo 2 >/sys/module/tcp_cubic/parameters/hystart_detect
nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
  11173
  10954
  12455
  10627
  11578
  11583
  11222
  10880
  10665
  11366

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 0e5428ed04fe4e50627e21a53c3d17f9f2dade4d..8ed25999381919af3dda59402a8c354c6115df24 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -376,6 +376,7 @@ static void hystart_update(struct sock *sk, u32 delay)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct bictcp *ca = inet_csk_ca(sk);
+	u32 threshold;
 
 	if (hystart_detect & HYSTART_ACK_TRAIN) {
 		u32 now = bictcp_clock_us(sk);
@@ -383,7 +384,17 @@ static void hystart_update(struct sock *sk, u32 delay)
 		/* first detection parameter - ack-train detection */
 		if ((s32)(now - ca->last_ack) <= hystart_ack_delta_us) {
 			ca->last_ack = now;
-			if ((s32)(now - ca->round_start) > ca->delay_min >> 1) {
+
+			threshold = ca->delay_min;
+			/* Hystart ack train triggers if we get ack past
+			 * ca->delay_min/2.
+			 * Pacing might have delayed packets up to RTT/2
+			 * during slow start.
+			 */
+			if ((sk->sk_pacing_status == SK_PACING_NONE) || (netdev_max_backlog & 1))
+				threshold >>= 1;
+
+			if ((s32)(now - ca->round_start) > threshold) {
 				ca->found = 1;
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
-- 
2.24.1.735.g03f4e72817-goog

