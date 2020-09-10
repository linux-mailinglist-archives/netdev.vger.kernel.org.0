Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878C02647C1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbgIJOIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731054AbgIJOEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:04:46 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687EEC061348
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:44 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 205so3663843qkd.2
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vizF2ErHY9g5QaQv8JTl5z8oP+vX2Em3be2Hcn5/dQc=;
        b=LRp6/ky4mbVOwpcB81abrxn0NSnll+XZSW+NVCkhmf23JDTDlqb0ReZzzMKoQ8anEV
         LVYtkluf3wQySy/nL3qv+5j6nbUKh2AcwinETW5T6mx0XhGsZUX0J6uM/LA89aMgsPyj
         nbHCkaq/ButfqcIBfgxEel2GtPgiszBLNGBGtatNZVBeu4n7yrgJ3gXyN5mZkPXMsZF7
         SF/lcZZ7ojsiY08DM1VM9i9lNByaJwNOehK2e/UDwKC3nwhRLTqZ6KGnNl5x2oZ27XhW
         i24UzYIIKwJYsGz0UnYTOhRVKQzhFWZC3MR7jUtXFH1H6bS06NLMh1trQjWWxNCC4Hxt
         kIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vizF2ErHY9g5QaQv8JTl5z8oP+vX2Em3be2Hcn5/dQc=;
        b=GLoInRr2ZVMQ6qOcNETcjBaDxh7m32wYYPtdoxf0JQXCigzYTy/aTuyVd8O1Evxk4h
         vRb52RDXclyRRsgDw0fL5Y/QYvOJG9rOb8TmAe31GgVcoJzYJAtUVaoFpZ6vQ4VIXYLi
         K7CpxG0BXoUccmxZf/n/k0iRZbZE8J7wwNy4zK/oTa5Ml4h1kw1CcK3VZOI3LzxVF2Yh
         t0yVsmuGKOQfUMGyXbTvH9ArHmovUWdRGa0LubIluozr3uHs06okCZHqC1xLcc/OOKaJ
         KEORxMw5aXRiT6fzbz49iOLcU/C23EnOiwqOKxHLPfrjhVqmkZBgkzJKg9q8FpZOUrw5
         Q29w==
X-Gm-Message-State: AOAM530UCD9BU9MoNXN8fkz7mG3xjBI4vyoZxpbMgXAf6AD9YOVGQB2O
        NdJCe4TiaHJ+opnCZe/JaGvo//AJSe7od8g=
X-Google-Smtp-Source: ABdhPJxEn1aInpaHAmEFjlmhAEXZXDzYJ9Tzc32ZglsWUKKyZJpdUc9bC64fxf2B1PxD/7dnkQPNqSC3fW3JaBA=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:e904:: with SMTP id
 a4mr8610458qvo.21.1599746683572; Thu, 10 Sep 2020 07:04:43 -0700 (PDT)
Date:   Thu, 10 Sep 2020 10:04:25 -0400
In-Reply-To: <20200910140428.751193-1-ncardwell@google.com>
Message-Id: <20200910140428.751193-3-ncardwell@google.com>
Mime-Version: 1.0
References: <20200910140428.751193-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 2/5] tcp: simplify EBPF TCP_CONGESTION to always
 init CC
From:   Neal Cardwell <ncardwell@google.com>
To:     Alexei Starovoitov <ast@kernel.org>
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
index 47eef9a0be6a..067f6759a68f 100644
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

