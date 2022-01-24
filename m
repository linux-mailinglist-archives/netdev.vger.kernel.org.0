Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653A3499C10
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380461AbiAXV7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456556AbiAXVjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:39:31 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB7AC0417CE
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:06 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id u10so12611237pfg.10
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/6C7q8//RS9PyIZsoudaUf2fJ6pFVbwD2v5ucpzbo5E=;
        b=c8JCM0dUBK5GAOcTjWwgG9ebJI/i4rpXgG08xQ7jd6jH18Um8qeMQ0wqkwhFNxbTQ5
         izYlgRb6XMRhdARTLNfHoXaC/YIeNEsLy8WIp7/xiba3VxiYUYozv8zRO1Lc8AjyMJxl
         3aTqnxqwrXHQYjrNilNW4tEXUd/rgKjVhV3sLqshNWnQ5FwlIc6Ivm8vAXcs1EY+HDDs
         37hPZAVgl1QqY6NeRXY84wLIEazmuE4n+HlVv44hBWSev5iAw6RhQA4GGhQYFBnx4gJU
         sZY5nM4/DP2TKAQGC6wsmMWy2I23qneaS1NycZ33uyo5egKv7y9uSsLQVcr87c7psKV+
         T/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/6C7q8//RS9PyIZsoudaUf2fJ6pFVbwD2v5ucpzbo5E=;
        b=ZpetpKK9TLW9WgGFWRy+JauBBmPgEmF/KEnIcAH3ar0WZK8UIqo26PzaW4emZ5Mc8F
         CV/TSG2bsLTZ2aKMYI7/bwOMI3jlBVAtFH8TkQe2wADu6bFsmpHGHMq1WAEPwAe3SkvU
         cegNJWdpQBaZMhNOr7TJWr/jfuv6cSI8ntXzhM/3LavpT9e+qR86S0x+yM9TgMLkyKI8
         +W7LcDjKIuHnYZKER5bWcwWdUZQs6CeNZswyaOt/s8+nEYwKt6or19s+3qtgphDPGBTz
         niT0MGRrz3UNtnO7l5GivLJKSsO+WNlFycxS1tuezgB5/IunTL9eM977SeMgh2rCRdjN
         mN4w==
X-Gm-Message-State: AOAM531CgiGVJYO00tTWDO6Z5ts1kKv0wIWBRvP3ll5hw8/353yyPqWB
        J4IFL8K8+vW70pAkNUOZqMg=
X-Google-Smtp-Source: ABdhPJxh5xgSSLu/Vdt/RZxOLZUsvaJr5Sjew+VbDbkNav4JVKrQ3yHdacJDNRHXAAMXqigspJk9zg==
X-Received: by 2002:a63:115c:: with SMTP id 28mr12850850pgr.382.1643055906526;
        Mon, 24 Jan 2022 12:25:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c19sm17871115pfv.76.2022.01.24.12.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:25:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/6] tcp/dccp: add tw->tw_bslot
Date:   Mon, 24 Jan 2022 12:24:52 -0800
Message-Id: <20220124202457.3450198-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124202457.3450198-1-eric.dumazet@gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We want to allow inet_twsk_kill() working even if netns
has been dismantled/freed, to get rid of inet_twsk_purge().

This patch adds tw->tw_bslot to cache the bind bucket slot
so that inet_twsk_kill() no longer needs to dereference twsk_net(tw)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_timewait_sock.h |  1 +
 net/ipv4/inet_timewait_sock.c    | 11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index dfd919b3119e8efcbc436a67e3e6fbd02091db10..c221fe2b77dd24d8e0d13db9819cdf3ac13fe742 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -72,6 +72,7 @@ struct inet_timewait_sock {
 				tw_tos		: 8;
 	u32			tw_txhash;
 	u32			tw_priority;
+	u32			tw_bslot; /* bind bucket slot */
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
 };
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 437afe392e667c7c54509920d1e624f759f9215b..6e8f4a6cd222e89b1c7f9fdd73b10d336ff026a1 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -52,8 +52,7 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	spin_unlock(lock);
 
 	/* Disassociate with bind bucket. */
-	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), tw->tw_num,
-			hashinfo->bhash_size)];
+	bhead = &hashinfo->bhash[tw->tw_bslot];
 
 	spin_lock(&bhead->lock);
 	inet_twsk_bind_unhash(tw, hashinfo);
@@ -110,8 +109,12 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 	   Note, that any socket with inet->num != 0 MUST be bound in
 	   binding cache, even if it is closed.
 	 */
-	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), inet->inet_num,
-			hashinfo->bhash_size)];
+	/* Cache inet_bhashfn(), because 'struct net' might be no longer
+	 * available later in inet_twsk_kill().
+	 */
+	tw->tw_bslot = inet_bhashfn(twsk_net(tw), inet->inet_num,
+				    hashinfo->bhash_size);
+	bhead = &hashinfo->bhash[tw->tw_bslot];
 	spin_lock(&bhead->lock);
 	tw->tw_tb = icsk->icsk_bind_hash;
 	WARN_ON(!icsk->icsk_bind_hash);
-- 
2.35.0.rc0.227.g00780c9af4-goog

