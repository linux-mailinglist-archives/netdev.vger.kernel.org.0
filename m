Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7BE55EC12
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiF1SHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiF1SHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:07:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D211EACC;
        Tue, 28 Jun 2022 11:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4FBACE21BF;
        Tue, 28 Jun 2022 18:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D353C3411D;
        Tue, 28 Jun 2022 18:07:11 +0000 (UTC)
Subject: [PATCH v2 13/31] NFSD: WARN when freeing an item still linked via
 nf_lru
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:07:10 -0400
Message-ID: <165643963066.84360.17047678502830993413.stgit@manet.1015granger.net>
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

Add a guardrail to prevent freeing memory that is still on a list.
This includes either a dispose list or the LRU list.

This is the sign of a bug, but this class of bugs can be detected
so that they don't endanger system stability, especially while
debugging.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 3055a04eeabe..8ade3699664c 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -220,6 +220,14 @@ nfsd_file_free(struct nfsd_file *nf)
 		fput(nf->nf_file);
 		flush = true;
 	}
+
+	/*
+	 * If this item is still linked via nf_lru, that's a bug.
+	 * WARN and leak it to preserve system stability.
+	 */
+	if (WARN_ON_ONCE(!list_empty(&nf->nf_lru)))
+		return flush;
+
 	call_rcu(&nf->nf_rcu, nfsd_file_slab_free);
 	return flush;
 }
@@ -349,7 +357,7 @@ nfsd_file_dispose_list(struct list_head *dispose)
 
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
-		list_del(&nf->nf_lru);
+		list_del_init(&nf->nf_lru);
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
 	}
@@ -363,7 +371,7 @@ nfsd_file_dispose_list_sync(struct list_head *dispose)
 
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
-		list_del(&nf->nf_lru);
+		list_del_init(&nf->nf_lru);
 		nfsd_file_flush(nf);
 		if (!refcount_dec_and_test(&nf->nf_ref))
 			continue;


