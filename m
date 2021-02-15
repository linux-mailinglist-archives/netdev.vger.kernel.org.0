Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24C431BE3D
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhBOQD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:03:57 -0500
Received: from mga06.intel.com ([134.134.136.31]:36147 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhBOP5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 10:57:19 -0500
IronPort-SDR: jMYrtocYHzzyvMPcWAPTP8oFazyXOi056q4diCrUASmcj0scZgB83Yydit24NNSfiXJKoQMRmf
 ZiuwMgUt+kzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244189537"
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="244189537"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 07:56:37 -0800
IronPort-SDR: cgi3/3GZli2gLB9/kiwpCge3Y0NwZv9CjppYyNKiDNRPTcr8u493RZycmKwvv9JudAxbV9Ua1g
 Q6v8CFMdSxFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="383413527"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2021 07:56:35 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Date:   Mon, 15 Feb 2021 16:46:36 +0100
Message-Id: <20210215154638.4627-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if there are multiple xdpsock instances running on a single
interface and in case one of the instances is terminated, the rest of
them are left in an inoperable state due to the fact of unloaded XDP
prog from interface.

To address that, step away from setting bpf prog in favour of bpf_link.
This means that refcounting of BPF resources will be done automatically
by bpf_link itself.

When setting up BPF resources during xsk socket creation, check whether
bpf_link for a given ifindex already exists via set of calls to
bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
and comparing the ifindexes from bpf_link and xsk socket.

If there's no bpf_link yet, create one for a given XDP prog and unload
explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.

If bpf_link is already at a given ifindex and underlying program is not
AF-XDP one, bail out or update the bpf_link's prog given the presence of
XDP_FLAGS_UPDATE_IF_NOEXIST.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/lib/bpf/xsk.c | 143 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 122 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 20500fb1f17e..5911868efa43 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -28,6 +28,7 @@
 #include <sys/mman.h>
 #include <sys/socket.h>
 #include <sys/types.h>
+#include <linux/if_link.h>
 
 #include "bpf.h"
 #include "libbpf.h"
@@ -70,6 +71,7 @@ struct xsk_ctx {
 	int ifindex;
 	struct list_head list;
 	int prog_fd;
+	int link_fd;
 	int xsks_map_fd;
 	char ifname[IFNAMSIZ];
 };
@@ -409,7 +411,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	static const int log_buf_size = 16 * 1024;
 	struct xsk_ctx *ctx = xsk->ctx;
 	char log_buf[log_buf_size];
-	int err, prog_fd;
+	int prog_fd;
 
 	/* This is the fallback C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
@@ -499,14 +501,47 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		return prog_fd;
 	}
 
-	err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, prog_fd,
-				  xsk->config.xdp_flags);
-	if (err) {
-		close(prog_fd);
-		return err;
+	ctx->prog_fd = prog_fd;
+	return 0;
+}
+
+static int xsk_create_bpf_link(struct xsk_socket *xsk)
+{
+	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
+	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
+	 */
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));
+	struct xsk_ctx *ctx = xsk->ctx;
+	__u32 prog_id;
+	int link_fd;
+	int err;
+
+	/* for !XDP_FLAGS_UPDATE_IF_NOEXIST, unload the program first, if any,
+	 * so that bpf_link can be attached
+	 */
+	if (!(xsk->config.xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
+		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
+		if (err) {
+			pr_warn("getting XDP prog id failed\n");
+			return err;
+		}
+		if (prog_id) {
+			err = bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
+			if (err < 0) {
+				pr_warn("detaching XDP prog failed\n");
+				return err;
+			}
+		}
 	}
 
-	ctx->prog_fd = prog_fd;
+	link_fd = bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_XDP, &opts);
+	if (link_fd < 0) {
+		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
+		return link_fd;
+	}
+
+	ctx->link_fd = link_fd;
 	return 0;
 }
 
@@ -625,8 +660,32 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	}
 
 	err = 0;
