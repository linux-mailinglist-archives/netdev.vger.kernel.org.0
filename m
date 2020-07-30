Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD913233B7E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 00:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgG3Woq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 18:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgG3Woo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 18:44:44 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DB6C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 15:44:44 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z5so3262021qtc.2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 15:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WLRlg46Uf7t/j471URcFCwN2o0SmhuDm3yZWPTyM8iw=;
        b=b9DVYTaClrLu2Na8j2A7mXYl+nU95TivkenKQUf3rLLaa+TcElycx2gGa8VbpCn9ca
         eAltzmYmu9dqVBDz6/6XUyfNBGgZdapXrGMaWMjHujie1+8LdJzIePOItbMEY/dAtcG1
         IKUVMW9EnlJSwwGm5oQCyleSV5PY/ETjnrsQSuqZnGif3bLwmiZsXVpGeb0G1mGchB+u
         wYLdkRcK/2hRHnlgaF7kL6qcRYltrpKei+EGV8Z49ixJ/8ONQam+GPe+v2HMWL2rL2Y7
         zVYI1AVeoG/JWGCtaIWoYlzS/6cmLKI85NZVkbfMRyBGJjiKMUMv6Hyo/F/yP0AnwwDG
         JPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WLRlg46Uf7t/j471URcFCwN2o0SmhuDm3yZWPTyM8iw=;
        b=p/x05pdVDxPp4cysP1oPynfNZpMJzMwAuxmjgLxzMuxO0bI+ZLoIAx0/hpg4rzcA5O
         8QXI3oufCgnRbagN9wXyeByB79lGMwhUL74I1o59ewAFU7WQxQSqmIWigWUo6KFGin4Y
         fmYU81Vi1UE38Wo6SbK6n7XNAloApmxSbF9s6rhkLPve3REF/B8vlEnmeni+QMqI8yxc
         Uro6wW2MUIpzXSvmORJh0VMeIRy97mZ4zxq1mp68gyt2OiBmhij3wkLwZIbMskVtPrQz
         r0SvzlFw8KNht8POPeYHMVYqu6nj71C6zFYZ4oNSPQi8ft7jh1gPwRyiO9UgTKbKTPtT
         aLlg==
X-Gm-Message-State: AOAM533vKjhwThQhbAXrVDtnJzSzFyuhMFRdkzZ9tW3dUt9Vv+V74Yto
        OZfGEafVlStRLaaficMIE1GFYevsgDYq
X-Google-Smtp-Source: ABdhPJxYanU7LFrzp/iCxsR+P7bGtHvisCVqXIDrBwVYoLDd7O5j8xsxTBSDjgzagvn88Kd/WWhkdUyvgrQa
X-Received: by 2002:a0c:ea21:: with SMTP id t1mr1424524qvp.62.1596149083577;
 Thu, 30 Jul 2020 15:44:43 -0700 (PDT)
Date:   Thu, 30 Jul 2020 15:44:40 -0700
Message-Id: <20200730224440.2930115-1-ysseung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH net-next] tcp: add earliest departure time to SCM_TIMESTAMPING_OPT_STATS
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds TCP_NLA_EDT to SCM_TIMESTAMPING_OPT_STATS that reports
the earliest departure time(EDT) of the timestamped skb. By tracking EDT
values of the skb from different timestamps, we can observe when and how
much the value changed. This allows to measure the precise delay
injected on the sender host e.g. by a bpf-base throttler.

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
---
 include/linux/tcp.h      | 3 ++-
 include/uapi/linux/tcp.h | 1 +
 net/core/skbuff.c        | 2 +-
 net/ipv4/tcp.c           | 6 +++++-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 527d668a5275..14b62d7df942 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -484,7 +484,8 @@ static inline void tcp_saved_syn_free(struct tcp_sock *tp)
 	tp->saved_syn = NULL;
 }
 
-struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk);
+struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
+					       const struct sk_buff *orig_skb);
 
 static inline u16 tcp_mss_clamp(const struct tcp_sock *tp, u16 mss)
 {
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index f2acb2566333..cfcb10b75483 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -313,6 +313,7 @@ enum {
 	TCP_NLA_SRTT,		/* smoothed RTT in usecs */
 	TCP_NLA_TIMEOUT_REHASH, /* Timeout-triggered rehash attempts */
 	TCP_NLA_BYTES_NOTSENT,	/* Bytes in write queue not yet sent */
+	TCP_NLA_EDT,		/* Earliest departure time (CLOCK_MONOTONIC) */
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b8afefe6f6b6..4e2edfbe0e19 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4692,7 +4692,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
 		    sk->sk_protocol == IPPROTO_TCP &&
 		    sk->sk_type == SOCK_STREAM) {
-			skb = tcp_get_timestamping_opt_stats(sk);
+			skb = tcp_get_timestamping_opt_stats(sk, orig_skb);
 			opt_stats = true;
 		} else
 #endif
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4afec552f211..c06d2bfd2ec4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3501,10 +3501,12 @@ static size_t tcp_opt_stats_get_size(void)
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_SRTT */
 		nla_total_size(sizeof(u16)) + /* TCP_NLA_TIMEOUT_REHASH */
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_BYTES_NOTSENT */
+		nla_total_size_64bit(sizeof(u64)) + /* TCP_NLA_EDT */
 		0;
 }
 
-struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk)
+struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
+					       const struct sk_buff *orig_skb)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *stats;
@@ -3558,6 +3560,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk)
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
 		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
+	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
+			  TCP_NLA_PAD);
 
 	return stats;
 }
-- 
2.28.0.163.g6104cc2f0b6-goog

