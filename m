Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B5956BFFB
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbiGHSYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239493AbiGHSYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:24:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845FA5596;
        Fri,  8 Jul 2022 11:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E6962474;
        Fri,  8 Jul 2022 18:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A18C341C0;
        Fri,  8 Jul 2022 18:24:00 +0000 (UTC)
Subject: [PATCH v3 03/32] NFSD: Report count of calls to nfsd_file_acquire()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:23:59 -0400
Message-ID: <165730463905.28142.7461176455073261110.stgit@klimt.1015granger.net>
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

Count the number of successful acquisitions that did not create a
file (ie, acquisitions that do not result in a compulsory cache
miss). This count can be compared directly with the reported hit
count to compute a hit ratio.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index a0234d194ec1..3359df6c7ac0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -43,6 +43,7 @@ struct nfsd_fcache_bucket {
 };
 
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -975,6 +976,8 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 out:
 	if (status == nfs_ok) {
+		if (open)
+			this_cpu_inc(nfsd_file_acquisitions);
 		*pnf = nf;
 	} else {
 		nfsd_file_put(nf);
@@ -1067,8 +1070,9 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
+	unsigned long hits = 0, acquisitions = 0;
 	unsigned int i, count = 0, longest = 0;
-	unsigned long lru = 0, hits = 0;
+	unsigned long lru = 0;
 
 	/*
 	 * No need for spinlocks here since we're not terribly interested in
@@ -1085,13 +1089,16 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	}
 	mutex_unlock(&nfsd_mutex);
 
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		hits += per_cpu(nfsd_file_cache_hits, i);
+		acquisitions += per_cpu(nfsd_file_acquisitions, i);
+	}
 
 	seq_printf(m, "total entries: %u\n", count);
 	seq_printf(m, "longest chain: %u\n", longest);
 	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
+	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	return 0;
 }
 


