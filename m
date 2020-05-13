Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1BC1D22A8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbgEMXEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731815AbgEMXEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:04:07 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E895C061A0C;
        Wed, 13 May 2020 16:04:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q24so11626128pjd.1;
        Wed, 13 May 2020 16:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R0TzPmISdcMqHvmE7QsPNNAq61zop0SzUXYI+ioXbng=;
        b=Mtv/fHeCMVTqBWpiQ/ba0qoZDU3J8WP8bU4k0O4NsJWKLXa/BdaD/yLaX7n3XMeomE
         2G1wycdGZPMKu2tN3bSRQapDn0L5LD//5ljbIVtmGwiabmD9cK6w8JCdde/4+hFZvjdA
         EnVJ3X2L/mA6ZOu9at4A0VSIt0VJpgdyFtvGEdg8c089b74n+dzPU+9yK5se+NnYQyu1
         dmn7l8Ns99iO7lg/dyrMmVcmJJd3aPheVcbCa7Tm156iyRphAbIBsbXqmTABSq1+4pkY
         TXeCjz3ALNQ4vKaEZ069HT9SaPR1zu5B6Wpi0O5uJSzEmz2Sqwe2R/GBo4Jzq64y6e6F
         E/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R0TzPmISdcMqHvmE7QsPNNAq61zop0SzUXYI+ioXbng=;
        b=azrkyLOs1+3vEx2SGsRywfjhPoDpID2/7es/2k2HyRBRp34TbVejJdnkvuuN1Gjlvg
         Px2JX6eD2UYbj2ZigAM239ZFvJ50H3ZbEKwXEfVVqMJcqdgv3cDeK2SjdsKoFCuv9PDI
         8v0FzYKc30+pKSch2Ek5QsSdtP1151leReLdxdeQk9w6Q5+/IxpQr35hEGZcx/dX2yX1
         +o1uYWBwzZp8lj88JBYwtAzz4iPg67wyenv+8dWcvh8g7DGCYbgzpUwAKsm1XOj5R0sV
         sLRWy0ubi1tnkY/DZrLwO6FUaOCC0AuWrz5xX4iHSqVpsfujH4tYw3TJXLEzxqYznLvV
         XqQA==
X-Gm-Message-State: AOAM530JYXCVISTE2QlvDgTwMJ9XXPg9r/CeaWUalo0a+vcaUc/rG2Xc
        hMtRTbLgsa5d60eH48V4iE0=
X-Google-Smtp-Source: ABdhPJy8d74W314xU44j8ltm3INfBBRpO+kpR01K1UhKLb/PqrVgij7tmpeT22Y72nTxohj5B55asw==
X-Received: by 2002:a17:902:261:: with SMTP id 88mr1425932plc.152.1589411045765;
        Wed, 13 May 2020 16:04:05 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id t23sm16558706pji.32.2020.05.13.16.04.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 16:04:04 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v7 bpf-next 3/3] selftests/bpf: use CAP_BPF and CAP_PERFMON in tests
Date:   Wed, 13 May 2020 16:03:55 -0700
Message-Id: <20200513230355.7858-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200513230355.7858-1-alexei.starovoitov@gmail.com>
References: <20200513230355.7858-1-alexei.starovoitov@gmail.com>
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

