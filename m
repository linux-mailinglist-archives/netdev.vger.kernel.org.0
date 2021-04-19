Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8282364952
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbhDSR5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240278AbhDSR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:57:12 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFF7C06174A;
        Mon, 19 Apr 2021 10:56:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g16so10413557pfq.5;
        Mon, 19 Apr 2021 10:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyCrkBvt3y2Wz6sLvGE/dTRK0nVA6L+NQj8plRBJmJk=;
        b=pxoJFl656uU2tx9KRIXooUcwv4KrH5NOZmcVIQHtZzAU9ubXcXhDCm+9Jjw1ZNsiJQ
         azR6v1ssZSQ4h/X1kRXB/463Jdz8I/9mvrjeiVMyuSq+0dlbJ8N0ct04BXQYGN1a2BfL
         XL03/mLkY2GICYVvI+bDRbgC6bDCCw/sprdlX22/WNg7011RMfmFwANXUa2uAOS8l+/3
         AKkUiT6MR9MF8pmNBRMMsdqr2NL3U6rwxpR0Pg2IiBjEmlpcBdsQ+mJuLq5/C8zmf9Fy
         DwrcNGrcG8qZIqnhmaZVKEGEWor8oH6aYxo4TpDedYhvSARmZTp/ONGCJjHvzmzqir8N
         nJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyCrkBvt3y2Wz6sLvGE/dTRK0nVA6L+NQj8plRBJmJk=;
        b=rbofv9Ug46xMt6wj23D9ggLSW1NIrvBpgc1pS/fhVxXzgEDLaD83HODEMS/zE9Ezpz
         BSl8avDlf2SxUmBxC9LWX0w0ba4zeSLjZcl0BjpDPcjYNnTqe9GBitgjbwk/zmI0PHFE
         ILllhwE8r+pRICTOa/KQwOZ0+o5UvydMlciIwbU6gRo5kBvNmMdjT0cv+5ANyrOkVSnJ
         nOjKBuh58z3aBEbkQK0bVnIoPvT29lTFzbrR+n7QDfq5ryj92pLaHOQmF1D/uvoZL2b/
         9c14bVr9qCjrJKm+loZ+vnO/7xPEqvGMUABiYkn5D+K8ebmfQuCZqXYXnayZFT/7zqhI
         lF3g==
X-Gm-Message-State: AOAM533W7SMUpM3xIyKD/Up6t0vgJoMUmZzh8l7sAarqWPvlvtmXnXs+
        UJpygkIuJgNYHdxWyjxJxFFPmQH81ssygA==
X-Google-Smtp-Source: ABdhPJxdjqHIv00/cm3RGDg8YRJXYzMg47xBFAinPEPh4ifEA9eeaVaJICELN15nxEe1YaIqvlaXBw==
X-Received: by 2002:a63:e541:: with SMTP id z1mr13376489pgj.59.1618855001813;
        Mon, 19 Apr 2021 10:56:41 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9c9:f92c:88fa:755e])
        by smtp.gmail.com with ESMTPSA id g2sm119660pju.18.2021.04.19.10.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:56:41 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 3/9] af_unix: set TCP_ESTABLISHED for datagram sockets too
Date:   Mon, 19 Apr 2021 10:55:57 -0700
Message-Id: <20210419175603.19378-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
References: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently only unix stream socket sets TCP_ESTABLISHED,
datagram socket can set this too when they connect to its
peer socket. At least __ip4_datagram_connect() does the same.

This will be used by the next patch to determine whether an
AF_UNIX datagram socket can be redirected in sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 97dfb747e052..183d132e363a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1205,6 +1205,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		unix_peer(sk) = other;
 		unix_state_double_unlock(sk, other);
 	}
+
+	sk->sk_state = other->sk_state = TCP_ESTABLISHED;
 	return 0;
 
 out_unlock:
@@ -1437,12 +1439,10 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
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

