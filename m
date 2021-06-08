Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97FD3A047E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbhFHTfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:35:34 -0400
Received: from mail-il1-f169.google.com ([209.85.166.169]:38558 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbhFHTdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:33:32 -0400
Received: by mail-il1-f169.google.com with SMTP id d1so17846375ils.5;
        Tue, 08 Jun 2021 12:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AAEaQnkcEin0xfopI4B5HxP0UPGqn6HkcxHsdLoqoo8=;
        b=lN0ezurN19ijysdHRyRCpv7N1gqTE7BQCzDCX19YSxzhzI8ftYBH5Z3FUDAJSmGnPS
         TcR+D2T6YDMsJil0GI1UAEAR/F7s2v9DVMaHvcExwcqueWkqNOz8H+pwhoQLlrulpIwL
         BBeW8jfUfLJDfbQSGH8zbO9tlxqoMmRDvpElyqERq6pSt8GjgfSUt4Hsg9j+9U3cjXIo
         2N+wyduePEsP6hcmiQZgS9swUaaRn8khoW/A0OplVwwV3ijjcMi5iHgSJAbx3gQkqOMh
         ghC9+9c18aVCk0JH3pgqZ/t9R4xWC6+YsE3JhA6VitBiCk02M9lF9qU1Yz7jEaNwnK0R
         ewcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AAEaQnkcEin0xfopI4B5HxP0UPGqn6HkcxHsdLoqoo8=;
        b=EHr/VYVruuF7gtOP1Zc8lGDubjywAEghaiHFjzrImo35FwAn1nlOX/oZLbaEpxPc0E
         uZ3q2/7PAcWNiLKiG2evzM2dfq8TsRReLkky23chI042pm2PjXZhMCCoMqScXj8rhDMi
         7PzYxsQO2KxwPk+b5lwNzzg2XW4N5KJKPeqdIjofbvDAllzFmCezN6w1LZKVIfqHXAPx
         O3diJDZZ58L1Pe71DUeipnu6TOWIWhyRrupYX7jYP7RmbjZ/H5eX9HRqYZjJkJcL2RMe
         LY+Y88tpdg+TbhbZxUsDUy5xVHV7PT3Youjk6fWM7+l/Q3JAoOZCJvjPp2jzJXnQ1JbJ
         /qmw==
X-Gm-Message-State: AOAM532gFYEeJ8nThMImgbKBmIFBga9Hh/w0JxmLLKHdwjfGmmdQGiig
        uai4bZ/kSesSbkACBeu5dqg=
X-Google-Smtp-Source: ABdhPJwyvZckIsCq+ekKEwln5K68p9lAiarvDCnEo/yZB9FN/vh/X12yRNJlGqvNQa6hN0ws0C8ZEQ==
X-Received: by 2002:a92:c949:: with SMTP id i9mr14825767ilq.38.1623180627229;
        Tue, 08 Jun 2021 12:30:27 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id t15sm302258ilq.84.2021.06.08.12.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 12:30:26 -0700 (PDT)
Subject: [PATCH bpf 1/2] bpf: Fix null ptr deref with mixed tail calls and
 subprogs
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Date:   Tue, 08 Jun 2021 12:30:15 -0700
Message-ID: <162318061518.323820.4329181800429686297.stgit@john-XPS-13-9370>
In-Reply-To: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
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

[   88.487438] BUG: KASAN: null-ptr-deref in do_jit+0x184a/0x3290
[   88.487455] Write of size 8 at addr 0000000000000008 by task test_progs/5295
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

CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 94ba5163d4c5..ac8373da849c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11408,7 +11408,7 @@ static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len
 	}
 }
 
-static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
+static void adjust_poke_descs(struct bpf_prog *prog, u32 off, u32 len)
 {
 	struct bpf_jit_poke_descriptor *tab = prog->aux->poke_tab;
 	int i, sz = prog->aux->size_poke_tab;
@@ -11416,6 +11416,8 @@ static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
 
 	for (i = 0; i < sz; i++) {
 		desc = &tab[i];
+		if (desc->insn_idx <= off)
+			continue;
 		desc->insn_idx += len - 1;
 	}
 }
@@ -11436,7 +11438,7 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 	if (adjust_insn_aux_data(env, new_prog, off, len))
 		return NULL;
 	adjust_subprog_starts(env, off, len);
-	adjust_poke_descs(new_prog, len);
+	adjust_poke_descs(new_prog, off, len);
 	return new_prog;
 }
 


