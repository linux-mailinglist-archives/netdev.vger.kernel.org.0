Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB42A264F28
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgIJTgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgIJTfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:35:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEF4C0613ED
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id n18so5852869qtw.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4NVvlx0Y06jzusDaZ6IoBQMLf9wBMnk5hk4bhYfrbF8=;
        b=O9Sz5hNWhATnTUNiYf3UGLUufvuzzLSxfcu0boUs38EcmxBqpYnGydHu2ebKnMHEKk
         Rv5iNW6coIzPPkjq2sudtMqrg7Hx/wiDo7mTXfiBp4dfEjxN3NZ0BBMv4ycKmWTg128L
         eXmWDa9i7uicUhp44J1ma00dD/FPnVQ18efb5Sjyvm2/rjrm65q96TQgA43Lwsqtt5O6
         I2eTuaUrjJe8Obru4oPQY9hbpu+BbEVN5ckiIlsOkr5X7CLXU8aQVKUik7TfGou4qpH3
         xnHOXh2P49n+wee6/9kn0LYCgnhOXHb9NIQ3dD9Gza3z6K75myiJH7bvtwRlRtjGbvXO
         pVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NVvlx0Y06jzusDaZ6IoBQMLf9wBMnk5hk4bhYfrbF8=;
        b=hPy3UTUs9UZjVsBEnOIl3ZmU96VkItMzlnuaXPpLc8Il4anJb5Su//5Fpuw41b00bN
         iyQF5dtwZWJTbgYVGYEPUWUJ0dBvvzsZ2HOMFJlaoEpRyANxtBbCnh0cE6RI1pTKD0se
         fDGokfvSb216BpkqxFfgAHFwtap1rNbr3QL6n31NqaimGZX+80+arizthTwN3UE0JmXC
         WRY0Pj3+08YTJKjGS3k5jhAr5tEuizcL+gS9Y2vX60ZdXqDxDAWxm8MntH0FpMMc0LaI
         vfsbI2SlhzkY1TRTo0NeTjdAwJOh1iEyUDHFJGC7Ne7NBeZcgpFAggCZ7aEM5jtaWe1a
         tryA==
X-Gm-Message-State: AOAM530xW4LTYAC0iUsxuhj0eY1nbUE63hsrO5urRWS4Y5D4l6Gu9XAs
        E1cwQJoEXc4rXIVHBq054/k=
X-Google-Smtp-Source: ABdhPJz4Iex0y5KVVdZqsnJVgaBMBTll5NGl/3hUklsTJRTDBUGNjrq/1ONxdQUeYwJj7+b41Gf+Zg==
X-Received: by 2002:ac8:4757:: with SMTP id k23mr9377376qtp.105.1599766541328;
        Thu, 10 Sep 2020 12:35:41 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id f13sm7735484qko.122.2020.09.10.12.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:35:40 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: [PATCH bpf-next v3 3/5] tcp: simplify tcp_set_congestion_control(): always reinitialize
Date:   Thu, 10 Sep 2020 15:35:34 -0400
Message-Id: <20200910193536.2980613-4-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
References: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
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
2.28.0.618.gf4bc123cb7-goog

