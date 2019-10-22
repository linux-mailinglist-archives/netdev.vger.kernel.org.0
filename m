Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D5ADFF5B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 10:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbfJVI0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 04:26:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:65278 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388155AbfJVI0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 04:26:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 01:26:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="348986785"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.103.211.44])
  by orsmga004.jf.intel.com with ESMTP; 22 Oct 2019 01:26:06 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, degeneloy@gmail.com, john.fastabend@gmail.com
Subject: [PATCH bpf-next v2] libbpf: fix compatibility for kernels without need_wakeup
Date:   Tue, 22 Oct 2019 10:25:56 +0200
Message-Id: <1571732756-20692-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the need_wakeup flag was added to AF_XDP, the format of the
XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
kernel to take care of compatibility issues arrising from running
applications using any of the two formats. However, libbpf was
not extended to take care of the case when the application/libbpf
uses the new format but the kernel only supports the old
format. This patch adds support in libbpf for parsing the old
format, before the need_wakeup flag was added, and emulating a
set of static need_wakeup flags that will always work for the
application.

v1 -> v2:
* Rebased to bpf-next
* Rewrote the code as the previous version made you blind

Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
Reported-by: Eloy Degen <degeneloy@gmail.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.c | 79 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 12 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 7866500..aa16458 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -73,6 +73,21 @@ struct xsk_nl_info {
 	int fd;
 };
 
+/* Up until and including Linux 5.3 */
+struct xdp_ring_offset_no_flags {
+	__u64 producer;
+	__u64 consumer;
+	__u64 desc;
+};
+
+/* Up until and including Linux 5.3 */
+struct xdp_mmap_offsets_no_flags {
+	struct xdp_ring_offset_no_flags rx;
+	struct xdp_ring_offset_no_flags tx;
+	struct xdp_ring_offset_no_flags fr;
+	struct xdp_ring_offset_no_flags cr;
+};
+
 int xsk_umem__fd(const struct xsk_umem *umem)
 {
 	return umem ? umem->fd : -EINVAL;
@@ -133,6 +148,54 @@ static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
 	return 0;
 }
 
+static bool xsk_mmap_offsets_has_flags(socklen_t optlen)
+{
+	return (optlen == sizeof(struct xdp_mmap_offsets)) ? true : false;
+}
+
+static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
+{
+	struct xdp_mmap_offsets_no_flags off_no_flag;
+	socklen_t optlen;
+	int err;
+
+	optlen = sizeof(*off);
+	err = getsockopt(fd, SOL_XDP, XDP_MMAP_OFFSETS, off, &optlen);
+	if (err)
+		return err;
+
+	if (xsk_mmap_offsets_has_flags(optlen))
+		return 0;
+
+	/* getsockopt on a kernel <= 5.3 has no flags fields.
+	 * Copy over the offsets to the correct places in the >=5.4 format
+	 * and put the flags where they would have been on that kernel.
+	 */
+	memcpy(&off_no_flag, off, sizeof(off_no_flag));
+
+	off->rx.producer = off_no_flag.rx.producer;
+	off->rx.consumer = off_no_flag.rx.consumer;
+	off->rx.desc = off_no_flag.rx.desc;
+	off->rx.flags = off_no_flag.rx.consumer + sizeof(u32);
+
+	off->tx.producer = off_no_flag.tx.producer;
+	off->tx.consumer = off_no_flag.tx.consumer;
+	off->tx.desc = off_no_flag.tx.desc;
+	off->tx.flags = off_no_flag.tx.consumer + sizeof(u32);
+
+	off->fr.producer = off_no_flag.fr.producer;
+	off->fr.consumer = off_no_flag.fr.consumer;
+	off->fr.desc = off_no_flag.fr.desc;
+	off->fr.flags = off_no_flag.fr.consumer + sizeof(u32);
+
+	off->cr.producer = off_no_flag.cr.producer;
+	off->cr.consumer = off_no_flag.cr.consumer;
+	off->cr.desc = off_no_flag.cr.desc;
+	off->cr.flags = off_no_flag.cr.consumer + sizeof(u32);
+
+	return 0;
+}
+
 int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 			    __u64 size, struct xsk_ring_prod *fill,
 			    struct xsk_ring_cons *comp,
@@ -141,7 +204,6 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	struct xdp_mmap_offsets off;
 	struct xdp_umem_reg mr;
 	struct xsk_umem *umem;
-	socklen_t optlen;
 	void *map;
 	int err;
 
@@ -190,8 +252,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 		goto out_socket;
 	}
 
-	optlen = sizeof(off);
-	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(umem->fd, &off);
 	if (err) {
 		err = -errno;
 		goto out_socket;
@@ -492,7 +553,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	struct sockaddr_xdp sxdp = {};
 	struct xdp_mmap_offsets off;
 	struct xsk_socket *xsk;
-	socklen_t optlen;
 	int err;
 
 	if (!umem || !xsk_ptr || !rx || !tx)
@@ -551,8 +611,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		}
 	}
 
-	optlen = sizeof(off);
-	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (err) {
 		err = -errno;
 		goto out_socket;
@@ -638,7 +697,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 int xsk_umem__delete(struct xsk_umem *umem)
 {
 	struct xdp_mmap_offsets off;
-	socklen_t optlen;
 	int err;
 
 	if (!umem)
@@ -647,8 +705,7 @@ int xsk_umem__delete(struct xsk_umem *umem)
 	if (umem->refcount)
 		return -EBUSY;
 
-	optlen = sizeof(off);
-	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(umem->fd, &off);
 	if (!err) {
 		munmap(umem->fill->ring - off.fr.desc,
 		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
@@ -666,7 +723,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 {
 	size_t desc_sz = sizeof(struct xdp_desc);
 	struct xdp_mmap_offsets off;
-	socklen_t optlen;
 	int err;
 
 	if (!xsk)
@@ -677,8 +733,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		close(xsk->prog_fd);
 	}
 
-	optlen = sizeof(off);
-	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (!err) {
 		if (xsk->rx) {
 			munmap(xsk->rx->ring - off.rx.desc,
-- 
2.7.4

