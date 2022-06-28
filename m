Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787ED55EA2F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiF1Qu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242133AbiF1Qs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:48:26 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EBC15717
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:45:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u12-20020a05600c210c00b003a02b16d2b8so7948981wml.2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mo8doXYA9emrg3uQBgrdNC6baXQfzRLIjgAua2IloJE=;
        b=BnkiZnq4yE71oiRH6bWiyg0HKscyhulPRcQNetE++yj/npAp7DlRZp8GekQJX25kPh
         xOd6q1DmKVivBNw4UhwusQXj6FC5+CdZ2qm7llDnapiE/N2jv4pT5TyH2e/JgHzqokyC
         7SOcqbZGLaqp89QKoBYYPtCdma+fUwjZ85OVq3Md+hY0XVkf+LXbLZ0IShgIRRNebOs5
         jur0Pd1TVjEjJnj1A4HJkwqi43xj339pd6r8/zk+KJ+h2UbtMbG/WXXvMD5TE9cmF9X4
         6DbGE+9gcLE2yJDYzJRzj6N7uQhu2hYtLU0LrwL46p7xoX7dJg5bpUpKRzG5zA46oSMl
         0Asw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mo8doXYA9emrg3uQBgrdNC6baXQfzRLIjgAua2IloJE=;
        b=CuY/Xik4YyDNDeaAR/SBEW5MMgWOCcak5MT5RjK4daUIFYu4r7kMixFA5sus9kXohQ
         TfvtDuQg9fZNqXS4gjllu+vZBbir1USiLQgIhuvzkREBVy3fIyqeLh0fKMprzUNtPMHS
         7Ob0c/Xu7769/PGDQfK+XqTj3iRry951mS+KDzh1eK0t5PAl32BJ+WaV1ce3mTQ8xjsu
         0wQvg6Xt6gy7jHX/PmgDPjyduH+UYySR0MNpgGsbRGzKzx+TdfcHCK5HF/CuP1o9sSz2
         6++UnR3wXwdoyt+HVBZqQEWoySx3FFcVjVKEsvHubIyUfFXukaEiFnEb/Ih8agTnffVz
         7Ccw==
X-Gm-Message-State: AJIora/Fybn2AxBKghcAD5F3M4owAus+4jAdSIt6N0p0l7SA0vVNLlWG
        CMnhvJr+kfi23bzo4eQMk6S7Kw==
X-Google-Smtp-Source: AGRyM1tx8LtiV7j5ISfbHRGmE8XllPMXBpjzg4+mdg5OasURbqX1AWPtI+Cylpx6hUEotSiiyU7s+Q==
X-Received: by 2002:a05:600c:583:b0:39c:3637:b9f with SMTP id o3-20020a05600c058300b0039c36370b9fmr578011wmd.79.1656434739332;
        Tue, 28 Jun 2022 09:45:39 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id a2-20020adfbc42000000b0021ba1b6186csm15585151wrh.40.2022.06.28.09.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:45:38 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next] bpftool: Probe for memcg-based accounting before bumping rlimit
Date:   Tue, 28 Jun 2022 17:45:29 +0100
Message-Id: <20220628164529.80050-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpftool used to bump the memlock rlimit to make sure to be able to load
BPF objects. After the kernel has switched to memcg-based memory
accounting [0] in 5.11, bpftool has relied on libbpf to probe the system
for memcg-based accounting support and for raising the rlimit if
necessary [1]. But this was later reverted, because the probe would
sometimes fail, resulting in bpftool not being able to load all required
objects [2].

Here we add a more efficient probe, in bpftool itself. We first lower
the rlimit to 0, then we attempt to load a BPF object (and finally reset
the rlimit): if the load succeeds, then memcg-based memory accounting is
supported.

This approach was earlier proposed for the probe in libbpf itself [3],
but given that the library may be used in multithreaded applications,
the probe could have undesirable consequences if one thread attempts to
lock kernel memory while memlock rlimit is at 0. Since bpftool is
single-threaded and the rlimit is process-based, this is fine to do in
bpftool itself.

This probe was inspired by the similar one from the cilium/ebpf Go
library [4].

