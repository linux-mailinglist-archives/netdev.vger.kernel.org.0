Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3708325BDEA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgICIzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:55:18 -0400
Received: from mail.katalix.com ([3.9.82.81]:42260 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgICIzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:55:09 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 5AE8D86C66;
        Thu,  3 Sep 2020 09:55:08 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599123308; bh=VEXEUb+/oqevL+R8UCQD7uxoPxCgimpGygm9z3+Pjms=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=206/6]=20l2tp:=20avoi
         d=20duplicated=20code=20in=20l2tp_tunnel_closeall|Date:=20Thu,=20=
         203=20Sep=202020=2009:54:52=20+0100|Message-Id:=20<20200903085452.
         9487-7-tparkin@katalix.com>|In-Reply-To:=20<20200903085452.9487-1-
         tparkin@katalix.com>|References:=20<20200903085452.9487-1-tparkin@
         katalix.com>;
        b=ORVNv6uQFXlPWEipAhuIGUXMb54XuU5RqfgWmEYgLsNEqj+AqWsBD2iIOpa6Jmq6H
         dXuWwQ1oNW/3GfEdoMhqSQMSkY68gLGwHbNB2bU2EuE9ZhRTJyY/+alwmrzNH/wEMS
         LnPmGrKDu84g3hKzaA8BCXSvnvHL/YiWK5S01o2RL+JidwzWyI+gzrn07MvJSiDwNI
         +nsjHO4CKA2qLMGYQ22ZID+bENB+mdR1iF/GpLDCEwWTKy1JhHK14Tdg7+uAzuCjOP
         3+s/b7mAR1uKkwUWoxyR5qMOHb3Wnemm7c3CPI7udARmsLg9iyGFGkyZLGiN9RrxAw
         8HJazh2RB6+Xw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 6/6] l2tp: avoid duplicated code in l2tp_tunnel_closeall
Date:   Thu,  3 Sep 2020 09:54:52 +0100
Message-Id: <20200903085452.9487-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903085452.9487-1-tparkin@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_tunnel_closeall is called as a part of tunnel shutdown in order to
close all the sessions held by the tunnel.  The code it uses to close a
session duplicates what l2tp_session_delete does.

Rather than duplicating the code, have l2tp_tunnel_closeall call
l2tp_session_delete instead.

This involves a very minor change to locking in l2tp_tunnel_closeall.
Previously, l2tp_tunnel_closeall checked the session "dead" flag while
holding tunnel->hlist_lock.  This allowed for the code to step to the
next session in the list without releasing the lock if the current
session happened to be in the process of closing already.

By calling l2tp_session_delete instead, l2tp_tunnel_closeall must now
drop and regain the hlist lock for each session in the tunnel list.
Given that the likelihood of a session being in the process of closing
when the tunnel is closed, it seems worth this very minor potential
loss of efficiency to avoid duplication of the session delete code.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index b02b3cc67df0..7de05be4fc33 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1191,22 +1191,10 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 again:
 		hlist_for_each_safe(walk, tmp, &tunnel->session_hlist[hash]) {
 			session = hlist_entry(walk, struct l2tp_session, hlist);
-
 			hlist_del_init(&session->hlist);
 
-			if (test_and_set_bit(0, &session->dead))
-				goto again;
-
 			write_unlock_bh(&tunnel->hlist_lock);
-
-			l2tp_session_unhash(session);
-			l2tp_session_queue_purge(session);
-
-			if (session->session_close)
-				(*session->session_close)(session);
-
-			l2tp_session_dec_refcount(session);
-
+			l2tp_session_delete(session);
 			write_lock_bh(&tunnel->hlist_lock);
 
 			/* Now restart from the beginning of this hash
-- 
2.17.1

