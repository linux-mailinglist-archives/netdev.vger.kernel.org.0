Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82CF3AA714
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFPW5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFPW5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:57:21 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE03C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:55:14 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id q18so3735958ile.10
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=MYzev/2ejIlEofGZAN0KAN+etWMF72Vq4LTXFhnj74M=;
        b=fnYjR7kIS+GEby0Bwyp11ZxdK9yhNvBM4o/p7i5FU+jrY8hjsbba2hNlJwiQkPjV/x
         0MoFXqqKsZW58PkRXVs4XveaU5eclBQDb/4kSKI9QHFOqmDHMCi34xKWoN6VyrErYjpb
         Blzq9l3yM/ePtL4dflbD9nwNCoITHU7/Ycv1bO66DE3LFZ6bopusklaOsrRcAvu6K7Xj
         LskkGhliu+cArzQWHGEgIKSUY5Tc83apFhRE+GQUe10oCf6Bbe1KluJWZYXuYFX59/Uu
         RxyRm0njIRGX4iV7wrcJ1HrKeT8Kf0JQymgjLJwimYjXTVe/OKou+/Sa/jRYWc8aOrAZ
         Y/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MYzev/2ejIlEofGZAN0KAN+etWMF72Vq4LTXFhnj74M=;
        b=Z7dkMPF9f1ywWD2YqtCgjcfPV5s3Gd7NCa736c3rMlicNJ4V/5sRRnGfc6AjKTO/53
         Ag6RMO2SxG7Q96FjqnCZQop/rPGaWr49TZ4YbsbJkmbokuANyeeRCajoxqsBJJ1GCLBY
         HR+1OTrNjmc79Ny91Lmv1DcD/eTC+LAQJuGYjVE9e74evI5kpyvp6TBBJtH5585h6BcA
         QWNt9FNv7ZWgYTm9aEtT9uSYIAaTkef6e1baALzMnAtzM9LjQY2TMfpdK/r4cmVfvRPH
         Jkq9PYXNN/zZ1iqJz+Z9WOxINa9wU/tWRSoCGo+4uF6iZfGfw8SiZk1/KBedpLX+UzrG
         sdkQ==
X-Gm-Message-State: AOAM531q5eiA5lXfOM8kzfbGvg/RqgG3OsWEaLU1fQASruEPnBnkXvW2
        hB7DYq8YM0i0WQYvLlu5wEg=
X-Google-Smtp-Source: ABdhPJyrTptKn7IWXK+sXTwhY2ecuMfBtxI1N/r/oVZhM/7361LIAq0x0fZ3ABbLTa/AWHiIn+PCtQ==
X-Received: by 2002:a05:6e02:1606:: with SMTP id t6mr1349473ilu.44.1623884113854;
        Wed, 16 Jun 2021 15:55:13 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id h26sm1859747ioh.34.2021.06.16.15.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:55:13 -0700 (PDT)
Subject: [PATCH bpf v2 1/4] bpf: Fix null ptr deref with mixed tail calls and
 subprogs
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 16 Jun 2021 15:55:00 -0700
Message-ID: <162388410082.151936.6522658624805533014.stgit@john-XPS-13-9370>
In-Reply-To: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sub-programs prog->aux->poke_tab[] is populated in jit_subprogs() and
then used when emitting 'BPF_JMP|BPF_TAIL_CALL' insn->code from the
individual JITs. The poke_tab[] to use is stored in the insn->imm by
the code adding it to that array slot. The JIT then uses imm to find the
right entry for an individual instruction. In the x86 bpf_jit_comp.c
this is done by calling emit_bpf_tail_call_direct with the poke_tab[]
of the imm value.

However, we observed the below null-ptr-deref when mixing tail call
programs with subprog programs. For this to happen we just need to
mix bpf-2-bpf calls and tailcalls with some extra calls or instructions
that would be patched later by one of the fixup routines. So whats
happening?

