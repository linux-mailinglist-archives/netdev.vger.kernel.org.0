Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6747621DF13
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbgGMRrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730305AbgGMRrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:03 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A1FC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:03 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id k15so9580815lfc.4
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDSEEbaluBZs+0tECJKbkPZc+3U6GYzy2UWo7TMx4PQ=;
        b=LXhwG2Ana8/kJY+LED0FuwqzhBaLI5+UE19TVBMjlpjp33lylKcgcw7e1tCm3DQS3R
         XaMWDl0XAvahKKP/DUAKFxb/Ez/cIjRpkDBBXtcYC21XlLRnPB7fJZS42HNNQEgXaf/q
         rPyc5a813qGJ6VEPTkfrBdrR83VMXwJb0pxzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDSEEbaluBZs+0tECJKbkPZc+3U6GYzy2UWo7TMx4PQ=;
        b=gAHG7brgbEOBPqnxBqKi/jaxwyZU+nV4QL/xHVYUlVEVMFT0HiRkemjkZ7bcDFYln1
         HZm59Py5sBYxi4eUfzOPiC5MNgqFkmmF1NXnNkSiEq4DmLhV3ei63UVgobAauAiVx82G
         f47p2EbxkA0u+VjCtM9jtffKuSxpsIcUhxfFfDgnlJmkoUB7M4heylz0vLODCcHFIgWY
         rH/kifjNwHO/ns16uJ7IpkqpqZ8PiFDresQtn7LcDuHbGZP6WmWOyoFsSDU2YqnKDHlu
         8sn0V5s36eaAJVxmSSXis68ppwXcyspEGVhxztd2e1wzLv7qJG8mcIj3fiLojLxaZTOO
         u4NQ==
X-Gm-Message-State: AOAM5322hRTkRW9HqMd/mVYB/un3w0+/Sd0UffAaZ6BYfRr1UhwJ8bBX
        FcafDUBH7fKiQaLxPuL5+sP5IA==
X-Google-Smtp-Source: ABdhPJytKuI10VUN5tx6g67NHROdnxuFoPpXxDYHGu+GqkdsG0zOStJQNKfZ1eHGJXHGQEit/WlQ5w==
X-Received: by 2002:a19:c886:: with SMTP id y128mr170168lff.98.1594662421680;
        Mon, 13 Jul 2020 10:47:01 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b11sm4736057lfa.50.2020.07.13.10.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:01 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v4 03/16] inet: Extract helper for selecting socket from reuseport group
Date:   Mon, 13 Jul 2020 19:46:41 +0200
Message-Id: <20200713174654.642628-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for calling into reuseport from __inet_lookup_listener as well.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/inet_hashtables.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2bbaaf0c7176..ab64834837c8 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -246,6 +246,21 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
+static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
+					    struct sk_buff *skb, int doff,
+					    __be32 saddr, __be16 sport,
+					    __be32 daddr, unsigned short hnum)
+{
+	struct sock *reuse_sk = NULL;
+	u32 phash;
+
+	if (sk->sk_reuseport) {
+		phash = inet_ehashfn(net, daddr, hnum, saddr, sport);
+		reuse_sk = reuseport_select_sock(sk, phash, skb, doff);
+	}
+	return reuse_sk;
+}
+
 /*
  * Here are some nice properties to exploit here. The BSD API
  * does not allow a listening sock to specify the remote port nor the
@@ -265,21 +280,17 @@ static struct sock *inet_lhash2_lookup(struct net *net,
 	struct inet_connection_sock *icsk;
 	struct sock *sk, *result = NULL;
 	int score, hiscore = 0;
-	u32 phash = 0;
 
 	inet_lhash2_for_each_icsk_rcu(icsk, &ilb2->head) {
 		sk = (struct sock *)icsk;
 		score = compute_score(sk, net, hnum, daddr,
 				      dif, sdif, exact_dif);
 		if (score > hiscore) {
-			if (sk->sk_reuseport) {
-				phash = inet_ehashfn(net, daddr, hnum,
-						     saddr, sport);
-				result = reuseport_select_sock(sk, phash,
-							       skb, doff);
-				if (result)
-					return result;
-			}
+			result = lookup_reuseport(net, sk, skb, doff,
+						  saddr, sport, daddr, hnum);
+			if (result)
+				return result;
+
 			result = sk;
 			hiscore = score;
 		}
-- 
2.25.4

