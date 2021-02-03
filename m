Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B7130D291
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhBCEU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhBCETA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:19:00 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D59C061352;
        Tue,  2 Feb 2021 20:17:20 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id q3so5707691oog.4;
        Tue, 02 Feb 2021 20:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hgdUBSB4MvEvN3e6yvQq8UCSM6sKbUZ7RhvBlW/6NiI=;
        b=pNcRXnqIiCzgEBvY66O1RauFKbKd7kuoeID08LnOef1yPXN5t59HFrAlyVkOn0A7Ux
         tkdtMiXHbtwbQWlwuc3I518f0aaLf0K7X71LdaqkDI9fJB20slybzLuZVZ56zXAeS2W+
         T9nJgfxaYvGLczTqg2PyhYs0ex7ajkS7zD08BfkzN/rTgXv2R7O3yR0IRGh4sUCvOm7h
         vmpR+9knw8XrefcEG6w4C7pDaBZjFTCQVzFJjui+QtOAWfLKxsY8FmeKys65LsOohaBB
         mnJ369W0x9Y7uWOXND/KrX5J24jmrtGsMHZOY1nyugynht/KykJN8ILSD+0kk6L7MkYp
         ImnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgdUBSB4MvEvN3e6yvQq8UCSM6sKbUZ7RhvBlW/6NiI=;
        b=k68Cr6L2nJshvIo6jjv8/1uXHUFGOfiHuDrR77cLskqcvnAY5BRX/gJXjhklo/GHu1
         dPEDXBz9u4I9NEq/88D4fYzXELSa4/H/kazjlS2fbWTmv+z44x72HAI7d8eVx4xEIEZE
         HGl0y1FoSzVH9u0JVlgtblH5YDUt6C4GZFYqUtQ6uJG7Z74SVW9JDxH3zY4Dc3t9CAHb
         lL3ioV/1mcYPaepFdGOk9fxHks4iBeIT46RFfBSGnS5ekjMXO/0GY58A23j3wCPIDh3p
         jkdUiJovLIhlmSZJEZmTmbnaFNVowfCtZDO6clMg2qFXi2yXxQc85YxpGS1lc0W5vWUk
         1B+Q==
X-Gm-Message-State: AOAM530ThCqvwRc3+EYOxgGDatSzkn3BIslYfWc+yMzY9qDrsBARLU0i
        7mnYqgKkf4DZtxMFM2mXlrVbo1t1RF8zvg==
X-Google-Smtp-Source: ABdhPJwA3HhzhwojS+ZjjSbtl9Hwa+f3jzEb8um8+EKP+8q0qA23p+y+6MhVsj7pyGfBpyldHK3STA==
X-Received: by 2002:a4a:96b3:: with SMTP id s48mr813426ooi.11.1612325839404;
        Tue, 02 Feb 2021 20:17:19 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:18 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 17/19] sock_map: update sock type checks
Date:   Tue,  2 Feb 2021 20:16:34 -0800
Message-Id: <20210203041636.38555-18-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now both AF_UNIX and UDP support sockmap and redirection,
we can safely update the sock type checks for them accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c    |  3 ++-
 net/core/sock_map.c | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8e3edbdf4c7c..a502137f7bc2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -667,7 +667,8 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	write_lock_bh(&sk->sk_callback_lock);
 
-	if (inet_csk_has_ulp(sk)) {
+	if ((sk->sk_family == AF_INET || sk->sk_family == AF_INET6) &&
+	    inet_csk_has_ulp(sk)) {
 		psock = ERR_PTR(-EINVAL);
 		goto out;
 	}
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 255067e5c73a..7e56a3ec7a57 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -544,14 +544,22 @@ static bool sk_is_udp(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_UDP;
 }
 
+static bool sk_is_unix(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_DGRAM && sk->sk_family == AF_UNIX;
+}
+
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
-	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+	if (sk_is_tcp(sk))
+		return sk->sk_state != TCP_LISTEN;
+	else
+		return sk->sk_state == TCP_ESTABLISHED;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
-	return sk_is_tcp(sk) || sk_is_udp(sk);
+	return !!sk->sk_prot->update_proto;
 }
 
 static bool sock_map_sk_state_allowed(const struct sock *sk)
@@ -560,7 +568,8 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
 	else if (sk_is_udp(sk))
 		return sk_hashed(sk);
-
+	else if (sk_is_unix(sk))
+		return sk->sk_state == TCP_ESTABLISHED;
 	return false;
 }
 
-- 
2.25.1

