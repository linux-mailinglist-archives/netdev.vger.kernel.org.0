Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD71547CF5
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 01:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237841AbiFLXqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 19:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiFLXqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 19:46:20 -0400
X-Greylist: delayed 53503 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Jun 2022 16:46:17 PDT
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8FD22506;
        Sun, 12 Jun 2022 16:46:17 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 5DE42C020; Mon, 13 Jun 2022 01:46:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655077575; bh=KOQAJGeSBAIgk3ukDBoTB7vytPgP1GjlIcTEfOHRoWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFheoy0CsWooFqvSK4/76QzRM3evDLCLnCmHJBCJiA6npb7/I7xC1hHE5bvXB3Xmt
         HbFQYOfq15vWJaBImtZU0EHvL6tqGoQe/YiE0t+2xpAAcn/bKxswu/wXAHH+Pguw9F
         1HJmin0GxyWuS0DYbigaHTlg5uL7S7OM8CQrQ85D4MntX7sfSw82QfJDFogwuhfYIK
         aeM7uvu1tv9p05v/jkE5JUojSmekkutzFXSTKT/CvUbWaHyzzSzjW0lhhKuCn/YEUo
         Lz69dPfNM3+OZQqZxbJrVoF/Ml3J0NlsSItYVLxyT4c382TIGLpLpXYvBYnWMjE1y1
         PvcgyC9Ot+f8A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 82B54C009;
        Mon, 13 Jun 2022 01:46:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655077572; bh=KOQAJGeSBAIgk3ukDBoTB7vytPgP1GjlIcTEfOHRoWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAV871imIg1NYcDI9OTNCCgXpZSts/I0lZ25qTm0zdILRx5UlZEYHamAypeR4XDLi
         84OtjfVm1SsB0htXglpN3S/K6F45d82lV9ndHf2FyIAyQIqL0Ldf8//cGN6ZinzBvD
         vrq05ZJCuwVurJebz2qmd6TFYO0FJEpFSNFWZ9EU3WHUAOooI0+GndDCBlQ7/+P+my
         Z2pOd+gx1QcATnEFJA+TbhLxT6jdEDUTC1x1gqayDC8RFXSYgAcO5mWK8hE7mmEtoi
         MyMrPWK60uJ6gkkXAsBRL1fy2/urrNKjADCRrM/0AhTZ1AU2lWwSJdJ5/Qlo0BJCt+
         s1AfwSv7OgoXA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 9d0a94b3;
        Sun, 12 Jun 2022 23:46:04 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 04/06] 9p fid refcount: add p9_fid_get/put wrappers
Date:   Mon, 13 Jun 2022 08:45:54 +0900
Message-Id: <20220612234557.1559736-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220612085330.1451496-5-asmadeus@codewreck.org>
References: <20220612085330.1451496-5-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was recently reminded that it is not clear that p9_client_clunk()
was actually just decrementing refcount and clunking only when that
reaches zero: make it clear through a set of helpers.

This will also allow instrumenting refcounting better for debugging
next patch, which is the reason these are not defined as static inline:
we won't be able to add trace events there...

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
v1 -> v2: p9_fid_get/put are now static inline in .h

 fs/9p/fid.c             | 18 ++++++++--------
 fs/9p/fid.h             |  2 +-
 fs/9p/vfs_addr.c        |  4 ++--
 fs/9p/vfs_dentry.c      |  4 ++--
 fs/9p/vfs_dir.c         |  2 +-
 fs/9p/vfs_file.c        |  4 ++--
 fs/9p/vfs_inode.c       | 48 ++++++++++++++++++++---------------------
 fs/9p/vfs_inode_dotl.c  | 42 ++++++++++++++++++------------------
 fs/9p/vfs_super.c       |  6 +++---
 fs/9p/xattr.c           |  8 +++----
 include/net/9p/client.h | 18 ++++++++++++++++
 net/9p/client.c         | 15 +++----------
 12 files changed, 90 insertions(+), 81 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index e8fad28fc5bd..d792499349c4 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -56,7 +56,7 @@ static struct p9_fid *v9fs_fid_find_inode(struct inode *inode, kuid_t uid)
 	h = (struct hlist_head *)&inode->i_private;
 	hlist_for_each_entry(fid, h, ilist) {
 		if (uid_eq(fid->uid, uid)) {
-			refcount_inc(&fid->count);
+			p9_fid_get(fid);
 			ret = fid;
 			break;
 		}
@@ -104,7 +104,7 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 		hlist_for_each_entry(fid, h, dlist) {
 			if (any || uid_eq(fid->uid, uid)) {
 				ret = fid;
-				refcount_inc(&ret->count);
+				p9_fid_get(ret);
 				break;
 			}
 		}
@@ -172,7 +172,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		old_fid = fid;
 
 		fid = p9_client_walk(old_fid, 1, &dentry->d_name.name, 1);
-		p9_client_clunk(old_fid);
+		p9_fid_put(old_fid);
 		goto fid_out;
 	}
 	up_read(&v9ses->rename_sem);
