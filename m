Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28B3129AD9
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfLWU2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:28:15 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:35418 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfLWU2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:28:15 -0500
Received: by mail-pj1-f73.google.com with SMTP id l8so368314pje.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LNh12X0w6s4aHE614eShFhr0NDoDuT1UFBM/j1moBVw=;
        b=gTGwlxObfF9Ic2kwzRJJnuJye5Q6SyfuU1JndpLTbA1ys4tW69n7hBZzI9vLxmeKHM
         YQ/QCrKxrBfeOu2zB3bUBTbitm6IJUgyh7JjIOV52ieftJyCYXM5m7h0FEYm0VI01MwI
         OX/LoxUNc83MOOKd5QEfFuioZ3PrTu0F8A4sgk41xcMsbX2dsv/x1KcEoGQxeNSzMH/0
         aUzy0SH4iNHsMm+aNrnny68YByiq9IciWuOxlsT89lEUUambOiOUMlJ4I6KqhF4vyWLD
         qRx1qzabCT4Cs837zCsMam4hUrwtVT+fqrN+XSYZDrv+3+MyQDcLoqr5SMGPkAAKQfVA
         LOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LNh12X0w6s4aHE614eShFhr0NDoDuT1UFBM/j1moBVw=;
        b=lKgfZWmw5UF1xMyClwyemIZZi+n98oxvzA/jESoHfic6vR0Gc9Zve28tUwccu050oi
         Xpph/47JkLYtfYe9S2YNH/Yw0DnUdgZxvukgbQPn9HFEqdzdKivMzU0RBPlArN7ji1Qn
         Ae0AILTpLcsAyN4GDEfp52seb0tGX9PEHLd4BIF2UnviN1U5S4YFNIQK4esNtg3dT7qR
         mV+prrXyMb4FKxIuEkEb0I2sAowNEqfgTrfswa2A/q8ab3bVMqIiRvcUfuQ+ntbrVohY
         F5ioq+XzonMcZXON/uuQOhV1QwavOACDA/g1P2JRXPygL+tDaLvvMN8mZLGIuTmAYrFe
         RQmw==
X-Gm-Message-State: APjAAAUttls4DpnlZPO4N+I5LgH9OcBvvr55+ecxcej7zVi6uO8YLtjg
        JOiQnZQ/GvdhB+dxp7xTNuNS74h/ZIO0fA==
X-Google-Smtp-Source: APXvYqwPs3/EaRhkwFsABT4YSuKU0ihk37fbGakkRgsUX7jRtrvV53/f2UAr+DlMsSCkhk48XvwkhZxXsBuMpg==
X-Received: by 2002:a63:a707:: with SMTP id d7mr32403267pgf.93.1577132894739;
 Mon, 23 Dec 2019 12:28:14 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:27:54 -0800
In-Reply-To: <20191223202754.127546-1-edumazet@google.com>
Message-Id: <20191223202754.127546-6-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next v2 5/5] tcp_cubic: make Hystart aware of pacing
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
index 0e5428ed04fe4e50627e21a53c3d17f9f2dade4d..d02bb283c6890e1692e714e053515c6e4981d83a 100644
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
+			if (sk->sk_pacing_status == SK_PACING_NONE)
+				threshold >>= 1;
+
+			if ((s32)(now - ca->round_start) > threshold) {
 				ca->found = 1;
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
-- 
2.24.1.735.g03f4e72817-goog

