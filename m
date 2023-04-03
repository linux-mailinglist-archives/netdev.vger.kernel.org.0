Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEB06D51C3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbjDCUCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjDCUBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:01:54 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7606E3A88;
        Mon,  3 Apr 2023 13:01:51 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id iw3so29174804plb.6;
        Mon, 03 Apr 2023 13:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680552111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=PpK8uXpXsSoABWnIl20UFWvQo7p7sruSV3zY9NaYJIGpzVk0XuL/KxcbW2nS0ji1Bj
         NVikSE8ckqdvY61doWVIH7ZLtMy3guZdsl/2p42G51dVgW5sTWO6f545XA+2DcHD8Aq1
         tsoII9mqfAs/C6p7cZR3SxI6jIvlGAEOqm03gd2ZvVKqKhGuoMQxYVgtQMFi5iVojMv8
         DDQR/4N+J9P6moXm+kUDqZVjjq/qSSxQ7zTey+3Wz0MUYzqeidD4MRt2341kqGbhPHyR
         +2gbNiQuxZSaPEo6qQXLAc6OHsqMv9Ujp2XLEURK5Tsg13eOUV2kewRfBjTMzed68+d1
         5hGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjReQ0LZ9FSRk9w0Br06i8T7DbKDQWusTN4F3PIXHbo=;
        b=LZ6toeLXG7nF6QhHd+w9BrgImH5jonxMa8OohJ27tG7IVdoQs1QoU9TTKi8rSbICwP
         60Vsz4mjeahOpDoO1aFoUupZDVCb9aPP9ewhBd9UY9XWgZvUO1kz//RV0zQJ2Xp4mrzH
         kWGyLdBs/3yJEh5cz8vyl+pPGvMmLP/0ml2taxKtAw45DetipGaasDB/V6P+WKEwhCiD
         EoFziAAUkPEzjTf7H6dBtFo5peDrKW7IRPpl0hw1vYiVlauImbamGsPZKofJfpQulx3l
         xktkun3zE/nRcd1SfiJHvYo1sruPQS+mVM2wYg/liR7IiM89lJSiu1osRid97mI0seQj
         ZNeQ==
X-Gm-Message-State: AAQBX9cOomR4UqIYFdDfXNDWVNyjvzVyRFfpwyHbT8h6Ovxbubk2ZupK
        autZgLwDqW9AprVyXaGnxNqyfm+h3i/tKA==
X-Google-Smtp-Source: AKy350YB5Kl88lDGFkMuvdozsYgmzHNVgBhfeE7DkG4Rh/8CAtudpWkHJBEme1kcGItsKbSApnK4hQ==
X-Received: by 2002:a17:902:e884:b0:19e:9807:de48 with SMTP id w4-20020a170902e88400b0019e9807de48mr292585plg.23.1680552110923;
        Mon, 03 Apr 2023 13:01:50 -0700 (PDT)
Received: from localhost.localdomain ([2605:59c8:4c5:7110:3da7:5d97:f465:5e01])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709028c9200b0019c2b1c4db1sm6948835plo.239.2023.04.03.13.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:01:50 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v3 06/12] bpf: sockmap, wake up polling after data copy
Date:   Mon,  3 Apr 2023 13:01:32 -0700
Message-Id: <20230403200138.937569-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230403200138.937569-1-john.fastabend@gmail.com>
References: <20230403200138.937569-1-john.fastabend@gmail.com>
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

