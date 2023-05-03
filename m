Return-Path: <netdev+bounces-99-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A846F524C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5262B1C20B91
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F8F4A1D;
	Wed,  3 May 2023 07:50:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDD19475
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:50:12 +0000 (UTC)
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5C91981;
	Wed,  3 May 2023 00:50:04 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
	id E004DC009; Wed,  3 May 2023 09:50:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683100202; bh=VbVBtnbrwLuul77qAvsbvfbxVsUi5EeTfSpIBmi3j4w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P79Oa6KPZN66cQuxIKitEjcvhOa4af7NH0eLqh4Sqy++awurygv3Xthq2MUglS/vC
	 JIb0vzmZ2S8sPeKq/8FZPJnRlENsAGQ2H3WDzrDMqKIgQvAtFd4a7kB5u6T1+lBalv
	 3AGt+SihdF2fnJ+8xAUS2N4xCpWyJghmphsDlQmLGnwjjcF/tK5driZMu7v/gTFe2U
	 DNuui4X8WNYXJLRbAWGUcIf6qrqDj2u3WK1D/297bAE3B6B7SAqEJ42mLwWEf0j6Gj
	 tLojuMsrTCU6O80zByT6RLgCUxEyUvH4WAa49oTBdRFw6ztWbpat5SJR/Zo+QJhvld
	 7tp3Foj8CVnGQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id CB897C01B;
	Wed,  3 May 2023 09:49:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683100200; bh=VbVBtnbrwLuul77qAvsbvfbxVsUi5EeTfSpIBmi3j4w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UXX7GgqwXphKEMKtVQdLpmhed/vC6usO4K1w6PT5h6gGTVaeCpY0hiUGz49RWatII
	 G4hQDTMQRUk7ubZ2fu1yRThyQ/AI8nCqlP8neMmKE0jwKRrYS+W+YBLfQortMpYLpU
	 PAVdW5dTPHgnVbRT/7+TAK2qdygsOU9SITOp5ZlZSHHzUfyKcf2xxjDz9HYTAof/KW
	 9cl9KugM1YHRyF4kdH6S+t6gbqEtlV5SsNKoMi6OfmtS3/04bpwQ4thLxbgcUgxBro
	 2B+1cF1sEopRtftw3BqECeiUtvuyhxup6tBhp0L4h08VfbRgmDzuP8K7PAOXs4Fo+j
	 AWJu5S0IFeIHg==
Received: from [127.0.0.2] (localhost [::1])
	by odin.codewreck.org (OpenSMTPD) with ESMTP id 018f94ab;
	Wed, 3 May 2023 07:49:37 +0000 (UTC)
From: Dominique Martinet <asmadeus@codewreck.org>
Date: Wed, 03 May 2023 16:49:29 +0900
Subject: [PATCH v2 5/5] 9p: remove dead stores (variable set again without
 being read)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230427-scan-build-v2-5-bb96a6e6a33b@codewreck.org>
References: <20230427-scan-build-v2-0-bb96a6e6a33b@codewreck.org>
In-Reply-To: <20230427-scan-build-v2-0-bb96a6e6a33b@codewreck.org>
To: Eric Van Hensbergen <ericvh@gmail.com>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, v9fs@lists.linux.dev, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=10835;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=ZpaOG6I1Mg+9Sdfd+zvY5JWk7jk8BihMPOQRrLFRmpo=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkUhIRID05hLvaWGo3o+U/pd52m5DsD9LwkTky9
 qXpKfcZyIiJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFISEQAKCRCrTpvsapjm
 cLkeD/4n5FKs8IQpn2Irz9rpxv3ywSXtF39YwPsTq7qmAfcoDKoiie8WGjc4CqTX/bBKhpiBYBs
 jcrQ0wqwBG9tE5Ll3zjk+1faNeFm7ew320iIqBr+B3sV6aAe9ebUnv1nb57bGW2twwWGaxLZ4HF
 m7Bf1UanvVZztieddeKqdwPJlDchaUwmuRF/ugl64eBPwiw0EWkIG5wqmN8cscpHQm8Bqngq4Nw
 NtgzhCmSneRGcrZ7bBCH6KccnpevkdlFpsh8Rqf4BImlVdGAN936oQG2lhL0OuiYmlxiVFVv+l6
 CYa0EzbkjXREoZIoil9mTwz4bZMvDOcHOFMfUvYZJQYcYC++im7S6PZAoyYPdRB/PFyw0NUZkuw
 cMXCvfWYluoxkZeAndbi1qA0aycOxHl1T4/4MdHfNuGK4nqyAafwlSwu9JuAw1MUJzm2OnMDwzQ
 phoRv4SloO8aDwCMz99vPlJImlv2Of4M0uwXyY0nSQe6DLYEuKgT3+fjZHC2UQbSBSR3M2A+waB
 tGxhiHEybZWNB9sut2FSFANFW31seYucC+w/DJoeW5v1N7+ROgLT+w9cNTAcpj95GvwvLnxwNlO
 JZlbm3wBWP/HnuddAc2ElNR/bPapb4cPtHGlk4rLFhDuZPj6CiopCZdtr+HN69d1vG9CXfLNAku
 zL5qD9hQBYmxRZw==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A

