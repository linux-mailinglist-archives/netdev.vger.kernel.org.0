Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF564554C70
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358280AbiFVOOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358290AbiFVONs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1199BAF;
        Wed, 22 Jun 2022 07:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BDB561B71;
        Wed, 22 Jun 2022 14:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DB3C34114;
        Wed, 22 Jun 2022 14:13:46 +0000 (UTC)
Subject: [PATCH RFC 09/30] NFSD: Record number of flush calls
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:13:45 -0400
Message-ID: <165590722535.75778.7826105117559897405.stgit@manet.1015granger.net>
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
 fs/nfsd/filecache.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d597acfdab28..cae7fa2343c1 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -45,6 +45,7 @@ struct nfsd_fcache_bucket {
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_pages_flushed);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
 struct nfsd_fcache_disposal {
@@ -249,7 +250,12 @@ nfsd_file_check_write_error(struct nfsd_file *nf)
 static void
 nfsd_file_flush(struct nfsd_file *nf)
 {
-	if (nf->nf_file && vfs_fsync(nf->nf_file, 1) != 0)
+	struct file *file = nf->nf_file;
+
+	if (!file || !(file->f_mode & FMODE_WRITE))
+		return;
+	this_cpu_add(nfsd_file_pages_flushed, file->f_mapping->nrpages);
+	if (vfs_fsync(file, 1) != 0)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
 
@@ -1091,7 +1097,8 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long hits = 0, acquisitions = 0, releases = 0, evictions = 0;
+	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
+	unsigned long hits = 0, acquisitions = 0;
 	unsigned int i, count = 0, longest = 0;
 
 	/*
@@ -1113,6 +1120,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
 		releases += per_cpu(nfsd_file_releases, i);
 		evictions += per_cpu(nfsd_file_evictions, i);
+		pages_flushed += per_cpu(nfsd_file_pages_flushed, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1127,6 +1135,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 			atomic_long_read(&nfsd_file_total_age) / releases);
 	else
 		seq_printf(m, "mean age (ms): -\n");
+	seq_printf(m, "pages flushed: %lu\n", pages_flushed);
 	return 0;
 }
 


