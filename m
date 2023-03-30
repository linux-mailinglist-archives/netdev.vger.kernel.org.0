Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F386D0EB8
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjC3T0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjC3T0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:26:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8DBFF1A
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:25:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso11912506ybf.23
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680204335;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oSZzmlSS0ViOrgoifG2A+qVqVoAK3xbRcCiltCGZPFk=;
        b=Rp5n4KzkPRZtoYnZo8fo0SFV0MiaXtMET0Uj8xawEdeyVXfNegNPK5Zg/kfxGYKj9R
         2D7cG0VDqOZLhSSZkX1si92cWcX2n3JDupEMdsChMApTxOSDKb9GMIdzB6J9Xkbz3WGM
         aKLgjbHLc6yFB2ODiN6yM1sqaZcbMYueGJr65cTULnmkGUvzdPPSk7pvabqhCWSCSEqF
         fFrvEeZGRWZk5YBRG21RO6sAQorZtSDXfyh3IIvYcqU3COFt2G0C1Xw2e/kmYRvThYQS
         s9taUgr17T+4sDgpzrV6BpuMGLuPs7GyVTtr5nUOTPE5zSqf6MDPhjNjRr1YN9kZLhEg
         YoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680204335;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSZzmlSS0ViOrgoifG2A+qVqVoAK3xbRcCiltCGZPFk=;
        b=OLFIwUIR94pIiyLG6J06NCOCI+pQGq5v/boEGRSto1Ntsj5c4+ualgFKaZISr9r5hA
         rA3zXTTO+wwMxf6Jfppm45dkWJotcsCQt29zyZHM7WIttGxwS/KOIAAxnD513jGH8khy
         wQMMMVvMyxh0jp/jwEzH+ouk+5lA62LJ/nvVk/i7sjdU3zvJ9BELfuojUL3+TqPJ+38m
         ng3+iLk+hjGoZO6S8a20AZnx//3Mkv/Bl3/aArjTSOvafSPiZV62WY35eJ9/HHJpjJWt
         dkuZuHQ5UAzlB3Dsh6smbMfsI7JwuCYpEZ5xjb5yM/EaNjzyISagOLgu4Kw/8QYWArCV
         JHUg==
X-Gm-Message-State: AAQBX9dfckLHRlj8Qwxv7ChtiGhSMwombehfgNuugTiibBkHkOtw3YKs
        fJ8KDOY8ekoG+TXOmvObYqsdRp5NJKSLcg==
X-Google-Smtp-Source: AKy350bf1T/nzQ09im3SjeV66VKJwmDOERuvFPKdE263Znd8rf6Morz169MuF/f4euWA3+/CieGo2sTunIjmRQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:72e:b0:b6c:f26c:e5ab with SMTP
 id l14-20020a056902072e00b00b6cf26ce5abmr16936710ybt.3.1680204335387; Thu, 30
 Mar 2023 12:25:35 -0700 (PDT)
Date:   Thu, 30 Mar 2023 19:25:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330192534.2307410-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: tsq: avoid using a tasklet if possible
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of always defer TCP Small Queue handling to a tasklet
we can try to lock the socket and immediately call tcp_tsq_handler()

In my experiments on a 100Gbit NIC with FQ qdisc, number of times
tcp_tasklet_func() is fired per second goes from ~70,000 to ~1,000.

This reduces number of ksoftirqd wakeups and thus extra cpu
costs and latencies.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfe128b81a010339b486dd6a40b077cee9570d08..470bb840bb6b6fb457f96d5c00fdfd11b414482f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1023,13 +1023,18 @@ static void tcp_tsq_write(struct sock *sk)
 	}
 }
 
-static void tcp_tsq_handler(struct sock *sk)
+static void tcp_tsq_handler_locked(struct sock *sk)
 {
-	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		tcp_tsq_write(sk);
 	else if (!test_and_set_bit(TCP_TSQ_DEFERRED, &sk->sk_tsq_flags))
 		sock_hold(sk);
+}
+
+static void tcp_tsq_handler(struct sock *sk)
+{
+	bh_lock_sock(sk);
+	tcp_tsq_handler_locked(sk);
 	bh_unlock_sock(sk);
 }
 /*
@@ -1165,6 +1170,13 @@ void tcp_wfree(struct sk_buff *skb)
 		nval = (oval & ~TSQF_THROTTLED) | TSQF_QUEUED;
 	} while (!try_cmpxchg(&sk->sk_tsq_flags, &oval, nval));
 
+	/* attempt to grab socket lock. */
+	if (spin_trylock_bh(&sk->sk_lock.slock)) {
+		clear_bit(TSQ_QUEUED, &sk->sk_tsq_flags);
+		tcp_tsq_handler_locked(sk);
+		spin_unlock_bh(&sk->sk_lock.slock);
+		goto out;
+	}
 	/* queue this socket to tasklet queue */
 	local_irq_save(flags);
 	tsq = this_cpu_ptr(&tsq_tasklet);
-- 
2.40.0.348.gf938b09366-goog

