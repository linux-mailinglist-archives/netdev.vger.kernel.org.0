Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752E852F51D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353686AbiETV2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353673AbiETV2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:28:11 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148E01A049E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:28:08 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-f1d2ea701dso11691680fac.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q5XQbNfGLJj67L4v4YP9Q8N+TcenfAdGg5BYcJ6pnxQ=;
        b=QBJktHUU1iN4vRd8xSBXSmAX82+DjXCbj0+OAqFSq64kIP1kWmXXpLbA/DKKcOLLgX
         jG6ZGOGTFdoiCrZLvxsBEGpAPfE25A7y77MO0yVW2WL6ChRyj6FMvz+uv0zwczTvytc7
         YJJ1hWu/8Pw7klMJ+IDBCUvepOaV5+ovdHOJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q5XQbNfGLJj67L4v4YP9Q8N+TcenfAdGg5BYcJ6pnxQ=;
        b=uPJ+6VH2Yf2tRXpMxJHA5Bu1roaeAROaePvjmZ4mLlTdPxmCNunwvAFR0cizCarORE
         fmacNTnZBceDeeRwr4F4GL4JM+4rNyQPrrkzL12VqM4gINPpKEg86V1RtOsWPoUSpmj9
         NPKVWSN8ENOS2+6S5F39P9ZO9xHVghBkhI9daZqr0Z7rvPuVzm9iecZkQeYQV4oAJjWr
         srjwbsogfFqU7Y6hXjX5ZuPofy5HclpfGlKNzf6MwEgEN7F5Ka83HFWIZl2vvX3/3CFE
         Rf2i+Zv5Grk2IQAQheiCZ0iLxbFdjuEBQClyLysEhh0zSFY9GosvWfY1++0nhuHPmUxc
         9kZQ==
X-Gm-Message-State: AOAM532Kls3zo4q1QvY+jw7fb8lFszoTdiVVxFiSBa8hSerYD8MhtJjF
        Bm6KkoNtIjYmyJdyIqG+aV0bRQ==
X-Google-Smtp-Source: ABdhPJyNOgE+ThNaeFZWCemWGDqk2cp4HcFCpiFSVcYcsByOTJCWo32ouonZKQ5WlM2Yzus5g0ORYA==
X-Received: by 2002:a05:6870:a10f:b0:f1:ce0b:4512 with SMTP id m15-20020a056870a10f00b000f1ce0b4512mr7339793oae.147.1653082086993;
        Fri, 20 May 2022 14:28:06 -0700 (PDT)
Received: from localhost.localdomain ([172.58.84.73])
        by smtp.gmail.com with ESMTPSA id 5-20020a9d0005000000b00606387601a2sm1383344ota.34.2022.05.20.14.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 14:28:06 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH] cred: Propagate security_prepare_creds() error code
Date:   Fri, 20 May 2022 16:27:46 -0500
Message-Id: <20220520212746.95075-1-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While experimenting with the security_prepare_creds() LSM hook, we
noticed that our EPERM error code was not propagated up the callstack.
Instead ENOMEM is always returned.  As a result, some tools may send a
confusing error message to the user:

$ unshare -rU
unshare: unshare failed: Cannot allocate memory

A user would think that the system didn't have enough memory, when
instead the action was denied.

This problem occurs because prepare_creds() and prepare_kernel_cred()
return NULL when security_prepare_creds() returns an error code. Later,
functions calling prepare_creds() and prepare_kernel_cred() return
ENOMEM because they assume that a NULL meant there was no memory
allocated.

Fix this by propagating an error code from security_prepare_creds() up
the callstack.

