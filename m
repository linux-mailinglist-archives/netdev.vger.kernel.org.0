Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0E129AC9
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfLWUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:20:14 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:35310 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:20:13 -0500
Received: by mail-pj1-f73.google.com with SMTP id l8so358628pje.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O0R5t5+mYqqA+LiZlBp+TuloAZtUA00OrQwRBPW8En0=;
        b=uxR5QJpq5lamtiqHhtZBxPjCDRC6TiCW1163rqe0Lvej5jTtocDr4xFZmB/9LUPNK8
         4XOayMGVvMhGLUYFyYvv9YJaLFb0NTGntDoMmDDTF7cZm7h+kcSdJnmtstAwHKt4itPu
         HYcxQrR+ERThdy52C/sgorL+j5q3VobyR4/TRMczHz8+C6tafmKDoR8uEDh2c3bOpuyk
         w7VRu1wc1iCRJGpqrUbVK0o+VzjdBpuKw5IEJE5KN934IAvAw8dXNFEA6eewysbm6bOR
         dt//OrNl+JvpJxMajiKhKR/Rl4ScTPMeTiLeMDq5K7ZDMUNO1Qk5nLs6Y1nHgtGDwuFN
         hY0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O0R5t5+mYqqA+LiZlBp+TuloAZtUA00OrQwRBPW8En0=;
        b=PEgvSdregJ3SptmFPRrIzlzrI2AwF8OlhoZlx6n5bqDucgs4xQHbkXZU+21TtahMAO
         ibsmQ2IpdwCSaATh5MpPi/+bLWhq0fosP+irfyOmj5JGbpuHXsGH6Hgci0Zvmg7U8dP4
         f8mTAduDDd4U5zZVy0gQYoavir32RE9kFENrfcE63yTiE9TBKfz0jgzdicUtsjSJ7xc4
         JPex388CeedBRGXVJ3RulVHAchZ2jWWnaKOimmhI9rk4OOM8JPtFlWaRkBbiY40fBePy
         vuyDeR3oOrPBpu5+PmQfMuez0nViu9p0KX4/SRPI5Fr90s0bSaXrMf/tmi2buFuHtIh9
         HZfw==
X-Gm-Message-State: APjAAAVcgCFxgNAQ/4jP+1bkyZuPq4CW9tzInga3fZxycYHz9KQo0lOW
        VbJaaO4Z228rTI/4HST8JDNu1O+DfhMgtQ==
X-Google-Smtp-Source: APXvYqwztpSIMKUuGkiVHpkzTSogPUesvtikiE08zH3TuOlTQWFUlu8a1qkgcl//j/34aUw2Vt4RxMtyqkOlXw==
X-Received: by 2002:a63:e0c:: with SMTP id d12mr31989163pgl.3.1577132412574;
 Mon, 23 Dec 2019 12:20:12 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:20:01 -0800
In-Reply-To: <20191223202005.104713-1-edumazet@google.com>
Message-Id: <20191223202005.104713-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202005.104713-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next 1/5] tcp_cubic: optimize hystart_update()
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

