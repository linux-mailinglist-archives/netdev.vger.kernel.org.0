Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C505B576DD5
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiGPMUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 08:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiGPMUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 08:20:52 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C6E1AF38;
        Sat, 16 Jul 2022 05:20:50 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LlS1D2zrMz19TvR;
        Sat, 16 Jul 2022 20:18:08 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 20:20:47 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 20:20:46 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next 1/5] bpf: Unify memory address casting operation style
Date:   Sat, 16 Jul 2022 20:51:04 +0800
Message-ID: <20220716125108.1011206-2-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220716125108.1011206-1-pulehui@huawei.com>
References: <20220716125108.1011206-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory addresses are conceptually unsigned, (unsigned long) casting
makes more sense, so let's make a change for conceptual uniformity
and there is no functional change.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 kernel/bpf/core.c     | 2 +-
 kernel/bpf/helpers.c  | 6 +++---
 kernel/bpf/syscall.c  | 2 +-
 kernel/bpf/verifier.c | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index cfb8a50a9f12..e14b399dd408 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1954,7 +1954,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		CONT;							\
 	LDX_PROBE_MEM_##SIZEOP:						\
 		bpf_probe_read_kernel(&DST, sizeof(SIZE),		\
-				      (const void *)(long) (SRC + insn->off));	\
+				      (const void *)(unsigned long) (SRC + insn->off));	\
 		DST = *((SIZE *)&DST);					\
 		CONT;
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a1c84d256f83..92c01dd007a6 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -903,7 +903,7 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 					err = snprintf(tmp_buf,
 						       (tmp_buf_end - tmp_buf),
 						       "%pB",
-						       (void *)(long)raw_args[num_spec]);
+						       (void *)(unsigned long)raw_args[num_spec]);
 					tmp_buf += (err + 1);
 				}
 
@@ -929,7 +929,7 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 				goto out;
 			}
 
-			unsafe_ptr = (char *)(long)raw_args[num_spec];
+			unsafe_ptr = (char *)(unsigned long)raw_args[num_spec];
 			err = copy_from_kernel_nofault(cur_ip, unsafe_ptr,
 						       sizeof_cur_ip);
 			if (err < 0)
@@ -966,7 +966,7 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 				goto out;
 			}
 
-			unsafe_ptr = (char *)(long)raw_args[num_spec];
+			unsafe_ptr = (char *)(unsigned long)raw_args[num_spec];
 			err = bpf_trace_copy_string(tmp_buf, unsafe_ptr,
 						    fmt_ptype,
 						    tmp_buf_end - tmp_buf);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83c7136c5788..d1380473e620 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5108,7 +5108,7 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, union bpf_attr *, attr, u32, attr_size)
 			bpf_prog_put(prog);
 			return -EBUSY;
 		}
-		attr->test.retval = bpf_prog_run(prog, (void *) (long) attr->test.ctx_in);
+		attr->test.retval = bpf_prog_run(prog, (void *) (unsigned long) attr->test.ctx_in);
 		__bpf_prog_exit_sleepable(prog, 0 /* bpf_prog_run does runtime stats */, &run_ctx);
 		bpf_prog_put(prog);
 		return 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c59c3df0fea6..d91f17598833 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4445,7 +4445,7 @@ static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
 	err = map->ops->map_direct_value_addr(map, &addr, off);
 	if (err)
 		return err;
-	ptr = (void *)(long)addr + off;
+	ptr = (void *)(unsigned long)addr + off;
 
 	switch (size) {
 	case sizeof(u8):
@@ -6113,7 +6113,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			return err;
 		}
 
-		str_ptr = (char *)(long)(map_addr);
+		str_ptr = (char *)(unsigned long)(map_addr);
 		if (!strnchr(str_ptr + map_off, map->value_size - map_off, 0)) {
 			verbose(env, "string is not zero-terminated\n");
 			return -EINVAL;
@@ -7099,7 +7099,7 @@ static int check_bpf_snprintf_call(struct bpf_verifier_env *env,
 		verbose(env, "verifier bug\n");
 		return -EFAULT;
 	}
-	fmt = (char *)(long)fmt_addr + fmt_map_off;
+	fmt = (char *)(unsigned long)fmt_addr + fmt_map_off;
 
 	/* We are also guaranteed that fmt+fmt_map_off is NULL terminated, we
 	 * can focus on validating the format specifiers.
-- 
2.25.1

