Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560405FE21
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfGDV1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:27:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35572 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfGDV1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:27:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id c27so7891453wrb.2
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xwMnaUxwwx/VpH4WlxvyV6kBbBg37qwOURMFSuhvxtQ=;
        b=yYo8w836VjTG14z3azN+zUiSMCSYD2NhI2uECFaEIxzA+b/Khl929Q6AmWcw2eTxBr
         gi6u8gNyUXs0293rJpsF9YUOi7H5YQuGTYyeiNY6bXFGwfYXhxmBoANgRSLBBkYjXybB
         t1MqdhcodU8b9OlZkf2MrcPnEfUuUYb83nHMynD+2B8/dTOvXL473WVeLHDu/SoXgN0N
         nInMCmVVWrTlxsFN9cEGUoyXEpmzJ69Nl1QXTHj8dn0o4rCqI46BgfknaswjwLT1Rg89
         M+sampQ01xl52Lxdsln/kyjyYhXFx8kDEZIozD7Qot0E1FWygWsQeFRKKY+E0f9Ex8sP
         3VEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xwMnaUxwwx/VpH4WlxvyV6kBbBg37qwOURMFSuhvxtQ=;
        b=gH9oJH0ih1CpmjcozAEaKMiYFAHtY/BrhvD/KsRh3upUCQvDjX9c4A+CkJFhXCXR/b
         TIh5fj9yJrIZdO6vs/0QGoE6Hxw09wMxfaKzecYXlcjGzMneIJKDVp8W/YRcr06OZSSW
         jt18PvkMqZoduviIqc7bbGr8iMFVvPdmgsMWZLSrwbcs2yVajRrDMcgMDr2i9lAdzie9
         wshgSgR+cr3mxHBF+NBctCwq8qipKQ3up0Pr8Th08HR0xjWg80QMlmmWfD68tIKca+ml
         QhqqyMTc6fVx28MyrF5LfmOfhg7b3bB96PaBGDA7xmLTvqNCnKEcrSml3eKv8L+a9lQT
         XzCw==
X-Gm-Message-State: APjAAAXaHqBBYIDKpc6Y0ZwSFxOtyu9/HnMVFw7cSuBQBO1E7cw1x1W7
        s88uvlv3NYeXz7kuXFpKeC/Sxg==
X-Google-Smtp-Source: APXvYqy/mDpC1fOZQHhba2byXK+sQ/X+siE4P2MxP1OwMJDOFmHji+q7NhHQtLkik4He8lrZ9ZwBSA==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr345467wrw.337.1562275626065;
        Thu, 04 Jul 2019 14:27:06 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t17sm9716654wrs.45.2019.07.04.14.27.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 14:27:05 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     ecree@solarflare.com, naveen.n.rao@linux.vnet.ibm.com,
        andriin@fb.com, jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [RFC bpf-next 2/8] bpf: extend list based insn patching infra to verification layer
Date:   Thu,  4 Jul 2019 22:26:45 +0100
Message-Id: <1562275611-31790-3-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verification layer also needs to handle auxiliar info as well as adjusting
subprog start.

At this layer, insns inside patch buffer could be jump, but they should
have been resolved, meaning they shouldn't jump to insn outside of the
patch buffer. Lineration function for this layer won't touch insns inside
patch buffer.

Adjusting subprog is finished along with adjusting jump target when the
input will cover bpf to bpf call insn, re-register subprog start is cheap.
But adjustment when there is insn deleteion is not considered yet.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/verifier.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a2e7637..2026d64 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8350,6 +8350,156 @@ static void opt_hard_wire_dead_code_branches(struct bpf_verifier_env *env)
 	}
 }
 
