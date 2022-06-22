Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F17554C85
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358059AbiFVOPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358085AbiFVONS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:13:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD17E1262C;
        Wed, 22 Jun 2022 07:13:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860F061BC4;
        Wed, 22 Jun 2022 14:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADAEC34114;
        Wed, 22 Jun 2022 14:13:13 +0000 (UTC)
Subject: [PATCH RFC 04/30] NFSD: Report average age of filecache items
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:13:12 -0400
Message-ID: <165590719265.75778.6788227290654985658.stgit@manet.1015granger.net>
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

This is a measure of how long items stay in the filecache, to help
assess how efficient the cache is.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    9 +++++++++
 fs/nfsd/filecache.h |    1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index f735f91e576b..6f48528c6284 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -61,6 +61,7 @@ static struct list_lru			nfsd_file_lru;
 static long				nfsd_file_lru_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
+static atomic_long_t			nfsd_file_total_age;
 static struct delayed_work		nfsd_filecache_laundrette;
 
 static void nfsd_file_gc(void);
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
+	atomic_long_add(age, &nfsd_file_total_age);
 
 	trace_nfsd_file_put_final(nf);
 	if (nf->nf_mark)
@@ -1102,6 +1106,11 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	seq_printf(m, "releases:      %lu\n", releases);
+	if (releases)
+		seq_printf(m, "mean age (ms): %ld\n",
+			atomic_long_read(&nfsd_file_total_age) / releases);
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


