Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7DC5D401
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGBQOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:10 -0400
Received: from mail-oi1-f201.google.com ([209.85.167.201]:53616 "EHLO
        mail-oi1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBQOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:09 -0400
Received: by mail-oi1-f201.google.com with SMTP id t198so6753792oih.20
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oiKeZPtLlGyJB1GPoonj593FsBpNBqsPanwSJD5Ith4=;
        b=IoJFzFtsAaXavtRUBZtuaky0zNoWcvJn8k7+ELGAkvep1Wf1U9mgxLqJosq9P5TKaP
         h0jZO+nsXcv0Wc3zmR/35FQfmqVnVR0sYcv4MpPN4BaYrjurRI1el6AbPbE8S/jm8xh4
         mMGZKCzmWYtzWS8w4A8Sn4hc+o9Yrl9qY5dk8bo27o/UiUoNuIB8ii/8e3aCRqw1Hiyf
         NRteaqd9ECrzJ5JzS7xOfYoIckm2hNxw1AUMMbAhFTqN0Ulq+zNy89qqG43LZyp2uoqq
         DYUYuRu9uKKQwhT++1kV/SU16+9NOsBY+pFAT5WXmfPMROs/0kHS5aFTq4uQs/bu4sT4
         uSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oiKeZPtLlGyJB1GPoonj593FsBpNBqsPanwSJD5Ith4=;
        b=NvmoT6+Um7XKJCIZ7hVgtT9BG7b+ncucma2u9zKVBcC2J571coFkVK+e/Nvp/T7sRd
         eJ2H33YUadfzyI6B6k80WyWmtakSr8vQsb6hJR48uKZr1+PdJ8oFG2nTHfbfYJ4HNDFQ
         HpyPv07M7leGnUKl5WayyrYBczsUvL9JwchwLHIYa/qJfocHY8M8U/j+PjYVWa2GHKag
         WDhlWXVQ7eBwsUHvlkTvdvvNIUnrgrL9NDvJbLQP8RWfuXmfIDbOrE9RqHhN2noMl7lr
         AqniUO25liz/bMoRACFjvRn0aof8IpjR4bW3vwkv+hAtzwfLAYFZ2VwaUdeQW0yfUn5k
         G9kg==
X-Gm-Message-State: APjAAAXn+Ba4qO9vIrhDX8OxBnCv/Z6Qci1c9yC5FykUH9TatbuvxZ8A
        Q7HEltKdfn4E5MXf94S7yHAQV23LK+YkarMKEmH1kuapCbFGZy2knUG4hxC2eM6gVKMa4ra8EEc
        RF8adsJeGgPnt0DE7sBLv8qzJiLPHQbojJGbit0srbB9fracwPu28tQ==
X-Google-Smtp-Source: APXvYqw+XQJ/H04N+W5mul3ZJg4E+4TCN/0YyW2S/5nUAis4s5O1JErHNgq0IGE/AEluYMv/ggSZtiw=
X-Received: by 2002:a9d:a76:: with SMTP id 109mr23162676otg.252.1562084048584;
 Tue, 02 Jul 2019 09:14:08 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:13:56 -0700
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Message-Id: <20190702161403.191066-2-sdf@google.com>
Mime-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 1/8] bpf: add BPF_CGROUP_SOCK_OPS callback that is
 executed on every RTT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Performance impact should be minimal because it's under a new
BPF_SOCK_OPS_RTT_CB_FLAG flag that has to be explicitly enabled.

Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/tcp.h        | 8 ++++++++
 include/uapi/linux/bpf.h | 6 +++++-
 net/ipv4/tcp_input.c     | 4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9d36cc88d043..e16d8a3fd3b4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2221,6 +2221,14 @@ static inline bool tcp_bpf_ca_needs_ecn(struct sock *sk)
 	return (tcp_call_bpf(sk, BPF_SOCK_OPS_NEEDS_ECN, 0, NULL) == 1);
 }
 
+static inline void tcp_bpf_rtt(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTT_CB_FLAG))
+		tcp_call_bpf(sk, BPF_SOCK_OPS_RTT_CB, 0, NULL);
+}
+
 #if IS_ENABLED(CONFIG_SMC)
 extern struct static_key_false tcp_have_smc;
 #endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index cffea1826a1f..9cdd0aaeba06 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1770,6 +1770,7 @@ union bpf_attr {
  * 		* **BPF_SOCK_OPS_RTO_CB_FLAG** (retransmission time out)
  * 		* **BPF_SOCK_OPS_RETRANS_CB_FLAG** (retransmission)
  * 		* **BPF_SOCK_OPS_STATE_CB_FLAG** (TCP state change)
+ * 		* **BPF_SOCK_OPS_RTT_CB_FLAG** (every RTT)
  *
  * 		Therefore, this function can be used to clear a callback flag by
  * 		setting the appropriate bit to zero. e.g. to disable the RTO
@@ -3314,7 +3315,8 @@ struct bpf_sock_ops {
 #define BPF_SOCK_OPS_RTO_CB_FLAG	(1<<0)
 #define BPF_SOCK_OPS_RETRANS_CB_FLAG	(1<<1)
 #define BPF_SOCK_OPS_STATE_CB_FLAG	(1<<2)
-#define BPF_SOCK_OPS_ALL_CB_FLAGS       0x7		/* Mask of all currently
+#define BPF_SOCK_OPS_RTT_CB_FLAG	(1<<3)
+#define BPF_SOCK_OPS_ALL_CB_FLAGS       0xF		/* Mask of all currently
 							 * supported cb flags
 							 */
 
@@ -3369,6 +3371,8 @@ enum {
 	BPF_SOCK_OPS_TCP_LISTEN_CB,	/* Called on listen(2), right after
 					 * socket transition to LISTEN state.
 					 */
+	BPF_SOCK_OPS_RTT_CB,		/* Called on every RTT.
+					 */
 };
 
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detect
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b71efeb0ae5b..c21e8a22fb3b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -778,6 +778,8 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
 				tp->rttvar_us -= (tp->rttvar_us - tp->mdev_max_us) >> 2;
 			tp->rtt_seq = tp->snd_nxt;
 			tp->mdev_max_us = tcp_rto_min_us(sk);
+
+			tcp_bpf_rtt(sk);
 		}
 	} else {
 		/* no previous measure. */
@@ -786,6 +788,8 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
 		tp->rttvar_us = max(tp->mdev_us, tcp_rto_min_us(sk));
 		tp->mdev_max_us = tp->rttvar_us;
 		tp->rtt_seq = tp->snd_nxt;
+
+		tcp_bpf_rtt(sk);
 	}
 	tp->srtt_us = max(1U, srtt);
 }
-- 
2.22.0.410.gd8fdbe21b5-goog