@@ -194,7 +194,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		if (IS_ERR(root_fid))
 			return root_fid;
 
-		refcount_inc(&root_fid->count);
+		p9_fid_get(root_fid);
 		v9fs_fid_add(dentry->d_sb->s_root, root_fid);
 	}
 	/* If we are root ourself just return that */
@@ -225,7 +225,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 				     old_fid == root_fid /* clone */);
 		/* non-cloning walk will return the same fid */
 		if (fid != old_fid) {
-			p9_client_clunk(old_fid);
+			p9_fid_put(old_fid);
 			old_fid = fid;
 		}
 		if (IS_ERR(fid)) {
@@ -240,11 +240,11 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		spin_lock(&dentry->d_lock);
 		if (d_unhashed(dentry)) {
 			spin_unlock(&dentry->d_lock);
-			p9_client_clunk(fid);
+			p9_fid_put(fid);
 			fid = ERR_PTR(-ENOENT);
 		} else {
 			__add_fid(dentry, fid);
-			refcount_inc(&fid->count);
+			p9_fid_get(fid);
 			spin_unlock(&dentry->d_lock);
 		}
 	}
@@ -301,7 +301,7 @@ struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 	fid = clone_fid(ofid);
 	if (IS_ERR(fid))
 		goto error_out;
-	p9_client_clunk(ofid);
+	p9_fid_put(ofid);
 	/*
 	 * writeback fid will only be used to write back the
 	 * dirty pages. We always request for the open fid in read-write
@@ -310,7 +310,7 @@ struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 	 */
 	err = p9_client_open(fid, O_RDWR);
 	if (err < 0) {
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 		fid = ERR_PTR(err);
 		goto error_out;
 	}
diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index f7f33509e169..3168dfad510e 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -29,7 +29,7 @@ static inline struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 		return fid;
 
 	nfid = clone_fid(fid);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	return nfid;
 }
 #endif
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 8ce82ff1e40a..ed598160e0c6 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -60,7 +60,7 @@ static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
 	struct p9_fid *fid = file->private_data;
 
-	refcount_inc(&fid->count);
+	p9_fid_get(fid);
 	rreq->netfs_priv = fid;
 	return 0;
 }
@@ -74,7 +74,7 @@ static void v9fs_req_cleanup(struct address_space *mapping, void *priv)
 {
 	struct p9_fid *fid = priv;
 
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 }
 
 /**
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index 1c609e99d280..f89f01734587 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -54,7 +54,7 @@ static void v9fs_dentry_release(struct dentry *dentry)
 	p9_debug(P9_DEBUG_VFS, " dentry: %pd (%p)\n",
 		 dentry, dentry);
 	hlist_for_each_safe(p, n, (struct hlist_head *)&dentry->d_fsdata)
-		p9_client_clunk(hlist_entry(p, struct p9_fid, dlist));
+		p9_fid_put(hlist_entry(p, struct p9_fid, dlist));
 	dentry->d_fsdata = NULL;
 }
 
@@ -85,7 +85,7 @@ static int v9fs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
 			retval = v9fs_refresh_inode_dotl(fid, inode);
 		else
 			retval = v9fs_refresh_inode(fid, inode);
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 
 		if (retval == -ENOENT)
 			return 0;
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 958680f7f23e..000fbaae9b18 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -218,7 +218,7 @@ int v9fs_dir_release(struct inode *inode, struct file *filp)
 		spin_lock(&inode->i_lock);
 		hlist_del(&fid->ilist);
 		spin_unlock(&inode->i_lock);
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 	}
 
 	if ((filp->f_mode & FMODE_WRITE)) {
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 2573c08f335c..8276f3af35d7 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -63,7 +63,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 
 		err = p9_client_open(fid, omode);
 		if (err < 0) {
-			p9_client_clunk(fid);
+			p9_fid_put(fid);
 			return err;
 		}
 		if ((file->f_flags & O_APPEND) &&
@@ -98,7 +98,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	v9fs_open_fid_add(inode, fid);
 	return 0;
 out_error:
-	p9_client_clunk(file->private_data);
+	p9_fid_put(file->private_data);
 	file->private_data = NULL;
 	return err;
 }
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 18c780ffd4b5..38186d1a1440 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -399,7 +399,7 @@ void v9fs_evict_inode(struct inode *inode)
 	fscache_relinquish_cookie(v9fs_inode_cookie(v9inode), false);
 	/* clunk the fid stashed in writeback_fid */
 	if (v9inode->writeback_fid) {
-		p9_client_clunk(v9inode->writeback_fid);
+		p9_fid_put(v9inode->writeback_fid);
 		v9inode->writeback_fid = NULL;
 	}
 }
