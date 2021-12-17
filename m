Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F45478288
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhLQBvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbhLQBvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:51:01 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530DEC06173E;
        Thu, 16 Dec 2021 17:51:01 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x5so950615pfr.0;
        Thu, 16 Dec 2021 17:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOTczFAMM0Fm7hG3kON/VsDcSM32uaLdyaYc6WXZgNs=;
        b=Sr3TGtqgFMWtlix5pXqTsOhWWO/9w4m4vSWXLtDsMSFMFLfsWlbwcztMPbCiO0A5RH
         IXDz4tQWbHdEizLaXVwUMfsV2zazp5zfHI/e5S7cwYlixGVD9WxI+FeHiwwRx9vDqVmf
         mlq/dMAJRtCnMe8tbtlUFsqZ9bRm7axnTpfQsxBVS9mrCyV2kipEsO/CBHHZS0EyBA7f
         ab68mvTDJDBmOljTltkkOMwOJJJ+KrlkSLohv3Yd4eA6+4NeAXMkfkUBnTSbbhxR+uQH
         zrGDXumzvpHv4HPO97UU8Jk20FnwtWcujwZeE5YWEHbzMvO9S8g88S2ZG81J5qUuYV/L
         l+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOTczFAMM0Fm7hG3kON/VsDcSM32uaLdyaYc6WXZgNs=;
        b=N3EWjk+l7yBwC6Vokm+Zq1HOU2M0QommjSpu5SPZdXRJzd+Ro69ArXdET3+lsT3WxE
         3HYLeNxTwdeaHlA9fyzPk7UDqDFtBh7muEr2Aki/iRyTNQ/PTOhKI0YtlLSDWR4i4RKn
         qysBHnhDxmr7wfa8zHukpGx68K8zJyxHbJDfBSRVBM0J9cY51A/sJQ09sken8fHD0fr/
         6Ig9FVAIx2L4IwrOQ0msB+V/e9trMoIgCGyHGj3eWYCYQ5r+2N88KED11/c/bRKAsLrK
         gIUuWoApQOylC3eoyI3dNfa6gaYzudANdmH7lsphbOkHAwtfvd11ENVtmetxUCUO/Zq8
         9ChA==
X-Gm-Message-State: AOAM533ZjCLbRuG41hDtSwfVfLjHU6PMowFi6sDWTAm++/ZOELsg7DYp
        7yRYQf43OGz/NDag7Rr8U8JgB/nmA7o=
X-Google-Smtp-Source: ABdhPJxlyvagz4TtmuSCl8VlEVDOmay/IjoCs+x1mNeMxJOAFjl0HI/wfSW2ZAcfdiP2smhzBMbSsA==
X-Received: by 2002:a63:1166:: with SMTP id 38mr861823pgr.368.1639705860744;
        Thu, 16 Dec 2021 17:51:00 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id e35sm6273425pgm.92.2021.12.16.17.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:51:00 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 09/10] selftests/bpf: Add test_verifier support to fixup kfunc call insns
Date:   Fri, 17 Dec 2021 07:20:30 +0530
Message-Id: <20211217015031.1278167-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2589; h=from:subject; bh=HvYBVFTxN/c5gpmQXG9GMBe+kJ3S9/llIuzjJYFWtlg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vFeBz+4C0zUgZysU/Gb8hb99af8eCe0lDsQQH3 aAq6zWOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxQAKCRBM4MiGSL8RyvvMD/ 4jTSb8yxqFKnziLHK8z+E1JMUgcCR3Zj3FJJquohqwoseZKiNeZ1/TFuWaB4Wd8VuKX/0nE890AUw+ Nj9wHAzN3BuMMOir14MgEuRDROpLA0iBXUeTigAtUTFqvYoPQqFO+ziPr6HPbilqOBMGaMZMQt/eFG iZJNATsPhiH2AODAmqEmE3yNcmlgeoh6rES1p+vG/uTtLoSetcPRM+2Oq2fl1dL7QzgZGkj4+7u+vl ox3dyh3ED/eWTkJ0F7xUXDHTv+6qSCt7vQrXqCikLnqE+4DpVFDg9ksT6tJxX8pII8ZwZsUBI09iLh hmgYJXhVK954zHdr2Eyx0sxe+ZElqiF/yUaeoR08MPRdQPewQcZZjiihDQbY5NSib0LhnAxhiVZesP cucxTpicqSqmuDVfLyHOSIF7K1XidwAYyegjB9EcsQtbJr9hIhsjyuSC3lqr5NFaNBXjqFYmDhjLMw b+iKKeD+51cU96puzWBD1qBcMtSp5OR6hUIzElgKji7uj74ymmG3MtpMWreaD5hwxAROccnLjrvvpk TrMALdrt8hzojRUeaajUQ9ePHvtkzb72+99je3rzWJ+SVd+CwXjL4Oqqkgd/Kz6zDPaCaqBBEHKZNI e6VJz+X/nMXMVteHs2xqrlvzIwa0P8zh/28DcPE/iJUWUM1GJ1I3diwki0Wg==
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

