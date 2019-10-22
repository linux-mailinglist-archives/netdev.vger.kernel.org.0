Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191EDE0DCB
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 23:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbfJVVar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 17:30:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:41034 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731437AbfJVVar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 17:30:47 -0400
Received: from 13.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.13] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iN1jp-000617-8M; Tue, 22 Oct 2019 23:30:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf] bpf: Fix use after free in bpf_get_prog_name
Date:   Tue, 22 Oct 2019 23:30:38 +0200
Message-Id: <875f2906a7c1a0691f2d567b4d8e4ea2739b1e88.1571779205.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25610/Tue Oct 22 10:54:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one more problematic case I noticed while recently fixing BPF kallsyms
handling in cd7455f1013e ("bpf: Fix use after free in subprog's jited symbol
removal") and that is bpf_get_prog_name().

If BTF has been attached to the prog, then we may be able to fetch the function
signature type id in kallsyms through prog->aux->func_info[prog->aux->func_idx].type_id.
However, while the BTF object itself is torn down via RCU callback, the prog's
aux->func_info is immediately freed via kvfree(prog->aux->func_info) once the
prog's refcount either hit zero or when subprograms were already exposed via
kallsyms and we hit the error path added in 5482e9a93c83 ("bpf: Fix memleak in
aux->func_info and aux->btf").

This violates RCU as well since kallsyms could be walked in parallel where we
could access aux->func_info. Hence, defer kvfree() to after RCU grace period.
Looking at ba64e7d85252 ("bpf: btf: support proper non-jit func info") there
is no reason/dependency where we couldn't defer the kvfree(aux->func_info) into
the RCU callback.

Fixes: 5482e9a93c83 ("bpf: Fix memleak in aux->func_info and aux->btf")
Fixes: ba64e7d85252 ("bpf: btf: support proper non-jit func info")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Yonghong Song <yhs@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index bcfc362de4f2..0937719b87e2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1326,6 +1326,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 {
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
+	kvfree(aux->func_info);
 	free_used_maps(aux);
 	bpf_prog_uncharge_memlock(aux->prog);
 	security_bpf_prog_free(aux);
@@ -1336,7 +1337,6 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
 	bpf_prog_kallsyms_del_all(prog);
 	btf_put(prog->aux->btf);
-	kvfree(prog->aux->func_info);
 	bpf_prog_free_linfo(prog);
 
 	if (deferred)
-- 
2.21.0

