Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD4634BEDA
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhC1UUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhC1UUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:33 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC77C061756;
        Sun, 28 Mar 2021 13:20:33 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id p2-20020a4aa8420000b02901bc7a7148c4so2533508oom.11;
        Sun, 28 Mar 2021 13:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cio+qgcDvmruwG8aqOjWedfunYy04m3r9xm+A6tj84M=;
        b=nuEEBeBFD1mY/wHM7bnhvnfwShfLwsU552vwpru1UzRPPXYzmT9IY2AQVd3OPWDqgV
         TP0tyR1nR6d5BKs4n5yJSAJ2PUmeE6dVc50kLpfOEaDq+qvYlxbhjjAhivXwC4JMeGsj
         10iuXiJI+jZpt8iZnyoNinxK2d3o8tH/jtc7NVKv6CSwD9eZqMbioqpq+tG0UpHjO1WR
         B37QEcWwIv15+QW+V+Vc6wIPTGZPoR7vN8DP5NZjdtbWRdhiQCGSo2oYdkeC0KqfO7Ze
         Ml5rj/nRR3ttv3966pkE5HfQsZKOjO/6PE9BrcXlwJwVAsY8u9eUnNrsf6Nd53H67Vaz
         Mrqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cio+qgcDvmruwG8aqOjWedfunYy04m3r9xm+A6tj84M=;
        b=HE0Fb1EuNPQQtpM3ulhtXlJMewIrYVCQHHnc15KHzBKd+Oefmpg4GihVk7BVQZc2vu
         QYbqdNLYohuPQk40W1qULIYITnq7dWA33LW35ZnKqPVrlXshmG5gGkvP4uN/15WAvZ4n
         h2XEATl58bLz6ETJ09vO2cXGr9axj5fXXvzyYcXIyhaKszeNQUl/fSej8hZ6W6ZPiZ8w
         ZVTVnhYTJo7tVKRWNaMr6l6YKXHv/pxQw3wY6vJFi8srYpxTY6jZvNtFwWnTOB1BaH/G
         Z2AOtVzzvPMt+wbYWnC2httiyxTFVPYByWkabEkN3CAkmU9mLlRmNndqbDexg90FJsl0
         c5aw==
X-Gm-Message-State: AOAM530MoLpIGUgBvzpTp3Hesyi5hgRo74XL6osV8ulSNWQMVZYYXtml
        MpE8GV83Tze/S58K04cDRG3LxLscdmOzAg==
X-Google-Smtp-Source: ABdhPJwuOlyL007rESEiWVt9+EGxmEGbjXGGYnTDOaHgH/8RfccD1p9HJjBSSUz4QIg33C0l1quf4g==
X-Received: by 2002:a4a:4005:: with SMTP id n5mr19288444ooa.61.1616962832710;
        Sun, 28 Mar 2021 13:20:32 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:32 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 12/13] sock_map: update sock type checks for UDP
Date:   Sun, 28 Mar 2021 13:20:12 -0700
Message-Id: <20210328202013.29223-13-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now UDP supports sockmap and redirection, we can safely update
the sock type checks for it accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d04b98fc8104..9ed040c7d9e7 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
 
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
-	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+	if (sk_is_tcp(sk))
+		return sk->sk_state != TCP_LISTEN;
+	else
+		return sk->sk_state == TCP_ESTABLISHED;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
-- 
2.25.1

