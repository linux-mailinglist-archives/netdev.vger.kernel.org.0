Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117A642A0C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439856AbfFLO40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbfFLO40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 10:56:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B0C20866;
        Wed, 12 Jun 2019 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560351385;
        bh=Lc+ym1o50Y9d5S4BmgqkjSdn0jAcuvgYaQKRXROPbdc=;
        h=Date:From:To:Cc:Subject:From;
        b=ok7aBvaTHO9trU95PUfF3ebBIHM9yuZSAmSgIbpDSqP4xIAx9pOqKzHkROhsdKmiC
         BlBuaUErd3KfUpIpin4WhRlG2OEmTdTpiXjxewr3w5h76FjEkuRWegsMJGB+ptYHoI
         5u4v2+ax20Lxf5r85rnjZprnONYXfOJM3yZn9hpM=
Date:   Wed, 12 Jun 2019 16:56:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] sunrpc: no need to check return value of debugfs_create
 functions
Message-ID: <20190612145622.GA18839@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/debugfs.c | 66 ++++++++------------------------------------
 1 file changed, 11 insertions(+), 55 deletions(-)

diff --git a/net/sunrpc/debugfs.c b/net/sunrpc/debugfs.c
index 95ebd76b132d..707d7aab1546 100644
--- a/net/sunrpc/debugfs.c
+++ b/net/sunrpc/debugfs.c
@@ -11,7 +11,6 @@
 #include "netns.h"
 
 static struct dentry *topdir;
-static struct dentry *rpc_fault_dir;
 static struct dentry *rpc_clnt_dir;
 static struct dentry *rpc_xprt_dir;
 
@@ -125,23 +124,16 @@ rpc_clnt_debugfs_register(struct rpc_clnt *clnt)
 	char name[24]; /* enough for "../../rpc_xprt/ + 8 hex digits + NULL */
 	struct rpc_xprt *xprt;
 
-	/* Already registered? */
-	if (clnt->cl_debugfs || !rpc_clnt_dir)
-		return;
-
 	len = snprintf(name, sizeof(name), "%x", clnt->cl_clid);
 	if (len >= sizeof(name))
 		return;
 
 	/* make the per-client dir */
 	clnt->cl_debugfs = debugfs_create_dir(name, rpc_clnt_dir);
-	if (!clnt->cl_debugfs)
-		return;
 
 	/* make tasks file */
-	if (!debugfs_create_file("tasks", S_IFREG | 0400, clnt->cl_debugfs,
-				 clnt, &tasks_fops))
-		goto out_err;
+	debugfs_create_file("tasks", S_IFREG | 0400, clnt->cl_debugfs, clnt,
+			    &tasks_fops);
 
 	rcu_read_lock();
 	xprt = rcu_dereference(clnt->cl_xprt);
@@ -157,8 +149,7 @@ rpc_clnt_debugfs_register(struct rpc_clnt *clnt)
 	if (len >= sizeof(name))
 		goto out_err;
 
-	if (!debugfs_create_symlink("xprt", clnt->cl_debugfs, name))
-		goto out_err;
+	debugfs_create_symlink("xprt", clnt->cl_debugfs, name);
 
 	return;
 out_err:
@@ -226,9 +217,6 @@ rpc_xprt_debugfs_register(struct rpc_xprt *xprt)
 	static atomic_t	cur_id;
 	char		name[9]; /* 8 hex digits + NULL term */
 
-	if (!rpc_xprt_dir)
-		return;
-
 	id = (unsigned int)atomic_inc_return(&cur_id);
 
 	len = snprintf(name, sizeof(name), "%x", id);
@@ -237,15 +225,10 @@ rpc_xprt_debugfs_register(struct rpc_xprt *xprt)
 
 	/* make the per-client dir */
 	xprt->debugfs = debugfs_create_dir(name, rpc_xprt_dir);
-	if (!xprt->debugfs)
-		return;
 
 	/* make tasks file */
-	if (!debugfs_create_file("info", S_IFREG | 0400, xprt->debugfs,
-				 xprt, &xprt_info_fops)) {
-		debugfs_remove_recursive(xprt->debugfs);
-		xprt->debugfs = NULL;
-	}
+	debugfs_create_file("info", S_IFREG | 0400, xprt->debugfs, xprt,
+			    &xprt_info_fops);
 
 	atomic_set(&xprt->inject_disconnect, rpc_inject_disconnect);
 }
@@ -308,28 +291,11 @@ static const struct file_operations fault_disconnect_fops = {
 	.release	= fault_release,
 };
 
-static struct dentry *
-inject_fault_dir(struct dentry *topdir)
-{
-	struct dentry *faultdir;
-
-	faultdir = debugfs_create_dir("inject_fault", topdir);
-	if (!faultdir)
-		return NULL;
-
-	if (!debugfs_create_file("disconnect", S_IFREG | 0400, faultdir,
-				 NULL, &fault_disconnect_fops))
-		return NULL;
-
-	return faultdir;
-}
-
 void __exit
 sunrpc_debugfs_exit(void)
 {
 	debugfs_remove_recursive(topdir);
 	topdir = NULL;
-	rpc_fault_dir = NULL;
 	rpc_clnt_dir = NULL;
 	rpc_xprt_dir = NULL;
 }
@@ -337,26 +303,16 @@ sunrpc_debugfs_exit(void)
 void __init
 sunrpc_debugfs_init(void)
 {
-	topdir = debugfs_create_dir("sunrpc", NULL);
-	if (!topdir)
-		return;
+	struct dentry *rpc_fault_dir;
 
-	rpc_fault_dir = inject_fault_dir(topdir);
-	if (!rpc_fault_dir)
-		goto out_remove;
+	topdir = debugfs_create_dir("sunrpc", NULL);
 
 	rpc_clnt_dir = debugfs_create_dir("rpc_clnt", topdir);
-	if (!rpc_clnt_dir)
-		goto out_remove;
 
 	rpc_xprt_dir = debugfs_create_dir("rpc_xprt", topdir);
-	if (!rpc_xprt_dir)
-		goto out_remove;
 
-	return;
-out_remove:
-	debugfs_remove_recursive(topdir);
-	topdir = NULL;
-	rpc_fault_dir = NULL;
-	rpc_clnt_dir = NULL;
+	rpc_fault_dir = debugfs_create_dir("inject_fault", topdir);
+
+	debugfs_create_file("disconnect", S_IFREG | 0400, rpc_fault_dir, NULL,
+			    &fault_disconnect_fops);
 }
-- 
2.22.0

