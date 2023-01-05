Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B520465E34E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 04:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjAEDPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 22:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjAEDPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 22:15:40 -0500
X-Greylist: delayed 409 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 Jan 2023 19:15:34 PST
Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C4F11178;
        Wed,  4 Jan 2023 19:15:34 -0800 (PST)
X-QQ-mid: bizesmtp82t1672888002tl8q9hny
Received: from localhost.localdomain ( [1.202.165.115])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 05 Jan 2023 11:06:39 +0800 (CST)
X-QQ-SSF: 01000000000000304000000A0000000
X-QQ-FEAT: mcZpNrjn0f81bkevW6+IRQCQqZpwMl2AY8Ejyyd01F00Kk1wdXt8WarfMrNha
        UI/6MZeMLodfqdEBApVdr6NVAXR92MaLhnfs9Gmrmz+KW0Zyq1nvL0mqV7nB6q1OC4vuf/E
        8kTCCA+hvHfbYF0U7fMdw+sK7Xv93nfTQFKL6qCyYNDjkOZHWZT5jPqS/+4x2r8baEHr0n1
        NcaQt9b2TO7IPJgb5EBqq1z9fPsyxKV5SRG6F1p8SQcAi8NX86i2Jmf2HsKXiPyqo3TPcq1
        OHTHoRllnFvDIzOc6RcSEZ3xJpMCbNfXZjoxeuICSRnwoMZZYbALlZBlZnAx2AKxqhp3U+S
        fT0WV5+d1eSLNBqyn8Hxua2s1TKu1JfRxMBiAw8Zcd7yULOp7+s4UsKENHF8A==
X-QQ-GoodBg: 0
From:   tong@infragraf.org
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.or, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org
Cc:     Tonghao Zhang <tong@infragraf.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Hou Tao <houtao1@huawei.com>
Subject: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
Date:   Thu,  5 Jan 2023 11:06:14 +0800
Message-Id: <20230105030614.26842-1-tong@infragraf.org>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:infragraf.org:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <tong@infragraf.org>

The x86_64 can't dump the valid insn in this way. A test BPF prog
which include subprog:

$ llvm-objdump -d subprog.o
Disassembly of section .text:
0000000000000000 <subprog>:
       0:       18 01 00 00 73 75 62 70 00 00 00 00 72 6f 67 00 r1 = 29114459903653235 ll
       2:       7b 1a f8 ff 00 00 00 00 *(u64 *)(r10 - 8) = r1
       3:       bf a1 00 00 00 00 00 00 r1 = r10
       4:       07 01 00 00 f8 ff ff ff r1 += -8
       5:       b7 02 00 00 08 00 00 00 r2 = 8
       6:       85 00 00 00 06 00 00 00 call 6
       7:       95 00 00 00 00 00 00 00 exit
Disassembly of section raw_tp/sys_enter:
0000000000000000 <entry>:
       0:       85 10 00 00 ff ff ff ff call -1
       1:       b7 00 00 00 00 00 00 00 r0 = 0
       2:       95 00 00 00 00 00 00 00 exit

kernel print message:
[  580.775387] flen=8 proglen=51 pass=3 image=ffffffffa000c20c from=kprobe-load pid=1643
[  580.777236] JIT code: 00000000: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
[  580.779037] JIT code: 00000010: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
[  580.780767] JIT code: 00000020: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
[  580.782568] JIT code: 00000030: cc cc cc

$ bpf_jit_disasm
51 bytes emitted from JIT compiler (pass:3, flen:8)
ffffffffa000c20c + <x>:
   0:   int3
   1:   int3
   2:   int3
   3:   int3
   4:   int3
   5:   int3
   ...

Until bpf_jit_binary_pack_finalize is invoked, we copy rw_header to header
and then image/insn is valid. BTW, we can use the "bpftool prog dump" JITed instructions.

