Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E731C439C05
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhJYQu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbhJYQuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:54 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF03C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:31 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t21so8345359plr.6
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JjKcZRwf7Vlbxnn6gpdZiVEu3+XDIiSkdFofSruGkuo=;
        b=bfG7JqsYhMzVUblDYT+noDyg4q0IoOW1EIKVF9tfPGSRFTCEJNFqJZ5GmMNzFjEMEY
         mcYLHmrQvxYet9NkCaHx2NUvnSPDPdwvylf5sHtx9S1uUwPutG4zRU5XWjIEwO6cSgfL
         PtoJV+BQieJsHxrqFOvbXNPEdDE5CB7U+GDEOKYhTEBo9NKgyL3p4p+4Y8ItmdayEmOA
         Vx0xYVUcgWp2oXTSPm54IrLgoAoaUzk8zhzzayhedfDzf4UI3nqKoSD+PtBmDhL+nqse
         DLhk+cKiDybT7b1b03BW2oP0tVrZ2wIBRj6QdR9f+Gf2ITaePwhEUTgKorl2k7s7Stkh
         EbWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JjKcZRwf7Vlbxnn6gpdZiVEu3+XDIiSkdFofSruGkuo=;
        b=cCgFLJccyiKr4UeiMuIbxZ+0Z24uyAJyspKYDlFXh3FmBIOCcBKUAjNQIvvXYJH8uv
         LOECgg9FLEm5B9eX830HWjt9Wsl7BkeztvpV7TfFQtmOk8D59b0Tz/qMmY+e9IVYJOaa
         4dq5GSz/MIyQBX74PLKJqutyASECEAUi/nx+rdG2l68XxWgZxcqlrQMSxLsZ+CX/I3If
         N3/JrQwtqHr+hGmnaZ2VLQCP+y6813TnXldExa/VNPxc9K/ctUY74al3m8xXsUea+jN9
         mAa8nmaxH6caXAD1WYQIWWkoVzHhaUEx2/7wFxDCNg0Bki63ByNm58W38bg/Bf7ubTb2
         fOVg==
X-Gm-Message-State: AOAM533E7N0CrIglMHkoZQxL++4whJK2MdYReaRc2VFHDISfoIoF6ay6
        XFVddWy4lIlcALFoBrgfgyI=
X-Google-Smtp-Source: ABdhPJzOGSj0nYtuArg0Jf50Swxf70SA+/gx5SgiRU93j9ADkBX6XBewk8/qNMIs69+UCnOJiJfV4Q==
X-Received: by 2002:a17:902:dac5:b0:140:3b56:c7e4 with SMTP id q5-20020a170902dac500b001403b56c7e4mr12823798plx.78.1635180511237;
        Mon, 25 Oct 2021 09:48:31 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:30 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 02/10] ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
Date:   Mon, 25 Oct 2021 09:48:17 -0700
Message-Id: <20211025164825.259415-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Increase cache locality by moving rx_dst_coookie next to sk->sk_rx_dst

This removes one or two cache line misses in IPv6 early demux (TCP/UDP)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/linux/ipv6.h | 1 -
 include/net/sock.h   | 2 ++
 net/ipv6/tcp_ipv6.c  | 6 +++---
 net/ipv6/udp.c       | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ef4a69865737cee82a72c35f3421a535b607c7a6..c383630d3f0658908eac65c030daf97b0a0d0c7c 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -282,7 +282,6 @@ struct ipv6_pinfo {
 	__be32			rcv_flowinfo;
 
 	__u32			dst_cookie;
-	__u32			rx_dst_cookie;
 
 	struct ipv6_mc_socklist	__rcu *ipv6_mc_list;
 	struct ipv6_ac_socklist	*ipv6_ac_list;
diff --git a/include/net/sock.h b/include/net/sock.h
index 0bfb3f138bdab01bd97498e1126d111743000c8c..99c4194cb61add848e3a35db0f952c4193f5ea1f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -260,6 +260,7 @@ struct bpf_local_storage;
   *	@sk_wq: sock wait queue and async head
   *	@sk_rx_dst: receive input route used by early demux
   *	@sk_rx_dst_ifindex: ifindex for @sk_rx_dst
+  *	@sk_rx_dst_cookie: cookie for @sk_rx_dst
   *	@sk_dst_cache: destination cache
   *	@sk_dst_pending_confirm: need to confirm neighbour
   *	@sk_policy: flow policy
@@ -432,6 +433,7 @@ struct sock {
 #endif
 	struct dst_entry	*sk_rx_dst;
 	int			sk_rx_dst_ifindex;
+	u32			sk_rx_dst_cookie;
 
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3e8669b6d636c2971f2afc0abf0f2ef51ca6e2d4..50d9578e945bd2965247a46bc6d8b1adeb21d2f4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -109,7 +109,7 @@ static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 
 		sk->sk_rx_dst = dst;
 		sk->sk_rx_dst_ifindex = skb->skb_iif;
-		tcp_inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
+		sk->sk_rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
 
@@ -1511,7 +1511,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (dst) {
 			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    INDIRECT_CALL_1(dst->ops->check, ip6_dst_check,
-					    dst, np->rx_dst_cookie) == NULL) {
+					    dst, sk->sk_rx_dst_cookie) == NULL) {
 				dst_release(dst);
 				sk->sk_rx_dst = NULL;
 			}
@@ -1872,7 +1872,7 @@ INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
 			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
 
 			if (dst)
-				dst = dst_check(dst, tcp_inet6_sk(sk)->rx_dst_cookie);
+				dst = dst_check(dst, sk->sk_rx_dst_cookie);
 			if (dst &&
 			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8d785232b4796b7cafe14a35dedcbb0aaa2c37c2..14a94cddcf0bcf63d8351c66b94a08770694a9c8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -884,7 +884,7 @@ static void udp6_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst)
 	if (udp_sk_rx_dst_set(sk, dst)) {
 		const struct rt6_info *rt = (const struct rt6_info *)dst;
 
-		inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
+		sk->sk_rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
 
@@ -1073,7 +1073,7 @@ INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 	dst = READ_ONCE(sk->sk_rx_dst);
 
 	if (dst)
-		dst = dst_check(dst, inet6_sk(sk)->rx_dst_cookie);
+		dst = dst_check(dst, sk->sk_rx_dst_cookie);
 	if (dst) {
 		/* set noref for now.
 		 * any place which wants to hold dst has to call
-- 
2.33.0.1079.g6e70778dc9-goog

