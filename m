Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78279554C8F
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358093AbiFVOQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358102AbiFVOPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:15:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0621B24;
        Wed, 22 Jun 2022 07:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0D961BDD;
        Wed, 22 Jun 2022 14:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF6BC34114;
        Wed, 22 Jun 2022 14:15:05 +0000 (UTC)
Subject: [PATCH RFC 21/30] NFSD: Refactor __nfsd_file_close_inode()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:15:04 -0400
Message-ID: <165590730448.75778.4596658492674636131.stgit@manet.1015granger.net>
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

The code that computes the hashval is the same in both callers.

To prevent them from going stale, reframe the documenting comments
to remove descriptions of the underlying hash table structure, which
is about to be replaced.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 16679a80f20e..0387b2028a9b 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -568,10 +568,15 @@ static struct shrinker	nfsd_file_shrinker = {
 	.seeks = 1,
 };
 
+/*
+ * Find all cache items that match the inode and move them to @dispose.
+ * This process is atomic wrt nfsd_file_insert().
+ */
 static void
-__nfsd_file_close_inode(struct inode *inode, unsigned int hashval,
-			struct list_head *dispose)
+__nfsd_file_close_inode(struct inode *inode, struct list_head *dispose)
 {
+	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
+						NFSD_FILE_HASH_BITS);
 	struct nfsd_file	*nf;
 	struct hlist_node	*tmp;
 
@@ -587,19 +592,14 @@ __nfsd_file_close_inode(struct inode *inode, unsigned int hashval,
  * nfsd_file_close_inode_sync - attempt to forcibly close a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
- * Walk the whole hash bucket, looking for any files that correspond to "inode".
- * If any do, then unhash them and put the hashtable reference to them and
- * destroy any that had their last reference put. Also ensure that any of the
- * fputs also have their final __fput done as well.
+ * Unhash and put, then flush and fput all cache items associated with @inode.
  */
 void
 nfsd_file_close_inode_sync(struct inode *inode)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
 	LIST_HEAD(dispose);
 
-	__nfsd_file_close_inode(inode, hashval, &dispose);
+	__nfsd_file_close_inode(inode, &dispose);
 	trace_nfsd_file_close_inode_sync(inode, !list_empty(&dispose));
 	nfsd_file_dispose_list_sync(&dispose);
 }
@@ -608,18 +608,14 @@ nfsd_file_close_inode_sync(struct inode *inode)
  * nfsd_file_close_inode - attempt a delayed close of a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
- * Walk the whole hash bucket, looking for any files that correspond to "inode".
- * If any do, then unhash them and put the hashtable reference to them and
- * destroy any that had their last reference put.
+ * Unhash and put all cache item associated with @inode.
  */
 static void
 nfsd_file_close_inode(struct inode *inode)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
 	LIST_HEAD(dispose);
 
-	__nfsd_file_close_inode(inode, hashval, &dispose);
+	__nfsd_file_close_inode(inode, &dispose);
 	trace_nfsd_file_close_inode(inode, !list_empty(&dispose));
 	nfsd_file_dispose_list_delayed(&dispose);
 }


