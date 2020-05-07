Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AFA1C8F10
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgEGO3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbgEGO3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 10:29:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B195E20838;
        Thu,  7 May 2020 14:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861743;
        bh=8hdS+zn0szNmoYXCOAEWvvvEI600objqG6lSWWGUNso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhVCVSZIvXTeLrqmxBV31C6ha7OgozBaalp9siCDHg6wpdwikOCX+tnRIKp6YIbHY
         JUVksnliMBFw7/C9weZG6uUOa0noK0NK1LF2zn4r3tppel8au95gTB2bbaQoH1TBZ4
         DXlFgW3if3fckEBzUk5fck1yMyulpMSzGdNpZaP4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/35] SUNRPC: defer slow parts of rpc_free_client() to a workqueue.
Date:   Thu,  7 May 2020 10:28:20 -0400
Message-Id: <20200507142830.26239-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
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
index abc63bd1be2b5..d99d39d45a494 100644
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
index f7f78566be463..a7430b66c7389 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -877,6 +877,20 @@ EXPORT_SYMBOL_GPL(rpc_shutdown_client);
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
@@ -887,17 +901,16 @@ rpc_free_client(struct rpc_clnt *clnt)
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

