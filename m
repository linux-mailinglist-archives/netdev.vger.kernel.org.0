Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B68955EC1D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiF1SH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiF1SHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A93C1EEE1;
        Tue, 28 Jun 2022 11:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C735B81F5A;
        Tue, 28 Jun 2022 18:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B343DC3411D;
        Tue, 28 Jun 2022 18:07:50 +0000 (UTC)
Subject: [PATCH v2 19/31] NFSD: Remove lockdep assertion from
 unhash_and_release_locked()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:07:49 -0400
Message-ID: <165643966981.84360.18336825644808669920.stgit@manet.1015granger.net>
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

IIUC, holding the hash bucket lock is needed only in
nfsd_file_unhash, and there is already a lockdep assertion there.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 32ada8cce2e0..278a13d85e8f 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -306,8 +306,6 @@ nfsd_file_unhash(struct nfsd_file *nf)
 static bool
 nfsd_file_unhash_and_release_locked(struct nfsd_file *nf, struct list_head *dispose)
 {
-	lockdep_assert_held(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-
 	trace_nfsd_file_unhash_and_release_locked(nf);
 	if (!nfsd_file_unhash(nf))
 		return false;


