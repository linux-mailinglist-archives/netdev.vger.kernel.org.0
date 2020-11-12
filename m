Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106372B0169
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKLI7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgKLI7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 03:59:01 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390A5C0613D1;
        Thu, 12 Nov 2020 00:59:00 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a9so6179881lfh.2;
        Thu, 12 Nov 2020 00:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2bnkjrx1xWoQdsVeRIpLXDfRlrh46E9LKTtm/nOQmtk=;
        b=f76KiPLTmMUougAsbHj2IhRkcT7rMHz0oDUax/1CfDKSn1kJY2nFmJd0QeL2aGA57K
         u+h/p5peMMZ2Vge/a/HkRHJ6DonKaTt9SLEBREe9U1YYfL/tFpr0M1keFYe8oFExlJOK
         X7N/l6FXP9iTGl4s0nv7if/MIz6grSnTd67wlHAASFqGYcdoj/dkMPthwyAzRjgJbpkA
         fkDwjsh4HRr3a/pDKbOYUlAxlkP4jq4cXtPlO0/jDq4GUUbQ6aHtrGAM0wVHXZJyvMPZ
         6bTEOxw124ug5SH5HnkfXJNAgmJ4OPp2QC10Ua0hKQ/b3vqHsv2lofXr/TaZK+PkXkwG
         EG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2bnkjrx1xWoQdsVeRIpLXDfRlrh46E9LKTtm/nOQmtk=;
        b=REQE6XZ0BHn/9l/acRE67bpZSZ4us94/34FaUDLIeEvW2Gzomfc8BK1+FvTT1thye/
         Av2gAhmZaZWed0ckrVmmShjbwXueUsz3ifuECcvNaM7N3F3UtbtJBA4YYEFd+q3Ji43/
         BmAgo4/AK9fdN1UHbcl2eF2dRCczhOOZYZMsnlPx3QsbXSPUaFcOgBl2+rjvtzuecbAg
         WBYR4UQLLYP5sSKEUMZ2g2GKc2TlkrPwl05NDwC/OfLALN6DEe5zRIsrQNdCBaKjZawt
         F+AY3bJLh6ve9NwkVPhWG7kWqDeZuxl7D5C3f37KQ9S+nHECYRccreYCCYOY8hvKeTKC
         o3tQ==
X-Gm-Message-State: AOAM5336PCmROsn9kFE6aRfnC+icDXDiWw567Zvt8Z3B+ld3SzZmlz6I
        /GKZxEh+bEHuijx2b7HKPLo=
X-Google-Smtp-Source: ABdhPJw2wTZRT1kmQfegVOgMEHn2jXfyKWAUDyPOKPsOV5Ss1XUlShpdIpqPYAwbXRyyw1wnOD/Dsw==
X-Received: by 2002:a19:c815:: with SMTP id y21mr9380406lff.589.1605171538667;
        Thu, 12 Nov 2020 00:58:58 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id i4sm486833ljj.6.2020.11.12.00.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 00:58:58 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v2 bpf-next 1/2] libbpf: separate XDP program load with xsk socket creation
Date:   Thu, 12 Nov 2020 09:58:53 +0100
Message-Id: <20201112085854.3764-2-mariuszx.dudek@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201112085854.3764-1-mariuszx.dudek@intel.com>
References: <20201112085854.3764-1-mariuszx.dudek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mariusz Dudek <mariuszx.dudek@intel.com>

Add support for separation of eBPF program load and xsk socket
creation.

This is needed for use-case when you want to privide as little
privileges as possible to the data plane application that will
handle xsk socket creation and incoming traffic.

With this patch the data entity container can be run with only
CAP_NET_RAW capability to fulfill its purpose of creating xsk
socket and handling packages. In case your umem is larger or
equal process limit for MEMLOCK you need either increase the
limit or CAP_IPC_LOCK capability.

To resolve privileges issue two APIs are introduced:

- xsk_setup_xdp_prog - prepares bpf program if given and
loads it on a selected network interface or loads the built in
XDP program, if no XDP program is supplied. It can also return
xsks_map_fd which is needed by unprivileged process to update
xsks_map with AF_XDP socket "fd"

