Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F8362942A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiKOJTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbiKOJTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:19:37 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2630F1F2D7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:18:57 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36f8318e4d0so131747737b3.20
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y8QpAjU3DxwPnSiaBVNmN26PhdWxcn5zF47k0r3Ro9s=;
        b=h8tVzd/qGUcF1YeSWzuFH0Jn1b/geL7la3ob3woDVKaTo0KAdAZyaML/0C4T2T+GNf
         4K89dKHVIgWymTXd93IrR7zPuVyTmt28KFiWBCbkMFk3aCvwSTqvO34lb8BiGzomd7oC
         kXawzDi0THpwIB67TaZDQnpwT0un0w1sxvCKN0mOY7VD4Ik04p0StHmVnXpPEmcbp0h4
         q22S/cWId7PEztAKSY8FLuJl8qrTghrDNcqYrFqNQkdQBTOTt18uDMQxNQ2wOL/bQpeP
         aKIpPXuxQulEF9r0e6uWXA0HPyTlu/jRfR1aIEZb/hxNPn9hO8lcjsVQUy4kKoQjjXQb
         Sbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y8QpAjU3DxwPnSiaBVNmN26PhdWxcn5zF47k0r3Ro9s=;
        b=CRhAh369Gi/B5sx1dhR+V8kDQCQIbQ9bWoGhWb49B1U1hVlbZyGQvgC44GF2jwrYbn
         lHPgcBH0q0Zvs3ViARhT//trFJ0CYwDj4ERKNhwbpYectoj+zNyeP5Ap98Ym9Rl/YzFj
         y0jWp5Ed5mVt8JhpV5Bdgzcq4mjB0evH4qvyGTiZMFreULGOe0M6QfArcWryFxuC0SKC
         z01odu/jzWeDYBPVRxTuJWgDU5HIavGoZeaNsb5IKOTj925KO4SBEtuCkUNg4odhjJce
         0k+pQQQ00pfGH7LnC2j4sDzIscpFy4F7uXxwP+5KehsVFA2isPw9w+yqj4NMMMJAuqto
         aHng==
X-Gm-Message-State: ANoB5pmwofnMe5EFyeb3SJb6/MNi29/LbeMSozcGIZizoVzp3NC9KU5h
        JjJQP44g0qEHEhFN9BLfOiK9RjOdDyvY0g==
X-Google-Smtp-Source: AA0mqf44TAtNcRroDnLI8fuCzD0FQkWnJXNtPYJUh8wPuGv19CKUGHFOvR14p38SkdOMMRyMBd/53H7ZWRMxXg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:8087:0:b0:367:3d7c:30df with SMTP id
 q129-20020a818087000000b003673d7c30dfmr16440551ywf.511.1668503936464; Tue, 15
 Nov 2022 01:18:56 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:18:51 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091851.2288237-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: annotate data-race around queue->synflood_warned
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
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

Annotate the lockless read of queue->synflood_warned.

Following xchg() has the needed data-race resolution.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 94024fdc2da1b28af1b3b6e50735bf6b915f861d..0ae291e53eab228ce171cd73abafc009d99b886d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6841,7 +6841,7 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 #endif
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
 
-	if (!queue->synflood_warned && syncookies != 2 &&
+	if (!READ_ONCE(queue->synflood_warned) && syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0) {
 		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
 			net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
-- 
2.38.1.431.g37b22c650d-goog

