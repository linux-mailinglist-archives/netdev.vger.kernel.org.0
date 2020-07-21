Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415D5228798
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgGURln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:43 -0400
Received: from mail.katalix.com ([3.9.82.81]:53304 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbgGURlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:04 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id E049D93B18;
        Tue, 21 Jul 2020 18:33:03 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352783; bh=pEs8OEBBFqrhca7K1SHsog9u5cb+3RAabV++BzT4vLE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2025/29]=20l2tp:=20don't=20BUG_ON=20session=20magic=20checks=2
         0in=20l2tp_ppp|Date:=20Tue,=2021=20Jul=202020=2018:32:17=20+0100|M
         essage-Id:=20<20200721173221.4681-26-tparkin@katalix.com>|In-Reply
         -To:=20<20200721173221.4681-1-tparkin@katalix.com>|References:=20<
         20200721173221.4681-1-tparkin@katalix.com>;
        b=0IyYIyPSnzxa8jSGB3ftfsUbualD5j86urKQQt3tIdq6ZkIXjb2wZdCHNLtrstpVT
         lxPdEOMU3Z9u8mkCRh3uEJnSp/egDo5DNZzPr7ehn7wS5rlW/kDSUDPMFRjA1TzTZ3
         es0MYGx1Uh1I2uDJwEmYrNU7UBdM5HddoZ6mf6A0fnhef4fw2Qksod47OPsZrklM/1
         jwXrOX34JJmzEirWFjTVdpCuDwMnJMMIzkoksMgXdQ0B9Pmm+muwBPo9THvtt/5U54
         4IyJSg8ZpPor+bBwCwtjZiCx1cTErN21RyHSRv/RMJczRfKYxnY3aQyD2AP7WQOBvE
         WDvqJ3EUA5//g==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 25/29] l2tp: don't BUG_ON session magic checks in l2tp_ppp
Date:   Tue, 21 Jul 2020 18:32:17 +0100
Message-Id: <20200721173221.4681-26-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch advises that WARN_ON and recovery code are preferred over
BUG_ON which crashes the kernel.

l2tp_ppp.c's BUG_ON checks of the l2tp session structure's "magic" field
occur in code paths where it's reasonably easy to recover:

 * In the case of pppol2tp_sock_to_session, we can return NULL and the
   caller will bail out appropriately.  There is no change required to
   any of the callsites of this function since they already handle
   pppol2tp_sock_to_session returning NULL.

 * In the case of pppol2tp_session_destruct we can just avoid
   decrementing the reference count on the suspect session structure.
   In the worst case scenario this results in a memory leak, which is
   preferable to a crash.

Convert these uses of BUG_ON to WARN_ON accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_ppp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index e58fe7e3b884..6cd1a422c426 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -163,8 +163,12 @@ static inline struct l2tp_session *pppol2tp_sock_to_session(struct sock *sk)
 		sock_put(sk);
 		goto out;
 	}
-
-	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
+	if (session->magic != L2TP_SESSION_MAGIC) {
+		WARN_ON(session->magic != L2TP_SESSION_MAGIC);
+		session = NULL;
+		sock_put(sk);
+		goto out;
+	}
 
 out:
 	return session;
@@ -419,8 +423,9 @@ static void pppol2tp_session_destruct(struct sock *sk)
 
 	if (session) {
 		sk->sk_user_data = NULL;
-		BUG_ON(session->magic != L2TP_SESSION_MAGIC);
-		l2tp_session_dec_refcount(session);
+		WARN_ON(session->magic != L2TP_SESSION_MAGIC);
+		if (session->magic == L2TP_SESSION_MAGIC)
+			l2tp_session_dec_refcount(session);
 	}
 }
 
-- 
2.17.1

