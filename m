Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A8A6D8A56
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjDEWJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbjDEWJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:09:33 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DA17DB6;
        Wed,  5 Apr 2023 15:09:17 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id o2so35749148plg.4;
        Wed, 05 Apr 2023 15:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680732556; x=1683324556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=kb2lMcEP2xe8Qs5fh8SIxzMht8SUdmarPWclb591EOHjSRd8x6QKi78oqqaFlDoI7P
         8ET2V3uVI5uJ2jmpaldAZfckOv8uVzrJveqKSBlNRC3Jrov90OnJxt2CoSoleio7xBL4
         BN+D0jMjiXQasGel0b0FWqkbtplF/DHFkeYhmiVokLPZbjf4RL7fU2eGr1C8eRsMyjRI
         bchJ2uzITBaYWQp6VzftdpDB/ToIZ9TJ0P0AqRD2bGkpF02koFwd3FlORz3fwM9Cn+5F
         dLQls3dF4bjODzlWkjPkzHLQ/OMeW0vC6Wlej42N/a7U4P6La3usmzGoZnXaVh7ePbMo
         haLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732556; x=1683324556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=Usz7PR11PfvZPefZUbKeyZzM6QG4Vi3TkFKKSnmYKVKd0z+z9d4HptjRFcgDnCWzad
         YKjOIuj30TOX/o9aNMg1Epf6adgzwuM1auekM6TsuBow9h03HEZ5s8rQbNEEy1lTfwrK
         Qi7oIcejei8BzdiUWoWwnHbPpwP3496sGYRcFuCBoN6e+fmvnSG6hJWyJUi+6UAGJffQ
         QnxVUnu7un0mI8J2WMk6TVF3b04e1BUhO8TjkIDshEYXmSruKMfWlsScuIhGlN5lQfIq
         R9QACz3D+bcypBpiUuzg6xahTBzZ/j/lLW45EAeqFjehUZjKeNPCAlGWLLsWVad7ffiO
         yOYw==
X-Gm-Message-State: AAQBX9fr3fUYLSqZfIu28ug5YA4XCWTQMwq5mjdh1m4TQGZzf+j6W9NJ
        9R4hXP8QO1yqnbChpDDISqT9ZzMPehK00g==
X-Google-Smtp-Source: AKy350a8Wy3XGvwGx6ABtF6oYbB0PJNvX3Wwt8I8Da0Rm9GUeLrTAG8GAJJ00eL4bAY5E4cxBYPCRg==
X-Received: by 2002:a17:90b:3ec9:b0:234:409:9752 with SMTP id rm9-20020a17090b3ec900b0023404099752mr7961417pjb.25.1680732556646;
        Wed, 05 Apr 2023 15:09:16 -0700 (PDT)
Received: from john.lan ([2605:59c8:4c5:7110:5120:4bff:95ea:9ce0])
        by smtp.gmail.com with ESMTPSA id gz11-20020a17090b0ecb00b00230ffcb2e24sm1865697pjb.13.2023.04.05.15.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:09:16 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v4 06/12] bpf: sockmap, wake up polling after data copy
Date:   Wed,  5 Apr 2023 15:08:58 -0700
Message-Id: <20230405220904.153149-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230405220904.153149-1-john.fastabend@gmail.com>
References: <20230405220904.153149-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When TCP stack has data ready to read sk_data_ready() is called. Sockmap
overwrites this with its own handler to call into BPF verdict program.
But, the original TCP socket had sock_def_readable that would additionally
wake up any user space waiters with sk_wake_async().

Sockmap saved the callback when the socket was created so call the saved
data ready callback and then we can wake up any epoll() logic waiting
on the read.

Note we call on 'copied >= 0' to account for returning 0 when a FIN is
received because we need to wake up user for this as well so they
can do the recvmsg() -> 0 and detect the shutdown.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f8731818b5c3..a2e83d2aacf8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1234,12 +1234,21 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
+	int copied;
 
 	trace_sk_data_ready(sk);
 
 	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
 		return;
-	sock->ops->read_skb(sk, sk_psock_verdict_recv);
+	copied = sock->ops->read_skb(sk, sk_psock_verdict_recv);
+	if (copied >= 0) {
+		struct sk_psock *psock;
+
+		rcu_read_lock();
+		psock = sk_psock(sk);
+		psock->saved_data_ready(sk);
+		rcu_read_unlock();
+	}
 }
 
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
-- 
2.33.0

