Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D005BFB62
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 00:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfIZWmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 18:42:55 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:41575 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfIZWmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 18:42:55 -0400
Received: by mail-pl1-f201.google.com with SMTP id b23so424923pls.8
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 15:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TsaviIDrHTxUAn8Z2DV/c6ydppwjLAK7iiY+WvZWu7s=;
        b=U45D1HDHuoO/3313mI/lL6e4UOiSmhf6fvw+IUkAC62QpCxGA5763AhvScYgGB/VQO
         P4e/Ed8IEVNdbxPzBthHnlKDUUyvptJaaP8sDdq04mrOKqMJyMe1d/Nki8IQfM/asQzD
         fc45G8vKAAU11Gnf+YslQaMzfB8DQHkFG6MkSfbiy2T6//mlX6+HRjOimd11aaBLOk5b
         HZ7mlvmhftXrBEk6UTWKjnnV7XaFOetSViIe6xn0PCfcAcoCl0r7wP57ubDmU9Pvbxgf
         uZdIX4rYS10HLIqfJKjnpasQDf5RHIkrF4QyyifqTicGyMEhkjnHwzzCod+Sh0d2+ewG
         /ajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TsaviIDrHTxUAn8Z2DV/c6ydppwjLAK7iiY+WvZWu7s=;
        b=X2m+oJ2zSrrBvTvE3gHVtaDAbAJDtam7wg2YR/ChOIFx284iTmGd2bsUIhlBHN+qOE
         HGnfWgvmR3w9D2NSzOdUdesXd7elXzUo6y1U40sH7Uq4o5220KYvm8YlYI1pn07W89DT
         V7r/OM1fjWqLklScZb4Gi7Ttm6obaWey/4ZrpHVIL90TuYn2rlxCS7dUqj42anxZOspP
         ipI/PmvxtTbBG3aBojybre9NBMUSRk0ZXHjXzBrlBl7VLvBUNcltT2njGqjJJCnCVtWV
         DZJ7+Dbc1aT2GtdHCN4dK5D1ASDnY7i0a+YUMN8KreElB5DnjJFC9Z7GqXUHPcDp7Z3J
         ve6A==
X-Gm-Message-State: APjAAAUA/bB4nHfS4n9oi/v7E1iUhNC9yfPQztM+iWQVUawndj99LECp
        U4j9DQzqZbWwZzE9VAXjCLUN1O6goWhUTA==
X-Google-Smtp-Source: APXvYqyCrT9abAZkBaSp/UOgYIKGSVCvLd3Vf0Q/D2U3DCaNAblm8WI8ue8eE7E7a/MIo2WBmgotK6OClWNRgg==
X-Received: by 2002:a63:ff18:: with SMTP id k24mr5995648pgi.427.1569537774428;
 Thu, 26 Sep 2019 15:42:54 -0700 (PDT)
Date:   Thu, 26 Sep 2019 15:42:51 -0700
Message-Id: <20190926224251.249797-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH net] tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Jon Maxwell <jmaxwell37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yuchung Cheng and Marek Majkowski independently reported a weird
behavior of TCP_USER_TIMEOUT option when used at connect() time.

When the TCP_USER_TIMEOUT is reached, tcp_write_timeout()
believes the flow should live, and the following condition
in tcp_clamp_rto_to_user_timeout() programs one jiffie timers :

    remaining = icsk->icsk_user_timeout - elapsed;
    if (remaining <= 0)
        return 1; /* user timeout has passed; fire ASAP */

This silly situation ends when the max syn rtx count is reached.

This patch makes sure we honor both TCP_SYNCNT and TCP_USER_TIMEOUT,
avoiding these spurious SYN packets.

Fixes: b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout() helper to improve accuracy")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Yuchung Cheng <ycheng@google.com>
Reported-by: Marek Majkowski <marek@cloudflare.com>
Cc: Jon Maxwell <jmaxwell37@gmail.com>
Link: https://marc.info/?l=linux-netdev&m=156940118307949&w=2
---
 net/ipv4/tcp_timer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index dbd9d2d0ee63aa46ad2dda417da6ec9409442b77..40de2d2364a1eca14c259d77ebed361d17829eb9 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -210,7 +210,7 @@ static int tcp_write_timeout(struct sock *sk)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
-	bool expired, do_reset;
+	bool expired = false, do_reset;
 	int retry_until;
 
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
@@ -242,9 +242,10 @@ static int tcp_write_timeout(struct sock *sk)
 			if (tcp_out_of_resources(sk, do_reset))
 				return 1;
 		}
+	}
+	if (!expired)
 		expired = retransmits_timed_out(sk, retry_until,
 						icsk->icsk_user_timeout);
-	}
 	tcp_fastopen_active_detect_blackhole(sk, expired);
 
 	if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTO_CB_FLAG))
-- 
2.23.0.444.g18eeb5a265-goog

