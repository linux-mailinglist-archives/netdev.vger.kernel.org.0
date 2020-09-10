Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B226524F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgIJVOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731014AbgIJO2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:28:31 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45674C061757
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:47 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 125so3660695qkh.4
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2TlvW+gem47oqaiPgHzk63tIxcSfaHdErY8i/BUbrtQ=;
        b=FiyJnDW25tS4GsOYsE8fh7PH8XlSDXnLRLpoCzOwoVPB+WfOOQdhNo3FNUixcDKLli
         OI70gHY1emuyc7ikwb5r5Wdz6sgx4iqccIUHkzj/DJ6SucZBUJ/qFnhFPaJqqsrfn+Z6
         94k4e1HqkdDHFi/2v4fAmVFxG5sgQgz+mfCkv0/7hifqfQWPq3wBKYR/vBazRXVe8pDq
         geR6uJXnxn54TnUTDx4gVyZsAWuU0eFdjNZVE8LgSAj8Mtws1D2FR+D0ilDhxGh1Dx2V
         coML/5PbGTLZ9Ay4TE31Rh8QCctHiCHJNeqapUE1buKrdS+MQr+yF/2b6qvMcYPIrICU
         49Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2TlvW+gem47oqaiPgHzk63tIxcSfaHdErY8i/BUbrtQ=;
        b=L32tcbW68oa+i6SUBpa0w7I7Ns0Wf5PDgTodvq554Hrmp6asjDwfIrpvPy4R7FuJgb
         q+ggQ8BQG2UEy5oe7YMTCKDWsbhS2XUbMWrpBOqsrFJF3BFkEAX0m4hAKjhEMPTZ3Oca
         J9NlApPMd6lkhUzUo+xCxQV3QwULtMGV6hroGpWWvBxClEn0Y38X9mJg7l2is9HeqEgL
         /VYXkH8mEdbrfHRu0tGBjpkHnGm/uCNnK9HiSnvorCw8r0RcLqGwDQesHE6PjKQ3SfBa
         Ech3baaDsl+k9v6Inx4vJgqEBQ2qHglMHSdnonC19f4vDIt+2EP4xDfJXmawmNwunS0+
         7+AQ==
X-Gm-Message-State: AOAM530w1UvygGF0wqcgpY0sp7jGTRhwsrKm0fPnr3PJ5tSlpQKbw8pR
        Elc/elctoGLK9oNT1Pkry2OAnWq+qDB5Br4=
X-Google-Smtp-Source: ABdhPJz0Tr2O2Uzx3/IO7MvKwuvstSzyeN3XwXkJO0PvecWUqV+6qSs4NleAc0dMP0AdbTzjD9W2ob0h0WpeeOw=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:eeca:: with SMTP id
 h10mr8952892qvs.13.1599746686356; Thu, 10 Sep 2020 07:04:46 -0700 (PDT)
Date:   Thu, 10 Sep 2020 10:04:27 -0400
In-Reply-To: <20200910140428.751193-1-ncardwell@google.com>
Message-Id: <20200910140428.751193-5-ncardwell@google.com>
Mime-Version: 1.0
References: <20200910140428.751193-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 4/5] tcp: simplify _bpf_setsockopt(): remove flags argument
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

Now that the previous patches have removed the code that uses the
flags argument to _bpf_setsockopt(), we can remove that argument.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
---
 net/core/filter.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index e89d6d7da03c..d266c6941967 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4314,7 +4314,7 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 };
 
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
-			   char *optval, int optlen, u32 flags)
+			   char *optval, int optlen)
 {
 	char devname[IFNAMSIZ];
 	int val, valbool;
@@ -4611,9 +4611,7 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 BPF_CALL_5(bpf_sock_addr_setsockopt, struct bpf_sock_addr_kern *, ctx,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
-	u32 flags = 0;
-	return _bpf_setsockopt(ctx->sk, level, optname, optval, optlen,
-			       flags);
+	return _bpf_setsockopt(ctx->sk, level, optname, optval, optlen);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_setsockopt_proto = {
@@ -4647,9 +4645,7 @@ static const struct bpf_func_proto bpf_sock_addr_getsockopt_proto = {
 BPF_CALL_5(bpf_sock_ops_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
-	u32 flags = 0;
-	return _bpf_setsockopt(bpf_sock->sk, level, optname, optval, optlen,
-			       flags);
+	return _bpf_setsockopt(bpf_sock->sk, level, optname, optval, optlen);
 }
 
 static const struct bpf_func_proto bpf_sock_ops_setsockopt_proto = {
-- 
2.28.0.526.ge36021eeef-goog

