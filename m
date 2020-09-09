Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B832635B3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIISQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgIISQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:16:17 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F209C061756
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:16:15 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id f12so2397001qtq.5
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=RZ48V2lKHNvzHAISSqx5zRygAAb3f3vZIanGXO4QqT4=;
        b=JGyW+i+w6WZGr7r+05GbUADhvmmnmyXZjQNZvMvw9GzAjX8+VtNwi/rX3I4i5fqmn1
         y8HGaQ6ePgHW+3DC3WkLn5Nr7nRkeddM1BoJlI6vdZ3WAZ5RjN2KC8O6CnPfEh8wU1Qp
         kWY+nQHnXQJVWR0KWj/idb5tAkoG5OarXqTfOrw4hGQnZXPnsPGz6fKeDoV1QV7243uQ
         rD/J9pUlbTXgMvq8NUqTtgxRqmRW1yNvQ5oSAy++lwTwNTe47i44koL5GgwjIUdBFm+2
         k4XSt6qtWr6v1tCNmR1q1pvIOytSfRrnDoShA4B0FMQpp/l8dwW7Vuy+KSmATRPmex2C
         UOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RZ48V2lKHNvzHAISSqx5zRygAAb3f3vZIanGXO4QqT4=;
        b=XkKH2OsIHER3LuEB0nUjy847jSsCYbRTGsZiN0Tj9RSyxX+Fc8xtQYffYZhAVmh2cw
         Ojv6MNt66bNdh+17FtvW4O/lFVgKbeM3PB3+7rXTPgtUHIdd49ADDbis4CQAhKjLjgem
         KlCVewhMmUskV02S0hoqwvuGKQKKytE2PZ89nnvmWLlySH+NcYse9Qu4SP+DWtXa8liU
         ij3qwLEvyVSAsN8kSOYULgvxVrMIJbbCkJi/iX32gkMi0hIqoUqCcOSmXcYbJhUuqKHs
         tGCJayiJ6Yg5vvivL+BXxE3MFpzwmXUZa4Fscb6s9upfKbhR7YpBrjF9capsI7ADRo3w
         s3eg==
X-Gm-Message-State: AOAM530qPQwtU9Crrt/hgea/Heu7ZM9uuMNQTazWj8Eg/K+MaaT4MEJd
        S8CBdXa8j5v3bqAkBIZtbSSfMi1QSpYmVO8=
X-Google-Smtp-Source: ABdhPJyZEd1LUGHZ36IVUYQXHZ/NypnrUYt7OqvAz1A9Z8vJlIsCjCBhqI7Mko4cg984zCeSskBqm4f6r0FIHM0=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a05:6214:1225:: with SMTP id
 p5mr5088862qvv.29.1599675374581; Wed, 09 Sep 2020 11:16:14 -0700 (PDT)
Date:   Wed,  9 Sep 2020 14:15:54 -0400
In-Reply-To: <20200909181556.2945496-1-ncardwell@google.com>
Message-Id: <20200909181556.2945496-3-ncardwell@google.com>
Mime-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next 2/4] tcp: simplify EBPF TCP_CONGESTION to always init CC
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the previous patch ensures we don't initialize the congestion
control twice, when EBPF sets the congestion control algorithm at
connection establishment we can simplify the code by simply
initializing the congestion control module at that time.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
---
 net/core/filter.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2ad9c0ef1946..b26c04924fa3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4313,8 +4313,6 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
-#define SOCKOPT_CC_REINIT (1 << 0)
-
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			   char *optval, int optlen, u32 flags)
 {
@@ -4449,13 +4447,12 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		   sk->sk_prot->setsockopt == tcp_setsockopt) {
 		if (optname == TCP_CONGESTION) {
 			char name[TCP_CA_NAME_MAX];
-			bool reinit = flags & SOCKOPT_CC_REINIT;
 
 			strncpy(name, optval, min_t(long, optlen,
 						    TCP_CA_NAME_MAX-1));
 			name[TCP_CA_NAME_MAX-1] = 0;
 			ret = tcp_set_congestion_control(sk, name, false,
-							 reinit, true);
+							 true, true);
 		} else {
 			struct inet_connection_sock *icsk = inet_csk(sk);
 			struct tcp_sock *tp = tcp_sk(sk);
@@ -4652,8 +4649,6 @@ BPF_CALL_5(bpf_sock_ops_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
 	u32 flags = 0;
-	if (bpf_sock->op > BPF_SOCK_OPS_NEEDS_ECN)
-		flags |= SOCKOPT_CC_REINIT;
 	return _bpf_setsockopt(bpf_sock->sk, level, optname, optval, optlen,
 			       flags);
 }
-- 
2.28.0.526.ge36021eeef-goog

