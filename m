Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9259965FED0
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbjAFKZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbjAFKYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:24:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FD26AD99
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673000637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ne7lEDhvuOQBbM0ub5oLvNggTzThdbAuSVTqTk6kGvY=;
        b=BCBd/tTyGc29xLoMKZ0XElNBHc6kowvmJ3htoBKsSivBzYqO0yMXlcbLdfwhWXEFTBQdLJ
        VQOhKUKMdCgaMJublCK7LQFDJRGJqwXylR5L7GNBayt8mU1/+5bcqNhXUV6P3wmqlkh1yf
        pGcCAFCuRz1ShE29rYx9BHQ6g3PNa3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-0rq5meD4McWzueleV6l2fg-1; Fri, 06 Jan 2023 05:23:54 -0500
X-MC-Unique: 0rq5meD4McWzueleV6l2fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 936F21871D97;
        Fri,  6 Jan 2023 10:23:53 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1796C15BAD;
        Fri,  6 Jan 2023 10:23:51 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v1 6/9] HID: bpf: rework how programs are attached and stored in the kernel
Date:   Fri,  6 Jan 2023 11:23:29 +0100
Message-Id: <20230106102332.1019632-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, HID-BPF was relying on a bpf tracing program to be notified
when a program was released from userspace. This is error prone, as
LLVM sometimes inline the function and sometimes not.

So instead of messing up with the bpf prog ref count, we can use the
bpf_link concept which actually matches exactly what we want:
- a bpf_link represents the fact that a given program is attached to a
  given HID device
- as long as the bpf_link has fd opened (either by the userspace program
  still being around or by pinning the bpf object in the bpffs), the
  program stays attached to the HID device
- once every user has closed the fd, we get called by
  hid_bpf_link_release() that we no longer have any users, and we can
  disconnect the program to the device in 2 passes: first atomically clear
  the bit saying that the link is active, and then calling release_work in
  a scheduled work item.

This solves entirely the problems of BPF tracing not showing up and is
definitely cleaner.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 Documentation/hid/hid-bpf.rst       |  12 ++-
 drivers/hid/bpf/hid_bpf_dispatch.c  |  18 +++--
 drivers/hid/bpf/hid_bpf_jmp_table.c | 116 +++++++++++++++-------------
 include/linux/hid_bpf.h             |   7 ++
 4 files changed, 90 insertions(+), 63 deletions(-)

diff --git a/Documentation/hid/hid-bpf.rst b/Documentation/hid/hid-bpf.rst
index a55f191d49a3..c205f92b7bcc 100644
--- a/Documentation/hid/hid-bpf.rst
+++ b/Documentation/hid/hid-bpf.rst
@@ -427,12 +427,22 @@ program first::
 	prog_fd = bpf_program__fd(hid_skel->progs.attach_prog);
 
 	err = bpf_prog_test_run_opts(prog_fd, &tattrs);
-	return err;
+	if (err)
+		return err;
+
+	return args.retval; /* the fd of the created bpf_link */
   }
 
 Our userspace program can now listen to notifications on the ring buffer, and
 is awaken only when the value changes.
 
+When the userspace program doesn't need to listen to events anymore, it can just
+close the returned fd from :c:func:`attach_filter`, which will tell the kernel to
+detach the program from the HID device.
+
+Of course, in other use cases, the userspace program can also pin the fd to the
+BPF filesystem through a call to :c:func:`bpf_obj_pin`, as with any bpf_link.
+
 Controlling the device
 ----------------------
 
diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index 58e608ebf0fa..8d29fd361ab9 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -249,7 +249,9 @@ int hid_bpf_reconnect(struct hid_device *hdev)
  * @prog_fd: an fd in the user process representing the program to attach
  * @flags: any logical OR combination of &enum hid_bpf_attach_flags
  *
- * @returns %0 on success, an error code otherwise.
+ * @returns an fd of a bpf_link object on success (> %0), an error code otherwise.
+ * Closing this fd will detach the program from the HID device (unless the bpf_link
+ * is pinned to the BPF file system).
  */
 /* called from syscall */
 noinline int
