Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7410524120
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349406AbiEKXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349399AbiEKXiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:20 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A9F6D951
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:17 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l11so3064824pgt.13
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6hoL+dAnDcEwYoBSkV/u3wIt5TDKEu6TFdOf6hMtRsE=;
        b=Bs3LQuc0bLHWNsB6qWe7uoRnhBQWFfW5gFzWO4JewKDxDBF52J7d/qAxjWlbXzklt0
         88/NCSDiL/7AEfVRMhVUorbTiCvyaZ/oFMKyr8Dcfk2Ox7/1JoVKUPnlVZX9ZUj029Mi
         PipL0vrNrXLE8G3QsPy9j4RG+zmg8DKbcZYCuZ9MHKQF2aye7fcPBFLcoVVdh3U15rRs
         HMauzII+dqtLXzn3MYEXLlDRK9Ze3C3wsoebxnhr/2SNAIcNT1IU2r6Kwzl7YEB4xHFx
         z5EN/eQtsSvp6RyA5Rg9CHAehfvv0hrLM5EehebyQKp2pzoUd7xiqSW3iQ7w0f8K/uhl
         1ssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6hoL+dAnDcEwYoBSkV/u3wIt5TDKEu6TFdOf6hMtRsE=;
        b=K8FAHFptYLwmYhXtJrGHG0FY0vQMZ22Qq78lQIgFUBftvLAlqwAIaGaZE0f4MMuVvE
         ke/wc0DoTP0tp6YlxFUePGbtf9wP6DCEmZBS+PFhLq8nNDNI5SXVgyy5q3schmL/aIHP
         1rUS8NwFQUBZX6i7zYMJ5HQo+pCK4iIg968G0AxlWKBS5LwngNjFTnycj6qia6NJMeIH
         HpMN21iN6VMg5c52V7/4cdoklQdxf+qOSvGDWpWOoaBAAsSBSxRrVD3CIK/gqkH8oxl7
         EChhxDaM8+6Lj5mT1Ynt2CbhGeB1lybmvwtbJnYdr6oZ1P1pkQSooVEqQEW0Z3aYa7FK
         CLUg==
X-Gm-Message-State: AOAM533YteSc3IRjeDVs8yMEIMXlJ/xwvwJJ25iKX2Xy8ruti99IO3wB
        njcBlKLCYm2F6zjdoWYrvPQ=
X-Google-Smtp-Source: ABdhPJxB8oBLVYQIgwkvnu8g2FRtiMpCBsQo+ovoCGcyHrtFvqGOW7D/AAtbkyD166YOTXthL8f+nw==
X-Received: by 2002:a65:4503:0:b0:382:aad5:ad7d with SMTP id n3-20020a654503000000b00382aad5ad7dmr22972706pgq.488.1652312296878;
        Wed, 11 May 2022 16:38:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 10/10] inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
Date:   Wed, 11 May 2022 16:37:57 -0700
Message-Id: <20220511233757.2001218-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220511233757.2001218-1-eric.dumazet@gmail.com>
References: <20220511233757.2001218-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

INET_MATCH() runs without holding a lock on the socket.

We probably need to annotate most reads.

This patch makes INET_MATCH() an inline function
to ease our changes. This also allows us
to add some __always_unused qualifiers.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_hashtables.h | 52 +++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 98e1ec1a14f0382d1f4f8e85fe5ac2a056d2d6bc..5d3fa071d754601149c9ad0dd559f074ac58deaa 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -307,23 +307,47 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 				   (((__force __u64)(__be32)(__daddr)) << 32) | \
 				   ((__force __u64)(__be32)(__saddr)))
 #endif /* __BIG_ENDIAN */
-#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))			&&	\
-	 ((__sk)->sk_addrpair == (__cookie))			&&	\
-	 (((__sk)->sk_bound_dev_if == (__dif))			||	\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
-	 net_eq(sock_net(__sk), (__net)))
+static inline bool INET_MATCH(const struct sock *sk, struct net *net,
+			      const __addrpair cookie,
+			      const __be32 __always_unused saddr,
+			      const __be32 __always_unused daddr,
+			      const __portpair ports,
+			      const int dif,
+			      const int sdif)
+{
+	int bound_dev_if;
+
+	if (!net_eq(sock_net(sk), net) ||
+	    sk->sk_portpair != ports ||
+	    sk->sk_addrpair != cookie)
+		return false;
+
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	return bound_dev_if == dif || bound_dev_if == sdif;
+}
 #else /* 32-bit arch */
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
-	const int __name __deprecated __attribute__((unused))
+	const int __name __deprecated __always_unused
 
-#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))		&&		\
-	 ((__sk)->sk_daddr	== (__saddr))		&&		\
-	 ((__sk)->sk_rcv_saddr	== (__daddr))		&&		\
-	 (((__sk)->sk_bound_dev_if == (__dif))		||		\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))	&&		\
-	 net_eq(sock_net(__sk), (__net)))
+static inline bool INET_MATCH(const struct sock *sk, struct net *net,
+			      const __addrpair __always_unused cookie,
+			      const __be32 saddr,
+			      const __be32 daddr,
+			      const __portpair ports,
+			      const int dif,
+			      const int sdif)
+{
+	int bound_dev_if;
+
+	if (!net_eq(sock_net(sk), net) ||
+	    sk->sk_portpair != ports ||
+	    sk->sk_daddr != saddr ||
+	    sk->sk_rcv_saddr != daddr)
+		return false;
+
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	return bound_dev_if == dif || bound_dev_if == sdif;
+}
 #endif /* 64-bit arch */
 
 /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
-- 
2.36.0.512.ge40c2bad7a-goog

