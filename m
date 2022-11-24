Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB8E637CBC
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKXPTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKXPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:19:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177DA16E8F6
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4mRjiCLMtLsImdt9LVO/5YkmYrf/jxzVEf75LrlJsQ=;
        b=WMoqfhHIPur4m39uFdD55swI3TPWyip5MR+/YEd6VWpIz8tuCUueamx55JMG1Wo/cfoovM
        4kou/7/hISLQ/ogpwR3j4M1hgXo2xNxsau3JIiIsNVXaRrr9PyeUSyWLh/59VlrteckzJ2
        3h6tUnmmR8SrpAv7v7C3o0cwbaJbTZ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-LihkDvwXO72orWAoMDlcbQ-1; Thu, 24 Nov 2022 10:16:18 -0500
X-MC-Unique: LihkDvwXO72orWAoMDlcbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FBE58582B9;
        Thu, 24 Nov 2022 15:16:17 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD6CA40C2064;
        Thu, 24 Nov 2022 15:16:15 +0000 (UTC)
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
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 04/10] HID: add the bpf loader that can attach a generic hid-bpf program
Date:   Thu, 24 Nov 2022 16:15:57 +0100
Message-Id: <20221124151603.807536-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is added to the hid bus, we check if there are any known
in-kernel bpf programs related to this device, and when found, we
load them, run the probe syscall if any, and then attach and pin
those programs to the HID device before presenting it to the userspace.

There are still a few bits missing right now:
- the list of programs should not be in kernel but in a separated module
  at least
- the pinned program has an incorrect path (not namespaced to the device)
- the pinned program stay around when the device is disconnected
- we could use the firmware interface to replace the array of programs,
  but how do we distribute and install them?

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/bpf/Makefile           |   3 +-
 drivers/hid/bpf/hid_bpf_dispatch.c |   3 +-
 drivers/hid/bpf/hid_bpf_loader.c   | 243 +++++++++++++++++++++++++++++
 drivers/hid/hid-core.c             |   2 +
 include/linux/hid_bpf.h            |   2 +
 5 files changed, 251 insertions(+), 2 deletions(-)
 create mode 100644 drivers/hid/bpf/hid_bpf_loader.c

diff --git a/drivers/hid/bpf/Makefile b/drivers/hid/bpf/Makefile
index cf55120cf7d6..d0c5fbc506b4 100644
--- a/drivers/hid/bpf/Makefile
+++ b/drivers/hid/bpf/Makefile
@@ -8,4 +8,5 @@ LIBBPF_INCLUDE = $(srctree)/tools/lib
 obj-$(CONFIG_HID_BPF) += hid_bpf.o
 CFLAGS_hid_bpf_dispatch.o += -I$(LIBBPF_INCLUDE)
 CFLAGS_hid_bpf_jmp_table.o += -I$(LIBBPF_INCLUDE)
