Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1588554C87
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358088AbiFVOPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358171AbiFVOOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:14:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87429BBD;
        Wed, 22 Jun 2022 07:14:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40257B81F5B;
        Wed, 22 Jun 2022 14:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C21C34114;
        Wed, 22 Jun 2022 14:13:59 +0000 (UTC)
Subject: [PATCH RFC 11/30] NFSD: Zero counters when the filecache is
 re-initialized
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:13:58 -0400
Message-ID: <165590723860.75778.13700894228554322207.stgit@manet.1015granger.net>
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

If nfsd_file_cache_init() is called after a shutdown, be sure the
stat counters are reset.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index a2a78163bf8d..0cf2e44e874f 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -832,6 +832,8 @@ nfsd_file_cache_shutdown_net(struct net *net)
 void
 nfsd_file_cache_shutdown(void)
 {
+	int i;
+
 	set_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
@@ -855,6 +857,15 @@ nfsd_file_cache_shutdown(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+
+	for_each_possible_cpu(i) {
+		this_cpu_write(nfsd_file_cache_hits, 0);
+		this_cpu_write(nfsd_file_acquisitions, 0);
+		this_cpu_write(nfsd_file_releases, 0);
+		this_cpu_write(nfsd_file_evictions, 0);
+		this_cpu_write(nfsd_file_pages_flushed, 0);
+		this_cpu_write(nfsd_file_cons_fails, 0);
+	}
 }
 
 static bool


