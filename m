Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1646DB168
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjDGRRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDGRRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:17:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB35BDD9;
        Fri,  7 Apr 2023 10:17:08 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z19so40500835plo.2;
        Fri, 07 Apr 2023 10:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680887827; x=1683479827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=RKoit1fQ5sVnszxQkDfFFMNrZ/bZRRPCVaVPYFGO6fHseZ4BgvuzzBXUE4ocWvyHdL
         4YAjmXhXfumjj6F+BkXFRVVMbdhVAHp6C1SW/M/q9eYIkjXy6F+lSQJbmfAM1ISarRTJ
         2eq5Y0ntsDcHOWkcQJYSYTbAq7W9rwZsqvYs1hFhspnAqpwuSBC5mdQprY6+0R3/jzj7
         osk5b5xfhXvxr6IbMwc1nn8nMEhk0qptgK7v1XP7fwTTS8xWzGAJCFGFRZlCCW9o9GDr
         PbkUJ6u6xFH/ASq216xJs5WbLgXELQqE2SjpiuPPJ6mhi0hQvELc9tiOhG825fZb405x
         HA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887827; x=1683479827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=uksClONFtSnFaH1Ga8y2wbCxMLDETfJ2i7H/R3L9R85TvzodI6E8YgdyLySuGJ+Kxv
         WVoedjIPFgdg9XsnFm5SfpoNqxGWWkBRvxEDe3DVk000jZkI8wBI3DJYTcI/sUbmaIda
         3ZerMCeTstzELcxNvhGTeMJ3HB2TQn7vNF57YSh2vroKciYbNJT6oKrPwDSoZXyzghFR
         1JONb28exIHQi17oJzUtNASY/ltFOtJSvq8nICiqifTUQNhm5FozmysMlDv7UK76XONE
         5BGE18xeuEhcaL3mUBVxBNEkJhZ+2wkgCXLl3S7gJZk47qvxUnLrND1XHECFPIG3wW+C
         GDhA==
X-Gm-Message-State: AAQBX9dVtvZOLi9CR1lEW1W/tNQRtC4hvWN3/WvVhqsIQoLP9NypJ6Ed
        7vir0XJjIpNqYyvmOgZmZNk=
X-Google-Smtp-Source: AKy350ZSBaUl8Y5/PC0h9BwK7z112llitfJX42zqR0UYmGGMqs/WJnA4DGBRTyUA3zI3slycHtoVDQ==
X-Received: by 2002:a17:902:d510:b0:1a1:d949:a54a with SMTP id b16-20020a170902d51000b001a1d949a54amr4173613plg.58.1680887827302;
        Fri, 07 Apr 2023 10:17:07 -0700 (PDT)
Received: from john.lan ([98.97.116.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709028a8100b0019b0937003esm3185425plo.150.2023.04.07.10.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:17:06 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v6 06/12] bpf: sockmap, wake up polling after data copy
Date:   Fri,  7 Apr 2023 10:16:48 -0700
Message-Id: <20230407171654.107311-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230407171654.107311-1-john.fastabend@gmail.com>
References: <20230407171654.107311-1-john.fastabend@gmail.com>
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

