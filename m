Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E168F32DF5E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCEB5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhCEB5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:57:16 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDE3C061574;
        Thu,  4 Mar 2021 17:57:16 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id l64so759964oig.9;
        Thu, 04 Mar 2021 17:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G2pc2Y0r7yxQXq7OMqDkdZt60cvbmBdKnnGFRzv2eB4=;
        b=qfNcZ1U9zgSH+2Pydqr7ywyWioNRYYuQP3mwwhbO7Y1onjcksPcTZdfr9dvQGd0j5L
         LzQNwYnvMW4tRSqjbMD9Mv/TLxcd8YW/GtES19Y/JeJ7ljwDfJb/37oqXRwiPcDa534J
         sqnGND29+e+MUoYABa9L1C8koggw0I/OkezVX9rJuWknCvHF5odl0R3f67L2GWt70W9S
         b9v4LCJ8p/c3Mlx6F5vIIAShWVS7ayKzUqcoi5PFzksZgk/aEpogTUaSVmO/OfKd/EvB
         dBSSsQprVVjPEFwseufqWVVEetPtEygePi1jCnvDLzRqi3C/YGeFjVC74TZoPPwg/mkX
         M3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2pc2Y0r7yxQXq7OMqDkdZt60cvbmBdKnnGFRzv2eB4=;
        b=r3BOyvchLrs105J17R+q6pmfDX/9Nd5CmElrjpVhToncGq/dPFD1+nVll6KO71sEi6
         yQF+uCY+UVI2RfQtNKsVHgZmWqAsLx3kH/Pj33IjwXYKpkdaqZ6A+qvuv+6oNbW6+B8a
         DFfKO9eyFN3YDLjvNODHHCJL9MasdMCY1paIOAyEGHkxASpZiF3PELZ/Z8ha/zPObsxu
         7AeY48XLeOg3NK3JL9g7sPhGgDUDqmmDSWKkFr068v+7n2ca7Ep34Z9DwyNZoqfZY+Om
         sQWNbed6VnG5zrpqHDdw7SaeAlAS0I/Fs8fJIX22jcq2S9Nwo8OewT114m6KbjhhYEKq
         IoFQ==
X-Gm-Message-State: AOAM532nxTHLZq4T8cuaOaOrzDl6n0/JCZhQjfmm4ZejKmRLU2iUCny/
        kJyjUNDibP+5chEhdNTouKA9gEw06Iaz+g==
X-Google-Smtp-Source: ABdhPJxc5LyDVd5Y5cQj9O1cn7CwxwxExCsUShOwiUB/rKQDqtO0xEkvniNgHRrt5WchSCE88523ew==
X-Received: by 2002:aca:1e04:: with SMTP id m4mr3198104oic.124.1614909435518;
        Thu, 04 Mar 2021 17:57:15 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:95de:1d5:1b36:946a])
        by smtp.gmail.com with ESMTPSA id r3sm224126oif.5.2021.03.04.17.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:15 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 8/9] sock_map: update sock type checks for UDP
Date:   Thu,  4 Mar 2021 17:56:54 -0800
Message-Id: <20210305015655.14249-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
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
index 7346c93d0f71..64a5d5996669 100644
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

