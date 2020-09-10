Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE14264EA0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgIJTVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgIJTU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:20:57 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68610C0613ED
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:20:57 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id cr8so3904569qvb.10
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rtUwEGlyH5UHD/xn4fGHTquuooXbAFvvo/KaYXsXfQ4=;
        b=HeThdFtSTJrPXrn73TX6TnROS9e2JMbtLXl3GdKwZLryJajLSMlxp2jsMJSY3y1Dbw
         xm90EeqoEzh2R/cVsYp/3QAAJeJCIiCV4ZcAWWOoWsJCwXvHgaCVtARYbeDcpy+rMrAq
         lPYbASs2LIw/Wypkqg0gOxYmJuUIJezylz8U0RZnzyczk15iT082gJSw0XaXIEotHcGz
         r96vjDNA8cxJL03HdOVWk9gW9yZKt66DwJ6Kcd9B7qmVGAEtthfXKci9B/tFeOf9h/W6
         Ndl2bnqwKcvz1JjWLSab55Pmn9USp2Gi2cVbbO7zZjKc1OLgkKIMav/aWxdmF8Qs1bKD
         guNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtUwEGlyH5UHD/xn4fGHTquuooXbAFvvo/KaYXsXfQ4=;
        b=ean5NPPs+Ik86lrJoMuHwkL0aCVKPqjjNsVXAGox5+0U6YO66XKXxPf4Vv20+qGNwa
         fWlejxxvnSRi072BLzWMuC+yOzZtaqpmsZqK61sqykBatc35c1mc2PDin22CAfQX4Cap
         WzOnHA7rhnq6sgqoWK/tghTWpu7m1JlEM+8U9RooWaKfT8qTXL7hHb+/y6n0f7tPx5Q0
         vNx9/lnbxeJhTjgQKaNjw0TMXbSHItotUlDydZ89qYrIXb6haNyU3UPfJE5iInL51z6l
         JzhzI8Zu9Du8sbpuzszRUqPMBSW1f9e5wfq+xDuI96zLzC9H9ieJwqWpdcrU9KDN/R2n
         ZGpQ==
X-Gm-Message-State: AOAM530XaAIi8vH0TiBwzXfRSIWkC8qvoubqzKhuvHW35NEXfvMQeMNL
        pKwA5urQpUHZYz3+QpHl7a8=
X-Google-Smtp-Source: ABdhPJz14IH219PDpcoRZ1ntvCIYL47a1omErsakj3DEBvxmHhMT4m7jQ3PpEdrNn9b6Boc4IPz0Hg==
X-Received: by 2002:ad4:56a6:: with SMTP id bd6mr10308669qvb.29.1599765656651;
        Thu, 10 Sep 2020 12:20:56 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id z6sm7315158qkl.39.2020.09.10.12.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:20:56 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: [PATCH bpf-next v2 2/5] tcp: simplify EBPF TCP_CONGESTION to always init CC
Date:   Thu, 10 Sep 2020 15:20:53 -0400
Message-Id: <20200910192053.2884884-3-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200910192053.2884884-1-ncardwell.kernel@gmail.com>
References: <20200910192053.2884884-1-ncardwell.kernel@gmail.com>
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
2.28.0.526.ge36021eeef-goog

