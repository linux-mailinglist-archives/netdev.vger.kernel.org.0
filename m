Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC6E6BED09
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjCQPdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCQPdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:33:17 -0400
X-Greylist: delayed 1190 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Mar 2023 08:32:44 PDT
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D09CAD00A;
        Fri, 17 Mar 2023 08:32:43 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4PdRkT0yYYz9xFGZ;
        Fri, 17 Mar 2023 22:45:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBnOWDafhRkaQemAQ--.41316S4;
        Fri, 17 Mar 2023 15:53:53 +0100 (CET)
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
Subject: [PATCH 2/5] usermode_driver_mgmt: Introduce management of user mode drivers
Date:   Fri, 17 Mar 2023 15:52:37 +0100
Message-Id: <20230317145240.363908-3-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwBnOWDafhRkaQemAQ--.41316S4
X-Coremail-Antispam: 1UD129KBjvJXoWxKFy5KF4rWr18AFW7ur4rZrb_yoWfJFyUpF
        WUJry5uws5J34UZ3Z3G3yUuayfZw4kZF1YgFZ3Ww4Svwn2qr1jqr17t3W5uryxKr95GF12
        yrZ09Fn8Crs8WrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
        Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
        6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14
        v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
        rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXw
        CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
        67AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
        1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU
        IID7DUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4asxgADsL
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Reuse the bpfilter code, with some adjustments to make the code more
generic, and usable for other user mode drivers.

:: struct umd_mgmt <=== struct bpfilter_umh_ops ::
Replace the start method with post_start, to allow for some customization
of the start procedure. All start procedures have in common the call to
fork_usermode_driver().

Remove the sockopt method, as it is use case-specific. Instead, use one of
the following two alternatives: generate the message from the manager of
the driver (e.g. sockopt), by exporting the message format definition; or,
define a new structure embedding the umd_mgmt and the custom method, which
can be registered from the kernel module through the post_start method.

Add kmod and kmod_loaded. Kmod is name of the kernel module that
umd_mgmt_send_recv() (from bpfilter_mbox_request()) attempts to load if
kmod_loaded is false (the driver is not yet started). Kmod_loaded is added
to replace the sockopt method test, and ensure that the driver is ready for
use.

:: start_umh() <=== start_umh() ::
Remove the connection test, and call the post_start method in umd_mgmt, if
set, which could point to that test.

:: shutdown_umh() <=== shutdown_umh() ::
Same code.

:: umd_mgmt_send_recv() <=== bpfilter_mbox_request() ::
Replace the bpfilter_mbox_request() parameters with the parameters of
umd_send_recv(), except for the first which is a umd_mgmt structure instead
of umd_info. Also, call umd_send_recv() instead of the sockopt method, and
shutdown the driver if there is an error.

:: umd_mgmt_load() <=== load_umh() ::
Same code except for the registration of the start and sockopt methods,
replaced with setting kmod_loaded to true (not depending on CONFIG_INET),
as mentioned in the explanation of umd_mgmt.

:: umd_mgmt_unload() <=== fini_umh() ::
Same code except for the deregistration of the start and sockopt methods,
replaced with setting kmod_loaded to false (not depending on CONFIG_INET).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 MAINTAINERS                          |   7 ++
 include/linux/usermode_driver_mgmt.h |  35 +++++++
 kernel/Makefile                      |   2 +-
 kernel/usermode_driver_mgmt.c        | 137 +++++++++++++++++++++++++++
 4 files changed, 180 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/usermode_driver_mgmt.h
 create mode 100644 kernel/usermode_driver_mgmt.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a3b14ec3383..7b27435fd20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11245,6 +11245,13 @@ S:	Maintained
 F:	include/linux/umh.h
 F:	kernel/umh.c
 
+KERNEL USERMODE DRIVER MANAGEMENT
+M:	Roberto Sassu <roberto.sassu@huawei.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/usermode_driver_mgmt.h
+F:	kernel/usermode_driver_mgmt.c
+
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Paolo Bonzini <pbonzini@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/include/linux/usermode_driver_mgmt.h b/include/linux/usermode_driver_mgmt.h
new file mode 100644
index 00000000000..3f9fc783a09
--- /dev/null
+++ b/include/linux/usermode_driver_mgmt.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 Huawei Technologies Duesseldorf GmbH
+ *
+ * User mode driver management API.
+ */
+#ifndef __LINUX_USERMODE_DRIVER_MGMT_H__
+#define __LINUX_USERMODE_DRIVER_MGMT_H__
+
+#include <linux/usermode_driver.h>
+
+/**
+ * struct umd_mgmt - user mode driver management structure
+ * @info: user mode driver information
+ * @lock: lock to serialize requests to the UMD Handler
+ * @post_start: function with additional operations after UMD Handler is started
+ * @kmod: kernel module acting as UMD Loader, to start the UMD Handler
+ * @kmod_loaded: whether @kmod is loaded or not
+ *
+ * Information necessary to manage the UMD during its lifecycle.
+ */
+struct umd_mgmt {
+	struct umd_info info;
+	struct mutex lock;
+	int (*post_start)(struct umd_mgmt *mgmt);
+	const char *kmod;
+	bool kmod_loaded;
+};
+
+int umd_mgmt_send_recv(struct umd_mgmt *mgmt, void *in, size_t in_len,
+		       void *out, size_t out_len);
+int umd_mgmt_load(struct umd_mgmt *mgmt, char *start, char *end);
+void umd_mgmt_unload(struct umd_mgmt *mgmt);
+
+#endif /* __LINUX_USERMODE_DRIVER_MGMT_H__ */
diff --git a/kernel/Makefile b/kernel/Makefile
index 10ef068f598..ee47f7c2023 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -12,7 +12,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o regset.o
 
