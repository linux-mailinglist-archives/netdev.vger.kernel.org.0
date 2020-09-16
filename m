Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CD426C86C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgIPSs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgIPSqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:46:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9830221EB;
        Wed, 16 Sep 2020 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600281967;
        bh=/HpLIcbRVuD2ycvpBlOy4OEqMVgIAQBp4R33DdeUlQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wP0aRCB1uK+qdp8y7T3xK4Wtdz9pxXu+PGs5sgQ8WRlMrZkOOnk3vg7R/bd1OBtMg
         DUQg+x3Ek81vr/5LEGAbZMcLwbxJjXlikFz5GQU77hOZdOdP9Wsq4aDjzlvmPpIHxJ
         ++eL57a4FFpQoq1BMyorPg4yb7RwjKOIjTF4bQus=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/7] net: un-hide lockdep_sock_is_held() for !LOCKDEP
Date:   Wed, 16 Sep 2020 11:45:24 -0700
Message-Id: <20200916184528.498184-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916184528.498184-1-kuba@kernel.org>
References: <20200916184528.498184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're trying to make LOCKDEP-related function declarations
visible to the compiler and depend on dead code elimination
to remove them.

Un-hide lockdep_sock_is_held().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/sock.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index eaa5cac5e836..1c67b1297a72 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1566,13 +1566,11 @@ do {									\
 	lockdep_init_map(&(sk)->sk_lock.dep_map, (name), (key), 0);	\
 } while (0)
 
-#ifdef CONFIG_LOCKDEP
 static inline bool lockdep_sock_is_held(const struct sock *sk)
 {
 	return lockdep_is_held(&sk->sk_lock) ||
 	       lockdep_is_held(&sk->sk_lock.slock);
 }
-#endif
 
 void lock_sock_nested(struct sock *sk, int subclass);
 
-- 
2.26.2