[0] commit 97306be45fbe ("Merge branch 'switch to memcg-based memory accounting'")
[1] commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
[2] commit 6b4384ff1088 ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"")
[3] https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/t/#u
[4] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39

Cc: Stanislav Fomichev <sdf@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/common.c   | 71 ++++++++++++++++++++++++++++++++++--
 tools/include/linux/kernel.h |  5 +++
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index a0d4acd7c54a..e07769802f76 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -13,14 +13,17 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <linux/limits.h>
-#include <linux/magic.h>
 #include <net/if.h>
 #include <sys/mount.h>
 #include <sys/resource.h>
 #include <sys/stat.h>
 #include <sys/vfs.h>
 
+#include <linux/filter.h>
+#include <linux/limits.h>
+#include <linux/magic.h>
+#include <linux/unistd.h>
+
 #include <bpf/bpf.h>
 #include <bpf/hashmap.h>
 #include <bpf/libbpf.h> /* libbpf_num_possible_cpus */
@@ -73,11 +76,73 @@ static bool is_bpffs(char *path)
 	return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
 }
 
+/* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
+ * memcg-based memory accounting for BPF maps and programs. This was done in
+ * commit 97306be45fbe ("Merge branch 'switch to memcg-based memory
+ * accounting'"), in Linux 5.11.
+ *
+ * Libbpf also offers to probe for memcg-based accounting vs rlimit, but does
+ * so by checking for the availability of a given BPF helper and this has
+ * failed on some kernels with backports in the past, see commit 6b4384ff1088
+ * ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"").
+ * Instead, we can probe by lowering the process-based rlimit to 0, trying to
+ * load a BPF object, and resetting the rlimit. If the load succeeds then
+ * memcg-based accounting is supported.
+ *
+ * This would be too dangerous to do in the library, because multithreaded
+ * applications might attempt to load items while the rlimit is at 0. Given
+ * that bpftool is single-threaded, this is fine to do here.
+ */
+static bool known_to_need_rlimit(void)
+{
+	const size_t prog_load_attr_sz = offsetofend(union bpf_attr, attach_btf_obj_fd);
+	struct bpf_insn insns[] = {
+		BPF_EXIT_INSN(),
+	};
+	struct rlimit rlim_init, rlim_cur_zero = {};
+	size_t insn_cnt = ARRAY_SIZE(insns);
+	union bpf_attr attr;
+	int prog_fd, err;
+
+	memset(&attr, 0, prog_load_attr_sz);
+	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+	attr.insns = ptr_to_u64(insns);
+	attr.insn_cnt = insn_cnt;
+	attr.license = ptr_to_u64("GPL");
+
+	if (getrlimit(RLIMIT_MEMLOCK, &rlim_init))
+		return false;
+
+	/* Drop the soft limit to zero. We maintain the hard limit to its
+	 * current value, because lowering it would be a permanent operation
+	 * for unprivileged users.
+	 */
+	rlim_cur_zero.rlim_max = rlim_init.rlim_max;
+	if (setrlimit(RLIMIT_MEMLOCK, &rlim_cur_zero))
+		return false;
+
+	/* Do not use bpf_prog_load() from libbpf here, because it calls
+	 * bump_rlimit_memlock(), interfering with the current probe.
+	 */
+	prog_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, prog_load_attr_sz);
+	err = errno;
+
+	/* reset soft rlimit to its initial value */
+	setrlimit(RLIMIT_MEMLOCK, &rlim_init);
+
+	if (prog_fd < 0)
+		return err == EPERM;
+
+	close(prog_fd);
+	return false;
+}
+
 void set_max_rlimit(void)
 {
 	struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
 
-	setrlimit(RLIMIT_MEMLOCK, &rinf);
+	if (known_to_need_rlimit())
+		setrlimit(RLIMIT_MEMLOCK, &rinf);
 }
 
 static int
diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index 4b0673bf52c2..5c90d65cc2d3 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -24,6 +24,11 @@
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
 
+#ifndef offsetofend
+# define offsetofend(TYPE, FIELD) \
+	(offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
+#endif
+
 #ifndef container_of
 /**
  * container_of - cast a member of a structure out to the containing structure
-- 
2.34.1

