Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4400E36AAD3
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhDZCvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhDZCvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:51:02 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E12C061760;
        Sun, 25 Apr 2021 19:50:21 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id o21so12528736qtp.7;
        Sun, 25 Apr 2021 19:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KQf9mcOLrtUNLG51UOBy0gl3Ky2lVF6jZ0E+cVTDSzA=;
        b=OAkYA5NtvIu2ARz5LFEj9W72Jc24tarzGN8pR8W2skRtWMTE6aQQ5iDiLlKEcse5T/
         vlEH672TTLYduv/ipplDx3sovMHER4ply6+1RBh3ChSGTM1fN0ngpOtnyOtiQl79xTgd
         +ah89Op7G7DVi4yY7DCP1zk8SqoDiI6JuayceeiIjZn7kcTC33RxEFfFqj24Mfe3xHtv
         wXn4rVhjxGmT8RwpvC03HRhaY2wfUWilQIiRP+6gVYerkHmbqpi44qniDqo715gKKIfB
         4s+JzXkYPLTeLK5apfKHiFaE23sle7/+jLT4fYxz0IPrNcT2Z0J8qVcWJiBM+y6KairL
         LVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KQf9mcOLrtUNLG51UOBy0gl3Ky2lVF6jZ0E+cVTDSzA=;
        b=KBvjaY8QKrSM8eHOKD7RLLwk+ig8yAZbyVejNoS79lVgAnYE9IZeRw84eM0tYSNPM7
         l0OMaWd3hvnqr8Y1U/vfTAPA22WRNDK5rGKIYWP2XVIY2b3r8SwtDeY4/bFd8ylFPqyA
         hnbkJLlMv6hgS5wR5NCJZz9dwcGDG+zWFx+1ArU+96N2060UKYVoZi0Vz2HsXdDyckmO
         pc/2Hmrw1fajv+DGmRjXVJd4L1FSKJLtfGC3wP7PHPzdsTlNi7n3zX6Al0UPafd2sWV5
         9I7eQSOY9ptArLKRwPak6NGWZ7yw1lL3LBASLSbBs/M1u6fLgxwxHbxOJ6qrIvgEdXxR
         fWxw==
X-Gm-Message-State: AOAM532FYgI+6fv9UuesJN0komZZ69+8WNuHfrk/79vblymxI8MOT1wA
        KVxQfXsG/FfdK1+GSBv2/PSAgTPlojdHdQ==
X-Google-Smtp-Source: ABdhPJyYyTKU5amydWOnuzv7uJu5d4Njqqsyobg3YA0+1YeSPC7qBTCBCCYvqzMN6ngMH7w1LCixRg==
X-Received: by 2002:a05:622a:94:: with SMTP id o20mr15096508qtw.158.1619405420163;
        Sun, 25 Apr 2021 19:50:20 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:19 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 06/10] sock_map: update sock type checks for AF_UNIX
Date:   Sun, 25 Apr 2021 19:49:57 -0700
Message-Id: <20210426025001.7899-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now AF_UNIX datagram supports sockmap and redirection,
we can update the sock type checks for them accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1107c9dcc969..2acdd848a895 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -533,6 +533,12 @@ static bool sk_is_udp(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_UDP;
 }
 
+static bool sk_is_unix(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_DGRAM &&
+	       sk->sk_family == AF_UNIX;
+}
+
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
@@ -552,6 +558,8 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
 	else if (sk_is_udp(sk))
 		return sk_hashed(sk);
+	else if (sk_is_unix(sk))
+		return sk->sk_state == TCP_ESTABLISHED;
 
 	return false;
 }
-- 
2.25.1

