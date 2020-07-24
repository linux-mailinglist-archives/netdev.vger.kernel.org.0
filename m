Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B731722C951
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgGXPc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:27 -0400
Received: from mail.katalix.com ([3.9.82.81]:56766 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgGXPcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 11:32:06 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 0C3468AD98;
        Fri, 24 Jul 2020 16:32:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604725; bh=4stRypcCnZUsQgOv6yYjGt2325QE5elmiA+15tBpuwU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=202/9]=20l2tp:=20WARN_ON=20rathe
         r=20than=20BUG_ON=20in=20l2tp_dfs_seq_start|Date:=20Fri,=2024=20Ju
         l=202020=2016:31:50=20+0100|Message-Id:=20<20200724153157.9366-3-t
         parkin@katalix.com>|In-Reply-To:=20<20200724153157.9366-1-tparkin@
         katalix.com>|References:=20<20200724153157.9366-1-tparkin@katalix.
         com>;
        b=UwVKtIA4GjIFOk2ZCHHfwhoVPb4Y6ABZ4zvMAoWBI8gsEkiSnM9AUpLPY+9ZQ/Uj0
         3c5R6dZ+gCmFaRYZjcHyWs72BFAFy3tGHqVswHsMD66ACApDObT1Xfn9gqTvh8O8Z3
         WXBxmjn3UmzGHAckpg5uU7DnWc0m02n0a0Lm6IjSZtENqRuIdOYqceE5V1y1XCE9Xj
         FPzLnMB6o9/bt8O5LcULEkxJ3xRszOV0B9JO13khHab5dYimPLS714rLQmzgte6J10
         YNhxH4Mr6t7roZg3IF5iTRdXH2JaHIXKCVHY+OhJZp/VFbSI+VWMGhKKVxwKE+ecY6
         yweAXPNFHWypg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 2/9] l2tp: WARN_ON rather than BUG_ON in l2tp_dfs_seq_start
Date:   Fri, 24 Jul 2020 16:31:50 +0100
Message-Id: <20200724153157.9366-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_dfs_seq_start had a BUG_ON to catch a possible programming error in
l2tp_dfs_seq_open.

Since we can easily bail out of l2tp_dfs_seq_start, prefer to do that
and flag the error with a WARN_ON rather than crashing the kernel.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 72ba83aa0eaf..96cb9601c21b 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -72,7 +72,10 @@ static void *l2tp_dfs_seq_start(struct seq_file *m, loff_t *offs)
 	if (!pos)
 		goto out;
 
-	BUG_ON(!m->private);
+	if (WARN_ON(!m->private)) {
+		pd = NULL;
+		goto out;
+	}
 	pd = m->private;
 
 	if (!pd->tunnel)
-- 
2.17.1

