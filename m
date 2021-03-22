Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1DF34517E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCVVKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhCVVJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:12 -0400
IronPort-SDR: KBKbAUrhToHVEj+0S9IHYKusGovC9S7iDt0Xm6tLsAJR8SjMMJrJjkvTaOChUFzRQHE0+jXZ5O
 FUwvlENoW4oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423726"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423726"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:11 -0700
IronPort-SDR: jo1eHqoqSNIFcgv6cAcwAmHMYdBjQ99hHh3ZP8PxhmhmeccPUn7YJ2SIlosRf4Vyt4LhMYSQKe
 CkyNVEyvlJ6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448796"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:09 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 06/17] libbpf: xsk: use bpf_link
Date:   Mon, 22 Mar 2021 21:58:05 +0100
Message-Id: <20210322205816.65159-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if there are multiple xdpsock instances running on a single
interface and in case one of the instances is terminated, the rest of
them are left in an inoperable state due to the fact of unloaded XDP
prog from interface.

Consider the scenario below:

// load xdp prog and xskmap and add entry to xskmap at idx 10
$ sudo ./xdpsock -i ens801f0 -t -q 10

// add entry to xskmap at idx 11
$ sudo ./xdpsock -i ens801f0 -t -q 11

terminate one of the processes and another one is unable to work due to
the fact that the XDP prog was unloaded from interface.

To address that, step away from setting bpf prog in favour of bpf_link.
This means that refcounting of BPF resources will be done automatically
by bpf_link itself.

Provide backward compatibility by checking if underlying system is
bpf_link capable. Do this by looking up/creating bpf_link on loopback
device. If it failed in any way, stick with netlink-based XDP prog.
Otherwise, use bpf_link-based logic.

When setting up BPF resources during xsk socket creation, check whether
bpf_link for a given ifindex already exists via set of calls to
bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
and comparing the ifindexes from bpf_link and xsk socket.

For case where resources exist but they are not AF_XDP related, bail out
and ask user to remove existing prog and then retry.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/lib/bpf/xsk.c | 175 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 156 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 526fc35c0b23..15812e4b93ca 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -28,6 +28,7 @@
 #include <sys/mman.h>
 #include <sys/socket.h>
 #include <sys/types.h>
+#include <linux/if_link.h>
 
 #include "bpf.h"
 #include "libbpf.h"
@@ -70,8 +71,10 @@ struct xsk_ctx {
 	int ifindex;
 	struct list_head list;
 	int prog_fd;
+	int link_fd;
 	int xsks_map_fd;
 	char ifname[IFNAMSIZ];
+	bool has_bpf_link;
 };
 
 struct xsk_socket {
@@ -409,7 +412,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	static const int log_buf_size = 16 * 1024;
 	struct xsk_ctx *ctx = xsk->ctx;
 	char log_buf[log_buf_size];
-	int err, prog_fd;
+	int prog_fd;
 
 	/* This is the fallback C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
@@ -499,14 +502,43 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		return prog_fd;
 	}
 
-	err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, prog_fd,
-				  xsk->config.xdp_flags);
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
+	__u32 prog_id = 0;
+	int link_fd;
+	int err;
+
+	err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
 	if (err) {
-		close(prog_fd);
+		pr_warn("getting XDP prog id failed\n");
 		return err;
 	}
 
-	ctx->prog_fd = prog_fd;
+	/* if there's a netlink-based XDP prog loaded on interface, bail out
+	 * and ask user to do the removal by himself
+	 */
+	if (prog_id) {
+		pr_warn("Netlink-based XDP prog detected, please unload it in order to launch AF_XDP prog\n");
+		return -EINVAL;
+	}
+
+	link_fd = bpf_link_create(ctx->prog_fd, ctx->ifindex, BPF_XDP, &opts);
+	if (link_fd < 0) {
+		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
+		return link_fd;
+	}
+
+	ctx->link_fd = link_fd;
 	return 0;
 }
 
@@ -625,7 +657,6 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 		close(fd);
 	}
 
-	err = 0;
 	if (ctx->xsks_map_fd == -1)
 		err = -ENOENT;
 
@@ -642,6 +673,97 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 				   &xsk->fd, 0);
 }
 
