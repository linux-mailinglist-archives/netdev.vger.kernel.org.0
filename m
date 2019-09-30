Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE84C29E0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbfI3Wou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:44:50 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48521 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731582AbfI3Wot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:44:49 -0400
Received: by mail-pg1-f202.google.com with SMTP id w13so9896346pge.15
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 15:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rqyB6fZEhhRjCJkjGDQsjUI7S1q+KxvTxnCDfGppJOY=;
        b=QO4G7RH7/vrkJ/KPiiDqdyhe7jNqBpdHWR31plTfENuTdPfieihwjvTUEklRx0s6zc
         fsj0nVbmVHg1oYsM9v59fiEsyOdWLKpd7zNs4uET/zPuCxn76o7KVw85Djr9GIaGJg/T
         DAuehuD33Fp2nCirWqGEmusgqPYytgJ+4T4oQtGW8xb4RDc4YFgU25OqzUZPjRkgxINQ
         Qqx30G3B7PNf8H1FPIS9IUkCSFwxGLqgFP2D4RcEL2KTQ3DvabOhAv2WdLWLJyekDM1j
         La+YsqtoGRtUqejuEN2ItRZiAjD+kadTbY0H8DhAEgj7YTDbZpwsWZIfbwGqE8JtvgAD
         2OvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rqyB6fZEhhRjCJkjGDQsjUI7S1q+KxvTxnCDfGppJOY=;
        b=KQcUJpDCV98mrPT/g6xYG6sRb3D8ZAwFTsexJpdUjJ+jh2ZWym1tiv8M9DFSurYRCG
         m3x5dHk/jxubPqPUhMOhXqTH2yIFfSexOUx7yObtQyrb+1pgPZDBt7cTBELZ8AqEZVYh
         4rPO7xk5nqbSfVGPrxYJPdcTL2FhbWEhiASRULUyd+hKYp9MDyTqDrcf3IkyF1YPVJvt
         EdkEipxjMIrMWVoVvX67oVX++nDhugydm9hwz7KKvxspTN+XGvWT4AZWKxnpdZ/ExJYT
         8ncsWG+ZyesHDi7S7aXSxp6nUUERA+lqF9dFi19KUcbrMl4XFNws0cGtIj6P6abXum+1
         v6sQ==
X-Gm-Message-State: APjAAAWm1oSfRCn2Zj82GDYVRK4ViRXuAsjLGjA6esiP23NTbqQQwWd2
        dWEm7DCtmYDMm8CPoreQBIpA5aStZQ5rbg==
X-Google-Smtp-Source: APXvYqw/x9SB4MW3UAiZI5+S2bdeG/eUZ2GCVHxJ2Uwp0GGZ3jg+9FPv0M6qDLlyEvqBz1bWVuew8+G65VmKYg==
X-Received: by 2002:a63:fe42:: with SMTP id x2mr26485766pgj.80.1569883487424;
 Mon, 30 Sep 2019 15:44:47 -0700 (PDT)
Date:   Mon, 30 Sep 2019 15:44:44 -0700
Message-Id: <20190930224444.77901-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH net] tcp: adjust rto_base in retransmits_timed_out()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commit exposed an old retransmits_timed_out() bug
which assumed it could call tcp_model_timeout() with
TCP_RTO_MIN as rto_base for all states.

But flows in SYN_SENT or SYN_RECV state uses a different
RTO base (1 sec instead of 200 ms, unless BPF choses
another value)

This caused a reduction of SYN retransmits from 6 to 4 with
the default /proc/sys/net/ipv4/tcp_syn_retries value.

Fixes: a41e8a88b06e ("tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Marek Majkowski <marek@cloudflare.com>
---
 net/ipv4/tcp_timer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 40de2d2364a1eca14c259d77ebed361d17829eb9..05be564414e9b4aad64321e381fc0afa10980190 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -198,8 +198,13 @@ static bool retransmits_timed_out(struct sock *sk,
 		return false;
 
 	start_ts = tcp_sk(sk)->retrans_stamp;
-	if (likely(timeout == 0))
-		timeout = tcp_model_timeout(sk, boundary, TCP_RTO_MIN);
+	if (likely(timeout == 0)) {
+		unsigned int rto_base = TCP_RTO_MIN;
+
+		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+			rto_base = tcp_timeout_init(sk);
+		timeout = tcp_model_timeout(sk, boundary, rto_base);
+	}
 
 	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }
-- 
2.23.0.444.g18eeb5a265-goog

