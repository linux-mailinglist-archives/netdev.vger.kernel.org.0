Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A235269AE
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383450AbiEMS4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383463AbiEMS4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7846BFFB
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:05 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y41so8416643pfw.12
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bbzJfH0PErMCbd5F/OJ6qwc9WUXsd3JJD9CMV2tx8VI=;
        b=J2zQ4e75hegVgqM2zyZZ6BPdnRgLY/8f70HMgTRyHfxd1bLe0y73pi4rAdJ/QZsInm
         3AQykfUMMjhAnLfoJkn+GtNQEKoTeCBIaaDMl8FcJTFHC6vmgzq8lpwMdsAeVbw4hvdS
         WkBDR2+rd3zzANjsEeciLsKeW/ZOMC2O5aLyBb+eLKiIHMuoqTwoU2yjcXsPI421xWK0
         TZJw0qwvMl/qCbhMHUDUZtXwf7ZtDfVPfjl6yV6AwYvb4QyfXRHA3QIZe6ivQk3PPRVU
         i5kxPMdQxtEogxHHfDVkMu5o1kq5HVf2naIhfVYbijtR/vo8yxMsT0sgeMMnDqB/u8jN
         mIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bbzJfH0PErMCbd5F/OJ6qwc9WUXsd3JJD9CMV2tx8VI=;
        b=w4+iWlB0JjNZEPbEzMIYooyScyKhHTgL6LoRnOTkSZl0bJUIxkvVXYOGa2C9PmZjLj
         POXgYVWlLI+oP5CUzDNqsqAUK82RrQ7Z73IdvEb5QFpVpwlLwS4OLFFB/0+nTyKzxGcD
         dYb3j/YZiqhsrYICCG6NMJW2bFW5507g/Iyl4auBHxa8PjcycdNEHBKV+n4P736VZA8E
         LBHoMD6QX+JSXbvZLjuSb3Kbmm+k2OzvXDP5CDZFSiWYQiNolmx0n9I0jHdD1KmS0Skw
         CxttG9HBG6i+yDo4VPuK1sd1yy6UJGsxvUhYM4CFmgAPaM/Q7/gRtZLkyn0Wrbki36EQ
         8fgQ==
X-Gm-Message-State: AOAM533ytPS+GAlwBodLB5khRBm2khJiLeFRSuDYZ9TkfQQ5I6X+iJhn
        hoStHAKuE8Ggg4Xb0Ip3Xpw=
X-Google-Smtp-Source: ABdhPJz6vv1A4SkqwzHkSys+zcoj7DX5OMSwXNHCGdP438h85ajeW79sajzMRo8WghhpkFZK2tWR7g==
X-Received: by 2002:a05:6a00:882:b0:510:a043:d4bc with SMTP id q2-20020a056a00088200b00510a043d4bcmr6010337pfj.64.1652468165292;
        Fri, 13 May 2022 11:56:05 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:56:05 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 08/10] l2tp: use add READ_ONCE() to fetch sk->sk_bound_dev_if
Date:   Fri, 13 May 2022 11:55:48 -0700
Message-Id: <20220513185550.844558-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
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
2.36.0.550.gb090851708-goog

