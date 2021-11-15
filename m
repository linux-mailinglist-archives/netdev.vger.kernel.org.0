Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611CD451D90
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345762AbhKPAbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345790AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638D5C0BC9A3
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:06 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n8so15272739plf.4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IeJyargwm9M1G/oIDoLt8+Lyr5Du0x0yvF0DDZ4zfAs=;
        b=BiLYZ4KDbejfNIWtB5BV7Dy8WI3mwPGPw7iBVvuJDySejFXDHLMb/NvKbKbDJSuXhI
         q4Ohz+XmR5P3NApg6gTHfn91QsX0bBH4i7InP/TUjRav8TnMULewsOTJOqFVXOml/OaH
         tQdJN0Xr/s+lfVGYGhMhGPCS9H8IDkdDzGLYLfC+jHlxPLure94NRxnFvqTwfUZjgor5
         0Vw11ntNynt/oSWeKlZ8fkGY0wwHq7kNiUsY969x1FP9wBFGXv1zVpOtGITnPjqMSNT7
         jrZFCFbKC3youoaIXgDbkADbclFj2FUBmRhig/OBNNFnaq+jjie/mYGx0X13C0l6BKY+
         tHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IeJyargwm9M1G/oIDoLt8+Lyr5Du0x0yvF0DDZ4zfAs=;
        b=Bv/zMzWTCy1VIqTGPoprBHTqFmgyflMrP08GEQfUIYjY6hmSIdVBRbC9o5C4zGEP35
         snInkdc8xiMPRmu8UjAPx1FNk7JUvP+urDNAG5hHkD/hbztQoKkO8BOPIMxAIjMURBx4
         Az+2W+2t5gVmbcTMWXYIYKfTNEP8xfrO3YVOhcNfKrWNEOgPOwJT8GXEONy1axk07s/j
         5NPslz5cZFBFhXYBxQi9NrUQcWFpkwq/IhccuDu5VCegX+iHAMmkLu3D7AjUIh5eQXvZ
         wYrjlM9pZ3J6R/YeV7y3Fs+91+Bh1Tmuh/nXw0PnyhZvRP5wMqcEVfM7REQPbcDwaqFX
         90FA==
X-Gm-Message-State: AOAM531LRw+2rGHsCTh+nCJ5yGMoJE2RaRtrjjssF1Ubr2ZCzZUDNJ03
        5F+1u9cIT3VE1L5GNlN4qvA=
X-Google-Smtp-Source: ABdhPJwgnJzjIo8HKmK8f7EvAOlMC8VnMIMoLci6pAcyno10ThUji80ePhMCpK3AsB79D0JfSOjwNA==
X-Received: by 2002:a17:902:f784:b0:141:c9ce:6725 with SMTP id q4-20020a170902f78400b00141c9ce6725mr38174983pln.58.1637002985784;
        Mon, 15 Nov 2021 11:03:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 04/20] net: use sk_is_tcp() in more places
Date:   Mon, 15 Nov 2021 11:02:33 -0800
Message-Id: <20211115190249.3936899-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Move sk_is_tcp() to include/net/sock.h and use it where we can.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skmsg.h | 6 ------
 include/net/sock.h    | 5 +++++
 net/core/skbuff.c     | 6 ++----
 net/core/sock.c       | 6 ++----
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 584d94be9c8b06e43dff0eecfcc25a63a17a652d..18a717fe62eb049758bc1502da97365cf7587ffd 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -507,12 +507,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 	return !!psock->saved_data_ready;
 }
 
-static inline bool sk_is_tcp(const struct sock *sk)
-{
-	return sk->sk_type == SOCK_STREAM &&
-	       sk->sk_protocol == IPPROTO_TCP;
-}
-
 static inline bool sk_is_udp(const struct sock *sk)
 {
 	return sk->sk_type == SOCK_DGRAM &&
diff --git a/include/net/sock.h b/include/net/sock.h
index b32906e1ab55527b5418f203d3de05853863f166..5bdeffdea5ecdb6069d13906bbf872d4479a1ce7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2638,6 +2638,11 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
 			   &skb_shinfo(skb)->tskey);
 }
 
+static inline bool sk_is_tcp(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_STREAM && sk->sk_protocol == IPPROTO_TCP;
+}
+
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ba2f38246f07e5ba5a4f97922b4be33bdb8ad6d6..d57796f38a0b4b0b78c513e6733580f9d4b56dc8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4849,8 +4849,7 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 	serr->header.h4.iif = skb->dev ? skb->dev->ifindex : 0;
 	if (sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID) {
 		serr->ee.ee_data = skb_shinfo(skb)->tskey;
-		if (sk->sk_protocol == IPPROTO_TCP &&
-		    sk->sk_type == SOCK_STREAM)
+		if (sk_is_tcp(sk))
 			serr->ee.ee_data -= sk->sk_tskey;
 	}
 
@@ -4919,8 +4918,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 	if (tsonly) {
 #ifdef CONFIG_INET
 		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
-		    sk->sk_protocol == IPPROTO_TCP &&
-		    sk->sk_type == SOCK_STREAM) {
+		    sk_is_tcp(sk)) {
 			skb = tcp_get_timestamping_opt_stats(sk, orig_skb,
 							     ack_skb);
 			opt_stats = true;
diff --git a/net/core/sock.c b/net/core/sock.c
index 8f2b2f2c0e7b1decdb4a5c8d86327ed7caa62c99..0be8e43f44b9e68678f4e20c3a86324ba1bfe03e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -872,8 +872,7 @@ int sock_set_timestamping(struct sock *sk, int optname,
 
 	if (val & SOF_TIMESTAMPING_OPT_ID &&
 	    !(sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)) {
-		if (sk->sk_protocol == IPPROTO_TCP &&
-		    sk->sk_type == SOCK_STREAM) {
+		if (sk_is_tcp(sk)) {
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
@@ -1370,8 +1369,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	case SO_ZEROCOPY:
 		if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
-			if (!((sk->sk_type == SOCK_STREAM &&
-			       sk->sk_protocol == IPPROTO_TCP) ||
+			if (!(sk_is_tcp(sk) ||
 			      (sk->sk_type == SOCK_DGRAM &&
 			       sk->sk_protocol == IPPROTO_UDP)))
 				ret = -ENOTSUPP;
-- 
2.34.0.rc1.387.gb447b232ab-goog

