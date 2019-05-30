Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A333047A
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfE3WB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:01:26 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39918 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfE3WB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:01:26 -0400
Received: by mail-qk1-f193.google.com with SMTP id i125so4965553qkd.6
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 15:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kczv21GTIjnuH9cr7KIc3FXXdznEntZMyHldmEAM87o=;
        b=Vag7DIgjUo8CJPCNvUbRUg2t6sPHoIQc8Os0NtVrLf4XezgRwlaXS0AhX+cNanqRca
         9BKO+q6VjXhOn7Ot/3aOsCrvxX90HQ1HNml3HUIW7oGBQP0mUBIvjXHlyINsnqDpH2K1
         Ew0ZaebtaagFpgaJnGdQ5+W0nfTK4G8yqcEVfA/hpAZCR9sLu5rddu9OJqVpG/tBCM3L
         xwub8bnbANnUFCoreEYVKWI0M3Qb9MlcyRqG96x4YZXyHiRZiTnMS6hYIXzPf1cm+oQE
         iHlzUgUhCDPWbogPAR4OJfl2gexkK+Wr11d0Ja4yAC/nCn57WzAskfRTjyJEod/JFYpa
         8xEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kczv21GTIjnuH9cr7KIc3FXXdznEntZMyHldmEAM87o=;
        b=HPB8QQPTAtizGbS5AQ4CnodN9dVXcJBUkP5hEOOr0dY0TKrw72EsBONlS/MuhxZzKb
         M9isFBjZ/HDWJC1/2w5R69cIkwIsFX+siC9PCjcv/4kpqM6mOqpmRX6Ijd2K6QuLLugj
         NRZmLOKBil9kKU48Tec2DFMWG8Gks9QyldDfZ2yHVn+BcQEPltri025mToDbfhBokj4M
         nc2mTLfHz/qns9daA8r+rfeUwO3lbOfW70hYDGNlWjkocwtG/0V4hh6z3tRiua4JbQlI
         S+fKTAJE3A+r2oteDiORRhbnMYCaNnC2h+A71uhUVQ/041sAfTSg0uj7Aoh5C/879lnk
         xaGg==
X-Gm-Message-State: APjAAAWBsYv//7JJeWvx5soadnKVIi67cmHfCqeI6KsEvKwBFrx+/P/q
        K7kF2rZACwxRS/R4CUYYzLummNBX
X-Google-Smtp-Source: APXvYqyyYn0PaiW7Pek9aFCsPQbZ/J/YRNon/KDctk4FfBRwdiaclf7mL1ViIDGK4qnGD2wm6kh8tQ==
X-Received: by 2002:a37:6895:: with SMTP id d143mr3742151qkc.94.1559253684879;
        Thu, 30 May 2019 15:01:24 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id m5sm3037044qke.25.2019.05.30.15.01.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 15:01:23 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net v2] net: correct zerocopy refcnt with udp MSG_MORE
Date:   Thu, 30 May 2019 18:01:21 -0400
Message-Id: <20190530220121.128798-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

TCP zerocopy takes a uarg reference for every skb, plus one for the
tcp_sendmsg_locked datapath temporarily, to avoid reaching refcnt zero
as it builds, sends and frees skbs inside its inner loop.

UDP and RAW zerocopy do not send inside the inner loop so do not need
the extra sock_zerocopy_get + sock_zerocopy_put pair. Commit
52900d22288ed ("udp: elide zerocopy operation in hot path") introduced
extra_uref to pass the initial reference taken in sock_zerocopy_alloc
to the first generated skb.

But, sock_zerocopy_realloc takes this extra reference at the start of
every call. With MSG_MORE, no new skb may be generated to attach the
extra_uref to, so refcnt is incorrectly 2 with only one skb.

Do not take the extra ref if uarg && !tcp, which implies MSG_MORE.
Update extra_uref accordingly.

This conditional assignment triggers a false positive may be used
uninitialized warning, so have to initialize extra_uref at define.

Changes v1->v2: fix typo in Fixes SHA1

Fixes: 52900d22288e7 ("udp: elide zerocopy operation in hot path")
Reported-by: syzbot <syzkaller@googlegroups.com>
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c     | 6 +++++-
 net/ipv4/ip_output.c  | 4 ++--
 net/ipv6/ip6_output.c | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e89be62826937..eaad23f9c7b5b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1036,7 +1036,11 @@ struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 			uarg->len++;
 			uarg->bytelen = bytelen;
 			atomic_set(&sk->sk_zckey, ++next);
-			sock_zerocopy_get(uarg);
+
+			/* no extra ref when appending to datagram (MSG_MORE) */
+			if (sk->sk_type == SOCK_STREAM)
+				sock_zerocopy_get(uarg);
+
 			return uarg;
 		}
 	}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index bfd0ca554977a..8c9189a41b136 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -878,7 +878,7 @@ static int __ip_append_data(struct sock *sk,
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref;
+	bool paged, extra_uref = false;
 	u32 tskey = 0;
 
 	skb = skb_peek_tail(queue);
@@ -918,7 +918,7 @@ static int __ip_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = true;
+		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index adef2236abe2e..f9e43323e6673 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1275,7 +1275,7 @@ static int __ip6_append_data(struct sock *sk,
 	int csummode = CHECKSUM_NONE;
 	unsigned int maxnonfragsize, headersize;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref;
+	bool paged, extra_uref = false;
 
 	skb = skb_peek_tail(queue);
 	if (!skb) {
@@ -1344,7 +1344,7 @@ static int __ip6_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = true;
+		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
-- 
2.22.0.rc1.257.g3120a18244-goog