@@ -257,7 +259,7 @@ hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags)
 {
 	struct hid_device *hdev;
 	struct device *dev;
-	int err, prog_type = hid_bpf_get_prog_attach_type(prog_fd);
+	int fd, err, prog_type = hid_bpf_get_prog_attach_type(prog_fd);
 
 	if (!hid_bpf_ops)
 		return -EINVAL;
@@ -283,17 +285,19 @@ hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags)
 			return err;
 	}
 
-	err = __hid_bpf_attach_prog(hdev, prog_type, prog_fd, flags);
-	if (err)
-		return err;
+	fd = __hid_bpf_attach_prog(hdev, prog_type, prog_fd, flags);
+	if (fd < 0)
+		return fd;
 
 	if (prog_type == HID_BPF_PROG_TYPE_RDESC_FIXUP) {
 		err = hid_bpf_reconnect(hdev);
-		if (err)
+		if (err) {
+			close_fd(fd);
 			return err;
+		}
 	}
 
-	return 0;
+	return fd;
 }
 
 /**
diff --git a/drivers/hid/bpf/hid_bpf_jmp_table.c b/drivers/hid/bpf/hid_bpf_jmp_table.c
index 207972b028d9..21bbb5809fbc 100644
--- a/drivers/hid/bpf/hid_bpf_jmp_table.c
+++ b/drivers/hid/bpf/hid_bpf_jmp_table.c
@@ -322,16 +322,6 @@ static int hid_bpf_insert_prog(int prog_fd, struct bpf_prog *prog)
 	if (err)
 		goto out;
 
-	/*
-	 * The program has been safely inserted, decrement the reference count
-	 * so it doesn't interfere with the number of actual user handles.
-	 * This is safe to do because:
-	 * - we overrite the put_ptr in the prog fd map
-	 * - we also have a cleanup function that monitors when a program gets
-	 *   released and we manually do the cleanup in the prog fd map
-	 */
-	bpf_prog_sub(prog, 1);
-
 	/* return the index */
 	err = index;
 
@@ -365,11 +355,43 @@ int hid_bpf_get_prog_attach_type(int prog_fd)
 	return prog_type;
 }
 
+static void hid_bpf_link_release(struct bpf_link *link)
+{
+	struct hid_bpf_link *hid_link =
+		container_of(link, struct hid_bpf_link, link);
+
+	__clear_bit(hid_link->index, jmp_table.enabled);
+	schedule_work(&release_work);
+}
+
+static void hid_bpf_link_dealloc(struct bpf_link *link)
+{
+	struct hid_bpf_link *hid_link =
+		container_of(link, struct hid_bpf_link, link);
+
+	kfree(hid_link);
+}
+
+static void hid_bpf_link_show_fdinfo(const struct bpf_link *link,
+					 struct seq_file *seq)
+{
+	seq_printf(seq,
+		   "attach_type:\tHID-BPF\n");
+}
+
+static const struct bpf_link_ops hid_bpf_link_lops = {
+	.release = hid_bpf_link_release,
+	.dealloc = hid_bpf_link_dealloc,
+	.show_fdinfo = hid_bpf_link_show_fdinfo,
+};
+
 /* called from syscall */
 noinline int
 __hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_type,
 		      int prog_fd, __u32 flags)
 {
+	struct bpf_link_primer link_primer;
+	struct hid_bpf_link *link;
 	struct bpf_prog *prog = NULL;
 	struct hid_bpf_prog_entry *prog_entry;
 	int cnt, err = -EINVAL, prog_idx = -1;
@@ -381,23 +403,32 @@ __hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_type,
 
 	mutex_lock(&hid_bpf_attach_lock);
 
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
+		err = -ENOMEM;
+		goto err_unlock;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_UNSPEC,
+		      &hid_bpf_link_lops, prog);
+
 	/* do not attach too many programs to a given HID device */
 	cnt = hid_bpf_program_count(hdev, NULL, prog_type);
 	if (cnt < 0) {
 		err = cnt;
-		goto out_unlock;
+		goto err_unlock;
 	}
 
 	if (cnt >= hid_bpf_max_programs(prog_type)) {
 		err = -E2BIG;
-		goto out_unlock;
+		goto err_unlock;
 	}
 
 	prog_idx = hid_bpf_insert_prog(prog_fd, prog);
 	/* if the jmp table is full, abort */
 	if (prog_idx < 0) {
 		err = prog_idx;
-		goto out_unlock;
+		goto err_unlock;
 	}
 
 	if (flags & HID_BPF_FLAG_INSERT_HEAD) {
@@ -418,16 +449,26 @@ __hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_type,
 
 	/* finally store the index in the device list */
 	err = hid_bpf_populate_hdev(hdev, prog_type);
-	if (err)
+	if (err) {
 		hid_bpf_release_prog_at(prog_idx);
+		goto err_unlock;
+	}
+
+	link->index = prog_idx;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto err_unlock;
 
- out_unlock:
 	mutex_unlock(&hid_bpf_attach_lock);
 
-	/* we only use prog as a key in the various tables, so we don't need to actually
-	 * increment the ref count.
-	 */
+	return bpf_link_settle(&link_primer);
+
+ err_unlock:
+	mutex_unlock(&hid_bpf_attach_lock);
+
 	bpf_prog_put(prog);
+	kfree(link);
 
 	return err;
 }
