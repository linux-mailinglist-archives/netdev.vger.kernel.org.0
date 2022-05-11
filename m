Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285F852411E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349418AbiEKXid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349404AbiEKXiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:19 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694441ACF9A
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c14so3288224pfn.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nLFHvhNFhb/qf+DZNUwjAIpYvQd26ySARtfAXo7uBqs=;
        b=YnZz3kNr5IfqtIN4R7ERGxXS4xetzkqoxBYD+f+qUWNw5xeeMpEaBDreoJLQqJIxRF
         ez9fmk/OljTot/KODWr2FMyJA5D7K2oGi46CygrocUuHZFk7b18o1lxa5DhVxNfM/a1f
         rlIXfpiA/vtHemhF6w2ILLbMWv7hgzxWls2s9rgK/ULfOreHUmFPBsOHywHBRrg44XhI
         tOppDrdi5iQAz4mY5SHUD6GuKZGiaJDtJi4ZGoMzYzftbWnQCbLAlbofPmeAYkLd1TEA
         eEJF7IIkrt2Cpm7s0hvyPRrNPBO/JGaImBT2SD1SQW4JslH/CK93gygB1EUmDdGnw4A0
         Fcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLFHvhNFhb/qf+DZNUwjAIpYvQd26ySARtfAXo7uBqs=;
        b=yTzHwTAo1pB6uSfWIMNVbouQfwwGQnb2T6NmYrDoHAsuKOKQEvlhrAs0HmJNvraZsq
         7GfCD4we4eMr8Bq7JHu6Lx7rqcEmMjhkqYGPN2WO1v/BZvbUQxMjVgQNTGWKD9HtoxL3
         SmDUhW+9OxdYFEZB/npJkHMet1OJgrslidXsPycwWp1ZuOnYRp+RlnaFOFvMYdT2QpGU
         cGTlvLmaficSn4PxsWrSe8zh3Yx5+tV3N/XMlS13GtZwJ/JBIRd4kLnUGTdRzpYVFyXZ
         usEetmF0S/oATFkUDj1PD+kmCbmLDW2mKQrO4GYveh6OSq7y72TbNIhFzIZSPORyFGlm
         ieAQ==
X-Gm-Message-State: AOAM533QMmvTvktmYMu9Gu0m1N/iKtGOXXsI3UAlrE5bsFURd3LROXbO
        7i9Jj6Zvzhm1nTL2f8v4jSLhVCM5C0g=
X-Google-Smtp-Source: ABdhPJwMIxl1OHsh8v7HpLw46u3MqNK321FJsOSIlWXjM9HFxn4UsY2thCyTIuh8iXaWYN5ZYoq0xg==
X-Received: by 2002:a63:8ac7:0:b0:3aa:f853:4f62 with SMTP id y190-20020a638ac7000000b003aaf8534f62mr23079436pgd.205.1652312294012;
        Wed, 11 May 2022 16:38:14 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:13 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 08/10] l2tp: use add READ_ONCE() to fetch sk->sk_bound_dev_if
Date:   Wed, 11 May 2022 16:37:55 -0700
Message-Id: <20220511233757.2001218-9-eric.dumazet@gmail.com>
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

Use READ_ONCE() in paths not holding the socket lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/l2tp/l2tp_ip.c  | 4 +++-
 net/l2tp/l2tp_ip6.c | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 6af09e188e52cfd84defb42ad34aea25f66f1e25..4db5a554bdbd9e80eb697a88cb7208e15d7931bc 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -50,11 +50,13 @@ static struct sock *__l2tp_ip_bind_lookup(const struct net *net, __be32 laddr,
 	sk_for_each_bound(sk, &l2tp_ip_bind_table) {
 		const struct l2tp_ip_sock *l2tp = l2tp_ip_sk(sk);
 		const struct inet_sock *inet = inet_sk(sk);
+		int bound_dev_if;
 
 		if (!net_eq(sock_net(sk), net))
 			continue;
 
-		if (sk->sk_bound_dev_if && dif && sk->sk_bound_dev_if != dif)
+		bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+		if (bound_dev_if && dif && bound_dev_if != dif)
 			continue;
 
 		if (inet->inet_rcv_saddr && laddr &&
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 217c7192691e160e9727afd78126006aba3736b4..c6ff8bf9b55f916e80380bb2e4ea81b11e544a32 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -62,11 +62,13 @@ static struct sock *__l2tp_ip6_bind_lookup(const struct net *net,
 		const struct in6_addr *sk_laddr = inet6_rcv_saddr(sk);
 		const struct in6_addr *sk_raddr = &sk->sk_v6_daddr;
 		const struct l2tp_ip6_sock *l2tp = l2tp_ip6_sk(sk);
+		int bound_dev_if;
 
 		if (!net_eq(sock_net(sk), net))
 			continue;
 
-		if (sk->sk_bound_dev_if && dif && sk->sk_bound_dev_if != dif)
+		bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+		if (bound_dev_if && dif && bound_dev_if != dif)
 			continue;
 
 		if (sk_laddr && !ipv6_addr_any(sk_laddr) &&
@@ -445,7 +447,7 @@ static int l2tp_ip6_getname(struct socket *sock, struct sockaddr *uaddr,
 		lsa->l2tp_conn_id = lsk->conn_id;
 	}
 	if (ipv6_addr_type(&lsa->l2tp_addr) & IPV6_ADDR_LINKLOCAL)
-		lsa->l2tp_scope_id = sk->sk_bound_dev_if;
+		lsa->l2tp_scope_id = READ_ONCE(sk->sk_bound_dev_if);
 	return sizeof(*lsa);
 }
 
@@ -560,7 +562,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	if (fl6.flowi6_oif == 0)
-		fl6.flowi6_oif = sk->sk_bound_dev_if;
+		fl6.flowi6_oif = READ_ONCE(sk->sk_bound_dev_if);
 
 	if (msg->msg_controllen) {
 		opt = &opt_space;
-- 
2.36.0.512.ge40c2bad7a-goog

