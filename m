Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C93926FA86
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIRKX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRKX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:23:27 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68414C06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:23:27 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id E6F8486B43;
        Fri, 18 Sep 2020 11:23:24 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1600424605; bh=0tRMACoWqGgJub+9sYesY3HfZaZokO0BodaA/U+TEc8=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=201/1]=20l2tp:=20fix=
         20up=20inconsistent=20rx/tx=20statistics|Date:=20Fri,=2018=20Sep=2
         02020=2011:23:21=20+0100|Message-Id:=20<20200918102321.7036-1-tpar
         kin@katalix.com>;
        b=mW3Ipoaia9OZmwm5+RvsZUnP7N0nFfkAduro/uEjybjnC23XsZiu0YYX8bw1jeX5K
         XYy0fSmrg5jV8FogchLa2M4sy5y4ftUassM5Tr9wKDRXMRDtb00QTxxrobirEXCSw/
         qPHRCbtnKXR2tJE8E4oAaX1mwLugmbaIk0doK+PstfSF+2GuI+tbk2wPf4no5424Q6
         9AJmaTexxLk1kbr+nI8OxTvmDS8Pkpc/YdBj4a4p/M6mDCbMsdHRiFPBEkvr1jLLwV
         eEr58yhq94s2vrfDzLb/p5fFqQB1B6lo1rFesR9Os+Wd7SPb/xysa8QMuCQ1//Fzvh
         XTcxkAZ4JZRTw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 1/1] l2tp: fix up inconsistent rx/tx statistics
Date:   Fri, 18 Sep 2020 11:23:21 +0100
Message-Id: <20200918102321.7036-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically L2TP core statistics count the L2TP header in the
per-session and per-tunnel byte counts tracked for transmission and
receipt.

Now that l2tp_xmit_skb updates tx stats, it is necessary for
l2tp_xmit_core to pass out the length of the transmitted packet so that
the statistics can be updated correctly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7de05be4fc33..7be5103ff2a8 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1006,7 +1006,7 @@ static int l2tp_xmit_queue(struct l2tp_tunnel *tunnel, struct sk_buff *skb, stru
 	return err >= 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
 }
 
-static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb)
+static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, unsigned int *len)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 	unsigned int data_len = skb->len;
@@ -1054,6 +1054,11 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb)
 		goto out_unlock;
 	}
 
+	/* Report transmitted length before we add encap header, which keeps
+	 * statistics consistent for both UDP and IP encap tx/rx paths.
+	 */
+	*len = skb->len;
+
 	inet = inet_sk(sk);
 	switch (tunnel->encap) {
 	case L2TP_ENCAPTYPE_UDP:
@@ -1095,10 +1100,10 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb)
  */
 int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
 {
-	unsigned int len = skb->len;
+	unsigned int len = 0;
 	int ret;
 
-	ret = l2tp_xmit_core(session, skb);
+	ret = l2tp_xmit_core(session, skb, &len);
 	if (ret == NET_XMIT_SUCCESS) {
 		atomic_long_inc(&session->tunnel->stats.tx_packets);
 		atomic_long_add(len, &session->tunnel->stats.tx_bytes);
-- 
2.17.1

