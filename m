Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9BC22C94F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGXPcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:23 -0400
Received: from mail.katalix.com ([3.9.82.81]:56770 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGXPcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 11:32:06 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4DC788ADAB;
        Fri, 24 Jul 2020 16:32:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604725; bh=7zOz5sbhMR8gJL2wm5U97mY91i9sULUPVYbVPEMgJzo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=204/9]=20l2tp:=20remove=20BUG_ON
         =20in=20l2tp_tunnel_closeall|Date:=20Fri,=2024=20Jul=202020=2016:3
         1:52=20+0100|Message-Id:=20<20200724153157.9366-5-tparkin@katalix.
         com>|In-Reply-To:=20<20200724153157.9366-1-tparkin@katalix.com>|Re
         ferences:=20<20200724153157.9366-1-tparkin@katalix.com>;
        b=TPqMv1K1b8JVx/XzowZn3K0N87P4/ntKvr/it8zTNNNdMrPqC3wX3Gfu4Fs83JQoP
         um703gnNouxelAQPhA69HqEd/0GYTqRWJRcjjuwbKeqQLgPcKVWacvKE7uFNTbe2MW
         7NIXTRxNZug7iyRVUQeqndO+HWiCu1Sjx3KiRAGWlNjvHLnpXaznuPLt4YtrNWfcr/
         XheA++Fu5aaVErD2kH42FkYXZoj8zh4eqG4Eo8F9wHzA5M50kFzWVY3pf9j+6C8QxO
         zLy6T+0Pehc80lV9NKe5wIpAiNkIPeV+UdFnbXybJ8eE0PUGLEV9bgLXoLe1DC7Bd4
         EU4BbDRXVZMVQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 4/9] l2tp: remove BUG_ON in l2tp_tunnel_closeall
Date:   Fri, 24 Jul 2020 16:31:52 +0100
Message-Id: <20200724153157.9366-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
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

