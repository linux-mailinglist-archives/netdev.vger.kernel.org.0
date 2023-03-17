Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBC96BEBD2
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjCQOym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjCQOyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:54:41 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F6EB6919;
        Fri, 17 Mar 2023 07:54:29 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4PdRkf73zhz9xqpl;
        Fri, 17 Mar 2023 22:45:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBnOWDafhRkaQemAQ--.41316S5;
        Fri, 17 Mar 2023 15:54:05 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, shuah@kernel.org,
        brauner@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ebiederm@xmission.com,
        mcgrof@kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 3/5] bpfilter: Port to user mode driver management API
Date:   Fri, 17 Mar 2023 15:52:38 +0100
Message-Id: <20230317145240.363908-4-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwBnOWDafhRkaQemAQ--.41316S5
X-Coremail-Antispam: 1UD129KBjvJXoWxuw4UXF43JF48Kw43Aw1xGrg_yoWfXrWkpF
        WYkw4UJr45XFyUXF1DGFy5Ar15Kr45Ww1UuryrG3sYyrsxWr1vg3yakrWFv345GrW7C34j
        qa98t3W5XasxXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
        WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
        bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
        AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
        F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
        ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
        0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x
        07jxCztUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4asxgAEsM
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Move bpfilter_process_sockopt() to sockopt.c, and call umd_mgmt_send_recv()
instead of umd_send_recv(), so that it has the original capability of
bpfilter_mbox_request() to request the loading of the kernel module
containing the user mode driver.

Move also the connection test originally in start_umh() in bpfilter.c, to
sockopt.c. Create the new function bpfilter_post_start_umh() with the moved
code.

Directly call bpfilter_process_sockopt() from bpfilter_ip_set_sockopt() and
bpfilter_ip_get_sockopt(), which now it is equivalent to
bpfilter_mbox_request().

Remove the struct bpfilter_umh_ops definition, and declare the global
variable bpfilter_ops as a umd_mgmt structure.

Set kmod to 'bpfilter', kmod_loaded to false and the new function
bpfilter_post_start_umh() as the post_start method for bpfilter_ops.

Replace load_umh() and fini_umh() in bpfilter.c respectively with
umd_mgmt_load() and umd_mgmt_unload().

Finally, remove the remaining functions, as their job is done by the user
mode driver management.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/bpfilter.h     | 12 +----
 net/bpfilter/bpfilter_kern.c | 98 ++----------------------------------
 net/ipv4/bpfilter/sockopt.c  | 67 ++++++++++++++----------
 3 files changed, 45 insertions(+), 132 deletions(-)

diff --git a/include/linux/bpfilter.h b/include/linux/bpfilter.h
index 2ae3c8e1d83..655e6ec6e9d 100644
--- a/include/linux/bpfilter.h
+++ b/include/linux/bpfilter.h
@@ -3,7 +3,7 @@
 #define _LINUX_BPFILTER_H
 
 #include <uapi/linux/bpfilter.h>
-#include <linux/usermode_driver.h>
+#include <linux/usermode_driver_mgmt.h>
 #include <linux/sockptr.h>
 
 struct sock;
@@ -13,13 +13,5 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
 			    int __user *optlen);
 void bpfilter_umh_cleanup(struct umd_info *info);
 
-struct bpfilter_umh_ops {
-	struct umd_info info;
-	/* since ip_getsockopt() can run in parallel, serialize access to umh */
-	struct mutex lock;
-	int (*sockopt)(struct sock *sk, int optname, sockptr_t optval,
-		       unsigned int optlen, bool is_set);
-	int (*start)(void);
-};
-extern struct bpfilter_umh_ops bpfilter_ops;
+extern struct umd_mgmt bpfilter_ops;
 #endif
diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 17d4df5f8fe..f2137d889c9 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -1,113 +1,21 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/init.h>
 #include <linux/module.h>
-#include <linux/umh.h>
 #include <linux/bpfilter.h>
-#include <linux/sched.h>
-#include <linux/sched/signal.h>
-#include <linux/fs.h>
-#include <linux/file.h>
 #include "msgfmt.h"
 
 extern char bpfilter_umh_start;
 extern char bpfilter_umh_end;
 
