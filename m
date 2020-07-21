Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F8A22878A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgGURlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:15 -0400
Received: from mail.katalix.com ([3.9.82.81]:53288 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbgGURlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:03 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 6466D93B0D;
        Tue, 21 Jul 2020 18:33:02 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352782; bh=BgCAfeclx3i5dPuC5ebbz1wVAivfMBMt8Wh3U7nzZjE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2022/29]=20l2tp:=20cleanup=20kzalloc=20calls|Date:=20Tue,=2021
         =20Jul=202020=2018:32:14=20+0100|Message-Id:=20<20200721173221.468
         1-23-tparkin@katalix.com>|In-Reply-To:=20<20200721173221.4681-1-tp
         arkin@katalix.com>|References:=20<20200721173221.4681-1-tparkin@ka
         talix.com>;
        b=2lpn2vkboVXZrnAqm/wRJrYLT+WZk+n08TsznPv1qK4nNO9zBel483qRzeuIo+5mr
         wGO92mnLwgymn5ZK/UD1XflCIqwRNShFTxNfgOIPm57zCqwlH+N42iFoXqAc+QwZJ/
         cbHR/DmcX3IRSWR087slQUTak6U88Ys4WWZvlI2c/WC1HY/r+WKGEBML2XMIUYxmhZ
         qTf8jYr6kSu+2ELwPpzKiq69y+hysRXMvCtRDb2IsIAIDGl+kKRo6PfWrvvR1lA0qU
         kDjnYoTEgYiIf6B2A+i7SoLWwEjtI/q9WvIMWde5gsoMDu3eTH5qI7wenT6LWA7uyh
         YG8VL9V1mNPCQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 22/29] l2tp: cleanup kzalloc calls
Date:   Tue, 21 Jul 2020 18:32:14 +0100
Message-Id: <20200721173221.4681-23-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing "sizeof(struct blah)" in kzalloc calls is less readable,
potentially prone to future bugs if the type of the pointer is changed,
and triggers checkpatch warnings.

Tweak the kzalloc calls in l2tp which use this form to avoid the
warning.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 4973a0f035e3..b871cceeff7c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1410,7 +1410,7 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	if (cfg)
 		encap = cfg->encap;
 
-	tunnel = kzalloc(sizeof(struct l2tp_tunnel), GFP_KERNEL);
+	tunnel = kzalloc(sizeof(*tunnel), GFP_KERNEL);
 	if (!tunnel) {
 		err = -ENOMEM;
 		goto err;
@@ -1647,7 +1647,7 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 {
 	struct l2tp_session *session;
 
-	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
+	session = kzalloc(sizeof(*session) + priv_size, GFP_KERNEL);
 	if (session) {
 		session->magic = L2TP_SESSION_MAGIC;
 		session->tunnel = tunnel;
-- 
2.17.1

