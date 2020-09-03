Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0102625BDE9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgICIzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:55:08 -0400
Received: from mail.katalix.com ([3.9.82.81]:42250 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgICIzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:55:07 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 167D086C71;
        Thu,  3 Sep 2020 09:55:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599123305; bh=PTBEx0iwJaF/IziJNTk93viL8CQz2z9UiXUweD8PwE0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=202/6]=20l2tp:=20drop
         =20data_len=20argument=20from=20l2tp_xmit_core|Date:=20Thu,=20=203
         =20Sep=202020=2009:54:48=20+0100|Message-Id:=20<20200903085452.948
         7-3-tparkin@katalix.com>|In-Reply-To:=20<20200903085452.9487-1-tpa
         rkin@katalix.com>|References:=20<20200903085452.9487-1-tparkin@kat
         alix.com>;
        b=SgeeKOraFqcxOg+iPfY2ddnHMIiQEtriP99sw4wqhYcrkCXk38zGW4A+mqL1uYh4E
         O78ck2KCi19J3HSshSmdxcGZnCgjLnebOVqUHCANCNGnb7FRnGC9Vf/OWSw/+fDG+7
         RYeZjUdG7HTmVQQY8cc0xUvlB/H0qRcIvU7RPA3dX/P7AdrRGvMriWNLkFX8BCfCRu
         YglcnqIyjwm3UfRdGo8msU7xvWVuvZvg0XHojwga+3/dV3XQe/gu0bN8ni7ZdmNszV
         J+TJyqfiIK0waegy5GiH+p4WPXXH83sbX5nUwQEz2Rx/waPi1MFF/lNb511N1ORgaD
         ZSHkp5Pcoc8cw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 2/6] l2tp: drop data_len argument from l2tp_xmit_core
Date:   Thu,  3 Sep 2020 09:54:48 +0100
Message-Id: <20200903085452.9487-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903085452.9487-1-tparkin@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data_len argument passed to l2tp_xmit_core is no longer used, so
remove it.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index c95b58b2ab3c..4a8fb285fada 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -985,8 +985,7 @@ static int l2tp_build_l2tpv3_header(struct l2tp_session *session, void *buf)
 	return bufp - optr;
 }
 
-static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
-			   struct flowi *fl, size_t data_len)
+static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, struct flowi *fl)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 	unsigned int len = skb->len;
@@ -1098,7 +1097,7 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
 		break;
 	}
 
-	l2tp_xmit_core(session, skb, fl, data_len);
+	l2tp_xmit_core(session, skb, fl);
 out_unlock:
 	bh_unlock_sock(sk);
 
-- 
2.17.1

