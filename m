Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513712BB005
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 17:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgKTQTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:19:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729476AbgKTQTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 11:19:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605889138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1qFdHiDfMq5vbHWlD1wlHlQF/+7f+rS1e6Pn3Pjw+8=;
        b=WqVymeb1qt5vSxMX5xVywGaTAELotsXjSEuNsEsj6N8jq3b94K3yNCjINlkMLX0AGvaAEW
        +vQ8vwKj515rQERcJSRoAc/lODRjX1eCxuerD97cJ19BmjlUAmIF2a2ZS1NRnIbPSvl8Ub
        +hSA/fqA+s/UcYEzwNnqu12ru+4SwAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-wV_31VasMZ-CDojZ6xpl2w-1; Fri, 20 Nov 2020 11:18:54 -0500
X-MC-Unique: wV_31VasMZ-CDojZ6xpl2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 627D7100A641;
        Fri, 20 Nov 2020 16:18:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 720A75B4A0;
        Fri, 20 Nov 2020 16:18:48 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6CDAF3213845D;
        Fri, 20 Nov 2020 17:18:47 +0100 (CET)
Subject: [PATCH bpf-next V7 8/8] bpf/selftests: activating bpf_check_mtu
 BPF-helper
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Fri, 20 Nov 2020 17:18:47 +0100
Message-ID: <160588912738.2817268.9380466634324530673.stgit@firesoul>
In-Reply-To: <160588903254.2817268.4861837335793475314.stgit@firesoul>
References: <160588903254.2817268.4861837335793475314.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest for BPF-helper bpf_check_mtu(). Making sure
it can be used from both XDP and TC.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |   37 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_check_mtu.c |   33 ++++++++++++++++++
 2 files changed, 70 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c

diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
new file mode 100644
index 000000000000..09b8f986a17b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Red Hat */
+#include <uapi/linux/bpf.h>
+#include <linux/if_link.h>
+#include <test_progs.h>
+
+#include "test_check_mtu.skel.h"
+#define IFINDEX_LO 1
+
+void test_check_mtu_xdp(struct test_check_mtu *skel)
+{
+	int err = 0;
+	int fd;
+
+	fd = bpf_program__fd(skel->progs.xdp_use_helper);
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
+	if (CHECK_FAIL(err))
+		return;
+
+	bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
+}
+
+void test_check_mtu(void)
+{
+	struct test_check_mtu *skel;
+
+	skel = test_check_mtu__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		perror("test_check_mtu__open_and_load");
+		return;
+	}
+
+	if (test__start_subtest("bpf_check_mtu XDP-attach"))
+		test_check_mtu_xdp(skel);
+
+	test_check_mtu__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
new file mode 100644
index 000000000000..ab97ec925a32
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Red Hat */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#include <stddef.h>
+#include <stdint.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("xdp")
+int xdp_use_helper(struct xdp_md *ctx)
+{
+	uint32_t mtu_len = 0;
+	int delta = 20;
+
+	if (bpf_check_mtu(ctx, 0, &mtu_len, delta, 0)) {
+		return XDP_ABORTED;
+	}
+	return XDP_PASS;
+}
+
+SEC("classifier")
+int tc_use_helper(struct __sk_buff *ctx)
+{
+	uint32_t mtu_len = 0;
+	int delta = -20;
+
+	if (bpf_check_mtu(ctx, 0, &mtu_len, delta, 0)) {
+		return BPF_DROP;
+	}
+	return BPF_OK;
+}


