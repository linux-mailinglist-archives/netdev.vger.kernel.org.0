Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD1556C074
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239426AbiGHSYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbiGHSYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2067D1EB;
        Fri,  8 Jul 2022 11:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6805D624C5;
        Fri,  8 Jul 2022 18:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747C8C341C0;
        Fri,  8 Jul 2022 18:24:39 +0000 (UTC)
Subject: [PATCH v3 09/32] NFSD: Report the number of items evicted by the LRU
 walk
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:24:38 -0400
Message-ID: <165730467850.28142.3134360390196293625.stgit@klimt.1015granger.net>
In-Reply-To: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
User-Agent: StGit/1.5.dev3+g9561319
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

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   13 ++++++++++---
 fs/nfsd/trace.h     |   29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 79cbbbdf8355..12f587473913 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -46,6 +46,7 @@ static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -452,6 +453,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 		goto out_skip;
 
 	list_lru_isolate_move(lru, &nf->nf_lru, head);
+	this_cpu_inc(nfsd_file_evictions);
 	return LRU_REMOVED;
 out_skip:
 	return LRU_SKIP;
@@ -482,9 +484,11 @@ static void
 nfsd_file_gc(void)
 {
 	LIST_HEAD(dispose);
+	unsigned long ret;
 
-	list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
-		      &dispose, LONG_MAX);
+	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
+			    &dispose, LONG_MAX);
+	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 }
 
@@ -509,6 +513,7 @@ nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 
 	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
 				   nfsd_file_lru_cb, &dispose);
+	trace_nfsd_file_shrinker_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 	return ret;
 }
@@ -1085,7 +1090,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long hits = 0, acquisitions = 0, releases = 0;
+	unsigned long hits = 0, acquisitions = 0, releases = 0, evictions = 0;
 	unsigned int i, count = 0, longest = 0;
 	unsigned long lru = 0, total_age = 0;
 
@@ -1109,6 +1114,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
 		releases += per_cpu(nfsd_file_releases, i);
 		total_age += per_cpu(nfsd_file_total_age, i);
+		evictions += per_cpu(nfsd_file_evictions, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1117,6 +1123,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	seq_printf(m, "releases:      %lu\n", releases);
+	seq_printf(m, "evictions:     %lu\n", evictions);
 	if (releases)
 		seq_printf(m, "mean age (ms): %ld\n", total_age / releases);
 	else
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 8467fd8f94c2..59dc5b2f4a50 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -897,6 +897,35 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 			__entry->nlink, __entry->mode, __entry->mask)
 );
 
+DECLARE_EVENT_CLASS(nfsd_file_lruwalk_class,
+	TP_PROTO(
+		unsigned long removed,
+		unsigned long remaining
+	),
+	TP_ARGS(removed, remaining),
+	TP_STRUCT__entry(
+		__field(unsigned long, removed)
+		__field(unsigned long, remaining)
+	),
+	TP_fast_assign(
+		__entry->removed = removed;
+		__entry->remaining = remaining;
+	),
+	TP_printk("%lu entries removed, %lu remaining",
+		__entry->removed, __entry->remaining)
+);
+
+#define DEFINE_NFSD_FILE_LRUWALK_EVENT(name)				\
+DEFINE_EVENT(nfsd_file_lruwalk_class, name,				\
+	TP_PROTO(							\
+		unsigned long removed,					\
+		unsigned long remaining					\
+	),								\
+	TP_ARGS(removed, remaining))
+
+DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_gc_removed);
+DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_shrinker_removed);
+
 #include "cache.h"
 
 TRACE_DEFINE_ENUM(RC_DROPIT);


