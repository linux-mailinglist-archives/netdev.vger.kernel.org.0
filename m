Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9586A3F37A4
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbhHUAVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240334AbhHUAVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:48 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02DFC06129E;
        Fri, 20 Aug 2021 17:20:59 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k24so10812324pgh.8;
        Fri, 20 Aug 2021 17:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1B8YkbMEvZ3DV1ZDQ1TOjgFOKhLs0+f0ghgPprjZ2zo=;
        b=lUD8axCqPYfitDznndbaktdzP66+RHYMQyUE7rohIAaxJVOOhjZslWuY1gsGFlMAb0
         63cIBYotKKzmHanNv0yyjSrqle1czgW6F+Od2BAU7yLR8h9XuxmiLXZjIsM2A1x1vMMD
         R17eZ2WNfrRv+GM21nMXYvRiwcgnvjYtdzCgyhicAXz6dc0/ZrfeQdtWvoomRSQEIMhl
         nt6CNae+qlUI1ia0pAZrU6/5xUbnlduTMFUsUqLpzNOWHHt1QB8RHEA4vMnbM2eDOJOU
         Xw2KRMNk8q3TsEQoQdAVR3Hf/MCCfbuMhpqiobjVn97O2PWDrSn1fHy5+YIOu308Xa7r
         pJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1B8YkbMEvZ3DV1ZDQ1TOjgFOKhLs0+f0ghgPprjZ2zo=;
        b=C56UAmexQn2Zuj4QBzYOLgfUNubGznHy33Ox0oMdmZmdvkVMbvhE9TeEt/qM3CEh+u
         7SMIImGo9DaX/MCpTMaQLMlnU/8lHle/fkslKpXHP6pQWdONXvUVF6aA3xqbpe2BTtI0
         RGDjLQ2ICK8MoMVuaEYLurHvbx1kUe1i/20JVONZImCPdxDL29Mpp/jkOsnrR8ZgdX+c
         tUC+6XvUpOclupaa0wYKHcgJZTmNbZ1pxkgPCS/wJ7SS/F6mbfMllT37S+UrKXGs6pBT
         GRuQX+Ginw7JaIoUR03lWznn4SufCr//Vi+QN348q2HJFvFs97mLpOhxT+ohIAOOkhap
         2D9Q==
X-Gm-Message-State: AOAM533iyo1w/LgtI4grPyPOZCdbhdp6UrRZjd5h7xLBp4L5ra5wLhej
        pKTzIpdfi2MqLfXFh1Y2itHBFgzlfUg=
X-Google-Smtp-Source: ABdhPJwi2VWKbbHODMqEKqaAx8ChxXM/XWmpw6QL63US43K9r7JnqHOZLcU4Ke/21G5Z7UipW9n8cQ==
X-Received: by 2002:a63:1a55:: with SMTP id a21mr21082158pgm.158.1629505259098;
        Fri, 20 Aug 2021 17:20:59 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id y27sm1705815pfa.29.2021.08.20.17.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:58 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 15/22] samples: bpf: Convert xdp_redirect_kern.o to XDP samples helper
Date:   Sat, 21 Aug 2021 05:50:03 +0530
Message-Id: <20210821002010.845777-16-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We moved swap_src_dst_mac to xdp_sample.bpf.h to be shared with other
potential users, so drop it while moving code to the new file.
Also, consistently use SEC("xdp") naming instead.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile            |  5 +-
 samples/bpf/xdp_redirect.bpf.c  | 49 ++++++++++++++++++
 samples/bpf/xdp_redirect_kern.c | 90 ---------------------------------
 3 files changed, 52 insertions(+), 92 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect.bpf.c
 delete mode 100644 samples/bpf/xdp_redirect_kern.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 479778439f5e..0b94a6acb348 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -163,7 +163,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_kern.o
 always-y += xdp_redirect_map_kern.o
 always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
@@ -356,6 +355,7 @@ endef
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
+$(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
 
 $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/xdp_sample_shared.h
@@ -366,9 +366,10 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
+xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
diff --git a/samples/bpf/xdp_redirect.bpf.c b/samples/bpf/xdp_redirect.bpf.c
new file mode 100644
index 000000000000..7c02bacfe96b
--- /dev/null
+++ b/samples/bpf/xdp_redirect.bpf.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016 John Fastabend <john.r.fastabend@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+#include "vmlinux.h"
+#include "xdp_sample.bpf.h"
+#include "xdp_sample_shared.h"
+
+const volatile int ifindex_out;
+
+SEC("xdp")
+int xdp_redirect_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct ethhdr *eth = data;
+	struct datarec *rec;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	rec = bpf_map_lookup_elem(&rx_cnt, &key);
+	if (!rec)
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
+
+	swap_src_dst_mac(data);
+	return bpf_redirect(ifindex_out, 0);
+}
+
+/* Redirect require an XDP bpf_prog loaded on the TX device */
+SEC("xdp")
+int xdp_redirect_dummy_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_kern.c b/samples/bpf/xdp_redirect_kern.c
deleted file mode 100644
index d26ec3aa215e..000000000000
--- a/samples/bpf/xdp_redirect_kern.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/* Copyright (c) 2016 John Fastabend <john.r.fastabend@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- */
-#define KBUILD_MODNAME "foo"
-#include <uapi/linux/bpf.h>
-#include <linux/in.h>
-#include <linux/if_ether.h>
-#include <linux/if_packet.h>
-#include <linux/if_vlan.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <bpf/bpf_helpers.h>
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__type(key, int);
-	__type(value, int);
-	__uint(max_entries, 1);
-} tx_port SEC(".maps");
-
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, long);
-	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
-
-static void swap_src_dst_mac(void *data)
-{
-	unsigned short *p = data;
-	unsigned short dst[3];
-
-	dst[0] = p[0];
-	dst[1] = p[1];
-	dst[2] = p[2];
-	p[0] = p[3];
-	p[1] = p[4];
-	p[2] = p[5];
-	p[3] = dst[0];
-	p[4] = dst[1];
-	p[5] = dst[2];
-}
-
-SEC("xdp_redirect")
-int xdp_redirect_prog(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	int rc = XDP_DROP;
-	int *ifindex, port = 0;
-	long *value;
-	u32 key = 0;
-	u64 nh_off;
-
-	nh_off = sizeof(*eth);
-	if (data + nh_off > data_end)
-		return rc;
-
-	ifindex = bpf_map_lookup_elem(&tx_port, &port);
-	if (!ifindex)
-		return rc;
-
-	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
-		*value += 1;
-
-	swap_src_dst_mac(data);
-	return bpf_redirect(*ifindex, 0);
-}
-
-/* Redirect require an XDP bpf_prog loaded on the TX device */
-SEC("xdp_redirect_dummy")
-int xdp_redirect_dummy_prog(struct xdp_md *ctx)
-{
-	return XDP_PASS;
-}
-
-char _license[] SEC("license") = "GPL";
-- 
2.33.0

