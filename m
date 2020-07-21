Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1B622879D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGURl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730457AbgGURlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:03 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C24FC0619DB
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:02 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id CB4C493AC0;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352781; bh=vISRnrcsYJEDUQLYKjC+VH4Sfd+G69wD0qdy47ENH90=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2018/29]=20l2tp:=20WARN_ON=20rather=20than=20BUG_ON=20in=20l2t
         p_debugfs.c|Date:=20Tue,=2021=20Jul=202020=2018:32:10=20+0100|Mess
         age-Id:=20<20200721173221.4681-19-tparkin@katalix.com>|In-Reply-To
         :=20<20200721173221.4681-1-tparkin@katalix.com>|References:=20<202
         00721173221.4681-1-tparkin@katalix.com>;
        b=1kPTk3keflvvQfdy5A72u4A2S4nbXwbObYAzJbPPP2ERjNfeYkanXYjWk7zYARXmQ
         xdRTuPbppxCyFYUwI21bUVs3DxlcZI77gLGHWBOYMcuUglSWV4QzKIudahIERd4Emh
         Z1aTTBvGgajSb6p6IlDS/JKuPWJd8dt02ml6p5mgq40lqMxKc1aJx/zHvh9isA2AkF
         n8ha9NyLNgGsthzlzCLEgwwE65/1NdQaG0nXehfbfT3d34R2JQJkZgBB7Xc0O4L7ED
         I4dNFAcn1a+2gulhcewyG4/Xsi1A0S8t5X9ICF7Nnk6793f+yllHAlI/mo7IwmGfUb
         VOZtuPI+W3Ppg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 18/29] l2tp: WARN_ON rather than BUG_ON in l2tp_debugfs.c
Date:   Tue, 21 Jul 2020 18:32:10 +0100
Message-Id: <20200721173221.4681-19-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
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
 net/l2tp/l2tp_debugfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 117a6697da72..800a17b988be 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -72,7 +72,14 @@ static void *l2tp_dfs_seq_start(struct seq_file *m, loff_t *offs)
 	if (!pos)
 		goto out;
 
-	BUG_ON(!m->private);
+	/* Unexpected: m->private is set in l2tp_dfs_seq_open.
+	 * Warn on this and bail out early.
+	 */
+	if (!m->private) {
+		WARN_ON(!m->private);
+		pd = NULL;
+		goto out;
+	}
 	pd = m->private;
 
 	if (!pd->tunnel)
-- 
2.17.1