- xsk_socket__update_xskmap - inserts an AF_XDP socket into an xskmap
for a particular xsk_socket

Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
---
 tools/lib/bpf/libbpf.map |   2 +
 tools/lib/bpf/xsk.c      | 160 ++++++++++++++++++++++++++++++++-------
 tools/lib/bpf/xsk.h      |  15 ++++
 3 files changed, 151 insertions(+), 26 deletions(-)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 29ff4807b909..73aa12388055 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -336,6 +336,8 @@ LIBBPF_0.2.0 {
 		perf_buffer__epoll_fd;
 		perf_buffer__consume_buffer;
 		xsk_socket__create_shared;
+		xsk_setup_xdp_prog;
+		xsk_socket__update_xskmap;
 } LIBBPF_0.1.0;
 
 LIBBPF_0.3.0 {
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e3c98c007825..88b8e01fafe7 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -351,13 +351,8 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
 COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
 DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
 
-static int xsk_load_xdp_prog(struct xsk_socket *xsk)
+static int get_bpf_prog(struct bpf_prog_cfg_opts *cfg_ptr, int xsks_map_fd)
 {
-	static const int log_buf_size = 16 * 1024;
-	struct xsk_ctx *ctx = xsk->ctx;
-	char log_buf[log_buf_size];
-	int err, prog_fd;
-
 	/* This is the C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
 	 * {
@@ -382,7 +377,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* *(u32 *)(r10 - 4) = r2 */
 		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -4),
 		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
+		BPF_LD_MAP_FD(BPF_REG_1, xsks_map_fd),
 		/* r3 = XDP_PASS */
 		BPF_MOV64_IMM(BPF_REG_3, 2),
 		/* call bpf_redirect_map */
@@ -394,7 +389,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* r2 += -4 */
 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
 		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
+		BPF_LD_MAP_FD(BPF_REG_1, xsks_map_fd),
 		/* call bpf_map_lookup_elem */
 		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
 		/* r1 = r0 */
@@ -406,7 +401,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* r2 = *(u32 *)(r10 - 4) */
 		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
 		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
+		BPF_LD_MAP_FD(BPF_REG_1, xsks_map_fd),
 		/* r3 = 0 */
 		BPF_MOV64_IMM(BPF_REG_3, 0),
 		/* call bpf_redirect_map */
@@ -414,17 +409,42 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* The jumps are to this instruction */
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
 
-	prog_fd = bpf_load_program(BPF_PROG_TYPE_XDP, prog, insns_cnt,
-				   "LGPL-2.1 or BSD-2-Clause", 0, log_buf,
+	cfg_ptr->prog = malloc(sizeof(prog));
+	if (!cfg_ptr->prog)
+		return -ENOMEM;
+	memcpy(cfg_ptr->prog, prog, sizeof(prog));
+	cfg_ptr->license = "LGPL-2.1 or BSD-2-Clause";
+	cfg_ptr->insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
+
+	return 0;
+}
+
+static int xsk_load_xdp_prog(struct xsk_socket *xsk, struct bpf_prog_cfg_opts *user_cfg)
+{
+	static const int log_buf_size = 16 * 1024;
+	struct xsk_ctx *ctx = xsk->ctx;
+	char log_buf[log_buf_size];
+	struct bpf_prog_cfg_opts cfg;
+	int err, prog_fd;
+
+	if (user_cfg && user_cfg->insns_cnt) {
+		cfg = *user_cfg;
+	} else {
+		err = get_bpf_prog(&cfg, ctx->xsks_map_fd);
+		if (err)
+			return err;
+	}
+
+	prog_fd = bpf_load_program(BPF_PROG_TYPE_XDP, cfg.prog, cfg.insns_cnt,
+				   cfg.license, 0, log_buf,
 				   log_buf_size);
 	if (prog_fd < 0) {
 		pr_warn("BPF log buffer:\n%s", log_buf);
 		return prog_fd;
 	}
 
-	err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, prog_fd,
+	err = bpf_set_link_xdp_fd(ctx->ifindex, prog_fd,
 				  xsk->config.xdp_flags);
 	if (err) {
 		close(prog_fd);
@@ -566,8 +586,43 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 				   &xsk->fd, 0);
 }
 
-static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
+static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
+{
+	char ifname[IFNAMSIZ];
+	struct xsk_ctx *ctx;
+	char *interface;
+	int res = -1;
+
+	ctx = calloc(1, sizeof(*ctx));
+	if (!ctx)
+		goto error_ctx;
+
+	interface = if_indextoname(ifindex, &ifname[0]);
+	if (!interface) {
+		res = -errno;
+		goto error_ifindex;
+	}
+
+	ctx->ifindex = ifindex;
+	strncpy(ctx->ifname, ifname, IFNAMSIZ - 1);
+	ctx->ifname[IFNAMSIZ - 1] = 0;
+
+	xsk->ctx = ctx;
+
+	return 0;
+
+error_ifindex:
+	free(ctx);
+error_ctx:
+	return res;
+}
+
+static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
+				struct bpf_prog_cfg_opts *cfg,
+				bool force_set_map,
+				int *xsks_map_fd)
 {
+	struct xsk_socket *xsk = _xdp;
 	struct xsk_ctx *ctx = xsk->ctx;
 	__u32 prog_id = 0;
 	int err;
@@ -578,14 +633,17 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		return err;
 
 	if (!prog_id) {
-		err = xsk_create_bpf_maps(xsk);
-		if (err)
-			return err;
+		if (!cfg || !cfg->insns_cnt) {
+			err = xsk_create_bpf_maps(xsk);
+			if (err)
+				return err;
+		} else {
+			ctx->xsks_map_fd = cfg->xsks_map_fd;
+		}
 
-		err = xsk_load_xdp_prog(xsk);
+		err = xsk_load_xdp_prog(xsk, cfg);
 		if (err) {
-			xsk_delete_bpf_maps(xsk);
-			return err;
+			goto err_load_xdp_prog;
 		}
 	} else {
 		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
@@ -598,15 +656,29 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		}
 	}
 
