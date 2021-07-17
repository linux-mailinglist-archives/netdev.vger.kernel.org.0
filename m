Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389773CC29C
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 12:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhGQKXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 06:23:10 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:55330
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S233431AbhGQKXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 06:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=2Q0bC1AplAGhv7FihkJDId3aCukUvv29yqxy6h3U4rA=; b=L
        Qa19Tb7TKAK+iduqFVELO+yzqsriQlE1TlKw3thbpDCTRdvSdG3CMAvNntl3nvNV
        Uqt83hIBgvPJXoVvAwPT5Q6L1GXI5ZqhtsiSFIdyt/Guk9waZFMKvigSFUqzedpU
        Vaz90pdW7wxJRd+KQrKj+VzWOf3JoGLcO+oE1oFoTs=
Received: from localhost.localdomain (unknown [39.144.44.130])
        by app2 (Coremail) with SMTP id XQUFCgC3L2mgrvJgjLzYBA--.38224S3;
        Sat, 17 Jul 2021 18:19:13 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Olga Kornievskaia <kolga@netapp.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn
Subject: [PATCH] SUNRPC: Convert from atomic_t to refcount_t on rpc_clnt->cl_count
Date:   Sat, 17 Jul 2021 18:18:08 +0800
Message-Id: <1626517112-42831-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgC3L2mgrvJgjLzYBA--.38224S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WF18uFyrGr4UZF1UWw1kGrg_yoW7Xr1Upr
        ZrC34rJF9Ykrs7K34vya1UZw1fAF1xAa4rKFW0y34rAF9xKr1Yq3WIkryjyrs7ZrW8uF12
        qF4jgF45CF4DZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k2
        6cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUo8nYUUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 include/linux/sunrpc/clnt.h          |  3 ++-
 net/sunrpc/auth_gss/gss_rpc_upcall.c |  2 +-
 net/sunrpc/clnt.c                    | 14 +++++++-------
 net/sunrpc/debugfs.c                 |  2 +-
 net/sunrpc/rpc_pipe.c                |  2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 8b5d5c97553e..61f725b9f865 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_SUNRPC_CLNT_H
 #define _LINUX_SUNRPC_CLNT_H
 
+#include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/in.h>
@@ -35,7 +36,7 @@ struct rpc_sysfs_client;
  * The high-level client handle
  */
 struct rpc_clnt {
-	atomic_t		cl_count;	/* Number of references */
+	refcount_t		cl_count;	/* Number of references */
 	unsigned int		cl_clid;	/* client id */
 	struct list_head	cl_clients;	/* Global list of clients */
 	struct list_head	cl_tasks;	/* List of tasks */
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index d1c003a25b0f..61c276bddaf2 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -160,7 +160,7 @@ static struct rpc_clnt *get_gssp_clnt(struct sunrpc_net *sn)
 	mutex_lock(&sn->gssp_lock);
 	clnt = sn->gssp_clnt;
 	if (clnt)
-		atomic_inc(&clnt->cl_count);
+		refcount_inc(&clnt->cl_count);
 	mutex_unlock(&sn->gssp_lock);
 	return clnt;
 }
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 8b4de70e8ead..d6b64622bd04 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -167,7 +167,7 @@ static int rpc_clnt_skip_event(struct rpc_clnt *clnt, unsigned long event)
 	case RPC_PIPEFS_MOUNT:
 		if (clnt->cl_pipedir_objects.pdh_dentry != NULL)
 			return 1;
-		if (atomic_read(&clnt->cl_count) == 0)
+		if (refcount_read(&clnt->cl_count) == 0)
 			return 1;
 		break;
 	case RPC_PIPEFS_UMOUNT:
@@ -419,7 +419,7 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 	clnt->cl_rtt = &clnt->cl_rtt_default;
 	rpc_init_rtt(&clnt->cl_rtt_default, clnt->cl_timeout->to_initval);
 
-	atomic_set(&clnt->cl_count, 1);
+	refcount_set(&clnt->cl_count, 1);
 
 	if (nodename == NULL)
 		nodename = utsname()->nodename;
@@ -431,7 +431,7 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 	if (err)
 		goto out_no_path;
 	if (parent)
-		atomic_inc(&parent->cl_count);
+		refcount_inc(&parent->cl_count);
 
 	trace_rpc_clnt_new(clnt, xprt, program->name, args->servername);
 	return clnt;
@@ -926,10 +926,10 @@ rpc_free_auth(struct rpc_clnt *clnt)
 	 *       release remaining GSS contexts. This mechanism ensures
 	 *       that it can do so safely.
 	 */
-	atomic_inc(&clnt->cl_count);
+	refcount_inc(&clnt->cl_count);
 	rpcauth_release(clnt->cl_auth);
 	clnt->cl_auth = NULL;
-	if (atomic_dec_and_test(&clnt->cl_count))
+	if (refcount_dec_and_test(&clnt->cl_count))
 		return rpc_free_client(clnt);
 	return NULL;
 }
@@ -943,7 +943,7 @@ rpc_release_client(struct rpc_clnt *clnt)
 	do {
 		if (list_empty(&clnt->cl_tasks))
 			wake_up(&destroy_wait);
-		if (!atomic_dec_and_test(&clnt->cl_count))
+		if (!refcount_dec_and_test(&clnt->cl_count))
 			break;
 		clnt = rpc_free_auth(clnt);
 	} while (clnt != NULL);
@@ -1082,7 +1082,7 @@ void rpc_task_set_client(struct rpc_task *task, struct rpc_clnt *clnt)
 	if (clnt != NULL) {
 		rpc_task_set_transport(task, clnt);
 		task->tk_client = clnt;
-		atomic_inc(&clnt->cl_count);
+		refcount_inc(&clnt->cl_count);
 		if (clnt->cl_softrtry)
 			task->tk_flags |= RPC_TASK_SOFT;
 		if (clnt->cl_softerr)
diff --git a/net/sunrpc/debugfs.c b/net/sunrpc/debugfs.c
index 56029e3af6ff..79995eb95927 100644
--- a/net/sunrpc/debugfs.c
+++ b/net/sunrpc/debugfs.c
@@ -90,7 +90,7 @@ static int tasks_open(struct inode *inode, struct file *filp)
 		struct seq_file *seq = filp->private_data;
 		struct rpc_clnt *clnt = seq->private = inode->i_private;
 
-		if (!atomic_inc_not_zero(&clnt->cl_count)) {
+		if (!refcount_inc_not_zero(&clnt->cl_count)) {
 			seq_release(inode, filp);
 			ret = -EINVAL;
 		}
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 09c000d490a1..ee5336d73fdd 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -423,7 +423,7 @@ rpc_info_open(struct inode *inode, struct file *file)
 		spin_lock(&file->f_path.dentry->d_lock);
 		if (!d_unhashed(file->f_path.dentry))
 			clnt = RPC_I(inode)->private;
-		if (clnt != NULL && atomic_inc_not_zero(&clnt->cl_count)) {
+		if (clnt != NULL && refcount_inc_not_zero(&clnt->cl_count)) {
 			spin_unlock(&file->f_path.dentry->d_lock);
 			m->private = clnt;
 		} else {
-- 
2.7.4

