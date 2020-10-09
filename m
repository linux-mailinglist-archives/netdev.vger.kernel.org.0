Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6282883F8
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 09:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbgJIHxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 03:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732295AbgJIHxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 03:53:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DC8C0613D2;
        Fri,  9 Oct 2020 00:53:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQnDD-0028fB-BZ; Fri, 09 Oct 2020 09:53:11 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-kernel@vger.kernel.org
Cc:     nstange@suse.de, ap420073@gmail.com, David.Laight@aculab.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org
Subject: [CRAZY-RFF] debugfs: track open files and release on remove
Date:   Fri,  9 Oct 2020 09:53:06 +0200
Message-Id: <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <87v9fkgf4i.fsf@suse.de>
References: <87v9fkgf4i.fsf@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[RFF = Request For Flaming]

THIS IS PROBABLY COMPLETELY CRAZY.

Currently, if a module is unloaded while debugfs files are being
kept open, things crash since the ->release() method is called
only at the actual release, despite the proxy_fops, and then the
code is no longer around.

The correct way to fix this is to annotate all the debugfs fops
with .owner= THIS_MODULE, but as a learning exercise and to see
how much hate I can possibly receive, I figured I'd try to work
around this in debugfs itself.

First, if the fops have a release method and no owner, we track
all the open files - currently using a very simple array data
structure for it linked into struct debugfs_fsdata. This required
changing the API of debugfs_file_get() and debugfs_file_put() to
pass the struct file * to it.

Then, once we know which files are still open at remove time, we
can call all their release functions, and avoid calling them from
the proxy_fops. Of course still call them from the proxy_fops if
the file is still around, and clean up, so the release isn't all
deferred to the end, but done as soon as possible.

This introduces a potential locking issue, we could have a fops
struct that takes a lock in its release that the same module is
also taking around debugfs_remove(). To flag these issues using
lockdep, take inode_lock_shared() in full_proxy_release(), see
the comment there. If this triggers for some fops, add the owner
as it should have been in the first place.

Over adding the owner everywhere this has two small advantages:
 1) you can unload the module while a debugfs file is open;
 2) no need to change hundreds of places in the kernel :-)