@@ -568,7 +568,7 @@ static int v9fs_remove(struct inode *dir, struct dentry *dentry, int flags)
 	if (v9fs_proto_dotl(v9ses))
 		retval = p9_client_unlinkat(dfid, dentry->d_name.name,
 					    v9fs_at_to_dotl_flags(flags));
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 	if (retval == -EOPNOTSUPP) {
 		/* Try the one based on path */
 		v9fid = v9fs_fid_clone(dentry);
@@ -632,14 +632,14 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
-		p9_client_clunk(dfid);
+		p9_fid_put(dfid);
 		return ERR_PTR(err);
 	}
 
 	err = p9_client_fcreate(ofid, name, perm, mode, extension);
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_fcreate failed %d\n", err);
-		p9_client_clunk(dfid);
+		p9_fid_put(dfid);
 		goto error;
 	}
 
@@ -651,7 +651,7 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 			p9_debug(P9_DEBUG_VFS,
 				   "p9_client_walk failed %d\n", err);
 			fid = NULL;
-			p9_client_clunk(dfid);
+			p9_fid_put(dfid);
 			goto error;
 		}
 		/*
@@ -662,20 +662,20 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 			err = PTR_ERR(inode);
 			p9_debug(P9_DEBUG_VFS,
 				   "inode creation failed %d\n", err);
-			p9_client_clunk(dfid);
+			p9_fid_put(dfid);
 			goto error;
 		}
 		v9fs_fid_add(dentry, fid);
 		d_instantiate(dentry, inode);
 	}
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 	return ofid;
 error:
 	if (ofid)
-		p9_client_clunk(ofid);
+		p9_fid_put(ofid);
 
 	if (fid)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 
 	return ERR_PTR(err);
 }
@@ -707,7 +707,7 @@ v9fs_vfs_create(struct user_namespace *mnt_userns, struct inode *dir,
 		return PTR_ERR(fid);
 
 	v9fs_invalidate_inode_attr(dir);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 
 	return 0;
 }
@@ -743,7 +743,7 @@ static int v9fs_vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	}
 
 	if (fid)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 
 	return err;
 }
@@ -784,7 +784,7 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	 */
 	name = dentry->d_name.name;
 	fid = p9_client_walk(dfid, 1, &name, 1);
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 	if (fid == ERR_PTR(-ENOENT))
 		inode = NULL;
 	else if (IS_ERR(fid))
@@ -807,7 +807,7 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 		else if (!IS_ERR(res))
 			v9fs_fid_add(res, fid);
 		else
-			p9_client_clunk(fid);
+			p9_fid_put(fid);
 	}
 	return res;
 }
@@ -890,7 +890,7 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 
 error:
 	if (fid)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 	goto out;
 }
 
@@ -958,7 +958,7 @@ v9fs_vfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	dfid = v9fs_parent_fid(old_dentry);
 	olddirfid = clone_fid(dfid);
 	if (dfid && !IS_ERR(dfid))
-		p9_client_clunk(dfid);
+		p9_fid_put(dfid);
 
 	if (IS_ERR(olddirfid)) {
 		retval = PTR_ERR(olddirfid);
@@ -967,7 +967,7 @@ v9fs_vfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 
 	dfid = v9fs_parent_fid(new_dentry);
 	newdirfid = clone_fid(dfid);
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 
 	if (IS_ERR(newdirfid)) {
 		retval = PTR_ERR(newdirfid);
@@ -1019,13 +1019,13 @@ v9fs_vfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		d_move(old_dentry, new_dentry);
 	}
 	up_write(&v9ses->rename_sem);
-	p9_client_clunk(newdirfid);
+	p9_fid_put(newdirfid);
 
 clunk_olddir:
-	p9_client_clunk(olddirfid);
+	p9_fid_put(olddirfid);
 
 done:
-	p9_client_clunk(oldfid);
+	p9_fid_put(oldfid);
 	return retval;
 }
 
@@ -1059,7 +1059,7 @@ v9fs_vfs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		return PTR_ERR(fid);
 
 	st = p9_client_stat(fid);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	if (IS_ERR(st))
 		return PTR_ERR(st);
 
