Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201144514B0
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348888AbhKOUMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345807AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22AFC06EDC1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:20 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y7so15380592plp.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cE2uznwFrliA3ejhifpoOM8+JmuLRcxyYcIVXX2zOq8=;
        b=hUJ8O3orunQ3G0Dvlo7UYIp0/XV4rL0LosDFUvn3E5utWaIxCkAEy6mC/0Dcjq86JK
         xj/O13Go7TFS2saga+uIKt7vCpH9MYrt+O5vcr4G3AHOKifnf5y1uM2xx0aZOGxxenED
         TDg+ML3DY0slvy+qs5rDVqZJoQpsBYUWuPGhUIzLZ7Oj63qQkKKtuq64nNog+x0B3u8+
         UBruytinXo+Xf15XStrAiyTAYD7HHKvpeFu0PZyOHGpIQkF2mP1hGeTZqQgCOsTrByBq
         7qKYe9LbF/XRHAcc1+MnEREkDpyC4DouAFOZyXEk6wq9IqhPMEBzKFiqr4WuaeiehmOx
         Zn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cE2uznwFrliA3ejhifpoOM8+JmuLRcxyYcIVXX2zOq8=;
        b=5V++DEXUxWYDTOGrtAyKYgl0fJKLoU+Nx9eISTRNubu8KP859I+q3QMy5/afppHX+e
         fTdXHWL5gggqnKOsp5pXUdfWJKXZvkghZpYLAstda7asSu0hdZwGrlKz6u85wqodvjpY
         gHcl03cjlQTNs3bT4imSS0MgkwSPkPgsR2nT4dZiPo4xZAqB1MWq31NEvRi8SXZOPAs2
         XEJxT43Qm6cYWuS+xJVbUYJPzXHUWsUZbNPMf/lrPbU9iONmV45244NHTjlwAmQ0yQQ2
         /lQRpwWyTokMqnNYi9WkOta9lutwqycqSgWf+2fK0PjPwUXEZ9HQY7AD/1LV6cy/dEDK
         UH2g==
X-Gm-Message-State: AOAM5327auYnwHly2NndxwL69PF8DUzgcPo4q5R7w+dhidYdLagkH8zq
        mtDggZcdcDn9WW1nXiHEHMY=
X-Google-Smtp-Source: ABdhPJxQg/DxPh000MK9J8csDabxIHZx/SSuBdi2BAZizn2Wx7u8STlYPctXBAuQfO7w8ok4LH0wMQ==
X-Received: by 2002:a17:903:285:b0:142:7a83:6dd2 with SMTP id j5-20020a170903028500b001427a836dd2mr37381870plr.59.1637003000547;
        Mon, 15 Nov 2021 11:03:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:20 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 15/20] tcp: tp->urg_data is unlikely to be set
Date:   Mon, 15 Nov 2021 11:02:44 -0800
Message-Id: <20211115190249.3936899-16-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use some unlikely() hints in the fast path.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c       | 10 +++++-----
 net/ipv4/tcp_input.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 313cf648c349a24ab7a04729180ec9b76b2f6aa2..9175e0d729f5e65b5fa39acadc5bf9de715854ad 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -547,7 +547,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		int target = sock_rcvlowat(sk, 0, INT_MAX);
 		u16 urg_data = READ_ONCE(tp->urg_data);
 
-		if (urg_data &&
+		if (unlikely(urg_data) &&
 		    READ_ONCE(tp->urg_seq) == READ_ONCE(tp->copied_seq) &&
 		    !sock_flag(sk, SOCK_URGINLINE))
 			target++;
@@ -1633,7 +1633,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
 			len = skb->len - offset;
 			/* Stop reading if we hit a patch of urgent data */
-			if (tp->urg_data) {
+			if (unlikely(tp->urg_data)) {
 				u32 urg_offset = tp->urg_seq - seq;
 				if (urg_offset < len)
 					len = urg_offset;
@@ -2326,7 +2326,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 		u32 offset;
 
 		/* Are we at urgent data? Stop if we have read anything or have SIGURG pending. */
-		if (tp->urg_data && tp->urg_seq == *seq) {
+		if (unlikely(tp->urg_data) && tp->urg_seq == *seq) {
 			if (copied)
 				break;
 			if (signal_pending(current)) {
@@ -2431,7 +2431,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 			used = len;
 
 		/* Do we have urgent data here? */
-		if (tp->urg_data) {
+		if (unlikely(tp->urg_data)) {
 			u32 urg_offset = tp->urg_seq - *seq;
 			if (urg_offset < used) {
 				if (!urg_offset) {
@@ -2465,7 +2465,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 		tcp_rcv_space_adjust(sk);
 
 skip_copy:
-		if (tp->urg_data && after(tp->copied_seq, tp->urg_seq)) {
+		if (unlikely(tp->urg_data) && after(tp->copied_seq, tp->urg_seq)) {
 			WRITE_ONCE(tp->urg_data, 0);
 			tcp_fast_path_check(sk);
 		}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5ee07a337652696bdebb1117334ff39d88fd0276..3658b9c3dd2b6cd4610603c78509c9af25ddcdbc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5604,11 +5604,11 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Check if we get a new urgent pointer - normally not. */
-	if (th->urg)
+	if (unlikely(th->urg))
 		tcp_check_urg(sk, th);
 
 	/* Do we wait for any urgent data? - normally not... */
-	if (tp->urg_data == TCP_URG_NOTYET) {
+	if (unlikely(tp->urg_data == TCP_URG_NOTYET)) {
 		u32 ptr = tp->urg_seq - ntohl(th->seq) + (th->doff * 4) -
 			  th->syn;
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

