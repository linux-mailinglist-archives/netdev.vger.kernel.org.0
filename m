Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88957264A70
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgIJQ5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgIJQzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:55:33 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEA9C06138B
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:53:41 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id y2so3665064qvs.14
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=2TlvW+gem47oqaiPgHzk63tIxcSfaHdErY8i/BUbrtQ=;
        b=iM/I39naYyxAQmYqXuZeCKrhjethDVQAF0s8c+2VrWZyIVjRMbqKqcXkV29lYbE/at
         q1IHSjw+ihK/APwEmPgkXhn0aAi0cS6r8GpXpB7HoVDxAvh1MenL9epaAx/zhzmeKdR0
         FuqzUu/uvTkVodkEZxOmIZmBFuBOOM95Jh6y+gvB0g/igFO/LfcX28uikZhggJECNoAL
         JaH9IQgva2zWMMueZb+1FGoTLSX3AlswN9egtg0qYxqHdoFUrAuyYvePDDL6rAwt1XsP
         8bLHSf2EF0+0SI5Lxot07NzQ4xZSK5K4YS4JVobcSlN1ZE6xRh2Ih7gBv40E5kbWrhr1
         dwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=2TlvW+gem47oqaiPgHzk63tIxcSfaHdErY8i/BUbrtQ=;
        b=YjLAbyqeqQgy+zAqbjDmgR0lRWdzIqB/sghOZ7pgIg1kSjovIBb4I6Y1SDZaLOyVbC
         jCp9xSHWd9u4DoIZK05hyBh0cnwspSWJBf8+hnevNkPO56gmXGp3Q3lSNMRx7bcjzs55
         gSKL6C/hjC+iisijRRgfvwj2JCwOrPjnLED7s0/6C4FZKwjfeAzVO1t5VsrAcsnuJqVa
         N8hUWOuQA49dHjSC1pTFhC3qAIa0rGCLTq2XSiAJfqCIEob0X2NjcZYNUMb81OM+za25
         21yxIcFwZYXxUxr1gXOYt32aFkdSUdKQEdk+2Dw0JnSumf702+v4M2LQYnHQ4rxdgmeo
         iymg==
X-Gm-Message-State: AOAM533BdsnzdDfuSk6huX7d8hgoN+tl2nl7z/vdNclem7fL+NI+Tkyc
        s8BnoxIZpe7X/vW78n1kvRWovBUjco2jGtg=
X-Google-Smtp-Source: ABdhPJwS1tZJXOWOtK5Hicfb93xr6uuu+KoS/XWorGuy8+cTG4VxGS7yXX55dv2WmaIkv5SsBJHxRZxmXNtzl5E=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:fbca:: with SMTP id
 n10mr9462501qvp.123.1599756820524; Thu, 10 Sep 2020 09:53:40 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:53:38 -0400
Message-Id: <20200910165338.2028737-1-ncardwell@google.com>
Mime-Version: 1.0
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

