Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACF641B99B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbhI1Vsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242929AbhI1Vsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 17:48:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62594C061753
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q8-20020a056902150800b005b640f67812so649291ybu.8
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CvGJ4Z6Bljun4/eGYY7fseGY0GSY3h9OiPiupWWA5tM=;
        b=Lze0PfYSKoHzEG5gYm69AnCJ3QP3NVt3LpHVCa4RCR3dMtiWBjwf3IfyxCDEtPmCS7
         QWQDaraGXxbClPJIVDR/SYrtLwULRVmEJPm7bDPuTs7DGs94f0wunIccg5wrPuy2N3s9
         X0IbcEoDTlN7gnDTm4vQoze7yAvjKDWhTUOzffjVtNrobnJGlSMyho3Y1IsRe/hZQkQK
         FQL/Rnwtdwk6a0xNgiCgTOg/ge4nQ1m6B1GBkSiy7RakrlPZcN1TnG+udIG+0d6Dl0rt
         ClEMtnUfzLJUYKl86TwZNCb5BoZWyMY2lzjyc3VrsxFC2a20qh3X+P9EixaEmog0vC0y
         rojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CvGJ4Z6Bljun4/eGYY7fseGY0GSY3h9OiPiupWWA5tM=;
        b=LmwS2rg5MM/zvFPsbQwwzf96TUJUfXzszjmT5DckYdy2+aj1RfCFwsZBMANsuTGuwD
         3xeDjp4mjoz6WmR9xtV9ib0rRCtD64vb3g2w/16BpG19ZSR/iEaiKs6VmwQeWZcKVqbf
         qf75Wi1ZGi2fBpE9rAb1Ym8MpFBMShaCAHoBxikheKdBpxYePX/vaq98Ro+61256SbgI
         4L3vzUcB+dJZ2eB0aJCw2dNDii+Y4zVhAd121aNXU0XGEkW4HeBn5Syjoz3kbqqnIEMb
         t9DIUXNb/el0WFmdTgyLWyNks/Mre04EU/NM4kpilI0c+XWjD0IRLP9eLXyc6RGFLs6k
         oCBw==
X-Gm-Message-State: AOAM533ZT2+MCN9gpGWlfuoB6VnzjAM5nW4pC+Oq9bsYUz+PVNdewIPo
        HgveROodUpg8GOT2KJcc2mBKpvyNg90=
X-Google-Smtp-Source: ABdhPJxI61vdVZfTksJ4YAXnqjd6cddULBil+rmmgVNujyBhFt/DE0YXfmyLqzv9UK1LGmDiEDtzA8zAkrc=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:5d42:81b8:4b7f:efe2])
 (user=weiwan job=sendgmr) by 2002:a05:6902:1141:: with SMTP id
 p1mr10035886ybu.0.1632865612675; Tue, 28 Sep 2021 14:46:52 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:46:43 -0700
In-Reply-To: <20210928214643.3300692-1-weiwan@google.com>
Message-Id: <20210928214643.3300692-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210928214643.3300692-1-weiwan@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 net-next 3/3] tcp: adjust rcv_ssthresh according to sk_reserved_mem
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "'David S . Miller'" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user sets SO_RESERVE_MEM socket option, in order to utilize the
reserved memory when in memory pressure state, we adjust rcv_ssthresh
according to the available reserved memory for the socket, instead of
using 4 * advmss always.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com> 
---
 include/net/tcp.h     | 11 +++++++++++
 net/ipv4/tcp_input.c  | 12 ++++++++++--
 net/ipv4/tcp_output.c |  3 +--
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 32cf6c01f403..4c2898ac6569 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1421,6 +1421,17 @@ static inline int tcp_full_space(const struct sock *sk)
 	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
+static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
+{
+	int unused_mem = sk_unused_reserved_mem(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);
+	if (unused_mem)
+		tp->rcv_ssthresh = max_t(u32, tp->rcv_ssthresh,
+					 tcp_win_from_space(sk, unused_mem));
+}
+
 void tcp_cleanup_rbuf(struct sock *sk, int copied);
 
 /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 06020395cc8d..246ab7b5e857 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -500,8 +500,11 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
 
 	room = min_t(int, tp->window_clamp, tcp_space(sk)) - tp->rcv_ssthresh;
 
+	if (room <= 0)
+		return;
+
 	/* Check #1 */
-	if (room > 0 && !tcp_under_memory_pressure(sk)) {
+	if (!tcp_under_memory_pressure(sk)) {
 		unsigned int truesize = truesize_adjust(adjust, skb);
 		int incr;
 
@@ -518,6 +521,11 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
 			tp->rcv_ssthresh += min(room, incr);
 			inet_csk(sk)->icsk_ack.quick |= 1;
 		}
+	} else {
+		/* Under pressure:
+		 * Adjust rcv_ssthresh according to reserved mem
+		 */
+		tcp_adjust_rcv_ssthresh(sk);
 	}
 }
 
@@ -5345,7 +5353,7 @@ static int tcp_prune_queue(struct sock *sk)
 	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf)
 		tcp_clamp_window(sk);
 	else if (tcp_under_memory_pressure(sk))
-		tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);
+		tcp_adjust_rcv_ssthresh(sk);
 
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
 		return 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fdc39b4fbbfa..3a01e5593a17 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2967,8 +2967,7 @@ u32 __tcp_select_window(struct sock *sk)
 		icsk->icsk_ack.quick = 0;
 
 		if (tcp_under_memory_pressure(sk))
-			tp->rcv_ssthresh = min(tp->rcv_ssthresh,
-					       4U * tp->advmss);
+			tcp_adjust_rcv_ssthresh(sk);
 
 		/* free_space might become our new window, make sure we don't
 		 * increase it due to wscale.
-- 
2.33.0.685.g46640cef36-goog