-obj-$(CONFIG_USERMODE_DRIVER) += usermode_driver.o
+obj-$(CONFIG_USERMODE_DRIVER) += usermode_driver.o usermode_driver_mgmt.o
 obj-$(CONFIG_MODULES) += kmod.o
 obj-$(CONFIG_MULTIUSER) += groups.o
 
diff --git a/kernel/usermode_driver_mgmt.c b/kernel/usermode_driver_mgmt.c
new file mode 100644
index 00000000000..4fb06b37f62
--- /dev/null
+++ b/kernel/usermode_driver_mgmt.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Huawei Technologies Duesseldorf GmbH
+ *
+ * User mode driver management library.
+ */
+#include <linux/kmod.h>
+#include <linux/fs.h>
+#include <linux/usermode_driver_mgmt.h>
+
+static void shutdown_umh(struct umd_mgmt *mgmt)
+{
+	struct umd_info *info = &mgmt->info;
+	struct pid *tgid = info->tgid;
+
+	if (tgid) {
+		kill_pid(tgid, SIGKILL, 1);
+		wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
+		umd_cleanup_helper(info);
+	}
+}
+
+static int start_umh(struct umd_mgmt *mgmt)
+{
+	int err;
+
+	/* fork usermode process */
+	err = fork_usermode_driver(&mgmt->info);
+	if (err)
+		return err;
+	pr_info("Loaded %s pid %d\n", mgmt->info.driver_name,
+		pid_nr(mgmt->info.tgid));
+
+	if (mgmt->post_start) {
+		err = mgmt->post_start(mgmt);
+		if (err)
+			shutdown_umh(mgmt);
+	}
+
+	return err;
+}
+
+/**
+ * umd_mgmt_send_recv - Communicate with the UMD Handler and start it.
+ * @mgmt: user mode driver management structure
+ * @in: request message
+ * @in_len: size of @in
+ * @out: reply message
+ * @out_len: size of @out
+ *
+ * Send a message to the UMD Handler through the created pipe and read the
+ * reply. If the UMD Handler is not available, invoke the UMD Loader to
+ * instantiate it. If the UMD Handler exited, restart it.
+ *
+ * Return: Zero on success, a negative value otherwise.
+ */
+int umd_mgmt_send_recv(struct umd_mgmt *mgmt, void *in, size_t in_len,
+		       void *out, size_t out_len)
+{
+	int err;
+
+	mutex_lock(&mgmt->lock);
+	if (!mgmt->kmod_loaded) {
+		mutex_unlock(&mgmt->lock);
+		request_module(mgmt->kmod);
+		mutex_lock(&mgmt->lock);
+
+		if (!mgmt->kmod_loaded) {
+			err = -ENOPROTOOPT;
+			goto out;
+		}
+	}
+	if (mgmt->info.tgid &&
+	    thread_group_exited(mgmt->info.tgid))
+		umd_cleanup_helper(&mgmt->info);
+
+	if (!mgmt->info.tgid) {
+		err = start_umh(mgmt);
+		if (err)
+			goto out;
+	}
+	err = umd_send_recv(&mgmt->info, in, in_len, out, out_len);
+	if (err)
+		shutdown_umh(mgmt);
+out:
+	mutex_unlock(&mgmt->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(umd_mgmt_send_recv);
+
+/**
+ * umd_mgmt_load - Load and start the UMD Handler.
+ * @mgmt: user mode driver management structure
+ * @start: start address of the binary blob of the UMD Handler
+ * @end: end address of the binary blob of the UMD Handler
+ *
+ * Copy the UMD Handler binary from the specified location to a private tmpfs
+ * filesystem. Then, start the UMD Handler.
+ *
+ * Return: Zero on success, a negative value otherwise.
+ */
+int umd_mgmt_load(struct umd_mgmt *mgmt, char *start, char *end)
+{
+	int err;
+
+	err = umd_load_blob(&mgmt->info, start, end - start);
+	if (err)
+		return err;
+
+	mutex_lock(&mgmt->lock);
+	err = start_umh(mgmt);
+	if (!err)
+		mgmt->kmod_loaded = true;
+	mutex_unlock(&mgmt->lock);
+	if (err)
+		umd_unload_blob(&mgmt->info);
+	return err;
+}
+EXPORT_SYMBOL_GPL(umd_mgmt_load);
+
+/**
+ * umd_mgmt_unload - Terminate and unload the UMD Handler.
+ * @mgmt: user mode driver management structure
+ *
+ * Terminate the UMD Handler, and cleanup the private tmpfs filesystem with the
+ * UMD Handler binary.
+ */
+void umd_mgmt_unload(struct umd_mgmt *mgmt)
+{
+	mutex_lock(&mgmt->lock);
+	shutdown_umh(mgmt);
+	mgmt->kmod_loaded = false;
+	mutex_unlock(&mgmt->lock);
+
+	umd_unload_blob(&mgmt->info);
+}
+EXPORT_SYMBOL_GPL(umd_mgmt_unload);
-- 
2.25.1