@@ -1135,7 +1135,7 @@ static int v9fs_vfs_setattr(struct user_namespace *mnt_userns,
 	retval = p9_client_wstat(fid, &wstat);
 
 	if (use_dentry)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 
 	if (retval < 0)
 		return retval;
@@ -1260,7 +1260,7 @@ static const char *v9fs_vfs_get_link(struct dentry *dentry,
 		return ERR_CAST(fid);
 
 	st = p9_client_stat(fid);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	if (IS_ERR(st))
 		return ERR_CAST(st);
 
@@ -1307,7 +1307,7 @@ static int v9fs_vfs_mkspecial(struct inode *dir, struct dentry *dentry,
 		return PTR_ERR(fid);
 
 	v9fs_invalidate_inode_attr(dir);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	return 0;
 }
 
@@ -1363,7 +1363,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 		v9fs_refresh_inode(oldfid, d_inode(old_dentry));
 		v9fs_invalidate_inode_attr(dir);
 	}
-	p9_client_clunk(oldfid);
+	p9_fid_put(oldfid);
 	return retval;
 }
 
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index b6eb1160296c..09b124fe349c 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -274,7 +274,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
-		p9_client_clunk(dfid);
+		p9_fid_put(dfid);
 		goto out;
 	}
 
@@ -286,7 +286,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
 			 err);
-		p9_client_clunk(dfid);
+		p9_fid_put(dfid);
 		goto error;
 	}
 	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
@@ -294,14 +294,14 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
 			 err);
-		p9_client_clunk(dfid);
+		p9_fid_put(dfid);
 		goto error;
 	}
 	v9fs_invalidate_inode_attr(dir);
 
 	/* instantiate inode and assign the unopened fid to the dentry */
 	fid = p9_client_walk(dfid, 1, &name, 1);
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 	if (IS_ERR(fid)) {
 		err = PTR_ERR(fid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
@@ -358,10 +358,10 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 
 error:
 	if (fid)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 err_clunk_old_fid:
 	if (ofid)
-		p9_client_clunk(ofid);
+		p9_fid_put(ofid);
 	goto out;
 }
 
@@ -458,9 +458,9 @@ static int v9fs_vfs_mkdir_dotl(struct user_namespace *mnt_userns,
 	v9fs_invalidate_inode_attr(dir);
 error:
 	if (fid)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 	v9fs_put_acl(dacl, pacl);
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 	return err;
 }
 
@@ -489,7 +489,7 @@ v9fs_vfs_getattr_dotl(struct user_namespace *mnt_userns,
 	 */
 
 	st = p9_client_getattr_dotl(fid, P9_STATS_ALL);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	if (IS_ERR(st))
 		return PTR_ERR(st);
 
@@ -603,7 +603,7 @@ int v9fs_vfs_setattr_dotl(struct user_namespace *mnt_userns,
 	retval = p9_client_setattr(fid, &p9attr);
 	if (retval < 0) {
 		if (use_dentry)
-			p9_client_clunk(fid);
+			p9_fid_put(fid);
 		return retval;
 	}
 
@@ -619,12 +619,12 @@ int v9fs_vfs_setattr_dotl(struct user_namespace *mnt_userns,
 		retval = v9fs_acl_chmod(inode, fid);
 		if (retval < 0) {
 			if (use_dentry)
-				p9_client_clunk(fid);
+				p9_fid_put(fid);
 			return retval;
 		}
 	}
 	if (use_dentry)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 
 	return 0;
 }
@@ -771,9 +771,9 @@ v9fs_vfs_symlink_dotl(struct user_namespace *mnt_userns, struct inode *dir,
 
 error:
 	if (fid)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 	return err;
 }
 
@@ -803,14 +803,14 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 
 	oldfid = v9fs_fid_lookup(old_dentry);
 	if (IS_ERR(oldfid)) {
-		p9_client_clunk(dfid);
+		p9_fid_put(dfid);
 		return PTR_ERR(oldfid);
 	}
 
 	err = p9_client_link(dfid, oldfid, dentry->d_name.name);
 
-	p9_client_clunk(dfid);
-	p9_client_clunk(oldfid);
+	p9_fid_put(dfid);
+	p9_fid_put(oldfid);
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_link failed %d\n", err);
 		return err;
@@ -826,7 +826,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 			return PTR_ERR(fid);
 
 		v9fs_refresh_inode_dotl(fid, d_inode(old_dentry));
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 	}
 	ihold(d_inode(old_dentry));
 	d_instantiate(dentry, d_inode(old_dentry));
@@ -924,9 +924,9 @@ v9fs_vfs_mknod_dotl(struct user_namespace *mnt_userns, struct inode *dir,
 	}
 error:
 	if (fid)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 	v9fs_put_acl(dacl, pacl);
-	p9_client_clunk(dfid);
+	p9_fid_put(dfid);
 
 	return err;
 }
