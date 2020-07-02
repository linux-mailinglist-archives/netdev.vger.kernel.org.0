Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34FF211FBE
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgGBJY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgGBJYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:25 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01C1C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:24 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg28so22868755edb.3
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDSEEbaluBZs+0tECJKbkPZc+3U6GYzy2UWo7TMx4PQ=;
        b=jRUrvkjDXU5ZEA1U+1wuvOSAdl0vzPuA65FacbXLk3TLISnEqhNQsmFyud2i5YVpGN
         SnERLVO00OjxI0zfXXlyXhIxT0tDLl59sOT09sasW5ttBW4etZonBfb8xtxfarRb5qNM
         X2qTHAmi7MrPLrtg7PqRnWccWwlquZeejYjFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDSEEbaluBZs+0tECJKbkPZc+3U6GYzy2UWo7TMx4PQ=;
        b=Iw/ypR0aIKielCwhxkVhA6LGa4Rf5HAczxhAp4TDi0wB2/XecreOnWAJVo1tnkoROh
         3a41tl4sjofE9/mGYzuEvpUCQoNG0hH1btnqn8xv14WIykDWmm/lO3IoJvoYf6UtTRs3
         wMviY/xCTLmx+ugMZNvNYvSkJPL9U8FP4rZUNb3OXrmpMyYM9oHHcd6YOC8XcAzsBezz
         gXt9Qs1GVY/39GkHxqp/uHop2QD1wr5rFBm0EnY4mwdcJ/Nvr08+iyag2peohk1Fo2q2
         99mnxb2XkVWtnj3gjaeaCjZEGoH1qy5ry3TVpxTFVMCz71j/ha04k3RiOzIqf66cTI/h
         VF/w==
X-Gm-Message-State: AOAM5327xfEvWTNWgTzdkUWPPK5mBZV7zW0lwTDLVad27DdrKBdyfp4q
        fpuDt24WxGtyjpKUi08tpw9XbD0F/LpbtA==
X-Google-Smtp-Source: ABdhPJwz0J1btJ1kAe2GOwwzwm7ipzD47rx5L2cvzL2iOuyt9mR+SnwQdgCXIrglNztOxW8LDg+vog==
X-Received: by 2002:a05:6402:1494:: with SMTP id e20mr21819234edv.2.1593681863555;
        Thu, 02 Jul 2020 02:24:23 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w24sm8684460edt.28.2020.07.02.02.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:23 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 03/16] inet: Extract helper for selecting socket from reuseport group
Date:   Thu,  2 Jul 2020 11:24:03 +0200
Message-Id: <20200702092416.11961-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
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

