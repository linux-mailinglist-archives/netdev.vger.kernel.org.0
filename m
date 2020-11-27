Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE312C60D5
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgK0I0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgK0I0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:26:08 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C33C0613D1;
        Fri, 27 Nov 2020 00:26:08 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id r24so5873981lfm.8;
        Fri, 27 Nov 2020 00:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+vmO/a8EuHfN+0gCApJv0Z+4yazI9QZiD8etvYqBRdk=;
        b=KLKQiOMRL5/7StWlkaEMEtexS2f47Tdcir+1qgai7h0cxENHPVGYXIwygzYxSrvxwM
         rFbXnp5Qyr3kwxGdSAnvNpv6ScxwOwVkE37f5fT5Iz5f13iP4ZA4qeuKdkw6XVdw6sFo
         /6TsfciBS7yAAEIIWQMZb19DEkZSLJh3RTvygzhIXqI9tflV4epz34bfVWBpUFh5x3//
         SJwoRDdWlFSTDOHcaROaqmq0mt+DfpuEJAQDewQUIj7YReNofi5VpbBhfLcBWkMIcB37
         EN36sSvBZq8mrniU5xHo69ZCtQQc3TIwagS/mkJ3zDm+5NAQOmqn5tbo8UVjM1NG9llK
         0ySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vmO/a8EuHfN+0gCApJv0Z+4yazI9QZiD8etvYqBRdk=;
        b=k3EzSOjJr9tvg/9355c4Wb3Lufio2NplzzlG7B0f0pQs5OzaFg0zOsetGrlvQVlFUd
         j5C5G4e5cQo6a2SnWiDBP++18L3gPrHZ57nPgsXlpv2rq0HH9hyMybjvdeEx76ie7FPe
         YUpRaGg4zPi58qVIJ1yJs+gHyLOd9aTW8w2GyqG/cRQp51VQn3WtKdEE5EKqyv6CLlZX
         wcVHG/krjy2RX/UmcIZ21skiauEAWhhTxEX+fbMlttjn4Cu+fA1ygrN0zGU4Tt5c3P3g
         w23OOQOWE0vlZkZ1EysR57isrB9UiPtcpC/wwSYRxfncKimAgXX5O0eWe6ta1EXSA3XE
         aKQg==
X-Gm-Message-State: AOAM530Z+mJNxi9pcZ/TIer2gkrDthy164feubkn7T6nz/5BfFh+UZuY
        HNC4q8VnPnOBa865oGvH8fg=
X-Google-Smtp-Source: ABdhPJywfTzomN36PAWx3191S9w5xbq3O8r8qJy0NppurKdftF0wZqToQ5TqFioJyXkaV/xoVHP6ig==
X-Received: by 2002:ac2:431a:: with SMTP id l26mr677116lfh.196.1606465566972;
        Fri, 27 Nov 2020 00:26:06 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id 202sm598753lfg.203.2020.11.27.00.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 00:26:06 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v5 bpf-next 1/2] libbpf: separate XDP program load with xsk socket creation
Date:   Fri, 27 Nov 2020 09:26:00 +0100
Message-Id: <20201127082601.4762-2-mariuszx.dudek@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201127082601.4762-1-mariuszx.dudek@intel.com>
References: <20201127082601.4762-1-mariuszx.dudek@intel.com>
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
index 1719a327e5f9..10b4259f8875 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -207,6 +207,11 @@ struct xsk_umem_config {
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

