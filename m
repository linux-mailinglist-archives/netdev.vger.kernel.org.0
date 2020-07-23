Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279C322AC04
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 12:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgGWKAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 06:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgGWKAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 06:00:00 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4F5C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 02:59:59 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y18so2929679lfh.11
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 02:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MW3j5LKyLZ9La+Eo3EPLM5dSjg55rwvKjRjtnUGYERg=;
        b=r3Tg8+KHnZ5T5KK3RpM5qeRP3DRBGZXpda+nn6ZAlx/MMyFaUXr/VNMM9Zvu9hT/2V
         d3xK8pBsfqbFC0f5eSxis9gwKGv5DYcCTlKlXpHCVrVhPaEEt46l7+AqAg+c8UEh78ZN
         OJwHJQRjPb2q8S/g2rR68pr0Qd362KUyXvzmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MW3j5LKyLZ9La+Eo3EPLM5dSjg55rwvKjRjtnUGYERg=;
        b=C/2R2Zie+4pnfbjz+EyrjLIfDDLQDtuNPS/SY00Nx6ktiohDuuI5nb/ollZNjQ7yao
         pKiJWoFzvdiB4X588RcJ9xxtlJqJjwiwgqtTxtLQGFhtPD6X87Ge+sn+hriKz+sBDWZa
         sogfn+Zp1kAQZvQxS50RWl9ox2iXqHA+0TA7hfEnXkd2kXB35WExoYy8mZd55nGvdibK
         x/tKZX59z4Mw5HKUfJqV4mC1uMNJzX6vJZDcrR+AfJT7z992/7VdoaPbN2B0s3DOWPJp
         VRdo+uANQMQ2CJI33mV/b/90dAC3I4C81JaVqeqAsaz9RXCZdgH1khqOuyvUgr864/Fs
         6jzA==
X-Gm-Message-State: AOAM530mW1j6wj7uP7ntjepkbAzA3oBhElJ85zKagw8ZCYePxbWCTj2I
        2VcRZB/1MHAGoaKxUiNcJdApKA==
X-Google-Smtp-Source: ABdhPJzEA08SqqZVP5Dqdaa+/08X737GmhX5YH70uykeMn5c+XtcmxeUNTpvQUkYbGfUPjwGFaItrQ==
X-Received: by 2002:a19:4c57:: with SMTP id z84mr1934878lfa.92.1595498397908;
        Thu, 23 Jul 2020 02:59:57 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d13sm2382112lfl.89.2020.07.23.02.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 02:59:57 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf v2 2/2] selftests/bpf: Add test for narrow loads from context at an offset
Date:   Thu, 23 Jul 2020 11:59:53 +0200
Message-Id: <20200723095953.1003302-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200723095953.1003302-1-jakub@cloudflare.com>
References: <20200723095953.1003302-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that narrow loads at various offsets from a context field backed by a
target field that is smaller in size work as expected. That is target field
value is loaded only when the offset is less than the target field size.
While for offsets beyond the target field, the loaded value is zero.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/narrow_load.c    | 84 +++++++++++++++++++
 .../selftests/bpf/progs/test_narrow_load.c    | 43 ++++++++++
 2 files changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/narrow_load.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_narrow_load.c

