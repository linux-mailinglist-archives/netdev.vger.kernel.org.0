Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79467126FA7
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfLSVUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:20:02 -0500
Received: from www62.your-server.de ([213.133.104.62]:59526 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfLSVUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:20:01 -0500
Received: from 31.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.31] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ii3DC-00058S-NF; Thu, 19 Dec 2019 22:19:58 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 1/2] bpf: Fix record_func_key to perform backtracking on r3
Date:   Thu, 19 Dec 2019 22:19:50 +0100
Message-Id: <ac43ffdeb7386c5bd688761ed266f3722bb39823.1576789878.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1576789878.git.daniel@iogearbox.net>
References: <cover.1576789878.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing Cilium with /unreleased/ Linus' tree under BPF-based NodePort
implementation, I noticed a strange BPF SNAT engine behavior from time to
time. In some cases it would do the correct SNAT/DNAT service translation,
but at a random point in time it would just stop and perform an unexpected
translation after SYN, SYN/ACK and stack would send a RST back. While initially
assuming that there is some sort of a race condition in BPF code, adding
trace_printk()s for debugging purposes at some point seemed to have resolved
the issue auto-magically.

Digging deeper on this Heisenbug and reducing the trace_printk() calls to
an absolute minimum, it turns out that a single call would suffice to
trigger / not trigger the seen RST issue, even though the logic of the
program itself remains unchanged. Turns out the single call changed verifier
pruning behavior to get everything to work. Reconstructing a minimal test
case, the incorrect JIT dump looked as follows:

  # bpftool p d j i 11346
  0xffffffffc0cba96c:
  [...]
    21:   movzbq 0x30(%rdi),%rax
    26:   cmp    $0xd,%rax
    2a:   je     0x000000000000003a
    2c:   xor    %edx,%edx
    2e:   movabs $0xffff89cc74e85800,%rsi
    38:   jmp    0x0000000000000049
    3a:   mov    $0x2,%edx
    3f:   movabs $0xffff89cc74e85800,%rsi
    49:   mov    -0x224(%rbp),%eax
    4f:   cmp    $0x20,%eax
    52:   ja     0x0000000000000062
    54:   add    $0x1,%eax
    57:   mov    %eax,-0x224(%rbp)
    5d:   jmpq   0xffffffffffff6911
    62:   mov    $0x1,%eax
  [...]

Hence, unexpectedly, JIT emitted a direct jump even though retpoline based
one would have been needed since in line 2c and 3a we have different slot
keys in BPF reg r3. Verifier log of the test case reveals what happened:

  0: (b7) r0 = 14
  1: (73) *(u8 *)(r1 +48) = r0
  2: (71) r0 = *(u8 *)(r1 +48)
  3: (15) if r0 == 0xd goto pc+4
   R0_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R1=ctx(id=0,off=0,imm=0) R10=fp0
  4: (b7) r3 = 0
  5: (18) r2 = 0xffff89cc74d54a00
  7: (05) goto pc+3
  11: (85) call bpf_tail_call#12
  12: (b7) r0 = 1
  13: (95) exit
  from 3 to 8: R0_w=inv13 R1=ctx(id=0,off=0,imm=0) R10=fp0
  8: (b7) r3 = 2
  9: (18) r2 = 0xffff89cc74d54a00
  11: safe
  processed 13 insns (limit 1000000) [...]

Second branch is pruned by verifier since considered safe, but issue is that
record_func_key() couldn't have seen the index in line 3a and therefore
decided that emitting a direct jump at this location was okay.

