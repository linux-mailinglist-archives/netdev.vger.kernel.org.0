Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CF822DA40
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 00:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgGYWlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 18:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgGYWlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 18:41:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B844C08C5C0
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 15:41:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m8so266646pfh.3
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 15:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zBh3Brw5i35dJGCDei6Frq9nRpSt9FDaFUnPZiZIX9g=;
        b=rS27zlT1kCnBBkD6OJwugtWzI4X2HFFBpbfpPDr2M4EKbfJyl3GQKJIZsats6rmU6M
         cZ0MP/guhgQsQDb9MmjZg2biK4RzuQGXmBFcqUKAVo1gj4Isk4+32g57La5g/Hi6j2P6
         YBxV9WW+4uAFNqzoBQP+712J0m07xeOjqDA2ECm7SPSXYoIgJu3Tkc4FJaG7iQrvIJin
         NknPDCmOP6MT5wf7++XV4K49asUhKFxVtYytNtB1xq5C92E+UBQ68PdjidwNoSdUAstg
         N0hsd2IoHpUTTB/vn0J08kpefiW0jDOGrJuNW0uzKdysgJQsWDIyP/6dL8z/LcAd0ACA
         xEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zBh3Brw5i35dJGCDei6Frq9nRpSt9FDaFUnPZiZIX9g=;
        b=SildR7kSYpqMuSlA5sySsWAioILdfm+O8m7ODuERN16m3t+edRVVIvk36NjTOqGTxt
         XyVEpXxCJg+iqeEqaZDLtImxHVFkAMscqHUCq9Q8osQQPsqqM2fQWrpwQzkpuwMWUK9b
         U8ggG1m6VH+wJ9VBAd9Ifgea1Pfyuv68DIAr8ncAdy8YPc9omd1siZLly0GjX/wgNj/n
         b9wKfB8lW6a6nTMNjqsBarL5kR3kSM0Ftv9pdordAGczb+BvkaZiSE0fKF45kPwGM49N
         K1VQt9x8p0eHImf4jjggOR8uXxxbcy59UfLxyC29VFpUD3O2dllF0fb6somURvenbjVN
         adDA==
X-Gm-Message-State: AOAM532ZNT8RNDtdB9voGdCSg86EmledhXM92UmoxSvDNwNpEc+5x+kA
        +DPP0PFQwVPkZrpA8Ne60CDpxCugaXg=
X-Google-Smtp-Source: ABdhPJwHROxayZPG6fm3/iMyimDFaWBtMuhGKXnBks0IHJqSoyUHoLL8kBeJyzONGLah6oRAsLHBLw==
X-Received: by 2002:a62:7a56:: with SMTP id v83mr14316636pfc.114.1595716861520;
        Sat, 25 Jul 2020 15:41:01 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::1e])
        by smtp.gmail.com with ESMTPSA id x9sm11476018pfq.216.2020.07.25.15.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 15:41:01 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, ch3332xr@gmail.com
Subject: [Patch net] ipv6: fix memory leaks on IPV6_ADDRFORM path
Date:   Sat, 25 Jul 2020 15:40:53 -0700
Message-Id: <20200725224053.14752-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPV6_ADDRFORM causes resource leaks when converting an IPv6 socket
to IPv4, particularly struct ipv6_ac_socklist. Similar to
struct ipv6_mc_socklist, we should just close it on this path.

This bug can be easily reproduced with the following C program:

  #include <stdio.h>
  #include <string.h>
  #include <sys/types.h>
  #include <sys/socket.h>
  #include <arpa/inet.h>

  int main()
  {
    int s, value;
    struct sockaddr_in6 addr;
    struct ipv6_mreq m6;

    s = socket(AF_INET6, SOCK_DGRAM, 0);
    addr.sin6_family = AF_INET6;
    addr.sin6_port = htons(5000);
    inet_pton(AF_INET6, "::ffff:192.168.122.194", &addr.sin6_addr);
    connect(s, (struct sockaddr *)&addr, sizeof(addr));

    inet_pton(AF_INET6, "fe80::AAAA", &m6.ipv6mr_multiaddr);
    m6.ipv6mr_interface = 5;
    setsockopt(s, SOL_IPV6, IPV6_JOIN_ANYCAST, &m6, sizeof(m6));

    value = AF_INET;
    setsockopt(s, SOL_IPV6, IPV6_ADDRFORM, &value, sizeof(value));

    close(s);
    return 0;
  }

Reported-by: ch3332xr@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/addrconf.h   |  1 +
 net/ipv6/anycast.c       | 17 ++++++++++++-----
 net/ipv6/ipv6_sockglue.c |  1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index fdb07105384c..8418b7d38468 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -274,6 +274,7 @@ int ipv6_sock_ac_join(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
 int ipv6_sock_ac_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
+void __ipv6_sock_ac_close(struct sock *sk);
 void ipv6_sock_ac_close(struct sock *sk);
 
 int __ipv6_dev_ac_inc(struct inet6_dev *idev, const struct in6_addr *addr);
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index 893261230ffc..dacdea7fcb62 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -183,7 +183,7 @@ int ipv6_sock_ac_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	return 0;
 }
 
-void ipv6_sock_ac_close(struct sock *sk)
+void __ipv6_sock_ac_close(struct sock *sk)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net_device *dev = NULL;
@@ -191,10 +191,7 @@ void ipv6_sock_ac_close(struct sock *sk)
 	struct net *net = sock_net(sk);
 	int	prev_index;
 
-	if (!np->ipv6_ac_list)
-		return;
-
-	rtnl_lock();
+	ASSERT_RTNL();
 	pac = np->ipv6_ac_list;
 	np->ipv6_ac_list = NULL;
 
@@ -211,6 +208,16 @@ void ipv6_sock_ac_close(struct sock *sk)
 		sock_kfree_s(sk, pac, sizeof(*pac));
 		pac = next;
 	}
+}
+
+void ipv6_sock_ac_close(struct sock *sk)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+
+	if (!np->ipv6_ac_list)
+		return;
+	rtnl_lock();
+	__ipv6_sock_ac_close(sk);
 	rtnl_unlock();
 }
 
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 20576e87a5f7..76f9e41859a2 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -240,6 +240,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 			fl6_free_socklist(sk);
 			__ipv6_sock_mc_close(sk);
+			__ipv6_sock_ac_close(sk);
 
 			/*
 			 * Sock is moving from IPv6 to IPv4 (sk_prot), so
-- 
2.27.0

