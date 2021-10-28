Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FCC43DB40
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhJ1Gho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhJ1Ghm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:42 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086AAC061767;
        Wed, 27 Oct 2021 23:35:16 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so4753288pjd.1;
        Wed, 27 Oct 2021 23:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rJhgAD0aJ6BrK0y6oSJnMpFug1HLoXQXHQWvDMmCfag=;
        b=d6KSouPnypJLNsORDhd4oZJXzoilNzlUEcl5n0umYBR4BwS3X3oRuqKXkrf531SF1U
         vWk0NEiv6eJTcpd4a9bdUxoqu0bt6Nnx0UFzWQLF3imfjYZ4TIk6qk/F96/FkS9Vl4r1
         s7HFMgmozEmHpDynla3EeNxbZPaSJ3dDyT81VcPyatW7mWhamc/wLvxoOzXcjxiKBvXK
         9IN1vPoh9a2naqBt+f5QeHPFWqwe1lB8XFxWCybmRVyFVeSVItBKC25jWgUgnLCXgg8+
         h6MMU+IqPNHnfE8hrW5fUpTwIMiDl3IAREVPpScapNCHRkZ6xkCnrGOte3obJbuBHDQn
         Zx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJhgAD0aJ6BrK0y6oSJnMpFug1HLoXQXHQWvDMmCfag=;
        b=6lGFc2dNro6644uQTtrppkIsa6p3ADB8CJZtwbSaZv0Azh0dG4y68DZLlJ3NJlHYS3
         ZIVTSSpNCTxI75ug7V+rqV1HhgALKfb6oxsQR503lDBciR7feYSyN8PwZpexxHoVNWsD
         QFAmn+5gRHrbeNGk9tR1RB6q9+j4PlJS3paLD/C/JYlH9R2KnGmejjJ853oqburv7Sj5
         4pn6pUW3ZNzG+qTsuKgNvSEFhSvJG2xbK18UB4FRp0HdKccLomHbX8QpfuE0+yMzOjnV
         IKkHyg/vCfIzvB85+xzo/Gz0x7teLGm3Lum/FZaw4ju4CWghw24tu66pAxPUYxb3PhEV
         fCgQ==
X-Gm-Message-State: AOAM531EinijiGfeMiLGYAPk4xf4id9l5NO/Ulsjcm/3iOSpfyd8YNtl
        16y3Vn6AuytGZyje9PWiN1kl9xpqsw67zg==
X-Google-Smtp-Source: ABdhPJwklKTFL17Psg+wMXR1L5GIF/htH2m8obp6MLckG+lElbU6yWVRP0fXaUKSr9dqlLqvPjNb9A==
X-Received: by 2002:a17:90b:1a85:: with SMTP id ng5mr10960970pjb.43.1635402915369;
        Wed, 27 Oct 2021 23:35:15 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id j14sm7194073pjd.53.2021.10.27.23.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:15 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 4/8] libbpf: Ensure that BPF syscall fds are never 0, 1, or 2
Date:   Thu, 28 Oct 2021 12:04:57 +0530
Message-Id: <20211028063501.2239335-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6632; h=from:subject; bh=kaAikty7BZzVHLo4b3rme93i/LdaBKbRXmuRQ6seRf0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR/GMbBeRoF4x+f/ANWRj+JFKbmFXfMz7zMihl8 /2iht6CJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfwAKCRBM4MiGSL8RyhgREA CafMebatEv7sjM5eNE/Ko2nlbGO2vokMT0jtHVUBqBlk8HXNlzrJ6AXZZ/vmFYlm4DlTxpk7b7QYvi EvMkXZbsHcNRNliWgtNqoZhhYXWHdYpepiXYa/E01ujUXzYhphWle6hQXXrrgSNC9a/emjOM4Lu3pB SnUKrFC1pls2NWyU5GbAkpecHM4a/XANinT2a1PuaHpSAQNMwQYRCdXRtywA5AblSMH+//V88z4bHF AcWLIlrcIn3Fm3EekfdR8pFGNfGZPxqpaJ3nUmpmLXJRYC3jrwcdbvxtpg0vRTJpg6Otbft1RkBP4j La8o/at9yOc3RnaurzVGfQEqom6+VeAHEJ8bAMmNJu54Hbg8jbHmNevmAyZK9o3DCzGhuJ0OjtIZth XbGJhIP4ao7MWAttZmJ1Ip5psjlBgMezBgOgBPrnKKG9eP0y1LJ0FFbD86lcWZOu8uDZX258lJ7+5f w4n1Fztfd6H2ePjMq9SKwfKIa2SDR19Qcq+2mVNeukW6M5NaENAN+Wej092WES9Hr/LtDfmOyRWUyo 0ov+q2PGb74SrSFDnUZioKhrOtfddSx38ZXZTfwv+obXKHkkbaNjbCZajrYO08D7wR14aWq/wRdtgu TxXNxvHuze7JtBDBEWS75e6OswuYm8zJfH1bJ9+PmC4PA4BGrB3dwdWE7dGA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple wrapper for passing an fd and getting a new one >= 3 if it
is one of 0, 1, or 2. There are two primary reasons to make this change:
First, libbpf relies on the assumption a certain BPF fd is never 0 (e.g.
most recently noticed in [0]). Second, Alexei pointed out in [1] that
some environments reset stdin, stdout, and stderr if they notice an
invalid fd at these numbers. To protect against both these cases, switch
all internal BPF syscall wrappers in libbpf to always return an fd >= 3.
We only need to modify the syscall wrappers and not other code that
assumes a valid fd by doing >= 0, to avoid pointless churn, and because
it is still a valid assumption. The cost paid is two additional syscalls
if fd is in range [0, 2].

  [0]: e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")
  [1]: https://lore.kernel.org/bpf/CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c             | 35 +++++++++++++++++++++------------
 tools/lib/bpf/libbpf_internal.h | 24 ++++++++++++++++++++++
 2 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 7d1741ceaa32..53efbdb1b652 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -65,13 +65,22 @@ static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
 	return syscall(__NR_bpf, cmd, attr, size);
 }
 