diff --git a/tools/testing/selftests/bpf/prog_tests/narrow_load.c b/tools/testing/selftests/bpf/prog_tests/narrow_load.c
new file mode 100644
index 000000000000..6d79d722a66d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/narrow_load.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+
+#include "test_progs.h"
+#include "test_narrow_load.skel.h"
+
+static int duration;
+
+void run_sk_reuseport_prog(struct bpf_program *reuseport_prog)
+{
+	static const struct timeval timeo = { .tv_sec = 3 };
+	struct sockaddr_in addr = {
+		.sin_family = AF_INET,
+		.sin_port = 0,
+		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
+	};
+	socklen_t len = sizeof(addr);
+	int err, fd, prog_fd;
+	const int one = 1;
+	char buf = 42;
+	ssize_t n;
+
+	prog_fd = bpf_program__fd(reuseport_prog);
+	if (CHECK(prog_fd < 0, "bpf_program__fd", "errno %d\n", errno))
+		return;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (CHECK(fd < 0, "socket", "errno %d\n", errno))
+		return;
+
+	/* Setup timeouts */
+	err = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(timeo));
+	if (CHECK(err, "setsockopt(SO_RCVTIMEO)", "errno %d\n", errno))
+		goto out_close;
+	err = setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(timeo));
+	if (CHECK(err, "setsockopt(SO_RCVTIMEO)", "errno %d\n", errno))
+		goto out_close;
+
+	/* Setup reuseport prog */
+	err = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
+	if (CHECK(err, "setsockopt(SO_REUSEPORT)", "errno %d\n", errno))
+		goto out_close;
+	err = setsockopt(fd, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+			 &prog_fd, sizeof(prog_fd));
+	if (CHECK(err, "setsockopt(SO_ATTACH_REUEPORT_EBPF)",
+		  "errno %d\n", errno))
+		goto out_close;
+
+	err = bind(fd, (void *)&addr, len);
+	if (CHECK(err, "bind", "errno %d\n", errno))
+		goto out_close;
+	err = getsockname(fd, (void *)&addr, &len);
+	if (CHECK(err, "getsockname", "errno %d\n", errno))
+		goto out_close;
+
+	/* Send a message to itself to trigger reuseport prog */
+	n = sendto(fd, &buf, sizeof(buf), 0, (void *)&addr, len);
+	if (CHECK(n < 1, "sendto", "ret %ld errno %d\n", n, errno))
+		goto out_close;
+	n = recv(fd, &buf, sizeof(buf), 0);
+	if (CHECK(n < 1, "recv", "ret %ld errno %d\n", n, errno))
+		goto out_close;
+
+	/* Pass, reuseport prog didn't drop the packet */
+
+out_close:
+	close(fd);
+}
+
+void test_narrow_load(void)
+{
+	struct test_narrow_load *skel;
+
+	skel = test_narrow_load__open_and_load();
+	if (CHECK(!skel, "skel open_and_load", "failed\n"))
+		return;
+
+	if (test__start_subtest("narrow load byte"))
+		run_sk_reuseport_prog(skel->progs.narrow_load_byte);
+	if (test__start_subtest("narrow load half word"))
+		run_sk_reuseport_prog(skel->progs.narrow_load_half_word);
+
+	test_narrow_load__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_narrow_load.c b/tools/testing/selftests/bpf/progs/test_narrow_load.c
new file mode 100644
index 000000000000..57444720df16
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_narrow_load.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+
+#include <stdint.h>
+
+#include <linux/bpf.h>
+#include <linux/in.h>
+
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "Dual BSD/GPL";
+
+/* Check 1-byte load from 2-byte wide target field */
+SEC("sk_reuseport/narrow_load_byte")
+int narrow_load_byte(struct sk_reuseport_md *ctx)
+{
+	__u8 *byte;
+
+	byte = (__u8 *)&ctx->ip_protocol;
+	if (byte[0] != IPPROTO_UDP)
+		return SK_DROP;
+	if (byte[1] != 0)
+		return SK_DROP;
+	if (byte[2] != 0)
+		return SK_DROP;
+	if (byte[3] != 0)
+		return SK_DROP;
+	return SK_PASS;
+}
+
+/* Check 2-byte load from 2-byte wide target field */
+SEC("sk_reuseport/narrow_load_half_word")
+int narrow_load_half_word(struct sk_reuseport_md *ctx)
+{
+	__u16 *half;
+
+	half = (__u16 *)&ctx->ip_protocol;
+	if (half[0] != IPPROTO_UDP)
+		return SK_DROP;
+	if (half[1] != 0)
+		return SK_DROP;
+	return SK_PASS;
+}
-- 
2.25.4

