Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73BB47156A
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhLKSnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:43:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231776AbhLKSnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:43:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639248213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HeYVFn3C/kHLoloeDuy+DYyyuZygKIHXuCGMV5j00so=;
        b=geGTyEphYTeL/svx9gTKE03sJ6t87KYf8oK3Bz09WOposa8O3qG9+keK4bQZ8/4R4yCMhP
        ECh2/Xo7tBnaVOx8WgyjLiPAmc6MvRxUsamtBGLJThDuX6A+hCeS84VMXbgAWuuJpszS7s
        0jRCTD1faGvXIn2Gh95PLr2zyw51RZA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-u4othmf2OneqyMKyR57XpQ-1; Sat, 11 Dec 2021 13:43:32 -0500
X-MC-Unique: u4othmf2OneqyMKyR57XpQ-1
Received: by mail-ed1-f71.google.com with SMTP id q17-20020aa7da91000000b003e7c0641b9cso10774083eds.12
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HeYVFn3C/kHLoloeDuy+DYyyuZygKIHXuCGMV5j00so=;
        b=XNWKnUQP3YkI5mUsubXsK1o1Knvz4vaR1dLx50mek/GXQmBmYyC72679yTrNr1sjYk
         YAAYb6jAvIBzbeGiW4PISPRmBCbhSdNGvQr7lhkZMvY7R1Jtz7fJwMzD5OBhlB312CfS
         syLpkoGx4p9Yq2UaYxxGh4rtp5YUVAIMQ383c+l4UGmBOccHcdazfBd2Io3pCSixir17
         TzBOcfLYhn19F6RVRQczNguidbYs1tCtViwt2bS5m2uuwpVgT89U63oKT8/d3/8akbf2
         07zjd8ZpMr8lA+yGHhW5ozX3iIGLvKiEWjtrhKuBwGcTcU+dkAJVZs88yupshz1Vrwm6
         oRiw==
X-Gm-Message-State: AOAM532j0RqSAt9PpZIctSHbF000FI8bjIm1h4AVVuvuvfucdIattGgF
        G4wMQpFQKuZ4UwzuWVoOZzvxemo3Uqp/CDNSnI6EFgTqmzNee4iKm7ZG0tPePw0koN8mzrgyL+Y
        zFW7ImCTw+3eRANBn
X-Received: by 2002:a05:6402:169a:: with SMTP id a26mr49742957edv.292.1639248210371;
        Sat, 11 Dec 2021 10:43:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvn2/kx/sy4X+uNEui7KNBiPnV187X8Fb6NiDQQ+3mYCw+ye/2jt3PYs599SBvbT546KuWgA==
X-Received: by 2002:a05:6402:169a:: with SMTP id a26mr49742824edv.292.1639248209030;
        Sat, 11 Dec 2021 10:43:29 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h7sm3838937ede.40.2021.12.11.10.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 10:43:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3B6B5180496; Sat, 11 Dec 2021 19:43:26 +0100 (CET)
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
Subject: [PATCH bpf-next v3 7/8] selftests/bpf: Add selftest for XDP_REDIRECT in bpf_prog_run()
Date:   Sat, 11 Dec 2021 19:41:41 +0100
Message-Id: <20211211184143.142003-8-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211211184143.142003-1-toke@redhat.com>
References: <20211211184143.142003-1-toke@redhat.com>
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

