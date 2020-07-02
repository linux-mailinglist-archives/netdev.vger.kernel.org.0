Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD524212332
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgGBMUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:20:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbgGBMUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:20:11 -0400
IronPort-SDR: iS6ZEDNtX0V5TRr/HvUG2eGrsW/HpbYsEQbvvOo81adBG/JRiVfqQIqMyN6AxGrEV3GdBFJv/3
 TREJ1tSAvRyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486149"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486149"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:20:09 -0700
IronPort-SDR: Pbwau3Z3tQ85+kXIoNJwdrQ52B9pG5rkN/LtHp4+gE1eow8ukPB5PUOoV6FEd61l12zF+IN3vu
 yhcQVQV38HvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933447"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:20:05 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 12/14] libbpf: support shared umems between queues and devices
Date:   Thu,  2 Jul 2020 14:19:11 +0200
Message-Id: <1593692353-15102-13-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for shared umems between hardware queues and devices to
the AF_XDP part of libbpf. This so that zero-copy can be achieved in
applications that want to send and receive packets between HW queues
on one device or between different devices/netdevs.

In order to create sockets that share a umem between hardware queues
and devices, a new function has been added called
xsk_socket__create_shared(). It takes the same arguments as
xsk_socket_create() plus references to a fill ring and a completion
ring. So for every socket that share a umem, you need to have one more
set of fill and completion rings. This in order to maintain the
single-producer single-consumer semantics of the rings.

You can create all the sockets via the new xsk_socket__create_shared()
call, or create the first one with xsk_socket__create() and the rest
with xsk_socket__create_shared(). Both methods work.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/libbpf.map |   1 +
 tools/lib/bpf/xsk.c      | 376 ++++++++++++++++++++++++++++++-----------------
 tools/lib/bpf/xsk.h      |   9 ++
 3 files changed, 254 insertions(+), 132 deletions(-)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 6544d2c..eb8065b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -288,4 +288,5 @@ LIBBPF_0.1.0 {
 		bpf_map__value_size;
 		bpf_program__autoload;
 		bpf_program__set_autoload;
+		xsk_socket__create_shared;
 } LIBBPF_0.0.9;
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index f7f4efb..86ad4f7 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
 #include <linux/if_xdp.h>
+#include <linux/list.h>
 #include <linux/sockios.h>
 #include <net/if.h>
 #include <sys/ioctl.h>
@@ -48,26 +49,35 @@
 #endif
 
 struct xsk_umem {
-	struct xsk_ring_prod *fill;
-	struct xsk_ring_cons *comp;
+	struct xsk_ring_prod *fill_save;
+	struct xsk_ring_cons *comp_save;
 	char *umem_area;
 	struct xsk_umem_config config;
 	int fd;
 	int refcount;
+	struct list_head ctx_list;
+};
+
+struct xsk_ctx {
+	struct xsk_ring_prod *fill;
+	struct xsk_ring_cons *comp;
+	__u32 queue_id;
+	struct xsk_umem *umem;
+	int refcount;
+	int ifindex;
+	struct list_head list;
+	int prog_fd;
+	int xsks_map_fd;
+	char ifname[IFNAMSIZ];
 };
 
 struct xsk_socket {
 	struct xsk_ring_cons *rx;
 	struct xsk_ring_prod *tx;
 	__u64 outstanding_tx;
-	struct xsk_umem *umem;
+	struct xsk_ctx *ctx;
 	struct xsk_socket_config config;
 	int fd;
-	int ifindex;
-	int prog_fd;
-	int xsks_map_fd;
-	__u32 queue_id;
-	char ifname[IFNAMSIZ];
 };
 
 struct xsk_nl_info {
@@ -203,15 +213,73 @@ static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
 	return -EINVAL;
 }
 
