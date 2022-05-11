Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62EB52411D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349417AbiEKXib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349405AbiEKXiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:19 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DEA17706D
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:15 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so3355389plg.0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xts06NB1ydWBfIKgI/h7q/I8j+UuwUGTyL4OWnYAlUU=;
        b=Muoa8ue2s3tG1ePujmHjMRZcU+zPwJEPPCnTbpLrOPfRkCPxGxhT5NYddWoGaVOd6O
         T9I2htPp/G2CGZGBs+wVoxHN6kKnauHX8ICa8W7N8DL7oapZQ67tpUy2ZzDj//RrMMY+
         wVKryoYTpn88aTXO6RlfmehWxfSPP7JSw0mdRM7T96plekKSdryFC3nhZhLCnl28kn7V
         1Vsb0f8MxrKu4yCgjp1rZsQQjEMaiddMypXRR/m6bSs4sEkXR8jUeOjMJ3iRiCJgfyIF
         KS7ye1g6hsPKF6B3JRhv27Th4cKnL/DKDQIqIorW8Mu/Ob8lFNjry/kutiDxZ9/GM2KS
         qQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xts06NB1ydWBfIKgI/h7q/I8j+UuwUGTyL4OWnYAlUU=;
        b=qMI/5rT5Fjwvl/bsMCir3S44jyoYq45Gwm5IN86cPSyFbe/4USjZYG3+Ii4iPhWULz
         z91x2rvSNE7WBEY9WihefzZJo9ObdVF9OW3k/X6CaTcJKv7f0/LKcVeEuYykhb1tlPOq
         hFU24Z8x9KjcHSSgVFQf1MPr2jpPfvrssP4v3TeCnFXA5hCRJUncu+Nv82M3dGFIgWOn
         mtjPzFmFDMWn4DKMrGbRuapJ5zQHSybDAddcbf9M3iwaX84kc/zzLONtNJUokKDCqxc8
         0Lle1EF3mjOxVwnGvXQIyXsNXRxFVZCoT3rGT1eSDqty1MzpwI2pqw975P7ySLw2Kv07
         k0qg==
X-Gm-Message-State: AOAM531uRkqaHj+GrGa5kTxfG6ihZzIs8MG5yERmiqKh4qb0wrAhkazB
        PIOzTlK1Bq+ZzWCreElxEqQ=
X-Google-Smtp-Source: ABdhPJw7ja6m1iChG+BqzHfhuVqYXe+VfMqCwMoN6+l8hrx8foinBfAxLWqPr42w6jIyhPbzndUCEA==
X-Received: by 2002:a17:90b:3944:b0:1dc:1ddb:e25c with SMTP id oe4-20020a17090b394400b001dc1ddbe25cmr7721942pjb.124.1652312295363;
        Wed, 11 May 2022 16:38:15 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:15 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 09/10] ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
Date:   Wed, 11 May 2022 16:37:56 -0700
Message-Id: <20220511233757.2001218-10-eric.dumazet@gmail.com>
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

INET6_MATCH() runs without holding a lock on the socket.

We probably need to annotate most reads.

This patch makes INET6_MATCH() an inline function
to ease our changes.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet6_hashtables.h | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 81b96595303680dee9c43f8c64d97b71fb4c4977..a7523e2e7ce50564c3ef1b3563a55dc80a03927d 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -105,13 +105,22 @@ struct sock *inet6_lookup(struct net *net, struct inet_hashinfo *hashinfo,
 int inet6_hash(struct sock *sk);
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
-#define INET6_MATCH(__sk, __net, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))			&&	\
-	 ((__sk)->sk_family == AF_INET6)			&&	\
-	 ipv6_addr_equal(&(__sk)->sk_v6_daddr, (__saddr))		&&	\
-	 ipv6_addr_equal(&(__sk)->sk_v6_rcv_saddr, (__daddr))	&&	\
-	 (((__sk)->sk_bound_dev_if == (__dif))	||			\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
-	 net_eq(sock_net(__sk), (__net)))
+static inline bool INET6_MATCH(const struct sock *sk, struct net *net,
+			       const struct in6_addr *saddr,
+			       const struct in6_addr *daddr,
+			       const __portpair ports,
+			       const int dif, const int sdif)
+{
+	int bound_dev_if;
 
+	if (!net_eq(sock_net(sk), net) ||
+	    sk->sk_family != AF_INET6 ||
+	    sk->sk_portpair != ports ||
+	    !ipv6_addr_equal(&sk->sk_v6_daddr, saddr) ||
+	    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
+		return false;
+
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	return bound_dev_if == dif || bound_dev_if == sdif;
+}
 #endif /* _INET6_HASHTABLES_H */
-- 
2.36.0.512.ge40c2bad7a-goog