-	if (ctx->xsks_map_fd == -1)
+	if (ctx->xsks_map_fd != -1)
+		goto out_map_ids;
+
+	/* if prog load is forced and we found bpf_link on a given ifindex BUT
+	 * the underlying XDP prog is not an AF-XDP one, close old prog's fd,
+	 * load AF-XDP and update existing bpf_link
+	 */
+	if (!(xsk->config.xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
+		close(ctx->prog_fd);
+		err = xsk_create_bpf_maps(xsk);
+		if (err)
+			goto out_map_ids;
+
+		err = xsk_load_xdp_prog(xsk);
+		if (err) {
+			xsk_delete_bpf_maps(xsk);
+			goto out_map_ids;
+		}
+
+		/* if update failed, caller will close fds */
+		err = bpf_link_update(ctx->link_fd, ctx->prog_fd, 0);
+		if (err)
+			pr_warn("bpf_link_update failed: %s\n", strerror(errno));
+	} else {
 		err = -ENOENT;
+	}
 
 out_map_ids:
 	free(map_ids);
@@ -666,6 +725,49 @@ static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
 	return 0;
 }
 
+static int xsk_link_lookup(struct xsk_ctx *ctx, __u32 *prog_id)
+{
+	__u32 link_len = sizeof(struct bpf_link_info);
+	struct bpf_link_info link_info;
+	__u32 id = 0;
+	int err;
+	int fd;
+
+	while (true) {
+		err = bpf_link_get_next_id(id, &id);
+		if (err) {
+			if (errno == ENOENT)
+				break;
+			pr_warn("can't get next link: %s\n", strerror(errno));
+			break;
+		}
+
+		fd = bpf_link_get_fd_by_id(id);
+		if (fd < 0) {
+			if (errno == ENOENT)
+				continue;
+			pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
+			break;
+		}
+
+		memset(&link_info, 0, link_len);
+		err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
+		if (err) {
+			pr_warn("can't get link info: %s\n", strerror(errno));
+			close(fd);
+			break;
+		}
+		if (link_info.xdp.ifindex == ctx->ifindex) {
+			ctx->link_fd = fd;
+			*prog_id = link_info.prog_id;
+			break;
+		}
+		close(fd);
+	}
+
+	return errno == ENOENT ? 0 : err;
+}
+
 static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 				int *xsks_map_fd)
 {
@@ -674,8 +776,7 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 	__u32 prog_id = 0;
 	int err;
 
-	err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id,
-				  xsk->config.xdp_flags);
+	err = xsk_link_lookup(ctx, &prog_id);
 	if (err)
 		return err;
 
@@ -685,9 +786,12 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 			return err;
 
 		err = xsk_load_xdp_prog(xsk);
-		if (err) {
+		if (err)
 			goto err_load_xdp_prog;
-		}
+
+		err = xsk_create_bpf_link(xsk);
+		if (err)
+			goto err_create_bpf_link;
 	} else {
 		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
 		if (ctx->prog_fd < 0)
@@ -695,20 +799,15 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 		err = xsk_lookup_bpf_maps(xsk);
 		if (err) {
 			close(ctx->prog_fd);
+			close(ctx->link_fd);
 			return err;
 		}
 	}
 
 	if (xsk->rx) {
 		err = xsk_set_bpf_maps(xsk);
-		if (err) {
-			if (!prog_id) {
-				goto err_set_bpf_maps;
-			} else {
-				close(ctx->prog_fd);
-				return err;
-			}
-		}
+		if (err)
+			goto err_set_bpf_maps;
 	}
 	if (xsks_map_fd)
 		*xsks_map_fd = ctx->xsks_map_fd;
@@ -716,8 +815,9 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 	return 0;
 
 err_set_bpf_maps:
+	close(ctx->link_fd);
+err_create_bpf_link:
 	close(ctx->prog_fd);
-	bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
 err_load_xdp_prog:
 	xsk_delete_bpf_maps(xsk);
 
@@ -1053,6 +1153,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	if (ctx->prog_fd != -1) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
+		close(ctx->link_fd);
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
-- 
2.20.1

