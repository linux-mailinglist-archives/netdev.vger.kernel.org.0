Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9020E4409B8
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhJ3OtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhJ3OtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:49:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A122BC061570;
        Sat, 30 Oct 2021 07:46:30 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y1so8742035plk.10;
        Sat, 30 Oct 2021 07:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=at5N+PIwtDvx5bN/JXjQgxbOT5qxk0tTrCjHUzNtDSs=;
        b=B4OElDpPFC4XcpxkwN7oesXs/QWT9H/rUaksExmRMejw5RO7LLeJ23lLGIKcdQ/aDv
         8yw+QlLZ2za2Zj6fHKWYCZS1qxTUd9Uwrh2lzxSOeIkFkv21DNVlwNU42eurwNm+UXIH
         fnjtYN90cXdMu68HCj4ahC0z6/evYU4bbQbBA3CUEuzbUSnDPWyYrwya9ZlogTDWeauR
         56VR6mnBcTvytDuTvOQgS0t09aptTnrMSgcszp6pExmEgRR0SU4czYSf0fxhVqJ87Dsp
         kilhkVPC/sRpv14uhqt5ROZKxv/wEw+80bgzcTOoap9zH3AYyGT/ev9Oxj73uJ3bN/pL
         oDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=at5N+PIwtDvx5bN/JXjQgxbOT5qxk0tTrCjHUzNtDSs=;
        b=1JFWEELtokAOlZ+hpOmNmAmw+o++Hf6ZCtFMjheH5izTLBwW59kLHTHhwNBNQPEGwS
         F0kkaKEuuBdOolbpD96pBHr3cnFGKKR0uicXmBd8VJ6vyqitdw/X+zUIGQptEVSK87ol
         IQLZyxJzADTXlCRIx6+BxREa/jWRl4h919d9uxS/1LagTz2TDrSyFaXaLobIFZYVqtsF
         DkduBn5hLV8tf0j2XbA8COfHz5cfWMJJlnFAEotGkBp3JPnhLhNgITdy/5Lp7mphRq04
         wtPVzOQbygvvXg2opQKD+agKQHLdXf+y4RY5MOnUyHxCqoa9cFjUA3DuSTWmGcY2raE3
         9sgw==
X-Gm-Message-State: AOAM53362gXxgld767c2kcgFQIT64FsyztuK24V+34y7ZmiIDuDvx90w
        Nn2H20SNOSjNOvkRZ4HIYg8B+M69z4kYEw==
X-Google-Smtp-Source: ABdhPJxXi7TjCIb/SIBy5XeVfcA+G6Cv9xixwSukUWIjr4yo5zyNfVgUZYbyHOPxm9vs8WjspfqPuw==
X-Received: by 2002:a17:903:2301:b0:141:6a7b:f3d with SMTP id d1-20020a170903230100b001416a7b0f3dmr15408639plh.51.1635605190035;
        Sat, 30 Oct 2021 07:46:30 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id b9sm3067065pfv.186.2021.10.30.07.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:46:29 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH RFC bpf-next v1 6/6] selftests/bpf: Add referenced PTR_TO_BTF_ID selftest
Date:   Sat, 30 Oct 2021 20:16:09 +0530
Message-Id: <20211030144609.263572-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211030144609.263572-1-memxor@gmail.com>
References: <20211030144609.263572-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4808; h=from:subject; bh=5bg2rhKVr2UKFhtHRWyecOF+605rD1kKDy/H6C9iW+c=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhfVoRhea3e0KTRKE04VOzktOFQ7q/P3eeY8KiVD0B 7yoTo2eJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYX1aEQAKCRBM4MiGSL8RyizYEA C77d7mJyBLOeKqF/zW8ExsnuR1lEBlPsEItjW9CFGPMrj1JdcCi8IHphdwGafSaYTfbpCvHba+LK55 DuPutIoby91SGZb0ufpmSHo5mBbdetZV5Qp9ixGcnX/Myc477ejwUHEu8suEy5e29OFWgbjA6LYbUz KQ8DqHBAnn17UMZY4enSa63s5W73Ze09UKWt7KDPIfegw0oOQnues/7N1ZMSrPKcVx2xyZZvKx38RC LJ3WamnUp8YiuFdpnQOfEgcqxSf+8z42Mifo6ZrzGbowNZKy6qla7pYczB7bo4H42adTbO/w4EloW6 uFC4LD9+H5JQN7l2jhXyh740bMWUVrF2nebN5nZuHMgKzitEotY2W6CWckuNWUTlNKXmhjqAeJguIP J6GT3yVZPwhmekRUyE/GfIQtvrbT/HdYpkUXxpK62tTTKsjsecBDCg4u92hd26+FOEgGJjEelppmbr JcJrov/OYIkrdc2c5icMCWAm35aowr28TXNgSCpjHlXZ9ZQfYuYkM6PpTcigE2rXMcPL6OVqg9C2oj qr4dQnc5vzjj/NnJMckrdE26dhTNwrqbEu3j8i3d6sgW/nED4nhAKtQ8+GMWzA2cupj3dw3gY8b8XC EcIrFQX3ZuPU4Vxts30C77uc475HQdtJLza3sK04jbh96lcBwWAUWpYWZRsg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
support.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  5 +++++
 .../selftests/bpf/prog_tests/kfunc_call.c     | 18 ++++++++++------
 .../selftests/bpf/progs/kfunc_call_test.c     | 21 +++++++++++++++++++
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f49cb5fc85af..36c284464599 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -322,7 +322,7 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h
 
-LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
+LSKELS := fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
 # Generate both light skeleton and libbpf skeleton for these
 LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c
diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index b1ede6f0b821..f7fe596d2c7e 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -185,6 +185,11 @@ struct tcp_congestion_ops {
 	void *owner;
 };
 
+struct prog_test_ref_kfunc {
+	int a;
+	int b;
+} __attribute__((preserve_access_index));
+
 #define min(a, b) ((a) < (b) ? (a) : (b))
 #define max(a, b) ((a) > (b) ? (a) : (b))
 #define min_not_zero(x, y) ({			\
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 5c9c0176991b..358b905ea9b5 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -2,31 +2,37 @@
 /* Copyright (c) 2021 Facebook */
 #include <test_progs.h>
 #include <network_helpers.h>
-#include "kfunc_call_test.lskel.h"
+#include "kfunc_call_test.skel.h"
 #include "kfunc_call_test_subprog.skel.h"
 
 static void test_main(void)
 {
-	struct kfunc_call_test_lskel *skel;
+	struct kfunc_call_test *skel;
 	int prog_fd, retval, err;
 
-	skel = kfunc_call_test_lskel__open_and_load();
+	skel = kfunc_call_test__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel"))
 		return;
 
-	prog_fd = skel->progs.kfunc_call_test1.prog_fd;
+	prog_fd = bpf_program__fd(skel->progs.kfunc_call_test1);
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, (__u32 *)&retval, NULL);
 	ASSERT_OK(err, "bpf_prog_test_run(test1)");
 	ASSERT_EQ(retval, 12, "test1-retval");
 
-	prog_fd = skel->progs.kfunc_call_test2.prog_fd;
+	prog_fd = bpf_program__fd(skel->progs.kfunc_call_test2);
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, (__u32 *)&retval, NULL);
 	ASSERT_OK(err, "bpf_prog_test_run(test2)");
 	ASSERT_EQ(retval, 3, "test2-retval");
 
-	kfunc_call_test_lskel__destroy(skel);
+	prog_fd = bpf_program__fd(skel->progs.kfunc_call_test_ref_btf_id);
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, NULL);
+	ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
+	ASSERT_EQ(retval, 0, "test_ref_btf_id-retval");
+
+	kfunc_call_test__destroy(skel);
 }
 
 static void test_subprog(void)
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 8a8cf59017aa..045f157309b6 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -7,6 +7,8 @@
 extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksym;
 extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
 				  __u32 c, __u64 d) __ksym;
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(char *packet) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
 
 SEC("tc")
 int kfunc_call_test2(struct __sk_buff *skb)
@@ -44,4 +46,23 @@ int kfunc_call_test1(struct __sk_buff *skb)
 	return ret;
 }
 
+SEC("tc")
+int kfunc_call_test_ref_btf_id(struct __sk_buff *skb)
+{
+	struct bpf_sock_tuple tuple = {};
+	struct prog_test_ref_kfunc *pt;
+	struct nf_conn *ct = NULL;
+	char *p = &(char){0};
+	__u64 flags_err = 0;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(p);
+	if (pt) {
+		if (pt->a != 42 || pt->b != 108)
+			ret = -1;
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.33.1

