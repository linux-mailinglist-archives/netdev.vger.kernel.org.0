Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD5C37743F
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhEHWKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhEHWKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:14 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9196DC06175F;
        Sat,  8 May 2021 15:09:11 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id v4so504735qtp.1;
        Sat, 08 May 2021 15:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lU6deMHw1f7T8Vy5QqfQAadD/G/Nn7rO2ZLLwGffBII=;
        b=toHg32WaYqiKj0Elqih2fW+wjSMkpM61WLwJjzcIP0wYPvS9nQkL/XEsM5CCm0A58d
         xBvvMlR8ZiL3k4aOHv/OZio7XHFon5db1ZcR1vI/YN2wVvWvgg5gstih7erZeUZiOBRi
         aIcxt3+Krm2G1DWTYBbaBkks7/z7v6VHR7lHOZXT9gGudUv7a/9JRHOPRFaxPN6sUz/g
         QvF/d/FWgKcYydYoWr4ecJ4m7e0OxC/LoS1mHj+tCVCEHS737KTK3wbnMVFwCw7wAvdc
         DapAwvP7urcr7W5qBOOC5K7aSV8ALrp3ipjs5TTfA7RXJBlKEbIXlMHGPtHQ9lon5rOj
         JIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lU6deMHw1f7T8Vy5QqfQAadD/G/Nn7rO2ZLLwGffBII=;
        b=mXzWuKuF4urO58HZ0kZt+OhqDskONFKV5PbQGjsbXktmUzVszV2pCO4gClwi6yHm4b
         gfg+fM0r+nqDAdbESzg1ZgtjSh1lG4SLSW0Ooy8h65JwtceO2ixEhBjQLJg9cprHVoQ5
         Jml91QrOM3wnKLJRp3DWVClC1zfOFLT1zihQXScbC5Ejmn4zU6yYAKFK8PngYHv1dYmH
         BtxpjOxm4hDLAxHblyvxxc4u0IifeiUtdTbnq7e/8GJASkN1VfW7h+9cMHi/NwS1Phhy
         H4ivwk9Z/avUG+Bu6ZjJKFGceyR6giZj5grDTF3KJVbjrgT3LzWlyH1JKSINATLeLips
         u3HA==
X-Gm-Message-State: AOAM530kgaXXi659aKg2Fu+CxK06DGm/+AgZC+zOMONpCg/J+yQh/6oE
        ozQqbxjHT40EZkl14Uz7pkj0rO11hpWwIw==
X-Google-Smtp-Source: ABdhPJxhbfPuz7Sx0z8Lk0C1xiMdpNGtlvGVJTqY2egkcrdV9HFwWt/g2Dpos94c34+NatASZtNgUA==
X-Received: by 2002:ac8:7b8c:: with SMTP id p12mr15432903qtu.137.1620511750688;
        Sat, 08 May 2021 15:09:10 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:10 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 03/12] af_unix: set TCP_ESTABLISHED for datagram sockets too
Date:   Sat,  8 May 2021 15:08:26 -0700
Message-Id: <20210508220835.53801-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently only unix stream socket sets TCP_ESTABLISHED,
datagram socket can set this too when they connect to its
peer socket. At least __ip4_datagram_connect() does the same.

This will be used by a later patch to determine whether an
AF_UNIX datagram socket can be redirected in sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 26d18f948737..e08918c45892 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -487,6 +487,7 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 			other->sk_error_report(other);
 		}
 	}
+	sk->sk_state = other->sk_state = TCP_CLOSE;
 }
 
 static void unix_sock_destructor(struct sock *sk)
@@ -1197,6 +1198,9 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		unix_peer(sk) = other;
 		unix_state_double_unlock(sk, other);
 	}
+
+	if (unix_peer(sk))
+		sk->sk_state = other->sk_state = TCP_ESTABLISHED;
 	return 0;
 
 out_unlock:
@@ -1429,12 +1433,10 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	init_peercred(ska);
 	init_peercred(skb);
 
-	if (ska->sk_type != SOCK_DGRAM) {
-		ska->sk_state = TCP_ESTABLISHED;
-		skb->sk_state = TCP_ESTABLISHED;
-		socka->state  = SS_CONNECTED;
-		sockb->state  = SS_CONNECTED;
-	}
+	ska->sk_state = TCP_ESTABLISHED;
+	skb->sk_state = TCP_ESTABLISHED;
+	socka->state  = SS_CONNECTED;
+	sockb->state  = SS_CONNECTED;
 	return 0;
 }
 
-- 
2.25.1

