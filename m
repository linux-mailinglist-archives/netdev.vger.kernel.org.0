Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DF96CAC69
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbjC0RzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjC0RzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:55:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E472681;
        Mon, 27 Mar 2023 10:55:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id cm5so415651pfb.0;
        Mon, 27 Mar 2023 10:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtsTYTsJcWAWZKuDnStnRk5vYxx1AzkuxP7veMJ6MVo=;
        b=jROISYHnUCOdoBJDDKznFtb4ASa6WNWONHAVclierkokFwE2GXLQa+6y7s7YAgHkeq
         74abbUzbm3jFVcUI9I1Cdh3h3oqIb0HrLSLUGXgxXNHr3O9ZWjsHnv+/DyDCJjqNhKZh
         SHVFFHBn5bHL3pLB7ZgPgaYDE9wKmmxt3gxhgz0uS7WHfooddIrFp7lFa8UZ8ygwYBIM
         K7855G0OaVvk/+c1c6/sDKT8Lz9QKhtGDNEMV6Sc3ndE8298SNpZPIwpGuczEOfeaufR
         Ojjtw1+os1mFrqfExNcAo4tIf8SRkBaXOLbVOPjaJ4FMRzODbhOW0duD2TRHOpAjOkZJ
         k5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtsTYTsJcWAWZKuDnStnRk5vYxx1AzkuxP7veMJ6MVo=;
        b=kT0wb8rnHKr5/RR3dMcXfM6GtcoEE4U8Z20WfMSlAHuHlXoInOmj9a4Wd3fR9z9Z22
         EmzNyx/r28BP17nuy5zicH+1abY135M3fNu0GAwvqWSB/Pdbh2xPN7pvmfl/qDUYpCgd
         iaimmNVceKrvS+Nw5OID6XZ2LbBjERxPZiIAjxzaReAk/hHRw0VP3PCpNjycLFFzDcuc
         UiVvQPUtn6wgBNBWCNPWVq3hUoG3dq0td40Fd478Sl6BVP08ryIl2hxuSfx0Dh38L1hw
         Gy9GayWjepH2KfkJZgzrViEXx2kKHtdYNb6RT6IlBaT7ojr+RTMS1lyxvBMpzKRcsRrH
         eQBQ==
X-Gm-Message-State: AAQBX9e4OzznBpeC2qDHZ2VrG6N1ipUXtRzPH2HTi6wOnlB8QG7Vhm4A
        Bjc0VBrvYTo8oRj9blJddVI=
X-Google-Smtp-Source: AKy350aGPUPAbzRaoQrX+GT4yKuyS8MRA4AuYfg+B5q/iA06RJgy8Wbj490v/QPmZrIjVP61aC04Ng==
X-Received: by 2002:aa7:9508:0:b0:629:fae0:d96a with SMTP id b8-20020aa79508000000b00629fae0d96amr12809757pfp.16.1679939699500;
        Mon, 27 Mar 2023 10:54:59 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:54:59 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 06/12] bpf: sockmap, wake up polling after data copy
Date:   Mon, 27 Mar 2023 10:54:40 -0700
Message-Id: <20230327175446.98151-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
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
index 34de0605694e..10e5481da662 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1230,10 +1230,19 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
+	int copied;
 
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

