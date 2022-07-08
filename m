Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4733056C09D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbiGHSZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239456AbiGHSZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:25:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CCA823B6;
        Fri,  8 Jul 2022 11:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD29DB82922;
        Fri,  8 Jul 2022 18:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CA9C341C0;
        Fri,  8 Jul 2022 18:24:59 +0000 (UTC)
Subject: [PATCH v3 12/32] NFSD: Hook up the filecache stat file
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:24:58 -0400
Message-ID: <165730469820.28142.10369457240055089259.stgit@klimt.1015granger.net>
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

There has always been the capability of exporting filecache metrics
via /proc, but it was never hooked up. Let's surface these metrics
to enable better observability of the filecache.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 66c352bf61b1..ecc08cf97a86 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -25,6 +25,7 @@
 #include "state.h"
 #include "netns.h"
 #include "pnfs.h"
+#include "filecache.h"
 
 /*
  *	We have a single directory with several nodes in it.
@@ -46,6 +47,7 @@ enum {
 	NFSD_MaxBlkSize,
 	NFSD_MaxConnections,
 	NFSD_SupportedEnctypes,
+	NFSD_Filecache,
 	/*
 	 * The below MUST come last.  Otherwise we leave a hole in nfsd_files[]
 	 * with !CONFIG_NFSD_V4 and simple_fill_super() goes oops
@@ -229,6 +231,13 @@ static const struct file_operations reply_cache_stats_operations = {
 	.release	= single_release,
 };
 
+static const struct file_operations filecache_ops = {
+	.open		= nfsd_file_cache_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*----------------------------------------------------------------------------*/
 /*
  * payload - write methods
@@ -1370,6 +1379,7 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
 		[NFSD_Ports] = {"portlist", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_MaxBlkSize] = {"max_block_size", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_MaxConnections] = {"max_connections", &transaction_ops, S_IWUSR|S_IRUGO},
+		[NFSD_Filecache] = {"filecache", &filecache_ops, S_IRUGO},
 #if defined(CONFIG_SUNRPC_GSS) || defined(CONFIG_SUNRPC_GSS_MODULE)
 		[NFSD_SupportedEnctypes] = {"supported_krb5_enctypes", &supported_enctypes_ops, S_IRUGO},
 #endif /* CONFIG_SUNRPC_GSS or CONFIG_SUNRPC_GSS_MODULE */