Signed-off-by: Frederick Lawler <fred@cloudflare.com>
---
 fs/aio.c                               |  4 +--
 fs/cachefiles/security.c               |  8 ++---
 fs/cifs/cifs_spnego.c                  |  4 +--
 fs/cifs/cifsacl.c                      |  4 +--
 fs/coredump.c                          |  2 +-
 fs/exec.c                              | 14 ++++++---
 fs/ksmbd/smb_common.c                  |  4 +--
 fs/nfs/flexfilelayout/flexfilelayout.c |  7 +++--
 fs/nfs/nfs4idmap.c                     |  4 +--
 fs/nfsd/auth.c                         |  4 +--
 fs/nfsd/nfs4callback.c                 | 10 +++---
 fs/nfsd/nfs4recover.c                  |  4 +--
 fs/nfsd/nfsfh.c                        |  4 +--
 fs/open.c                              | 10 +++---
 fs/overlayfs/dir.c                     | 42 ++++++++++++++------------
 fs/overlayfs/super.c                   |  5 +--
 kernel/capability.c                    |  4 +--
 kernel/cred.c                          | 28 +++++++++--------
 kernel/groups.c                        |  4 +--
 kernel/nsproxy.c                       | 18 ++++++++---
 kernel/sys.c                           | 28 ++++++++---------
 kernel/trace/trace_events_user.c       |  5 ++-
 kernel/umh.c                           |  5 +--
 kernel/user_namespace.c                | 17 ++++++-----
 net/dns_resolver/dns_key.c             |  4 +--
 security/apparmor/task.c               | 14 ++++-----
 security/commoncap.c                   | 20 ++++++------
 security/keys/keyctl.c                 |  8 ++---
 security/keys/process_keys.c           | 16 +++++-----
 security/landlock/syscalls.c           |  4 +--
 security/selinux/hooks.c               |  8 ++---
 security/smack/smack_lsm.c             |  8 ++---
 security/smack/smackfs.c               |  4 +--
 33 files changed, 175 insertions(+), 150 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3c249b938632..84f52b8b5aae 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1628,8 +1628,8 @@ static int aio_fsync(struct fsync_iocb *req, const struct iocb *iocb,
 		return -EINVAL;
 
 	req->creds = prepare_creds();
-	if (!req->creds)
-		return -ENOMEM;
+	if (IS_ERR(req->creds))
+		return PTR_ERR(req->creds);
 
 	req->datasync = datasync;
 	INIT_WORK(&req->work, aio_fsync_work);
diff --git a/fs/cachefiles/security.c b/fs/cachefiles/security.c
index fe777164f1d8..8dc256b18312 100644
--- a/fs/cachefiles/security.c
+++ b/fs/cachefiles/security.c
@@ -21,8 +21,8 @@ int cachefiles_get_security_ID(struct cachefiles_cache *cache)
 	_enter("{%s}", cache->secctx);
 
 	new = prepare_kernel_cred(current);
-	if (!new) {
-		ret = -ENOMEM;
+	if (IS_ERR(new)) {
+		ret = PTR_ERR(new);
 		goto error;
 	}
 
@@ -84,8 +84,8 @@ int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
 	/* duplicate the cache creds for COW (the override is currently in
 	 * force, so we can use prepare_creds() to do this) */
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	cachefiles_end_secure(cache, *_saved_cred);
 
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 342717bf1dc2..0a5b8157387a 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -190,8 +190,8 @@ init_cifs_spnego(void)
 	 */
 
 	cred = prepare_kernel_cred(NULL);
-	if (!cred)
-		return -ENOMEM;
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
 
 	keyring = keyring_alloc(".cifs_spnego",
 				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index bf861fef2f0c..1debcfa927d1 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -466,8 +466,8 @@ init_cifs_idmap(void)
 	 * with add_key().
 	 */
 	cred = prepare_kernel_cred(NULL);
-	if (!cred)
-		return -ENOMEM;
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
 
 	keyring = keyring_alloc(".cifs_idmap",
 				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
diff --git a/fs/coredump.c b/fs/coredump.c
index ebc43f960b64..ea4ccae6368a 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -546,7 +546,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 		goto fail;
 
 	cred = prepare_creds();
-	if (!cred)
+	if (IS_ERR(cred))
 		goto fail;
 	/*
 	 * We cannot trust fsuid as being the "true" uid of the process
diff --git a/fs/exec.c b/fs/exec.c
index e3e55d5e0be1..a9139f31eb8f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1466,15 +1466,19 @@ EXPORT_SYMBOL(finalize_exec);
  */
 static int prepare_bprm_creds(struct linux_binprm *bprm)
 {
+	int err = -ERESTARTNOINTR;
 	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
-		return -ERESTARTNOINTR;
+		return err;
 
 	bprm->cred = prepare_exec_creds();
-	if (likely(bprm->cred))
-		return 0;
+	if (IS_ERR(bprm->cred)) {
+		err = PTR_ERR(bprm->cred);
+		bprm->cred = NULL;
+		mutex_unlock(&current->signal->cred_guard_mutex);
+		return err;
+	}
 
-	mutex_unlock(&current->signal->cred_guard_mutex);
-	return -ENOMEM;
+	return 0;
 }
 
 static void free_bprm(struct linux_binprm *bprm)
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 9a7e211dbf4f..285006184afb 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -620,8 +620,8 @@ int ksmbd_override_fsids(struct ksmbd_work *work)
 		gid = share->force_gid;
 
 	cred = prepare_kernel_cred(NULL);
-	if (!cred)
-		return -ENOMEM;
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
 
 	cred->fsuid = make_kuid(current_user_ns(), uid);
 	cred->fsgid = make_kgid(current_user_ns(), gid);
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 604be402ae13..74d950a6dd55 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -493,9 +493,12 @@ ff_layout_alloc_lseg(struct pnfs_layout_hdr *lh,
 			kcred = prepare_kernel_cred(NULL);
 			memalloc_nofs_restore(nofs_flags);
 		}
-		rc = -ENOMEM;
-		if (!kcred)
+
+		if (IS_ERR(kcred)) {
+			rc = PTR_ERR(kcred);
 			goto out_err_free;
+		}
+
 		kcred->fsuid = uid;
 		kcred->fsgid = gid;
 		cred = RCU_INITIALIZER(kcred);
diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index f331866dd418..6ddceff5fbe0 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -204,8 +204,8 @@ int nfs_idmap_init(void)
 		key_type_id_resolver.name);
 
 	cred = prepare_kernel_cred(NULL);
-	if (!cred)
-		return -ENOMEM;
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
 
 	keyring = keyring_alloc(".id_resolver",
 				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index fdf2aad73470..9206ec3ed0f1 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -31,8 +31,8 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	/* discard any old override before preparing the new set */
 	revert_creds(get_cred(current_real_cred()));
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	new->fsuid = rqstp->rq_cred.cr_uid;
 	new->fsgid = rqstp->rq_cred.cr_gid;
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 11f8715d92d6..630c2af0ec74 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -872,8 +872,8 @@ static const struct cred *get_backchannel_cred(struct nfs4_client *clp, struct r
 		struct cred *kcred;
 
 		kcred = prepare_kernel_cred(NULL);
-		if (!kcred)
-			return NULL;
+		if (IS_ERR(kcred))
+			return ERR_CAST(kcred);
 
 		kcred->uid = ses->se_cb_sec.uid;
 		kcred->gid = ses->se_cb_sec.gid;
@@ -932,10 +932,10 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		return PTR_ERR(client);
 	}
 	cred = get_backchannel_cred(clp, client, ses);
-	if (!cred) {
-		trace_nfsd_cb_setup_err(clp, -ENOMEM);
+	if (IS_ERR(cred)) {
+		trace_nfsd_cb_setup_err(clp, PTR_ERR(cred));
 		rpc_shutdown_client(client);
-		return -ENOMEM;
+		return PTR_ERR(cred);
 	}
 	clp->cl_cb_client = client;
 	clp->cl_cb_cred = cred;
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index c634483d85d2..8e1b196928c1 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -75,8 +75,8 @@ nfs4_save_creds(const struct cred **original_creds)
 	struct cred *new;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	new->fsuid = GLOBAL_ROOT_UID;
 	new->fsgid = GLOBAL_ROOT_GID;
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index c29baa03dfaf..e09e614117bd 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -219,8 +219,8 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 		 * fix that case easily.
 		 */
 		struct cred *new = prepare_creds();
-		if (!new) {
-			error =  nfserrno(-ENOMEM);
+		if (IS_ERR(new)) {
+			error =  nfserrno(PTR_ERR(new));
 			goto out;
 		}
 		new->cap_effective =
diff --git a/fs/open.c b/fs/open.c
index 1315253e0247..d4601a557df0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -350,8 +350,8 @@ static const struct cred *access_override_creds(void)
 	struct cred *override_cred;
 
 	override_cred = prepare_creds();
-	if (!override_cred)
-		return NULL;
+	if (IS_ERR(override_cred))
+		return ERR_CAST(override_cred);
 
 	override_cred->fsuid = override_cred->uid;
 	override_cred->fsgid = override_cred->gid;
@@ -414,8 +414,8 @@ static long do_faccessat(int dfd, const char __user *filename, int mode, int fla
 
 	if (!(flags & AT_EACCESS)) {
 		old_cred = access_override_creds();
-		if (!old_cred)
-			return -ENOMEM;
+		if (IS_ERR(old_cred))
+			return PTR_ERR(old_cred);
 	}
 
 retry:
@@ -1173,7 +1173,7 @@ struct file *filp_open(const char *filename, int flags, umode_t mode)
 {
 	struct filename *name = getname_kernel(filename);
 	struct file *file = ERR_CAST(name);
-	
+
 	if (!IS_ERR(name)) {
 		file = file_open_name(name, flags, mode);
 		putname(name);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f18490813170..905eb8f69d64 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -589,28 +589,32 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 			goto out_revert_creds;
 	}
 
-	err = -ENOMEM;
 	override_cred = prepare_creds();
-	if (override_cred) {
-		override_cred->fsuid = inode->i_uid;
-		override_cred->fsgid = inode->i_gid;
-		if (!attr->hardlink) {
-			err = security_dentry_create_files_as(dentry,
-					attr->mode, &dentry->d_name, old_cred,
-					override_cred);
-			if (err) {
-				put_cred(override_cred);
-				goto out_revert_creds;
-			}
-		}
-		put_cred(override_creds(override_cred));
-		put_cred(override_cred);
+	if (IS_ERR(override_cred)) {
+		err = PTR_ERR(override_cred);
+		goto out_revert_creds;
+	}
 
-		if (!ovl_dentry_is_whiteout(dentry))
-			err = ovl_create_upper(dentry, inode, attr);
-		else
-			err = ovl_create_over_whiteout(dentry, inode, attr);
+	override_cred->fsuid = inode->i_uid;
+	override_cred->fsgid = inode->i_gid;
+	if (!attr->hardlink) {
+		err = security_dentry_create_files_as(dentry, attr->mode,
+						      &dentry->d_name,
+						      old_cred,
+						      override_cred);
+		if (err) {
+			put_cred(override_cred);
+			goto out_revert_creds;
+		}
 	}
+	put_cred(override_creds(override_cred));
+	put_cred(override_cred);
+
+	if (!ovl_dentry_is_whiteout(dentry))
+		err = ovl_create_upper(dentry, inode, attr);
+	else
+		err = ovl_create_over_whiteout(dentry, inode, attr);
+
 out_revert_creds:
 	revert_creds(old_cred);
 	return err;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 001cdbb8f015..b29b62670e10 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1984,10 +1984,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ofs)
 		goto out;
 
-	err = -ENOMEM;
 	ofs->creator_cred = cred = prepare_creds();
-	if (!cred)
+	if (IS_ERR(ofs->creator_cred)) {
+		err = PTR_ERR(ofs->creator_cred);
 		goto out_err;
+	}
 
 	/* Is there a reason anyone would want not to share whiteouts? */
 	ofs->share_whiteout = true;
diff --git a/kernel/capability.c b/kernel/capability.c
index 765194f5d678..7a722754f571 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -263,8 +263,8 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 	inheritable.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	ret = security_capset(new, current_cred(),
 			      &effective, &inheritable, &permitted);
diff --git a/kernel/cred.c b/kernel/cred.c
index e10c15f51c1f..dba33c9fa869 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -245,12 +245,13 @@ struct cred *cred_alloc_blank(void)
  *
  * Preparation involves making a copy of the objective creds for modification.
  *
- * Returns a pointer to the new creds-to-be if successful, NULL otherwise.
+ * Returns a pointer to the new creds-to-be if successful, < 0 on error.
  *
  * Call commit_creds() or abort_creds() to clean up.
  */
 struct cred *prepare_creds(void)
 {
+	int err = -ENOMEM;
 	struct task_struct *task = current;
 	const struct cred *old;
 	struct cred *new;
@@ -259,7 +260,7 @@ struct cred *prepare_creds(void)
 
 	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
 	if (!new)
-		return NULL;
+		return ERR_PTR(err);
 
 	kdebug("prepare_creds() alloc %p", new);
 
@@ -288,7 +289,8 @@ struct cred *prepare_creds(void)
 	if (!new->ucounts)
 		goto error;
 
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+	err = security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT);
+	if (err < 0)
 		goto error;
 
 	validate_creds(new);
@@ -296,7 +298,7 @@ struct cred *prepare_creds(void)
 
 error:
 	abort_creds(new);
-	return NULL;
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(prepare_creds);
 
@@ -309,8 +311,8 @@ struct cred *prepare_exec_creds(void)
 	struct cred *new;
 
 	new = prepare_creds();
-	if (!new)
-		return new;
+	if (IS_ERR(new))
+		return ERR_CAST(new);
 
 #ifdef CONFIG_KEYS
 	/* newly exec'd tasks don't get a thread keyring */
@@ -363,8 +365,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	}
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	if (clone_flags & CLONE_NEWUSER) {
 		ret = create_user_ns(new);
@@ -707,16 +709,17 @@ void __init cred_init(void)
  *
  * The caller may change these controls afterwards if desired.
  *
- * Returns the new credentials or NULL if out of memory.
+ * Returns the new credentials or < 0 on error
  */
 struct cred *prepare_kernel_cred(struct task_struct *daemon)
 {
+	int err = -ENOMEM;
 	const struct cred *old;
 	struct cred *new;
 
 	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
 	if (!new)
-		return NULL;
+		return ERR_PTR(err);
 
 	kdebug("prepare_kernel_cred() alloc %p", new);
 
@@ -750,7 +753,8 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	if (!new->ucounts)
 		goto error;
 
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+	err = security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT);
+	if (err < 0)
 		goto error;
 
 	put_cred(old);
@@ -760,7 +764,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 error:
 	put_cred(new);
 	put_cred(old);
-	return NULL;
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(prepare_kernel_cred);
 
diff --git a/kernel/groups.c b/kernel/groups.c
index 787b381c7c00..140915fbb31f 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -136,8 +136,8 @@ int set_current_groups(struct group_info *group_info)
 	struct cred *new;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	set_groups(new, group_info);
 	return commit_creds(new);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index eec72ca962e2..2c937e62a83d 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -311,18 +311,26 @@ static void put_nsset(struct nsset *nsset)
 
 static int prepare_nsset(unsigned flags, struct nsset *nsset)
 {
+	int err = -ENOMEM;
 	struct task_struct *me = current;
 
 	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
 	if (IS_ERR(nsset->nsproxy))
 		return PTR_ERR(nsset->nsproxy);
 
-	if (flags & CLONE_NEWUSER)
+	if (flags & CLONE_NEWUSER) {
 		nsset->cred = prepare_creds();
-	else
+		if (IS_ERR(nsset->cred)) {
+			err = PTR_ERR(nsset->cred);
+			nsset->cred = NULL;
+			goto out;
+		}
+	} else {
 		nsset->cred = current_cred();
-	if (!nsset->cred)
-		goto out;
+		if (!nsset->cred) {
+			goto out;
+		}
+	}
 
 	/* Only create a temporary copy of fs_struct if we really need to. */
 	if (flags == CLONE_NEWNS) {
@@ -338,7 +346,7 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 
 out:
 	put_nsset(nsset);
-	return -ENOMEM;
+	return err;
 }
 
 static inline int validate_ns(struct nsset *nsset, struct ns_common *ns)
diff --git a/kernel/sys.c b/kernel/sys.c
index 374f83e95239..53a12bc4da70 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -372,8 +372,8 @@ long __sys_setregid(gid_t rgid, gid_t egid)
 		return -EINVAL;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	old = current_cred();
 
 	retval = -EPERM;
@@ -434,8 +434,8 @@ long __sys_setgid(gid_t gid)
 		return -EINVAL;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	old = current_cred();
 
 	retval = -EPERM;
@@ -529,8 +529,8 @@ long __sys_setreuid(uid_t ruid, uid_t euid)
 		return -EINVAL;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	old = current_cred();
 
 	retval = -EPERM;
@@ -606,8 +606,8 @@ long __sys_setuid(uid_t uid)
 		return -EINVAL;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	old = current_cred();
 
 	retval = -EPERM;
@@ -672,8 +672,8 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		return -EINVAL;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	old = current_cred();
 
@@ -767,8 +767,8 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		return -EINVAL;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	old = current_cred();
 
 	retval = -EPERM;
@@ -850,7 +850,7 @@ long __sys_setfsuid(uid_t uid)
 		return old_fsuid;
 
 	new = prepare_creds();
-	if (!new)
+	if (IS_ERR(new))
 		return old_fsuid;
 
 	if (uid_eq(kuid, old->uid)  || uid_eq(kuid, old->euid)  ||
@@ -894,7 +894,7 @@ long __sys_setfsgid(gid_t gid)
 		return old_fsgid;
 
 	new = prepare_creds();
-	if (!new)
+	if (IS_ERR(new))
 		return old_fsgid;
 
 	if (gid_eq(kgid, old->gid)  || gid_eq(kgid, old->egid)  ||
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 706e1686b5eb..1ff2e5fab8d8 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -558,9 +558,8 @@ static int user_event_set_call_visible(struct user_event *user, bool visible)
 	struct cred *cred;
 
 	cred = prepare_creds();
-
-	if (!cred)
-		return -ENOMEM;
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
 
 	/*
 	 * While by default tracefs is locked down, systems can be configured
diff --git a/kernel/umh.c b/kernel/umh.c
index 36c123360ab8..2bf9b402083a 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -87,10 +87,11 @@ static int call_usermodehelper_exec_async(void *data)
 	 */
 	set_user_nice(current, 0);
 
-	retval = -ENOMEM;
 	new = prepare_kernel_cred(current);
-	if (!new)
+	if (IS_ERR(new)) {
+		retval = PTR_ERR(new);
 		goto out;
+	}
 
 	spin_lock(&umh_sysctl_lock);
 	new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 5481ba44a8d6..3287666f942c 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -171,19 +171,20 @@ int create_user_ns(struct cred *new)
 int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
 {
 	struct cred *cred;
-	int err = -ENOMEM;
+	int err;
 
 	if (!(unshare_flags & CLONE_NEWUSER))
 		return 0;
 
 	cred = prepare_creds();
-	if (cred) {
-		err = create_user_ns(cred);
-		if (err)
-			put_cred(cred);
-		else
-			*new_cred = cred;
-	}
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
+
+	err = create_user_ns(cred);
+	if (err)
+		put_cred(cred);
+	else
+		*new_cred = cred;
 
 	return err;
 }
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 3aced951d5ab..dbfb2b17491e 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -338,8 +338,8 @@ static int __init init_dns_resolver(void)
 	 * with add_key().
 	 */
 	cred = prepare_kernel_cred(NULL);
-	if (!cred)
-		return -ENOMEM;
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
 
 	keyring = keyring_alloc(".dns_resolver",
 				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
diff --git a/security/apparmor/task.c b/security/apparmor/task.c
index d17130ee6795..2c1940c26cb2 100644
--- a/security/apparmor/task.c
+++ b/security/apparmor/task.c
@@ -52,9 +52,9 @@ int aa_replace_current_label(struct aa_label *label)
 	if (current_cred() != current_real_cred())
 		return -EBUSY;
 
-	new  = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	new = prepare_creds();
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	if (ctx->nnp && label_is_stale(ctx->nnp)) {
 		struct aa_label *tmp = ctx->nnp;
@@ -118,8 +118,8 @@ int aa_set_current_hat(struct aa_label *label, u64 token)
 	struct cred *new;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	AA_BUG(!label);
 
 	if (!ctx->previous) {
@@ -164,8 +164,8 @@ int aa_restore_previous_label(u64 token)
 		return 0;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	aa_put_label(cred_label(new));
 	set_cred_label(new, aa_get_newest_label(ctx->previous));
diff --git a/security/commoncap.c b/security/commoncap.c
index 5fc8986c3c77..906d1bf4a226 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1247,8 +1247,8 @@ static int cap_prctl_drop(unsigned long cap)
 		return -EINVAL;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	cap_lower(new->cap_bset, cap);
 	return commit_creds(new);
 }
@@ -1323,8 +1323,8 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			return -EPERM;
 
 		new = prepare_creds();
-		if (!new)
-			return -ENOMEM;
+		if (IS_ERR(new))
+			return PTR_ERR(new);
 		new->securebits = arg2;
 		return commit_creds(new);
 
@@ -1341,8 +1341,8 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			return -EPERM;
 
 		new = prepare_creds();
-		if (!new)
-			return -ENOMEM;
+		if (IS_ERR(new))
+			return PTR_ERR(new);
 		if (arg2)
 			new->securebits |= issecure_mask(SECURE_KEEP_CAPS);
 		else
@@ -1355,8 +1355,8 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 				return -EINVAL;
 
 			new = prepare_creds();
-			if (!new)
-				return -ENOMEM;
+			if (IS_ERR(new))
+				return PTR_ERR(new);
 			cap_clear(new->cap_ambient);
 			return commit_creds(new);
 		}
@@ -1378,8 +1378,8 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 				return -EPERM;
 
 			new = prepare_creds();
-			if (!new)
-				return -ENOMEM;
+			if (IS_ERR(new))
+				return PTR_ERR(new);
 			if (arg2 == PR_CAP_AMBIENT_RAISE)
 				cap_raise(new->cap_ambient, arg3);
 			else
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 96a92a645216..cb3be208bc7d 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1146,8 +1146,8 @@ static int keyctl_change_reqkey_auth(struct key *key)
 	struct cred *new;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	key_put(new->request_key_auth);
 	new->request_key_auth = key_get(key);
@@ -1396,8 +1396,8 @@ long keyctl_set_reqkey_keyring(int reqkey_defl)
 		return old_setting;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	switch (reqkey_defl) {
 	case KEY_REQKEY_DEFL_THREAD_KEYRING:
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index b5d5333ab330..8e7655d48319 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -247,8 +247,8 @@ static int install_thread_keyring(void)
 	int ret;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	ret = install_thread_keyring_to_cred(new);
 	if (ret < 0) {
@@ -294,8 +294,8 @@ static int install_process_keyring(void)
 	int ret;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	ret = install_process_keyring_to_cred(new);
 	if (ret < 0) {
@@ -359,8 +359,8 @@ static int install_session_keyring(struct key *keyring)
 	int ret;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	ret = install_session_keyring_to_cred(new, keyring);
 	if (ret < 0) {
@@ -842,8 +842,8 @@ long join_session_keyring(const char *name)
 	long ret, serial;
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 	old = current_cred();
 
 	/* if no name is provided, install an anonymous keyring */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 7e27ce394020..905ae7f9717f 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -419,8 +419,8 @@ SYSCALL_DEFINE2(landlock_restrict_self,
 
 	/* Prepares new credentials. */
 	new_cred = prepare_creds();
-	if (!new_cred) {
-		err = -ENOMEM;
+	if (IS_ERR(new_cred)) {
+		err = PTR_ERR(new_cred);
 		goto out_put_ruleset;
 	}
 	new_llcred = landlock_cred(new_cred);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e9e959343de9..a0b3671ee1f1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3472,8 +3472,8 @@ static int selinux_inode_copy_up(struct dentry *src, struct cred **new)
 
 	if (new_creds == NULL) {
 		new_creds = prepare_creds();
-		if (!new_creds)
-			return -ENOMEM;
+		if (IS_ERR(new_creds))
+			return PTR_ERR(new_creds);
 	}
 
 	tsec = selinux_cred(new_creds);
@@ -6457,8 +6457,8 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
 	}
 
 	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	/* Permission checking based on the specified context is
 	   performed during the actual operation (execve,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 6207762dbdb1..ca4e2b906cce 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3555,8 +3555,8 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
 	}
 
 	new = prepare_creds();
-	if (new == NULL)
-		return -ENOMEM;
+	if (IS_ERR(new))
+		return PTR_ERR(new);
 
 	tsp = smack_cred(new);
 	tsp->smk_task = skp;
@@ -4633,8 +4633,8 @@ static int smack_inode_copy_up(struct dentry *dentry, struct cred **new)
 
 	if (new_creds == NULL) {
 		new_creds = prepare_creds();
-		if (new_creds == NULL)
-			return -ENOMEM;
+		if (IS_ERR(new_creds))
+			return PTR_ERR(new_creds);
 	}
 
 	tsp = smack_cred(new_creds);
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 658eab05599e..1e90b325c56b 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2777,8 +2777,8 @@ static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 		struct task_smack *tsp;
 
 		new = prepare_creds();
-		if (!new) {
-			rc = -ENOMEM;
+		if (IS_ERR(new)) {
+			rc = PTR_ERR(new);
 			goto out;
 		}
 		tsp = smack_cred(new);
-- 
2.30.2