+/* Linearize bpf list insn to array (verifier layer). */
+static struct bpf_verifier_env *
+verifier_linearize_list_insn(struct bpf_verifier_env *env,
+			     struct bpf_list_insn *list)
+{
+	u32 *idx_map, idx, orig_cnt, fini_cnt = 0;
+	struct bpf_subprog_info *new_subinfo;
+	struct bpf_insn_aux_data *new_data;
+	struct bpf_prog *prog = env->prog;
+	struct bpf_verifier_env *ret_env;
+	struct bpf_insn *insns, *insn;
+	struct bpf_list_insn *elem;
+	int ret;
+
+	/* Calculate final size. */
+	for (elem = list; elem; elem = elem->next)
+		if (!(elem->flag & LIST_INSN_FLAG_REMOVED))
+			fini_cnt++;
+
+	orig_cnt = prog->len;
+	insns = prog->insnsi;
+	/* If prog length remains same, nothing else to do. */
+	if (fini_cnt == orig_cnt) {
+		for (insn = insns, elem = list; elem; elem = elem->next, insn++)
+			*insn = elem->insn;
+		return env;
+	}
+	/* Realloc insn buffer when necessary. */
+	if (fini_cnt > orig_cnt)
+		prog = bpf_prog_realloc(prog, bpf_prog_size(fini_cnt),
+					GFP_USER);
+	if (!prog)
+		return ERR_PTR(-ENOMEM);
+	insns = prog->insnsi;
+	prog->len = fini_cnt;
+	ret_env = env;
+
+	/* idx_map[OLD_IDX] = NEW_IDX */
+	idx_map = kvmalloc(orig_cnt * sizeof(u32), GFP_KERNEL);
+	if (!idx_map)
+		return ERR_PTR(-ENOMEM);
+	memset(idx_map, 0xff, orig_cnt * sizeof(u32));
+
+	/* Use the same alloc method used when allocating env->insn_aux_data. */
+	new_data = vzalloc(array_size(sizeof(*new_data), fini_cnt));
+	if (!new_data) {
+		kvfree(idx_map);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Copy over insn + calculate idx_map. */
+	for (idx = 0, elem = list; elem; elem = elem->next) {
+		int orig_idx = elem->orig_idx - 1;
+
+		if (orig_idx >= 0) {
+			idx_map[orig_idx] = idx;
+
+			if (elem->flag & LIST_INSN_FLAG_REMOVED)
+				continue;
+
+			new_data[idx] = env->insn_aux_data[orig_idx];
+
+			if (elem->flag & LIST_INSN_FLAG_PATCHED)
+				new_data[idx].zext_dst =
+					insn_has_def32(env, &elem->insn);
+		} else {
+			new_data[idx].seen = true;
+			new_data[idx].zext_dst = insn_has_def32(env,
+								&elem->insn);
+		}
+		insns[idx++] = elem->insn;
+	}
+
+	new_subinfo = kvzalloc(sizeof(env->subprog_info), GFP_KERNEL);
+	if (!new_subinfo) {
+		kvfree(idx_map);
+		vfree(new_data);
+		return ERR_PTR(-ENOMEM);
+	}
+	memcpy(new_subinfo, env->subprog_info, sizeof(env->subprog_info));
+	memset(env->subprog_info, 0, sizeof(env->subprog_info));
+	env->subprog_cnt = 0;
+	env->prog = prog;
+	ret = add_subprog(env, 0);
+	if (ret < 0) {
+		ret_env = ERR_PTR(ret);
+		goto free_all_ret;
+	}
+	/* Relocate jumps using idx_map.
+	 *   old_dst = jmp_insn.old_target + old_pc + 1;
+	 *   new_dst = idx_map[old_dst] = jmp_insn.new_target + new_pc + 1;
+	 *   jmp_insn.new_target = new_dst - new_pc - 1;
+	 */
+	for (idx = 0, elem = list; elem; elem = elem->next) {
+		int orig_idx = elem->orig_idx;
+
+		if (elem->flag & LIST_INSN_FLAG_REMOVED)
+			continue;
+		if ((elem->flag & LIST_INSN_FLAG_PATCHED) || !orig_idx) {
+			idx++;
+			continue;
+		}
+
+		ret = bpf_jit_adj_imm_off(&insns[idx], orig_idx - 1, idx,
+					  idx_map);
+		if (ret < 0) {
+			ret_env = ERR_PTR(ret);
+			goto free_all_ret;
+		}
+		/* Recalculate subprog start as we are at bpf2bpf call insn. */
+		if (ret > 0) {
+			ret = add_subprog(env, idx + insns[idx].imm + 1);
+			if (ret < 0) {
+				ret_env = ERR_PTR(ret);
+				goto free_all_ret;
+			}
+		}
+		idx++;
+	}
+	if (ret < 0) {
+		ret_env = ERR_PTR(ret);
+		goto free_all_ret;
+	}
+
+	env->subprog_info[env->subprog_cnt].start = fini_cnt;
+	for (idx = 0; idx <= env->subprog_cnt; idx++)
+		new_subinfo[idx].start = env->subprog_info[idx].start;
+	memcpy(env->subprog_info, new_subinfo, sizeof(env->subprog_info));
+
+	/* Adjust linfo.
+	 * FIXME: no support for insn removal at the moment.
+	 */
+	if (prog->aux->nr_linfo) {
+		struct bpf_line_info *linfo = prog->aux->linfo;
+		u32 nr_linfo = prog->aux->nr_linfo;
+
+		for (idx = 0; idx < nr_linfo; idx++)
+			linfo[idx].insn_off = idx_map[linfo[idx].insn_off];
+	}
+	vfree(env->insn_aux_data);
+	env->insn_aux_data = new_data;
+	goto free_mem_list_ret;
+free_all_ret:
+	vfree(new_data);
+free_mem_list_ret:
+	kvfree(new_subinfo);
+	kvfree(idx_map);
+	return ret_env;
+}
+
 static int opt_remove_dead_code(struct bpf_verifier_env *env)
 {
 	struct bpf_insn_aux_data *aux_data = env->insn_aux_data;
-- 
2.7.4

