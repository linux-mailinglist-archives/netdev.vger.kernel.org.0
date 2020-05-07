Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDB71C9002
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgEGOgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgEGO2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 10:28:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2D802083B;
        Thu,  7 May 2020 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861689;
        bh=Dek+MGDDA1gIbGByUT5XOUMDdXthngPtNd3pio84ldc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xtc9G+odZRk3kQaWCw06CGd9FFmF4dz1vGM2GYvdWALgYPN88Movj/1VYNt3aaBb7
         HR2Nq3jvgwnxG3bkYDWiE6sJRiOR6xXlssX5NEniIC94wijjnzkkaPpTVSUn+t65r4
         kQcE308K6qTdjOc7q6QyJHxb5dZ3qOC5O9YpGiJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 34/50] SUNRPC: defer slow parts of rpc_free_client() to a workqueue.
Date:   Thu,  7 May 2020 10:27:10 -0400
Message-Id: <20200507142726.25751-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 7c4310ff56422ea43418305d22bbc5fe19150ec4 ]

The rpciod workqueue is on the write-out path for freeing dirty memory,
so it is important that it never block waiting for memory to be
allocated - this can lead to a deadlock.

rpc_execute() - which is often called by an rpciod work item - calls
rcp_task_release_client() which can lead to rpc_free_client().

rpc_free_client() makes two calls which could potentially block wating
for memory allocation.

rpc_clnt_debugfs_unregister() calls into debugfs and will block while
any of the debugfs files are being accessed.  In particular it can block
while any of the 'open' methods are being called and all of these use
malloc for one thing or another.  So this can deadlock if the memory
allocation waits for NFS to complete some writes via rpciod.

rpc_clnt_remove_pipedir() can take the inode_lock() and while it isn't
obvious that memory allocations can happen while the lock it held, it is
safer to assume they might and to not let rpciod call
rpc_clnt_remove_pipedir().

So this patch moves these two calls (together with the final kfree() and
rpciod_down()) into a work-item to be run from the system work-queue.
rpciod can continue its important work, and the final stages of the free
can happen whenever they happen.

I have seen this deadlock on a 4.12 based kernel where debugfs used
synchronize_srcu() when removing objects.  synchronize_srcu() requires a
workqueue and there were no free workther threads and none could be
allocated.  While debugsfs no longer uses SRCU, I believe the deadlock
is still possible.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/clnt.h |  8 +++++++-
 net/sunrpc/clnt.c           | 21 +++++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index ca7e108248e21..7bd124e06b36f 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -71,7 +71,13 @@ struct rpc_clnt {
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	struct dentry		*cl_debugfs;	/* debugfs directory */
 #endif
-	struct rpc_xprt_iter	cl_xpi;
+	/* cl_work is only needed after cl_xpi is no longer used,
+	 * and that are of similar size
+	 */
+	union {
+		struct rpc_xprt_iter	cl_xpi;
+		struct work_struct	cl_work;
+	};
 	const struct cred	*cl_cred;
 };
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7324b21f923e6..a2c215a6980d8 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -880,6 +880,20 @@ EXPORT_SYMBOL_GPL(rpc_shutdown_client);
 /*
  * Free an RPC client
  */
+static void rpc_free_client_work(struct work_struct *work)
+{
+	struct rpc_clnt *clnt = container_of(work, struct rpc_clnt, cl_work);
+
+	/* These might block on processes that might allocate memory,
+	 * so they cannot be called in rpciod, so they are handled separately
+	 * here.
+	 */
+	rpc_clnt_debugfs_unregister(clnt);
+	rpc_clnt_remove_pipedir(clnt);
+
+	kfree(clnt);
+	rpciod_down();
+}
 static struct rpc_clnt *
 rpc_free_client(struct rpc_clnt *clnt)
 {
@@ -890,17 +904,16 @@ rpc_free_client(struct rpc_clnt *clnt)
 			rcu_dereference(clnt->cl_xprt)->servername);
 	if (clnt->cl_parent != clnt)
 		parent = clnt->cl_parent;
-	rpc_clnt_debugfs_unregister(clnt);
-	rpc_clnt_remove_pipedir(clnt);
 	rpc_unregister_client(clnt);
 	rpc_free_iostats(clnt->cl_metrics);
 	clnt->cl_metrics = NULL;
 	xprt_put(rcu_dereference_raw(clnt->cl_xprt));
 	xprt_iter_destroy(&clnt->cl_xpi);
-	rpciod_down();
 	put_cred(clnt->cl_cred);
 	rpc_free_clid(clnt);
-	kfree(clnt);
+
+	INIT_WORK(&clnt->cl_work, rpc_free_client_work);
+	schedule_work(&clnt->cl_work);
 	return parent;
 }
 
-- 
2.20.1

