Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DB63BA48D
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhGBULl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhGBULl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 16:11:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020CAC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 13:09:08 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so8341854pjb.0
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 13:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hsxLPE6n9hDKQXhj6wLUqqXLVyZdJIo7vOg1HKqVME=;
        b=k1IVm6et8+mDTWsm55kZV8Uv5MWSNKejWXcf1Smip1J3r5s98ucQHPjZuIqSHfrwXQ
         XmBFNO3Fx4jdsMpd86oIqcBuXDk6YXIBNv1Yxmp4M1RNQCTn+ozNyP4KWsXVxEKLRKLZ
         xlKrtxgRMck0SrBKPyKB4F6vDKJ4LhNFHtXDrdQFH8iK5/y5VEtiUCGOVkS3ZnvSoAIl
         BdMpLx0vyTUlMS+OrfboUtlS26S7LlzkEaKiJAg0xsr1JdtZrNlVS36Pk9zaZdv/BVrV
         TS8/KR9omqcVzoR6OhifPE40FMW/mOxBTaeAwGEzeneiQP8zkLPxYS8ZsPXgZ63zl3K3
         idWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hsxLPE6n9hDKQXhj6wLUqqXLVyZdJIo7vOg1HKqVME=;
        b=sZfsZs03AR+2MWpe3RgdUlyBPjjjJz3jaYqSOXx2q6vdRq8lLnv666mKS8WNclszJ9
         C/HR7bWrR2l0cbhLprngNEQ59tvbQg3HVqZbUMEIxCp02/NdBB9m1JAsw9XWhUjsYodK
         DkPMETW8rk/R3QHxERtW5zQnEseowYmTPFJFNOKziYWIBP6jY/aG8f/MR5ev9lqRDptA
         qaWPZhupe4Xrobnn9URTGvYpYTYoY/UYNt6OygnfDXkVvB+S57l+LG6x+w2t0oN+kp9d
         4lkWHv5pqKI4VEI2KGPz+ok01TTTZCvc9j2SrfelZMB4+IdQWd5xVGgC8ikOSF9GKKa7
         XKRw==
X-Gm-Message-State: AOAM530TJuv+WhHAncdZRjIzRt+RCn0T1M7cpNDWi4P1aQk2wK234rW4
        aJ2zF91R+heVSmG0ae2eDh6lLhsCc2E=
X-Google-Smtp-Source: ABdhPJyZYm3GkwFT2c0m+090ldIMc9heOiTPgMOO5kNAA6EHiOgy8MEu2CtTb+y09qSciXR26VO1OQ==
X-Received: by 2002:a17:902:aa4a:b029:10e:f98c:2b83 with SMTP id c10-20020a170902aa4ab029010ef98c2b83mr1231970plr.62.1625256547523;
        Fri, 02 Jul 2021 13:09:07 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7c57:ec32:6dc8:bd6c])
        by smtp.gmail.com with ESMTPSA id j205sm4653065pfd.4.2021.07.02.13.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 13:09:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] tcp: annotate data races around tp->mtu_info
Date:   Fri,  2 Jul 2021 13:09:03 -0700
Message-Id: <20210702200903.4088572-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While tp->mtu_info is read while socket is owned, the write
sides happen from err handlers (tcp_v[46]_mtu_reduced)
which only own the socket spinlock.

Fixes: 563d34d05786 ("tcp: dont drop MTU reduction indications")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 net/ipv6/tcp_ipv6.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e66ad6bfe8083bfde66d24d9644abcdb649508be..b9dc2d6197be8b8b03a4d052ad1c87987c7a62aa 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -342,7 +342,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
-	mtu = tcp_sk(sk)->mtu_info;
+	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
 	dst = inet_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
@@ -546,7 +546,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 			if (sk->sk_state == TCP_LISTEN)
 				goto out;
 
-			tp->mtu_info = info;
+			WRITE_ONCE(tp->mtu_info, info);
 			if (!sock_owned_by_user(sk)) {
 				tcp_v4_mtu_reduced(sk);
 			} else {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 578ab6305c3f84819bb38054acf1e62c00a9061e..593c32fe57ed13a218492fd6056f2593e601ec79 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -352,7 +352,7 @@ static void tcp_v6_mtu_reduced(struct sock *sk)
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
 
-	dst = inet6_csk_update_pmtu(sk, tcp_sk(sk)->mtu_info);
+	dst = inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info));
 	if (!dst)
 		return;
 
@@ -443,7 +443,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		if (!ip6_sk_accept_pmtu(sk))
 			goto out;
 
-		tp->mtu_info = ntohl(info);
+		WRITE_ONCE(tp->mtu_info, ntohl(info));
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
 		else if (!test_and_set_bit(TCP_MTU_REDUCED_DEFERRED,
-- 
2.32.0.93.g670b81a890-goog

