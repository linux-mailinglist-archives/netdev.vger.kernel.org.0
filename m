Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A9E41D041
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347774AbhI3ABT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346558AbhI3ABQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:16 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574A4C061768;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q23so3347466pfs.9;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BaH7sQI3I6EwdpTIp5maXR5ac1Z0lm0IijH03KT+Y4M=;
        b=T5lZwlqJ5Mu00JdxYmFtpbzF9KNOLalqGsd025i7xeQAQG9pfvMXu+glLWqmZ6fET8
         O6acMSDS8Rc9+gx0zPU2fJupWzX6p93cIh8y4sheQiYxx2LMpIllKV5S3OwKz/+yAz4N
         Zydy1sIPjyoRyfTQMXe1HtUGGhiaF0GIbPz1Hu3XR+STFo5HyXCjt9vsQ/nC+Q2qmGoj
         fjRfxoNafS8PZJpitMkTXaC2/Ogp6k+skc66/OEWME2F1lDrauiBksWfGIMxffupUosn
         0OrgaHFyV32veLTSb1Xe273lVBSb5c4heSu4IfEvac96lMMmkfb13VekEnN95as5m66f
         YGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BaH7sQI3I6EwdpTIp5maXR5ac1Z0lm0IijH03KT+Y4M=;
        b=4yTY8YzhA+XDwWEHZYDy66ADjlXxb10aaaQ8dcs3+/DrR7u2c54/HUjqXTbnvBCWMe
         a93eSanw/hsbDHveFDYz3s4vPH9vdJWKNMAm4FtMVpzUZc4Sw43gkFheJZHoT7aZ3BMW
         cyq8c5ik0ceDQgjktqMQuYx44kBH42tykyJJXu1prZUZdUW5Pvwlsc/FrS0nRhL1siCe
         o3Dbe849LMkt/bkZEq7YfBE/DEvSWP7As29zMy+NZ/Gv2dTF750LjLheclwka0WYOAOU
         GE9k4cHfZP2M96kLO0ZiY4TsokFBy6VM6RrYP66i9TX6GcYDVgajJzJMvJUPCaM1LStg
         +fWg==
X-Gm-Message-State: AOAM531u9EG2wur6ZYlG/dtmx/uGjdjKmZQooXao4o5+8zCYm0N50ltV
        CKpJyIgV8uk/fi2OwCWHdShBLUUudz4r
X-Google-Smtp-Source: ABdhPJycwD45Js6PhKN7XkvyBcVeV7lHuKvL7KN7mGPUDv5L+tGCG/1OQ8FLcEuKnh7chO0b9mYFdQ==
X-Received: by 2002:a63:1d58:: with SMTP id d24mr2322328pgm.316.1632959973172;
        Wed, 29 Sep 2021 16:59:33 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:32 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 01/13] bpf: Add machinery to register map tracing hooks
Date:   Wed, 29 Sep 2021 23:58:58 +0000
Message-Id: <20210929235910.1765396-2-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Maps may be traced in two ways (so far): after a key-only operation
s.a. a deletion, and after a key-value operation s.a. an update. Each
type is identified by a tracing type.

In order to reject invalid map tracing programs at load time, we export
a function for each tracing type. Programs include this function's name
or BTF ID when loading. The verifier will check that the traced
function is registered for map tracing and that the program has the
right arguments.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 include/linux/bpf.h      | 12 ++++++++++++
 include/uapi/linux/bpf.h |  9 +++++++++
 kernel/bpf/Makefile      |  1 +
 kernel/bpf/map_trace.c   | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)
 create mode 100644 kernel/bpf/map_trace.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 19735d59230a..dad62d5571c9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1510,6 +1510,17 @@ struct bpf_iter_reg {
 	const struct bpf_iter_seq_info *seq_info;
 };
 
+#define BPF_MAP_TRACE_FUNC_SYM(trace_type) bpf_map_trace__ ## trace_type
+#define DEFINE_BPF_MAP_TRACE_FUNC(trace_type, args...)	\
+	extern int BPF_MAP_TRACE_FUNC_SYM(trace_type)(args);	\
+	int __init BPF_MAP_TRACE_FUNC_SYM(trace_type)(args)	\
+	{ return 0; }
+
+struct bpf_map_trace_reg {
+	const char *target;
+	enum bpf_map_trace_type trace_type;
+};
+
 struct bpf_iter_meta {
 	__bpf_md_ptr(struct seq_file *, seq);
 	u64 session_id;
@@ -1528,6 +1539,7 @@ void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 const struct bpf_func_proto *
 bpf_iter_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
+int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info);
 int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr, struct bpf_prog *prog);
 int bpf_iter_new_fd(struct bpf_link *link);
 bool bpf_link_is_iter(struct bpf_link *link);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..17e8f4113369 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -93,6 +93,15 @@ union bpf_iter_link_info {
 	} map;
 };
 
+enum bpf_map_trace_type {
+	BPF_MAP_TRACE_UPDATE_ELEM = 0,
+	BPF_MAP_TRACE_DELETE_ELEM = 1,
+
+	MAX_BPF_MAP_TRACE_TYPE,
+};
+
+#define BPF_MAP_TRACE_FUNC(trace_type) "bpf_map_trace__" #trace_type
+
 /* BPF syscall commands, see bpf(2) man-page for more details. */
 /**
  * DOC: eBPF Syscall Preamble
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 7f33098ca63f..34eab32e0d9d 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
 obj-$(CONFIG_BPF_PRELOAD) += preload/
+obj-$(CONFIG_BPF_SYSCALL) += map_trace.o
diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
new file mode 100644
index 000000000000..d8f829535f7e
--- /dev/null
+++ b/kernel/bpf/map_trace.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Google */
+
+#include <linux/filter.h>
+#include <linux/bpf.h>
+
+struct bpf_map_trace_target_info {
+	struct list_head list;
+	const struct bpf_map_trace_reg *reg_info;
+	u32 btf_id;
+};
+
+static struct list_head targets = LIST_HEAD_INIT(targets);
+static DEFINE_MUTEX(targets_mutex);
+
+int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info)
+{
+	struct bpf_map_trace_target_info *tinfo;
+
+	tinfo = kmalloc(sizeof(*tinfo), GFP_KERNEL);
+	if (!tinfo)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&tinfo->list);
+	tinfo->reg_info = reg_info;
+	tinfo->btf_id = 0;
+
+	mutex_lock(&targets_mutex);
+	list_add(&tinfo->list, &targets);
+	mutex_unlock(&targets_mutex);
+
+	return 0;
+}
-- 
2.33.0.685.g46640cef36-goog

