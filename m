Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36D741B99A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242686AbhI1Vsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242729AbhI1Vsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 17:48:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B98C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q8-20020a056902150800b005b640f67812so649166ybu.8
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8m0XVgut/HJbKZ+90MngCURWWhcQtIfU/0941XQ2oPg=;
        b=DruefNoCb6AKgp3SJRBM0hnk3lvTkECdqXzXZ7UFgbHowvRrgljpuz7mBGPDS915WG
         tCtKgHKimhQ+Pmw/+iES0d2sRQPBlsOnWo5MNwH1SZvft6m9EGBxshNaj/l1Be3fMDBG
         aQLPrR0UW9O4D3VCQ4tf6tJYz8lEM/JIoJ56HwsTAyNLfgu8ov6wJsnubmwQutjAxGvf
         Pgk8FxHz/HfsgurKRLR4DNQY0ZII79Oqn7wzi8rvvxOyF7BotxsTdfLtk5HbKQbsx6d1
         KJGecZiplLJI7FrE5RbAM7p+cDWxGuAznqS70PXPaB7t+ZTIAmXXrVgRysmHqbbuYkcq
         ZrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8m0XVgut/HJbKZ+90MngCURWWhcQtIfU/0941XQ2oPg=;
        b=Y3Nmpswmcbbi0AOXhmrWhO7QbddmeoxbLQDRiDMRj/ZyoO2VJMWEtH6Ed0Twx8YcD6
         dOuY12nC3bFuHKZCwi1pb1yyBsTzZSQejpbBOwBKgkQzvO2ngePb6YndjYB+yaBPdgC7
         DVczq2AqfsY/ig93+8tnQ6L8VmBlipZKhYxlNHScpWo571plBKJpIuoVJxfATmH19ZWi
         0siUoiqr7VqYrICOO+EVgD2mXQdj3fv4/QXJKu2A32p8kXVXl/lKTTGe6L3CrwPJpdrh
         jiMJbYMzduFJibUNrt4MrNxOES7efVmd1Z7aehaFcJqNKilFigIuMrd2TRr83za133n1
         33Mg==
X-Gm-Message-State: AOAM5312QvnqL1VuaJOlnWt1Jq+K4PdX6fOaQbSyisF2q66zkcVEn45h
        vvUpeOjHr80J8WbiCIfO8FrEklrKSpo=
X-Google-Smtp-Source: ABdhPJyWjqpLYszv+in+YOlf3aeh28anjdsEE1OKHJ6TKhPBFy7lDpK5IUk7QSis6RePwmXR6AJnasBkbGY=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:5d42:81b8:4b7f:efe2])
 (user=weiwan job=sendgmr) by 2002:a5b:f03:: with SMTP id x3mr9746554ybr.546.1632865610437;
 Tue, 28 Sep 2021 14:46:50 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:46:42 -0700
In-Reply-To: <20210928214643.3300692-1-weiwan@google.com>
Message-Id: <20210928214643.3300692-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210928214643.3300692-1-weiwan@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 net-next 2/3] tcp: adjust sndbuf according to sk_reserved_mem
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "'David S . Miller'" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user sets SO_RESERVE_MEM socket option, in order to fully utilize the
reserved memory in memory pressure state on the tx path, we modify the
logic in sk_stream_moderate_sndbuf() to set sk_sndbuf according to
available reserved memory, instead of MIN_SOCK_SNDBUF, and adjust it
when new data is acked.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com> 
---
 include/net/sock.h   |  1 +
 net/ipv4/tcp_input.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 0feb37c7f534..df3b7a45a57e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2377,6 +2377,7 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 		return;
 
 	val = min(sk->sk_sndbuf, sk->sk_wmem_queued >> 1);
+	val = max_t(u32, val, sk_unused_reserved_mem(sk));
 
 	WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 53675e284841..06020395cc8d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5380,7 +5380,7 @@ static int tcp_prune_queue(struct sock *sk)
 	return -1;
 }
 
-static bool tcp_should_expand_sndbuf(const struct sock *sk)
+static bool tcp_should_expand_sndbuf(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
@@ -5391,8 +5391,18 @@ static bool tcp_should_expand_sndbuf(const struct sock *sk)
 		return false;
 
 	/* If we are under global TCP memory pressure, do not expand.  */
-	if (tcp_under_memory_pressure(sk))
+	if (tcp_under_memory_pressure(sk)) {
+		int unused_mem = sk_unused_reserved_mem(sk);
+
+		/* Adjust sndbuf according to reserved mem. But make sure
+		 * it never goes below SOCK_MIN_SNDBUF.
+		 * See sk_stream_moderate_sndbuf() for more details.
+		 */
+		if (unused_mem > SOCK_MIN_SNDBUF)
+			WRITE_ONCE(sk->sk_sndbuf, unused_mem);
+
 		return false;
+	}
 
 	/* If we are under soft global TCP memory pressure, do not expand.  */
 	if (sk_memory_allocated(sk) >= sk_prot_mem_limits(sk, 0))
-- 
2.33.0.685.g46640cef36-goog

