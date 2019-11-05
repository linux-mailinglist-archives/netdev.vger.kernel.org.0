Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23135F091D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbfKEWML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:12:11 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:36507 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387420AbfKEWML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:12:11 -0500
Received: by mail-ua1-f73.google.com with SMTP id r39so3809601uad.3
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YXST7hsRVZiDazVQTk6ijZIwRK9FaWUze+2G5yzqFGY=;
        b=CX7rI35gCFMCcRlIt7cl6pL+n2SC/c0Ahn4Laj1/imJxbzoB1VvE3tz64YylQRYYda
         WaOPSYjirvb6d6fTnOaxbnK9uVqGGQcGpV3C+l8DUJ9Ll4vJCwj8uMugjqy8CWB7luSM
         NWAiYlBqGAVP45krHNo2HhyTaEqZW5bxdfU2/pOxiwIOCxGdl/BzSKJsn1sGA9Ytv9WF
         qrFCbYCU5tXjBqwscbyGJXVn7FQkRm2/wP2z1YMAahzI4GQqSTLougAzLv5FsbiNhxWa
         YVxJWhXXe5+OLPhUet2WrHxo8dCks5L/5Ghor0vyFZEocUnbEZC5Pw5FQhNbEWnxMwzR
         p9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YXST7hsRVZiDazVQTk6ijZIwRK9FaWUze+2G5yzqFGY=;
        b=rSpgBiRh0HzbYqU4nuCrGik7NsNm5wlVxXOfsb8r0q2+uLQQBt6IQlA7o/hRIEyv1V
         YuPuXMcuT4YaHm9fi6tF22ljaMx+CFGbYJadyy+s5HFtuJzC4iS2seg8SEAAu+rsHEE5
         2cVlB50ssTKgbZJEgTK6zf5SfLG1JspPD5PckTlWW2pVD1a7rSrlS0ab1tq2I9vmCLdG
         jKR2OPLswLC+lr+OHxh4COxBnyg1q/0IIW4dRx5SmHqtxpWhgmfCpzd9O46AxpIflNDZ
         8rSo6I3EY6lDjI0OSAuxs7WAVOB468YbnpU3emLiCX53j5igzwrf57ZicPi81FwR4aal
         2hbw==
X-Gm-Message-State: APjAAAXX8CR2r2bEAydt//pRPHSXNn8Fa37Vy64Adj5lsjezj5/VfNG4
        ublp8ozaz672WM2dLHLubnLm32UJZ8LfDA==
X-Google-Smtp-Source: APXvYqyjCBecbsXFKvfI0tbJtkFsdMJHZNHvh5eqLelmg2/ARRA0S++DNKE4viZ/yRoMLZQX3E6JWL4IKD5f0w==
X-Received: by 2002:a9f:23ea:: with SMTP id 97mr14803922uao.141.1572991929866;
 Tue, 05 Nov 2019 14:12:09 -0800 (PST)
Date:   Tue,  5 Nov 2019 14:11:50 -0800
In-Reply-To: <20191105221154.232754-1-edumazet@google.com>
Message-Id: <20191105221154.232754-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191105221154.232754-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 2/6] inet_diag: use jiffies_delta_to_msecs()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use jiffies_delta_to_msecs() to avoid reporting 'infinite'
timeouts and to cleanup code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/inet_diag.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 7dc79b973e6edcc64e668e14c71c732ca1187e8f..af154977904c0c249e77e425990a09c62cca4251 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -226,17 +226,17 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		r->idiag_timer = 1;
 		r->idiag_retrans = icsk->icsk_retransmits;
 		r->idiag_expires =
-			jiffies_to_msecs(icsk->icsk_timeout - jiffies);
+			jiffies_delta_to_msecs(icsk->icsk_timeout - jiffies);
 	} else if (icsk->icsk_pending == ICSK_TIME_PROBE0) {
 		r->idiag_timer = 4;
 		r->idiag_retrans = icsk->icsk_probes_out;
 		r->idiag_expires =
-			jiffies_to_msecs(icsk->icsk_timeout - jiffies);
+			jiffies_delta_to_msecs(icsk->icsk_timeout - jiffies);
 	} else if (timer_pending(&sk->sk_timer)) {
 		r->idiag_timer = 2;
 		r->idiag_retrans = icsk->icsk_probes_out;
 		r->idiag_expires =
-			jiffies_to_msecs(sk->sk_timer.expires - jiffies);
+			jiffies_delta_to_msecs(sk->sk_timer.expires - jiffies);
 	} else {
 		r->idiag_timer = 0;
 		r->idiag_expires = 0;
@@ -342,16 +342,13 @@ static int inet_twsk_diag_fill(struct sock *sk,
 	r = nlmsg_data(nlh);
 	BUG_ON(tw->tw_state != TCP_TIME_WAIT);
 
-	tmo = tw->tw_timer.expires - jiffies;
-	if (tmo < 0)
-		tmo = 0;
-
 	inet_diag_msg_common_fill(r, sk);
 	r->idiag_retrans      = 0;
 
 	r->idiag_state	      = tw->tw_substate;
 	r->idiag_timer	      = 3;
-	r->idiag_expires      = jiffies_to_msecs(tmo);
+	tmo = tw->tw_timer.expires - jiffies;
+	r->idiag_expires      = jiffies_delta_to_msecs(tmo);
 	r->idiag_rqueue	      = 0;
 	r->idiag_wqueue	      = 0;
 	r->idiag_uid	      = 0;
@@ -385,7 +382,7 @@ static int inet_req_diag_fill(struct sock *sk, struct sk_buff *skb,
 		     offsetof(struct sock, sk_cookie));
 
 	tmo = inet_reqsk(sk)->rsk_timer.expires - jiffies;
-	r->idiag_expires = (tmo >= 0) ? jiffies_to_msecs(tmo) : 0;
+	r->idiag_expires = jiffies_delta_to_msecs(tmo);
 	r->idiag_rqueue	= 0;
 	r->idiag_wqueue	= 0;
 	r->idiag_uid	= 0;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

