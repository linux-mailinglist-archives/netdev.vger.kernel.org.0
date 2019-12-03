Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79A41101C9
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLCQF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:05:57 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:35071 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfLCQF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 11:05:56 -0500
Received: by mail-pg1-f202.google.com with SMTP id t11so1915668pgm.2
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 08:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zwMIe6Eg1Uo5FcajCo7R4z6i3w2U3/lx4IP+en7R5gU=;
        b=biS5NLDggGD3q1QN3E8kLRPgtyuREsQQIPuHhEJynwrlKVIc9KhpSULiuSBsdRoKyU
         dIRv6sYgit4XumZjNzec9JtKFi9qH3diekvgq0uOyL4vpXMlshsr3EPuf9qAsViReAp1
         lJ3edCcHTlJfXI3jbp8kHN+B1nmge+mPYFp+b0XSrnPDZK/LsbQzN8bMfQMbmzvvql2B
         638GCcCkcxW1V1FxkDGyNl3PwGH62bLoTbVNbIxqxGBn4Uq3/AeEqhQBoCCSjBYGRnRx
         uiG09Gp7NIRWG2XpcoyXqTGk4ojdOZ+MascVgKOvFF/JZMkNrecMxeVIVCLJsj+lzkJg
         f8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zwMIe6Eg1Uo5FcajCo7R4z6i3w2U3/lx4IP+en7R5gU=;
        b=lAFbHQ144sxjCurtZfvpMM+h2VSV9/35wkmgJ3R8X1PMOu7+Uw7nUxLDst0M1eZwL8
         qd0S3kLCx/bVf0jQ2iKsCj3W/Yl+Kb+1wHptYauPlcD3gX1lmPWFo5icaKwq0EtsoLIU
         R2OBKpthSA5J2pyoZiqlNSY0YhokwNAnjBE2mg3ktJbFjheZSXrtQACQF6bUF66VwF7m
         CFKDIN6N/ELAn3l3II1gi5a2KW7TDMuTMjJ7Gy1BTIDXkS/Sh1kBawHspipuMDUphSt7
         NbsUfFgkm76R/fyNXyVUuSSOovsH9Pj/5xbydSktX3ghu9+HeF2/7TrsK6MwsGvktGUm
         ZskA==
X-Gm-Message-State: APjAAAWNGIYSu0LjZ6N6lgEkCrOu3u+BD4LOAsWSo04ulu3gFJm+4PZl
        A3+Fa693LM2mZMozgoOnymbwRs8abrDWhA==
X-Google-Smtp-Source: APXvYqwXgzY2ueZin0huMkyEz5l9JYKYdgr7FhE4pOuF669bpEwBi7jUygt+9pCOc6BpQbSNfl3RrOnXBj23rg==
X-Received: by 2002:a63:fd0a:: with SMTP id d10mr5846525pgh.197.1575389155975;
 Tue, 03 Dec 2019 08:05:55 -0800 (PST)
Date:   Tue,  3 Dec 2019 08:05:52 -0800
Message-Id: <20191203160552.31071-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net] tcp: refactor tcp_retransmit_timer()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears linux-4.14 stable needs a backport of commit
88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")

Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()

I will provide to stable teams the squashed patches.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index dd5a6317a8018a45ad609f832ced6df2937ad453..1097b438befe14ae3f375f3dbcc1f2d375a93879 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -434,6 +434,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	struct net *net = sock_net(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct request_sock *req;
+	struct sk_buff *skb;
 
 	req = rcu_dereference_protected(tp->fastopen_rsk,
 					lockdep_sock_is_held(sk));
@@ -446,7 +447,12 @@ void tcp_retransmit_timer(struct sock *sk)
 		 */
 		return;
 	}
-	if (!tp->packets_out || WARN_ON_ONCE(tcp_rtx_queue_empty(sk)))
+
+	if (!tp->packets_out)
+		return;
+
+	skb = tcp_rtx_queue_head(sk);
+	if (WARN_ON_ONCE(!skb))
 		return;
 
 	tp->tlp_high_seq = 0;
@@ -480,7 +486,7 @@ void tcp_retransmit_timer(struct sock *sk)
 			goto out;
 		}
 		tcp_enter_loss(sk);
-		tcp_retransmit_skb(sk, tcp_rtx_queue_head(sk), 1);
+		tcp_retransmit_skb(sk, skb, 1);
 		__sk_dst_reset(sk);
 		goto out_reset_timer;
 	}
-- 
2.24.0.393.g34dc348eaf-goog

