Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C796028871B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbgJIKl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgJIKl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:41:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7729CC0613D2;
        Fri,  9 Oct 2020 03:41:28 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQppy-002DFq-PG; Fri, 09 Oct 2020 12:41:22 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-kernel@vger.kernel.org
Cc:     nstange@suse.de, ap420073@gmail.com, David.Laight@aculab.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] debugfs: protect against rmmod while files are open
Date:   Fri,  9 Oct 2020 12:41:13 +0200
Message-Id: <20201009124113.a723e46a677a.Ib6576679bb8db01eb34d3dce77c4c6899c28ce26@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
References: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Currently, things will crash (or at least UAF) in release() when
a module owning a debugfs file, but that didn't set the fops.owner,
is removed while the offending debugfs file is open.

Since we have the proxy_fops, we can break that down into two
different cases:

If the fops doesn't have a release method, we don't even need
to keep a reference to the real_fops, we can just fops_put()
them already in debugfs remove, and a later full_proxy_release()
won't call anything anyway - this just crashed/UAFed because it
used real_fops, not because there was actually a (now invalid)
release() method.

If, on the other hand, the fops do have a release method then
WARN and prevent adding this debugfs file if it doesn't also
have an owner and the release method is in a module. In theory,
the fops and the release method could be in different modules,
while this is something we don't really need to consider it is
in fact handled as well because we make a copy of the release()
pointer and call through that, releasing the fops when the file
is removed from debugfs.

Surely this warning will find a few places that should have an
owner, but at least then we don't have to add one everywhere.

Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 fs/debugfs/file.c     | 24 +++++++++++++++++++-----
 fs/debugfs/inode.c    |  9 +++++++++
 fs/debugfs/internal.h |  1 +
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index ae49a55bda00..addacefc356e 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -94,6 +94,7 @@ int debugfs_file_get(struct dentry *dentry)
 
 		fsd->real_fops = (void *)((unsigned long)d_fsd &
 					~DEBUGFS_FSDATA_IS_REAL_FOPS_BIT);
+		fsd->fop_release = fsd->real_fops->release;
 		refcount_set(&fsd->active_users, 1);
 		init_completion(&fsd->active_users_drained);
 		if (cmpxchg(&dentry->d_fsdata, d_fsd, fsd) != d_fsd) {
@@ -258,8 +259,8 @@ static __poll_t full_proxy_poll(struct file *filp,
 
 static int full_proxy_release(struct inode *inode, struct file *filp)
 {
-	const struct dentry *dentry = F_DENTRY(filp);
-	const struct file_operations *real_fops = debugfs_real_fops(filp);
+	struct dentry *dentry = F_DENTRY(filp);
+	struct debugfs_fsdata *fsd = dentry->d_fsdata;
 	const struct file_operations *proxy_fops = filp->f_op;
 	int r = 0;
 
@@ -268,13 +269,26 @@ static int full_proxy_release(struct inode *inode, struct file *filp)
 	 * original releaser should be called unconditionally in order
 	 * not to leak any resources. Releasers must not assume that
 	 * ->i_private is still being meaningful here.
+	 *
+	 * Note, however, that we don't reference real_fops (unless we
+	 * can guarantee it's still around). We made a copy of release()
+	 * before, in case it was NULL we then will not call anything and
+	 * don't need to use real_fops at all. This allows us to allow
+	 * module unloading of modules exposing debugfs files if they
+	 * don't have release() methods.
 	 */
-	if (real_fops->release)
-		r = real_fops->release(inode, filp);
+	if (fsd->fop_release)
+		r = fsd->fop_release(inode, filp);
 
 	replace_fops(filp, d_inode(dentry)->i_fop);
 	kfree((void *)proxy_fops);
-	fops_put(real_fops);
+
+	/* fops_put() only if not already gone */
+	if (refcount_inc_not_zero(&fsd->active_users)) {
+		fops_put(fsd->real_fops);
+		debugfs_file_put(dentry);
+	}
+
 	return r;
 }
 
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b7f2e971ecbc..25fd95f79c3b 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -377,6 +377,13 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	struct dentry *dentry;
 	struct inode *inode;
 
+	if (WARN(real_fops->release &&
+		 is_module_text_address((unsigned long)real_fops->release) &&
+		 !real_fops->owner,
+		 "%ps is in a module but %ps doesn't have an owner",
+		 real_fops->release, real_fops))
+		return ERR_PTR(-EINVAL);
+
 	if (!(mode & S_IFMT))
 		mode |= S_IFREG;
 	BUG_ON(!S_ISREG(mode));
@@ -672,6 +679,8 @@ static void __debugfs_file_removed(struct dentry *dentry)
 		return;
 	if (!refcount_dec_and_test(&fsd->active_users))
 		wait_for_completion(&fsd->active_users_drained);
+	fops_put(fsd->real_fops);
+	fsd->real_fops = NULL;
 }
 
 static void remove_one(struct dentry *victim)
diff --git a/fs/debugfs/internal.h b/fs/debugfs/internal.h
index 034e6973cead..160a77abcfab 100644
--- a/fs/debugfs/internal.h
+++ b/fs/debugfs/internal.h
@@ -17,6 +17,7 @@ extern const struct file_operations debugfs_full_proxy_file_operations;
 
 struct debugfs_fsdata {
 	const struct file_operations *real_fops;
+	int (*fop_release)(struct inode *, struct file *);
 	refcount_t active_users;
 	struct completion active_users_drained;
 };
-- 
2.26.2

