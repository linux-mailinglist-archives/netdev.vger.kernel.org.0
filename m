Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953D5228786
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgGURlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730257AbgGURlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:01 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42292C0619DB
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:01 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 6BD4493B22;
        Tue, 21 Jul 2020 18:33:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352784; bh=DgaR+VP4jOl6MJLEesGcIrZHamIaBBkGgom3urP7uM4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2029/29]=20l2tp:=20WARN_ON=20rather=20than=20BUG_ON=20in=20l2t
         p_session_free|Date:=20Tue,=2021=20Jul=202020=2018:32:21=20+0100|M
         essage-Id:=20<20200721173221.4681-30-tparkin@katalix.com>|In-Reply
         -To:=20<20200721173221.4681-1-tparkin@katalix.com>|References:=20<
         20200721173221.4681-1-tparkin@katalix.com>;
        b=JFG9OWpuWSMwyvS+y1pm/+jyqEkpY7m+TcZL883i8OxozdV/rv2UKO2RRavv3h6/2
         tet3E2VPOFLe6cOhmkc6y+2ET4+fZIMT6Gq5KLnBAXh48oqqpeG1b7fTplfaKsAHwa
         4nUb5XsaqRkW8Cf4agotAxaVexCGoDtQw2noRkZWtCMEz38ebvWZEZPQ/d+507qUVC
         plRkiWflRP3z9rLhzOx0tQwo07jbOsRVqFOTMRk047JRg6sCrsiTzxk5hdiGOItDUV
         SAAy03NJf7w3p9pEI1Uh72pATJljeTgIC4/4mM1GO1wcwYxVxLEjrdmYG2sHfUCDqR
         hvlSUOQSJKF5g==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 29/29] l2tp: WARN_ON rather than BUG_ON in l2tp_session_free
Date:   Tue, 21 Jul 2020 18:32:21 +0100
Message-Id: <20200721173221.4681-30-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_session_free called BUG_ON if the tunnel magic feather value wasn't
correct.  The intent of this was to catch lifetime bugs; for example
early tunnel free due to incorrect use of reference counts.

Since the tunnel magic feather being wrong indicates either early free
or structure corruption, we can avoid doing more damage by simply
leaving the tunnel structure alone.  If the tunnel refcount isn't
dropped when it should be, the tunnel instance will remain in the
kernel, resulting in the tunnel structure and socket leaking.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 34dacb14042f..64c4350b8eb4 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1566,8 +1566,10 @@ void l2tp_session_free(struct l2tp_session *session)
 	struct l2tp_tunnel *tunnel = session->tunnel;
 
 	if (tunnel) {
-		BUG_ON(tunnel->magic != L2TP_TUNNEL_MAGIC);
-		l2tp_tunnel_dec_refcount(tunnel);
+		if (tunnel->magic == L2TP_TUNNEL_MAGIC)
+			l2tp_tunnel_dec_refcount(tunnel);
+		else
+			WARN_ON(tunnel->magic != L2TP_TUNNEL_MAGIC);
 	}
 
 	kfree(session);
-- 
2.17.1

