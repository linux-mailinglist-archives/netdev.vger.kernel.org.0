Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCC136AAD0
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhDZCvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZCvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:51:00 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0F4C06138C;
        Sun, 25 Apr 2021 19:50:18 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y136so23156057qkb.1;
        Sun, 25 Apr 2021 19:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VAkAGTv3tSKkDyojScl6Kn+k3PxHxCfUkX5R08qmgI0=;
        b=Ou3ORZUI1zZi5B4D+Zm1eX0z9lombyn5UDnb+hyRQnxjMtbklLKUQyTPNipIWv4+xn
         fg/N+KJuGmB7wR+/u6dy25m/ERe0GTHHsBWFECrif1vmaqueegnxUVVSxOUSYMxjkzzk
         2MQbKSlXCy5pF7T/aAbVSnO0cqneUqW8KWTUmQsLcAlQYTsSXR443Y0zFwO/zRhSu6mG
         K7KatwP/J3Pc6Q0bXyRpIn9eKCvSjCFVJrCvDqrU/zHiSQTg8VzHFBB1sfK1wF5NZF/f
         jVjW0mzYQrf5OtLvbWdBRDpPQkaNmuAq30lE2eY/2j0BSJCAb92xp5HYTjbwUAlOA7Of
         1JXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VAkAGTv3tSKkDyojScl6Kn+k3PxHxCfUkX5R08qmgI0=;
        b=oOvu0DmQVZuxPxyl49Tixa9NAEw/c3DOwvVeKgm7sLNPaBWaQoR/+PwCMfKHv5FglM
         g4JjeLq/cBCIBhNUvfO70zliY/cGYn0PjRaGexQgztgVoQO62pZbOSJZwLCnZ5s10c3z
         gOfH5UD19EP8XZaOz10qAA/cs1YGVrnnk5jJZzsgNZt8d8k3mD9Ogq/uZGjNKQFpMPie
         uiyv90HZnEstGLKAmKgKx2//GUesOtc9IAqAt6PF40dOgfjb4So9hQYteIY8c77YAVy8
         HwjeMJ/ay4PZiHbQQHsjbH6iIesZoOB4cFRYSWPxTkZsIuy9IwQOpVg0VNq5IZHIUe4n
         yg1Q==
X-Gm-Message-State: AOAM533ljJTx3Af3qW5QwIfBpyDUF2trpa07jzhPJ015IaAPiseNhPM/
        ClQzsqJrlb4HyQYN1pDFGzck/4gfSqWoDQ==
X-Google-Smtp-Source: ABdhPJza3esOR9GPSlrL0GmbTSkkJyh2aBdlV280iuWeseqfMNm94K6qtaY+BGJODctnhmCkB2+NFA==
X-Received: by 2002:a37:4242:: with SMTP id p63mr5398094qka.107.1619405417285;
        Sun, 25 Apr 2021 19:50:17 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 04/10] af_unix: set TCP_ESTABLISHED for datagram sockets too
Date:   Sun, 25 Apr 2021 19:49:55 -0700
Message-Id: <20210426025001.7899-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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
index 8968ed44a89f..c4afc5fbe137 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1206,6 +1206,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		unix_peer(sk) = other;
 		unix_state_double_unlock(sk, other);
 	}
+
+	sk->sk_state = other->sk_state = TCP_ESTABLISHED;
 	return 0;
 
 out_unlock:
@@ -1438,12 +1440,10 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
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