Signed-off-by: Tonghao Zhang <tong@infragraf.org>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Hou Tao <houtao1@huawei.com>
---
 Documentation/admin-guide/sysctl/net.rst |   1 +
 Documentation/networking/filter.rst      |  98 +------
 arch/arm/net/bpf_jit_32.c                |   4 -
 arch/arm64/net/bpf_jit_comp.c            |   4 -
 arch/loongarch/net/bpf_jit.c             |   4 -
 arch/mips/net/bpf_jit_comp.c             |   3 -
 arch/powerpc/net/bpf_jit_comp.c          |  11 -
 arch/riscv/net/bpf_jit_core.c            |   3 -
 arch/s390/net/bpf_jit_comp.c             |   4 -
 arch/sparc/net/bpf_jit_comp_32.c         |   3 -
 arch/sparc/net/bpf_jit_comp_64.c         |  13 -
 arch/x86/net/bpf_jit_comp.c              |   3 -
 arch/x86/net/bpf_jit_comp32.c            |   3 -
 net/core/sysctl_net_core.c               |  12 +-
 tools/bpf/.gitignore                     |   1 -
 tools/bpf/Makefile                       |  10 +-
 tools/bpf/bpf_jit_disasm.c               | 332 -----------------------
 17 files changed, 9 insertions(+), 500 deletions(-)
 delete mode 100644 tools/bpf/bpf_jit_disasm.c

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 6394f5dc2303..82ca05ca6ed0 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -88,6 +88,7 @@ Values:
 	- 0 - disable the JIT (default value)
 	- 1 - enable the JIT
 	- 2 - enable the JIT and ask the compiler to emit traces on kernel log.
+              (deprecated since v6.3, use ``bpftool prog dump jited id <id>`` instead)
 
 bpf_jit_harden
 --------------
diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index f69da5074860..5f51c050e88f 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -520,102 +520,8 @@ been previously enabled by root::
 
   echo 1 > /proc/sys/net/core/bpf_jit_enable
 
-For JIT developers, doing audits etc, each compile run can output the generated
-opcode image into the kernel log via::
-
-  echo 2 > /proc/sys/net/core/bpf_jit_enable
-
-Example output from dmesg::
-
-    [ 3389.935842] flen=6 proglen=70 pass=3 image=ffffffffa0069c8f
-    [ 3389.935847] JIT code: 00000000: 55 48 89 e5 48 83 ec 60 48 89 5d f8 44 8b 4f 68
-    [ 3389.935849] JIT code: 00000010: 44 2b 4f 6c 4c 8b 87 d8 00 00 00 be 0c 00 00 00
-    [ 3389.935850] JIT code: 00000020: e8 1d 94 ff e0 3d 00 08 00 00 75 16 be 17 00 00
-    [ 3389.935851] JIT code: 00000030: 00 e8 28 94 ff e0 83 f8 01 75 07 b8 ff ff 00 00
-    [ 3389.935852] JIT code: 00000040: eb 02 31 c0 c9 c3
-
-When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set to 1 and
-setting any other value than that will return in failure. This is even the case for
-setting bpf_jit_enable to 2, since dumping the final JIT image into the kernel log
-is discouraged and introspection through bpftool (under tools/bpf/bpftool/) is the
-generally recommended approach instead.
-
-In the kernel source tree under tools/bpf/, there's bpf_jit_disasm for
-generating disassembly out of the kernel log's hexdump::
-
-	# ./bpf_jit_disasm
-	70 bytes emitted from JIT compiler (pass:3, flen:6)
-	ffffffffa0069c8f + <x>:
-	0:	push   %rbp
-	1:	mov    %rsp,%rbp
-	4:	sub    $0x60,%rsp
-	8:	mov    %rbx,-0x8(%rbp)
-	c:	mov    0x68(%rdi),%r9d
-	10:	sub    0x6c(%rdi),%r9d
-	14:	mov    0xd8(%rdi),%r8
-	1b:	mov    $0xc,%esi
-	20:	callq  0xffffffffe0ff9442
-	25:	cmp    $0x800,%eax
-	2a:	jne    0x0000000000000042
-	2c:	mov    $0x17,%esi
-	31:	callq  0xffffffffe0ff945e
-	36:	cmp    $0x1,%eax
-	39:	jne    0x0000000000000042
-	3b:	mov    $0xffff,%eax
-	40:	jmp    0x0000000000000044
-	42:	xor    %eax,%eax
-	44:	leaveq
-	45:	retq
-
-	Issuing option `-o` will "annotate" opcodes to resulting assembler
-	instructions, which can be very useful for JIT developers:
-
-	# ./bpf_jit_disasm -o
-	70 bytes emitted from JIT compiler (pass:3, flen:6)
-	ffffffffa0069c8f + <x>:
-	0:	push   %rbp
-		55
-	1:	mov    %rsp,%rbp
-		48 89 e5
-	4:	sub    $0x60,%rsp
-		48 83 ec 60
-	8:	mov    %rbx,-0x8(%rbp)
-		48 89 5d f8
-	c:	mov    0x68(%rdi),%r9d
-		44 8b 4f 68
-	10:	sub    0x6c(%rdi),%r9d
-		44 2b 4f 6c
-	14:	mov    0xd8(%rdi),%r8
-		4c 8b 87 d8 00 00 00
-	1b:	mov    $0xc,%esi
-		be 0c 00 00 00
-	20:	callq  0xffffffffe0ff9442
-		e8 1d 94 ff e0
-	25:	cmp    $0x800,%eax
-		3d 00 08 00 00
-	2a:	jne    0x0000000000000042
-		75 16
-	2c:	mov    $0x17,%esi
-		be 17 00 00 00
-	31:	callq  0xffffffffe0ff945e
-		e8 28 94 ff e0
-	36:	cmp    $0x1,%eax
-		83 f8 01
-	39:	jne    0x0000000000000042
-		75 07
-	3b:	mov    $0xffff,%eax
-		b8 ff ff 00 00
-	40:	jmp    0x0000000000000044
-		eb 02
-	42:	xor    %eax,%eax
-		31 c0
-	44:	leaveq
-		c9
-	45:	retq
-		c3
-
-For BPF JIT developers, bpf_jit_disasm, bpf_asm and bpf_dbg provides a useful
-toolchain for developing and testing the kernel's JIT compiler.
+For JIT developers, doing audits etc, should use `bpftool prog dump` to
+veiw the JIT generated opcode image.
 
 BPF kernel internals
 --------------------
diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 6a1c9fca5260..39301d59b537 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1999,10 +1999,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	}
 	flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
 
-	if (bpf_jit_enable > 1)
-		/* there are 2 passes here */
-		bpf_jit_dump(prog->len, image_size, 2, ctx.target);
-
 	bpf_jit_binary_lock_ro(header);
 	prog->bpf_func = (void *)ctx.target;
 	prog->jited = 1;
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 62f805f427b7..59c35b4d77b7 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1567,10 +1567,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		goto out_off;
 	}
 
-	/* And we're done. */
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, prog_size, 2, ctx.image);
-
 	bpf_flush_icache(header, ctx.image + ctx.idx);
 
 	if (!prog->is_func || extra_pass) {
diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index bdcd0c7719a9..ea37f52faa6e 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1123,10 +1123,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		goto out_offset;
 	}
 
-	/* And we're done */
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, image_size, 2, ctx.image);
-
 	/* Update the icache */
 	flush_icache_range((unsigned long)header, (unsigned long)(ctx.image + ctx.idx));
 
diff --git a/arch/mips/net/bpf_jit_comp.c b/arch/mips/net/bpf_jit_comp.c
index b17130d510d4..ccbb7c231cb0 100644
--- a/arch/mips/net/bpf_jit_comp.c
+++ b/arch/mips/net/bpf_jit_comp.c
@@ -1012,9 +1012,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	flush_icache_range((unsigned long)header,
 			   (unsigned long)&ctx.target[ctx.jit_index]);
 
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, image_size, 2, ctx.target);
-
 	prog->bpf_func = (void *)ctx.target;
 	prog->jited = 1;
 	prog->jited_len = image_size;
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 43e634126514..f0f7d8ff2022 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -262,20 +262,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 			goto out_addrs;
 		}
 		bpf_jit_build_epilogue(code_base, &cgctx);
-
-		if (bpf_jit_enable > 1)
-			pr_info("Pass %d: shrink = %d, seen = 0x%x\n", pass,
-				proglen - (cgctx.idx * 4), cgctx.seen);
 	}
 
 skip_codegen_passes:
-	if (bpf_jit_enable > 1)
-		/*
-		 * Note that we output the base address of the code_base
-		 * rather than image, since opcodes are in code_base.
-		 */
-		bpf_jit_dump(flen, proglen, pass, code_base);
-
 #ifdef CONFIG_PPC64_ELF_ABI_V1
 	/* Function descriptor nastiness: Address + TOC */
 	((u64 *)image)[0] = (u64)code_base;
diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 737baf8715da..ff168c50d46a 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -151,9 +151,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	}
 	bpf_jit_build_epilogue(ctx);
 
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, prog_size, pass, ctx->insns);
-
 	prog->bpf_func = (void *)ctx->insns;
 	prog->jited = 1;
 	prog->jited_len = prog_size;
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index af35052d06ed..13d996e27602 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1831,10 +1831,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		fp = orig_fp;
 		goto free_addrs;
 	}
-	if (bpf_jit_enable > 1) {
-		bpf_jit_dump(fp->len, jit.size, pass, jit.prg_buf);
-		print_fn_code(jit.prg_buf, jit.size_prg);
-	}
 	if (!fp->is_func || extra_pass) {
 		bpf_jit_binary_lock_ro(header);
 	} else {
diff --git a/arch/sparc/net/bpf_jit_comp_32.c b/arch/sparc/net/bpf_jit_comp_32.c
index a74e5004c6c8..08de0ed84831 100644
--- a/arch/sparc/net/bpf_jit_comp_32.c
+++ b/arch/sparc/net/bpf_jit_comp_32.c
@@ -743,9 +743,6 @@ cond_branch:			f_offset = addrs[i + filter[i].jf];
 		oldproglen = proglen;
 	}
 
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(flen, proglen, pass + 1, image);
-
 	if (image) {
 		fp->bpf_func = (void *)image;
 		fp->jited = 1;
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index fa0759bfe498..14c9e5ce4100 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1549,16 +1549,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		}
 		build_epilogue(&ctx);
 
-		if (bpf_jit_enable > 1)
-			pr_info("Pass %d: size = %u, seen = [%c%c%c%c%c%c]\n", pass,
-				ctx.idx * 4,
-				ctx.tmp_1_used ? '1' : ' ',
-				ctx.tmp_2_used ? '2' : ' ',
-				ctx.tmp_3_used ? '3' : ' ',
-				ctx.saw_frame_pointer ? 'F' : ' ',
-				ctx.saw_call ? 'C' : ' ',
-				ctx.saw_tail_call ? 'T' : ' ');
-
 		if (ctx.idx * 4 == prev_image_size)
 			break;
 		prev_image_size = ctx.idx * 4;
