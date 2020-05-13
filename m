Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895D71D056B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgEMDTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:19:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A29C061A0C;
        Tue, 12 May 2020 20:19:40 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ms17so10358711pjb.0;
        Tue, 12 May 2020 20:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R0TzPmISdcMqHvmE7QsPNNAq61zop0SzUXYI+ioXbng=;
        b=m1XO5mxslURrro2xDkImVCnVlRplMfM+enLWR67RSp3PIZUaX2YT8liGKmoDH4vBMw
         Ixg/1kNOsSL66mMmln86ePv6CtT137OQIvyJU42ldiPLUHk/fuVoujWiDkhH8lCaPw14
         7F9FNPQip6I0tgLmT30KhUDrkyt9p0wuXy4T9EPXvBavvjziq6S3/rIHFSInTTc7wQ8D
         ud6uywGFhkxzLcBci9wY2OfaED8LW0my1zWbz/q9fsE/nzp6Azu5fDqMOxzJa3iHecuk
         a1sXbIpCzECUW5fpAxXvQxhStFmmkECecgjIBlbY2riDg5ps3W1uLTmDz3QQHQoEmPbm
         3ZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R0TzPmISdcMqHvmE7QsPNNAq61zop0SzUXYI+ioXbng=;
        b=GpYThIjKlyI6CCPxVeQKOAdrH1WLo2xXmMtgaJ/XUwzXG/jquVeA/hOovh+GA1zkLd
         DWEaHnAq1H2KVgugVHJSrLHbbJj4yaVZMqSOgacqKBHBA7H0g6KGAqckzwYNH8UvBZt1
         npM6HpEv8lSfhz9sGdZZev3qnLYQkJmpIFeCEsb15ogprRmXG++FNWD9x2Ppun16i0IV
         QFxCGAGjQ9/1KFLeKTwnX03mamz2XEEe5jFu/UJzZleWLtc8SvZkcW3WU/egAZXtXG0k
         qumKlY4nFbTXOTwmlZLzu/h9jTiCUsv7xndMxkxFcwdnSuP1rjdK5OhWL7OstYQD/EhX
         8oJQ==
X-Gm-Message-State: AOAM532HirD+w8lnEXkc6DWzna+AFJ2MidI0P6M9BDGMyH4pn7qZNmgg
        /Gt43s8zi+mLhgGyeqgXX9w=
X-Google-Smtp-Source: ABdhPJzQUN9JMObiYqz/LAY1VVfOLFifvtStU+SlsmqmHblRaaQ1XCaEW46YHmx8u6X9S88LlUJvPQ==
X-Received: by 2002:a17:90a:bb81:: with SMTP id v1mr1060930pjr.168.1589339979775;
        Tue, 12 May 2020 20:19:39 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.1])
        by smtp.gmail.com with ESMTPSA id f70sm13206415pfa.17.2020.05.12.20.19.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 20:19:39 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v6 bpf-next 3/3] selftests/bpf: use CAP_BPF and CAP_PERFMON in tests
Date:   Tue, 12 May 2020 20:19:30 -0700
Message-Id: <20200513031930.86895-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
References: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Make all test_verifier test exercise CAP_BPF and CAP_PERFMON

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c   | 44 +++++++++++++++----
 tools/testing/selftests/bpf/verifier/calls.c  | 16 +++----
 .../selftests/bpf/verifier/dead_code.c        | 10 ++---
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 21a1ce219c1c..78a6bae56ea6 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -818,10 +818,18 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 }
 
+struct libcap {
+	struct __user_cap_header_struct hdr;
+	struct __user_cap_data_struct data[2];
+};
+
 static int set_admin(bool admin)
 {
 	cap_t caps;
-	const cap_value_t cap_val = CAP_SYS_ADMIN;
+	/* need CAP_BPF, CAP_NET_ADMIN, CAP_PERFMON to load progs */
+	const cap_value_t cap_net_admin = CAP_NET_ADMIN;
+	const cap_value_t cap_sys_admin = CAP_SYS_ADMIN;
+	struct libcap *cap;
 	int ret = -1;
 
 	caps = cap_get_proc();
@@ -829,11 +837,26 @@ static int set_admin(bool admin)
 		perror("cap_get_proc");
 		return -1;
 	}
