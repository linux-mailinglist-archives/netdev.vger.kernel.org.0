Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595F662905F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiKODD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbiKODDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:12 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817CF21BB
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:16 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z125-20020a25c983000000b006dc905e6ccfso12051584ybf.1
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+8IjXRgxBNITPsOwIQKMXDKqWa80/z37oUBtUuQVa0=;
        b=WJ+Gmv5/4g5yFbrp5IctO/4xjTqfAnV73tfMi/F7yI3/SCZP1J+a2RMInH/6OsyyIe
         Rdh8XJsAMlXQJjWlonNRg0k7V+GccC8NlXTIEmWG3jf56Pt3ZbbxrzHH0YcvjzHJkREM
         kLMNnb+jiEbjPOkbR6ScJ5b2r80deVxSNTiYuKnzEu+PY/cPtUaNNQM5ZfOp+b9v+xX5
         i/CVxyDT7vB9DCXEp/+Yj5ZkI1gjNKMs/mx3nxe7+J5CT7OCcwheY1XTKmVgMyOw21Ml
         MeHMnSYXDAO7WoztOY0aKuxmltR6B8pm3cqNEc9eqdd1+Wvtzy5Sj2XfOF6P2kyBi2VL
         TXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+8IjXRgxBNITPsOwIQKMXDKqWa80/z37oUBtUuQVa0=;
        b=kv4hyTNyw0Iny2Ub2vQ8i7lMsx39wDTUq1BLQTc4UAlQkT3km4jBK48EsWsm4YYf/w
         9pTrpr1yO9xPebizgfE4TE8ltdcag/7IgLLVh71urwVhDt7mY6xdzr0JA43ujGjOrNlp
         W2w3bkzgZSnOTesZs18gHGtJ+ygWdfEFotLwZoNaRep1Smw/dNR7m9uDgHeKT68KGrZI
         us27Ip9OSpgkhUvCcZoqxXQ17CcI7QC3F/mLsA8EWc52f7gIEC7Ck6A5Xpvpbk/JfMiD
         Pa6XXL8wqwm8aTk3MeJ2FbTKtxjrXl4RktW8hVixfSkAE0ZJzW7ksqFxLBmghJ4GCKPs
         rTGg==
X-Gm-Message-State: ANoB5pn5Mbtm6n6yUvGtBxb4SdKBm0q8LeA11xf37geySfyHSFaT5uSW
        TcIGgj/HW2QFtE7wfO3WAY4ZgNk=
X-Google-Smtp-Source: AA0mqf49JR+xywOcvNrrM2mX6vAJ2aTg+01p+IZYDcOS32Yl5zwEF1L6Kv8p/1IcRroXqOIzIsYPkrk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:3801:0:b0:6cf:ef46:e780 with SMTP id
 f1-20020a253801000000b006cfef46e780mr15073287yba.644.1668481335532; Mon, 14
 Nov 2022 19:02:15 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:02:01 -0800
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
Mime-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-3-sdf@google.com>
Subject: [PATCH bpf-next 02/11] bpf: Introduce bpf_patch
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple abstraction around a series of instructions that transparently
handles resizing.

Currently, we have insn_buf[16] in convert_ctx_accesses which might
not be enough for xdp kfuncs.

If we find this abstraction helpful, we might convert existing
insn_buf[16] to it in the future.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf_patch.h | 29 +++++++++++++++
 kernel/bpf/Makefile       |  2 +-
 kernel/bpf/bpf_patch.c    | 77 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/bpf_patch.h
 create mode 100644 kernel/bpf/bpf_patch.c

diff --git a/include/linux/bpf_patch.h b/include/linux/bpf_patch.h
new file mode 100644
index 000000000000..359c165ad68b
--- /dev/null
+++ b/include/linux/bpf_patch.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_BPF_PATCH_H
+#define _LINUX_BPF_PATCH_H 1
+
+#include <linux/bpf.h>
+
+struct bpf_patch {
+	struct bpf_insn *insn;
+	size_t capacity;
+	size_t len;
+	int err;
+};
+
+void bpf_patch_free(struct bpf_patch *patch);
+size_t bpf_patch_len(const struct bpf_patch *patch);
+int bpf_patch_err(const struct bpf_patch *patch);
+void __bpf_patch_append(struct bpf_patch *patch, struct bpf_insn insn);
+struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch);
+void bpf_patch_resolve_jmp(struct bpf_patch *patch);
+u32 bpf_patch_magles_registers(const struct bpf_patch *patch);
+
+#define bpf_patch_append(patch, ...) ({ \
+	struct bpf_insn insn[] = { __VA_ARGS__ }; \
+	int i; \
+	for (i = 0; i < ARRAY_SIZE(insn); i++) \
+		__bpf_patch_append(patch, insn[i]); \
+})
+
+#endif
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 3a12e6b400a2..5724f36292a5 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
 obj-$(CONFIG_BPF_JIT) += trampoline.o
-obj-$(CONFIG_BPF_SYSCALL) += btf.o memalloc.o
+obj-$(CONFIG_BPF_SYSCALL) += btf.o memalloc.o bpf_patch.o
 obj-$(CONFIG_BPF_JIT) += dispatcher.o
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
diff --git a/kernel/bpf/bpf_patch.c b/kernel/bpf/bpf_patch.c
new file mode 100644
index 000000000000..eb768398fd8f
--- /dev/null
+++ b/kernel/bpf/bpf_patch.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bpf_patch.h>
+
+void bpf_patch_free(struct bpf_patch *patch)
+{
+	kfree(patch->insn);
+}
+
+size_t bpf_patch_len(const struct bpf_patch *patch)
+{
+	return patch->len;
+}
+
+int bpf_patch_err(const struct bpf_patch *patch)
+{
+	return patch->err;
+}
+
+void __bpf_patch_append(struct bpf_patch *patch, struct bpf_insn insn)
+{
+	void *arr;
+
+	if (patch->err)
+		return;
+
+	if (patch->len + 1 > patch->capacity) {
+		if (!patch->capacity)
+			patch->capacity = 16;
+		else
+			patch->capacity *= 2;
+
+		arr = krealloc_array(patch->insn, patch->capacity, sizeof(insn), GFP_KERNEL);
+		if (!arr) {
+			patch->err = -ENOMEM;
+			kfree(patch->insn);
+			return;
+		}
+
+		patch->insn = arr;
+		patch->capacity *= 2;
+	}
+
+	patch->insn[patch->len++] = insn;
+}
+EXPORT_SYMBOL(__bpf_patch_append);
+
+struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch)
+{
+	return patch->insn;
+}
+
+void bpf_patch_resolve_jmp(struct bpf_patch *patch)
+{
+	int i;
+
+	for (i = 0; i < patch->len; i++) {
+		if (BPF_CLASS(patch->insn[i].code) != BPF_JMP)
+			continue;
+
+		if (patch->insn[i].off != S16_MAX)
+			continue;
+
+		patch->insn[i].off = patch->len - i - 1;
+	}
+}
+
+u32 bpf_patch_magles_registers(const struct bpf_patch *patch)
+{
+	u32 mask = 0;
+	int i;
+
+	for (i = 0; i < patch->len; i++)
+		mask |= 1 << patch->insn[i].dst_reg;
+
+	return mask;
+}
-- 
2.38.1.431.g37b22c650d-goog