+static int xsk_create_umem_rings(struct xsk_umem *umem, int fd,
+				 struct xsk_ring_prod *fill,
+				 struct xsk_ring_cons *comp)
+{
+	struct xdp_mmap_offsets off;
+	void *map;
+	int err;
+
+	err = setsockopt(fd, SOL_XDP, XDP_UMEM_FILL_RING,
+			 &umem->config.fill_size,
+			 sizeof(umem->config.fill_size));
+	if (err)
+		return -errno;
+
+	err = setsockopt(fd, SOL_XDP, XDP_UMEM_COMPLETION_RING,
+			 &umem->config.comp_size,
+			 sizeof(umem->config.comp_size));
+	if (err)
+		return -errno;
+
+	err = xsk_get_mmap_offsets(fd, &off);
+	if (err)
+		return -errno;
+
+	map = mmap(NULL, off.fr.desc + umem->config.fill_size * sizeof(__u64),
+		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+		   XDP_UMEM_PGOFF_FILL_RING);
+	if (map == MAP_FAILED)
+		return -errno;
+
+	fill->mask = umem->config.fill_size - 1;
+	fill->size = umem->config.fill_size;
+	fill->producer = map + off.fr.producer;
+	fill->consumer = map + off.fr.consumer;
+	fill->flags = map + off.fr.flags;
+	fill->ring = map + off.fr.desc;
+	fill->cached_cons = umem->config.fill_size;
+
+	map = mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(__u64),
+		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+		   XDP_UMEM_PGOFF_COMPLETION_RING);
+	if (map == MAP_FAILED) {
+		err = -errno;
+		goto out_mmap;
+	}
+
+	comp->mask = umem->config.comp_size - 1;
+	comp->size = umem->config.comp_size;
+	comp->producer = map + off.cr.producer;
+	comp->consumer = map + off.cr.consumer;
+	comp->flags = map + off.cr.flags;
+	comp->ring = map + off.cr.desc;
+
+	return 0;
+
+out_mmap:
+	munmap(map, off.fr.desc + umem->config.fill_size * sizeof(__u64));
+	return err;
+}
+
 int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 			    __u64 size, struct xsk_ring_prod *fill,
 			    struct xsk_ring_cons *comp,
 			    const struct xsk_umem_config *usr_config)
 {
-	struct xdp_mmap_offsets off;
 	struct xdp_umem_reg mr;
 	struct xsk_umem *umem;
-	void *map;
 	int err;
 
 	if (!umem_area || !umem_ptr || !fill || !comp)
@@ -230,6 +298,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	}
 
 	umem->umem_area = umem_area;
+	INIT_LIST_HEAD(&umem->ctx_list);
 	xsk_set_umem_config(&umem->config, usr_config);
 
 	memset(&mr, 0, sizeof(mr));
@@ -244,71 +313,16 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 		err = -errno;
 		goto out_socket;
 	}
-	err = setsockopt(umem->fd, SOL_XDP, XDP_UMEM_FILL_RING,
-			 &umem->config.fill_size,
-			 sizeof(umem->config.fill_size));
-	if (err) {
-		err = -errno;
-		goto out_socket;
-	}
-	err = setsockopt(umem->fd, SOL_XDP, XDP_UMEM_COMPLETION_RING,
-			 &umem->config.comp_size,
-			 sizeof(umem->config.comp_size));
-	if (err) {
-		err = -errno;
-		goto out_socket;
-	}
 
-	err = xsk_get_mmap_offsets(umem->fd, &off);
-	if (err) {
-		err = -errno;
-		goto out_socket;
-	}
-
-	map = mmap(NULL, off.fr.desc + umem->config.fill_size * sizeof(__u64),
-		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
-		   XDP_UMEM_PGOFF_FILL_RING);
-	if (map == MAP_FAILED) {
-		err = -errno;
+	err = xsk_create_umem_rings(umem, umem->fd, fill, comp);
+	if (err)
 		goto out_socket;
-	}
-
-	umem->fill = fill;
-	fill->mask = umem->config.fill_size - 1;
-	fill->size = umem->config.fill_size;
-	fill->producer = map + off.fr.producer;
-	fill->consumer = map + off.fr.consumer;
-	fill->flags = map + off.fr.flags;
-	fill->ring = map + off.fr.desc;
-	fill->cached_prod = *fill->producer;
-	/* cached_cons is "size" bigger than the real consumer pointer
-	 * See xsk_prod_nb_free
-	 */
-	fill->cached_cons = *fill->consumer + umem->config.fill_size;
-
-	map = mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(__u64),
-		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
-		   XDP_UMEM_PGOFF_COMPLETION_RING);
-	if (map == MAP_FAILED) {
-		err = -errno;
-		goto out_mmap;
-	}
-
-	umem->comp = comp;
-	comp->mask = umem->config.comp_size - 1;
-	comp->size = umem->config.comp_size;
-	comp->producer = map + off.cr.producer;
-	comp->consumer = map + off.cr.consumer;
-	comp->flags = map + off.cr.flags;
-	comp->ring = map + off.cr.desc;
-	comp->cached_prod = *comp->producer;
-	comp->cached_cons = *comp->consumer;
 
