Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EE556C034
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbiGHSYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbiGHSYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0059282387;
        Fri,  8 Jul 2022 11:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F4A66259E;
        Fri,  8 Jul 2022 18:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9346BC341C0;
        Fri,  8 Jul 2022 18:24:52 +0000 (UTC)
Subject: [PATCH v3 11/32] NFSD: Zero counters when the filecache is
 re-initialized
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:24:51 -0400
Message-ID: <165730469147.28142.10705393492354984904.stgit@klimt.1015granger.net>
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

If nfsd_file_cache_init() is called after a shutdown, be sure the
stat counters are reset.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7b532449b93f..3055a04eeabe 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -830,6 +830,8 @@ nfsd_file_cache_shutdown_net(struct net *net)
 void
 nfsd_file_cache_shutdown(void)
 {
+	int i;
+
 	set_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
@@ -853,6 +855,15 @@ nfsd_file_cache_shutdown(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+
+	for_each_possible_cpu(i) {
+		per_cpu(nfsd_file_cache_hits, i) = 0;
+		per_cpu(nfsd_file_acquisitions, i) = 0;
+		per_cpu(nfsd_file_releases, i) = 0;
+		per_cpu(nfsd_file_total_age, i) = 0;
+		per_cpu(nfsd_file_pages_flushed, i) = 0;
+		per_cpu(nfsd_file_evictions, i) = 0;
+	}
 }
 
 static bool