Fix this by reusing our backtracking logic for precise scalar verification
in order to prevent pruning on the slot key. This means verifier will track
content of r3 all the way backwards and only prune if both scalars were
unknown in state equivalence check and therefore poisoned in the first place
in record_func_key(). The range is [x,x] in record_func_key() case since
the slot always would have to be constant immediate. Correct verification
after fix:

  0: (b7) r0 = 14
  1: (73) *(u8 *)(r1 +48) = r0
  2: (71) r0 = *(u8 *)(r1 +48)
  3: (15) if r0 == 0xd goto pc+4
   R0_w=invP(id=0,umax_value=255,var_off=(0x0; 0xff)) R1=ctx(id=0,off=0,imm=0) R10=fp0
  4: (b7) r3 = 0
  5: (18) r2 = 0x0
  7: (05) goto pc+3
  11: (85) call bpf_tail_call#12
  12: (b7) r0 = 1
  13: (95) exit
  from 3 to 8: R0_w=invP13 R1=ctx(id=0,off=0,imm=0) R10=fp0
  8: (b7) r3 = 2
  9: (18) r2 = 0x0
  11: (85) call bpf_tail_call#12
  12: (b7) r0 = 1
  13: (95) exit
  processed 15 insns (limit 1000000) [...]

And correct corresponding JIT dump:

  # bpftool p d j i 11
  0xffffffffc0dc34c4:
  [...]
    21:	  movzbq 0x30(%rdi),%rax
    26:	  cmp    $0xd,%rax
    2a:	  je     0x000000000000003a
    2c:	  xor    %edx,%edx
    2e:	  movabs $0xffff9928b4c02200,%rsi
    38:	  jmp    0x0000000000000049
    3a:	  mov    $0x2,%edx
    3f:	  movabs $0xffff9928b4c02200,%rsi
    49:	  cmp    $0x4,%rdx
    4d:	  jae    0x0000000000000093
    4f:	  and    $0x3,%edx
    52:	  mov    %edx,%edx
    54:	  cmp    %edx,0x24(%rsi)
    57:	  jbe    0x0000000000000093
    59:	  mov    -0x224(%rbp),%eax
    5f:	  cmp    $0x20,%eax
    62:	  ja     0x0000000000000093
    64:	  add    $0x1,%eax
    67:	  mov    %eax,-0x224(%rbp)
    6d:	  mov    0x110(%rsi,%rdx,8),%rax
    75:	  test   %rax,%rax
    78:	  je     0x0000000000000093
    7a:	  mov    0x30(%rax),%rax
    7e:	  add    $0x19,%rax
    82:   callq  0x000000000000008e
    87:   pause
    89:   lfence
    8c:   jmp    0x0000000000000087
    8e:   mov    %rax,(%rsp)
    92:   retq
    93:   mov    $0x1,%eax
  [...]

Also explicitly adding explicit env->allow_ptr_leaks to fixup_bpf_calls() since
backtracking is enabled under former (direct jumps as well, but use different
test). In case of only tracking different map pointers as in c93552c443eb ("bpf:
properly enforce index mask to prevent out-of-bounds speculation"), pruning
cannot make such short-cuts, neither if there are paths with scalar and non-scalar
types as r3. mark_chain_precision() is only needed after we know that
register_is_const(). If it was not the case, we already poison the key on first
path and non-const key in later paths are not matching the scalar range in regsafe()
either. Cilium NodePort testing passes fine as well now. Note, released kernels
not affected.

Fixes: d2e4c1e6c294 ("bpf: Constant map key tracking for prog array pokes")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/verifier.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6ef71429d997..4983940cbdca 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4134,6 +4134,7 @@ record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	struct bpf_map *map = meta->map_ptr;
 	struct tnum range;
 	u64 val;
+	int err;
 
 	if (func_id != BPF_FUNC_tail_call)
 		return 0;
@@ -4150,6 +4151,10 @@ record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 		return 0;
 	}
 
+	err = mark_chain_precision(env, BPF_REG_3);
+	if (err)
+		return err;
+
 	val = reg->var_off.value;
 	if (bpf_map_key_unseen(aux))
 		bpf_map_key_store(aux, val);
@@ -9272,7 +9277,8 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			insn->code = BPF_JMP | BPF_TAIL_CALL;
 
 			aux = &env->insn_aux_data[i + delta];
-			if (prog->jit_requested && !expect_blinding &&
+			if (env->allow_ptr_leaks && !expect_blinding &&
+			    prog->jit_requested &&
 			    !bpf_map_key_poisoned(aux) &&
 			    !bpf_map_ptr_poisoned(aux) &&
 			    !bpf_map_ptr_unpriv(aux)) {
-- 
2.21.0

