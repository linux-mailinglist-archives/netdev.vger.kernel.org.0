Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7048D3B893D
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 21:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhF3Tnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 15:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3Tnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 15:43:42 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAC7C061756;
        Wed, 30 Jun 2021 12:41:13 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h3so4027858ilc.9;
        Wed, 30 Jun 2021 12:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MCM7KRnV/PI1c93unODv/6BzjghcEhL/TUDBiodTGIk=;
        b=u26JCKM+Omy7FgbrcKBvrs66G6zoQ+l4H/mZyGUhrQ+6tRQ8tsVoskZg8hVe1086a4
         zrNN9hXew7PNkaecdtJtZmbP7L+w3bWmz+IPwTPq7Onyq1NnHQq/Fw2KXRk8XSS35Epm
         fcrtA/f3iQUdxM2ix/UPcVVeJWvkpVsCzlp6YTg1AzuTavDXnUe09byCE5RMYSalD6CR
         moIAk94FC1cmFvzAN7xK0u9taczJSv3Fl80tGKsES9xckkocGY9CnAYJLSy8Sd44h/tP
         LQApg14v4pZlOhM5E7fYd5MS1p9tLYx8/d9PEAT7N2d3VKxoYGebGpllgvFUtvzG0tfH
         Bxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MCM7KRnV/PI1c93unODv/6BzjghcEhL/TUDBiodTGIk=;
        b=R9EJc09Wh4Oj8RjsuWZmceO2BJovJHQ2mtcB231d2SwTPZ3omnBsNL9+q3pepauR9R
         rQL3zg1PT11U2nlaRHaOlLfwFW4jhu/D7lBQBphfYFw8Oj58/RpIyDnmRsQuj+0R+no9
         BNmzHHrG1o+T/I9jeebpR2w8lxzlV2rbGZ+/6Ow9exIyuuRvLMCKkBItx5L1O4G+ayS8
         0GlkVSAxxJejLNjvS/Ax5lyTWYRVCiKfIwpOdRYFFb/5pfOzGEwW3gc0RNKIU+rhnEG3
         BPFaI9021bQ01BKgrN7CVwQ8R57ad3CWuawNhamHQhO+cw1Jfc2tYeI/aQLsyvqa/ZEv
         kppw==
X-Gm-Message-State: AOAM530vCweYZzW4O+nEdC9CQ8R+gHBQbjbaYC1xAqjf6JryIP76+oWV
        Z7cIeC72jJvsHUX4hBLQ+SY=
X-Google-Smtp-Source: ABdhPJyp+/52AwCtC2lm8Y5H7TDfBX0RsCd0feLYWQLxmPZXjHu1aqtSN+xobjYrZFZU2Cn8HuVQhw==
X-Received: by 2002:a05:6e02:1b85:: with SMTP id h5mr19223030ili.99.1625082072587;
        Wed, 30 Jun 2021 12:41:12 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p9sm10977680iod.48.2021.06.30.12.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 12:41:12 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf: track subprog poke correctly, fix use-after-free
Date:   Wed, 30 Jun 2021 12:40:48 -0700
Message-Id: <20210630194049.46453-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210630194049.46453-1-john.fastabend@gmail.com>
References: <20210630194049.46453-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subprograms are calling map_poke_track but on program release there is no
hook to call map_poke_untrack. But on prog release the aux memory is freed
even though we still have a reference to it in the element list of the
map aux data.

So when we run map_poke_run() we end up accessing free'd memory. This
triggers with KASAN in prog_array_map_poke_run() shown here.

    [  402.824686] ==================================================================
    [  402.824689] BUG: KASAN: use-after-free in prog_array_map_poke_run+0xc2/0x34e
    [  402.824698] Read of size 4 at addr ffff8881905a7940 by task hubble-fgs/4337

    [  402.824705] CPU: 1 PID: 4337 Comm: hubble-fgs Tainted: G          I       5.12.0+ #399
    [  402.824715] Call Trace:
    [  402.824719]  dump_stack+0x93/0xc2
    [  402.824727]  print_address_description.constprop.0+0x1a/0x140
    [  402.824736]  ? prog_array_map_poke_run+0xc2/0x34e
    [  402.824740]  ? prog_array_map_poke_run+0xc2/0x34e
    [  402.824744]  kasan_report.cold+0x7c/0xd8
    [  402.824752]  ? prog_array_map_poke_run+0xc2/0x34e
    [  402.824757]  prog_array_map_poke_run+0xc2/0x34e
    [  402.824765]  bpf_fd_array_map_update_elem+0x124/0x1a0

