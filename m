Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6376B22C94B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGXPcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:14 -0400
Received: from mail.katalix.com ([3.9.82.81]:56776 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgGXPcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 11:32:07 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id AE3198ADAE;
        Fri, 24 Jul 2020 16:32:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604725; bh=SflVZU7cgcDGkMu7ECuW7o3uatEUr22DOwT9l2VSVKw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=207/9]=20l2tp:=20WARN_ON=20rathe
         r=20than=20BUG_ON=20in=20l2tp_session_queue_purge|Date:=20Fri,=202
         4=20Jul=202020=2016:31:55=20+0100|Message-Id:=20<20200724153157.93
         66-8-tparkin@katalix.com>|In-Reply-To:=20<20200724153157.9366-1-tp
         arkin@katalix.com>|References:=20<20200724153157.9366-1-tparkin@ka
         talix.com>;
        b=sSk8/qBRpFW1oOPuT2i2OktT/Au3DJPwDAfAWnSC1D23Y1/poJUdjm1wzmVQmcNEW
         cR+qn1bnYPm5rVTyIciwvk0EDDB4Jk/Go/oYFPkw39WrkUAGxal2hUcW5B6rpBKBup
         V5yxvIfeTPU2mD2zxoRb34bqsSNh7FLB6OUWGcrl4wxH0DW/4nUgAT98btelFXYJyX
         OxfsT2CNfVZTx9RsnFdRZ7i+2Auqu3id13FwnW6Hqerah2Q7ITGor5/Sxdvaqgm1an
         EClv4yuECf9smLGeg9FEXEpXTW5rOGZfU2nmscIWI5iDAg8NHZdGeljGhMD8+PNb1G
         +UEDy7eZl+1Sw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 7/9] l2tp: WARN_ON rather than BUG_ON in l2tp_session_queue_purge
Date:   Fri, 24 Jul 2020 16:31:55 +0100
Message-Id: <20200724153157.9366-8-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
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
 net/l2tp/l2tp_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 6be3f2e69efd..e228480fa529 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -773,16 +773,17 @@ EXPORT_SYMBOL(l2tp_recv_common);
 
 /* Drop skbs from the session's reorder_q
  */
-static int l2tp_session_queue_purge(struct l2tp_session *session)
+static void l2tp_session_queue_purge(struct l2tp_session *session)
 {
 	struct sk_buff *skb = NULL;
 
-	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
+	if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
+		return;
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

