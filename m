Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB2322878C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgGURlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:20 -0400
Received: from mail.katalix.com ([3.9.82.81]:53314 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730572AbgGURlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:05 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 098D993B1B;
        Tue, 21 Jul 2020 18:33:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352784; bh=QQ1Z+wrVMMMWdxC5/PoJInxa7WnirXzceUHeCROe2MY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2026/29]=20l2tp:=20don't=20BUG_ON=20seqfile=20checks=20in=20l2
         tp_ppp|Date:=20Tue,=2021=20Jul=202020=2018:32:18=20+0100|Message-I
         d:=20<20200721173221.4681-27-tparkin@katalix.com>|In-Reply-To:=20<
         20200721173221.4681-1-tparkin@katalix.com>|References:=20<20200721
         173221.4681-1-tparkin@katalix.com>;
        b=cZUmG44vlBWwdithD/4XIfxpHvOPwMcR3p6QLl9JUUFKVSUDwjN8YfZQWW68JHzmk
         t+g1ZGvxZnEJpte5Z0ys9U1lTZfUBIiAcjhRraicCkfw1smG/WJZDohowxzgwwx5wU
         Y7eNvw377oQA7wVOFEyyif81d3o5l4v7BAytgl9NHUHhGBwhw888LqW/f1NX2Cxja5
         ctu2kbTYOICoOLGqypR67u4MorSa5E5qcA6IUA8l0zmjb4ZhLVzZw9vCkkjr2EmPX/
         qvdZ6XhWZGW/5heb44MJxiYjpxFXF4l+qahn1L6sNzuj3omXO1fc577t4UgpFv4tC/
         5PAr2cIjEOP2Q==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 26/29] l2tp: don't BUG_ON seqfile checks in l2tp_ppp
Date:   Tue, 21 Jul 2020 18:32:18 +0100
Message-Id: <20200721173221.4681-27-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch advises that WARN_ON and recovery code are preferred over
BUG_ON which crashes the kernel.

l2tp_ppp has a BUG_ON check of struct seq_file's private pointer in
pppol2tp_seq_start prior to accessing data through that pointer.

Rather than crashing, we can simply bail out early and return NULL in
order to terminate the seq file processing in much the same way as we do
when reaching the end of tunnel/session instances to render.

Retain a WARN_ON to help trace possible bugs in this area.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_ppp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 6cd1a422c426..a58e0cc66e43 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1479,7 +1479,12 @@ static void *pppol2tp_seq_start(struct seq_file *m, loff_t *offs)
 	if (!pos)
 		goto out;
 
-	BUG_ON(!m->private);
+	if (!m->private) {
+		WARN_ON(!m->private);
+		pd = NULL;
+		goto out;
+	}
+
 	pd = m->private;
 	net = seq_file_net(m);
 
-- 
2.17.1

