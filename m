Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA3524119
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349396AbiEKXiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349380AbiEKXiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:10 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E070BCE83
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q18so3288382pln.12
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wXdqDbMn3niNRtOSNFnZfRQzdIcOYSmVNknYpbOe3iY=;
        b=MBYEPTxIiKg6sBUWoUWeZbuoWw6uR3uBMxfOIutZNGbPtGKGZ/7u5e3GAL73kcvWkf
         uEL1p/xI0Nv+EBu7wiZZJwsALHkwNwNjPPPp+/HlPiYrOB1CBITlkvXH/ozdbWOBZq5t
         5b/YTr8FMzEJwEOh3ERY2R3ekO2/kVzxD7DVY/WhMgbt+8J0ydUiz2MXMUYKx+2UZKpS
         yw/qX0bcP+08Al1g0lUus5Pup2ZEmpSZqvUfhYWOEf2SUhQX8wOiKWN7CPAbI0y7v54L
         I4b9zHm9JcFLfyq01g4ZcALf8FaGfYKN9ocvI0P3N0LStfDXIq4TxweIKOpC60WbcGEc
         36pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wXdqDbMn3niNRtOSNFnZfRQzdIcOYSmVNknYpbOe3iY=;
        b=l8QgEw+NqLjHKVvc6Ki7BY25mvrZgK75y0BIQlQX6X7UO1YwVXTbyOBLYPsIcNY2T9
         /7DcaxdwRUp9etFZJ0XfFVhjAqA4srqoS1Kzx5IYFiNan0CyB2sgmWri7arhM9fOKmix
         iRJXDD+61OngOXVXEpqYgN7wpEbBaefyIA57SCtCo1LFMQojaiyaW/lrhoT1R7vArxKV
         shLUVDVHBLqMcY1MGTJfrBF6FYdWg9T70O6KefSqyZbyB5sOBACiFVbzyAMlfE7yQGEo
         A4l9puErp1MPHVmTy96Urw5nrqoWaF8oJyew3r/FlNnnTrbdtE6jsg8sQG1KKI5axQvp
         QOeg==
X-Gm-Message-State: AOAM5320K2HM3uW6IHDyMcNx6YfYq4MfmQX9zVBk3EqUwRuuhXdVV37c
        EmTO17xi516A/7wTMiInqNo/fyQSlkQ=
X-Google-Smtp-Source: ABdhPJzxvkb6xw1xV9j6UVfi1+2s9WczjzyaBmZHLwr83/dWxFVSF/STS1cECJd97CpxynbRnxJRmg==
X-Received: by 2002:a17:902:ea06:b0:15e:d3a0:d443 with SMTP id s6-20020a170902ea0600b0015ed3a0d443mr27788412plg.10.1652312286876;
        Wed, 11 May 2022 16:38:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 03/10] tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
Date:   Wed, 11 May 2022 16:37:50 -0700
Message-Id: <20220511233757.2001218-4-eric.dumazet@gmail.com>
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

inet_request_bound_dev_if() reads sk->sk_bound_dev_if twice
while listener socket is not locked.

Another cpu could change this field under us.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_sock.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 234d70ae5f4cbdc3b2caaf10df81495439a101a5..c1b5dcd6597c622dfea3d4a646f97c87acb7ea32 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -116,14 +116,15 @@ static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 static inline int inet_request_bound_dev_if(const struct sock *sk,
 					    struct sk_buff *skb)
 {
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!sk->sk_bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
 		return l3mdev_master_ifindex_by_index(net, skb->skb_iif);
 #endif
 
-	return sk->sk_bound_dev_if;
+	return bound_dev_if;
 }
 
 static inline int inet_sk_bound_l3mdev(const struct sock *sk)
-- 
2.36.0.512.ge40c2bad7a-goog

