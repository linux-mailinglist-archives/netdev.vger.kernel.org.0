Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0415D22C946
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgGXPcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgGXPcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:32:06 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 939E7C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 08:32:06 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 6DC528ADAC;
        Fri, 24 Jul 2020 16:32:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604725; bh=jhuDh8WrnW9oxZDGB4SAf6xPABJ8SsnCRkB6Npip0a4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=205/9]=20l2tp:=20don't=20BUG_ON=
         20session=20magic=20checks=20in=20l2tp_ppp|Date:=20Fri,=2024=20Jul
         =202020=2016:31:53=20+0100|Message-Id:=20<20200724153157.9366-6-tp
         arkin@katalix.com>|In-Reply-To:=20<20200724153157.9366-1-tparkin@k
         atalix.com>|References:=20<20200724153157.9366-1-tparkin@katalix.c
         om>;
        b=xG2FjMTN7pT3PFgt2trzdmyBD4nl9tWkOEd2Fj/pJvsXz0IAyuuHAI7QgWfAuThyG
         dVDLfzP1z2mpBUEFOnm3cAU8s1lcCMwe4RofKKC39Xue3Pr+vYw+82MRLoLubLo6DT
         cBa+U0ypIlRy8x4v6YZ0UYA9t+DPfZQpehBEH54NF4GjtM1deyAiKVL9Rp7+jKioDf
         oykuAw58Zi2m0WeR0CA0ywBcGUl/TuB1Xv3aY1ih15Md4gfaB5uSg8TNaBvMVOTosx
         qAR4g9lyEIhvhXkMm1clzkrerthwS/befveqQxnoofd469EAeVmlnVCBKv2Brn9A94
         Q1lBr1wRsCDKw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 5/9] l2tp: don't BUG_ON session magic checks in l2tp_ppp
Date:   Fri, 24 Jul 2020 16:31:53 +0100
Message-Id: <20200724153157.9366-6-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
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
 net/l2tp/l2tp_ppp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index e58fe7e3b884..3b6613cfef48 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -163,8 +163,11 @@ static inline struct l2tp_session *pppol2tp_sock_to_session(struct sock *sk)
 		sock_put(sk);
 		goto out;
 	}
-
-	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
+	if (WARN_ON(session->magic != L2TP_SESSION_MAGIC)) {
+		session = NULL;
+		sock_put(sk);
+		goto out;
+	}
 
 out:
 	return session;
@@ -419,7 +422,8 @@ static void pppol2tp_session_destruct(struct sock *sk)
 
 	if (session) {
 		sk->sk_user_data = NULL;
-		BUG_ON(session->magic != L2TP_SESSION_MAGIC);
+		if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
+			return;
 		l2tp_session_dec_refcount(session);
 	}
 }
-- 
2.17.1

