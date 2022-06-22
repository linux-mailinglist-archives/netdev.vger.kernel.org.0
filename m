Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291EB554C68
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358181AbiFVOOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358246AbiFVONn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:13:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA190BBD;
        Wed, 22 Jun 2022 07:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56F4DB81F58;
        Wed, 22 Jun 2022 14:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9116C34114;
        Wed, 22 Jun 2022 14:13:39 +0000 (UTC)
Subject: [PATCH RFC 08/30] NFSD: Report the number of items evicted by the LRU
 walk
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:13:38 -0400
Message-ID: <165590721886.75778.3954208768212592776.stgit@manet.1015granger.net>
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

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   14 +++++++++++---
 fs/nfsd/trace.h     |   29 +++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index b1e7588d578a..d597acfdab28 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -45,6 +45,7 @@ struct nfsd_fcache_bucket {
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -482,9 +483,12 @@ static void
 nfsd_file_gc(void)
 {
 	LIST_HEAD(dispose);
+	unsigned long ret;
 
-	list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
-		      &dispose, LONG_MAX);
+	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
+			    &dispose, LONG_MAX);
+	this_cpu_add(nfsd_file_evictions, ret);
+	trace_nfsd_file_gc_evicted(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 }
 
@@ -509,6 +513,8 @@ nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 
 	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
 				   nfsd_file_lru_cb, &dispose);
+	this_cpu_add(nfsd_file_evictions, ret);
+	trace_nfsd_file_shrinker_evicted(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 	return ret;
 }
@@ -1085,7 +1091,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long hits = 0, acquisitions = 0, releases = 0;
+	unsigned long hits = 0, acquisitions = 0, releases = 0, evictions = 0;
 	unsigned int i, count = 0, longest = 0;
 
 	/*
@@ -1106,6 +1112,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		hits += per_cpu(nfsd_file_cache_hits, i);
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
 		releases += per_cpu(nfsd_file_releases, i);
+		evictions += per_cpu(nfsd_file_evictions, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1114,6 +1121,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	seq_printf(m, "releases:      %lu\n", releases);
+	seq_printf(m, "evictions:     %lu\n", evictions);
 	if (releases)
 		seq_printf(m, "mean age (ms): %ld\n",
 			atomic_long_read(&nfsd_file_total_age) / releases);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index a60ead3b227a..c055c6361bd5 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -851,6 +851,35 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 			__entry->nlink, __entry->mode, __entry->mask)
 );
 
+DECLARE_EVENT_CLASS(nfsd_file_lruwalk_class,
+	TP_PROTO(
+		unsigned long evicted,
+		unsigned long remaining
+	),
+	TP_ARGS(evicted, remaining),
+	TP_STRUCT__entry(
+		__field(unsigned long, evicted)
+		__field(unsigned long, remaining)
+	),
+	TP_fast_assign(
+		__entry->evicted = evicted;
+		__entry->remaining = remaining;
+	),
+	TP_printk("%lu entries evicted, %lu remaining",
+		__entry->evicted, __entry->remaining)
+);
+
+#define DEFINE_NFSD_FILE_LRUWALK_EVENT(name)				\
+DEFINE_EVENT(nfsd_file_lruwalk_class, name,				\
+	TP_PROTO(							\
+		unsigned long evicted,					\
+		unsigned long remaining					\
+	),								\
+	TP_ARGS(evicted, remaining))
+
+DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_gc_evicted);
+DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_shrinker_evicted);
+
 #include "cache.h"
 
 TRACE_DEFINE_ENUM(RC_DROPIT);


