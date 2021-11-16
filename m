Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A631452BB1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhKPHlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:42935 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230482AbhKPHls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099116"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099116"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857396"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:47 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [RFC PATCH bpf-next 8/8] libbpf: use bpf_redirect_xsk in the default program
Date:   Tue, 16 Nov 2021 07:37:42 +0000
Message-Id: <20211116073742.7941-9-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NOTE: This will be committed to libxdp, not libbpf as the xsk support in
that library has been deprecated. It is only here to serve as an example
of what will be added into libxdp.

Use the new bpf_redirect_xsk helper in the default program if the kernel
supports it.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/include/uapi/linux/bpf.h | 13 +++++++++
 tools/lib/bpf/xsk.c            | 50 ++++++++++++++++++++++++++++++++--
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6297eafdc40f..a33cc63c8e6f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4957,6 +4957,17 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * long bpf_redirect_xsk(void *ctx, struct bpf_map *map, u32 key, u64 flags)
+ *	Description
+ *		Redirect the packet to the XDP socket associated with the netdev queue if
+ *		the socket has an rx ring configured and is the only socket attached to the
+ *		queue. Fall back to bpf_redirect_map behavior if either condition is not met.
+ *	Return
+ *		**XDP_REDIRECT_XSK** if successful.
+ *
+ *		**XDP_REDIRECT** if the fall back was successful, or the value of the
+ *		two lower bits of the *flags* argument on error
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5140,6 +5151,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(redirect_xsk),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5520,6 +5532,7 @@ enum xdp_action {
 	XDP_PASS,
 	XDP_TX,
 	XDP_REDIRECT,
+	XDP_REDIRECT_XSK,
 };
 
 /* user accessible metadata for XDP packet hook
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index fdb22f5405c9..ec66d4206af0 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -50,6 +50,7 @@
 enum xsk_prog {
 	XSK_PROG_FALLBACK,
 	XSK_PROG_REDIRECT_FLAGS,
+	XSK_PROG_REDIRECT_XSK_FLAGS,
 };
 
 struct xsk_umem {
@@ -374,7 +375,15 @@ static enum xsk_prog get_xsk_prog(void)
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		BPF_EXIT_INSN(),
 	};
-	int prog_fd, map_fd, ret, insn_cnt = ARRAY_SIZE(insns);
+	struct bpf_insn insns_xsk[] = {
+		BPF_MOV64_REG(BPF_REG_CTX, BPF_REG_ARG1),
+		BPF_LD_MAP_FD(BPF_REG_2, 0),
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_MOV64_IMM(BPF_REG_4, XDP_PASS),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_xsk),
+		BPF_EXIT_INSN(),
+	};
+	int prog_fd, map_fd, ret;
 
 	memset(&map_attr, 0, sizeof(map_attr));
 	map_attr.map_type = BPF_MAP_TYPE_XSKMAP;
@@ -386,9 +395,25 @@ static enum xsk_prog get_xsk_prog(void)
 	if (map_fd < 0)
 		return detected;
 
+	insns_xsk[1].imm = map_fd;
+
+	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns_xsk, ARRAY_SIZE(insns_xsk),
+				NULL);
+	if (prog_fd < 0)
+		goto prog_redirect;
+
+	ret = bpf_prog_test_run(prog_fd, 0, &data_in, 1, &data_out, &size_out, &retval, &duration);
+	if (!ret && retval == XDP_PASS) {
+		detected = XSK_PROG_REDIRECT_XSK_FLAGS;
+		close(map_fd);
+		close(prog_fd);
+		return detected;
+	}
+
+prog_redirect:
 	insns[0].imm = map_fd;
 
-	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
+	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, ARRAY_SIZE(insns), NULL);
 	if (prog_fd < 0) {
 		close(map_fd);
 		return detected;
@@ -483,10 +508,29 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		BPF_EXIT_INSN(),
 	};
+
+	/* This is the post-5.13 kernel C-program:
+	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
+	 * {
+	 *     return bpf_redirect_xsk(ctx, &xsks_map, ctx->rx_queue_index, XDP_PASS);
+	 * }
+	 */
+	struct bpf_insn prog_redirect_xsk_flags[] = {
+		/* r3 = *(u32 *)(r1 + 16) */
+		BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, 16),
+		/* r2 = xskmap[] */
+		BPF_LD_MAP_FD(BPF_REG_2, ctx->xsks_map_fd),
+		/* r4 = XDP_PASS */
+		BPF_MOV64_IMM(BPF_REG_4, 2),
+		/* call bpf_redirect_xsk */
+		BPF_EMIT_CALL(BPF_FUNC_redirect_xsk),
+		BPF_EXIT_INSN(),
+	};
 	size_t insns_cnt[] = {sizeof(prog) / sizeof(struct bpf_insn),
 			      sizeof(prog_redirect_flags) / sizeof(struct bpf_insn),
+			      sizeof(prog_redirect_xsk_flags) / sizeof(struct bpf_insn),
 	};
-	struct bpf_insn *progs[] = {prog, prog_redirect_flags};
+	struct bpf_insn *progs[] = {prog, prog_redirect_flags, prog_redirect_xsk_flags};
 	enum xsk_prog option = get_xsk_prog();
 	LIBBPF_OPTS(bpf_prog_load_opts, opts,
 		.log_buf = log_buf,
-- 
2.17.1

