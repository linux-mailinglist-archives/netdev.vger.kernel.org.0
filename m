Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4127264F29
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgIJTgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIJTfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:35:41 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAF4C061757
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g72so7287773qke.8
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y1Qjy3REE/DvqVeuoDCxwy818dXeknrvZhb2GWvtIBA=;
        b=nUdv6TKlDUP0FhNeZ4heaPj1d4St+l3qKYYO3tXTjo6UAF/3Rtfu6mMV0bie+iT/qu
         /sJUmVZAuPnTEhwc4KZsPL9vvo+2J2NWzqkHLRHmNlJ8Myvh7Mdd+JKEBf4OhzDI732g
         6nwziRl1edDb/q1o21gy/TWMSNc0ckM37RrIhdFgjSdSbpxC0uZHNvzTIhnENPZyuC++
         vhpwEB5hmJc48sf/uUeEGvPUqcY8Vs7zMWAIryq5uYIPhw637aKE/+otQaaa8XepApid
         0GAR55WjhtCetUO6NKBrRAkZVMEtb+LtUEgEYgdkejnX59MicR15XI6pNxHusyGB1KzQ
         PscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y1Qjy3REE/DvqVeuoDCxwy818dXeknrvZhb2GWvtIBA=;
        b=BxOq5t1PLTOHG48tAMUsOuM6ZcFT53GA/q5LWfSdmW/5USg21lUEO0nFz7C4/Q3Mvc
         N9Af4kMknUcsriqHeerGWWIUX9ftBjdIV57N0pGU33s+PbMUYXQWMtcRtztxP3ZfL8Ad
         kFGy/IrjGkXiz75JHtaDaeenB7QDbKElGhYntrh6DbtfY7N1QnZZx8rLZiWlhgVWmV42
         zHASmUt4vDFuw5b7rbOPUI4fJ5RmwB+ilOrxJN0sadr6OECNzSRTSUfEXehsmOKOl4fw
         rs/K3EbDlRLvPZd073EHJl9pt67Lqbtju5oLQbrrmNwd7NeB9r984SB+JHVngC/LgtJI
         34QA==
X-Gm-Message-State: AOAM532EemwqUYwS4v+3DpiZXBDdwyLPADYnkPcPiBLMgbqEgUu8AK7w
        nBvfvXb00kzFANsruWYr7Jk=
X-Google-Smtp-Source: ABdhPJzL5h0rqe0d1/fQ3dAU1WYaa+mSsB35kHaairqhv6PTiDwbK9mcBZBZeYxWE8Caj5AbYgK7Xw==
X-Received: by 2002:ae9:e70c:: with SMTP id m12mr9493095qka.91.1599766540338;
        Thu, 10 Sep 2020 12:35:40 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id f13sm7735484qko.122.2020.09.10.12.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:35:39 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: [PATCH bpf-next v3 2/5] tcp: simplify EBPF TCP_CONGESTION to always init CC
Date:   Thu, 10 Sep 2020 15:35:33 -0400
Message-Id: <20200910193536.2980613-3-ncardwell.kernel@gmail.com>
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
2.28.0.618.gf4bc123cb7-goog

