Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7871C96C4D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfHTWdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37018 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731048AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=f4E12JJ1H4Mj6tfyP9JFiMFUAEca/7EWznYbpU1HG3Q=; b=ZxazYOy4zndTg6RyyOaXVdLO8/
        ThsuyQ2BLm9z7oi0n5EWUXKDtO0m8mT4iEYSqMkqETOyTVxQO/h2QpJ3iKq/+cgq3o9VgPpOnDVEj
        lrq6YpOZ0a6t/HwoEsISfONNqmbYJ4EogfjY+rf/tOuVL2FnQrnp3B3lCZvCZ7Rmn8bz23prZrhnN
        UPtxpTuWY5ua2cu15ql/1SlmEzeuANGZq4ebc+7CEdFXjoOM53B8rJdq8nTVnOLpBX41BBUcOjKW7
        4OYOe8AhkY1z1uHxs5/pTwxjDTW1HTj8DSTwUF3t4Q7C+MfbwSEGMhxuP6Cshz0e9xI4MJNK0D9nx
        LJ09VjRQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005sQ-8i; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 30/38] cls_flower: Use XArray list of filters in fl_walk
Date:   Tue, 20 Aug 2019 15:32:51 -0700
Message-Id: <20190820223259.22348-31-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Instead of iterating over every filter attached to every mark, just
iterate over each filter.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_flower.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 54026c9e9b05..2a1999d2b507 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -575,18 +575,15 @@ static void fl_destroy(struct tcf_proto *tp, bool rtnl_held,
 		       struct netlink_ext_ack *extack)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
-	struct fl_flow_mask *mask, *next_mask;
-	struct cls_fl_filter *f, *next;
+	struct cls_fl_filter *f;
+	unsigned long handle;
 	bool last;
 
-	list_for_each_entry_safe(mask, next_mask, &head->masks, list) {
-		list_for_each_entry_safe(f, next, &mask->filters, list) {
-			__fl_delete(tp, f, &last, rtnl_held, extack);
-			if (last)
-				break;
-		}
+	xa_for_each(&head->filters, handle, f) {
+		__fl_delete(tp, f, &last, rtnl_held, extack);
+		if (last)
+			break;
 	}
-	xa_destroy(&head->filters);
 
 	__module_get(THIS_MODULE);
 	tcf_queue_work(&head->rwork, fl_destroy_sleepable);
-- 
2.23.0.rc1

