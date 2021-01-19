Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D932FBDBA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391648AbhASQKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 11:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391305AbhASPvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:51:48 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13645C0613ED;
        Tue, 19 Jan 2021 07:50:34 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u11so22401359ljo.13;
        Tue, 19 Jan 2021 07:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rXtdonoT6z2Mk/wuvXU5Af4iSxQJt1+pwiGmRinI7sw=;
        b=bdICjUBBA4dVZbd0hhiKShUfTjFCf0E6iFRssb7bZOJWDYmHTyYPZbplVF1nfCapL7
         z/F+SE2yXMGkJbAvHt8zm2Rq7xdv9dzjT2noTJsg2uG2C4I62HLzOOZHq/kyaB3GhhXS
         Gjbhq+/0LGDKdf8VGn/puy7D7nRjvFJ1UWbNkq8K7VF1pvm9uUQ8ABpA551H72gRKyIT
         rlLONxmHCl4FdrDytlEE/oWO22XIVwKJR5tmiJEASIKPqZLFruWAs56Yx4QTGOFMRl64
         jw6E+YgzyEi7+7xmHFS+BgUpPNB887KnACm/JM7iaGU5dpymV3H5oIpNK/6ND2PfpTDp
         Si6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXtdonoT6z2Mk/wuvXU5Af4iSxQJt1+pwiGmRinI7sw=;
        b=U5Ld/+5XXBN1d/ZtrjIex3nWPROvcBaUtcSmf7k0Q2aOwooVRo6JQcPP/nucPgap8j
         wdynfv3fUnV2gujwpJv5SMQDCGihPpgCGxTUEkEUwnRApdnMFKxp7Bo+VwsVWfStRF7p
         9EuiWnTbXL0k2IGKEoG72yYnE0U3jC5maTqu+DW0V1zodvNLAYgSMsLWE0m4G5mUilCJ
         O1bylCsIXDaFyZvjwd25XHx9XX5IRK7XfW+JfOC+zjHJxVnrjIK82+61t38FRZ88pQa6
         KLFpp7OO8JPMnZQibliSbf2NXHCIMfXR7mz9XojxY7+XWX3vApuIYMFS1IXiYQJ6HBok
         gMog==
X-Gm-Message-State: AOAM530zIablpxSEzMp3zDd+BZZLf1H27cJGkCJt5L98lWWsxPEv27aS
        or44j4ZTDk+zpVjbTY9QIs4=
X-Google-Smtp-Source: ABdhPJwP28Hgjquhg9jSWYGkjhjoW+HsaBf0D4OFGJJmwnY+Jg4RlvLAPfR4yftSSam7Euk0YOuINg==
X-Received: by 2002:a2e:9d85:: with SMTP id c5mr2279760ljj.80.1611071432635;
        Tue, 19 Jan 2021 07:50:32 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id h20sm2309249lfc.239.2021.01.19.07.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:50:31 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next v2 6/8] libbpf, xsk: select bpf_redirect_xsk(), if supported
Date:   Tue, 19 Jan 2021 16:50:11 +0100
Message-Id: <20210119155013.154808-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119155013.154808-1-bjorn.topel@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Select bpf_redirect_xsk() as the default AF_XDP BPF program, if
supported.

The bpf_redirect_xsk() helper does not require an XSKMAP, so make sure
that no map is created/updated when using it.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 46 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index c8642c6cb5d6..27e36d6d92a6 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -47,9 +47,12 @@
  #define PF_XDP AF_XDP
 #endif
 
