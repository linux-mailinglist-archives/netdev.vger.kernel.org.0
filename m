Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D312F228790
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgGURl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:27 -0400
Received: from mail.katalix.com ([3.9.82.81]:53310 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730524AbgGURlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:05 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4536D93B21;
        Tue, 21 Jul 2020 18:33:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352784; bh=XwFVHrXoi2LKUgtRXW06Nwp9ZdOBAT1ZmxPQTCQwWis=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2028/29]=20l2tp:=20remove=20BUG_ON=20refcount=20value=20in=20l
         2tp_session_free|Date:=20Tue,=2021=20Jul=202020=2018:32:20=20+0100
         |Message-Id:=20<20200721173221.4681-29-tparkin@katalix.com>|In-Rep
         ly-To:=20<20200721173221.4681-1-tparkin@katalix.com>|References:=2
         0<20200721173221.4681-1-tparkin@katalix.com>;
        b=a+GFepqHmg2Blbdeg/lyby83KZUrhYOfgFn/IhxgE4HrNcI3eYnqD5443fLie/CKW
         vREMafCLWWNpK1ZQHgKvXiTUyv+PJBFh4jwzKMUbx5Q75xGHdi8l++f3jwtYivedg2
         okMSvO0aF3vGW+K5FbZRjqx0B5jhFHqT+QDfB9GOqNbpWFabwsGErRYtx8JLvdwxI4
         pYD8evmjjbxeoxcan/ZqcQ6nwuzlYzSNRRRRmRpUuO5LYkm6AuZ0jcpCUnmsr7lTqw
         Pp6gjO+1BLFi5cCHvyKUvhmDw6p7OYJ0QabNGFLZaBZmQpTaHmMq+h7TFmzT5S4TFj
         L86/nKrS5yrkQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 28/29] l2tp: remove BUG_ON refcount value in l2tp_session_free
Date:   Tue, 21 Jul 2020 18:32:20 +0100
Message-Id: <20200721173221.4681-29-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_session_free is only called by l2tp_session_dec_refcount when the
reference count reaches zero, so it's of limited value to validate the
reference count value in l2tp_session_free itself.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index c7c513e0b042..34dacb14042f 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1565,8 +1565,6 @@ void l2tp_session_free(struct l2tp_session *session)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 
-	BUG_ON(refcount_read(&session->ref_count) != 0);
-
 	if (tunnel) {
 		BUG_ON(tunnel->magic != L2TP_TUNNEL_MAGIC);
 		l2tp_tunnel_dec_refcount(tunnel);
-- 
2.17.1