+static int xsk_link_lookup(int ifindex, __u32 *prog_id, int *link_fd)
+{
+	struct bpf_link_info link_info;
+	__u32 link_len;
+	__u32 id = 0;
+	int err;
+	int fd;
+
+	while (true) {
+		err = bpf_link_get_next_id(id, &id);
+		if (err) {
+			if (errno == ENOENT) {
+				err = 0;
+				break;
+			}
+			pr_warn("can't get next link: %s\n", strerror(errno));
+			break;
+		}
+
+		fd = bpf_link_get_fd_by_id(id);
+		if (fd < 0) {
+			if (errno == ENOENT)
+				continue;
+			pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
+			err = -errno;
+			break;
+		}
+
+		link_len = sizeof(struct bpf_link_info);
+		memset(&link_info, 0, link_len);
+		err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
+		if (err) {
+			pr_warn("can't get link info: %s\n", strerror(errno));
+			close(fd);
+			break;
+		}
+		if (link_info.type == BPF_LINK_TYPE_XDP) {
+			if (link_info.xdp.ifindex == ifindex) {
+				*link_fd = fd;
+				if (prog_id)
+					*prog_id = link_info.prog_id;
+				break;
+			}
+		}
+		close(fd);
+	}
+
+	return err;
+}
+
+static bool xsk_probe_bpf_link(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .flags = XDP_FLAGS_SKB_MODE);
+	struct bpf_load_program_attr prog_attr;
+	struct bpf_insn insns[2] = {
+		BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
+		BPF_EXIT_INSN()
+	};
+	int prog_fd, link_fd = -1;
+	int ifindex_lo = 1;
+	bool ret = false;
+	int err;
+
+	err = xsk_link_lookup(ifindex_lo, NULL, &link_fd);
+	if (err)
+		return ret;
+
+	if (link_fd >= 0)
+		return true;
+
+	memset(&prog_attr, 0, sizeof(prog_attr));
+	prog_attr.prog_type = BPF_PROG_TYPE_XDP;
+	prog_attr.insns = insns;
+	prog_attr.insns_cnt = ARRAY_SIZE(insns);
+	prog_attr.license = "GPL";
+
+	prog_fd = bpf_load_program_xattr(&prog_attr, NULL, 0);
+	if (prog_fd < 0)
+		return ret;
+
+	link_fd = bpf_link_create(prog_fd, ifindex_lo, BPF_XDP, &opts);
+	if (link_fd >= 0)
+		ret = true;
+
+	close(prog_fd);
+	close(link_fd);
+
+	return ret;
+}
+
 static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
 {
 	char ifname[IFNAMSIZ];
@@ -663,6 +785,7 @@ static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
 	ctx->ifname[IFNAMSIZ - 1] = 0;
 
 	xsk->ctx = ctx;
+	xsk->ctx->has_bpf_link = xsk_probe_bpf_link();
 
 	return 0;
 }
@@ -675,8 +798,10 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 	__u32 prog_id = 0;
 	int err;
 
-	err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id,
-				  xsk->config.xdp_flags);
+	if (ctx->has_bpf_link)
+		err = xsk_link_lookup(ctx->ifindex, &prog_id, &ctx->link_fd);
+	else
+		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
 	if (err)
 		return err;
 
@@ -686,9 +811,16 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 			return err;
 
 		err = xsk_load_xdp_prog(xsk);
-		if (err) {
+		if (err)
 			goto err_load_xdp_prog;
-		}
+
+		if (ctx->has_bpf_link)
+			err = xsk_create_bpf_link(xsk);
+		else
+			err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, ctx->prog_fd,
+						  xsk->config.xdp_flags);
+		if (err)
+			goto err_attach_prog;
 	} else {
 		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
 		if (ctx->prog_fd < 0)
@@ -696,20 +828,18 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 		err = xsk_lookup_bpf_maps(xsk);
 		if (err) {
 			close(ctx->prog_fd);
+			if (ctx->has_bpf_link)
+				close(ctx->link_fd);
+			else
+				bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);
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
@@ -717,8 +847,12 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
 	return 0;
 
 err_set_bpf_maps:
+	if (ctx->has_bpf_link)
+		close(ctx->link_fd);
+	else
+		bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);
+err_attach_prog:
 	close(ctx->prog_fd);
-	bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
 err_load_xdp_prog:
 	xsk_delete_bpf_maps(xsk);
 
@@ -898,6 +1032,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		}
 	}
 	xsk->ctx = ctx;
+	xsk->ctx->has_bpf_link = xsk_probe_bpf_link();
 
 	if (rx) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
@@ -1054,6 +1189,8 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	if (ctx->prog_fd != -1) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
+		if (ctx->has_bpf_link)
+			close(ctx->link_fd);
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
-- 
2.20.1

