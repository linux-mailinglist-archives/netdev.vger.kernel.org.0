Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5E056C07F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbiGHSYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiGHSYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB0F7D1EB;
        Fri,  8 Jul 2022 11:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB5FC62474;
        Fri,  8 Jul 2022 18:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBBDC341C0;
        Fri,  8 Jul 2022 18:24:32 +0000 (UTC)
Subject: [PATCH v3 08/32] NFSD: Refactor nfsd_file_lru_scan()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:24:31 -0400
Message-ID: <165730467186.28142.10694600051478325327.stgit@klimt.1015granger.net>
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

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 4e1162f51a70..79cbbbdf8355 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -478,23 +478,6 @@ static void nfsd_file_gc_dispose_list(struct list_head *dispose)
 	nfsd_file_dispose_list_delayed(dispose);
 }
 
-static unsigned long
-nfsd_file_lru_walk_list(struct shrink_control *sc)
-{
-	LIST_HEAD(head);
-	unsigned long ret;
-
-	if (sc)
-		ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
-				nfsd_file_lru_cb, &head);
-	else
-		ret = list_lru_walk(&nfsd_file_lru,
-				nfsd_file_lru_cb,
-				&head, LONG_MAX);
-	nfsd_file_gc_dispose_list(&head);
-	return ret;
-}
-
 static void
 nfsd_file_gc(void)
 {
@@ -521,7 +504,13 @@ nfsd_file_lru_count(struct shrinker *s, struct shrink_control *sc)
 static unsigned long
 nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 {
-	return nfsd_file_lru_walk_list(sc);
+	LIST_HEAD(dispose);
+	unsigned long ret;
+
+	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
+				   nfsd_file_lru_cb, &dispose);
+	nfsd_file_gc_dispose_list(&dispose);
+	return ret;
 }
 
 static struct shrinker	nfsd_file_shrinker = {