+	umem->fill_save = fill;
+	umem->comp_save = comp;
 	*umem_ptr = umem;
 	return 0;
 
-out_mmap:
-	munmap(map, off.fr.desc + umem->config.fill_size * sizeof(__u64));
 out_socket:
 	close(umem->fd);
 out_umem_alloc:
@@ -342,6 +356,7 @@ DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
 static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 {
 	static const int log_buf_size = 16 * 1024;
+	struct xsk_ctx *ctx = xsk->ctx;
 	char log_buf[log_buf_size];
 	int err, prog_fd;
 
@@ -369,7 +384,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* *(u32 *)(r10 - 4) = r2 */
 		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -4),
 		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
+		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
 		/* r3 = XDP_PASS */
 		BPF_MOV64_IMM(BPF_REG_3, 2),
 		/* call bpf_redirect_map */
@@ -381,7 +396,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* r2 += -4 */
 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
 		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
+		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
 		/* call bpf_map_lookup_elem */
 		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
 		/* r1 = r0 */
@@ -393,7 +408,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* r2 = *(u32 *)(r10 - 4) */
 		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
 		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
+		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
 		/* r3 = 0 */
 		BPF_MOV64_IMM(BPF_REG_3, 0),
 		/* call bpf_redirect_map */
@@ -411,19 +426,21 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		return prog_fd;
 	}
 
-	err = bpf_set_link_xdp_fd(xsk->ifindex, prog_fd, xsk->config.xdp_flags);
+	err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, prog_fd,
+				  xsk->config.xdp_flags);
 	if (err) {
 		close(prog_fd);
 		return err;
 	}
 
