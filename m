Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD45345EE2
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhCWNER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhCWNDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 09:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FB2C6192D;
        Tue, 23 Mar 2021 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616504623;
        bh=zJzf06RB17EMVuvWgntxsZAzxqtJqr53ucVYYUuK8EU=;
        h=From:To:Cc:Subject:Date:From;
        b=cdzpNOFiRFj1xqywlgrtaCm1x2O3E9/6J1vYZ+i3Xn9uIZpSjvmY7wU0ZniYgINSS
         IOQIsmi4ezhBN9t+2EB4bJoz6PXZriiQ7/XE15WVoBqQSZks0Kn43n1aYZ81QJNeO0
         OdUyMQwDyeNTlBzOBydQdboMkFsZzLi1K7tvXC1EwevheelgHtTFgO2WlbpE4t7Qpw
         inVYe1+v8izZC7jVhJB0wUwi79Fv6KOkmEz7lliOyeRHGk0FcwIz4W06dczEaksbAJ
         ID8dY92zjNGV9h7Xl36klqqwRFcTDucMBIBmKMnKrQ6a4lTdqEyKHGBm4o3Y2zWJeW
         jZGEl5QOMsEyQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rhashtable: avoid -Wrestrict warning on overlapping sprintf output
Date:   Tue, 23 Mar 2021 14:03:32 +0100
Message-Id: <20210323130338.2213241-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

sprintf() is declared with a restrict keyword to not allow input and
output to point to the same buffer:

lib/test_rhashtable.c: In function 'print_ht':
lib/test_rhashtable.c:504:4: error: 'sprintf' argument 3 overlaps destination object 'buff' [-Werror=restrict]
  504 |    sprintf(buff, "%s\nbucket[%d] -> ", buff, i);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/test_rhashtable.c:489:7: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
  489 |  char buff[512] = "";
      |       ^~~~

Rework this function to remember the last offset instead to
avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/test_rhashtable.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index 76c607ee6db5..5a1dd4736b56 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -487,6 +487,7 @@ static unsigned int __init print_ht(struct rhltable *rhlt)
 	struct rhashtable *ht;
 	const struct bucket_table *tbl;
 	char buff[512] = "";
+	int offset = 0;
 	unsigned int i, cnt = 0;
 
 	ht = &rhlt->ht;
@@ -501,18 +502,18 @@ static unsigned int __init print_ht(struct rhltable *rhlt)
 		next = !rht_is_a_nulls(pos) ? rht_dereference(pos->next, ht) : NULL;
 
 		if (!rht_is_a_nulls(pos)) {
-			sprintf(buff, "%s\nbucket[%d] -> ", buff, i);
+			offset += sprintf(buff + offset, "\nbucket[%d] -> ", i);
 		}
 
 		while (!rht_is_a_nulls(pos)) {
 			struct rhlist_head *list = container_of(pos, struct rhlist_head, rhead);
-			sprintf(buff, "%s[[", buff);
+			offset += sprintf(buff + offset, "[[");
 			do {
 				pos = &list->rhead;
 				list = rht_dereference(list->next, ht);
 				p = rht_obj(ht, pos);
 
-				sprintf(buff, "%s val %d (tid=%d)%s", buff, p->value.id, p->value.tid,
+				offset += sprintf(buff + offset, " val %d (tid=%d)%s", p->value.id, p->value.tid,
 					list? ", " : " ");
 				cnt++;
 			} while (list);
@@ -521,7 +522,7 @@ static unsigned int __init print_ht(struct rhltable *rhlt)
 			next = !rht_is_a_nulls(pos) ?
 				rht_dereference(pos->next, ht) : NULL;
 
-			sprintf(buff, "%s]]%s", buff, !rht_is_a_nulls(pos) ? " -> " : "");
+			offset += sprintf(buff + offset, "]]%s", !rht_is_a_nulls(pos) ? " -> " : "");
 		}
 	}
 	printk(KERN_ERR "\n---- ht: ----%s\n-------------\n", buff);
-- 
2.29.2