+static inline int sys_bpf_fd(enum bpf_cmd cmd, union bpf_attr *attr,
+			     unsigned int size)
+{
+	int fd;
+
+	fd = sys_bpf(cmd, attr, size);
+	return ensure_good_fd(fd);
+}
+
 static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
 {
 	int retries = 5;
 	int fd;
 
 	do {
-		fd = sys_bpf(BPF_PROG_LOAD, attr, size);
+		fd = sys_bpf_fd(BPF_PROG_LOAD, attr, size);
 	} while (fd < 0 && errno == EAGAIN && retries-- > 0);
 
 	return fd;
@@ -103,7 +112,7 @@ int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
 	else
 		attr.inner_map_fd = create_attr->inner_map_fd;
 
-	fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_MAP_CREATE, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -181,7 +190,7 @@ int bpf_create_map_in_map_node(enum bpf_map_type map_type, const char *name,
 		attr.numa_node = node;
 	}
 
-	fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_MAP_CREATE, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -609,7 +618,7 @@ int bpf_obj_get(const char *pathname)
 	memset(&attr, 0, sizeof(attr));
 	attr.pathname = ptr_to_u64((void *)pathname);
 
-	fd = sys_bpf(BPF_OBJ_GET, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_OBJ_GET, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -720,7 +729,7 @@ int bpf_link_create(int prog_fd, int target_fd,
 		break;
 	}
 proceed:
-	fd = sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_LINK_CREATE, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -763,7 +772,7 @@ int bpf_iter_create(int link_fd)
 	memset(&attr, 0, sizeof(attr));
 	attr.iter_create.link_fd = link_fd;
 
-	fd = sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_ITER_CREATE, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -921,7 +930,7 @@ int bpf_prog_get_fd_by_id(__u32 id)
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_id = id;
 
-	fd = sys_bpf(BPF_PROG_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_PROG_GET_FD_BY_ID, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -933,7 +942,7 @@ int bpf_map_get_fd_by_id(__u32 id)
 	memset(&attr, 0, sizeof(attr));
 	attr.map_id = id;
 
-	fd = sys_bpf(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -945,7 +954,7 @@ int bpf_btf_get_fd_by_id(__u32 id)
 	memset(&attr, 0, sizeof(attr));
 	attr.btf_id = id;
 
-	fd = sys_bpf(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -957,7 +966,7 @@ int bpf_link_get_fd_by_id(__u32 id)
 	memset(&attr, 0, sizeof(attr));
 	attr.link_id = id;
 
-	fd = sys_bpf(BPF_LINK_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_LINK_GET_FD_BY_ID, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -988,7 +997,7 @@ int bpf_raw_tracepoint_open(const char *name, int prog_fd)
 	attr.raw_tracepoint.name = ptr_to_u64(name);
 	attr.raw_tracepoint.prog_fd = prog_fd;
 
-	fd = sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
@@ -1008,7 +1017,7 @@ int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_s
 		attr.btf_log_buf = ptr_to_u64(log_buf);
 	}
 
-	fd = sys_bpf(BPF_BTF_LOAD, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_BTF_LOAD, &attr, sizeof(attr));
 
 	if (fd < 0 && !do_log && log_buf && log_buf_size) {
 		do_log = true;
@@ -1050,7 +1059,7 @@ int bpf_enable_stats(enum bpf_stats_type type)
 	memset(&attr, 0, sizeof(attr));
 	attr.enable_stats.type = type;
 
-	fd = sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
+	fd = sys_bpf_fd(BPF_ENABLE_STATS, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 13bc7950e304..14f135808f5c 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -13,6 +13,8 @@
 #include <limits.h>
 #include <errno.h>
 #include <linux/err.h>
+#include <fcntl.h>
+#include <unistd.h>
 #include "libbpf_legacy.h"
 #include "relo_core.h"
 
@@ -468,4 +470,26 @@ static inline bool is_ldimm64_insn(struct bpf_insn *insn)
 	return insn->code == (BPF_LD | BPF_IMM | BPF_DW);
 }
 
+/* if fd is stdin, stdout, or stderr, dup to a fd greater than 2
+ * Takes ownership of the fd passed in, and closes it if calling
+ * fcntl(fd, F_DUPFD_CLOEXEC, 3).
+ */
+static inline int ensure_good_fd(int fd)
+{
+	int old_fd = fd, saved_errno;
+
+	if (fd < 0)
+		return fd;
+	if (fd < 3) {
+		fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
+		saved_errno = errno;
+		close(old_fd);
+		if (fd < 0) {
+			pr_warn("failed to dup FD %d to FD > 2: %d\n", old_fd, -saved_errno);
+			errno = saved_errno;
+		}
+	}
+	return fd;
+}
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
-- 
2.33.1

