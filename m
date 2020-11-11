Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C72AE6E0
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgKKDMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgKKDMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:12:19 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A1FC0613D1;
        Tue, 10 Nov 2020 19:12:19 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q5so737976pfk.6;
        Tue, 10 Nov 2020 19:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XjRkkKoDu+Kyc2vamgZoB13ahFUlRYh6LdPxIMys8aw=;
        b=sCw/AuBpNbjut2RyBgNpBnumbPXZoH9oWvRSHC53cwaoQKDw5ouM61O9olHVNCTZoj
         7Ibx/aIbSij788GpO3PHSb1Fl+1AkbtDclltu8o2ujo79Vly/vjKekeCmBNwJj8zv709
         P4U1y7BuABqToyJrNIz6R6+yFUgakw7ZZcV2Hj3HLOUeIwbyVqcRZf8W9OiPczNjr8BV
         DP+ScPZxNWpLKB4KtbEMGOrOnIPVY9vxY3d3vCQpqtVU2wBwRc9NR4NHMX0P22nVxidU
         2yia7jf8/zCl0PISRqcz0NumKE9vKIqbp1ae81zMEJo6OYq6GdMlMEYFvbQ5TTGNeQW2
         1NCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XjRkkKoDu+Kyc2vamgZoB13ahFUlRYh6LdPxIMys8aw=;
        b=hRZPJo7O8E59ZZtqv5fDS7rtTO+ztyKM++DzkMUc3KLO6iS0KF4w5LB2/zQCfPLIwz
         5LEn7jk1u0NUkI5cnLNzYRRouiwm5Y8t17ffqEeRXjPQt3gM7PMq4bjxB/Z5ZavEk6wP
         ftOeBfA7UNpwyi0146s6+23jsVU5k671OFuoedwvw59B1kndFakrP9oSzLO8Ev3kUQlT
         q9amDYuyg7b4i0Kk1nFxrVSxSUj+guIpao5GWuLuvZyPuAQMAlujLpOg6bm8gsso5yQM
         EcDl7N8xFZc1VyQUWXAO6HlICNODICy4aiUKnwhwShjuyjNuDRZXS/tfgddYlRPu/CjU
         cD4A==
X-Gm-Message-State: AOAM531kaNfXlbOBpp1iFILdY2DScBK5csZeOW0cisAb0uoE7z+yvzuy
        zx+fmlZOxqO0T4ztv+Dq5vc=
X-Google-Smtp-Source: ABdhPJz9p0f5/pe4DxyF/bazP1+EpAUArEQ7QCgPI6jt0sBnfWSZ6I95bhQ49EDH7y75vPl2yc20Fw==
X-Received: by 2002:a17:90b:300a:: with SMTP id hg10mr1657507pjb.30.1605064339175;
        Tue, 10 Nov 2020 19:12:19 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id o132sm506815pfg.100.2020.11.10.19.12.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 19:12:18 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/3] selftests/bpf: Add skb_pkt_end test
Date:   Tue, 10 Nov 2020 19:12:12 -0800
Message-Id: <20201111031213.25109-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add a test that currently makes LLVM generate assembly code:

$ llvm-objdump -S skb_pkt_end.o
0000000000000000 <main_prog>:
; 	if (skb_shorter(skb, ETH_IPV4_TCP_SIZE))
       0:	61 12 50 00 00 00 00 00	r2 = *(u32 *)(r1 + 80)
       1:	61 14 4c 00 00 00 00 00	r4 = *(u32 *)(r1 + 76)
       2:	bf 43 00 00 00 00 00 00	r3 = r4
       3:	07 03 00 00 36 00 00 00	r3 += 54
       4:	b7 01 00 00 00 00 00 00	r1 = 0
       5:	2d 23 02 00 00 00 00 00	if r3 > r2 goto +2 <LBB0_2>
       6:	07 04 00 00 0e 00 00 00	r4 += 14
; 	if (skb_shorter(skb, ETH_IPV4_TCP_SIZE))
       7:	bf 41 00 00 00 00 00 00	r1 = r4
0000000000000040 <LBB0_2>:
       8:	b4 00 00 00 ff ff ff ff	w0 = -1
