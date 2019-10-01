Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABD1C3EF8
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfJARtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:49:11 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37160 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfJARtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:49:11 -0400
Received: by mail-pl1-f202.google.com with SMTP id p15so7699812plq.4
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 10:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gGCVjqhtBSkQ7qwIsFjA6kBBGz9r2UmtOH2oSB04oM0=;
        b=pmWpC2UAQCRHBJ17j6T1r0PqiVqZ5n8GKpyjtSppvwb5xGIRgCqaWlEuGIitPSE/xZ
         zk7KKC7QuDLlZi2E44eSCOw3QXKNINeh6TwrvhHyDoMNvDcgvCAJzOd4nH3+cjdf4m8w
         a8CVSfrYzw3ojJdqLovKNFdminRFcrxhEvYsQPUhJP3oJIBtF5Zj+uutCwhCoCF99iz7
         BC72EKsphEppD4ynfCxj6G24CpWQIHZeTMEzUaUyGZ0wqfBTvWsbavAD6aLx0ZDbJxLu
         cwCHrsAMCiShALq01hzxnZCDVyfXYl9OtchnYXQFn2hx5IFdwYYGixVduEDWG7/PUTKm
         j6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gGCVjqhtBSkQ7qwIsFjA6kBBGz9r2UmtOH2oSB04oM0=;
        b=kTiSQ9wm4fTB1dvLUAEuFZBHfxuAiRFMpbMbGH0ILtCG/t81GqJ+yTq/3qPe9Jhp4Z
         15r+BIepKeuTjIotK8NC7rc8IjYCyb4AsvGY/1FZlIgSarZUST1zpylGL0zc6pWhi6kh
         NqjRc6exKHaBT7emarvDBPNBAbbpzkwiJefacinOlgPfDiR8cUt9TfOTo5qM2YKmIxz8
         WYefFMbt4NwmLViyu2GwwPQfYUXmQ7tBLeq11AaSkKFpCV2LfcKHzhSAPbbNiamgBaB8
         lfrlYuxeFphiqFQ1Q+CNH1Ag7ywbRlkfP/7twhatXRsldEzFI1CzVOYbbWbTAxPO53h6
         nhdw==
X-Gm-Message-State: APjAAAVs30tjRyIz/83ObYv4uHG4v0lCMUe0jlbyCZ6VYHToOsMiXtvL
        n+BzEZ0dNEfAB8VMM1pORgRx30k4ZLe4vw==
X-Google-Smtp-Source: APXvYqyzoBhc9Qhx9xkQRcslMz5L/i8ebISHua2oCMCQr0PpGekEmOoZNRSN8sNOEHogLRLqDkecccrImX354Q==
X-Received: by 2002:a65:500d:: with SMTP id f13mr31623802pgo.359.1569952149877;
 Tue, 01 Oct 2019 10:49:09 -0700 (PDT)
Date:   Tue,  1 Oct 2019 10:49:06 -0700
Message-Id: <20191001174906.96622-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net-next] tcp: add ipv6_addr_v4mapped_loopback() helper
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_twsk_unique() has a hard coded assumption about ipv4 loopback
being 127/8

Lets instead use the standard ipv4_is_loopback() method,
in a new ipv6_addr_v4mapped_loopback() helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h  | 5 +++++
 net/ipv4/tcp_ipv4.c | 6 ++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 009605c56f209040d10f4878353aafa66c1a845f..d04b7abe2a4c3975edce9f4f0d91e6091ca4d401 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -696,6 +696,11 @@ static inline bool ipv6_addr_v4mapped(const struct in6_addr *a)
 					cpu_to_be32(0x0000ffff))) == 0UL;
 }
 
+static inline bool ipv6_addr_v4mapped_loopback(const struct in6_addr *a)
+{
+	return ipv6_addr_v4mapped(a) && ipv4_is_loopback(a->s6_addr32[3]);
+}
+
 static inline u32 ipv6_portaddr_hash(const struct net *net,
 				     const struct in6_addr *addr6,
 				     unsigned int port)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2ee45e3755e92e60b5e1810e2f68205221b8308d..27dc3c1e909494f54da18ea05bb0102de8ef5e5b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -121,11 +121,9 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 #if IS_ENABLED(CONFIG_IPV6)
 		if (tw->tw_family == AF_INET6) {
 			if (ipv6_addr_loopback(&tw->tw_v6_daddr) ||
-			    (ipv6_addr_v4mapped(&tw->tw_v6_daddr) &&
-			     (tw->tw_v6_daddr.s6_addr[12] == 127)) ||
+			    ipv6_addr_v4mapped_loopback(&tw->tw_v6_daddr) ||
 			    ipv6_addr_loopback(&tw->tw_v6_rcv_saddr) ||
-			    (ipv6_addr_v4mapped(&tw->tw_v6_rcv_saddr) &&
-			     (tw->tw_v6_rcv_saddr.s6_addr[12] == 127)))
+			    ipv6_addr_v4mapped_loopback(&tw->tw_v6_rcv_saddr))
 				loopback = true;
 		} else
 #endif
-- 
2.23.0.581.g78d2f28ef7-goog

