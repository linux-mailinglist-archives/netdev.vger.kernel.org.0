Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8158451D96
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348912AbhKPAbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345771AbhKOT3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:16 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443CCC0BC999
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so631759pjb.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9BWwpkrYxVGEuYLSkV9sKoqSnqttzgUOQ4sFuU/ZB1M=;
        b=e/p9faxlfzCt/RtOKXa4e6KuSFlM9508ZLgKOGpLDpC3SV16vBEhhrtgMti5COjZCH
         BL3RiMbj8wTVgZDoTFFzr9amYUGMj6oqbHhxolgclhsbmOtw+K/osgabUepMYb6EvelH
         KajIqwiJd632+oh1xuYg6DsqB8UOD2j6U+Ohdw3agCD24NWhncG7mmhrrs6bfgrP8yf+
         ZX9Qqk8lYZBHwjKf1sBQ/QQeICsC9NH/zQFodsHP1whhpPLo0zR63l5OS11zTcnn9Dyu
         7WqszppYzPtj3saI2jnzJaVaSkMgqnOAefwrVX59t01pBZDM6s3HOchbh93rdL2A/HJd
         fzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9BWwpkrYxVGEuYLSkV9sKoqSnqttzgUOQ4sFuU/ZB1M=;
        b=nl65b8POZrfQCA++8+TJPxweq2b+c7YkC3boyzFa/AwRYh6x2M+huGiwNw122M/df5
         ViqGjF6J7U7jJi0L4IFmtxUkfMplLm238dFYcGUhHUC2f7e29GvpASiodN3hTDfqB80G
         ohhU9yqbJVBY0jTNBt3BYCW72MrLti+/j09D/d5vT5dd84BvdU0XkUqzNsj5jWAxFmRt
         xSbVJbJLwxqBzQHvE7eEngRNVvixazzyplvXERjfxbUBO2hiJ9KPHScHGFZ8yDsy5qiN
         KGfOmQ7F1CyF2BaCA//FGG9FZGTVSN8nV8vAXYTlPnvjZtUuDEGS129PuGGa5j1EfUMb
         vtgQ==
X-Gm-Message-State: AOAM5317TtSqsvuWUE/8tPUDZOpAjAfVY+XSDCsASR5uF6YJitO7oBTI
        B6WXqb9GqOjHfgnhtOhYI8kbiOEVjPw=
X-Google-Smtp-Source: ABdhPJyDi+W+EK7J7x+xqUjcnqZiv4+GoRUBDskqOdHlRsAIowUL39grX3u3TpyCs8PCXl7kE+Xxaw==
X-Received: by 2002:a17:902:b28a:b0:142:3e17:38d8 with SMTP id u10-20020a170902b28a00b001423e1738d8mr38367886plr.56.1637002979742;
        Mon, 15 Nov 2021 11:02:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:02:59 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 01/20] tcp: minor optimization in tcp_add_backlog()
Date:   Mon, 15 Nov 2021 11:02:30 -0800
Message-Id: <20211115190249.3936899-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If packet is going to be coalesced, sk_sndbuf/sk_rcvbuf values
are not used. Defer their access to the point we need them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 13d868c43284584ee0c58ddfd411bb52c8b0c830..82a9e1b75405f1488d6bc5d56c11f9bc597ddb07 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1800,8 +1800,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
-	u32 tail_gso_size, tail_gso_segs;
+	u32 limit, tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1909,7 +1908,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit += 64*1024;
+	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.34.0.rc1.387.gb447b232ab-goog

