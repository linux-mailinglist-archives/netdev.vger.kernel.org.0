Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABAA6293EE
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbiKOJLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiKOJLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:09 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480AA21E2A
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:08 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 4-20020a250104000000b006de5a38d75bso9787418ybb.20
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AQtykxHiwgykFBU1KSjj+ViZJkVO1odUlq/LYoyPTB0=;
        b=VfdPo2+5MUm9/3E4ypg6A/BaODeh//dGMRS3Xfilt8nKLb4tUmeVd7dsAPYupp4qtZ
         4ZSZzwK+ThYnT/YYc2LOmXZNt/2EdYdg09A6Ujp8FuW48Pi1IZZBgtyPRdlGgn5AmahW
         9UAG83Aocw/Xfqryl/Z+BToXgEdMuxml+WuGouZvU+m0bfQQiyxzgnm0IFzGT9yPeKwX
         mTL9UusVcYpDgp0uXvCLyyndgIGo2sbHt97A31ymqm/WYNRTkH0Um+zp438aEd3Lbwg5
         BZI6Br8HokCPHTiSUnRcVNi+WK2qj/0wBke/xc+6pauFxCCSG+43LMjbto+C6YALhqzt
         I+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQtykxHiwgykFBU1KSjj+ViZJkVO1odUlq/LYoyPTB0=;
        b=1Rmf6rYbfAevyFJI2PdDmIipo92gS19P54oIYubniyVt52IDVTSSbiksGYaKuBfzMP
         Qrw4vLYKeV3e2sgpxsK0SRTJ9txumrMkaf6dq8rUkc1O3ep10AkP0gyHSiNQB5fUiVVs
         YBf26jkcfrBDaU4FVnQW4Gw2WfSecEHpXY6K/1Cd9WRvY2wgGIVod0qS/wiTkXtlVeLx
         aEwo+eK2HV6B7BSNTmsFMAsbczlKmQWyZjLwCBCeGHrYmyATC+TMy3rh/QZpr9hu36vu
         8DkAhixi44IMDsf0cNjej+G71CZyrlfP8SiVT9mjnGvmtX0Q/eC3vRXG42FlSEgl9SZm
         d4yQ==
X-Gm-Message-State: ANoB5plTlspqmYIfTCMRbeeNqaCq9zDEuw8KoSPKsFBfu6KLY90O+0vi
        6t554WLwW0IDe91e7DMvoRS6KhJb40j63Q==
X-Google-Smtp-Source: AA0mqf7yC4mF5EHv3j1Lqd4kK0XbFSiUKqrHOA/e3MKf+ApeqWRA9iD4tiV0KGgZau1qKHGSPnlC8e4JBMIh9g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:ae5f:0:b0:377:40d0:a20c with SMTP id
 g31-20020a81ae5f000000b0037740d0a20cmr6564513ywk.132.1668503467195; Tue, 15
 Nov 2022 01:11:07 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:10:57 +0000
In-Reply-To: <20221115091101.2234482-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115091101.2234482-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091101.2234482-3-edumazet@google.com>
Subject: [PATCH net-next 2/6] ipv6: fib6_new_sernum() optimization
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
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

Adopt atomic_try_cmpxchg() which is slightly more efficient.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
---
 net/ipv6/ip6_fib.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 413f66781e50de62d6b20042d84798e7da59165a..2438da5ff6da810d9f612fc66df4d28510f50f10 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -91,13 +91,12 @@ static void fib6_walker_unlink(struct net *net, struct fib6_walker *w)
 
 static int fib6_new_sernum(struct net *net)
 {
-	int new, old;
+	int new, old = atomic_read(&net->ipv6.fib6_sernum);
 
 	do {
-		old = atomic_read(&net->ipv6.fib6_sernum);
 		new = old < INT_MAX ? old + 1 : 1;
-	} while (atomic_cmpxchg(&net->ipv6.fib6_sernum,
-				old, new) != old);
+	} while (!atomic_try_cmpxchg(&net->ipv6.fib6_sernum, &old, new));
+
 	return new;
 }
 
-- 
2.38.1.431.g37b22c650d-goog

