Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8EA3689CC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbhDWA1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbhDWA1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:35 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CF6C06138F;
        Thu, 22 Apr 2021 17:26:58 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p67so27976399pfp.10;
        Thu, 22 Apr 2021 17:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HMtZowpuKJ//bqS/0/So0II0C+lVTMjMU4WfA8IzfXQ=;
        b=C6yT8RSJy/eslFFZpnx8+95P0A2RhZrVz462kQC5Xx3TOLNo/KM9fkRN6vXQqQk9YG
         EJV3SompCvejgb39ZqRPURFcDZNnjn3nFKLmsaAc4barnN2xHMvP9YFHxcmouHlhGApy
         JROwJgx6nMj4O8mqsuWB7GBFSiYCLWJrRJE2yGIhQo2/RSr8QoniS6dYHWVo0XvIZzaU
         IqwHz/g3pmYUbh2aWN5COnfGBWV4opyb68cH0ePr+SXNlero2r4uUcLuOJrjUVItBRzz
         U2RORVH5e8EYYdCfum6vWAqMFJrJYCrnao0/jP1tyZ4b6PSgQW9hR4QKFeoxlTYzkzqx
         O2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HMtZowpuKJ//bqS/0/So0II0C+lVTMjMU4WfA8IzfXQ=;
        b=tkIhXGtBL6KbjWyhTxl5HBgkz5OVgoarsr3qNHtg8wwxgOAKCR8FaavPuqDXC9y89A
         PWIakrjWbiHzCr7ODKRs1U3CYMnakZ0Zxo3d7c7lTtVHMS0x1kLmg9/oqxlLbN0K+c3M
         BRsrI0XArHY4Yf0gFKSMlnS1p4GdNLWD8xYr2rSDFZfPemPYxUGyttDq0n4J/P/7bjrb
         zbYFo3EnJmHlUB6ccyDs4Qx2zx1Rq1/ugRtscqKANPNq5CygtZ1iAPz/0qi0k/sWVoRo
         bAcgl3rNjpzuq7dcyy/C5wFaOPyS+O9Ftui8WvfhK9aw5z4UDvmv8Ip38i2wL19NXYMX
         fxEQ==
X-Gm-Message-State: AOAM5324Dt0f5PxqKBCUXFR0xJrFClltRhy9KPRF0ycqFWd45URyXtgU
        x8S0/ETESssVgCr/Az9c32c=
X-Google-Smtp-Source: ABdhPJw8b0+EAHbqCAWEH1DvrgIFI4sBgDcik7/kRjFhoVz9IcJvVDU3uPtckMEsW8nLDQHjt1bVUA==
X-Received: by 2002:a65:4986:: with SMTP id r6mr1277347pgs.392.1619137618347;
        Thu, 22 Apr 2021 17:26:58 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:57 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 07/16] selftests/bpf: Test for btf_load command.
Date:   Thu, 22 Apr 2021 17:26:37 -0700
Message-Id: <20210423002646.35043-8-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Improve selftest to check that btf_load is working from bpf program.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/progs/syscall.c | 48 +++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/syscall.c b/tools/testing/selftests/bpf/progs/syscall.c
index 01476f88e45f..b6ac10f75c37 100644
--- a/tools/testing/selftests/bpf/progs/syscall.c
+++ b/tools/testing/selftests/bpf/progs/syscall.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <linux/btf.h>
 #include <../../tools/include/linux/filter.h>
 
 volatile const int workaround = 1;
@@ -18,6 +19,45 @@ struct args {
 	int prog_fd;
 };
 
+#define BTF_INFO_ENC(kind, kind_flag, vlen) \
+	((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
+#define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
+#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
+	((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
+#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
+	BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
+	BTF_INT_ENC(encoding, bits_offset, bits)
+
+static int btf_load(void)
+{
+	struct btf_blob {
+		struct btf_header btf_hdr;
+		__u32 types[8];
+		__u32 str;
+	} raw_btf = {
+		.btf_hdr = {
+			.magic = BTF_MAGIC,
+			.version = BTF_VERSION,
+			.hdr_len = sizeof(struct btf_header),
+			.type_len = sizeof(__u32) * 8,
+			.str_off = sizeof(__u32) * 8,
+			.str_len = sizeof(__u32),
+		},
+		.types = {
+			/* long */
+			BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 64, 8),  /* [1] */
+			/* unsigned long */
+			BTF_TYPE_INT_ENC(0, 0, 0, 64, 8),  /* [2] */
+		},
+	};
+	static union bpf_attr btf_load_attr = {
+		.btf_size = sizeof(raw_btf),
+	};
+
+	btf_load_attr.btf = (long)&raw_btf;
+	return bpf_sys_bpf(BPF_BTF_LOAD, &btf_load_attr, sizeof(btf_load_attr));
+}
+
 SEC("syscall")
 int bpf_prog(struct args *ctx)
 {
@@ -35,6 +75,8 @@ int bpf_prog(struct args *ctx)
 		.map_type = BPF_MAP_TYPE_HASH,
 		.key_size = 8,
 		.value_size = 8,
+		.btf_key_type_id = 1,
+		.btf_value_type_id = 2,
 	};
 	static union bpf_attr map_update_attr = { .map_fd = 1, };
 	static __u64 key = 12;
@@ -45,7 +87,13 @@ int bpf_prog(struct args *ctx)
 	};
 	int ret;
 
+	ret = btf_load();
+	if (ret < 0)
+		return ret;
+
 	map_create_attr.max_entries = ctx->max_entries;
+	map_create_attr.btf_fd = ret;
+
 	prog_load_attr.license = (long) license;
 	prog_load_attr.insns = (long) insns;
 	prog_load_attr.log_buf = ctx->log_buf;
-- 
2.30.2

