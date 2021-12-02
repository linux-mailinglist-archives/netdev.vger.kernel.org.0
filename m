Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D207465A5E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 01:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353968AbhLBAHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 19:07:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354093AbhLBAHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 19:07:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638403447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HeYVFn3C/kHLoloeDuy+DYyyuZygKIHXuCGMV5j00so=;
        b=dsZhx2YBoSsLcfeXi/O565XNTZxvUKTck3dsV2e4ok1DziSYUldq21viULmssHnMV4HRVL
        wQYYlIhzWRwkqOJ261RqbeiNNZoYDVUHVQr7cHKkHi75KE8AMGmuV9Q8UswNY2o2DndRcC
        65s674n7JjKkC3/D0xaNsEiYCfiTjIU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-Ww4ItmQtN_WCjyI1B0_OCQ-1; Wed, 01 Dec 2021 19:04:06 -0500
X-MC-Unique: Ww4ItmQtN_WCjyI1B0_OCQ-1
Received: by mail-ed1-f71.google.com with SMTP id a3-20020a05640213c300b003e7d12bb925so21948971edx.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:04:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HeYVFn3C/kHLoloeDuy+DYyyuZygKIHXuCGMV5j00so=;
        b=SyZsbBEDO0VypV48y2dBloXVEFiGxoUa+xARELdTVFt4Bx1svIFYsHghgpLhevVaVT
         9bbja85n0aONIz4EccofssBOtfg7PYyRVxwekfToWHSN9sP/5jXXHNfUI5GTUnS3gwsD
         9GoGZguBvRC09bes7JVecG0B3b/EMH2qG6rI2mbQdFHha9NQA7niczXTS0jwVAolWPCa
         0Gycp2otiA9CJjYSUEcpKP3V5jJgtR/cmKSU1jbLD7XZlkLoEGpzTCHwyT6/UURiFMrZ
         v0P+u0Qr9QX9VUelG3qjmvMSlqxbehZrYmot+mKj76wQzZ3mtE5DTgK1W5wNH7Us/PR6
         tYgw==
X-Gm-Message-State: AOAM531O95UlmnZ8tiZlqYtKH3nZLEe+oXef57HoTDBaVm8eFaFaq1/z
        dd63M6h96aq+c1EA28KFnU2O07UfK0f+HnYWxuVVsZSiZ44LqeyjPTHcUhj13O+k9o827C8NRyt
        1nS/9v1OPUkPy9Fab
X-Received: by 2002:a05:6402:3551:: with SMTP id f17mr12489395edd.129.1638403445484;
        Wed, 01 Dec 2021 16:04:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeJBPV+unSKdbOtAmXJoB0/EgM0fv5RUBXQLvMLIVG5oNj32Uxu53MfmcDbzk7sEbsJk/8Mw==
X-Received: by 2002:a05:6402:3551:: with SMTP id f17mr12489354edd.129.1638403445214;
        Wed, 01 Dec 2021 16:04:05 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m25sm739413edj.80.2021.12.01.16.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 16:04:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 126401802A0; Thu,  2 Dec 2021 01:04:04 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 7/8] selftests/bpf: Add selftest for XDP_REDIRECT in bpf_prog_run()
Date:   Thu,  2 Dec 2021 01:02:28 +0100
Message-Id: <20211202000232.380824-8-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211202000232.380824-1-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a selftest for the XDP_REDIRECT facility in bpf_prog_run, that
redirects packets into a veth and counts them using an XDP program on the
other side of the veth pair.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../bpf/prog_tests/xdp_do_redirect.c          | 74 +++++++++++++++++++
 .../bpf/progs/test_xdp_do_redirect.c          | 34 +++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
new file mode 100644
index 000000000000..c2effcf076a6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <net/if.h>
+#include "test_xdp_do_redirect.skel.h"
+
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			goto fail;				\
+	})
+
+#define NUM_PKTS 10
+void test_xdp_do_redirect(void)
+{
+	struct test_xdp_do_redirect *skel = NULL;
+	struct ipv6_packet data = pkt_v6;
+	struct xdp_md ctx_in = { .data_end = sizeof(data) };
+	__u8 dst_mac[ETH_ALEN] = {0x00, 0x11, 0x22, 0x33, 0x44, 0x55};
+	__u8 src_mac[ETH_ALEN] = {0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+			    .data_in = &data,
+			    .data_size_in = sizeof(data),
+			    .ctx_in = &ctx_in,
+			    .ctx_size_in = sizeof(ctx_in),
+			    .flags = BPF_F_TEST_XDP_DO_REDIRECT,
+			    .repeat = NUM_PKTS,
+		);
+	int err, prog_fd, ifindex_src, ifindex_dst;
+	struct bpf_link *link;
+
+	memcpy(data.eth.h_dest, dst_mac, ETH_ALEN);
+	memcpy(data.eth.h_source, src_mac, ETH_ALEN);
+
+	skel = test_xdp_do_redirect__open();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	SYS("ip link add veth_src type veth peer name veth_dst");
+	SYS("ip link set dev veth_src up");
+	SYS("ip link set dev veth_dst up");
+
+	ifindex_src = if_nametoindex("veth_src");
+	ifindex_dst = if_nametoindex("veth_dst");
+	if (!ASSERT_NEQ(ifindex_src, 0, "ifindex_src") ||
+	    !ASSERT_NEQ(ifindex_dst, 0, "ifindex_dst"))
+		goto fail;
+
+	memcpy(skel->rodata->expect_dst, dst_mac, ETH_ALEN);
+	skel->rodata->ifindex_out = ifindex_src;
+
+	if (!ASSERT_OK(test_xdp_do_redirect__load(skel), "load"))
+		goto fail;
+
+	link = bpf_program__attach_xdp(skel->progs.xdp_count_pkts, ifindex_dst);
+	if (!ASSERT_OK_PTR(link, "prog_attach"))
+		goto fail;
+	skel->links.xdp_count_pkts = link;
+
+	prog_fd = bpf_program__fd(skel->progs.xdp_redirect_notouch);
+	err = bpf_prog_test_run_opts(prog_fd, &opts);
+	if (!ASSERT_OK(err, "prog_run"))
+		goto fail;
+
+	/* wait for the packets to be flushed */
+	kern_sync_rcu();
+
+	ASSERT_EQ(skel->bss->pkts_seen, NUM_PKTS, "pkt_count");
+fail:
+	system("ip link del dev veth_src");
+	test_xdp_do_redirect__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
new file mode 100644
index 000000000000..254ebf523f37
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define ETH_ALEN 6
+const volatile int ifindex_out;
+const volatile __u8 expect_dst[ETH_ALEN];
+volatile int pkts_seen = 0;
+
+SEC("xdp")
+int xdp_redirect_notouch(struct xdp_md *xdp)
+{
+	return bpf_redirect(ifindex_out, 0);
+}
+
+SEC("xdp")
+int xdp_count_pkts(struct xdp_md *xdp)
+{
+	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(long)xdp->data_end;
+	struct ethhdr *eth = data;
+	int i;
+
+	if (eth + 1 > data_end)
+		return XDP_ABORTED;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		if (expect_dst[i] != eth->h_dest[i])
+			return XDP_ABORTED;
+	pkts_seen++;
+	return XDP_DROP;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.0