@@ -460,36 +501,10 @@ void __hid_bpf_destroy_device(struct hid_device *hdev)
 
 void call_hid_bpf_prog_put_deferred(struct work_struct *work)
 {
-	struct bpf_prog_aux *aux;
-	struct bpf_prog *prog;
-	bool found = false;
-	int i;
-
-	aux = container_of(work, struct bpf_prog_aux, work);
-	prog = aux->prog;
-
-	/* we don't need locking here because the entries in the progs table
-	 * are stable:
-	 * if there are other users (and the progs entries might change), we
-	 * would simply not have been called.
-	 */
-	for (i = 0; i < HID_BPF_MAX_PROGS; i++) {
-		if (jmp_table.progs[i] == prog) {
-			__clear_bit(i, jmp_table.enabled);
-			found = true;
-		}
-	}
-
-	if (found)
-		/* schedule release of all detached progs */
-		schedule_work(&release_work);
-}
-
-static void hid_bpf_prog_fd_array_put_ptr(void *ptr)
-{
+	/* kept around for patch readability, to be dropped in the next commmit */
 }
 
-#define HID_BPF_PROGS_COUNT 2
+#define HID_BPF_PROGS_COUNT 1
 
 static struct bpf_link *links[HID_BPF_PROGS_COUNT];
 static struct entrypoints_bpf *skel;
@@ -528,8 +543,6 @@ void hid_bpf_free_links_and_skel(void)
 	idx++;									\
 } while (0)
 
-static struct bpf_map_ops hid_bpf_prog_fd_maps_ops;
-
 int hid_bpf_preload_skel(void)
 {
 	int err, idx = 0;
@@ -548,14 +561,7 @@ int hid_bpf_preload_skel(void)
 		goto out;
 	}
 
-	/* our jump table is stealing refs, so we should not decrement on removal of elements */
-	hid_bpf_prog_fd_maps_ops = *jmp_table.map->ops;
-	hid_bpf_prog_fd_maps_ops.map_fd_put_ptr = hid_bpf_prog_fd_array_put_ptr;
-
-	jmp_table.map->ops = &hid_bpf_prog_fd_maps_ops;
-
 	ATTACH_AND_STORE_LINK(hid_tail_call);
-	ATTACH_AND_STORE_LINK(hid_bpf_prog_put_deferred);
 
 	return 0;
 out:
diff --git a/include/linux/hid_bpf.h b/include/linux/hid_bpf.h
index 3ca85ab91325..6da923c90393 100644
--- a/include/linux/hid_bpf.h
+++ b/include/linux/hid_bpf.h
@@ -3,6 +3,7 @@
 #ifndef __HID_BPF_H
 #define __HID_BPF_H
 
+#include <linux/bpf.h>
 #include <linux/spinlock.h>
 #include <uapi/linux/hid.h>
 
@@ -138,6 +139,12 @@ struct hid_bpf {
 	spinlock_t progs_lock;		/* protects RCU update of progs */
 };
 
+/* specific HID-BPF link when a program is attached to a device */
+struct hid_bpf_link {
+	struct bpf_link link;
+	int index;
+};
+
 #ifdef CONFIG_HID_BPF
 u8 *dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
 				  u32 *size, int interrupt);
-- 
2.38.1

