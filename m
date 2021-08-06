Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8AD3E2358
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 08:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243369AbhHFGis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 02:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhHFGir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 02:38:47 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2F8C061798;
        Thu,  5 Aug 2021 23:38:32 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628231910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SbevIza4EhMSBMVlDXsk7z2l6BXlmPukSRKdAQD1lug=;
        b=ddNGYfZJz3UMAEfpBMCPrl5drFdErz6UokOO+ZmhNKnRA848g1+P+at0VM14Shzf3Vv5Ii
        PfZmNYw7R5ekART9vkQ8IvcZ6HODhvnB50lTET6u5bcWKMMlTMoQkUHzSXlRsknshKUHxP
        wHwyFErAWymFU0SMts9MllntxtgOSlk=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: sock: add the case if sk is NULL
Date:   Fri,  6 Aug 2021 14:38:15 +0800
Message-Id: <20210806063815.21541-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the case if sk is NULL in sock_{put, hold},
The caller is free to use it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/sock.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6e761451c927..8821ec0d4147 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -699,7 +699,8 @@ static inline bool __sk_del_node_init(struct sock *sk)
 
 static __always_inline void sock_hold(struct sock *sk)
 {
-	refcount_inc(&sk->sk_refcnt);
+	if (sk)
+		refcount_inc(&sk->sk_refcnt);
 }
 
 /* Ungrab socket in the context, which assumes that socket refcnt
@@ -1811,7 +1812,7 @@ void sock_init_data(struct socket *sock, struct sock *sk);
 /* Ungrab socket and destroy it, if it was the last reference. */
 static inline void sock_put(struct sock *sk)
 {
-	if (refcount_dec_and_test(&sk->sk_refcnt))
+	if (sk && refcount_dec_and_test(&sk->sk_refcnt))
 		sk_free(sk);
 }
 /* Generic version of sock_put(), dealing with all sockets
-- 
2.32.0