+#define XSKMAP_NOT_NEEDED -1
+
 enum xsk_prog {
 	XSK_PROG_FALLBACK,
 	XSK_PROG_REDIRECT_FLAGS,
+	XSK_PROG_REDIRECT_XSK,
 };
 
 struct xsk_umem {
@@ -361,7 +364,11 @@ static enum xsk_prog get_xsk_prog(void)
 {
 	__u32 kver = get_kernel_version();
 
-	return kver < KERNEL_VERSION(5, 3, 0) ? XSK_PROG_FALLBACK : XSK_PROG_REDIRECT_FLAGS;
+	if (kver < KERNEL_VERSION(5, 3, 0))
+		return XSK_PROG_FALLBACK;
+	if (kver < KERNEL_VERSION(5, 12, 0))
+		return XSK_PROG_REDIRECT_FLAGS;
+	return XSK_PROG_REDIRECT_XSK;
 }
 
 static int xsk_load_xdp_prog(struct xsk_socket *xsk)
@@ -445,10 +452,25 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		BPF_EXIT_INSN(),
 	};
+
+	/* This is the post-5.12 kernel C-program:
+	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
+	 * {
+	 *     return bpf_redirect_xsk(ctx, XDP_PASS);
+	 * }
+	 */
+	struct bpf_insn prog_redirect_xsk[] = {
+		/* r2 = XDP_PASS */
+		BPF_MOV64_IMM(BPF_REG_2, 2),
+		/* call bpf_redirect_xsk */
+		BPF_EMIT_CALL(BPF_FUNC_redirect_xsk),
+		BPF_EXIT_INSN(),
+	};
 	size_t insns_cnt[] = {sizeof(prog) / sizeof(struct bpf_insn),
 			      sizeof(prog_redirect_flags) / sizeof(struct bpf_insn),
+			      sizeof(prog_redirect_xsk) / sizeof(struct bpf_insn),
 	};
-	struct bpf_insn *progs[] = {prog, prog_redirect_flags};
+	struct bpf_insn *progs[] = {prog, prog_redirect_flags, prog_redirect_xsk};
 	enum xsk_prog option = get_xsk_prog();
 
 	prog_fd = bpf_load_program(BPF_PROG_TYPE_XDP, progs[option], insns_cnt[option],
@@ -508,12 +530,22 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 	return ret;
 }
 
+static bool xskmap_required(void)
+{
+	return get_xsk_prog() != XSK_PROG_REDIRECT_XSK;
+}
+
 static int xsk_create_bpf_maps(struct xsk_socket *xsk)
 {
 	struct xsk_ctx *ctx = xsk->ctx;
 	int max_queues;
 	int fd;
 
+	if (!xskmap_required()) {
+		ctx->xsks_map_fd = XSKMAP_NOT_NEEDED;
+		return 0;
+	}
+
 	max_queues = xsk_get_max_queues(xsk);
 	if (max_queues < 0)
 		return max_queues;
@@ -532,6 +564,9 @@ static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
 {
 	struct xsk_ctx *ctx = xsk->ctx;
 
+	if (ctx->xsks_map_fd == XSKMAP_NOT_NEEDED)
+		return;
+
 	bpf_map_delete_elem(ctx->xsks_map_fd, &ctx->queue_id);
 	close(ctx->xsks_map_fd);
 }
@@ -563,7 +598,7 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	if (err)
 		goto out_map_ids;
 
-	ctx->xsks_map_fd = -1;
+	ctx->xsks_map_fd = XSKMAP_NOT_NEEDED;
 
 	for (i = 0; i < prog_info.nr_map_ids; i++) {
 		fd = bpf_map_get_fd_by_id(map_ids[i]);
@@ -585,7 +620,7 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	}
 
 	err = 0;
-	if (ctx->xsks_map_fd == -1)
+	if (ctx->xsks_map_fd == XSKMAP_NOT_NEEDED && xskmap_required())
 		err = -ENOENT;
 
 out_map_ids:
@@ -597,6 +632,9 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 {
 	struct xsk_ctx *ctx = xsk->ctx;
 
+	if (ctx->xsks_map_fd == XSKMAP_NOT_NEEDED)
+		return 0;
+
 	return bpf_map_update_elem(ctx->xsks_map_fd, &ctx->queue_id,
 				   &xsk->fd, 0);
 }
-- 
2.27.0

