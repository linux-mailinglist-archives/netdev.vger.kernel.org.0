Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E166482C07
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbiABQVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiABQVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:45 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3DCC061761;
        Sun,  2 Jan 2022 08:21:45 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id u20so27576023pfi.12;
        Sun, 02 Jan 2022 08:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOTczFAMM0Fm7hG3kON/VsDcSM32uaLdyaYc6WXZgNs=;
        b=BsZGf2Qce7KoOIbXJHB+2bgnowx411i7T+Y4/ZtU2YtLwx3EdoWnv0ZotxQ7hF4caA
         Cc06AxuxHpuhPMBcW7byjDWKvjiUAH2ECi9AI77wV+jJG3tJ6QRRew7aYEK9IQMBqDo8
         llez37cvx1GtEzzNTuz0hwMdjdNHbwhMXXkoi9WssEzAb3ikrN3vFiuMotqHCUvXjExs
         0RglQVE4HUCySE+4ZKY02ExlrmTlpKi/0Qxzq/PToCjBlDF4VJT9hPBeehYklt0kIg9S
         wSfJpq+E9SLYZcV+OanYP+5/cfNItwu/gFx/6ySXwtOD6MjUVHYRl9mgMMSqV/XZZNhk
         Tj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOTczFAMM0Fm7hG3kON/VsDcSM32uaLdyaYc6WXZgNs=;
        b=he0CeLCFD34wHEt582S2fvdvh8oIhX+Z36Dygd3j+a5AkTsmpfIy1PAGdDqpUju7ac
         mpp6QY5vcivFf5hnU0wEMFR1LFPfG0Kq/MIpJqOL9qb95BFD+7e8PPyXlhj0nErSWhK2
         MTdXgqNRxBLJCjK97HG/fNfa0+FaTtVMsJF/tqFj5aANkXqxv9qPi7BEXK5VwDHKdGRN
         2XMHB7gxdvjeewI+23wOz55ObRSJ//nZ34WK6OkfMFDsTTyHfjJtwW8h80FCSLyai2Bw
         HHXSKwRMMDLHqbr6RNZulFlLM+qs3amGVX3dQRc3cnUC+83x0OrZ262Ao8V4lX8vOhmY
         rZbQ==
X-Gm-Message-State: AOAM533weFdXnhmSneGB7catEb85HUXgbTOqh047J74Gd2obfQZrYYRH
        pwqTtMDei2uLD+GHjqVJJ8apW5fqVSU=
X-Google-Smtp-Source: ABdhPJzgOfYKA42i8XoqmJbIUN19Kb3mPJfEWQndPG5tsMOQpB+BVNat5ORcdAeoCcrlw45AwqkhEg==
X-Received: by 2002:a63:787:: with SMTP id 129mr38362930pgh.289.1641140504795;
        Sun, 02 Jan 2022 08:21:44 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id x6sm30680371pge.50.2022.01.02.08.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:44 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 09/11] selftests/bpf: Add test_verifier support to fixup kfunc call insns
Date:   Sun,  2 Jan 2022 21:51:13 +0530
Message-Id: <20220102162115.1506833-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2589; h=from:subject; bh=HvYBVFTxN/c5gpmQXG9GMBe+kJ3S9/llIuzjJYFWtlg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCKeBz+4C0zUgZysU/Gb8hb99af8eCe0lDsQQH3 aAq6zWOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQigAKCRBM4MiGSL8RyuMvEA CYfoSvm1K78ExLMGNbZV0grYuMMly2iKEpq1F1Wh3zDFTh5HEP04HVXzNC01dtEyqSo2r9LXINysn0 pY45pPbmOScNjRNXRjLh8MI1bhSafEHkyxhwvfT9HattHgqflv7gaQxIrktvlepuvlNwdYtQMyB5+h levtiiciP+FJjJJO53MYiGw0bhnFMmiuuOstt+rErOJxjk7zwIDkkwcJkw9uVBT+7tV3oItDqLlbT3 aFSatAFl9q/DnQTuu53GVzV0OAjDj7tLgCY84jV20S4FUFJwyGZVOOzCgdWYvKYhHNfv476KSMATJO Fc4gxlXvS+S3KHJTLx9W7L5Jx/a72GlZNJBlxDqq80eGBAlxyW/CxqTLboC6R3Vxoainsoy3qmHgOn YAgv2PnFGTGgfQM59KWyQM8le6YmIga2951+YozTh2Jfwm7OLYSSlZuIpr9OOv8NX5QnAsRfYE4oor MAJOAYk2MwF1Kg3c9cIMpTyFMsg3k84r2EQhKe7nBMvRRarCL9iKM3mgMuHEpT/pVjQSEruiJOyj4h 96WaRsM7xe2pOYjKwKE4ux+h8hcRUZw5uyoZOyjFcULhMLOIOxJQctQBV/v6WVmzsb185Hf1hmofFh KH8EtEhyxM/F1xR6J7t/VIzIxp+bexicQd73G8+a/vw2NwDWJpuczR2q0HTg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to add tests (esp. negative tests) where we only want to
ensure the program doesn't pass through the verifier, and also verify
the error. The next commit will add the tests making use of this.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 28 +++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index b0bd2a1f6d52..50a96d01ddb2 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -31,6 +31,7 @@
 #include <linux/if_ether.h>
 #include <linux/btf.h>
 
+#include <bpf/btf.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
@@ -66,6 +67,11 @@ static bool unpriv_disabled = false;
 static int skips;
 static bool verbose = false;
 
+struct kfunc_btf_id_pair {
+	const char *kfunc;
+	int insn_idx;
+};
+
 struct bpf_test {
 	const char *descr;
 	struct bpf_insn	insns[MAX_INSNS];
@@ -92,6 +98,7 @@ struct bpf_test {
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
 	int fixup_map_timer[MAX_FIXUPS];
+	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -744,6 +751,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
 	int *fixup_map_timer = test->fixup_map_timer;
+	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -936,6 +944,26 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_timer++;
 		} while (*fixup_map_timer);
 	}
+
+	/* Patch in kfunc BTF IDs */
+	if (fixup_kfunc_btf_id->kfunc) {
+		struct btf *btf;
+		int btf_id;
+
+		do {
+			btf_id = 0;
+			btf = btf__load_vmlinux_btf();
+			if (btf) {
+				btf_id = btf__find_by_name_kind(btf,
+								fixup_kfunc_btf_id->kfunc,
+								BTF_KIND_FUNC);
+				btf_id = btf_id < 0 ? 0 : btf_id;
+			}
+			btf__free(btf);
+			prog[fixup_kfunc_btf_id->insn_idx].imm = btf_id;
+			fixup_kfunc_btf_id++;
+		} while (fixup_kfunc_btf_id->kfunc);
+	}
 }
 
 struct libcap {
-- 
2.34.1

