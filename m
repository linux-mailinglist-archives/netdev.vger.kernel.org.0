Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136216BB82E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjCOPnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjCOPm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:42:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D386D6FFF9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-540e3b152a3so144815877b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zM+PS+KsvJKkjk+P5uKoyjd33NWdGy5HDkijimHL/pc=;
        b=WMMl51I7iR3lESd8iXe3JeKTRFHigN2oLA0xys6N364QCMXV2jQ77R1nEc4qjt93x8
         C9ntWdjYF4a49mUx/oCWMIKq85c8cmk46MLmX1TlOiEW73+RToDzp4hixm/oHstnOvQY
         O6Ihhtf7Z2Cg2pHdqsAU2KaG/HGffESQRPs7s0Ry13Ol2w+aVUtUYdKMRfJ7VBYV4t7n
         P8TRloGMR5cOG+5IVmSoq9i26rTijUE3cpVWE23J98KZp6LJ9hNnNvKr0vGAWM23EH7M
         O3kmgxx2ohhkuQQyahPsNCGS/azKNDMa6kKQ3bv62l1sDVVM6bDHuXOtaKF+z1gx6iu+
         F+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zM+PS+KsvJKkjk+P5uKoyjd33NWdGy5HDkijimHL/pc=;
        b=J6jcBNJ/o7obCVjoZ1rFWPW9eAQ9uKdBbyYPuRpPsA6CzWjHYb3AA0gy9XFYgQXB27
         dROBkDQMZijOncr1K8Wep8c2vpuK6BgUJoiahsEbT3aW/MZSrYu9W2cZAlw1XUZB64hk
         I1Pew+kL5f+YryaqyDid2EDN3opQDEGfbvuSyW+4LXqG2PXLB1LcHPtrdw8BvlyFKyMp
         a7Fz7u1BBK4XqTzjQKbpi1qyNvmJsuFo0Jdgr68IACe1EUwVyUzkJqaV9pJ4XUBW2ZQo
         8QLLtAFGgptaC3bejkFn2vU5M70qtwmzi8NxSsslcEM/MbwErAeIxvRuILWM4z9AwmUE
         NL5A==
X-Gm-Message-State: AO0yUKUWESLzxa15piHQpZsYJZS0grXyhfr+XuLyF+AzyGcZfViqLybK
        X98vIl723ICCyUjsA4WlmCkuyql3WpRaDw==
X-Google-Smtp-Source: AK7set8MXTjCMuNCm9GEW8pzt111E0K12BvHswhP1w4p/FCTcACjUXNfTBQZti5C256UjUZ7KJvgLWUIb1GnKQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:312:b0:a58:af0b:5150 with SMTP
 id b18-20020a056902031200b00a58af0b5150mr21704987ybs.3.1678894973106; Wed, 15
 Mar 2023 08:42:53 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:41 +0000
In-Reply-To: <20230315154245.3405750-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-5-edumazet@google.com>
Subject: [PATCH net-next 4/8] ipv6: constify inet6_mc_check()
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

inet6_mc_check() is essentially a read-only function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/addrconf.h | 2 +-
 net/ipv6/mcast.c       | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index c04f359655b86feed2b4b42cc69b90c63088238a..82da55101b5a30b2a5512d964429d2c5f73d03fd 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -223,7 +223,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
 void __ipv6_sock_mc_close(struct sock *sk);
 void ipv6_sock_mc_close(struct sock *sk);
-bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
+bool inet6_mc_check(const struct sock *sk, const struct in6_addr *mc_addr,
 		    const struct in6_addr *src_addr);
 
 int ipv6_dev_mc_inc(struct net_device *dev, const struct in6_addr *addr);
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 1c02160cf7a4c54f0d8687b8368e5f6151ab0bce..714cdc9e2b8edfb925a061a722c38b37b1c6088e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -627,12 +627,12 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	return 0;
 }
 
-bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
+bool inet6_mc_check(const struct sock *sk, const struct in6_addr *mc_addr,
 		    const struct in6_addr *src_addr)
 {
-	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct ipv6_mc_socklist *mc;
-	struct ip6_sf_socklist *psl;
+	const struct ipv6_pinfo *np = inet6_sk(sk);
+	const struct ipv6_mc_socklist *mc;
+	const struct ip6_sf_socklist *psl;
 	bool rv = true;
 
 	rcu_read_lock();
-- 
2.40.0.rc1.284.g88254d51c5-goog