Before the fixup_call_args() -- where the jit op is done -- various
code patching is done by do_misc_fixups(). This may increase the
insn count, for example when we patch map_lookup_up using map_gen_lookup
hook. This does two things. First, it means the instruction index,
insn_idx field, of a tail call instruction will move by a 'delta'.

In verifier code,

 struct bpf_jit_poke_descriptor desc = {
  .reason = BPF_POKE_REASON_TAIL_CALL,
  .tail_call.map = BPF_MAP_PTR(aux->map_ptr_state),
  .tail_call.key = bpf_map_key_immediate(aux),
  .insn_idx = i + delta,
 };

Then subprog start values subprog_info[i].start will be updated
with the delta and any poke descriptor index will also be updated
with the delta in adjust_poke_desc(). If we look at the adjust
subprog starts though we see its only adjusted when the delta
occurs before the new instructions,

        /* NOTE: fake 'exit' subprog should be updated as well. */
        for (i = 0; i <= env->subprog_cnt; i++) {
                if (env->subprog_info[i].start <= off)
                        continue;

Earlier subprograms are not changed because their start values
are not moved. But, adjust_poke_desc() does the offset + delta
indiscriminately. The result is poke descriptors are potentially
corrupted.

Then in jit_subprogs() we only populate the poke_tab[]
when the above insn_idx is less than the next subprogram start. From
above we corrupted our insn_idx so we might incorrectly assume a
poke descriptor is not used in a subprogram omitting it from the
subprogram. And finally when the jit runs it does the deref of poke_tab
when emitting the instruction and crashes with below. Because earlier
step omitted the poke descriptor.

The fix is straight forward with above context. Simply move same logic
from adjust_subprog_starts() into adjust_poke_descs() and only adjust
insn_idx when needed.

[   82.396354] bpf_testmod: version magic '5.12.0-rc2alu+ SMP preempt mod_unload ' should be '5.12.0+ SMP preempt mod_unload '
[   82.623001] loop10: detected capacity change from 0 to 8
[   88.487424] ==================================================================
[   88.487438] BUG: KASAN: null-ptr-deref in do_jit+0x184a/0x3290
[   88.487455] Write of size 8 at addr 0000000000000008 by task test_progs/5295
[   88.487471] CPU: 7 PID: 5295 Comm: test_progs Tainted: G          I       5.12.0+ #386
[   88.487483] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
[   88.487490] Call Trace:
[   88.487498]  dump_stack+0x93/0xc2
[   88.487515]  kasan_report.cold+0x5f/0xd8
[   88.487530]  ? do_jit+0x184a/0x3290
[   88.487542]  do_jit+0x184a/0x3290
 ...
[   88.487709]  bpf_int_jit_compile+0x248/0x810
 ...
[   88.487765]  bpf_check+0x3718/0x5140
 ...
[   88.487920]  bpf_prog_load+0xa22/0xf10

Reported-by: Jussi Maki <joamaki@gmail.com>
CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c6a27574242d..6e2ebcb0d66f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11459,7 +11459,7 @@ static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len
 	}
 }
 
-static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
+static void adjust_poke_descs(struct bpf_prog *prog, u32 off, u32 len)
 {
 	struct bpf_jit_poke_descriptor *tab = prog->aux->poke_tab;
 	int i, sz = prog->aux->size_poke_tab;
@@ -11467,6 +11467,8 @@ static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
 
 	for (i = 0; i < sz; i++) {
 		desc = &tab[i];
+		if (desc->insn_idx <= off)
+			continue;
 		desc->insn_idx += len - 1;
 	}
 }
@@ -11487,7 +11489,7 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 	if (adjust_insn_aux_data(env, new_prog, off, len))
 		return NULL;
 	adjust_subprog_starts(env, off, len);
-	adjust_poke_descs(new_prog, len);
+	adjust_poke_descs(new_prog, off, len);
 	return new_prog;
 }
 