-	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
+	cap = (struct libcap *)caps;
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_sys_admin, CAP_CLEAR)) {
+		perror("cap_set_flag clear admin");
+		goto out;
+	}
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_admin,
 				admin ? CAP_SET : CAP_CLEAR)) {
-		perror("cap_set_flag");
+		perror("cap_set_flag set_or_clear net");
 		goto out;
 	}
+	/* libcap is likely old and simply ignores CAP_BPF and CAP_PERFMON,
+	 * so update effective bits manually
+	 */
+	if (admin) {
+		cap->data[1].effective |= 1 << (38 /* CAP_PERFMON */ - 32);
+		cap->data[1].effective |= 1 << (39 /* CAP_BPF */ - 32);
+	} else {
+		cap->data[1].effective &= ~(1 << (38 - 32));
+		cap->data[1].effective &= ~(1 << (39 - 32));
+	}
 	if (cap_set_proc(caps)) {
 		perror("cap_set_proc");
 		goto out;
@@ -1067,9 +1090,11 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 
 static bool is_admin(void)
 {
+	cap_flag_value_t net_priv = CAP_CLEAR;
+	bool perfmon_priv = false;
+	bool bpf_priv = false;
+	struct libcap *cap;
 	cap_t caps;
-	cap_flag_value_t sysadmin = CAP_CLEAR;
-	const cap_value_t cap_val = CAP_SYS_ADMIN;
 
 #ifdef CAP_IS_SUPPORTED
 	if (!CAP_IS_SUPPORTED(CAP_SETFCAP)) {
@@ -1082,11 +1107,14 @@ static bool is_admin(void)
 		perror("cap_get_proc");
 		return false;
 	}
-	if (cap_get_flag(caps, cap_val, CAP_EFFECTIVE, &sysadmin))
-		perror("cap_get_flag");
+	cap = (struct libcap *)caps;
+	bpf_priv = cap->data[1].effective & (1 << (39/* CAP_BPF */ - 32));
+	perfmon_priv = cap->data[1].effective & (1 << (38/* CAP_PERFMON */ - 32));
+	if (cap_get_flag(caps, CAP_NET_ADMIN, CAP_EFFECTIVE, &net_priv))
+		perror("cap_get_flag NET");
 	if (cap_free(caps))
 		perror("cap_free");
-	return (sysadmin == CAP_SET);
+	return bpf_priv && perfmon_priv && net_priv == CAP_SET;
 }
 
 static void get_unpriv_disabled()
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 2d752c4f8d9d..7629a0cebb9b 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -19,7 +19,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 2),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 1,
@@ -315,7 +315,7 @@
 	BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "allowed for root only",
+	.errstr_unpriv = "allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = POINTER_VALUE,
@@ -346,7 +346,7 @@
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_2),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "allowed for root only",
+	.errstr_unpriv = "allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = TEST_DATA_LEN + TEST_DATA_LEN - ETH_HLEN - ETH_HLEN,
@@ -397,7 +397,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 1),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.fixup_map_hash_48b = { 3 },
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
@@ -1064,7 +1064,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "allowed for root only",
+	.errstr_unpriv = "allowed for",
 	.result_unpriv = REJECT,
 	.errstr = "R0 !read_ok",
 	.result = REJECT,
@@ -1977,7 +1977,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
@@ -2003,7 +2003,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.errstr = "!read_ok",
 	.result = REJECT,
 },
@@ -2028,7 +2028,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.errstr = "!read_ok",
 	.result = REJECT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/dead_code.c b/tools/testing/selftests/bpf/verifier/dead_code.c
index 50a8a63be4ac..5cf361d8eb1c 100644
--- a/tools/testing/selftests/bpf/verifier/dead_code.c
+++ b/tools/testing/selftests/bpf/verifier/dead_code.c
@@ -85,7 +85,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 12),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 7,
@@ -103,7 +103,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 12),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 7,
@@ -121,7 +121,7 @@
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, -5),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 7,
@@ -137,7 +137,7 @@
 	BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
@@ -152,7 +152,7 @@
 	BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "function calls to other bpf functions are allowed for root only",
+	.errstr_unpriv = "function calls to other bpf functions are allowed for",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
-- 
2.23.0

