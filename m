Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74DE4818B4
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhL3Chk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbhL3Chd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:33 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D865C06173E;
        Wed, 29 Dec 2021 18:37:33 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id c3so4029844pls.5;
        Wed, 29 Dec 2021 18:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOTczFAMM0Fm7hG3kON/VsDcSM32uaLdyaYc6WXZgNs=;
        b=mOta9Ee4vPuLZpNm51N/Ww6GIIunrEvwD/VnbZcsw5o9SEBFHGNPUMNxv5T3GcUEvd
         amZxIhFr7L6xVg7K+an6Kmp8Taw2SqiRhlGxYiNNLKdhtSXxw6EvVeUu9wQCzZ8NvHms
         8my5bFE9o0HrY+fBBGeeZupPn3mt4YrUeAktHHEPdadpAeXbBYY1Rf9KxIudxyhzYHMO
         hi6fCtUJLtcJPECHkfGkrXkZH3PNXd9oAToTCsuSK+uX0Ic0PqKUFMhfjEujGIqJI6Nq
         UJgOdYvq/LpYl0L/xNsPeTi/37t4sWDTOs5UYOJf3LeMzqESlO9EqauCjndmIqHo5+Re
         ETQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOTczFAMM0Fm7hG3kON/VsDcSM32uaLdyaYc6WXZgNs=;
        b=H0oLSheiIpcrLUkoVEbEA5q8TcW4Ra2bpNAlOXiOxl961KmgqOWZjwKD1UtHrU5lQr
         q9evkCkbDz6SKYBMllBBgSaNoV/Jx2hkJVMyGtDz27fGntjo3IDcfakoCcWmiQYULC3D
         IgiHu6DqveZDSByk6n4GPofG6d0HN2fU+qttM7BhRk2qQYbm58AknFuBZNpoeeyLRjYq
         ALjV44iMxJMZ293ks4adLQN9El+9zUoAxeYseUnQAACLrMAILkMhkf4VfqxMTw/Oy6zS
         fPycDgxz9YqG+Xb09IJCOYtog7LptFuScZYwrR/0e2bAZzhR4rbzIKkNQtcdN9d08H+F
         w30w==
X-Gm-Message-State: AOAM531AuxcLvspf2ulF9fal5zLTR0Z1Bojr31zfhSg58yACia6SVUFy
        peFqvFB1k+0iHsIf5KbSyl/XKbUZiLs=
X-Google-Smtp-Source: ABdhPJwckn5IIY3iRnQ5Yrlm/nbLYrh/Q11jX9ju4SuNbyzUvsFGWYjjkB0QQuBPqOVGtHEWVZv62g==
X-Received: by 2002:a17:90b:70f:: with SMTP id s15mr15152274pjz.35.1640831853014;
        Wed, 29 Dec 2021 18:37:33 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id s2sm24249223pfe.103.2021.12.29.18.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:32 -0800 (PST)
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
Subject: [PATCH bpf-next v5 8/9] selftests/bpf: Add test_verifier support to fixup kfunc call insns
Date:   Thu, 30 Dec 2021 08:07:04 +0530
Message-Id: <20211230023705.3860970-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2589; h=from:subject; bh=HvYBVFTxN/c5gpmQXG9GMBe+kJ3S9/llIuzjJYFWtlg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr+eBz+4C0zUgZysU/Gb8hb99af8eCe0lDsQQH3 aAq6zWOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/gAKCRBM4MiGSL8Ryhm6D/ 0dsrBcDgDFIBcOlMrs8kgFjfYTHBZhKzs0cLgkmQrOHeb8VMvP8HkXSCjcjqX4c+eyoZ9n2dSJlNyG 5iaFCM9VE85ZsY4MQa+xN1aOW5RFZ8jTQCbW4FLBfs9fsAG4DgCzR8/e7qHhvLmRzNh0NQEgaYcOXc /PfiW59CqlrxvcCK7bgP2Fmf73CwiusCoRkCCM6CsPDhcq1+tyOU1qnMh0MiRfkRrg5zW/DFkNDHnC K8GZVpFVVeqrFwGvKvS/HSNBtz4irjdgP6oY8c9RJ0BcdRz1CGB9OYMJfugk7YXVcgX84KZ6idq9VP yC+23o0H3mvuUyKVa98pz8D71QB1sIL8Pmo/OMLJwrwzXZtHg9GJJ2Ym/zGfSJ6cC/UzF/23gmww3o IzhZVMemOGpKVl3izjqbgm7by0X7h2a9xBdvJnEctRFr15qH1P9WcHX+U91iBMJF1tkGKQ/35+P8zx ONuwrbaeFj2Rg7oIv9dEiLfCmEWPP3ylZfYqiNlr0dwbe4u2hjRXUQjHgFT2lLBD4R+uHOeA+R1dQe JOmm2N6t3Zg+2GwPqAPXxkTsoHXLgq/a9KNe0eGeznKne5zUXC/0VsmDtjfcxa0XRiNObfkoWh7UEc GKje9c61Btw9AIiYRhpkIzt5/EsI4DSQHrqjx7M//3Y1b6T7BVs0QW6pPrnw==
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

