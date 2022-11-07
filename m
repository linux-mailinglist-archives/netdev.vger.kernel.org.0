Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685A361EECE
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiKGJYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiKGJXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:23:52 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D76E9588;
        Mon,  7 Nov 2022 01:23:52 -0800 (PST)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N5QlN1MxdzRp5Z;
        Mon,  7 Nov 2022 17:23:44 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:48 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:47 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <asavkov@redhat.com>, <delyank@fb.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH bpf v2 3/5] libbpf: Skip adjust mem size for load pointer in 32-bit arch in CO_RE
Date:   Mon, 7 Nov 2022 17:20:30 +0800
Message-ID: <20221107092032.178235-4-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20221107092032.178235-1-yangjihong1@huawei.com>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_core_patch_insn modifies load's mem size from 8 bytes to 4 bytes.
As a result, the bpf check fails, we need to skip adjust mem size to fit
the verifier.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 184ce1684dcd..e1c21b631a0b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5634,6 +5634,28 @@ static int bpf_core_resolve_relo(struct bpf_program *prog,
 				       targ_res);
 }
 
+static bool
+bpf_core_patch_insn_skip(const struct btf *local_btf, const struct bpf_insn *insn,
+			 const struct bpf_core_relo_res *res)
+{
+	__u8 class;
+	const struct btf_type *orig_t;
+
+	class = BPF_CLASS(insn->code);
+	orig_t = btf_type_by_id(local_btf, res->orig_type_id);
+
+	/*
+	 * verifier has to see a load of a pointer as a 8-byte load,
+	 * CO_RE should not screws up access, bpf_core_patch_insn modifies
+	 * load's mem size from 8 bytes to 4 bytes in 32-bit arch,
+	 * so we skip adjust mem size.
+	 */
+	if (class == BPF_LDX && btf_is_ptr(orig_t))
+		return true;
+
+	return false;
+}
+
 static int
 bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 {
@@ -5730,11 +5752,13 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 				goto out;
 			}
 
-			err = bpf_core_patch_insn(prog->name, insn, insn_idx, rec, i, &targ_res);
-			if (err) {
-				pr_warn("prog '%s': relo #%d: failed to patch insn #%u: %d\n",
-					prog->name, i, insn_idx, err);
-				goto out;
+			if (!bpf_core_patch_insn_skip(obj->btf, insn, &targ_res)) {
+				err = bpf_core_patch_insn(prog->name, insn, insn_idx, rec, i, &targ_res);
+				if (err) {
+					pr_warn("prog '%s': relo #%d: failed to patch insn #%u: %d\n",
+						prog->name, i, insn_idx, err);
+					goto out;
+				}
 			}
 		}
 	}
-- 
2.30.GIT

