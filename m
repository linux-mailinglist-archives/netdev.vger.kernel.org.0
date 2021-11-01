Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE43A442357
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhKAWYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhKAWYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:24:36 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A583C061764;
        Mon,  1 Nov 2021 15:22:02 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y4so3303770pfa.5;
        Mon, 01 Nov 2021 15:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ysqon/JwnCyLV8l12vSiD07wZq0evQinrXixZOATe48=;
        b=p2/15HmAIXRgFT44ez3MGKPotG7oHxmt7ox5zkTqUVzkwhzTbZ/B6v2CI26JkujGsW
         6KDo+wVAHnqINDVyVy5OUrgx/qgEbiX15woNmJXh4gzjrHzxFxa2nT5IF+JqnoqgaA2b
         lbvlKPwrBjo4Z2AE+KJjwyRLBZUHeYVO6hYydpYB/RpmHyZopfgTEUI7MpU7PvnQmI40
         O9uug7PkQdJH1vYO87p7a/s30Lf/oFZMjc5f8h13Ouf+ezRLcjp2b1v4F4wCPseDCVgU
         vG472kNYu0wremd53R7zrEbnLUE1t+/wDXqoj9Nv5kRMojvSsz3Q5IfgHhVRyM3N88bR
         I0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ysqon/JwnCyLV8l12vSiD07wZq0evQinrXixZOATe48=;
        b=djkQ2RMdUVz35tv6d1E2WVea5rp5V/QiJGqD4F8jOzc7fv1kWT1XyOqySJyZ7tpOBL
         jKWbysNGeLckq2VNnY2apg2q1dw4poDG0IAESTGDd/VCyTJIgCZP8PCHA0dckBrqE/0e
         bW+1DBnHhe+uhkT450eieC1rqC4WwNtRlSxzKakkQ+7Fm2oM+HsNpD45dF7l5LmnrnWd
         S9H13VwgUANQJi6hSKgDeB7wEDtDclMZgI8AQtnExn0LDh6kKKWhfL59Djr4FiyqDifs
         kJ8BE5hNsLdTQrG1qtU1oGEN1H6nfuXX+P1BQDXLPlTMQGItUCf3++jo4a9R+TAUEyFs
         xusQ==
X-Gm-Message-State: AOAM531ab6/3UDHLCvI/guzpXMVrmnX6KMTNr/68UHbk8AmJrgnd6L+K
        RMZXJ0rrcpISRRQ908nimu8=
X-Google-Smtp-Source: ABdhPJxwYbiXeCVws+EmbeQ8cN0nCdwZRtLbRe6i/36qxUxLQs0Nq6KKi3Ke98QYP/mPE/KlQhmHDg==
X-Received: by 2002:a63:ef57:: with SMTP id c23mr23823650pgk.60.1635805321618;
        Mon, 01 Nov 2021 15:22:01 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:880e])
        by smtp.gmail.com with ESMTPSA id v8sm15379641pfu.107.2021.11.01.15.22.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Nov 2021 15:22:01 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: Add a testcase for 64-bit bounds propagation issue.
Date:   Mon,  1 Nov 2021 15:21:53 -0700
Message-Id: <20211101222153.78759-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
References: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

./test_progs-no_alu32 -vv -t twfw

Before the 64-bit_into_32-bit fix:
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

Acked-by: Yonghong Song <yhs@fb.com>
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

