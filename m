Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279AE6BB82F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjCOPnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjCOPm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:42:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7ED7B980
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:55 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-540e3b152a3so144816457b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dbZoz4QOzziJUbuQwPzjqvaM0Lu47sMx74iGpmk1hNw=;
        b=YL6QHsu8plPHV9DKcxccjd3SaL5mFsHRw4vwKIs09orUwX+Z5UldviWCanG5krd2uZ
         QZkLNxNBADO73TjxGW/JHuoWnpvtnX50pHv4IMOSQ4595A4IO5nneJ9J5jyAgqgTawfU
         S2tEmfLm1y6h0vAhBwJ7pL2G42sPA8vVhWMgPND+UIPe+gH7Eu+QSpAUZOIFWiY8SeCf
         CxfJ9uqQ45+g4xHygVchuIG1V7J5mbQppBMYIy5CaApnF/Ep6BZlY2kHjP9TkzR8dylE
         Z6gLqz5iZSWR7ENJPRjUZV0ABKl7m57tB8GNBmYMzsQCt0RrCK6kCBye674TehpR5DJf
         cXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dbZoz4QOzziJUbuQwPzjqvaM0Lu47sMx74iGpmk1hNw=;
        b=DcrvpgoKYPKQJxWYUCQvQ4TlhW28wKG9tOUrYM4eMIsNJqR04GI5PmR7vy8LKf1aLD
         KCgmp8svAm6m1f/BECmQgHcQX3xJUCdDE4zI/uER/RXJT6TJwsjT3L/9dt13ji+kGwpK
         xG24iMV6NI0y1EfmENtGWySfNQMF/jkpZ1hW1ifx0IG3sIy0GLlLuSOqSIbOwTBkahop
         6wZ+zodb5OdaKLKSZZgidWozPf0TdQIE6yOeQUXU/YIK3NlzEl3y/DJdORGABNBou2ja
         Q+XGBOLxKh7Uh6R+LhE33Gzft0NqliWBjqDIvcOkJjzFWGbL7MPZ9wsza4OROCYrSndk
         Wadg==
X-Gm-Message-State: AO0yUKUVpGEJaZP8v+PGZ7TGz6uM7xFkWCB+oB+xQ0i2VZqaMygolD6T
        AXWBejotgBaY4d8Qu/SKIE7kzaOjG/pKTg==
X-Google-Smtp-Source: AK7set86kAnup/kVwk37FCIlkB3O1Emmes728lSAbpIWuOyMYbAR4B79OQSTP1iV9B5FLvtm20Ztxw5dvPgclg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:a9c3:0:b0:541:9b2b:8240 with SMTP id
 g186-20020a81a9c3000000b005419b2b8240mr206735ywh.6.1678894974745; Wed, 15 Mar
 2023 08:42:54 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:42 +0000
In-Reply-To: <20230315154245.3405750-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-6-edumazet@google.com>
Subject: [PATCH net-next 5/8] udp6: constify __udp_v6_is_mcast_sock() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clarifies __udp_v6_is_mcast_sock() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/udp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ab4ae886235ac9557219c901c5041adfa8b026ef..d350e57c479299e732bd3595c1964acddde2d876 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -805,12 +805,12 @@ static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
-static bool __udp_v6_is_mcast_sock(struct net *net, struct sock *sk,
+static bool __udp_v6_is_mcast_sock(struct net *net, const struct sock *sk,
 				   __be16 loc_port, const struct in6_addr *loc_addr,
 				   __be16 rmt_port, const struct in6_addr *rmt_addr,
 				   int dif, int sdif, unsigned short hnum)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 
 	if (!net_eq(sock_net(sk), net))
 		return false;
-- 
2.40.0.rc1.284.g88254d51c5-goog

