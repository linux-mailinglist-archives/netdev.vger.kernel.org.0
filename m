Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB42E1E5248
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgE1AfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgE1AfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 20:35:03 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67189C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:35:02 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w14so1381460qkb.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=z3YU89e6pPfR07wydtS+K1VRcpUUqTZ+p3Je1UQ5NNo=;
        b=CicES7RrCg7wQUuKguePf1R8+QqduOuHkOuOzTpryZi6xXf8cj1J2aljgW0xqGkKYW
         7R0g4Z5LKvrp7Sxm7H4pkbXht9/6xXNd0hYLFeBsQoW+5ICfJWtfhex/2vI4ZLHHVp/O
         6UtCbKEnZafgmNiT8XOq2gMdMdWGl+urGhHZVZqtxYQpKXlAfgCsWzmJe6vWz2EyDQXE
         UfpKHcO/r2udgWJyI64mAAblXdcWub1KOZ5CQ3PIRPUG7VGCLtAujVTvTTtOSUqdcokX
         Ee15hZIRID63IvI6X8O9z9NHYR5kftg4cmsdMiQSKQf5TAsq+JLgO2VZ+m4XqP8G/kze
         guUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=z3YU89e6pPfR07wydtS+K1VRcpUUqTZ+p3Je1UQ5NNo=;
        b=qEJ7DVfuSw2MRCXPx8U7qABD5FfLq93Yd+p+8nhoxe9K4c1Ojns9905qeKlTbRJyOF
         uQZkN0GzMJ7ZdAKMwzHMN0MN54d8xv8K8tjrBwnI9TU63hVyuI/lO7n9ZkDaLe+uWKfT
         Ge7yFs+CElAIuxtbeADZjMDHSiPPwZsiR7XCU7z4yoEanP+YG/VO9qEKf6zcCqQKWsYQ
         e0V3bTf4isTLtY5vAn50yTM94GCzY503AfRipnsiQrMurm4fz/USKLFHsdlHvOhgBj1o
         kq4EALVdByt3dbRnZh+rEzQLPeahI54KYjJOUdacdY9xnOYtHGcCR16IoneSITSia7YG
         miIQ==
X-Gm-Message-State: AOAM533M0n6TsLihed6+hHlqpRZ9ZGbYenpCR6dZoV4eWwNA2fhQOJAn
        i+5ylRbjY3qzDEtxiscjMGWZGfIjJ51MFA==
X-Google-Smtp-Source: ABdhPJwL+GslKS/LRggkw2AFf3IFnwqrSuwOSlq84dtwWeZ5UOvvn4OPApjaOGhhZqwwwToO9rPE/cCsVdom8w==
X-Received: by 2002:a0c:b92f:: with SMTP id u47mr618848qvf.247.1590626101506;
 Wed, 27 May 2020 17:35:01 -0700 (PDT)
Date:   Wed, 27 May 2020 17:34:58 -0700
Message-Id: <20200528003458.90435-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net-next] tcp: ipv6: support RFC 6069 (TCP-LD)
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make tcp_ld_RTO_revert() helper available to IPv6, and
implement RFC 6069 :

Quoting this RFC :

3. Connectivity Disruption Indication

   For Internet Protocol version 6 (IPv6) [RFC2460], the counterpart of
   the ICMP destination unreachable message of code 0 (net unreachable)
   and of code 1 (host unreachable) is the ICMPv6 destination
   unreachable message of code 0 (no route to destination) [RFC4443].
   As with IPv4, a router should generate an ICMPv6 destination
   unreachable message of code 0 in response to a packet that cannot be
   delivered to its destination address because it lacks a matching
   entry in its routing table.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h   | 1 +
 net/ipv4/tcp_ipv4.c | 3 ++-
 net/ipv6/tcp_ipv6.c | 9 +++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index b681338a8320b55a32004b4d9d88c33ca28e8d29..66e4b8331850623515fade891a2e9feb79c49061 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -437,6 +437,7 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
 void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb);
 void tcp_v4_mtu_reduced(struct sock *sk);
 void tcp_req_err(struct sock *sk, u32 seq, bool abort);
+void tcp_ld_RTO_revert(struct sock *sk, u32 seq);
 int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
 struct sock *tcp_create_openreq_child(const struct sock *sk,
 				      struct request_sock *req,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3a1e2becb1e8d1e0513e87bdfc0e1d5769ffc8e8..615de2d62d8b9b005a9a31b679d253fd2e5c12a8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -404,7 +404,7 @@ void tcp_req_err(struct sock *sk, u32 seq, bool abort)
 EXPORT_SYMBOL(tcp_req_err);
 
 /* TCP-LD (RFC 6069) logic */
-static void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
+void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -441,6 +441,7 @@ static void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
 		tcp_retransmit_timer(sk);
 	}
 }
+EXPORT_SYMBOL(tcp_ld_RTO_revert);
 
 /*
  * This routine is called by the ICMP module when it gets some
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c403e955fde1288fe781a3f5664de768642b0a7e..00f81817b378911aad3c905160218e964657e730 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -473,6 +473,15 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		} else
 			sk->sk_err_soft = err;
 		goto out;
+	case TCP_LISTEN:
+		break;
+	default:
+		/* check if this ICMP message allows revert of backoff.
+		 * (see RFC 6069)
+		 */
+		if (!fastopen && type == ICMPV6_DEST_UNREACH &&
+		    code == ICMPV6_NOROUTE)
+			tcp_ld_RTO_revert(sk, seq);
 	}
 
 	if (!sock_owned_by_user(sk) && np->recverr) {
-- 
2.27.0.rc0.183.gde8f92d652-goog

