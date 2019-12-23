Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888E0129AD5
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLWU2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:28:03 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:39849 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfLWU2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:28:02 -0500
Received: by mail-pj1-f73.google.com with SMTP id c67so354579pje.4
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O0R5t5+mYqqA+LiZlBp+TuloAZtUA00OrQwRBPW8En0=;
        b=AYyxY/iqm969Dj7r2VKTUnEKx6LNjbMok1NSPQp+4qJWZay9heq5YPVj6Rwbi2BkWH
         fFHLj+iwhAK2D010oJJHy9XbthAJsbC59CbR+JKaD9f/FGhulUBcVM9oc+3MK4xqahuR
         zhY0H9/T1eRAUIy4gdNzP8SckWX7Dw2eQ+0EmzQTNClXhuNI3u1hNauLyObqF+724CM4
         v1dO6cMQLKZM8Vz7WjZDCb55qfdAuHeL/faAnccmy+4dlV7H96p7H9Qw2wmdB0e4TA4Y
         GGMIpK1RSb8Z+7APGfjxUthOBW6l9IfThuXjnvIyF9SIlPPHN9AQgb4CdOD4Da8Anvml
         NVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O0R5t5+mYqqA+LiZlBp+TuloAZtUA00OrQwRBPW8En0=;
        b=bTYXefRjZBbTW1I6DXVgRVKZHxGgYMwTkevCWQ5AX6HhjRhjhLCUyhVC76VgKTYG9N
         9X59Wk1bSkQ7MBGso5L0plUWDNqRxS0n7jjXxDoH8JD/FS4kWtytptxtd2RTZJiw6Jbk
         Zgj5ziJOpEacX1OTBWfaHrIWfFeXsrrs/j0YwmV+aU9K6bDSIn8riXf7e7b8Ul7ZE40T
         r0o2+DyPJgC4imXoLs0Q5wWeZBXzH3nbX5JZGxfmrg6LPGsNXygOMMahFcbFzJkz8+4x
         p6P8slCvn27W9xn/t/a3cSPrz1nF0Dyr7o4uYIKBiOXfO9ToxeHoSPLuqC+DNRl2q4CS
         9C0A==
X-Gm-Message-State: APjAAAXUAhex7RL/Qt13G4DkkYvulFAW39nEtfBSY/ADxfBStiyE7kjy
        623XjIVKTcaM/ukyC5YWDs7dDbV5nP7aWQ==
X-Google-Smtp-Source: APXvYqwLq5bN41YXHeGjfxfaJdDqtfGxxj0bg+qvcAXE9mgIVoeUhB7Zw4rJr4Tplla1d9WvU+pwhp4vWj6wbA==
X-Received: by 2002:a63:12:: with SMTP id 18mr33189363pga.294.1577132881125;
 Mon, 23 Dec 2019 12:28:01 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:27:50 -0800
In-Reply-To: <20191223202754.127546-1-edumazet@google.com>
Message-Id: <20191223202754.127546-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next v2 1/5] tcp_cubic: optimize hystart_update()
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

We do not care which bit in ca->found is set.

We avoid accessing hystart and hystart_detect unless really needed,
possibly avoiding one cache line miss.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 1b3d032a4df2a23faf8f12a9b426638fb1997fef..297936033c335ee57ba6205de50c5ef06b90da60 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -381,9 +381,6 @@ static void hystart_update(struct sock *sk, u32 delay)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct bictcp *ca = inet_csk_ca(sk);
 
-	if (ca->found & hystart_detect)
-		return;
-
 	if (hystart_detect & HYSTART_ACK_TRAIN) {
 		u32 now = bictcp_clock();
 
@@ -391,7 +388,7 @@ static void hystart_update(struct sock *sk, u32 delay)
 		if ((s32)(now - ca->last_ack) <= hystart_ack_delta) {
 			ca->last_ack = now;
 			if ((s32)(now - ca->round_start) > ca->delay_min >> 4) {
-				ca->found |= HYSTART_ACK_TRAIN;
+				ca->found = 1;
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
 				NET_ADD_STATS(sock_net(sk),
@@ -412,7 +409,7 @@ static void hystart_update(struct sock *sk, u32 delay)
 		} else {
 			if (ca->curr_rtt > ca->delay_min +
 			    HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
-				ca->found |= HYSTART_DELAY;
+				ca->found = 1;
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTDELAYDETECT);
 				NET_ADD_STATS(sock_net(sk),
@@ -450,7 +447,7 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
 		ca->delay_min = delay;
 
 	/* hystart triggers when cwnd is larger than some threshold */
-	if (hystart && tcp_in_slow_start(tp) &&
+	if (!ca->found && hystart && tcp_in_slow_start(tp) &&
 	    tp->snd_cwnd >= hystart_low_window)
 		hystart_update(sk, delay);
 }
-- 
2.24.1.735.g03f4e72817-goog