@@ -1596,9 +1586,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		goto out_off;
 	}
 
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, image_size, pass, ctx.image);
-
 	bpf_flush_icache(header, (u8 *)header + header->size);
 
 	if (!prog->is_func || extra_pass) {
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index e3e2b57e4e13..197ff8651a56 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2551,9 +2551,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		cond_resched();
 	}
 
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, proglen, pass + 1, image);
-
 	if (image) {
 		if (!prog->is_func || extra_pass) {
 			/*
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 429a89c5468b..ca53f20aca73 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -2597,9 +2597,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		cond_resched();
 	}
 
-	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, proglen, pass + 1, image);
-
 	if (image) {
 		bpf_jit_binary_lock_ro(header);
 		prog->bpf_func = (void *)image;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 5b1ce656baa1..562ace48e1c9 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -276,14 +276,10 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	tmp.data = &jit_enable;
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 	if (write && !ret) {
-		if (jit_enable < 2 ||
-		    (jit_enable == 2 && bpf_dump_raw_ok(current_cred()))) {
-			*(int *)table->data = jit_enable;
-			if (jit_enable == 2)
-				pr_warn("bpf_jit_enable = 2 was set! NEVER use this in production, only for JIT debugging!\n");
-		} else {
-			ret = -EPERM;
-		}
+		*(int *)table->data = jit_enable;
+
+		if (jit_enable == 2)
+			pr_warn_once("bpf_jit_enable == 2 was deprecated! Use bpftool prog dump instead.\n");
 	}
 
 	if (write && ret && min == max)
diff --git a/tools/bpf/.gitignore b/tools/bpf/.gitignore
index cf53342175e7..5c70cfb9092e 100644
--- a/tools/bpf/.gitignore
+++ b/tools/bpf/.gitignore
@@ -4,4 +4,3 @@ feature
 bpf_asm
 bpf_dbg
 bpf_exp.yacc.*
-bpf_jit_disasm
diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 243b79f2b451..9264d7b0edf6 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -74,14 +74,10 @@ $(OUTPUT)%.yacc.o: $(OUTPUT)%.yacc.c
 $(OUTPUT)%.lex.o: $(OUTPUT)%.lex.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -c -o $@ $<
 
-PROGS = $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg $(OUTPUT)bpf_asm
+PROGS = $(OUTPUT)bpf_dbg $(OUTPUT)bpf_asm
 
 all: $(PROGS) bpftool runqslower
 
-$(OUTPUT)bpf_jit_disasm: CFLAGS += -DPACKAGE='bpf_jit_disasm'
-$(OUTPUT)bpf_jit_disasm: $(OUTPUT)bpf_jit_disasm.o
-	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $^ -lopcodes -lbfd -ldl
-
 $(OUTPUT)bpf_dbg: $(OUTPUT)bpf_dbg.o
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $^ -lreadline
 
@@ -94,16 +90,14 @@ $(OUTPUT)bpf_exp.lex.o: $(OUTPUT)bpf_exp.lex.c
 
 clean: bpftool_clean runqslower_clean resolve_btfids_clean
 	$(call QUIET_CLEAN, bpf-progs)
-	$(Q)$(RM) -r -- $(OUTPUT)*.o $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg \
+	$(Q)$(RM) -r -- $(OUTPUT)*.o $(OUTPUT)bpf_dbg \
 	       $(OUTPUT)bpf_asm $(OUTPUT)bpf_exp.yacc.* $(OUTPUT)bpf_exp.lex.*
 	$(call QUIET_CLEAN, core-gen)
 	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpf
 	$(Q)$(RM) -r -- $(OUTPUT)feature
 
 install: $(PROGS) bpftool_install
-	$(call QUIET_INSTALL, bpf_jit_disasm)
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/bin
-	$(Q)$(INSTALL) $(OUTPUT)bpf_jit_disasm $(DESTDIR)$(prefix)/bin/bpf_jit_disasm
 	$(call QUIET_INSTALL, bpf_dbg)
 	$(Q)$(INSTALL) $(OUTPUT)bpf_dbg $(DESTDIR)$(prefix)/bin/bpf_dbg
 	$(call QUIET_INSTALL, bpf_asm)
diff --git a/tools/bpf/bpf_jit_disasm.c b/tools/bpf/bpf_jit_disasm.c
deleted file mode 100644
index a90a5d110f92..000000000000
--- a/tools/bpf/bpf_jit_disasm.c
+++ /dev/null
@@ -1,332 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Minimal BPF JIT image disassembler
- *
- * Disassembles BPF JIT compiler emitted opcodes back to asm insn's for
- * debugging or verification purposes.
- *
- * To get the disassembly of the JIT code, do the following:
- *
- *  1) `echo 2 > /proc/sys/net/core/bpf_jit_enable`
- *  2) Load a BPF filter (e.g. `tcpdump -p -n -s 0 -i eth1 host 192.168.20.0/24`)
- *  3) Run e.g. `bpf_jit_disasm -o` to read out the last JIT code
- *
- * Copyright 2013 Daniel Borkmann <borkmann@redhat.com>
- */
-
-#include <stdint.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <assert.h>
-#include <unistd.h>
-#include <string.h>
-#include <bfd.h>
-#include <dis-asm.h>
-#include <regex.h>
-#include <fcntl.h>
-#include <sys/klog.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <limits.h>
-#include <tools/dis-asm-compat.h>
-
-#define CMD_ACTION_SIZE_BUFFER		10
-#define CMD_ACTION_READ_ALL		3
-
-static void get_exec_path(char *tpath, size_t size)
-{
-	char *path;
-	ssize_t len;
-
-	snprintf(tpath, size, "/proc/%d/exe", (int) getpid());
-	tpath[size - 1] = 0;
-
-	path = strdup(tpath);
-	assert(path);
-
-	len = readlink(path, tpath, size);
-	tpath[len] = 0;
-
-	free(path);
-}
-
-static void get_asm_insns(uint8_t *image, size_t len, int opcodes)
-{
-	int count, i, pc = 0;
-	char tpath[PATH_MAX];
-	struct disassemble_info info;
-	disassembler_ftype disassemble;
-	bfd *bfdf;
-
-	memset(tpath, 0, sizeof(tpath));
-	get_exec_path(tpath, sizeof(tpath));
-
-	bfdf = bfd_openr(tpath, NULL);
-	assert(bfdf);
-	assert(bfd_check_format(bfdf, bfd_object));
-
-	init_disassemble_info_compat(&info, stdout,
-				     (fprintf_ftype) fprintf,
-				     fprintf_styled);
-	info.arch = bfd_get_arch(bfdf);
-	info.mach = bfd_get_mach(bfdf);
-	info.buffer = image;
-	info.buffer_length = len;
-
-	disassemble_init_for_target(&info);
-
-#ifdef DISASM_FOUR_ARGS_SIGNATURE
-	disassemble = disassembler(info.arch,
-				   bfd_big_endian(bfdf),
-				   info.mach,
-				   bfdf);
-#else
-	disassemble = disassembler(bfdf);
-#endif
-	assert(disassemble);
-
-	do {
-		printf("%4x:\t", pc);
-
-		count = disassemble(pc, &info);
-
-		if (opcodes) {
-			printf("\n\t");
-			for (i = 0; i < count; ++i)
-				printf("%02x ", (uint8_t) image[pc + i]);
-		}
-		printf("\n");
-
-		pc += count;
-	} while(count > 0 && pc < len);
-
-	bfd_close(bfdf);
-}
-
-static char *get_klog_buff(unsigned int *klen)
-{
-	int ret, len;
-	char *buff;
-
-	len = klogctl(CMD_ACTION_SIZE_BUFFER, NULL, 0);
-	if (len < 0)
-		return NULL;
-
-	buff = malloc(len);
-	if (!buff)
-		return NULL;
-
-	ret = klogctl(CMD_ACTION_READ_ALL, buff, len);
-	if (ret < 0) {
-		free(buff);
-		return NULL;
-	}
-
-	*klen = ret;
-	return buff;
-}
-
-static char *get_flog_buff(const char *file, unsigned int *klen)
-{
-	int fd, ret, len;
-	struct stat fi;
-	char *buff;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		return NULL;
-
-	ret = fstat(fd, &fi);
-	if (ret < 0 || !S_ISREG(fi.st_mode))
-		goto out;
-
-	len = fi.st_size + 1;
-	buff = malloc(len);
-	if (!buff)
-		goto out;
-
-	memset(buff, 0, len);
-	ret = read(fd, buff, len - 1);
-	if (ret <= 0)
-		goto out_free;
-
-	close(fd);
-	*klen = ret;
-	return buff;
-out_free:
-	free(buff);
-out:
-	close(fd);
-	return NULL;
-}
-
-static char *get_log_buff(const char *file, unsigned int *klen)
-{
-	return file ? get_flog_buff(file, klen) : get_klog_buff(klen);
-}
-
-static void put_log_buff(char *buff)
-{
-	free(buff);
-}
-
-static uint8_t *get_last_jit_image(char *haystack, size_t hlen,
-				   unsigned int *ilen)
-{
-	char *ptr, *pptr, *tmp;
-	off_t off = 0;
-	unsigned int proglen;
-	int ret, flen, pass, ulen = 0;
-	regmatch_t pmatch[1];
-	unsigned long base;
-	regex_t regex;
-	uint8_t *image;
-
-	if (hlen == 0)
-		return NULL;
-
-	ret = regcomp(&regex, "flen=[[:alnum:]]+ proglen=[[:digit:]]+ "
-		      "pass=[[:digit:]]+ image=[[:xdigit:]]+", REG_EXTENDED);
-	assert(ret == 0);
-
-	ptr = haystack;
-	memset(pmatch, 0, sizeof(pmatch));
-
-	while (1) {
-		ret = regexec(&regex, ptr, 1, pmatch, 0);
-		if (ret == 0) {
-			ptr += pmatch[0].rm_eo;
-			off += pmatch[0].rm_eo;
-			assert(off < hlen);
-		} else
-			break;
-	}
-
-	ptr = haystack + off - (pmatch[0].rm_eo - pmatch[0].rm_so);
-	ret = sscanf(ptr, "flen=%d proglen=%u pass=%d image=%lx",
-		     &flen, &proglen, &pass, &base);
-	if (ret != 4) {
-		regfree(&regex);
-		return NULL;
-	}
-	if (proglen > 1000000) {
-		printf("proglen of %d too big, stopping\n", proglen);
-		return NULL;
-	}
-
-	image = malloc(proglen);
-	if (!image) {
-		printf("Out of memory\n");
-		return NULL;
-	}
-	memset(image, 0, proglen);
-
-	tmp = ptr = haystack + off;
-	while ((ptr = strtok(tmp, "\n")) != NULL && ulen < proglen) {
-		tmp = NULL;
-		if (!strstr(ptr, "JIT code"))
-			continue;
-		pptr = ptr;
-		while ((ptr = strstr(pptr, ":")))
-			pptr = ptr + 1;
-		ptr = pptr;
-		do {
-			image[ulen++] = (uint8_t) strtoul(pptr, &pptr, 16);
-			if (ptr == pptr) {
-				ulen--;
-				break;
-			}
-			if (ulen >= proglen)
-				break;
-			ptr = pptr;
-		} while (1);
-	}
-
-	assert(ulen == proglen);
-	printf("%u bytes emitted from JIT compiler (pass:%d, flen:%d)\n",
-	       proglen, pass, flen);
-	printf("%lx + <x>:\n", base);
-
-	regfree(&regex);
-	*ilen = ulen;
-	return image;
-}
-
-static void usage(void)
-{
-	printf("Usage: bpf_jit_disasm [...]\n");
-	printf("       -o          Also display related opcodes (default: off).\n");
-	printf("       -O <file>   Write binary image of code to file, don't disassemble to stdout.\n");
-	printf("       -f <file>   Read last image dump from file or stdin (default: klog).\n");
-	printf("       -h          Display this help.\n");
-}
-
-int main(int argc, char **argv)
-{
-	unsigned int len, klen, opt, opcodes = 0;
-	char *kbuff, *file = NULL;
-	char *ofile = NULL;
-	int ofd;
-	ssize_t nr;
-	uint8_t *pos;
-	uint8_t *image = NULL;
-
-	while ((opt = getopt(argc, argv, "of:O:")) != -1) {
-		switch (opt) {
-		case 'o':
-			opcodes = 1;
-			break;
-		case 'O':
-			ofile = optarg;
-			break;
-		case 'f':
-			file = optarg;
-			break;
-		default:
-			usage();
-			return -1;
-		}
-	}
-
-	bfd_init();
-
-	kbuff = get_log_buff(file, &klen);
-	if (!kbuff) {
-		fprintf(stderr, "Could not retrieve log buffer!\n");
-		return -1;
-	}
-
-	image = get_last_jit_image(kbuff, klen, &len);
-	if (!image) {
-		fprintf(stderr, "No JIT image found!\n");
-		goto done;
-	}
-	if (!ofile) {
-		get_asm_insns(image, len, opcodes);
-		goto done;
-	}
-
-	ofd = open(ofile, O_WRONLY | O_CREAT | O_TRUNC, DEFFILEMODE);
-	if (ofd < 0) {
-		fprintf(stderr, "Could not open file %s for writing: ", ofile);
-		perror(NULL);
-		goto done;
-	}
-	pos = image;
-	do {
-		nr = write(ofd, pos, len);
-		if (nr < 0) {
-			fprintf(stderr, "Could not write data to %s: ", ofile);
-			perror(NULL);
-			goto done;
-		}
-		len -= nr;
-		pos += nr;
-	} while (len);
-	close(ofd);
-
-done:
-	put_log_buff(kbuff);
-	free(image);
-	return 0;
-}
-- 
2.27.0

