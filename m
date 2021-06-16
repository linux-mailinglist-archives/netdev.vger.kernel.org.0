Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BABE3AA719
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhFPW6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbhFPW57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:57:59 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9453C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:55:52 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j14so3749156ila.6
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=T8qbS7NbckTl+8pauuGnPZDRe2QMX0EMkKMWVI6/vyc=;
        b=piByfiAVktCUeODPguQVOgLWA9WD+W0MbMOxU4n8H5mviLVsEGs+9+IJdy+97kvgbY
         HZE5t0I19EsuZ/K5d+EficyShv9lz8X8BjEpOS7NMC8m9/KNavkNFwqkXyyAdy3tX0LU
         +1lI5wPVVYYMZyBPJJcxQ50T9vkHOxlcQuAa3h7Cwsd0jdpucOip00zvTR0qzuqlGqc7
         6D5UHJ1MsHiKyZQBULa+Y15pK+YU5A4IbBr67JOxOGtxnHPP+OS9R3mQ8oScZ+CMBslS
         EVEePBHUcbIXfOd8e+4CkBp/zBzAX6tg6hf7DftSJ597WE6suBY6HlMYUYk+4r0ornH6
         NOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=T8qbS7NbckTl+8pauuGnPZDRe2QMX0EMkKMWVI6/vyc=;
        b=ldDK2J+uOxodiiyOEGbNkCKY7sBlt9RHp9Lk8KYbo9OYkjaycjgae3O4rxW0wbdjIE
         sFBSRj8uQuZZiHgVyWMkEBPqPbjrOpQda20Cuusgf1G3BeZpoN7HTpTMhj/psAHbHyos
         AgCn7waJot1SY/EKG5GfbxJ7+I+vezr7LrChmzpYhLlUAPbd9dD4OdEqLCFS4vzf9YqI
         Ksk5ahcuDzZIxs3eAIdh2B4xlrVMyyH4P6mcy4qIkfn16xIJlRo92YJu7EoVBStJUy8V
         nIC+lIcO5S/qFUipIVp405G0yZI2nXTl+2KFIObYDde7OuFR1DJd1o8uVvX+Ge6RiGfL
         r+jw==
X-Gm-Message-State: AOAM530TsABh98XVNvWKdvz7C3ryj5DCH6I4oIuBhzuYzoUHA30hs4nW
        3vEFYqsYFY07I0KtrFFHCsg=
X-Google-Smtp-Source: ABdhPJxdrQvGGht9Z9qO+NZeMsxVm7h7v57xtwzmnrKCS34jLknRwSd4FhQoyIE8n8DQAvBTc621UQ==
X-Received: by 2002:a92:c0c9:: with SMTP id t9mr1321269ilf.195.1623884151593;
        Wed, 16 Jun 2021 15:55:51 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id 6sm2105581ioe.43.2021.06.16.15.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:55:51 -0700 (PDT)
Subject: [PATCH bpf v2 3/4] bpf: track subprog poke correctly
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 16 Jun 2021 15:55:39 -0700
Message-ID: <162388413965.151936.16775592753297385087.stgit@john-XPS-13-9370>
In-Reply-To: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

To fix track the map references by using a per subprogram used_maps array
and used_map_cnt values to hold references into the maps so when the
subprogram is released we can then untrack from the correct map using
the correct aux field.

Here we a slightly less than optimal because we insert all poke entries
into the used_map array, even duplicates. In theory we could get by
with only unique entries. This would require an extra collect the maps
stage though and seems unnecessary when this is simply an extra 8B
per duplicate. It also makes the logic simpler and the untrack hook
is happy to ignore entries previously removed.

Reported-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/bpf.h   |    1 +
 kernel/bpf/core.c     |    6 ++++--
 kernel/bpf/verifier.c |   36 +++++++++++++++++++++++++-----------
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 02b02cb29ce2..c037c67347c0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1780,6 +1780,7 @@ static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
 	return bpf_prog_get_type_dev(ufd, type, false);
 }
 
+void bpf_free_used_maps(struct bpf_prog_aux *aux);
 void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 			  struct bpf_map **used_maps, u32 len);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 5e31ee9f7512..ce5bb8932958 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2167,7 +2167,7 @@ void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 	}
 }
 
-static void bpf_free_used_maps(struct bpf_prog_aux *aux)
+void bpf_free_used_maps(struct bpf_prog_aux *aux)
 {
 	__bpf_free_used_maps(aux, aux->used_maps, aux->used_map_cnt);
 	kfree(aux->used_maps);
@@ -2211,8 +2211,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 #endif
 	if (aux->dst_trampoline)
 		bpf_trampoline_put(aux->dst_trampoline);
-	for (i = 0; i < aux->func_cnt; i++)
+	for (i = 0; i < aux->func_cnt; i++) {
+		bpf_free_used_maps(aux->func[i]->aux);
 		bpf_jit_free(aux->func[i]);
+	}
 	if (aux->func_cnt) {
 		kfree(aux->func);
 		bpf_prog_unlock_free(aux->prog);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 066fac9b5460..31c0f3ad9626 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12128,14 +12128,32 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
 		}
 
-		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
-			int ret;
+		/* overapproximate the number of map slots. Untrack will just skip
+		 * the lookup anyways and we avoid an extra layer of accounting.
+		 */
+		if (func[i]->aux->size_poke_tab) {
+			struct bpf_map **used_maps;
 
-			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
-			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
-			if (ret < 0) {
-				verbose(env, "tracking tail call prog failed\n");
+			used_maps = kmalloc_array(func[i]->aux->size_poke_tab,
+						  sizeof(struct bpf_map *),
+						  GFP_KERNEL);
+			if (!used_maps)
 				goto out_free;
+
+			func[i]->aux->used_maps = used_maps;
+
+			for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
+				int ret;
+
+				map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
+				ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
+				if (ret < 0) {
+					verbose(env, "tracking tail call prog failed\n");
+					goto out_free;
+				}
+				bpf_map_inc(map_ptr);
+				func[i]->aux->used_map_cnt++;
+				func[i]->aux->used_maps[j] = map_ptr;
 			}
 		}
 
@@ -12259,11 +12277,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 	for (i = 0; i < env->subprog_cnt; i++) {
 		if (!func[i])
 			continue;
-
-		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
-			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
-			map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
-		}
+		bpf_free_used_maps(func[i]->aux);
 		bpf_jit_free(func[i]);
 	}
 	kfree(func);