-	xsk->prog_fd = prog_fd;
+	ctx->prog_fd = prog_fd;
 	return 0;
 }
 
 static int xsk_get_max_queues(struct xsk_socket *xsk)
 {
 	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
+	struct xsk_ctx *ctx = xsk->ctx;
 	struct ifreq ifr = {};
 	int fd, err, ret;
 
@@ -432,7 +449,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		return -errno;
 
 	ifr.ifr_data = (void *)&channels;
-	memcpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
+	memcpy(ifr.ifr_name, ctx->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
 	err = ioctl(fd, SIOCETHTOOL, &ifr);
 	if (err && errno != EOPNOTSUPP) {
@@ -460,6 +477,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 
 static int xsk_create_bpf_maps(struct xsk_socket *xsk)
 {
+	struct xsk_ctx *ctx = xsk->ctx;
 	int max_queues;
 	int fd;
 
@@ -472,15 +490,17 @@ static int xsk_create_bpf_maps(struct xsk_socket *xsk)
 	if (fd < 0)
 		return fd;
 
-	xsk->xsks_map_fd = fd;
+	ctx->xsks_map_fd = fd;
 
 	return 0;
 }
 
 static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
 {
-	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
-	close(xsk->xsks_map_fd);
+	struct xsk_ctx *ctx = xsk->ctx;
+
+	bpf_map_delete_elem(ctx->xsks_map_fd, &ctx->queue_id);
+	close(ctx->xsks_map_fd);
 }
 
 static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
@@ -488,10 +508,11 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	__u32 i, *map_ids, num_maps, prog_len = sizeof(struct bpf_prog_info);
 	__u32 map_len = sizeof(struct bpf_map_info);
 	struct bpf_prog_info prog_info = {};
+	struct xsk_ctx *ctx = xsk->ctx;
 	struct bpf_map_info map_info;
 	int fd, err;
 
-	err = bpf_obj_get_info_by_fd(xsk->prog_fd, &prog_info, &prog_len);
+	err = bpf_obj_get_info_by_fd(ctx->prog_fd, &prog_info, &prog_len);
 	if (err)
 		return err;
 
@@ -505,11 +526,11 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	prog_info.nr_map_ids = num_maps;
 	prog_info.map_ids = (__u64)(unsigned long)map_ids;
 
-	err = bpf_obj_get_info_by_fd(xsk->prog_fd, &prog_info, &prog_len);
+	err = bpf_obj_get_info_by_fd(ctx->prog_fd, &prog_info, &prog_len);
 	if (err)
 		goto out_map_ids;
 
-	xsk->xsks_map_fd = -1;
+	ctx->xsks_map_fd = -1;
 
 	for (i = 0; i < prog_info.nr_map_ids; i++) {
 		fd = bpf_map_get_fd_by_id(map_ids[i]);
@@ -523,7 +544,7 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 		}
 
 		if (!strcmp(map_info.name, "xsks_map")) {
-			xsk->xsks_map_fd = fd;
+			ctx->xsks_map_fd = fd;
 			continue;
 		}
 
@@ -531,7 +552,7 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	}
 
 	err = 0;
-	if (xsk->xsks_map_fd == -1)
+	if (ctx->xsks_map_fd == -1)
 		err = -ENOENT;
 
 out_map_ids:
@@ -541,16 +562,19 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 
 static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 {
-	return bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id,
+	struct xsk_ctx *ctx = xsk->ctx;
+
+	return bpf_map_update_elem(ctx->xsks_map_fd, &ctx->queue_id,
 				   &xsk->fd, 0);
 }
 
 static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 {
+	struct xsk_ctx *ctx = xsk->ctx;
 	__u32 prog_id = 0;
 	int err;
 
-	err = bpf_get_link_xdp_id(xsk->ifindex, &prog_id,
+	err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id,
 				  xsk->config.xdp_flags);
 	if (err)
 		return err;
@@ -566,12 +590,12 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 			return err;
 		}
 	} else {
-		xsk->prog_fd = bpf_prog_get_fd_by_id(prog_id);
-		if (xsk->prog_fd < 0)
+		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
+		if (ctx->prog_fd < 0)
 			return -errno;
 		err = xsk_lookup_bpf_maps(xsk);
 		if (err) {
-			close(xsk->prog_fd);
+			close(ctx->prog_fd);
 			return err;
 		}
 	}
@@ -580,25 +604,110 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		err = xsk_set_bpf_maps(xsk);
 	if (err) {
 		xsk_delete_bpf_maps(xsk);
-		close(xsk->prog_fd);
+		close(ctx->prog_fd);
 		return err;
 	}
 
 	return 0;
 }
 
