Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7972522879F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgGURl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:58 -0400
Received: from mail.katalix.com ([3.9.82.81]:53294 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730292AbgGURlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:02 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 2575F93B1E;
        Tue, 21 Jul 2020 18:33:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352784; bh=BgsXDsAOWufN5TKnwNP+k419NOyTDkHKo1ZenKmfZz8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2027/29]=20l2tp:=20WARN_ON=20rather=20than=20BUG_ON=20in=20l2t
         p_session_queue_purge|Date:=20Tue,=2021=20Jul=202020=2018:32:19=20
         +0100|Message-Id:=20<20200721173221.4681-28-tparkin@katalix.com>|I
         n-Reply-To:=20<20200721173221.4681-1-tparkin@katalix.com>|Referenc
         es:=20<20200721173221.4681-1-tparkin@katalix.com>;
        b=TeBMrhGCFbImAeW7OR/BtUj0W8SZlxgtC6sv1TsbNZQy5G6MwlamvgPlW4El1+PEC
         luLEQE/STCRHo65j7ldG+CYaWER6zUi3k8i0usYxomXPcihIVXtFVkNji/yPid7Z6c
         wX1yBaYjY1I4wF1b1OhlfqJXDMZQGRAYSwFCDsRZqk5u4+1RePhsvmreHTxKuIwL9b
         LYiKIMC1ckLzncI7NKQMFE6mtVUQi2p263rF14C8DfaADv/KVt9ztxONhFVF5CHJzL
         GN+XXMktHCDlmDkKvLPcQ40DnbynmwzoABiy4xjZHmCNA3eYlHrtOYxe4kVUgwMA6+
         uBZ2qYArpyx8Q==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 27/29] l2tp: WARN_ON rather than BUG_ON in l2tp_session_queue_purge
Date:   Tue, 21 Jul 2020 18:32:19 +0100
Message-Id: <20200721173221.4681-28-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_session_queue_purge is used during session shutdown to drop any
skbs queued for reordering purposes according to L2TP dataplane rules.

The BUG_ON in this function checks the session magic feather in an
attempt to catch lifetime bugs.

Rather than crashing the kernel with a BUG_ON, we can simply WARN_ON and
refuse to do anything more -- in the worst case this could result in a
leak.  However this is highly unlikely given that the session purge only
occurs from codepaths which have obtained the session by means of a lookup
via. the parent tunnel and which check the session "dead" flag to
protect against shutdown races.

While we're here, have l2tp_session_queue_purge return void rather than
an integer, since neither of the callsites checked the return value.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 6be3f2e69efd..c7c513e0b042 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -773,16 +773,19 @@ EXPORT_SYMBOL(l2tp_recv_common);
 
 /* Drop skbs from the session's reorder_q
  */
-static int l2tp_session_queue_purge(struct l2tp_session *session)
+static void l2tp_session_queue_purge(struct l2tp_session *session)
 {
 	struct sk_buff *skb = NULL;
 
-	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
+	if (session->magic != L2TP_SESSION_MAGIC) {
+		WARN_ON(session->magic != L2TP_SESSION_MAGIC);
+		return;
+	}
+
 	while ((skb = skb_dequeue(&session->reorder_q))) {
 		atomic_long_inc(&session->stats.rx_errors);
 		kfree_skb(skb);
 	}
-	return 0;
 }
 
 /* Internal UDP receive frame. Do the real work of receiving an L2TP data frame
-- 
2.17.1

