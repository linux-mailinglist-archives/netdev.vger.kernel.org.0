Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4727456C097
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbiGHSYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238719AbiGHSYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:24:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145C4E036;
        Fri,  8 Jul 2022 11:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A87E62474;
        Fri,  8 Jul 2022 18:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6DFC341C0;
        Fri,  8 Jul 2022 18:24:06 +0000 (UTC)
Subject: [PATCH v3 04/32] NFSD: Report count of freed filecache items
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:24:05 -0400
Message-ID: <165730464571.28142.4278861288638395918.stgit@klimt.1015granger.net>
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

Surface the count of freed nfsd_file items.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 3359df6c7ac0..c28e9577837d 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -44,6 +44,7 @@ struct nfsd_fcache_bucket {
 
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -202,6 +203,8 @@ nfsd_file_free(struct nfsd_file *nf)
 {
 	bool flush = false;
 
+	this_cpu_inc(nfsd_file_releases);
+
 	trace_nfsd_file_put_final(nf);
 	if (nf->nf_mark)
 		nfsd_file_mark_put(nf->nf_mark);
@@ -1070,7 +1073,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long hits = 0, acquisitions = 0;
+	unsigned long hits = 0, acquisitions = 0, releases = 0;
 	unsigned int i, count = 0, longest = 0;
 	unsigned long lru = 0;
 
@@ -1092,6 +1095,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	for_each_possible_cpu(i) {
 		hits += per_cpu(nfsd_file_cache_hits, i);
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
+		releases += per_cpu(nfsd_file_releases, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1099,6 +1103,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
+	seq_printf(m, "releases:      %lu\n", releases);
 	return 0;
 }
 


