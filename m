Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB90220FE2D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgF3Uvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgF3Uvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:51:31 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11B4C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:51:31 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h30so15291306qtb.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a8Mna9JvTOrVKn6Q1hMZon3VYM7qkCojbUu1upW8NtY=;
        b=PyelTbsCd7F7Y1Rpa56IhJz/ojjwC6zoG9nmXSMpk2vU1wGTV1hUTOBxsEidPjcKvs
         f6BN406O53SPpAIqiWLWDCwjkJvgNEVxOCkvIMM+zYnckOOIRsSHkAjvP+LECdkUuA8x
         6fB4/9S4DuHA94Nc/hlBO60XV0lZEUKtXVHcszbdvEgIxL7D1rl1Dm7majn6WGW+0JA+
         7THIYirx/jueV8D6aYYG60tuhtmcTtAoMsoKSNslzlnmlHbvUX5zDfJsdn6BObYXRmmu
         tPfcWF6rjpEIglmH6wsEU8C7ik36nibDi2Sn4ng/Ro9KQ6P78ErIqTj5fohl2Ph1Kqb+
         6mpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a8Mna9JvTOrVKn6Q1hMZon3VYM7qkCojbUu1upW8NtY=;
        b=ge8jVITJwH1hdsOjfMAvjo+y7eC4wqGyTLgW4teOlXjpOEXVsQFHopK9EkI20Gt5i0
         MPMgmO038yINvX2o8XTspEEGr/OEABy7IfJJbt1clx8eIkpHDRtFBTSiCXFcVjpq/jd7
         GI+Dob5xfkjomCvwfnaOJSByYOJrOCj2WpG6Y8n/H4vZAaqgW0epS3hSybWnXSDfOVB3
         yeNiz0OMduF19x54wU3bYhbcdF6Uryp1A6KcocfXBIwoVKbGBv1mxpbzgo/M9M7vH3U+
         89HhvUyFOkS5TwHy7918Nrb3tSADXfH9iHghtJcO1OvBLgqZmltOEqDMCht3CYkfvgN7
         XSOg==
X-Gm-Message-State: AOAM533p/Xk2TC71MbBG31Kq2JZhQytqQBd/ok3sZi0WeOuD03HWXX9h
        e6QaD9Qe37ZM+B6Gs0ioxim5k9zq4CNWGQ==
X-Google-Smtp-Source: ABdhPJw3abcUm3vvpABx6WRyLQ1bJ/kWVSEK8IvnNYtX//Yiphey9ETFrsl9t+NeIw9M3HC0zYLTwMHEdhPIPQ==
X-Received: by 2002:ad4:57b2:: with SMTP id g18mr21641219qvx.207.1593550290775;
 Tue, 30 Jun 2020 13:51:30 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:51:28 -0700
Message-Id: <20200630205128.3162961-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net] tcp: fix SO_RCVLOWAT possible hangs under high mem pressure
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever tcp_try_rmem_schedule() returns an error, we are under
trouble and should make sure to wakeup readers so that they
can drain socket queues and eventually make room.

Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f3a0eb139b7633ebc1ddb801de232bcd3a0cbdc6..9615e72656d12e9c7298bf7087792d0209897b50 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4582,6 +4582,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
+		sk->sk_data_ready(sk);
 		tcp_drop(sk, skb);
 		return;
 	}
@@ -4828,6 +4829,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 			sk_forced_mem_schedule(sk, skb->truesize);
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
+			sk->sk_data_ready(sk);
 			goto drop;
 		}
 
-- 
2.27.0.212.ge8ba1cc988-goog

