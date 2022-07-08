Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E12D56BF8F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbiGHS2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbiGHS11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:27:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EABC88F1A;
        Fri,  8 Jul 2022 11:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4B27B82928;
        Fri,  8 Jul 2022 18:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C72C341C0;
        Fri,  8 Jul 2022 18:26:57 +0000 (UTC)
Subject: [PATCH v3 30/32] NFSD: Update the nfsd_file_fsnotify_handle_event()
 tracepoint
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:26:56 -0400
Message-ID: <165730481643.28142.10460346630935183143.stgit@klimt.1015granger.net>
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

As a convenience, display the mode and event mask symbolically
rather than numerically.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/trace.h           |   21 ++++++++++++++-------
 include/trace/events/fs.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 96bb6629541e..f68bcf13be8e 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -9,6 +9,7 @@
 #define _NFSD_TRACE_H
 
 #include <linux/tracepoint.h>
+#include <trace/events/fs.h>
 
 #include "export.h"
 #include "nfsfh.h"
@@ -1020,22 +1021,28 @@ TRACE_EVENT(nfsd_file_is_cached,
 );
 
 TRACE_EVENT(nfsd_file_fsnotify_handle_event,
-	TP_PROTO(struct inode *inode, u32 mask),
+	TP_PROTO(
+		const struct inode *inode,
+		u32 mask
+	),
 	TP_ARGS(inode, mask),
 	TP_STRUCT__entry(
-		__field(struct inode *, inode)
+		__field(const struct inode *, inode)
 		__field(unsigned int, nlink)
-		__field(umode_t, mode)
-		__field(u32, mask)
+		__field(unsigned long, mode)
+		__field(unsigned long, mask)
 	),
 	TP_fast_assign(
 		__entry->inode = inode;
 		__entry->nlink = inode->i_nlink;
-		__entry->mode = inode->i_mode;
+		__entry->mode = inode->i_mode & S_IFMT;
 		__entry->mask = mask;
 	),
-	TP_printk("inode=%p nlink=%u mode=0%ho mask=0x%x", __entry->inode,
-			__entry->nlink, __entry->mode, __entry->mask)
+	TP_printk("inode=%p nlink=%u mode=%s mask=%s",
+		__entry->inode, __entry->nlink,
+		show_fs_file_type(__entry->mode),
+		show_fs_notify_flags(__entry->mask)
+	)
 );
 
 DECLARE_EVENT_CLASS(nfsd_file_gc_class,
diff --git a/include/trace/events/fs.h b/include/trace/events/fs.h
index 738b97f22f36..3c75f85086a2 100644
--- a/include/trace/events/fs.h
+++ b/include/trace/events/fs.h
@@ -120,3 +120,40 @@
 		{ LOOKUP_BENEATH,	"BENEATH" }, \
 		{ LOOKUP_IN_ROOT,	"IN_ROOT" }, \
 		{ LOOKUP_CACHED,	"CACHED" })
+
+#define show_fs_file_type(x) \
+	__print_symbolic(x, \
+		{ S_IFLNK,		"LNK" }, \
+		{ S_IFREG,		"REG" }, \
+		{ S_IFDIR,		"DIR" }, \
+		{ S_IFCHR,		"CHR" }, \
+		{ S_IFBLK,		"BLK" }, \
+		{ S_IFIFO,		"FIFO" }, \
+		{ S_IFSOCK,		"SOCK" })
+
+#define show_fs_notify_flags(x) \
+	__print_flags(x, "|", \
+		{ FS_ACCESS,		"ACCESS" }, \
+		{ FS_MODIFY,		"MODIFY" }, \
+		{ FS_ATTRIB,		"ATTRIB" }, \
+		{ FS_CLOSE_WRITE,	"CLOSE_WRITE" }, \
+		{ FS_CLOSE_NOWRITE,	"CLOSE_NOWRITE" }, \
+		{ FS_OPEN,		"OPEN" }, \
+		{ FS_MOVED_FROM,	"MOVED_FROM" }, \
+		{ FS_MOVED_TO,		"MOVED_TO" }, \
+		{ FS_CREATE,		"CREATE" }, \
+		{ FS_DELETE,		"DELETE" }, \
+		{ FS_DELETE_SELF,	"DELETE_SELF" }, \
+		{ FS_MOVE_SELF,		"MOVE_SELF" }, \
+		{ FS_OPEN_EXEC,		"OPEN_EXEC" }, \
+		{ FS_UNMOUNT,		"UNMOUNT" }, \
+		{ FS_Q_OVERFLOW,	"Q_OVERFLOW" }, \
+		{ FS_ERROR,		"ERROR" }, \
+		{ FS_IN_IGNORED,	"IN_IGNORED" }, \
+		{ FS_OPEN_PERM,		"OPEN_PERM" }, \
+		{ FS_ACCESS_PERM,	"ACCESS_PERM" }, \
+		{ FS_OPEN_EXEC_PERM,	"OPEN_EXEC_PERM" }, \
+		{ FS_EVENT_ON_CHILD,	"EVENT_ON_CHILD" }, \
+		{ FS_RENAME,		"RENAME" }, \
+		{ FS_DN_MULTISHOT,	"DN_MULTISHOT" }, \
+		{ FS_ISDIR,		"ISDIR" })