The 9p code for some reason used to initialize variables outside of the
declaration, e.g. instead of just initializing the variable like this:

int retval = 0

We would be doing this:

int retval;
retval = 0;

This is perfectly fine and the compiler will just optimize dead stores
anyway, but scan-build seems to think this is a problem and there are
many of these warnings making the output of scan-build full of such
warnings:
fs/9p/vfs_inode.c:916:2: warning: Value stored to 'retval' is never read [deadcode.DeadStores]
        retval = 0;
        ^        ~

I have no strong opinion here, but if we want to regularly run
scan-build we should fix these just to silence the messages.

I've confirmed these all are indeed ok to remove.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/vfs_inode.c      |  6 ------
 fs/9p/vfs_inode_dotl.c |  1 -
 net/9p/client.c        | 46 ++++++++++++----------------------------------
 3 files changed, 12 insertions(+), 41 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3791f642c502..99305e97287c 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -164,7 +164,6 @@ int v9fs_uflags2omode(int uflags, int extended)
 {
 	int ret;
 
-	ret = 0;
 	switch (uflags&3) {
 	default:
 	case O_RDONLY:
@@ -604,7 +603,6 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 
 	p9_debug(P9_DEBUG_VFS, "name %pd\n", dentry);
 
-	err = 0;
 	name = dentry->d_name.name;
 	dfid = v9fs_parent_fid(dentry);
 	if (IS_ERR(dfid)) {
@@ -816,8 +814,6 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (!(flags & O_CREAT) || d_really_is_positive(dentry))
 		return finish_no_open(file, res);
 
-	err = 0;
-
 	v9ses = v9fs_inode2v9ses(dir);
 	perm = unixmode2p9mode(v9ses, mode);
 	p9_omode = v9fs_uflags2omode(flags, v9fs_proto_dotu(v9ses));
@@ -913,7 +909,6 @@ v9fs_vfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		return -EINVAL;
 
 	p9_debug(P9_DEBUG_VFS, "\n");
-	retval = 0;
 	old_inode = d_inode(old_dentry);
 	new_inode = d_inode(new_dentry);
 	v9ses = v9fs_inode2v9ses(old_inode);
@@ -1067,7 +1062,6 @@ static int v9fs_vfs_setattr(struct mnt_idmap *idmap,
 	if (retval)
 		return retval;
 
-	retval = -EPERM;
 	v9ses = v9fs_dentry2v9ses(dentry);
 	if (iattr->ia_valid & ATTR_FILE) {
 		fid = iattr->ia_file->private_data;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 3acf2bcb69cc..43e282f21962 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -367,7 +367,6 @@ static int v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
 	struct posix_acl *dacl = NULL, *pacl = NULL;
 
 	p9_debug(P9_DEBUG_VFS, "name %pd\n", dentry);
-	err = 0;
 	v9ses = v9fs_inode2v9ses(dir);
 
 	omode |= S_IFDIR;
diff --git a/net/9p/client.c b/net/9p/client.c
index a3340268ec8d..86bbc7147fc1 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -904,7 +904,7 @@ EXPORT_SYMBOL(do_trace_9p_fid_put);
 
 static int p9_client_version(struct p9_client *c)
 {
-	int err = 0;
+	int err;
 	struct p9_req_t *req;
 	char *version = NULL;
 	int msize;
@@ -975,7 +975,6 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	struct p9_client *clnt;
 	char *client_id;
 
-	err = 0;
 	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
@@ -1094,7 +1093,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 				const char *uname, kuid_t n_uname,
 				const char *aname)
 {
-	int err = 0;
+	int err;
 	struct p9_req_t *req;
 	struct p9_fid *fid;
 	struct p9_qid qid;
@@ -1147,7 +1146,6 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 	struct p9_req_t *req;
 	u16 nwqids, count;
 
-	err = 0;
 	wqids = NULL;
 	clnt = oldfid->clnt;
 	if (clone) {
@@ -1224,7 +1222,6 @@ int p9_client_open(struct p9_fid *fid, int mode)
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> %s fid %d mode %d\n",
 		 p9_is_proto_dotl(clnt) ? "TLOPEN" : "TOPEN", fid->fid, mode);
-	err = 0;
 
 	if (fid->mode != -1)
 		return -EINVAL;
@@ -1262,7 +1259,7 @@ EXPORT_SYMBOL(p9_client_open);
 int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
 			  u32 mode, kgid_t gid, struct p9_qid *qid)
 {
-	int err = 0;
+	int err;
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 	int iounit;
@@ -1314,7 +1311,6 @@ int p9_client_fcreate(struct p9_fid *fid, const char *name, u32 perm, int mode,
 
 	p9_debug(P9_DEBUG_9P, ">>> TCREATE fid %d name %s perm %d mode %d\n",
 		 fid->fid, name, perm, mode);
-	err = 0;
 	clnt = fid->clnt;
 
 	if (fid->mode != -1)
@@ -1350,7 +1346,7 @@ EXPORT_SYMBOL(p9_client_fcreate);
 int p9_client_symlink(struct p9_fid *dfid, const char *name,
 		      const char *symtgt, kgid_t gid, struct p9_qid *qid)
 {
-	int err = 0;
+	int err;
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
@@ -1402,13 +1398,12 @@ EXPORT_SYMBOL(p9_client_link);
 
 int p9_client_fsync(struct p9_fid *fid, int datasync)
 {
-	int err;
+	int err = 0;
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
 	p9_debug(P9_DEBUG_9P, ">>> TFSYNC fid %d datasync:%d\n",
 		 fid->fid, datasync);
-	err = 0;
 	clnt = fid->clnt;
 
 	req = p9_client_rpc(clnt, P9_TFSYNC, "dd", fid->fid, datasync);
@@ -1428,7 +1423,7 @@ EXPORT_SYMBOL(p9_client_fsync);
 
 int p9_client_clunk(struct p9_fid *fid)
 {
-	int err;
+	int err = 0;
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 	int retries = 0;
@@ -1436,7 +1431,6 @@ int p9_client_clunk(struct p9_fid *fid)
 again:
 	p9_debug(P9_DEBUG_9P, ">>> TCLUNK fid %d (try %d)\n",
 		 fid->fid, retries);
-	err = 0;
 	clnt = fid->clnt;
 
 	req = p9_client_rpc(clnt, P9_TCLUNK, "d", fid->fid);
@@ -1465,12 +1459,11 @@ EXPORT_SYMBOL(p9_client_clunk);
 
 int p9_client_remove(struct p9_fid *fid)
 {
-	int err;
+	int err = 0;
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
 	p9_debug(P9_DEBUG_9P, ">>> TREMOVE fid %d\n", fid->fid);
-	err = 0;
 	clnt = fid->clnt;
 
 	req = p9_client_rpc(clnt, P9_TREMOVE, "d", fid->fid);
@@ -1680,7 +1673,6 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
-	err = 0;
 	clnt = fid->clnt;
 
 	req = p9_client_rpc(clnt, P9_TSTAT, "d", fid->fid);
@@ -1733,7 +1725,6 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
-	err = 0;
 	clnt = fid->clnt;
 
 	req = p9_client_rpc(clnt, P9_TGETATTR, "dq", fid->fid, request_mask);
@@ -1812,11 +1803,10 @@ static int p9_client_statsize(struct p9_wstat *wst, int proto_version)
 
 int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
 {
-	int err;
+	int err = 0;
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
-	err = 0;
 	clnt = fid->clnt;
 	wst->size = p9_client_statsize(wst, clnt->proto_version);
 	p9_debug(P9_DEBUG_9P, ">>> TWSTAT fid %d\n",
@@ -1851,11 +1841,10 @@ EXPORT_SYMBOL(p9_client_wstat);
 
 int p9_client_setattr(struct p9_fid *fid, struct p9_iattr_dotl *p9attr)
 {
-	int err;
+	int err = 0;
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
-	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> TSETATTR fid %d\n", fid->fid);
 	p9_debug(P9_DEBUG_9P, "    valid=%x mode=%x uid=%d gid=%d size=%lld\n",
@@ -1887,7 +1876,6 @@ int p9_client_statfs(struct p9_fid *fid, struct p9_rstatfs *sb)
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
-	err = 0;
 	clnt = fid->clnt;
 
 	p9_debug(P9_DEBUG_9P, ">>> TSTATFS fid %d\n", fid->fid);
@@ -1921,11 +1909,10 @@ EXPORT_SYMBOL(p9_client_statfs);
 int p9_client_rename(struct p9_fid *fid,
 		     struct p9_fid *newdirfid, const char *name)
 {
-	int err;
+	int err = 0;
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
-	err = 0;
 	clnt = fid->clnt;
 
 	p9_debug(P9_DEBUG_9P, ">>> TRENAME fid %d newdirfid %d name %s\n",
@@ -1949,11 +1936,10 @@ EXPORT_SYMBOL(p9_client_rename);
 int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,
 		       struct p9_fid *newdirfid, const char *new_name)
 {
-	int err;
+	int err = 0;
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
-	err = 0;
 	clnt = olddirfid->clnt;
 
 	p9_debug(P9_DEBUG_9P,
@@ -1986,7 +1972,6 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 	struct p9_client *clnt;
 	struct p9_fid *attr_fid;
 
-	err = 0;
 	clnt = file_fid->clnt;
 	attr_fid = p9_fid_create(clnt);
 	if (!attr_fid) {
@@ -2027,14 +2012,13 @@ EXPORT_SYMBOL_GPL(p9_client_xattrwalk);
 int p9_client_xattrcreate(struct p9_fid *fid, const char *name,
 			  u64 attr_size, int flags)
 {
-	int err;
+	int err = 0;
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
 	p9_debug(P9_DEBUG_9P,
 		 ">>> TXATTRCREATE fid %d name  %s size %llu flag %d\n",
 		 fid->fid, name, attr_size, flags);
-	err = 0;
 	clnt = fid->clnt;
 	req = p9_client_rpc(clnt, P9_TXATTRCREATE, "dsqd",
 			    fid->fid, name, attr_size, flags);
@@ -2063,7 +2047,6 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 	p9_debug(P9_DEBUG_9P, ">>> TREADDIR fid %d offset %llu count %d\n",
 		 fid->fid, offset, count);
 
-	err = 0;
 	clnt = fid->clnt;
 
 	rsize = fid->iounit;
@@ -2122,7 +2105,6 @@ int p9_client_mknod_dotl(struct p9_fid *fid, const char *name, int mode,
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
-	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P,
 		 ">>> TMKNOD fid %d name %s mode %d major %d minor %d\n",
@@ -2153,7 +2135,6 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
-	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> TMKDIR fid %d name %s mode %d gid %d\n",
 		 fid->fid, name, mode, from_kgid(&init_user_ns, gid));
@@ -2182,7 +2163,6 @@ int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status)
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
-	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P,
 		 ">>> TLOCK fid %d type %i flags %d start %lld length %lld proc_id %d client_id %s\n",
@@ -2214,7 +2194,6 @@ int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *glock)
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
-	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P,
 		 ">>> TGETLOCK fid %d, type %i start %lld length %lld proc_id %d client_id %s\n",
@@ -2251,7 +2230,6 @@ int p9_client_readlink(struct p9_fid *fid, char **target)
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
-	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> TREADLINK fid %d\n", fid->fid);
 

-- 
2.39.2