-int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
-		       __u32 queue_id, struct xsk_umem *umem,
-		       struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
-		       const struct xsk_socket_config *usr_config)
+static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
+				   __u32 queue_id)
+{
+	struct xsk_ctx *ctx;
+
+	if (list_empty(&umem->ctx_list))
+		return NULL;
+
+	list_for_each_entry(ctx, &umem->ctx_list, list) {
+		if (ctx->ifindex == ifindex && ctx->queue_id == queue_id) {
+			ctx->refcount++;
+			return ctx;
+		}
+	}
+
+	return NULL;
+}
+
+static void xsk_put_ctx(struct xsk_ctx *ctx)
+{
+	struct xsk_umem *umem = ctx->umem;
+	struct xdp_mmap_offsets off;
+	int err;
+
+	if (--ctx->refcount == 0) {
+		err = xsk_get_mmap_offsets(umem->fd, &off);
+		if (!err) {
+			munmap(ctx->fill->ring - off.fr.desc,
+			       off.fr.desc + umem->config.fill_size *
+			       sizeof(__u64));
+			munmap(ctx->comp->ring - off.cr.desc,
+			       off.cr.desc + umem->config.comp_size *
+			       sizeof(__u64));
+		}
+
+		list_del(&ctx->list);
+		free(ctx);
+	}
+}
+
+static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
+				      struct xsk_umem *umem, int ifindex,
+				      const char *ifname, __u32 queue_id,
+				      struct xsk_ring_prod *fill,
+				      struct xsk_ring_cons *comp)
+{
+	struct xsk_ctx *ctx;
+	int err;
+
+	ctx = calloc(1, sizeof(*ctx));
+	if (!ctx)
+		return NULL;
+
+	if (!umem->fill_save) {
+		err = xsk_create_umem_rings(umem, xsk->fd, fill, comp);
+		if (err) {
+			free(ctx);
+			return NULL;
+		}
+	} else if (umem->fill_save != fill || umem->comp_save != comp) {
+		/* Copy over rings to new structs. */
+		memcpy(fill, umem->fill_save, sizeof(*fill));
+		memcpy(comp, umem->comp_save, sizeof(*comp));
+	}
+
+	ctx->ifindex = ifindex;
+	ctx->refcount = 1;
+	ctx->umem = umem;
+	ctx->queue_id = queue_id;
+	memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
+	ctx->ifname[IFNAMSIZ - 1] = '\0';
+
+	umem->fill_save = NULL;
+	umem->comp_save = NULL;
+	ctx->fill = fill;
+	ctx->comp = comp;
+	list_add(&ctx->list, &umem->ctx_list);
+	return ctx;
+}
+
+int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
+			      const char *ifname,
+			      __u32 queue_id, struct xsk_umem *umem,
+			      struct xsk_ring_cons *rx,
+			      struct xsk_ring_prod *tx,
+			      struct xsk_ring_prod *fill,
+			      struct xsk_ring_cons *comp,
+			      const struct xsk_socket_config *usr_config)
 {
 	void *rx_map = NULL, *tx_map = NULL;
 	struct sockaddr_xdp sxdp = {};
 	struct xdp_mmap_offsets off;
 	struct xsk_socket *xsk;
-	int err;
+	struct xsk_ctx *ctx;
+	int err, ifindex;
 
-	if (!umem || !xsk_ptr || !(rx || tx))
+	if (!umem || !xsk_ptr || !(rx || tx) || !fill || !comp)
 		return -EFAULT;
 
 	xsk = calloc(1, sizeof(*xsk));
@@ -609,10 +718,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	if (err)
 		goto out_xsk_alloc;
 
-	if (umem->refcount &&
-	    !(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
-		pr_warn("Error: shared umems not supported by libbpf supplied XDP program.\n");
-		err = -EBUSY;
+	xsk->outstanding_tx = 0;
+	ifindex = if_nametoindex(ifname);
+	if (!ifindex) {
+		err = -errno;
 		goto out_xsk_alloc;
 	}
 
@@ -626,16 +735,16 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		xsk->fd = umem->fd;
 	}
 
-	xsk->outstanding_tx = 0;
-	xsk->queue_id = queue_id;
-	xsk->umem = umem;
-	xsk->ifindex = if_nametoindex(ifname);
-	if (!xsk->ifindex) {
-		err = -errno;
-		goto out_socket;
+	ctx = xsk_get_ctx(umem, ifindex, queue_id);
+	if (!ctx) {
+		ctx = xsk_create_ctx(xsk, umem, ifindex, ifname, queue_id,
+				     fill, comp);
+		if (!ctx) {
+			err = -ENOMEM;
+			goto out_socket;
+		}
 	}
-	memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
-	xsk->ifname[IFNAMSIZ - 1] = '\0';
+	xsk->ctx = ctx;
 
 	if (rx) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
@@ -643,7 +752,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 				 sizeof(xsk->config.rx_size));
 		if (err) {
 			err = -errno;
-			goto out_socket;
+			goto out_put_ctx;
 		}
 	}
 	if (tx) {
@@ -652,14 +761,14 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 				 sizeof(xsk->config.tx_size));
 		if (err) {
 			err = -errno;
-			goto out_socket;
+			goto out_put_ctx;
 		}
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (err) {
 		err = -errno;
-		goto out_socket;
+		goto out_put_ctx;
 	}
 
 	if (rx) {
@@ -669,7 +778,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 			      xsk->fd, XDP_PGOFF_RX_RING);
 		if (rx_map == MAP_FAILED) {
 			err = -errno;
-			goto out_socket;
+			goto out_put_ctx;
 		}
 
 		rx->mask = xsk->config.rx_size - 1;
@@ -708,10 +817,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	xsk->tx = tx;
 
 	sxdp.sxdp_family = PF_XDP;
-	sxdp.sxdp_ifindex = xsk->ifindex;
-	sxdp.sxdp_queue_id = xsk->queue_id;
+	sxdp.sxdp_ifindex = ctx->ifindex;
+	sxdp.sxdp_queue_id = ctx->queue_id;
 	if (umem->refcount > 1) {
-		sxdp.sxdp_flags = XDP_SHARED_UMEM;
+		sxdp.sxdp_flags |= XDP_SHARED_UMEM;
 		sxdp.sxdp_shared_umem_fd = umem->fd;
 	} else {
 		sxdp.sxdp_flags = xsk->config.bind_flags;
@@ -723,7 +832,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		goto out_mmap_tx;
 	}
 
-	xsk->prog_fd = -1;
+	ctx->prog_fd = -1;
 
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = xsk_setup_xdp_prog(xsk);
@@ -742,6 +851,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	if (rx)
 		munmap(rx_map, off.rx.desc +
 		       xsk->config.rx_size * sizeof(struct xdp_desc));
+out_put_ctx:
+	xsk_put_ctx(ctx);
 out_socket:
 	if (--umem->refcount)
 		close(xsk->fd);
@@ -750,25 +861,24 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	return err;
 }
 
