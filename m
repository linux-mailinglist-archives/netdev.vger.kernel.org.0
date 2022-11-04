Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B48618EF7
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiKDD1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiKDDZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:25:55 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40838635E
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:36 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q6-20020a170902dac600b001873ef77938so2612876plx.18
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YbRm3I0sewWtsZIHwhErDFMz3x0ncMPhKVqkK3e/Kzk=;
        b=F/j+r+DQWgWU+H64J7k+Tlw9APbvQO6yhhwJkgncOiWnKlmmd7ff3U0fDMWcrIM6eA
         Rrc6+HsRPDXVFkN/1Ol4jOSGhYk5Cu9FHGQdp5u2VJzi/qceoBkwLigm8V1aSgsBQSyH
         t2yGCOTZY8ZguLjd7JLXNalfPBqujqIfzSAqmR9dudUMpphE2D4hoDFPrK6M3xMipjdv
         kqgjtByufledR5lP2KjsFzIIRNsUFCQbD0UXrW6ZohJ2eQLFOicozTT+r4+rEsHhQ2a5
         PDPpXcDvhQeczI4vZMBENr+pBOUlgphRkuSIuEzsnnUi4HLZf13zUZMJMQtvH7HcspTF
         P9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YbRm3I0sewWtsZIHwhErDFMz3x0ncMPhKVqkK3e/Kzk=;
        b=Iw+GbJ9Ie22BLWXb1yJuStrheeIwV7SxLZ8+eg//bBtvaJcLc/gaQqhxU8rR8socJq
         IOb5C8JVlDaAi8dgtbqo17Mi+WcCYrzo/SvwAFUq+OBtPlDMzWmnLjw6nVDab/gjYbHM
         7n8ufHhePLyLB3LST66qQmpA8FvR/to4LePWU5fbVZUFNgnLfQjVA5wZPAOSWOwD1o/I
         uHD8/Ry1Uqh9+Iqyw7Sie1C2OwAwfvZomiEu3mDcGWTdkPz/3MaLQb0tWeskvV/CYnEf
         UV3G485+6kw3DbNa3rXbYyqv4onxc1w1nWJODMFVtA0aMRWvePvBvccOGXy9eCHc0uOk
         5BYQ==
X-Gm-Message-State: ACrzQf047R10RtETFP+94tqku/lUVbm856fVQ3pr0sI+sZ2gmA62sylp
        /ZjYuX3bzQRiF1Dl6XiJhF1NA/s=
X-Google-Smtp-Source: AMsMyM7Z6bdvew+CNuqL+zRO4xlM9NhZdHxVH3wfWepJiyS61542z1snHXjcv2qO5a2qvaaQV4BBXL8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:9421:0:b0:56b:b2a8:6822 with SMTP id
 y1-20020aa79421000000b0056bb2a86822mr33149365pfo.86.1667532335655; Thu, 03
 Nov 2022 20:25:35 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:19 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-2-sdf@google.com>
Subject: [RFC bpf-next v2 01/14] bpf: Introduce bpf_patch
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
 include/linux/bpf_patch.h | 27 +++++++++++++++++++++
 kernel/bpf/Makefile       |  2 +-
 kernel/bpf/bpf_patch.c    | 51 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/bpf_patch.h
 create mode 100644 kernel/bpf/bpf_patch.c

diff --git a/include/linux/bpf_patch.h b/include/linux/bpf_patch.h
new file mode 100644
index 000000000000..81ff738eef8d
--- /dev/null
+++ b/include/linux/bpf_patch.h
@@ -0,0 +1,27 @@
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
index 000000000000..82a10bf5624a
--- /dev/null
+++ b/kernel/bpf/bpf_patch.c
@@ -0,0 +1,51 @@
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
-- 
2.38.1.431.g37b22c650d-goog

