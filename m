Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC566D8C56
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbjDFBB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjDFBBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:15 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F4A7ECB;
        Wed,  5 Apr 2023 18:00:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so39068264pjz.1;
        Wed, 05 Apr 2023 18:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742847; x=1683334847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=q3Y5cYf/7fUq9G6HFHyPmpYtgJ3eok4WRfXnPX+xJzcrWqW8LzmiZgpoiNwun/AnQg
         +v6mNcSjuwJnre6Jh6rWDdTkoQgOw7HZCn6pthzUCMWQBOe82Nps9328RkhOHUqqgquz
         NIozFSbxs6v5rPnsAAfHfDT6xRPCBWRsyI+n9K2STNez+TrGfpsOkP9HmUSh/3/ysy1i
         02L//1r8C5qYQSzjwjl4K3hzyWoRf04XxU+G3ArYs2Ah8kuQ4U/VhbXj57qFbROCIx+6
         s6vPyBU+yVc9RgZOwl4UumIzXj1HHV8Nc6pStE2GGGDkPh21TcpCCfDidVBo+aj2GLPJ
         3dXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742847; x=1683334847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=BA4zNG38aBWKqB8RxVXrQZpInUNhPOEgYJLx7exhRrUgZy8Gck+mgRI4rTMKyjItSc
         56nK8+ouPCtNVybzax9KktrqEkiO+4IKaXJijyqpFQCEoVuutvA9PUBwG6Wf/XFrIseN
         ekE+oGJkUbVGissT/82CLW2PtiVBODNPecx89WrjtOh+nDmHm8rdjAL3mh6biokddncQ
         L8TpSnLDOZazbzc0Bi4n72oMjMXhZMrs8pwab1oOLYNmbn9zhEbgX0vg3U0CW9ErhGPA
         hmByBlLxdtAFX1AbB/acVU9Nyv8ql3HxKQdVIM1O6Vx+6QLTTpMOz4ZVDdVD7XncpyOU
         RyLQ==
X-Gm-Message-State: AAQBX9ejGjm5ku0khygnTN4uO6C616iWIoDZlN4E7QsnI8S1C1USUnA1
        iWAfB2mxHVgxNXah+zN0+F8=
X-Google-Smtp-Source: AKy350ZKzBgCDdXqcmOnPGYBhUwoziW9WDehqQsWFOwdE1yXqN04S7f2kuE+V5eJR5ShS9XGSJQBvQ==
X-Received: by 2002:a05:6a20:b2a4:b0:e7:54a5:517f with SMTP id ei36-20020a056a20b2a400b000e754a5517fmr985751pzb.62.1680742846836;
        Wed, 05 Apr 2023 18:00:46 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:46 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 06/12] bpf: sockmap, wake up polling after data copy
Date:   Wed,  5 Apr 2023 18:00:25 -0700
Message-Id: <20230406010031.3354-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
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

