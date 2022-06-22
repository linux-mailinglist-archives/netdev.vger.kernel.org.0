Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE06D554C6B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358209AbiFVOOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358305AbiFVON4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:13:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CAFA45F;
        Wed, 22 Jun 2022 07:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE01FB81F56;
        Wed, 22 Jun 2022 14:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AEFC341C0;
        Wed, 22 Jun 2022 14:13:53 +0000 (UTC)
Subject: [PATCH RFC 10/30] NFSD: Report filecache item construction failures
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:13:52 -0400
Message-ID: <165590723207.75778.6796494140785317184.stgit@manet.1015granger.net>
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

My guess is this is exceptionally rare, but it's worth reporting
to see how nfsd_file_acquire() behaves when the cache is full.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index cae7fa2343c1..a2a78163bf8d 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -47,6 +47,7 @@ static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_pages_flushed);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_cons_fails);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -975,6 +976,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	/* Did construction of this file fail? */
 	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
+		this_cpu_inc(nfsd_file_cons_fails);
 		if (!retry) {
 			status = nfserr_jukebox;
 			goto out;
@@ -1098,7 +1100,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
-	unsigned long hits = 0, acquisitions = 0;
+	unsigned long hits = 0, acquisitions = 0, cons_fails = 0;
 	unsigned int i, count = 0, longest = 0;
 
 	/*
@@ -1121,6 +1123,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		releases += per_cpu(nfsd_file_releases, i);
 		evictions += per_cpu(nfsd_file_evictions, i);
 		pages_flushed += per_cpu(nfsd_file_pages_flushed, i);
+		cons_fails += per_cpu(nfsd_file_cons_fails, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1136,6 +1139,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	else
 		seq_printf(m, "mean age (ms): -\n");
 	seq_printf(m, "pages flushed: %lu\n", pages_flushed);
+	seq_printf(m, "cons fails:    %lu\n", cons_fails);
 	return 0;
 }
 


