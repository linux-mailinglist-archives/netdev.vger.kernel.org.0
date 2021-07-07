Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0BD3BF225
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhGGWlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhGGWly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 18:41:54 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849EAC061574;
        Wed,  7 Jul 2021 15:39:12 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id z1so4672272ils.0;
        Wed, 07 Jul 2021 15:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z+sjd+s/r2IhZPy8Smr9kFhc+9Fy1TVVXFgPMydonWE=;
        b=h53Ztx3pkuiQ0XhkrJXBD1WoQ0LPeRAVTi6BHcxm6N6ciiUbqN2/8Z9QmNaOINgOYD
         rc0gFB3yD7ZeVtvKo+bGpQDy1ChFtL1ACezVHJTE+85oW0rFeDEFjZRQQBKKZQyRBNvk
         ozOSpOyCiWxAerMgdDwgEIpEkCHEKOAM21oV45ZWJtfScmSQ4DqYw3CuTj2UKTwALYyH
         QADdGoCOdNabnZlBThwr2YKORtg0L0R/OkEblCWV6fB1c1yxwafSzObj7E4gq1w/YLZU
         saHI/hg3gO4SHzTu1ZgRJDCury/UHRJIuooV5YNRGkaErwPNeJlzrZfatLyrYN/UF6Zb
         nNwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z+sjd+s/r2IhZPy8Smr9kFhc+9Fy1TVVXFgPMydonWE=;
        b=fR1TpAWkf2ujGQCVt8ONnWzvZ4REz/8V4BsbcAHhR6QjZurfLk6EHzvbXyl/iC8lDE
         04YXQzNQ5yzZXs8cAwlcAN63aN9mTec5PrN7lYurkxsfeAP07Z0MkudE2YCbdnt+257p
         W5//UdzPID9BkyatqT2Q8BMPGkJrnGsTfvhmlc4W2+bkQycLNbuHJxJCEXcfYzFBIjbJ
         wSVUgzkadEtmjeOGoTii5dFpVZTBT5GdXy1wuHTO6eigPvVK9T19AeikUeJ3zyRQJjtI
         omchffPxXS6P5a1xNpRTaUQFUsxrvzqTZN0uhQLCqoXyoIzAZK3Ju5KMY8TPW0xi8HH+
         bStQ==
X-Gm-Message-State: AOAM531M0MHyYb7I8Bocx3txf4X44I5iaPt9xEvl0TqWJAt5QYbdAT9N
        6lWz3zplxzrlAiWTKjhY4+g=
X-Google-Smtp-Source: ABdhPJzpMaKzAQZj90Odn/9qGvYG2wvDUuP8moltFRIfZw3Ahm6Nxun2xK+bAtkiFpQUACo6TeGYZw==
X-Received: by 2002:a92:c84f:: with SMTP id b15mr19454344ilq.27.1625697551988;
        Wed, 07 Jul 2021 15:39:11 -0700 (PDT)
Received: from john-Precision-5820-Tower.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id f4sm253455ile.8.2021.07.07.15.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 15:39:11 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v2 1/2] bpf: track subprog poke correctly, fix use-after-free
Date:   Wed,  7 Jul 2021 15:38:47 -0700
Message-Id: <20210707223848.14580-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707223848.14580-1-john.fastabend@gmail.com>
References: <20210707223848.14580-1-john.fastabend@gmail.com>
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

On the error path we omit cleaning up the poke->aux field because these
are only ever referenced from the JIT side, but on error we will never
make it to the JIT so its fine to leave them dangling. Removing these
pointers would complicate the error path for no reason.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 arch/x86/net/bpf_jit_comp.c |  4 ++++
 include/linux/bpf.h         |  1 +
 kernel/bpf/core.c           |  7 +++++-
 kernel/bpf/verifier.c       | 45 +++++++------------------------------
 4 files changed, 19 insertions(+), 38 deletions(-)

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
index 6e2ebcb0d66f..a58e19223e85 100644
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
-
-			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
+			poke = &prog->aux->poke_tab[j];
 
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
@@ -12255,11 +12230,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 	for (i = 0; i < env->subprog_cnt; i++) {
 		if (!func[i])
 			continue;
-
-		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
-			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
-			map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
-		}
+		func[i]->aux->poke_tab = NULL;
 		bpf_jit_free(func[i]);
 	}
 	kfree(func);
-- 
2.17.1

