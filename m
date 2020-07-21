Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6A4228785
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgGURlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730241AbgGURlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:01 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F09CC0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:01 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id AAE8B93B17;
        Tue, 21 Jul 2020 18:33:03 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352783; bh=7zOz5sbhMR8gJL2wm5U97mY91i9sULUPVYbVPEMgJzo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2024/29]=20l2tp:=20remove=20BUG_ON=20in=20l2tp_tunnel_closeall
         |Date:=20Tue,=2021=20Jul=202020=2018:32:16=20+0100|Message-Id:=20<
         20200721173221.4681-25-tparkin@katalix.com>|In-Reply-To:=20<202007
         21173221.4681-1-tparkin@katalix.com>|References:=20<20200721173221
         .4681-1-tparkin@katalix.com>;
        b=HS1GXtH2QY12sfNmzDrxh4MSG1twjs3if4/ybFR2UhZGuXpOaCYQNN4u1JdoicXv0
         q0wINACI07GYMsxQogSp1Gwd4Wa3SpdLJDdLK+lXGXu7fP3m1i9kdTzWmlMDb329AK
         m6GJ3sSlUSpcBVcq5Nh2zKdQnBL8TcrT30nvhcZA7RPcfg7j0gc2raS9h5gbtXSiJn
         skjhQLrJr+8IY124hVc9z/e8H50hk7fUauLLLXURT4pnxXH8OVRQjp4MzS0vwXhziN
         yJ5Ez6pufQ0kcsqzHQb9t66zrwNWP2A40LDtfaDodOUKstjoFX+aHjMgc5tg2emFdl
         yq6vBZxaxU8HQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 24/29] l2tp: remove BUG_ON in l2tp_tunnel_closeall
Date:   Tue, 21 Jul 2020 18:32:16 +0100
Message-Id: <20200721173221.4681-25-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_tunnel_closeall is only called from l2tp_core.c, and it's easy
to statically analyse the code path calling it to validate that it
should never be passed a NULL tunnel pointer.

Having a BUG_ON checking the tunnel pointer triggers a checkpatch
warning.  Since the BUG_ON is of no value, remove it to avoid the
warning.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a1ed8baa5aaa..6be3f2e69efd 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1188,8 +1188,6 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 	struct hlist_node *tmp;
 	struct l2tp_session *session;
 
-	BUG_ON(!tunnel);
-
 	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: closing all sessions...\n",
 		  tunnel->name);
 
-- 
2.17.1

