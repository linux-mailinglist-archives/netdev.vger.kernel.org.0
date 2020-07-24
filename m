Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0588022C949
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGXPcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:09 -0400
Received: from mail.katalix.com ([3.9.82.81]:56778 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgGXPcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 11:32:08 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id D05B78ADAF;
        Fri, 24 Jul 2020 16:32:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604726; bh=UgSb0iFXmTqnJKlU4S8N/MUH/Vhb8QabiqMjW0CzHEo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=208/9]=20l2tp:=20remove=20BUG_ON
         =20refcount=20value=20in=20l2tp_session_free|Date:=20Fri,=2024=20J
         ul=202020=2016:31:56=20+0100|Message-Id:=20<20200724153157.9366-9-
         tparkin@katalix.com>|In-Reply-To:=20<20200724153157.9366-1-tparkin
         @katalix.com>|References:=20<20200724153157.9366-1-tparkin@katalix
         .com>;
        b=LPA/dXGIJJAlLbxC9Lv/LgnRuTDzQ5oCxrIFeC/7SId7YpwqzoVyyHsKLSv+NFDpH
         ASU/5Oa4mrYB6U1QngrmUy6SEq6fRo/DWq2qa0Auq6Jt16RNrkUA8mg1fdm2pkSRVR
         MKSpt1RfLMofg9khH9Ob3L5Wevc7rFB72VMl31OLuLMNviqx/CoPRHSegdwhTlmaPB
         9OgDSdsQT9wgGdZ7W0ofcYM7ykEL5hSMmvujc1HiaDdlBAdWy3jqbOagPzQvkqq0T4
         GqZhsqb7SB5jzXjd+2eDWglPnkjWg1plfeC9ylASeKAU61QaQ6qnz2jztS49Ku4DJU
         QqRBFpq7Lc8tw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 8/9] l2tp: remove BUG_ON refcount value in l2tp_session_free
Date:   Fri, 24 Jul 2020 16:31:56 +0100
Message-Id: <20200724153157.9366-9-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
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
index e228480fa529..50548c61b91e 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1563,8 +1563,6 @@ void l2tp_session_free(struct l2tp_session *session)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 
-	BUG_ON(refcount_read(&session->ref_count) != 0);
-
 	if (tunnel) {
 		BUG_ON(tunnel->magic != L2TP_TUNNEL_MAGIC);
 		l2tp_tunnel_dec_refcount(tunnel);
-- 
2.17.1