-int xsk_umem__delete(struct xsk_umem *umem)
+int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
+		       __u32 queue_id, struct xsk_umem *umem,
+		       struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
+		       const struct xsk_socket_config *usr_config)
 {
-	struct xdp_mmap_offsets off;
-	int err;
+	return xsk_socket__create_shared(xsk_ptr, ifname, queue_id, umem,
+					 rx, tx, umem->fill_save,
+					 umem->comp_save, usr_config);
+}
 
+int xsk_umem__delete(struct xsk_umem *umem)
+{
 	if (!umem)
 		return 0;
 
 	if (umem->refcount)
 		return -EBUSY;
 
-	err = xsk_get_mmap_offsets(umem->fd, &off);
-	if (!err) {
-		munmap(umem->fill->ring - off.fr.desc,
-		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
-		munmap(umem->comp->ring - off.cr.desc,
-		       off.cr.desc + umem->config.comp_size * sizeof(__u64));
-	}
-
 	close(umem->fd);
 	free(umem);
 
@@ -778,15 +888,16 @@ int xsk_umem__delete(struct xsk_umem *umem)
 void xsk_socket__delete(struct xsk_socket *xsk)
 {
 	size_t desc_sz = sizeof(struct xdp_desc);
+	struct xsk_ctx *ctx = xsk->ctx;
 	struct xdp_mmap_offsets off;
 	int err;
 
 	if (!xsk)
 		return;
 
-	if (xsk->prog_fd != -1) {
+	if (ctx->prog_fd != -1) {
 		xsk_delete_bpf_maps(xsk);
-		close(xsk->prog_fd);
+		close(ctx->prog_fd);
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
@@ -799,14 +910,15 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 			munmap(xsk->tx->ring - off.tx.desc,
 			       off.tx.desc + xsk->config.tx_size * desc_sz);
 		}
-
 	}
 
-	xsk->umem->refcount--;
+	xsk_put_ctx(ctx);
+
+	ctx->umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
 	 * to it.
 	 */
-	if (xsk->fd != xsk->umem->fd)
+	if (xsk->fd != ctx->umem->fd)
 		close(xsk->fd);
 	free(xsk);
 }
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 584f682..1069c46 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -234,6 +234,15 @@ LIBBPF_API int xsk_socket__create(struct xsk_socket **xsk,
 				  struct xsk_ring_cons *rx,
 				  struct xsk_ring_prod *tx,
 				  const struct xsk_socket_config *config);
+LIBBPF_API int
+xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
+			  const char *ifname,
+			  __u32 queue_id, struct xsk_umem *umem,
+			  struct xsk_ring_cons *rx,
+			  struct xsk_ring_prod *tx,
+			  struct xsk_ring_prod *fill,
+			  struct xsk_ring_cons *comp,
+			  const struct xsk_socket_config *config);
 
 /* Returns 0 for success and -EBUSY if the umem is still in use. */
 LIBBPF_API int xsk_umem__delete(struct xsk_umem *umem);
-- 
2.7.4