-static void shutdown_umh(void)
-{
-	struct umd_info *info = &bpfilter_ops.info;
-	struct pid *tgid = info->tgid;
-
-	if (tgid) {
-		kill_pid(tgid, SIGKILL, 1);
-		wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
-		bpfilter_umh_cleanup(info);
-	}
-}
-
-static int bpfilter_process_sockopt(struct sock *sk, int optname,
-				    sockptr_t optval, unsigned int optlen,
-				    bool is_set)
-{
-	struct mbox_request req = {
-		.is_set		= is_set,
-		.pid		= current->pid,
-		.cmd		= optname,
-		.addr		= (uintptr_t)optval.user,
-		.len		= optlen,
-	};
-	struct mbox_reply reply;
-	int err;
-
-	if (sockptr_is_kernel(optval)) {
-		pr_err("kernel access not supported\n");
-		return -EFAULT;
-	}
-	err = umd_send_recv(&bpfilter_ops.info, &req, sizeof(req), &reply,
-			    sizeof(reply));
-	if (err) {
-		shutdown_umh();
-		return err;
-	}
-
-	return reply.status;
-}
-
-static int start_umh(void)
-{
-	struct mbox_request req = { .pid = current->pid };
-	struct mbox_reply reply;
-	int err;
-
-	/* fork usermode process */
-	err = fork_usermode_driver(&bpfilter_ops.info);
-	if (err)
-		return err;
-	pr_info("Loaded bpfilter_umh pid %d\n", pid_nr(bpfilter_ops.info.tgid));
-
-	/* health check that usermode process started correctly */
-	if (umd_send_recv(&bpfilter_ops.info, &req, sizeof(req), &reply,
-			  sizeof(reply)) != 0 || reply.status != 0) {
-		shutdown_umh();
-		return -EFAULT;
-	}
-
-	return 0;
-}
-
 static int __init load_umh(void)
 {
-	int err;
-
-	err = umd_load_blob(&bpfilter_ops.info,
-			    &bpfilter_umh_start,
-			    &bpfilter_umh_end - &bpfilter_umh_start);
-	if (err)
-		return err;
-
-	mutex_lock(&bpfilter_ops.lock);
-	err = start_umh();
-	if (!err && IS_ENABLED(CONFIG_INET)) {
-		bpfilter_ops.sockopt = &bpfilter_process_sockopt;
-		bpfilter_ops.start = &start_umh;
-	}
-	mutex_unlock(&bpfilter_ops.lock);
-	if (err)
-		umd_unload_blob(&bpfilter_ops.info);
-	return err;
+	return umd_mgmt_load(&bpfilter_ops, &bpfilter_umh_start,
+			     &bpfilter_umh_end);
 }
 
 static void __exit fini_umh(void)
 {
-	mutex_lock(&bpfilter_ops.lock);
-	if (IS_ENABLED(CONFIG_INET)) {
-		shutdown_umh();
-		bpfilter_ops.start = NULL;
-		bpfilter_ops.sockopt = NULL;
-	}
-	mutex_unlock(&bpfilter_ops.lock);
-
-	umd_unload_blob(&bpfilter_ops.info);
+	umd_mgmt_unload(&bpfilter_ops);
 }
 module_init(load_umh);
 module_exit(fini_umh);
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 1b34cb9a770..491f5042612 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -8,8 +8,9 @@
 #include <linux/kmod.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include "../../bpfilter/msgfmt.h"
 
-struct bpfilter_umh_ops bpfilter_ops;
+struct umd_mgmt bpfilter_ops;
 EXPORT_SYMBOL_GPL(bpfilter_ops);
 
 void bpfilter_umh_cleanup(struct umd_info *info)
@@ -21,40 +22,49 @@ void bpfilter_umh_cleanup(struct umd_info *info)
 }
 EXPORT_SYMBOL_GPL(bpfilter_umh_cleanup);
 
-static int bpfilter_mbox_request(struct sock *sk, int optname, sockptr_t optval,
-				 unsigned int optlen, bool is_set)
+static int bpfilter_process_sockopt(struct sock *sk, int optname,
+				    sockptr_t optval, unsigned int optlen,
+				    bool is_set)
 {
+	struct mbox_request req = {
+		.is_set		= is_set,
+		.pid		= current->pid,
+		.cmd		= optname,
+		.addr		= (uintptr_t)optval.user,
+		.len		= optlen,
+	};
+	struct mbox_reply reply;
 	int err;
-	mutex_lock(&bpfilter_ops.lock);
-	if (!bpfilter_ops.sockopt) {
-		mutex_unlock(&bpfilter_ops.lock);
-		request_module("bpfilter");
-		mutex_lock(&bpfilter_ops.lock);
 
-		if (!bpfilter_ops.sockopt) {
-			err = -ENOPROTOOPT;
-			goto out;
-		}
+	if (sockptr_is_kernel(optval)) {
+		pr_err("kernel access not supported\n");
+		return -EFAULT;
 	}
-	if (bpfilter_ops.info.tgid &&
-	    thread_group_exited(bpfilter_ops.info.tgid))
-		bpfilter_umh_cleanup(&bpfilter_ops.info);
+	err = umd_mgmt_send_recv(&bpfilter_ops, &req, sizeof(req), &reply,
+				 sizeof(reply));
+	if (err)
+		return err;
 
-	if (!bpfilter_ops.info.tgid) {
-		err = bpfilter_ops.start();
-		if (err)
-			goto out;
-	}
-	err = bpfilter_ops.sockopt(sk, optname, optval, optlen, is_set);
-out:
-	mutex_unlock(&bpfilter_ops.lock);
-	return err;
+	return reply.status;
+}
+
+static int bpfilter_post_start_umh(struct umd_mgmt *mgmt)
+{
+	struct mbox_request req = { .pid = current->pid };
+	struct mbox_reply reply;
+
+	/* health check that usermode process started correctly */
+	if (umd_send_recv(&bpfilter_ops.info, &req, sizeof(req), &reply,
+			  sizeof(reply)) != 0 || reply.status != 0)
+		return -EFAULT;
+
+	return 0;
 }
 
 int bpfilter_ip_set_sockopt(struct sock *sk, int optname, sockptr_t optval,
 			    unsigned int optlen)
 {
-	return bpfilter_mbox_request(sk, optname, optval, optlen, true);
+	return bpfilter_process_sockopt(sk, optname, optval, optlen, true);
 }
 
 int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
@@ -65,8 +75,8 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	return bpfilter_mbox_request(sk, optname, USER_SOCKPTR(optval), len,
-				     false);
+	return bpfilter_process_sockopt(sk, optname, USER_SOCKPTR(optval), len,
+					false);
 }
 
 static int __init bpfilter_sockopt_init(void)
@@ -74,6 +84,9 @@ static int __init bpfilter_sockopt_init(void)
 	mutex_init(&bpfilter_ops.lock);
 	bpfilter_ops.info.tgid = NULL;
 	bpfilter_ops.info.driver_name = "bpfilter_umh";
+	bpfilter_ops.post_start = bpfilter_post_start_umh;
+	bpfilter_ops.kmod = "bpfilter";
+	bpfilter_ops.kmod_loaded = false;
 
 	return 0;
 }
-- 
2.25.1

