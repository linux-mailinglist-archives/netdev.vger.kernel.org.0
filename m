Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3F411E982
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbfLMRvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:51:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45088 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbfLMRvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:51:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id b9so156305pgk.12;
        Fri, 13 Dec 2019 09:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6SeiTsvAEy8VQxsdRHDPpYhwUBoXZ86ZAU9B9WJ43Dg=;
        b=mGePQ1s4HECk3rLvU4Fp0AqJBpRI1IfJOgN6jUC6pvb6f8l4QsOFZDvESt2bpj6lwk
         EcnMkaM5uVm1yFs66U/JFcPM9GhVvQSn2x7/sqPc1eow1DZ8cMRvyK1SLloxQyiwLj7r
         isNpBwrqYuLbDuW+8dFnomfNy+B8GKRa+dOEcLduPhWQO5TU2H1SoU9n9YuJwK/eYy97
         cdGiykjdrnKMcbTSz7enBnIXKlzCEiKwKzKVr+5M06M17w9xZ+SXyN1c23iSMps/JqiT
         kr6irjKkJDCs8wS9r7yA6jpkiXDfNCtLh7k1y42wWTpd3hFRg3DKH6dtzmaa8bGpqG2y
         wXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6SeiTsvAEy8VQxsdRHDPpYhwUBoXZ86ZAU9B9WJ43Dg=;
        b=Ik21MT2brCjMBjtM4OGIa/2ABavEQ9MpduFgqWCKOMm8fVgFV0yWA5W+upfs2tikdO
         uisHXcUr4rkDtiFvNu3GTrGdj0L0c5nSXPhAIO5DUr3kkT37JpsHccwtwpvNwnT+m2hD
         rVOQwaRI7sHspm1iNXu28f7zQkcXMoW4HFe/lWpf3Oq1bzim/CubA0dlkEnTXGOY3jfi
         oI7SSfB/drBacEqToRmGFyKkyiv2uPoiWYq4nwMTpVCA8/+Q0JMPjYVxj6IWLnWkc7uo
         B8EGUVa08F0dqAavq1M9AXdBnT8O6jANzJN2GR1vVTGF2njtwje0k1zVL3O/mB7FwdZj
         vulA==
X-Gm-Message-State: APjAAAVbcFuaZgeh8/rXilzLtQKkbWkZTUlVcoEh+WN12ZtKOj+VySkB
        CC8ZDZmSwLMGpKXLo+a/BPa7YCNMU5bZNA==
X-Google-Smtp-Source: APXvYqzrblG5FSP5ZS+DeuisqhrPY60lux/ez2dqCyfOJclxt0zsAl57QvexKvkTeREqlrb5hhqRiA==
X-Received: by 2002:a63:c207:: with SMTP id b7mr708479pgd.422.1576259504588;
        Fri, 13 Dec 2019 09:51:44 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id q12sm12166366pfh.158.2019.12.13.09.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 09:51:44 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v5 5/6] selftests: bpf: add xdp_perf test
Date:   Fri, 13 Dec 2019 18:51:11 +0100
Message-Id: <20191213175112.30208-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213175112.30208-1-bjorn.topel@gmail.com>
References: <20191213175112.30208-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The xdp_perf is a dummy XDP test, only used to measure the the cost of
jumping into a naive XDP program one million times.

To build and run the program:
  $ cd tools/testing/selftests/bpf
  $ make
  $ ./test_progs -v -t xdp_perf

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 .../selftests/bpf/prog_tests/xdp_perf.c       | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_perf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_perf.c b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
new file mode 100644
index 000000000000..7185bee16fe4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+void test_xdp_perf(void)
+{
+	const char *file = "./xdp_dummy.o";
+	__u32 duration, retval, size;
+	struct bpf_object *obj;
+	char in[128], out[128];
+	int err, prog_fd;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	err = bpf_prog_test_run(prog_fd, 1000000, &in[0], 128,
+				out, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_PASS || size != 128,
+	      "xdp-perf",
+	      "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	bpf_object__close(obj);
+}
-- 
2.20.1

