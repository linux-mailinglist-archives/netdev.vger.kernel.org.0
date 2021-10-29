Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6944012F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhJ2RYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhJ2RYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 13:24:48 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481EAC0613B9;
        Fri, 29 Oct 2021 10:22:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so7823217pjb.4;
        Fri, 29 Oct 2021 10:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U6yMT3GV2dbCSQeHBjAWc80Y0SjzhEx7QAHW0xwVICY=;
        b=P1AEVVC9NT7glY83gdz4Ghz5rhS4A9G6fJ86guPRs9xI+5YotileJrZOC5GsPAoc2O
         tcH+12NTTJup3fzvRSNR9RUDhsZk/HIFlh6IgaeA+wbfgLv18vPxmQtURTJHUqiuXHob
         MEG4phHhHrrUA2HhNNECd18bmUcIdvjxmSsF+jTozZiIRPGe46SZLKTZ69vHsqKvYiw0
         ZhSOlLNrCWztO/DUVPshYfAP4zrgrCUoQltstiQeX0oDZBVqBpDttLKigsCxaSJv/2SL
         eAkKixLdjpsFU1tpynolyo5I/+xfZOyCMxqX9xdULFh0LyGqjRKAkSDfXGohFN/FAoro
         h0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U6yMT3GV2dbCSQeHBjAWc80Y0SjzhEx7QAHW0xwVICY=;
        b=FP6NP5y+Ulr/EmNOJfnXwXU3Ia7jVHnAyHHlxr27GquJa6rtnkz9mr15Yy9PCHNZzC
         Yag+qIAcdeDMoUtQZ2Te2aJHXQVy3scdSfrtU0rs9fxktjfmcGiF8/h1A1y/YU9fNNvK
         h1B9Hpviea/cDu6/zB2W79UR0SzlqJylIVmM6okbVnxqJY8Z7AMQVqZWNI1Xu7bymAyD
         QzoPP3BUbE47eODhbD0Moif6/kUMrIgLU/XnKtXFxBPnrSk2B3DERMEDOZ0Nu50M1jjx
         ahNEvYXScEtZy+IcybCgfgdzESZaDbklU4zSrK9SY756qWT6OhP5hFILoLmkle1Ku17S
         PzXw==
X-Gm-Message-State: AOAM533Fy8cxe8v3aYQ8R+pbhgCtZub88U5JhMRiIZMsCCGEkhA1oooZ
        dgRlxw21Wv4O3wMFooS+CjvWWG/DWrE=
X-Google-Smtp-Source: ABdhPJypWVsr1ZJ/8GigAeaf8GHpmvRLmMd+mDBtVhTy55T1rMy3ldEkzRm5GWat4MWKn8SmtB2oFA==
X-Received: by 2002:a17:903:11c5:b0:13f:ef40:e319 with SMTP id q5-20020a17090311c500b0013fef40e319mr10915938plh.33.1635528138538;
        Fri, 29 Oct 2021 10:22:18 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:76b2])
        by smtp.gmail.com with ESMTPSA id a8sm6344483pgd.8.2021.10.29.10.22.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 10:22:18 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] selftests/bpf: Add a testcase for 64-bit bounds propagation issue.
Date:   Fri, 29 Oct 2021 10:22:16 -0700
Message-Id: <20211029172216.88408-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

./test_progs-no_alu32 -vv -t twfw

Before the fix:
19: (25) if r1 > 0x3f goto pc+6
 R1_w=inv(id=0,umax_value=63,var_off=(0x0; 0xff),s32_max_value=255,u32_max_value=255)

and eventually:

invalid access to map value, value_size=8 off=7 size=8
R6 max value is outside of the allowed memory range
libbpf: failed to load object 'no_alu32/twfw.o'

After the fix:
19: (25) if r1 > 0x3f goto pc+6
 R1_w=inv(id=0,umax_value=63,var_off=(0x0; 0x3f))

verif_twfw:OK

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../bpf/prog_tests/bpf_verif_scale.c          |  5 ++
 tools/testing/selftests/bpf/progs/twfw.c      | 58 +++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/twfw.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index 867349e4ed9e..27f5d8ea7964 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -202,3 +202,8 @@ void test_verif_scale_seg6_loop()
 {
 	scale_test("test_seg6_loop.o", BPF_PROG_TYPE_LWT_SEG6LOCAL, false);
 }
+
+void test_verif_twfw()
+{
+	scale_test("twfw.o", BPF_PROG_TYPE_CGROUP_SKB, false);
+}
diff --git a/tools/testing/selftests/bpf/progs/twfw.c b/tools/testing/selftests/bpf/progs/twfw.c
new file mode 100644
index 000000000000..de1b18a62b46
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/twfw.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/bpf.h>
+#include <stdint.h>
+
+#define TWFW_MAX_TIERS (64)
+/*
+ * load is successful
+ * #define TWFW_MAX_TIERS (64u)$
+ */
+
+struct twfw_tier_value {
+	unsigned long mask[1];
+};
+
+struct rule {
+	uint8_t seqnum;
+};
+
+struct rules_map {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, __u32);
+	__type(value, struct rule);
+	__uint(max_entries, 1);
+};
+
+struct tiers_map {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, __u32);
+	__type(value, struct twfw_tier_value);
+	__uint(max_entries, 1);
+};
+
+struct rules_map rules SEC(".maps");
+struct tiers_map tiers SEC(".maps");
+
+SEC("cgroup_skb/ingress")
+int twfw_verifier(struct __sk_buff* skb)
+{
+	const uint32_t key = 0;
+	const struct twfw_tier_value* tier = bpf_map_lookup_elem(&tiers, &key);
+	if (!tier)
+		return 1;
+
+	struct rule* rule = bpf_map_lookup_elem(&rules, &key);
+	if (!rule)
+		return 1;
+
+	if (rule && rule->seqnum < TWFW_MAX_TIERS) {
+		/* rule->seqnum / 64 should always be 0 */
+		unsigned long mask = tier->mask[rule->seqnum / 64];
+		if (mask)
+			return 0;
+	}
+	return 1;
+}
-- 
2.30.2

