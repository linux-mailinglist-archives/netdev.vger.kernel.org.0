Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE9A554C8B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358183AbiFVOPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358355AbiFVOPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:15:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D804F39B9C;
        Wed, 22 Jun 2022 07:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5670161B71;
        Wed, 22 Jun 2022 14:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60937C34114;
        Wed, 22 Jun 2022 14:14:52 +0000 (UTC)
Subject: [PATCH RFC 19/30] NFSD: Remove lockdep assertion from
 unhash_and_release_locked()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:14:51 -0400
Message-ID: <165590729129.75778.11255677507294323945.stgit@manet.1015granger.net>
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

IIUC, holding the hash bucket lock is needed only in
nfsd_file_unhash, and there is already a lockdep assertion there.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d620f18924a1..304faa28afd7 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -307,8 +307,6 @@ nfsd_file_unhash(struct nfsd_file *nf)
 static bool
 nfsd_file_unhash_and_release_locked(struct nfsd_file *nf, struct list_head *dispose)
 {
-	lockdep_assert_held(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-
 	trace_nfsd_file_unhash_and_release_locked(nf);
 	if (!nfsd_file_unhash(nf))
 		return false;


