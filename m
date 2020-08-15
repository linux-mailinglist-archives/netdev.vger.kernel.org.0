Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85105245429
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbgHOWNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:13:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:36294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbgHOWNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:13:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40F9AAD4B;
        Sat, 15 Aug 2020 12:43:26 +0000 (UTC)
From:   colyli@suse.de
To:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>
Subject: [PATCH v4 1/3] net: introduce helper sendpage_ok() in include/linux/net.h
Date:   Sat, 15 Aug 2020 20:42:52 +0800
Message-Id: <20200815124254.115076-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coly Li <colyli@suse.de>

The original problem was from nvme-over-tcp code, who mistakenly uses
kernel_sendpage() to send pages allocated by __get_free_pages() without
__GFP_COMP flag. Such pages don't have refcount (page_count is 0) on
tail pages, sending them by kernel_sendpage() may trigger a kernel panic
from a corrupted kernel heap, because these pages are incorrectly freed
in network stack as page_count 0 pages.

This patch introduces a helper sendpage_ok(), it returns true if the
checking page,
- is not slab page: PageSlab(page) is false.
- has page refcount: page_count(page) is not zero

All drivers who want to send page to remote end by kernel_sendpage()
may use this helper to check whether the page is OK. If the helper does
not return true, the driver should try other non sendpage method (e.g.
sock_no_sendpage()) to handle the page.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Vlastimil Babka <vbabka@suse.com>
Cc: stable@vger.kernel.org
---
Changelog:
v4, change sendpage_ok() as an inline helper, and post it as
    separate patch.
v3, introduce a more common sendpage_ok()
v2, fix typo in patch subject
v1, the initial version.
 include/linux/net.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index d48ff1180879..97e8f1a8a427 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -286,6 +286,21 @@ do {									\
 #define net_get_random_once_wait(buf, nbytes)			\
 	get_random_once_wait((buf), (nbytes))
 
+/*
+ * E.g. XFS meta- & log-data is in slab pages, or bcache meta
+ * data pages, or other high order pages allocated by
+ * __get_free_pages() without __GFP_COMP, which have a page_count
+ * of 0 and/or have PageSlab() set. We cannot use send_page for
+ * those, as that does get_page(); put_page(); and would cause
+ * either a VM_BUG directly, or __page_cache_release a page that
+ * would actually still be referenced by someone, leading to some
+ * obscure delayed Oops somewhere else.
+ */
+static inline bool sendpage_ok(struct page *page)
+{
+	return  (!PageSlab(page) && page_count(page) >= 1);
+}
+
 int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
 		   size_t num, size_t len);
 int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
-- 
2.26.2

