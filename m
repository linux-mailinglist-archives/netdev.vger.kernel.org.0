Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E076C3D0B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCUVwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjCUVwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:37 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A514FAB3;
        Tue, 21 Mar 2023 14:52:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id ix20so17516528plb.3;
        Tue, 21 Mar 2023 14:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtsTYTsJcWAWZKuDnStnRk5vYxx1AzkuxP7veMJ6MVo=;
        b=ATQ8vN1DHH5Su80gq2uMK9CC5tmK4oK7oVCoqCIepaWJ66mEve+GFjz600rntVLMFm
         oMeYHhBWucIpNWK/SXl5WpO7q5rfQmIg9UVBQTHgOSZPWRQyKQWR8ZaxG5bZv7EYRsnX
         qy4anwiXV42QQSXcWVpo6/mYo0yuDfVId4DHRx13zZWnNNN08lRhkZabpuzHZVjo0Au5
         s82P80QyiOlWTjiXeVIHBvmdgB0FxqNHJvk+tgjGLAGM/20aRs3YzjBTBz8pP5X7UeXz
         fzSYVhtBTVvfFdr4SHBF50nc1i6lmVY3gL28l5Hl6BdyrVu2SeO6wSyuBJqnKShh/pD3
         F6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtsTYTsJcWAWZKuDnStnRk5vYxx1AzkuxP7veMJ6MVo=;
        b=7N+1lw7w4xm2gipRwJaRIfeEjMXbs9VsIS6ebwhRrg7oMAo51HMXukyI10KI3r4joL
         dgT2aKFTS/egys8BKeByb15dIioadVK5Ek4tlCEzqhJA+m/WKirfTOtFa7Oh8ZBlYaTM
         4pUpfKTn8H0GDakgRmCjg+dmV1hdE14T2zn67TJ2naJZt02UU9qyp9qF7InAofQyWMpO
         SQnItO1op9twGBc023Yg2Il1ow92FbDBLh3ykiau0TpnaTsa1+alVm8Vh1R9VYwlwBvw
         /cszjN1NRfuaJiOAe1jv/tCwFhIoNbKwV7gw45AyB29/wC/AF+ljIOTovLmRScHSbgts
         AaOQ==
X-Gm-Message-State: AO0yUKWpPGErah5BQf2i0WUym9mTQmIfsm1013FM95bHsLU6ilJFaeRj
        ZlZ1sJJUp0/F0tQreZqxcbQ=
X-Google-Smtp-Source: AK7set9MBuTRTBl6+QsN3IJSIMHBI9yheYby5PCOI8Bg+uelRoQ4cm7Nbo2VjqKzdFC4P9TmUuDc9w==
X-Received: by 2002:a17:903:32cf:b0:19c:e842:a9e0 with SMTP id i15-20020a17090332cf00b0019ce842a9e0mr591123plr.16.1679435548177;
        Tue, 21 Mar 2023 14:52:28 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:27 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 06/11] bpf: sockmap, wake up polling after data copy
Date:   Tue, 21 Mar 2023 14:52:07 -0700
Message-Id: <20230321215212.525630-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
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

