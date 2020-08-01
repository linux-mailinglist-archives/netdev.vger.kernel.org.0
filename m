Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D36A234F61
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 04:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgHACJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 22:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHACJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 22:09:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C325C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 19:09:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x10so21809523ybj.19
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 19:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a52V4Kdhy4rgB5aYktu9ijZu4cJb8Jp2kCo0109Mb1A=;
        b=BoOu3o9guxB8PhIKD0pKz8HNgp4bPriNfbuaxNzNq+GFUY5w81dxTMMY/e0Jl2ETnd
         RMlLRWXCOz/RXHzsHec9b4uDS8xpEyL/MbMNqB6YEn+m6Pns2R9t+iVYZFI0M+24jIGd
         JtHvY/xYnbEzVIB8YNjdnJ4Kk78hUD8G/WGxfi+ffGNBCVjpR40xvFsPbY6veJBoyePg
         9gqqt2J9cer8tsmPDHqk30RDy8tWwElUpdcVMH3z+c9dR2of9Z9ERe8v0okwFobDfDSV
         f5Ncj5yGp8ozUn+NRSIYH3nHjejK2R3h5qwavNfwfuAnOiI1WF8WMBAf4OaMMtDL23g0
         uy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a52V4Kdhy4rgB5aYktu9ijZu4cJb8Jp2kCo0109Mb1A=;
        b=L/jbM2i886WXJLsVvYpbYBTVpNbIWg8/imAd/B9hTLNy2GNQL335GR0jd37fff6aY8
         cDcRaznr/ze4wnNhDaHpq7BojMymkbRfXTbjPJvs7ihyLwJ39yLEJ8gY+AOXdOFxR1zt
         ewkJhxlh5bPTCu66KbxTD4rZeJfFE0ohqIT8d1iL/YA6pFPNlopHA7Xo5OhXj+f8hIZT
         1oj93OJxf3P3ejCOpBDmgIiCIzSHfMfSKM5NGa4zCxvLPeuZAPUTHk0r8eczVHcEIcLS
         xIdJAM21dSnot7vqyqamj1NNCngCU++Phngh6HbHE5X+I95+ygA+4Uk0WGLRk/jG+aJK
         M9/A==
X-Gm-Message-State: AOAM531H3DgLQ0QcJeNudjLoN4Q+J0xIlJq6A+EHAQjx3FOOr9jsiZA1
        apxl1VNP5qD9V5YLyE3C+6ur5FWD6GglAQ==
X-Google-Smtp-Source: ABdhPJzwR7ozcjUz7S2lO1HXossFTaxUjhYMa231D1Aef0OGiL3T1I4aYCEC0EQjNkfmMmcV5Np6e46UKR6TCg==
X-Received: by 2002:a25:38c5:: with SMTP id f188mr10171240yba.132.1596247772383;
 Fri, 31 Jul 2020 19:09:32 -0700 (PDT)
Date:   Fri, 31 Jul 2020 19:09:29 -0700
Message-Id: <20200801020929.3000802-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH net-next] tcp: fix build fong CONFIG_MPTCP=n
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes these errors:

net/ipv4/syncookies.c: In function 'tcp_get_cookie_sock':
net/ipv4/syncookies.c:216:19: error: 'struct tcp_request_sock' has no
member named 'drop_req'
  216 |   if (tcp_rsk(req)->drop_req) {
      |                   ^~
net/ipv4/syncookies.c: In function 'cookie_tcp_reqsk_alloc':
net/ipv4/syncookies.c:289:27: warning: unused variable 'treq'
[-Wunused-variable]
  289 |  struct tcp_request_sock *treq;
      |                           ^~~~
make[3]: *** [scripts/Makefile.build:280: net/ipv4/syncookies.o] Error 1
make[3]: *** Waiting for unfinished jobs....

Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
---
 net/ipv4/syncookies.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 11b20474be8310d7070750a1c7b4013f2fba2f55..f0794f0232bae749244fff35d8b96b1f561a5e87 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -213,7 +213,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 		tcp_sk(child)->tsoffset = tsoff;
 		sock_rps_save_rxhash(child, skb);
 
-		if (tcp_rsk(req)->drop_req) {
+		if (rsk_drop_req(req)) {
 			refcount_set(&req->rsk_refcnt, 2);
 			return child;
 		}
@@ -286,10 +286,11 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 					    struct sock *sk,
 					    struct sk_buff *skb)
 {
-	struct tcp_request_sock *treq;
 	struct request_sock *req;
 
 #ifdef CONFIG_MPTCP
+	struct tcp_request_sock *treq;
+
 	if (sk_is_mptcp(sk))
 		ops = &mptcp_subflow_request_sock_ops;
 #endif
-- 
2.28.0.163.g6104cc2f0b6-goog

