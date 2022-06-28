Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A71F55EC1A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiF1SHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiF1SHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:07:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1021EC58;
        Tue, 28 Jun 2022 11:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A81761AD5;
        Tue, 28 Jun 2022 18:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A250DC3411D;
        Tue, 28 Jun 2022 18:07:37 +0000 (UTC)
Subject: [PATCH v2 17/31] NFSD: Never call nfsd_file_gc() in foreground paths
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:07:36 -0400
Message-ID: <165643965677.84360.11591963051893106165.stgit@manet.1015granger.net>
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

The checks in nfsd_file_acquire() and nfsd_file_put() that directly
invoke filecache garbage collection are intended to keep cache
occupancy between a low- and high-watermark. The reason to limit the
capacity of the filecache is to keep filecache lookups reasonably
fast.

However, invoking garbage collection at those points has some
undesirable negative impacts. Files that are held open by NFSv4
clients often push the occupancy of the filecache over these
watermarks. At that point:

- Every call to nfsd_file_acquire() and nfsd_file_put() results in
  an LRU walk. This has the same effect on lookup latency as long
  chains in the hash table.
- Garbage collection will then run on every nfsd thread, causing a
  lot of unnecessary lock contention.
- Limiting cache capacity pushes out files used only by NFSv3
  clients, which are the type of files the filecache is supposed to
  help.

To address those negative impacts, remove the direct calls to the
garbage collector. Subsequent patches will address maintaining
lookup efficiency as cache capacity increases.

Suggested-by: Wang Yugui <wangyugui@e16-tech.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index bd6ba63f69ae..faa8588663d6 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -29,8 +29,6 @@
 #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
 
 #define NFSD_FILE_SHUTDOWN		     (1)
-#define NFSD_FILE_LRU_THRESHOLD		     (4096UL)
-#define NFSD_FILE_LRU_LIMIT		     (NFSD_FILE_LRU_THRESHOLD << 2)
 
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
@@ -66,8 +64,6 @@ static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
 static struct delayed_work		nfsd_filecache_laundrette;
 
-static void nfsd_file_gc(void);
-
 static void
 nfsd_file_schedule_laundrette(void)
 {
@@ -350,9 +346,6 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_schedule_laundrette();
 	} else
 		nfsd_file_put_noref(nf);
-
-	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
-		nfsd_file_gc();
 }
 
 struct nfsd_file *
@@ -1075,8 +1068,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
 			nfsd_file_hashtbl[hashval].nfb_count);
 	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	if (atomic_long_inc_return(&nfsd_filecache_count) >= NFSD_FILE_LRU_THRESHOLD)
-		nfsd_file_gc();
+	atomic_long_inc(&nfsd_filecache_count);
 
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark) {


