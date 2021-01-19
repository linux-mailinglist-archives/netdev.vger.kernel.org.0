Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B413A2FC011
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbhASTdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbhAST1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 14:27:08 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1726C061574
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 11:26:27 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id g7so632949pji.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 11:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=8wDlSUTCxAoSuX/Z9xGIGr42GDc+U/TtdpLKVwW1zYM=;
        b=q7YoBJ0SVhdUDdKAeUchXQ5VsvaRr4Ik0/sbtRkBHXr+h+LzLs4lo35NAqaxFnuk2K
         PQMyNM/YCHQCFCVlEj6X8Fz17pwXa/aku+h/m0877ae6QDZ7mV6465yMo9oZWvYptuDc
         D0xjfJm0/IU6tSLpbBZeuT2R10HoT9/170k/RoXDodFW52ddzIz5iWImW21pD0XboJIY
         UVVdnORi7RRF260RIkL6AQTUCZCayCdPQ99FetMznk91i+DpiK4WDPvh3VOEJ2E39o0o
         Z52cLPkm8Zb614gk9CRQurzyyaA7xCxaA6fRTwuAwog1XuziYvID54Xil26XS0APM8im
         RB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=8wDlSUTCxAoSuX/Z9xGIGr42GDc+U/TtdpLKVwW1zYM=;
        b=BJjxj0n3dmjY/ChL7vu1UNtggAcX2ItdRkbzErK9t3OItmfHNhAnC+qiJofsdrtQ4q
         +fEP2TVBs0Ib0Pp28vedujvQk07EAeVc6HKapgj2O4m3oVKsDBjk5tCBQI/wBvqsz597
         e+sL3uPpGrI5BDpobtlWnb8kas8yF45MW5PpwYgrG8SyQsDzySHo1i1xjNMukPwL3Gz6
         ZWMhDf6LSnJJy7NmZjrqdNX+3xt/USphmnThqcg4QtaTx4GKkIWrQVCYtBoLPDfBpWGh
         IDXgOjilTHGPdWgfb2OXJgF82UNpnrx+ZuH/OEPXr+af2TGmbMBVLZcxu0L643YuMfPe
         Wtpg==
X-Gm-Message-State: AOAM530aHGKd8D7ws1McQRL0JtEQzbzUL8RlQTAROnLmzSmROA0fjqFn
        Qxzabe5n6mPGXVoKPtrxjTeEdpSVzTA=
X-Google-Smtp-Source: ABdhPJwpYIP8bNmkd+xz1Rk/Atx2G8sdieIQ3m6vCCp8Olzf3zadPA3OenTkYXKXNp/7xEpnccQ+D4drfyc=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a17:90a:ea02:: with SMTP id
 w2mr1317583pjy.228.1611084387326; Tue, 19 Jan 2021 11:26:27 -0800 (PST)
Date:   Tue, 19 Jan 2021 11:26:19 -0800
Message-Id: <20210119192619.1848270-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH net] tcp: fix TCP socket rehash stats mis-accounting
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit 32efcc06d2a1 ("tcp: export count for rehash attempts")
would mis-account rehashing SNMP and socket stats:

  a. During handshake of an active open, only counts the first
     SYN timeout

  b. After handshake of passive and active open, stop updating
     after (roughly) TCP_RETRIES1 recurring RTOs

  c. After the socket aborts, over count timeout_rehash by 1

This patch fixes this by checking the rehash result from sk_rethink_txhash.

Fixes: 32efcc06d2a1 ("tcp: export count for rehash attempts")
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
---
 include/net/sock.h   | 17 ++++++++++++-----
 net/ipv4/tcp_input.c |  5 ++---
 net/ipv4/tcp_timer.c | 22 ++++++++--------------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index bdc4323ce53c..129d200bccb4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1921,10 +1921,13 @@ static inline void sk_set_txhash(struct sock *sk)
 	sk->sk_txhash = net_tx_rndhash();
 }
 
-static inline void sk_rethink_txhash(struct sock *sk)
+static inline bool sk_rethink_txhash(struct sock *sk)
 {
-	if (sk->sk_txhash)
+	if (sk->sk_txhash) {
 		sk_set_txhash(sk);
+		return true;
+	}
+	return false;
 }
 
 static inline struct dst_entry *
@@ -1947,12 +1950,10 @@ sk_dst_get(struct sock *sk)
 	return dst;
 }
 
-static inline void dst_negative_advice(struct sock *sk)
+static inline void __dst_negative_advice(struct sock *sk)
 {
 	struct dst_entry *ndst, *dst = __sk_dst_get(sk);
 
-	sk_rethink_txhash(sk);
-
 	if (dst && dst->ops->negative_advice) {
 		ndst = dst->ops->negative_advice(dst);
 
@@ -1964,6 +1965,12 @@ static inline void dst_negative_advice(struct sock *sk)
 	}
 }
 
+static inline void dst_negative_advice(struct sock *sk)
+{
+	sk_rethink_txhash(sk);
+	__dst_negative_advice(sk);
+}
+
 static inline void
 __sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bafcab75f425..a7dfca0a38cd 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4397,10 +4397,9 @@ static void tcp_rcv_spurious_retrans(struct sock *sk, const struct sk_buff *skb)
 	 * The receiver remembers and reflects via DSACKs. Leverage the
 	 * DSACK state and change the txhash to re-route speculatively.
 	 */
-	if (TCP_SKB_CB(skb)->seq == tcp_sk(sk)->duplicate_sack[0].start_seq) {
-		sk_rethink_txhash(sk);
+	if (TCP_SKB_CB(skb)->seq == tcp_sk(sk)->duplicate_sack[0].start_seq &&
+	    sk_rethink_txhash(sk))
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPDUPLICATEDATAREHASH);
-	}
 }
 
 static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 454732ecc8f3..faa92948441b 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -219,14 +219,8 @@ static int tcp_write_timeout(struct sock *sk)
 	int retry_until;
 
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
-		if (icsk->icsk_retransmits) {
-			dst_negative_advice(sk);
-		} else {
-			sk_rethink_txhash(sk);
-			tp->timeout_rehash++;
-			__NET_INC_STATS(sock_net(sk),
-					LINUX_MIB_TCPTIMEOUTREHASH);
-		}
+		if (icsk->icsk_retransmits)
+			__dst_negative_advice(sk);
 		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
 		expired = icsk->icsk_retransmits >= retry_until;
 	} else {
@@ -234,12 +228,7 @@ static int tcp_write_timeout(struct sock *sk)
 			/* Black hole detection */
 			tcp_mtu_probing(icsk, sk);
 
-			dst_negative_advice(sk);
-		} else {
-			sk_rethink_txhash(sk);
-			tp->timeout_rehash++;
-			__NET_INC_STATS(sock_net(sk),
-					LINUX_MIB_TCPTIMEOUTREHASH);
+			__dst_negative_advice(sk);
 		}
 
 		retry_until = net->ipv4.sysctl_tcp_retries2;
@@ -270,6 +259,11 @@ static int tcp_write_timeout(struct sock *sk)
 		return 1;
 	}
 
+	if (sk_rethink_txhash(sk)) {
+		tp->timeout_rehash++;
+		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEOUTREHASH);
+	}
+
 	return 0;
 }
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

