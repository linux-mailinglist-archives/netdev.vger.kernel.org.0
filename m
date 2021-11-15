Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198A2451D8A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244391AbhKPAbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345808AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64582C06EDC2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:22 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y8so9800521plg.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cq6IvpouhA6CdLDUxp8Df/cpSEh3QpQotH8ssQAlWko=;
        b=SiQ/Ib+/tAoXV85NlA8oBj1/CuO6GsY4p2OxqIYb9v0XLVQm7TnIRuoFDgUtG62sQD
         sRrFkm5GRPAFU0w6pMyTEunSzzhlg/M/ZflWrpJX3sPNqCE/gDvBOI+Z1mGLdAtL6mqK
         vRzmjU9SAP9z8vq8MpdhsPaFXYtUIFqGwMoS2ysTOST2k8dcoa5HM41esNG18V2s1hOa
         UpyMV4SswUoSqx/qHO6l8s8Lrr2hEb/5hdf/kxuJuJd0gX0pT+eDNN+67NoCM1e/mMUM
         aMrf4A/CLLbN/JasT6JUXTQBdc/zBDOgjgF+zGSxpRlGwWM5OiLB7D9/Eqfa87IJ/zWK
         RfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cq6IvpouhA6CdLDUxp8Df/cpSEh3QpQotH8ssQAlWko=;
        b=RB1OF7yqWFbZGesZoKp/TTGAs0gpsUkOBP3PC4TgFrHA15MT4Tx5qlbYiJEZV3pi0R
         rmAF8/s2u8GsDOTIhEBnUa3xoRbilJhH06J8quyhZpYugbnnYYVUTE+OU7xsOQV8/XrP
         SrYD6GfSXwQQntuZig4rWXgqXeby6A8yOMtDKDXlvVnxCZr4ZRJjGb35LTI0dTxPFwQB
         2xjKN2RCe2QQmRcPbr+TcJzYpSWaSnBpxMnFfzrlp0lPH7tEAM/FDRNDYjdITrIAp9VB
         MhSkJ5506EfiYapuZ3T7v8TAEd5eZFRFHTK1ANPKhypCo/2FlG1GLmdIp7xrq/4cScfL
         YCiw==
X-Gm-Message-State: AOAM533zCruLEmTRJVB051psm6KQ6SRmngE5zOZ8YeN1qcQnb68nquqZ
        2nIPbyVQhK6OV8dN2Loz7sa0vUoR90A=
X-Google-Smtp-Source: ABdhPJzHp+y+9zi+MVrnDP5IwM6N+FwNdUsitHOX7Kp38v2qji0desp94WI2mmq7nTwWwG/8TTOM6A==
X-Received: by 2002:a17:902:c115:b0:142:2441:aa23 with SMTP id 21-20020a170902c11500b001422441aa23mr37072325pli.16.1637003001768;
        Mon, 15 Nov 2021 11:03:21 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 16/20] tcp: avoid indirect calls to sock_rfree
Date:   Mon, 15 Nov 2021 11:02:45 -0800
Message-Id: <20211115190249.3936899-17-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

TCP uses sk_eat_skb() when skbs can be removed from receive queue.
However, the call so skb_orphan() from __kfree_skb() incurs
an indirect call so sock_rfee(), which is more expensive than
a direct call, especially for CONFIG_RETPOLINE=y.

Add tcp_eat_recv_skb() function to make the call before
__kfree_skb().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9175e0d729f5e65b5fa39acadc5bf9de715854ad..4e7011672aa9a04370b7a03b972fe19cd48ea232 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1580,6 +1580,16 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
 		tcp_send_ack(sk);
 }
 
+static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	if (likely(skb->destructor == sock_rfree)) {
+		sock_rfree(skb);
+		skb->destructor = NULL;
+		skb->sk = NULL;
+	}
+	sk_eat_skb(sk, skb);
+}
+
 static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 {
 	struct sk_buff *skb;
@@ -1599,7 +1609,7 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 		 * splitted a fat GRO packet, while we released socket lock
 		 * in skb_splice_bits()
 		 */
-		sk_eat_skb(sk, skb);
+		tcp_eat_recv_skb(sk, skb);
 	}
 	return NULL;
 }
@@ -1665,11 +1675,11 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				continue;
 		}
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
-			sk_eat_skb(sk, skb);
+			tcp_eat_recv_skb(sk, skb);
 			++seq;
 			break;
 		}
-		sk_eat_skb(sk, skb);
+		tcp_eat_recv_skb(sk, skb);
 		if (!desc->count)
 			break;
 		WRITE_ONCE(tp->copied_seq, seq);
@@ -2481,14 +2491,14 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			goto found_fin_ok;
 		if (!(flags & MSG_PEEK))
-			sk_eat_skb(sk, skb);
+			tcp_eat_recv_skb(sk, skb);
 		continue;
 
 found_fin_ok:
 		/* Process the FIN. */
 		WRITE_ONCE(*seq, *seq + 1);
 		if (!(flags & MSG_PEEK))
-			sk_eat_skb(sk, skb);
+			tcp_eat_recv_skb(sk, skb);
 		break;
 	} while (len > 0);
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

