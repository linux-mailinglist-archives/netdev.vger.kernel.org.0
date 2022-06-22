Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F05554C79
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357724AbiFVOPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358384AbiFVOOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:14:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C421393C9;
        Wed, 22 Jun 2022 07:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85660CE206A;
        Wed, 22 Jun 2022 14:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C70C34114;
        Wed, 22 Jun 2022 14:14:32 +0000 (UTC)
Subject: [PATCH RFC 16/30] NFSD: Fix the filecache LRU shrinker
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:14:31 -0400
Message-ID: <165590727154.75778.8699495406930751112.stgit@manet.1015granger.net>
In-Reply-To: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
User-Agent: StGit/1.5.dev2+g9ce680a5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without LRU item rotation, the shrinker visits only a few items on
the end of the LRU list, and those would always be long-term OPEN
files for NFSv4 workloads. That makes the filecache shrinker
completely ineffective.

Adopt the same strategy as the inode LRU by using LRU_ROTATE.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 65085853cc42..deb842f45117 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -453,6 +453,7 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
  *
  * Return values:
  *   %LRU_REMOVED: @item was removed from the LRU
+ *   %LRU_ROTATED: @item is to be moved to the LRU tail
  *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
@@ -491,7 +492,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 
 	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags)) {
 		trace_nfsd_file_gc_referenced(nf);
-		return LRU_SKIP;
+		return LRU_ROTATE;
 	}
 
 	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
@@ -528,13 +529,14 @@ static void nfsd_file_gc_dispose_list(struct list_head *dispose)
 static void
 nfsd_file_gc(void)
 {
+	unsigned long max = list_lru_count(&nfsd_file_lru);
 	LIST_HEAD(dispose);
 	unsigned long ret;
 
 	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
-			    &dispose, LONG_MAX);
+			    &dispose, max);
 	this_cpu_add(nfsd_file_evictions, ret);
-	trace_nfsd_file_gc_evicted(ret, list_lru_count(&nfsd_file_lru));
+	trace_nfsd_file_gc_evicted(ret, max);
 	nfsd_file_gc_dispose_list(&dispose);
 }
 


