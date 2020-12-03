Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35D72CD210
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgLCJGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388299AbgLCJGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:06:33 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32837C061A4E;
        Thu,  3 Dec 2020 01:05:53 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id r18so1732944ljc.2;
        Thu, 03 Dec 2020 01:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TlAaOHv+D4f3ZAj/if+FE/lW/YqKpU9owoxKajM6LoE=;
        b=m+uFckbs0VF4gLsZ1h/3LSDsqPgoCXtxTO1IHoOqzt6re0XTMJEcosMmeyeCaPmXQW
         n/TgITbrMuievqB5vUAPNlPe1sh+Y4OByibjaTyGN4mk6NhZtYw4hmLJkBP5e9pa02NA
         HdFQ4xlKlrL7lHJDdjrXsN7yJWfROOa58YFk0xA0SmCBid0EyWvyVvMuEChh5N3x1lia
         7sH6/6gJNot3A4zuuBfZX/5F/Wq+FzpMiq3ywjTdY4VdzEw2oBPKrmf6geUj1P0HDh+D
         ray9hLfXMvY6gTyOPm7XbiAkewHoWrmY+DOGSdXLwCCrmAOGfDSrSc+v7nqkO1EyFR9/
         lwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TlAaOHv+D4f3ZAj/if+FE/lW/YqKpU9owoxKajM6LoE=;
        b=Xd1OSXycnY1X6bsV5iPzBoFk+CmoEzEuTYvg+GIDbf9f7VTVSOnUw3mC5xb2b+mUmX
         UsNIKtBk1R49SUAZ/gNdtx6+ePMES/qsdlwGtEBEmRZeKs9YJOiapdrwnXFMNM2L2AaL
         oLxls5eO8rAPegfiWqnOwGf9p3mA5p+viUwJD5j6+esk4ftHSJcMs4v8LP0TZmD+6DOu
         0osWxYsfxkyJGojsSPcxE7/lzAhNs1OBHdAMFczqaV8PEtjR7LjfVmyT5q9q66BlszJg
         7h5Nd4jQPbLK+W7aSTfxn6lupNLg5aFTUGxOkuLr9i7k2otlvCAcnb6HudPM349kxB5f
         6uNg==
X-Gm-Message-State: AOAM5314raKHP+dmgNRtBlMy89KU+vdwYKluzDS4wXVnQjkqwB9nYDxu
        vuovTxF7ZBY+aBs16vj8UQmdfRtrGlowtAW4
X-Google-Smtp-Source: ABdhPJzeOkOrgxq3JfQe7ckT8dLdEp7yNP8WD0L8R7EcDtWp2YdWOhN1ZEdoSey6/UVJeUPPlB7DpA==
X-Received: by 2002:a2e:7c08:: with SMTP id x8mr873061ljc.8.1606986351665;
        Thu, 03 Dec 2020 01:05:51 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id y14sm198744ljk.125.2020.12.03.01.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 01:05:51 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v7 bpf-next 1/2] libbpf: separate XDP program load with xsk socket creation
Date:   Thu,  3 Dec 2020 10:05:45 +0100
Message-Id: <20201203090546.11976-2-mariuszx.dudek@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201203090546.11976-1-mariuszx.dudek@intel.com>
References: <20201203090546.11976-1-mariuszx.dudek@intel.com>
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
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/libbpf.map |  2 +
 tools/lib/bpf/xsk.c      | 92 ++++++++++++++++++++++++++++++++++++----
 tools/lib/bpf/xsk.h      |  5 +++
 3 files changed, 90 insertions(+), 9 deletions(-)

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
index 9bc537d0b92d..4b051ec7cfbb 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -566,8 +566,35 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 				   &xsk->fd, 0);
 }
 
-static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
+static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
 {
+	char ifname[IFNAMSIZ];
+	struct xsk_ctx *ctx;
+	char *interface;
+
+	ctx = calloc(1, sizeof(*ctx));
+	if (!ctx)
+		return -ENOMEM;
+
+	interface = if_indextoname(ifindex, &ifname[0]);
+	if (!interface) {
+		free(ctx);
+		return -errno;
+	}
+
+	ctx->ifindex = ifindex;
+	strncpy(ctx->ifname, ifname, IFNAMSIZ - 1);
+	ctx->ifname[IFNAMSIZ - 1] = 0;
+
+	xsk->ctx = ctx;
+
+	return 0;
+}
+
+static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
+				int *xsks_map_fd)
+{
+	struct xsk_socket *xsk = _xdp;
 	struct xsk_ctx *ctx = xsk->ctx;
 	__u32 prog_id = 0;
 	int err;
@@ -584,8 +611,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 
 		err = xsk_load_xdp_prog(xsk);
 		if (err) {
-			xsk_delete_bpf_maps(xsk);
-			return err;
+			goto err_load_xdp_prog;
 		}
 	} else {
 		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
@@ -598,15 +624,29 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		}
 	}
 
-	if (xsk->rx)
+	if (xsk->rx) {
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
@@ -689,6 +729,40 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
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
+	int res;
+
+	xsk = calloc(1, sizeof(*xsk));
+	if (!xsk)
+		return -ENOMEM;
+
+	res = xsk_create_xsk_struct(ifindex, xsk);
+	if (res) {
+		free(xsk);
+		return -EINVAL;
+	}
+
+	res = __xsk_setup_xdp_prog(xsk, xsks_map_fd);
+
+	xsk_destroy_xsk_struct(xsk);
+
+	return res;
+}
+
 int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			      const char *ifname,
 			      __u32 queue_id, struct xsk_umem *umem,
@@ -838,7 +912,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	ctx->prog_fd = -1;
 
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
-		err = xsk_setup_xdp_prog(xsk);
+		err = __xsk_setup_xdp_prog(xsk, NULL);
 		if (err)
 			goto out_mmap_tx;
 	}
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 5865e082ba0b..e9f121f5d129 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -204,6 +204,11 @@ struct xsk_umem_config {
 	__u32 flags;
 };
 
+LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
+				  int *xsks_map_fd);
+LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
+					 int xsks_map_fd);
+
 /* Flags for the libbpf_flags field. */
 #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
 
-- 
2.20.1