The elements concerned are walked like this,

    for (i = 0; i < elem->aux->size_poke_tab; i++) {
           poke = &elem->aux->poke_tab[i];

So the access to size_poke_tab is the 4B read, verified by checking offsets
in the KASAN dump,

    [  402.825004] The buggy address belongs to the object at ffff8881905a7800
                    which belongs to the cache kmalloc-1k of size 1024
    [  402.825008] The buggy address is located 320 bytes inside of
                    1024-byte region [ffff8881905a7800, ffff8881905a7c00)

With pahol output,

     struct bpf_prog_aux {
     ...
            /* --- cacheline 5 boundary (320 bytes) --- */
            u32                        size_poke_tab;        /*   320     4 */
     ...

In general subprograms do not manage their own data structures. For example
btf func_info, linfo, etc are just pointers to the prog structure. This
allows reference counting and cleanup to be done on the main prog.

The aux->poke_tab struct however did not follow this logic. The initial fix
for above use after free further embedded subprogram tracking of poke data
tracking into the subprogram with proper reference counting. However,
Daniel and Alexei questioned why we were treating these objects specially.
I agree its unnecessary.

The fix here removes the per subprogram poke data structure alloc and map
tracking and instead simply points the aux->poke_tab pointer at the main
programs poke_tab. This way map tracking is done on the origin program
and we do not need to manage them per subprogram. A couple small
complication arise here. First on bpf_prog_free_deferred(), where we unwind
the prog reference counting and kfree objects, we need to ensure that we
don't try to double free the poke_tab when free'ing the subprog structures.
This is easily solved by NULL'ing the poke_tab pointer.

The second detail is to ensure that per subprog jit logic only does fixups
on poke_tab[] entries it owns. To do this we add a pointer in the poke
structure to point at the subprog value so JITs can easily check while
walking the poke_tab structure if the current entry belongs to the current
program. This change is necessary per JIT. See x86/net/bpf_jit_compo.c func
bpf_tail_call_direct_fixup() for the details. Only x86 is currently using
the poke_tab struct so we only need to fixup the x86 JIT.

Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 arch/x86/net/bpf_jit_comp.c |  4 ++++
 include/linux/bpf.h         |  1 +
 kernel/bpf/core.c           |  7 ++++++-
 kernel/bpf/verifier.c       | 39 +++++++------------------------------
 4 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 2a2e290fa5d8..ce8dbc9310a9 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -576,6 +576,10 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
 
 	for (i = 0; i < prog->aux->size_poke_tab; i++) {
 		poke = &prog->aux->poke_tab[i];
+
+		if (poke->aux && poke->aux != prog->aux)
+			continue;
+
 		WARN_ON_ONCE(READ_ONCE(poke->tailcall_target_stable));
 
 		if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 02b02cb29ce2..a7532cb3493a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -777,6 +777,7 @@ struct bpf_jit_poke_descriptor {
 	void *tailcall_target;
 	void *tailcall_bypass;
 	void *bypass_addr;
+	void *aux;
 	union {
 		struct {
 			struct bpf_map *map;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 5e31ee9f7512..72810314c43b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2211,8 +2211,13 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 #endif
 	if (aux->dst_trampoline)
 		bpf_trampoline_put(aux->dst_trampoline);
-	for (i = 0; i < aux->func_cnt; i++)
+	for (i = 0; i < aux->func_cnt; i++) {
+		/* poke_tab in subprogs are links to main prog and are
+		 * freed above so delete link without kfree.
+		 */
+		aux->func[i]->aux->poke_tab = NULL;
 		bpf_jit_free(aux->func[i]);
+	}
 	if (aux->func_cnt) {
 		kfree(aux->func);
 		bpf_prog_unlock_free(aux->prog);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6e2ebcb0d66f..daa5a3f5e7b8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12109,30 +12109,17 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		/* the btf and func_info will be freed only at prog->aux */
 		func[i]->aux->btf = prog->aux->btf;
 		func[i]->aux->func_info = prog->aux->func_info;
+		func[i]->aux->poke_tab = prog->aux->poke_tab;
+		func[i]->aux->size_poke_tab = prog->aux->size_poke_tab;
 
 		for (j = 0; j < prog->aux->size_poke_tab; j++) {
-			u32 insn_idx = prog->aux->poke_tab[j].insn_idx;
-			int ret;
+			struct bpf_jit_poke_descriptor *poke;
 
-			if (!(insn_idx >= subprog_start &&
-			      insn_idx <= subprog_end))
-				continue;
-
-			ret = bpf_jit_add_poke_descriptor(func[i],
-							  &prog->aux->poke_tab[j]);
-			if (ret < 0) {
-				verbose(env, "adding tail call poke descriptor failed\n");
-				goto out_free;
-			}
+			poke = &prog->aux->poke_tab[j];
 
-			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
-
-			map_ptr = func[i]->aux->poke_tab[ret].tail_call.map;
-			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
-			if (ret < 0) {
-				verbose(env, "tracking tail call prog failed\n");
-				goto out_free;
-			}
+			if (poke->insn_idx < subprog_end &&
+			    poke->insn_idx >= subprog_start)
+				poke->aux = func[i]->aux;
 		}
 
 		/* Use bpf_prog_F_tag to indicate functions in stack traces.
@@ -12163,18 +12150,6 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		cond_resched();
 	}
 
-	/* Untrack main program's aux structs so that during map_poke_run()
-	 * we will not stumble upon the unfilled poke descriptors; each
-	 * of the main program's poke descs got distributed across subprogs
-	 * and got tracked onto map, so we are sure that none of them will
-	 * be missed after the operation below
-	 */
-	for (i = 0; i < prog->aux->size_poke_tab; i++) {
-		map_ptr = prog->aux->poke_tab[i].tail_call.map;
-
-		map_ptr->ops->map_poke_untrack(map_ptr, prog->aux);
-	}
-
 	/* at this point all bpf functions were successfully JITed
 	 * now populate all bpf_calls with correct addresses and
 	 * run last pass of JIT
-- 
2.25.1

