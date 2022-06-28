Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6838155EC01
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiF1SGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiF1SGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:06:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A641C923;
        Tue, 28 Jun 2022 11:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDDF8B81F55;
        Tue, 28 Jun 2022 18:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3339EC3411D;
        Tue, 28 Jun 2022 18:06:19 +0000 (UTC)
Subject: [PATCH v2 05/31] NFSD: Report average age of filecache items
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:06:18 -0400
Message-ID: <165643957825.84360.15206355426631591915.stgit@manet.1015granger.net>
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

This is a measure of how long items stay in the filecache, to help
assess how efficient the cache is.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   11 ++++++++++-
 fs/nfsd/filecache.h |    1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index c28e9577837d..da48c51a2bf0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -45,6 +45,7 @@ struct nfsd_fcache_bucket {
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -178,6 +179,7 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 	if (nf) {
 		INIT_HLIST_NODE(&nf->nf_node);
 		INIT_LIST_HEAD(&nf->nf_lru);
+		nf->nf_birthtime = ktime_get();
 		nf->nf_file = NULL;
 		nf->nf_cred = get_current_cred();
 		nf->nf_net = net;
@@ -201,9 +203,11 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 static bool
 nfsd_file_free(struct nfsd_file *nf)
 {
+	s64 age = ktime_to_ms(ktime_sub(ktime_get(), nf->nf_birthtime));
 	bool flush = false;
 
 	this_cpu_inc(nfsd_file_releases);
+	this_cpu_add(nfsd_file_total_age, age);
 
 	trace_nfsd_file_put_final(nf);
 	if (nf->nf_mark)
@@ -1075,7 +1079,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned long hits = 0, acquisitions = 0, releases = 0;
 	unsigned int i, count = 0, longest = 0;
-	unsigned long lru = 0;
+	unsigned long lru = 0, total_age = 0;
 
 	/*
 	 * No need for spinlocks here since we're not terribly interested in
@@ -1096,6 +1100,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		hits += per_cpu(nfsd_file_cache_hits, i);
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
 		releases += per_cpu(nfsd_file_releases, i);
+		total_age += per_cpu(nfsd_file_total_age, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1104,6 +1109,10 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	seq_printf(m, "releases:      %lu\n", releases);
+	if (releases)
+		seq_printf(m, "mean age (ms): %ld\n", total_age / releases);
+	else
+		seq_printf(m, "mean age (ms): -\n");
 	return 0;
 }
 
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 1da0c79a5580..d0c42619dc10 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -46,6 +46,7 @@ struct nfsd_file {
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
+	ktime_t			nf_birthtime;
 };
 
 int nfsd_file_cache_init(void);


