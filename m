Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AC14C373
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbfFSWP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:15:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfFSWP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 18:15:57 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E588930860BF
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 22:15:56 +0000 (UTC)
Received: from [10.0.16.7] (ovpn-112-24.phx2.redhat.com [10.3.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06744100194A;
        Wed, 19 Jun 2019 22:15:53 +0000 (UTC)
Subject: [PATCH] page_pool: fix compile warning when CONFIG_PAGE_POOL is
 disabled
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org
Date:   Thu, 20 Jun 2019 00:15:52 +0200
Message-ID: <156098255254.17592.13888583206213518228.stgit@carbon>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 19 Jun 2019 22:15:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kbuild test robot reported compile warning:
 warning: no return statement in function returning non-void
in function page_pool_request_shutdown, when CONFIG_PAGE_POOL is disabled.

The fix makes the code a little more verbose, with a descriptive variable.

Fixes: 99c07c43c4ea ("xdp: tracking page_pool resources and safe removal")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 include/net/page_pool.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index f09b3f1994e6..f07c518ef8a5 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -156,12 +156,12 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 bool __page_pool_request_shutdown(struct page_pool *pool);
 static inline bool page_pool_request_shutdown(struct page_pool *pool)
 {
-	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
-	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
-	 */
+	bool safe_to_remove = false;
+
 #ifdef CONFIG_PAGE_POOL
-	return __page_pool_request_shutdown(pool);
+	safe_to_remove = __page_pool_request_shutdown(pool);
 #endif
+	return safe_to_remove;
 }
 
 /* Disconnects a page (from a page_pool).  API users can have a need

