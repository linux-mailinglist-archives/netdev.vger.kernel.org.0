Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E881264B6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLSO3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:29:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58377 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726879AbfLSO3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:29:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576765780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKuhuDZ28lcg6ktC/LRHyhMwfrATZ70bwbds9FUsBUk=;
        b=LQzALclgabJBB6XN7pgnjZ96iuMYIx9cufzhQr9VHB9fz4ybFamGdBc7VdsD2dYPey9xCL
        gAGgSt+/vDUHLKF/muRpSOgCBPjD40DQRO3RH2Evf6hhDb/og8HwfB6HtBPL1ZQYeMFFdY
        Gl8NPvVSTSz/l7d/jmquX7zjwiyRfhI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-tvrSb4sBNzuNopM-lujuEA-1; Thu, 19 Dec 2019 09:29:37 -0500
X-MC-Unique: tvrSb4sBNzuNopM-lujuEA-1
Received: by mail-lf1-f71.google.com with SMTP id t3so580609lfp.15
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 06:29:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UKuhuDZ28lcg6ktC/LRHyhMwfrATZ70bwbds9FUsBUk=;
        b=DhcvSsyszhBIcLuNSiOCN9X8bSn7KuRSxncFh/AAyp8/mSa4GoAU1/rFvGk1X+fIJj
         /AaNs1ScOKfWfZ27fOG0l6BcQ0dc84JKGkXbYMdg0lev9KjUlluPNb7CCpT6IsVt+gzt
         7pOqnHieRCeqwML8SqJUZ72+AlcUCTFxuhEVQtKfmXDgS7fGoV/nPONT0wQz69I9ElRe
         5nIrwVZqjrvGta8BN1j7oenhRqHDf20OoAIafld+nRoTYvVhs/EFi/2n57OhJwciCOWQ
         fZvjDKHMwmd8ZgzBbhPSGsSvTxgB0dJfFsYnNmwExkQWQkhirzpR2xEgqx5DHqBcQaYz
         eJfw==
X-Gm-Message-State: APjAAAXWz1CD8rEaI0FPH+LdBb13gK4JguKRgNDUla+FIx6sTp2lgYby
        c9VK4iC9tv+VFpTtUwd/9hEzJFky/u39S/thczM5+YbH/eiljTvjHkqSb88b4F3xsJXhOi+2KUB
        PnWL6/7C5/u3Hx1sl
X-Received: by 2002:a2e:b0db:: with SMTP id g27mr6418233ljl.74.1576765775472;
        Thu, 19 Dec 2019 06:29:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNDBp/rL2FrdoZdx7dGqWj4YiuJc4YV5pg+Bpobb9ccT2fGoE6MPT9y7qIMewiLJidU4AzOw==
X-Received: by 2002:a2e:b0db:: with SMTP id g27mr6418205ljl.74.1576765775262;
        Thu, 19 Dec 2019 06:29:35 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s18sm3625170ljj.36.2019.12.19.06.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 06:29:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D8D7818096A; Thu, 19 Dec 2019 15:29:33 +0100 (CET)
Subject: [PATCH RFC bpf-next 3/3] selftests/bpf: Add selftest for XDP
 multiprogs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 19 Dec 2019 15:29:33 +0100
Message-ID: <157676577376.957277.10941753215180409553.stgit@toke.dk>
In-Reply-To: <157676577049.957277.3346427306600998172.stgit@toke.dk>
References: <157676577049.957277.3346427306600998172.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a simple selftest that combines two XDP programs through a third
dispatcher, exercising the libbpf function externals handling.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/xdp_multiprog.c       |   52 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/xdp_drop.c       |   13 +++++
 tools/testing/selftests/bpf/progs/xdp_multiprog.c  |   26 ++++++++++
 3 files changed, 91 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_multiprog.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_drop.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_multiprog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_multiprog.c b/tools/testing/selftests/bpf/prog_tests/xdp_multiprog.c
new file mode 100644
index 000000000000..40a743437222
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_multiprog.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+void test_xdp_multiprog(void)
+{
+	const char *file_dispatcher = "./xdp_multiprog.o";
+	const char *file_drop = "./xdp_drop.o";
+	const char *file_pass = "./xdp_dummy.o";
+	struct bpf_object *obj, *obj_drop, *obj_pass;
+	int err;
+
+
+	obj = bpf_object__open_file(file_dispatcher, NULL);
+	err = libbpf_get_error(obj);
+	if (CHECK_FAIL(err))
+		return;
+
+	obj_drop = bpf_object__open_file(file_drop, NULL);
+	err = libbpf_get_error(obj_drop);
+	if (CHECK_FAIL(err))
+		goto out_obj;
+
+	obj_pass = bpf_object__open_file(file_pass, NULL);
+	err = libbpf_get_error(obj_pass);
+	if (CHECK_FAIL(err))
+		goto out_drop;
+
+        err = bpf_object__load(obj_drop);
+        err = err ?: bpf_object__load(obj_pass);
+
+        if (CHECK_FAIL(err))
+                goto out;
+
+	struct bpf_extern_call_tgt tgts[] =
+		{
+		 {.name = "prog1", .tgt_prog_name = "xdp_dummy_prog", .tgt_obj = obj_pass},
+		 {.name = "prog2", .tgt_prog_name = "xdp_drop_prog", .tgt_obj = obj_drop},
+		};
+	struct bpf_extern_calls calls = {.num_tgts = 2, .tgts = tgts };
+
+	DECLARE_LIBBPF_OPTS(bpf_object_load_opts, load_opts,
+			    .ext_calls = &calls);
+
+	err = bpf_object__load2(obj, &load_opts);
+        CHECK_FAIL(err);
+out:
+	bpf_object__close(obj_pass);
+out_drop:
+	bpf_object__close(obj_drop);
+out_obj:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/xdp_drop.c b/tools/testing/selftests/bpf/progs/xdp_drop.c
new file mode 100644
index 000000000000..10e415e49564
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_drop.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define KBUILD_MODNAME "xdp_drop"
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+SEC("xdp_drop")
+int xdp_drop_prog(struct xdp_md *ctx)
+{
+	return XDP_DROP;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/xdp_multiprog.c b/tools/testing/selftests/bpf/progs/xdp_multiprog.c
new file mode 100644
index 000000000000..ef5ba8172038
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_multiprog.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define KBUILD_MODNAME "xdp_multiprog"
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+extern int prog1(struct xdp_md *ctx);
+extern int prog2(struct xdp_md *ctx);
+
+SEC("xdp_test")
+int xdp_main(struct xdp_md *ctx)
+{
+        int ret;
+
+        ret = prog1(ctx);
+        if (ret != XDP_PASS)
+                goto out;
+
+        ret = prog2(ctx);
+        if (ret != XDP_DROP)
+                goto out;
+out:
+        return ret;
+}
+
+char _license[] SEC("license") = "GPL";

