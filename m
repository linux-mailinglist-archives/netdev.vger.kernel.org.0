Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8254A55EC18
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiF1SHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiF1SHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:07:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F63A1EAE8;
        Tue, 28 Jun 2022 11:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29CCC61ADB;
        Tue, 28 Jun 2022 18:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B083C3411D;
        Tue, 28 Jun 2022 18:07:31 +0000 (UTC)
Subject: [PATCH v2 16/31] NFSD: Fix the filecache LRU shrinker
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:07:30 -0400
Message-ID: <165643965013.84360.5320447476976778288.stgit@manet.1015granger.net>
In-Reply-To: <165643915086.84360.2809940286726976517.stgit@manet.1015granger.net>
References: <165643915086.84360.2809940286726976517.stgit@manet.1015granger.net>
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
 fs/nfsd/filecache.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6e9e186334ab..bd6ba63f69ae 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -452,6 +452,7 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
  *
  * Return values:
  *   %LRU_REMOVED: @item was removed from the LRU
+ *   %LRU_ROTATED: @item is to be moved to the LRU tail
  *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
@@ -490,7 +491,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 
 	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags)) {
 		trace_nfsd_file_gc_referenced(nf);
-		return LRU_SKIP;
+		return LRU_ROTATE;
 	}
 
 	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
@@ -532,7 +533,7 @@ nfsd_file_gc(void)
 	unsigned long ret;
 
 	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
-			    &dispose, LONG_MAX);
+			    &dispose, list_lru_count(&nfsd_file_lru));
 	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 }