-hid_bpf-objs += hid_bpf_dispatch.o hid_bpf_jmp_table.o
+CFLAGS_hid_bpf_loader.o += -I$(LIBBPF_INCLUDE)
+hid_bpf-objs += hid_bpf_dispatch.o hid_bpf_jmp_table.o hid_bpf_loader.o
diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index c3920c7964dc..3c989e74d249 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -238,7 +238,8 @@ static int hid_bpf_allocate_event_data(struct hid_device *hdev)
 
 int hid_bpf_reconnect(struct hid_device *hdev)
 {
-	if (!test_and_set_bit(ffs(HID_STAT_REPROBED), &hdev->status))
+	if (hdev->status & HID_STAT_ADDED &&
+	    !test_and_set_bit(ffs(HID_STAT_REPROBED), &hdev->status))
 		return device_reprobe(&hdev->dev);
 
 	return 0;
diff --git a/drivers/hid/bpf/hid_bpf_loader.c b/drivers/hid/bpf/hid_bpf_loader.c
new file mode 100644
index 000000000000..d2aa0a8e78c7
--- /dev/null
+++ b/drivers/hid/bpf/hid_bpf_loader.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Benjamin Tissoires
+ */
+
+#include <bpf/skel_internal.h>
+#include <linux/hid.h>
+#include <linux/hid_bpf.h>
+#include <linux/minmax.h>
+
+#include "hid_bpf_dispatch.h"
+#include "progs/hid_bpf.h"
+#include "progs/hid_bpf_progs.h"
+
+struct generic_bpf_skel {
+	struct hid_bpf_object *obj;
+	struct bpf_map_desc *maps;
+	struct bpf_prog_desc *progs;
+	int *links;
+	void *rodata;
+	/*
+	 * ctx needs to come last, it is populated by the bpf loader
+	 * beyond the end of the struct, which we get through maps
+	 * and progs above.
+	 */
+	struct bpf_loader_ctx ctx;
+};
+
+static size_t hid_bpf_get_obj_ctx_size(struct hid_bpf_object *obj)
+{
+	return sizeof(struct generic_bpf_skel) +
+	       sizeof(struct bpf_map_desc) * obj->map_cnt +
+	       sizeof(struct bpf_prog_desc) * obj->prog_cnt +
+	       sizeof(int) * obj->prog_cnt;
+}
+
+static void
+generic_bpf_skel__detach(struct generic_bpf_skel *skel)
+{
+	int i;
+
+	for (i = 0; i < skel->obj->prog_cnt; i++)
+		skel_closenz(skel->links[i]);
+}
+
+static void
+generic_bpf_skel__destroy(struct generic_bpf_skel *skel)
+{
+	int i;
+
+	if (!skel)
+		return;
+
+	generic_bpf_skel__detach(skel);
+
+	for (i = 0; i < skel->obj->prog_cnt; i++)
+		skel_closenz(skel->progs[i].prog_fd);
+
+	if (skel->obj->rodata < skel->obj->map_cnt) {
+		skel_free_map_data(skel->rodata,
+				   skel->maps[skel->obj->rodata].initial_value,
+				   skel->obj->maps[skel->obj->rodata].mmap_sz);
+	}
+
+	for (i = 0; i < skel->obj->map_cnt; i++)
+		skel_closenz(skel->maps[i].map_fd);
+
+	skel_free(skel);
+}
+
+static struct generic_bpf_skel *
+generic_bpf_skel__open(struct hid_bpf_object *obj)
+{
+	struct generic_bpf_skel *skel;
+
+	skel = skel_alloc(hid_bpf_get_obj_ctx_size(obj));
+	if (!skel)
+		goto cleanup;
+	skel->obj = obj;
+	skel->ctx.sz = hid_bpf_get_obj_ctx_size(obj) - offsetof(struct generic_bpf_skel, ctx);
+
+	skel->maps = (struct bpf_map_desc *)(skel + 1);
+	skel->progs = (struct bpf_prog_desc *)(skel->maps + obj->map_cnt);
+	skel->links = (int *)(skel->progs + obj->prog_cnt);
+
+	if (obj->rodata < obj->map_cnt) {
+		skel->rodata = skel_prep_map_data((void *)obj->maps[obj->rodata].data,
+						  obj->maps[obj->rodata].mmap_sz,
+						  obj->maps[obj->rodata].size);
+
+		if (!skel->rodata)
+			goto cleanup;
+		skel->maps[obj->rodata].initial_value = (__u64) (long) skel->rodata;
+	}
+
+	return (struct generic_bpf_skel *)skel;
+
+cleanup:
+	generic_bpf_skel__destroy((struct generic_bpf_skel *)skel);
+	return NULL;
+}
+
+static int
+generic_bpf_skel__load(struct generic_bpf_skel *skel)
+{
+	struct bpf_load_and_run_opts opts = {};
+	int err;
+
+	opts.ctx = &skel->ctx;
+	opts.data_sz = skel->obj->data_sz;
+	opts.data = (void *)skel->obj->data;
+	opts.insns_sz = skel->obj->insns_sz;
+	opts.insns = skel->obj->insns;
+
+	err = bpf_load_and_run(&opts);
+	if (err < 0)
+		return err;
+
+	if (skel->obj->rodata < skel->obj->map_cnt) {
+		skel->rodata = skel_finalize_map_data(&skel->maps[skel->obj->rodata].initial_value,
+						      skel->obj->maps[skel->obj->rodata].mmap_sz,
+						      PROT_READ,
+						      skel->maps[skel->obj->rodata].map_fd);
+		if (!skel->rodata)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static struct generic_bpf_skel *
+generic_bpf_skel__open_and_load(struct hid_bpf_object *obj)
+{
+	struct generic_bpf_skel *skel;
+
+	skel = generic_bpf_skel__open(obj);
+	if (!skel)
+		return NULL;
+	if (generic_bpf_skel__load(skel)) {
+		generic_bpf_skel__destroy(skel);
+		return NULL;
+	}
+	return skel;
+}
+
+static int
+execute_probe(struct hid_device *hdev, struct generic_bpf_skel *skel)
+{
+	const size_t test_run_attr_sz = offsetofend(union bpf_attr, test);
+	struct hid_bpf_probe_args *ctx;
+	union bpf_attr attr;
+	int err;
+
+	/* early abort if there is no probe program */
+	if (skel->obj->probe >= skel->obj->prog_cnt)
+		return 0;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	memset(&attr, 0, test_run_attr_sz);
+
+	attr.test.prog_fd = skel->progs[skel->obj->probe].prog_fd;
+
+	attr.test.ctx_in = (long) ctx;
+	attr.test.ctx_size_in = sizeof(*ctx);
+
+	ctx->hid = hdev->id;
+
+	ctx->rdesc_size = hdev->dev_rsize;
+
+	memcpy(ctx->rdesc, hdev->dev_rdesc,
+	       min_t(unsigned int, sizeof(ctx->rdesc), hdev->dev_rsize));
+
+	err = skel_sys_bpf(BPF_PROG_RUN, &attr, test_run_attr_sz);
+	if (err < 0 || (int)attr.test.retval < 0) {
+		if (err == 0)
+			err = (int)attr.test.retval;
+	} else {
+		err = ctx->retval;
+	}
+
+	kfree(ctx);
+	return err;
+}
+
+static void __hid_load_internal_bpf_program(struct hid_device *hdev, struct hid_bpf_object *obj)
+{
+	struct generic_bpf_skel *skel;
+	int err;
+
+	skel = generic_bpf_skel__open_and_load(obj);
+	if (!skel)
+		return;
+
+	err = execute_probe(hdev, skel);
+	if (err)
+		goto out;
+
+	/*
+	 * The bpf object is loaded and probe returned 0, we can bind
+	 * all of its HID-BPF programs to the device.
+	 */
+	for (int i = 0; i < obj->prog_cnt; i++) {
+		int prog_fd = skel->progs[i].prog_fd;
+		enum hid_bpf_prog_type prog_type;
+		struct bpf_prog *prog;
+
+		if (i == obj->probe)
+			continue;
+
+		prog_type = hid_bpf_get_prog_attach_type(prog_fd);
+
+		/* ignore non HID-BPF programs */
+		if (prog_type < 0 || prog_type >= HID_BPF_PROG_TYPE_MAX)
+			continue;
+
+		err = __hid_bpf_attach_prog(hdev, prog_type, prog_fd, 0);
+
+		if (!err) {
+			prog = bpf_prog_get(prog_fd);
+			/* TODO: prefix the name with 'hid/bus_vid_pid_id/' */
+			err = bpf_prog_pin_kernel(prog->aux->name, prog);
+			if (err)
+				bpf_prog_put(prog);
+		}
+	}
+
+ out:
+	generic_bpf_skel__destroy(skel);
+}
+
+int hid_load_internal_bpf_programs(struct hid_device *hdev)
+{
+	struct hid_bpf_object *obj;
+
+	for (obj = &hid_objects[0]; obj->id.bus; obj++) {
+		if (hid_match_one_id(hdev, &obj->id))
+			__hid_load_internal_bpf_program(hdev, obj);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hid_load_internal_bpf_programs);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index fa4436b8101e..b27b4faad5bc 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2761,6 +2761,8 @@ int hid_add_device(struct hid_device *hdev)
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
 		     hdev->vendor, hdev->product, hdev->id);
 
+	hid_load_internal_bpf_programs(hdev);
+
 	hid_debug_register(hdev, dev_name(&hdev->dev));
 	ret = device_add(&hdev->dev);
 	if (!ret)
diff --git a/include/linux/hid_bpf.h b/include/linux/hid_bpf.h
index 3ca85ab91325..2b06ddf64c1c 100644
--- a/include/linux/hid_bpf.h
+++ b/include/linux/hid_bpf.h
@@ -146,6 +146,7 @@ void hid_bpf_disconnect_device(struct hid_device *hdev);
 void hid_bpf_destroy_device(struct hid_device *hid);
 void hid_bpf_device_init(struct hid_device *hid);
 u8 *call_hid_bpf_rdesc_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size);
+int hid_load_internal_bpf_programs(struct hid_device *hdev);
 #else /* CONFIG_HID_BPF */
 static inline u8 *dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type,
 						u8 *data, u32 *size, int interrupt) { return data; }
@@ -157,6 +158,7 @@ static inline u8 *call_hid_bpf_rdesc_fixup(struct hid_device *hdev, u8 *rdesc, u
 {
 	return kmemdup(rdesc, *size, GFP_KERNEL);
 }
+static inline int hid_load_internal_bpf_programs(struct hid_device *hdev) { return 0; }
 
 #endif /* CONFIG_HID_BPF */
 
-- 
2.38.1