@@ -956,7 +956,7 @@ v9fs_vfs_get_link_dotl(struct dentry *dentry,
 	if (IS_ERR(fid))
 		return ERR_CAST(fid);
 	retval = p9_client_readlink(fid, &target);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	if (retval)
 		return ERR_PTR(retval);
 	set_delayed_call(done, kfree_link, target);
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 97e23b4e6982..bf350fad9500 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -190,7 +190,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	return dget(sb->s_root);
 
 clunk_fid:
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	v9fs_session_close(v9ses);
 free_session:
 	kfree(v9ses);
@@ -203,7 +203,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	 * attached the fid to dentry so it won't get clunked
 	 * automatically.
 	 */
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	deactivate_locked_super(sb);
 	return ERR_PTR(retval);
 }
@@ -270,7 +270,7 @@ static int v9fs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	}
 	res = simple_statfs(dentry, buf);
 done:
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	return res;
 }
 
diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index a824441b95a2..1f9298a4bd42 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -44,7 +44,7 @@ ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
 		if (err)
 			retval = err;
 	}
-	p9_client_clunk(attr_fid);
+	p9_fid_put(attr_fid);
 	return retval;
 }
 
@@ -71,7 +71,7 @@ ssize_t v9fs_xattr_get(struct dentry *dentry, const char *name,
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 	ret = v9fs_fid_xattr_get(fid, name, buffer, buffer_size);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 
 	return ret;
 }
@@ -98,7 +98,7 @@ int v9fs_xattr_set(struct dentry *dentry, const char *name,
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 	ret = v9fs_fid_xattr_set(fid, name, value, value_len, flags);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	return ret;
 }
 
@@ -128,7 +128,7 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
 			 retval);
 	else
 		p9_client_write(fid, 0, &from, &retval);
-	err = p9_client_clunk(fid);
+	err = p9_fid_put(fid);
 	if (!retval && err)
 		retval = err;
 	return retval;
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index ec1d1706f43c..9fd38d674057 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -237,6 +237,24 @@ static inline int p9_req_try_get(struct p9_req_t *r)
 
 int p9_req_put(struct p9_req_t *r);
 
+static inline struct p9_fid *p9_fid_get(struct p9_fid *fid)
+{
+	refcount_inc(&fid->count);
+
+	return fid;
+}
+
+static inline int p9_fid_put(struct p9_fid *fid)
+{
+	if (!fid || IS_ERR(fid))
+		return 0;
+
+	if (!refcount_dec_and_test(&fid->count))
+		return 0;
+
+	return p9_client_clunk(fid);
+}
+
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status);
 
 int p9_parse_header(struct p9_fcall *pdu, int32_t *size, int8_t *type,
diff --git a/net/9p/client.c b/net/9p/client.c
index 8bba0d9cf975..f3eb280c7d9d 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1228,7 +1228,7 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 
 clunk_fid:
 	kfree(wqids);
-	p9_client_clunk(fid);
+	p9_fid_put(fid);
 	fid = NULL;
 
 error:
@@ -1459,15 +1459,6 @@ int p9_client_clunk(struct p9_fid *fid)
 	struct p9_req_t *req;
 	int retries = 0;
 
-	if (!fid || IS_ERR(fid)) {
-		pr_warn("%s (%d): Trying to clunk with invalid fid\n",
-			__func__, task_pid_nr(current));
-		dump_stack();
-		return 0;
-	}
-	if (!refcount_dec_and_test(&fid->count))
-		return 0;
-
 again:
 	p9_debug(P9_DEBUG_9P, ">>> TCLUNK fid %d (try %d)\n",
 		 fid->fid, retries);
@@ -1519,7 +1510,7 @@ int p9_client_remove(struct p9_fid *fid)
 	p9_tag_remove(clnt, req);
 error:
 	if (err == -ERESTARTSYS)
-		p9_client_clunk(fid);
+		p9_fid_put(fid);
 	else
 		p9_fid_destroy(fid);
 	return err;
@@ -2042,7 +2033,7 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 		 attr_fid->fid, *attr_size);
 	return attr_fid;
 clunk_fid:
-	p9_client_clunk(attr_fid);
+	p9_fid_put(attr_fid);
 	attr_fid = NULL;
 error:
 	if (attr_fid && attr_fid != file_fid)
-- 
2.35.1

