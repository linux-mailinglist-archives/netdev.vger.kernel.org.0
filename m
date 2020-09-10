Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC746264E7E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgIJTQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgIJTPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:15:50 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BCC0613ED
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:15:49 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n133so7195011qkn.11
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qC2VWLk0/qEnHec9uRZvg0cPu4sO7p/Sao+VaNVpy7M=;
        b=LBKn2lbeE0P/JUyxnqZ0uA/tGUDKsRXFO8vGEoOQP5BkqUKCVkiqQj6fDNpy+Je0hK
         ikZJF7AODpbcrogjBSNqFrz6CaPHIOqO8AXcg+V8ZXX/5wVZMy7K7ajEMnQnQOTd2rVw
         JJciGaqYFBXZfnAqNE3W3p606wWPzCYxbviPIU9Edj+uLKc+C+Ewv4x47aAU7Tr8jPDJ
         wVS+DFsn3P2d+b5+zobyEs4/vg01CoDZ/HiIumm+WeNTT0qpk2rfpVURXVlnmsHTUxk/
         bYUHKC3IxLlWJ1zf6G5WxCjGpQ/dFQZqeOFXRKmeAFsg72pH0gbywbf9r31bGeUUQPvx
         HJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qC2VWLk0/qEnHec9uRZvg0cPu4sO7p/Sao+VaNVpy7M=;
        b=m3Gu+DGQGHH8JBQq5lVnqncKq5dnXjdXc5njwIqdFZLES31Mp8vEdacWQriQbFEXBc
         Yqjm4v+IvKsvHCpFS+wizhAopmjwsAtRnP90UhrY4NR02dy0oSS90yXdKkAC5UtRlJms
         VFtyqtosu+4671UkMTx1AHLOQusuKV1U2+CDllFbn3pCzrKpli3B/KDpYO3W/j/qxQOW
         ggudJbQ9eHSJOBawnTVa6jqW/poeQCpcYPrX7GXgD85SBB3/JnVm6Blrb0qhvY+1oiHm
         GQMXK4a4LYQEgc+aCDIqJ33gMaiYkYO+GVytsaTiNQ3uLyqwAv/LyXYl55A4w3SDnAd4
         pEoA==
X-Gm-Message-State: AOAM5335egHpb7tMndsWt0fF4nxSc/zHa6Z+KY8+mJf/nLqs6HcqzEF5
        Z+KZj9Cvm/uQrLpojZeWYG8=
X-Google-Smtp-Source: ABdhPJytm2i3sPS3qWBLSPYhSvQ7j0Rq86l3Q+EVC2hB51AsVOe7k0cSeuJByfEZaNmu8WlHhz6n0g==
X-Received: by 2002:a37:7d87:: with SMTP id y129mr9695600qkc.108.1599765349186;
        Thu, 10 Sep 2020 12:15:49 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id j31sm8456630qta.6.2020.09.10.12.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:15:48 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: [PATCH bpf-next v2 3/5] tcp: simplify tcp_set_congestion_control(): always reinitialize
Date:   Thu, 10 Sep 2020 15:15:46 -0400
Message-Id: <20200910191546.2852195-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

Now that the previous patches ensure that all call sites for
tcp_set_congestion_control() want to initialize congestion control, we
can simplify tcp_set_congestion_control() by removing the reinit
argument and the code to support it.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
---
 include/net/tcp.h   |  2 +-
 net/core/filter.c   |  3 +--
 net/ipv4/tcp.c      |  2 +-
 net/ipv4/tcp_cong.c | 11 ++---------
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e85d564446c6..f857146c17a5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1104,7 +1104,7 @@ void tcp_get_available_congestion_control(char *buf, size_t len);
 void tcp_get_allowed_congestion_control(char *buf, size_t len);
 int tcp_set_allowed_congestion_control(char *allowed);
 int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
-			       bool reinit, bool cap_net_admin);
+			       bool cap_net_admin);
 u32 tcp_slow_start(struct tcp_sock *tp, u32 acked);
 void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 067f6759a68f..e89d6d7da03c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4451,8 +4451,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			strncpy(name, optval, min_t(long, optlen,
 						    TCP_CA_NAME_MAX-1));
 			name[TCP_CA_NAME_MAX-1] = 0;
-			ret = tcp_set_congestion_control(sk, name, false,
-							 true, true);
+			ret = tcp_set_congestion_control(sk, name, false, true);
 		} else {
 			struct inet_connection_sock *icsk = inet_csk(sk);
 			struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7360d3db2b61..e58ab9db73ff 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3050,7 +3050,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		name[val] = 0;
 
 		lock_sock(sk);
-		err = tcp_set_congestion_control(sk, name, true, true,
+		err = tcp_set_congestion_control(sk, name, true,
 						 ns_capable(sock_net(sk)->user_ns,
 							    CAP_NET_ADMIN));
 		release_sock(sk);
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index d18d7a1ce4ce..a9b0fb52a1ec 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -341,7 +341,7 @@ int tcp_set_allowed_congestion_control(char *val)
  * already initialized.
  */
 int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
-			       bool reinit, bool cap_net_admin)
+			       bool cap_net_admin)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcp_congestion_ops *ca;
@@ -365,15 +365,8 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 	if (!ca) {
 		err = -ENOENT;
 	} else if (!load) {
-		const struct tcp_congestion_ops *old_ca = icsk->icsk_ca_ops;
-
 		if (bpf_try_module_get(ca, ca->owner)) {
-			if (reinit) {
-				tcp_reinit_congestion_control(sk, ca);
-			} else {
-				icsk->icsk_ca_ops = ca;
-				bpf_module_put(old_ca, old_ca->owner);
-			}
+			tcp_reinit_congestion_control(sk, ca);
 		} else {
 			err = -EBUSY;
 		}
-- 
2.28.0.526.ge36021eeef-goog