(No, I won't sign off on this unless somebody _really_ wants it.)
---
 drivers/base/regmap/regmap-debugfs.c |   8 +-
 drivers/infiniband/hw/hfi1/debugfs.c |  10 +-
 drivers/infiniband/hw/hfi1/fault.c   |   8 +-
 fs/debugfs/file.c                    | 168 +++++++++++++++++++++------
 fs/debugfs/inode.c                   |  11 ++
 fs/debugfs/internal.h                |   7 ++
 include/linux/debugfs.h              |   4 +-
 7 files changed, 165 insertions(+), 51 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index b6d63ef16b44..1415fe9ba4c9 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -470,7 +470,7 @@ static ssize_t regmap_cache_only_write_file(struct file *file,
 	if (err)
 		return count;
 
-	err = debugfs_file_get(file->f_path.dentry);
+	err = debugfs_file_get(file);
 	if (err)
 		return err;
 
@@ -486,7 +486,7 @@ static ssize_t regmap_cache_only_write_file(struct file *file,
 	map->cache_only = new_val;
 
 	map->unlock(map->lock_arg);
-	debugfs_file_put(file->f_path.dentry);
+	debugfs_file_put(file);
 
 	if (require_sync) {
 		err = regcache_sync(map);
@@ -517,7 +517,7 @@ static ssize_t regmap_cache_bypass_write_file(struct file *file,
 	if (err)
 		return count;
 
-	err = debugfs_file_get(file->f_path.dentry);
+	err = debugfs_file_get(file);
 	if (err)
 		return err;
 
@@ -532,7 +532,7 @@ static ssize_t regmap_cache_bypass_write_file(struct file *file,
 	map->cache_bypass = new_val;
 
 	map->unlock(map->lock_arg);
-	debugfs_file_put(file->f_path.dentry);
+	debugfs_file_put(file);
 
 	return count;
 }
diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 2ced236e1553..81f38da1dee0 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -68,27 +68,25 @@ static struct dentry *hfi1_dbg_root;
 ssize_t hfi1_seq_read(struct file *file, char __user *buf, size_t size,
 		      loff_t *ppos)
 {
-	struct dentry *d = file->f_path.dentry;
 	ssize_t r;
 
-	r = debugfs_file_get(d);
+	r = debugfs_file_get(file);
 	if (unlikely(r))
 		return r;
 	r = seq_read(file, buf, size, ppos);
-	debugfs_file_put(d);
+	debugfs_file_put(file);
 	return r;
 }
 
 loff_t hfi1_seq_lseek(struct file *file, loff_t offset, int whence)
 {
-	struct dentry *d = file->f_path.dentry;
 	loff_t r;
 
-	r = debugfs_file_get(d);
+	r = debugfs_file_get(file);
 	if (unlikely(r))
 		return r;
 	r = seq_lseek(file, offset, whence);
-	debugfs_file_put(d);
+	debugfs_file_put(file);
 	return r;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index 0dfbcfb048ca..19b6e41458b6 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -146,7 +146,7 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 		goto free_data;
 	}
 
-	ret = debugfs_file_get(file->f_path.dentry);
+	ret = debugfs_file_get(file);
 	if (unlikely(ret))
 		goto free_data;
 	ptr = data;
@@ -196,7 +196,7 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 	}
 	ret = len;
 
-	debugfs_file_put(file->f_path.dentry);
+	debugfs_file_put(file);
 free_data:
 	kfree(data);
 	return ret;
@@ -215,7 +215,7 @@ static ssize_t fault_opcodes_read(struct file *file, char __user *buf,
 	data = kcalloc(datalen, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-	ret = debugfs_file_get(file->f_path.dentry);
+	ret = debugfs_file_get(file);
 	if (unlikely(ret))
 		goto free_data;
 	bit = find_first_bit(fault->opcodes, bitsize);
@@ -231,7 +231,7 @@ static ssize_t fault_opcodes_read(struct file *file, char __user *buf,
 					 bit);
 		bit = find_next_bit(fault->opcodes, bitsize, zero);
 	}
-	debugfs_file_put(file->f_path.dentry);
+	debugfs_file_put(file);
 	data[size - 1] = '\n';
 	data[size] = '\0';
 	ret = simple_read_from_buffer(buf, len, pos, data, size);
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index a768a09430c3..fa758e774568 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL_GPL(debugfs_real_fops);
 
 /**
  * debugfs_file_get - mark the beginning of file data access
- * @dentry: the dentry object whose data is being accessed.
+ * @file: the file object whose data is being accessed.
  *
  * Up to a matching call to debugfs_file_put(), any successive call
  * into the file removing functions debugfs_remove() and
@@ -79,8 +79,9 @@ EXPORT_SYMBOL_GPL(debugfs_real_fops);
  * it is not safe to access any of its data. If, on the other hand,
  * it is allowed to access the file data, zero is returned.
  */
-int debugfs_file_get(struct dentry *dentry)
+int debugfs_file_get(struct file *file)
 {
+	struct dentry *dentry = F_DENTRY(file);
 	struct debugfs_fsdata *fsd;
 	void *d_fsd;
 
@@ -94,9 +95,25 @@ int debugfs_file_get(struct dentry *dentry)
 
 		fsd->real_fops = (void *)((unsigned long)d_fsd &
 					~DEBUGFS_FSDATA_IS_REAL_FOPS_BIT);
+
+		if (fsd->real_fops->release && !fsd->real_fops->owner) {
+			fsd->files = kzalloc(struct_size(fsd->files, files, 4),
+					     GFP_KERNEL);
+			if (!fsd->files) {
+				kfree(fsd);
+				return -ENOMEM;
+			}
+			fsd->files->n_alloc = 4;
+			fsd->files->n_used = 0;
+			mutex_init(&fsd->files_lock);
+		} else {
+			fsd->files = NULL;
+		}
+
 		refcount_set(&fsd->active_users, 1);
 		init_completion(&fsd->active_users_drained);
 		if (cmpxchg(&dentry->d_fsdata, d_fsd, fsd) != d_fsd) {
+			kfree(fsd->files);
 			kfree(fsd);
 			fsd = READ_ONCE(dentry->d_fsdata);
 		}
@@ -116,21 +133,60 @@ int debugfs_file_get(struct dentry *dentry)
 	if (!refcount_inc_not_zero(&fsd->active_users))
 		return -EIO;
 
+	if (fsd->files) {
+		struct debugfs_files_release *files;
+		bool found = false;
+		unsigned int i;
+
+		mutex_lock(&fsd->files_lock);
+		/* re-read under mutex */
+		files = READ_ONCE(fsd->files);
+		for (i = 0; i < files->n_used; i++) {
+			if (files->files[i] == file) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			if (files->n_used >= files->n_alloc) {
+				struct debugfs_files_release *new;
+
+				files->n_alloc += 4;
+				new = krealloc(files,
+					       struct_size(new, files,
+							   files->n_alloc),
+					       GFP_KERNEL);
+				if (!new) {
+					files->n_alloc -= 4;
+					mutex_unlock(&fsd->files_lock);
+					refcount_dec(&fsd->active_users);
+					return -ENOMEM;
+				}
+				files = new;
+				fsd->files = files;
+			}
+			files->files[files->n_used++] = file;
+		}
+		mutex_unlock(&fsd->files_lock);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(debugfs_file_get);
 
 /**
  * debugfs_file_put - mark the end of file data access
- * @dentry: the dentry object formerly passed to
- *          debugfs_file_get().
+ * @file: the file object formerly passed to
+ *        debugfs_file_get().
  *
  * Allow any ongoing concurrent call into debugfs_remove() or
  * debugfs_remove_recursive() blocked by a former call to
  * debugfs_file_get() to proceed and return to its caller.
  */
-void debugfs_file_put(struct dentry *dentry)
+void debugfs_file_put(struct file *file)
 {
+	struct dentry *dentry = F_DENTRY(file);
 	struct debugfs_fsdata *fsd = READ_ONCE(dentry->d_fsdata);
 
 	if (refcount_dec_and_test(&fsd->active_users))
@@ -166,7 +222,7 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 	const struct file_operations *real_fops = NULL;
 	int r;
 
-	r = debugfs_file_get(dentry);
+	r = debugfs_file_get(filp);
 	if (r)
 		return r == -EIO ? -ENOENT : r;
 
@@ -195,7 +251,7 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 		r = real_fops->open(inode, filp);
 
 out:
-	debugfs_file_put(dentry);
+	debugfs_file_put(filp);
 	return r;
 }
 
@@ -209,16 +265,15 @@ const struct file_operations debugfs_open_proxy_file_operations = {
 #define FULL_PROXY_FUNC(name, ret_type, filp, proto, args)		\
 static ret_type full_proxy_ ## name(proto)				\
 {									\
-	struct dentry *dentry = F_DENTRY(filp);			\
 	const struct file_operations *real_fops;			\
 	ret_type r;							\
 									\
-	r = debugfs_file_get(dentry);					\
+	r = debugfs_file_get(filp);					\
 	if (unlikely(r))						\
 		return r;						\
 	real_fops = debugfs_real_fops(filp);				\
 	r = real_fops->name(args);					\
-	debugfs_file_put(dentry);					\
+	debugfs_file_put(filp);						\
 	return r;							\
 }
 
@@ -243,16 +298,15 @@ FULL_PROXY_FUNC(unlocked_ioctl, long, filp,
 static __poll_t full_proxy_poll(struct file *filp,
 				struct poll_table_struct *wait)
 {
-	struct dentry *dentry = F_DENTRY(filp);
 	__poll_t r = 0;
 	const struct file_operations *real_fops;
 
-	if (debugfs_file_get(dentry))
+	if (debugfs_file_get(filp))
 		return EPOLLHUP;
 
 	real_fops = debugfs_real_fops(filp);
 	r = real_fops->poll(filp, wait);
-	debugfs_file_put(dentry);
+	debugfs_file_put(filp);
 	return r;
 }
 
@@ -261,16 +315,65 @@ static int full_proxy_release(struct inode *inode, struct file *filp)
 	const struct dentry *dentry = F_DENTRY(filp);
 	const struct file_operations *real_fops = debugfs_real_fops(filp);
 	const struct file_operations *proxy_fops = filp->f_op;
+	struct debugfs_fsdata *fsd = dentry->d_fsdata;
 	int r = 0;
 
 	/*
-	 * We must not protect this against removal races here: the
-	 * original releaser should be called unconditionally in order
-	 * not to leak any resources. Releasers must not assume that
-	 * ->i_private is still being meaningful here.
+	 * If debugfs_file_get() fails here, the original releaser
+	 * was already called at debugfs_remove() time, so don't do
+	 * it again. This allows even removing a module while files
+	 * are open.
 	 */
-	if (real_fops->release)
+	if (!fsd->files) {
+		if (real_fops->release)
+			r = real_fops->release(inode, filp);
+	} else if (debugfs_file_get(filp) == 0) {
+		struct debugfs_files_release *files;
+
+		unsigned int i, old_n_used;
+
+		/*
+		 * XXX This is a hack - is this even allowed? XXX
+		 *
+		 * Take the inode lock here because we also hold it
+		 * during the other possible call to ->release during
+		 * debugfs_remove() over in __debugfs_file_removed().
+		 *
+		 * Taking it here also means that lockdep will *always*
+		 * record a chain from the inode lock to any locks the
+		 * debugfs user might take during release, and then if
+		 * they also hold the same locks during debugfs_remove()
+		 * it will complain.
+		 *
+		 * When it complains, we can then fix it by adding
+		 *
+		 *	.owner = THIS_MODULE
+		 *
+		 * to the relevant fops, in which case we won't get to
+		 * this path here, but to the above code block that's
+		 * only calling it directly.
+		 */
+		inode_lock_shared(inode);
 		r = real_fops->release(inode, filp);
+		inode_unlock_shared(inode);
+
+		mutex_lock(&fsd->files_lock);
+		/* re-read under mutex */
+		files = READ_ONCE(fsd->files);
+		old_n_used = files->n_used;
+		for (i = 0; i < files->n_used; i++) {
+			if (files->files[i] == filp) {
+				files->n_used--;
+				files->files[i] = files->files[files->n_used];
+				files->files[files->n_used] = NULL;
+				break;
+			}
+		}
+		WARN_ON(i >= old_n_used);
+		mutex_unlock(&fsd->files_lock);
+
+		debugfs_file_put(filp);
+	}
 
 	replace_fops(filp, d_inode(dentry)->i_fop);
 	kfree(proxy_fops);
@@ -301,7 +404,7 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 	struct file_operations *proxy_fops = NULL;
 	int r;
 
-	r = debugfs_file_get(dentry);
+	r = debugfs_file_get(filp);
 	if (r)
 		return r == -EIO ? -ENOENT : r;
 
@@ -351,7 +454,7 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 	kfree(proxy_fops);
 	fops_put(real_fops);
 out:
-	debugfs_file_put(dentry);
+	debugfs_file_put(filp);
 	return r;
 }
 
@@ -362,14 +465,13 @@ const struct file_operations debugfs_full_proxy_file_operations = {
 ssize_t debugfs_attr_read(struct file *file, char __user *buf,
 			size_t len, loff_t *ppos)
 {
-	struct dentry *dentry = F_DENTRY(file);
 	ssize_t ret;
 
-	ret = debugfs_file_get(dentry);
+	ret = debugfs_file_get(file);
 	if (unlikely(ret))
 		return ret;
 	ret = simple_attr_read(file, buf, len, ppos);
-	debugfs_file_put(dentry);
+	debugfs_file_put(file);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(debugfs_attr_read);
@@ -377,14 +479,13 @@ EXPORT_SYMBOL_GPL(debugfs_attr_read);
 ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
 			 size_t len, loff_t *ppos)
 {
-	struct dentry *dentry = F_DENTRY(file);
 	ssize_t ret;
 
-	ret = debugfs_file_get(dentry);
+	ret = debugfs_file_get(file);
 	if (unlikely(ret))
 		return ret;
 	ret = simple_attr_write(file, buf, len, ppos);
-	debugfs_file_put(dentry);
+	debugfs_file_put(file);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(debugfs_attr_write);
@@ -776,13 +877,12 @@ ssize_t debugfs_read_file_bool(struct file *file, char __user *user_buf,
 	char buf[3];
 	bool val;
 	int r;
-	struct dentry *dentry = F_DENTRY(file);
 
-	r = debugfs_file_get(dentry);
+	r = debugfs_file_get(file);
 	if (unlikely(r))
 		return r;
 	val = *(bool *)file->private_data;
-	debugfs_file_put(dentry);
+	debugfs_file_put(file);
 
 	if (val)
 		buf[0] = 'Y';
@@ -800,15 +900,14 @@ ssize_t debugfs_write_file_bool(struct file *file, const char __user *user_buf,
 	bool bv;
 	int r;
 	bool *val = file->private_data;
-	struct dentry *dentry = F_DENTRY(file);
 
 	r = kstrtobool_from_user(user_buf, count, &bv);
 	if (!r) {
-		r = debugfs_file_get(dentry);
+		r = debugfs_file_get(file);
 		if (unlikely(r))
 			return r;
 		*val = bv;
-		debugfs_file_put(dentry);
+		debugfs_file_put(file);
 	}
 
 	return count;
@@ -869,15 +968,14 @@ static ssize_t read_file_blob(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
 	struct debugfs_blob_wrapper *blob = file->private_data;
-	struct dentry *dentry = F_DENTRY(file);
 	ssize_t r;
 
-	r = debugfs_file_get(dentry);
+	r = debugfs_file_get(file);
 	if (unlikely(r))
 		return r;
 	r = simple_read_from_buffer(user_buf, count, ppos, blob->data,
 				blob->size);
-	debugfs_file_put(dentry);
+	debugfs_file_put(file);
 	return r;
 }
 
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 2fcf66473436..f34202c1d7ee 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -694,6 +694,17 @@ static void __debugfs_file_removed(struct dentry *dentry)
 		return;
 	if (!refcount_dec_and_test(&fsd->active_users))
 		wait_for_completion(&fsd->active_users_drained);
+
+	if (fsd->files) {
+		unsigned int i;
+
+		for (i = 0; i < fsd->files->n_used; i++)
+			fsd->real_fops->release(d_inode(dentry),
+						fsd->files->files[i]);
+
+		kfree(fsd->files);
+		fsd->files = NULL;
+	}
 }
 
 static void remove_one(struct dentry *victim)
diff --git a/fs/debugfs/internal.h b/fs/debugfs/internal.h
index 92af8ae31313..d898ef8108e6 100644
--- a/fs/debugfs/internal.h
+++ b/fs/debugfs/internal.h
@@ -15,10 +15,17 @@ extern const struct file_operations debugfs_noop_file_operations;
 extern const struct file_operations debugfs_open_proxy_file_operations;
 extern const struct file_operations debugfs_full_proxy_file_operations;
 
+struct debugfs_files_release {
+	unsigned int n_used, n_alloc;
+	struct file *files[];
+};
+
 struct debugfs_fsdata {
 	const struct file_operations *real_fops;
 	refcount_t active_users;
 	struct completion active_users_drained;
+	struct debugfs_files_release *files;
+	struct mutex files_lock;
 };
 
 /*
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 851dd1f9a8a5..ef32f7be19bc 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -93,8 +93,8 @@ void debugfs_remove(struct dentry *dentry);
 
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
-int debugfs_file_get(struct dentry *dentry);
-void debugfs_file_put(struct dentry *dentry);
+int debugfs_file_get(struct file *file);
+void debugfs_file_put(struct file *file);
 
 ssize_t debugfs_attr_read(struct file *file, char __user *buf,
 			size_t len, loff_t *ppos);
-- 
2.26.2

