Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0D155EBF9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiF1SGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiF1SGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:06:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B441CFF5;
        Tue, 28 Jun 2022 11:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0CADCE217E;
        Tue, 28 Jun 2022 18:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2B5C341C8;
        Tue, 28 Jun 2022 18:05:59 +0000 (UTC)
Subject: [PATCH v2 02/31] NFSD: Report filecache LRU size
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:05:58 -0400
Message-ID: <165643955879.84360.13113783746339971558.stgit@manet.1015granger.net>
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

Surface the NFSD filecache's LRU list length to help field
troubleshooters monitor filecache issues.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 9cb2d590c036..a0234d194ec1 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1068,7 +1068,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned int i, count = 0, longest = 0;
-	unsigned long hits = 0;
+	unsigned long lru = 0, hits = 0;
 
 	/*
 	 * No need for spinlocks here since we're not terribly interested in
@@ -1081,6 +1081,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 			count += nfsd_file_hashtbl[i].nfb_count;
 			longest = max(longest, nfsd_file_hashtbl[i].nfb_count);
 		}
+		lru = list_lru_count(&nfsd_file_lru);
 	}
 	mutex_unlock(&nfsd_mutex);
 
@@ -1089,6 +1090,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "total entries: %u\n", count);
 	seq_printf(m, "longest chain: %u\n", longest);
+	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	return 0;
 }