; 	if (!(ip = get_iphdr(skb)))
       9:	2d 23 05 00 00 00 00 00	if r3 > r2 goto +5 <LBB0_6>
; 	proto = ip->protocol;
      10:	71 12 09 00 00 00 00 00	r2 = *(u8 *)(r1 + 9)
; 	if (proto != IPPROTO_TCP)
      11:	56 02 03 00 06 00 00 00	if w2 != 6 goto +3 <LBB0_6>
; 	if (tcp->dest != 0)
      12:	69 12 16 00 00 00 00 00	r2 = *(u16 *)(r1 + 22)
      13:	56 02 01 00 00 00 00 00	if w2 != 0 goto +1 <LBB0_6>
; 	return tcp->urg_ptr;
      14:	69 10 26 00 00 00 00 00	r0 = *(u16 *)(r1 + 38)
0000000000000078 <LBB0_6>:
; }
      15:	95 00 00 00 00 00 00 00	exit

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../bpf/prog_tests/test_skb_pkt_end.c         | 41 ++++++++++++++
 .../testing/selftests/bpf/progs/skb_pkt_end.c | 54 +++++++++++++++++++
 2 files changed, 95 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_pkt_end.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c b/tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
new file mode 100644
index 000000000000..cf1215531920
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "skb_pkt_end.skel.h"
+
+static int sanity_run(struct bpf_program *prog)
+{
+	__u32 duration, retval;
+	int err, prog_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, &retval, &duration);
+	if (CHECK(err || retval != 123, "test_run",
+		  "err %d errno %d retval %d duration %d\n",
+		  err, errno, retval, duration))
+		return -1;
+	return 0;
+}
+
+void test_test_skb_pkt_end(void)
+{
+	struct skb_pkt_end *skb_pkt_end_skel = NULL;
+	__u32 duration = 0;
+	int err;
+
+	skb_pkt_end_skel = skb_pkt_end__open_and_load();
+	if (CHECK(!skb_pkt_end_skel, "skb_pkt_end_skel_load", "skb_pkt_end skeleton failed\n"))
+		goto cleanup;
+
+	err = skb_pkt_end__attach(skb_pkt_end_skel);
+	if (CHECK(err, "skb_pkt_end_attach", "skb_pkt_end attach failed: %d\n", err))
+		goto cleanup;
+
+	if (sanity_run(skb_pkt_end_skel->progs.main_prog))
+		goto cleanup;
+
+cleanup:
+	skb_pkt_end__destroy(skb_pkt_end_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/skb_pkt_end.c b/tools/testing/selftests/bpf/progs/skb_pkt_end.c
new file mode 100644
index 000000000000..cf6823f42e80
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/skb_pkt_end.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+#define BPF_NO_PRESERVE_ACCESS_INDEX
+#include <vmlinux.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+#define NULL 0
+#define INLINE __always_inline
+
+#define skb_shorter(skb, len) ((void *)(long)(skb)->data + (len) > (void *)(long)skb->data_end)
+
+#define ETH_IPV4_TCP_SIZE (14 + sizeof(struct iphdr) + sizeof(struct tcphdr))
+
+static INLINE struct iphdr *get_iphdr(struct __sk_buff *skb)
+{
+	struct iphdr *ip = NULL;
+	struct ethhdr *eth;
+
+	if (skb_shorter(skb, ETH_IPV4_TCP_SIZE))
+		goto out;
+
+	eth = (void *)(long)skb->data;
+	ip = (void *)(eth + 1);
+
+out:
+	return ip;
+}
+
+SEC("classifier/cls")
+int main_prog(struct __sk_buff *skb)
+{
+	struct iphdr *ip = NULL;
+	struct tcphdr *tcp;
+	__u8 proto = 0;
+
+	if (!(ip = get_iphdr(skb)))
+		goto out;
+
+	proto = ip->protocol;
+
+	if (proto != IPPROTO_TCP)
+		goto out;
+
+	tcp = (void*)(ip + 1);
+	if (tcp->dest != 0)
+		goto out;
+	if (!tcp)
+		goto out;
+
+	return tcp->urg_ptr;
+out:
+	return -1;
+}
+char _license[] SEC("license") = "GPL";
-- 
2.24.1

