Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0745055EC20
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiF1SIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiF1SH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:07:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3231EECA;
        Tue, 28 Jun 2022 11:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5324961AED;
        Tue, 28 Jun 2022 18:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F80C3411D;
        Tue, 28 Jun 2022 18:07:57 +0000 (UTC)
Subject: [PATCH v2 20/31] NFSD: nfsd_file_unhash can compute hashval from
 nf->nf_inode
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:07:56 -0400
Message-ID: <165643967625.84360.12001257218905569232.stgit@manet.1015granger.net>
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

Remove an unnecessary usage of nf_hashval.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 278a13d85e8f..4143898fff37 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -279,13 +279,17 @@ static void nfsd_file_lru_remove(struct nfsd_file *nf)
 static void
 nfsd_file_do_unhash(struct nfsd_file *nf)
 {
-	lockdep_assert_held(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
+	struct inode *inode = nf->nf_inode;
+	unsigned int hashval = (unsigned int)hash_long(inode->i_ino,
+				NFSD_FILE_HASH_BITS);
+
+	lockdep_assert_held(&nfsd_file_hashtbl[hashval].nfb_lock);
 
 	trace_nfsd_file_unhash(nf);
 
 	if (nfsd_file_check_write_error(nf))
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
-	--nfsd_file_hashtbl[nf->nf_hashval].nfb_count;
+	--nfsd_file_hashtbl[hashval].nfb_count;
 	hlist_del_rcu(&nf->nf_node);
 	atomic_long_dec(&nfsd_filecache_count);
 }


