Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29642B78D6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgKRIda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgKRIda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:33:30 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AD6C0613D4;
        Wed, 18 Nov 2020 00:33:28 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id z21so1710336lfe.12;
        Wed, 18 Nov 2020 00:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+AVzmHN1unh2F44Ye9cmaZ1Jn+0n2NfEt8uFe+D8pTc=;
        b=Rb7pWLTqFDxHscwSbpVJiPp0N9HugaBJwmfhfBhOWjCWS1+XZcbWNFV4pm40acoUlU
         gDoQB93Rj9iQKHLkH6qdKjvGQ7btgpTWtYSnYUITk/DEh/WkxIFvKHCO0WQ3buPwOTA+
         s9TTcQJq/XLt+WAHMWaaOo7vTTE0waKvysOe1P8dKSQnOPpp540YdNN8Nxa9uRaToed0
         qjzbMejzlYgGHfaOEUi0+j/CoLoT15MRaqIundimh8uZkK69YCUQEj8m6EYsmQKuf+1J
         eX/zeEOnjeAem4Cp385fDHyTx5IK+4+1Ia9F1gM3l10i2V7Ax/LcZBsJwK+EFlygZd3v
         iegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+AVzmHN1unh2F44Ye9cmaZ1Jn+0n2NfEt8uFe+D8pTc=;
        b=ugHQBd4mmj5KW3fXULfnCHOUerTzzj1AXwEQpwN06jQmYvIXOSB+/x7CJoV/UuDq5i
         DTKeWArabVva71X9V+PFGPW/uZnrzLbxUWV9hwjjTE26kP6318QYi+I8h+ydSq5Xihpb
         sNH/YdFhozjRBAcdFFtsjVA8cRb2BAKJuJFO/E9TbUHyUjWg4ZdT2+SOjj0WfMAMGEHj
         Oxqt2vpwqWrtB8ZNb9JMzrZIJ2dBhH12QLrOSZA9wZ0vn2/ykTK0ghy+AG+kma5NuzZ0
         u6FGyXQCrGADC/H8len9FqEooxrQbL9m1FigLtZt/5baaL7Lnm9EsZIDi+j7kkCIm+T0
         wUow==
X-Gm-Message-State: AOAM531+S8/uJ7L4JuITm5MFfZIYpJ0N6vgUEFhV3LbXP9Yio0IqUq5h
        OusIGXXyq+DMkm2jo+YLx4A=
X-Google-Smtp-Source: ABdhPJwza3BMuvSApMGhaahWghArZ4BAw2Xj9SOkMdkGJGEkUacGQy62NJQrcpo2efEiOYi5v0dVKA==
X-Received: by 2002:ac2:5475:: with SMTP id e21mr324372lfn.153.1605688406935;
        Wed, 18 Nov 2020 00:33:26 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id r12sm3542107lfc.80.2020.11.18.00.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 00:33:26 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v3 bpf-next 1/2] libbpf: separate XDP program load with xsk socket creation
Date:   Wed, 18 Nov 2020 09:32:52 +0100
Message-Id: <20201118083253.4150-2-mariuszx.dudek@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118083253.4150-1-mariuszx.dudek@intel.com>
References: <20201118083253.4150-1-mariuszx.dudek@intel.com>
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

- xsk_setup_xdp_prog - loads the built in XDP program. It can
also return xsks_map_fd which is needed by unprivileged process
to update xsks_map with AF_XDP socket "fd"

- xsk_socket__update_xskmap - inserts an AF_XDP socket into an xskmap
for a particular xsk_socket

Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
---
 tools/lib/bpf/libbpf.map |  2 +
 tools/lib/bpf/xsk.c      | 97 ++++++++++++++++++++++++++++++++++++----
 tools/lib/bpf/xsk.h      |  5 +++
 3 files changed, 95 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 29ff4807b909..d939d5ac092e 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -345,4 +345,6 @@ LIBBPF_0.3.0 {
 		btf__parse_split;
 		btf__new_empty_split;
 		btf__new_split;
+		xsk_setup_xdp_prog;
+		xsk_socket__update_xskmap;
 } LIBBPF_0.2.0;
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 9bc537d0b92d..e16f920d2ef9 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -566,8 +566,42 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 				   &xsk->fd, 0);
 }
 
-static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
+static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
 {
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
+				bool force_set_map,
+				int *xsks_map_fd)
+{
+	struct xsk_socket *xsk = _xdp;
 	struct xsk_ctx *ctx = xsk->ctx;
 	__u32 prog_id = 0;
 	int err;
@@ -584,8 +618,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 
 		err = xsk_load_xdp_prog(xsk);
 		if (err) {
-			xsk_delete_bpf_maps(xsk);
-			return err;
+			goto err_load_xdp_prog;
 		}
 	} else {
 		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
@@ -598,15 +631,29 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
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
@@ -689,6 +736,38 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
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
+int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)
+{
+	struct xsk_socket *xsk;
+	int res = -1;
+
+	xsk = calloc(1, sizeof(*xsk));
+	if (!xsk)
+		return res;
+
+	res = xsk_create_xsk_struct(ifindex, xsk);
+	if (res)
+		return -EINVAL;
+
+	res = __xsk_setup_xdp_prog(xsk, false, xsks_map_fd);
+
+	xsk_destroy_xsk_struct(xsk);
+
+	return res;
+}
+
 int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			      const char *ifname,
 			      __u32 queue_id, struct xsk_umem *umem,
@@ -838,7 +917,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	ctx->prog_fd = -1;
 
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
-		err = xsk_setup_xdp_prog(xsk);
+		err = __xsk_setup_xdp_prog(xsk, false, NULL);
 		if (err)
 			goto out_mmap_tx;
 	}
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 1069c46364ff..5b74c17ed3d4 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -201,6 +201,11 @@ struct xsk_umem_config {
 	__u32 flags;
 };
 
+LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
+				  int *xsks_map_fd);
+LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
+				 int xsks_map_fd);
+
 /* Flags for the libbpf_flags field. */
 #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
 
-- 
2.20.1

