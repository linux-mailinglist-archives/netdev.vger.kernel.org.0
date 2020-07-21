Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1F12287A1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbgGURmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbgGURlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:02 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EACBC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:02 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 9539493B0E;
        Tue, 21 Jul 2020 18:33:02 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352783; bh=ue9mOAv1pdlNVez+dhAaSTApDx9q/qLQ4c9l0kwiYAM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2023/29]=20l2tp:=20remove=20BUG_ON=20in=20l2tp_session_queue_p
         urge|Date:=20Tue,=2021=20Jul=202020=2018:32:15=20+0100|Message-Id:
         =20<20200721173221.4681-24-tparkin@katalix.com>|In-Reply-To:=20<20
         200721173221.4681-1-tparkin@katalix.com>|References:=20<2020072117
         3221.4681-1-tparkin@katalix.com>;
        b=XYahRuRr+aW0SbooKQvsrQxTlHCLjgj1RWh8ZT4sYcIwEvYblfS1xve8l8BP2hiCU
         qa5o/dTIe8xUo3Dnp3kDhpUuzkHVN3/wUariGsJgl/YZzWvx5uEbepnQuKvttdeTGr
         HoHyUeeeTpp+8Wd+VW/seKVKQyxL2vlNqy6vsgPtHthBtzv4yKqbTPKBjg9jh373YP
         B4qqbS9pZWn/MLqmcMC+0jvsjQVd+C8bCW0OOw1aPe5gEWoUB2oye6aCYogAJd5xMu
         h+9xdueakVvSteoKglyd82Tj2Zytn25GLCavhhZDG3p5VKrhIQYDHBpQP06LAS34Lu
         tCn6dhMfz7kZQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 23/29] l2tp: remove BUG_ON in l2tp_session_queue_purge
Date:   Tue, 21 Jul 2020 18:32:15 +0100
Message-Id: <20200721173221.4681-24-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_session_queue_purge is only called from l2tp_core.c, and it's easy
to statically analyse the code paths calling it to validate that it
should never be passed a NULL session pointer.

Having a BUG_ON checking the session pointer triggers a checkpatch
warning.  Since the BUG_ON is of no value, remove it to avoid the
warning.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index b871cceeff7c..a1ed8baa5aaa 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -777,7 +777,6 @@ static int l2tp_session_queue_purge(struct l2tp_session *session)
 {
 	struct sk_buff *skb = NULL;
 
-	BUG_ON(!session);
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
 	while ((skb = skb_dequeue(&session->reorder_q))) {
 		atomic_long_inc(&session->stats.rx_errors);
-- 
2.17.1