-	if (xsk->rx)
+	if (xsk->rx || force_set_map) {
 		err = xsk_set_bpf_maps(xsk);
-	if (err) {
-		xsk_delete_bpf_maps(xsk);
-		close(ctx->prog_fd);
-		return err;
+		if (err) {
+			if (!prog_id) {
+				goto err_set_bpf_maps;
+			} else {
+				close(ctx->prog_fd);
+				return err;
+			}
+		}
 	}
+	if (xsks_map_fd)
+		*xsks_map_fd = ctx->xsks_map_fd;
 
 	return 0;
+
+err_set_bpf_maps:
+	close(ctx->prog_fd);
+	bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
+err_load_xdp_prog:
+	xsk_delete_bpf_maps(xsk);
+
+	return err;
 }
 
 static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
@@ -689,6 +761,42 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	return ctx;
 }
 
+static void xsk_destroy_xsk_struct(struct xsk_socket *xsk)
+{
+	free(xsk->ctx);
+	free(xsk);
+}
+
+int xsk_socket__update_xskmap(struct xsk_socket *xsk, int fd)
+{
+	xsk->ctx->xsks_map_fd = fd;
+	return xsk_set_bpf_maps(xsk);
+}
+
+int xsk_setup_xdp_prog(int ifindex, struct bpf_prog_cfg_opts *opts,
+		       int *xsks_map_fd)
+{
+	struct xsk_socket *xsk;
+	int res = -1;
+
+	if (!OPTS_VALID(opts, bpf_prog_cfg_opts))
+		return -EINVAL;
+
+	xsk = calloc(1, sizeof(*xsk));
+	if (!xsk)
+		return res;
+
+	res = xsk_create_xsk_struct(ifindex, xsk);
+	if (res)
+		return -EINVAL;
+
+	res = __xsk_setup_xdp_prog(xsk, opts, false, xsks_map_fd);
+
+	xsk_destroy_xsk_struct(xsk);
+
+	return res;
+}
+
 int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			      const char *ifname,
 			      __u32 queue_id, struct xsk_umem *umem,
@@ -838,7 +946,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	ctx->prog_fd = -1;
 
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
-		err = xsk_setup_xdp_prog(xsk);
+		err = __xsk_setup_xdp_prog(xsk, NULL, false, NULL);
 		if (err)
 			goto out_mmap_tx;
 	}
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 1069c46364ff..c852ec742437 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -201,6 +201,21 @@ struct xsk_umem_config {
 	__u32 flags;
 };
 
+struct bpf_prog_cfg_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	struct bpf_insn *prog;
+	const char *license;
+	size_t insns_cnt;
+	int xsks_map_fd;
+};
+#define bpf_prog_cfg_opts__last_field xsks_map_fd
+
+LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
+				  struct bpf_prog_cfg_opts *opts,
+				  int *xsks_map_fd);
+LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
+				 int xsks_map_fd);
+
 /* Flags for the libbpf_flags field. */
 #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
 
-- 
2.20.1

