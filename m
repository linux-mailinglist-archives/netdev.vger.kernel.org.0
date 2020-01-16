Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA60E13E152
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgAPQtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbgAPQs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F542081E;
        Thu, 16 Jan 2020 16:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193337;
        bh=+cDAZTkQdBsstb6/U8Op+Z9V7NMEdynTpk2NDe7Mjk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8mBVmjRBu31K9byzT6hijiycwaDYgfok7z6P1MoFsmYM5rRoC0d9jvg4LSBjuwNN
         GFn8UegtK/262z2TJtZn8P0OUwIRbwaUjpvvtWWc7yCO/0ZkVQsjTwcgfF4ROfmtmn
         yKrsR2DmpQs83G1V/jQvmI12dnDdixmtHG6MbDXo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Eloy Degen <degeneloy@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 077/205] libbpf: Fix compatibility for kernels without need_wakeup
Date:   Thu, 16 Jan 2020 11:40:52 -0500
Message-Id: <20200116164300.6705-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 94ff9ebb49a546b7f009ed840bafa235c96d4c4b ]

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

v2 -> v3:
* Incorporated code improvements suggested by Jonathan Lemon

v1 -> v2:
* Rebased to bpf-next
* Rewrote the code as the previous version made you blind

Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
Reported-by: Eloy Degen <degeneloy@gmail.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Link: https://lore.kernel.org/bpf/1571995035-21889-1-git-send-email-magnus.karlsson@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 83 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 70f9e10de286..b29d37fba2b0 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -73,6 +73,21 @@ struct xsk_nl_info {
 	int fd;
 };
 
+/* Up until and including Linux 5.3 */
+struct xdp_ring_offset_v1 {
+	__u64 producer;
+	__u64 consumer;
+	__u64 desc;
+};
+
+/* Up until and including Linux 5.3 */
+struct xdp_mmap_offsets_v1 {
+	struct xdp_ring_offset_v1 rx;
+	struct xdp_ring_offset_v1 tx;
+	struct xdp_ring_offset_v1 fr;
+	struct xdp_ring_offset_v1 cr;
+};
+
 int xsk_umem__fd(const struct xsk_umem *umem)
 {
 	return umem ? umem->fd : -EINVAL;
@@ -133,6 +148,58 @@ static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
 	return 0;
 }
 
+static void xsk_mmap_offsets_v1(struct xdp_mmap_offsets *off)
+{
+	struct xdp_mmap_offsets_v1 off_v1;
+
+	/* getsockopt on a kernel <= 5.3 has no flags fields.
+	 * Copy over the offsets to the correct places in the >=5.4 format
+	 * and put the flags where they would have been on that kernel.
+	 */
+	memcpy(&off_v1, off, sizeof(off_v1));
+
+	off->rx.producer = off_v1.rx.producer;
+	off->rx.consumer = off_v1.rx.consumer;
+	off->rx.desc = off_v1.rx.desc;
+	off->rx.flags = off_v1.rx.consumer + sizeof(u32);
+
+	off->tx.producer = off_v1.tx.producer;
+	off->tx.consumer = off_v1.tx.consumer;
+	off->tx.desc = off_v1.tx.desc;
+	off->tx.flags = off_v1.tx.consumer + sizeof(u32);
+
+	off->fr.producer = off_v1.fr.producer;
+	off->fr.consumer = off_v1.fr.consumer;
+	off->fr.desc = off_v1.fr.desc;
+	off->fr.flags = off_v1.fr.consumer + sizeof(u32);
+
+	off->cr.producer = off_v1.cr.producer;
+	off->cr.consumer = off_v1.cr.consumer;
+	off->cr.desc = off_v1.cr.desc;
+	off->cr.flags = off_v1.cr.consumer + sizeof(u32);
+}
+
+static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
+{
+	socklen_t optlen;
+	int err;
+
+	optlen = sizeof(*off);
+	err = getsockopt(fd, SOL_XDP, XDP_MMAP_OFFSETS, off, &optlen);
+	if (err)
+		return err;
+
+	if (optlen == sizeof(*off))
+		return 0;
+
+	if (optlen == sizeof(struct xdp_mmap_offsets_v1)) {
+		xsk_mmap_offsets_v1(off);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 			    __u64 size, struct xsk_ring_prod *fill,
 			    struct xsk_ring_cons *comp,
@@ -141,7 +208,6 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	struct xdp_mmap_offsets off;
 	struct xdp_umem_reg mr;
 	struct xsk_umem *umem;
-	socklen_t optlen;
 	void *map;
 	int err;
 
@@ -190,8 +256,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 		goto out_socket;
 	}
 
-	optlen = sizeof(off);
-	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(umem->fd, &off);
 	if (err) {
 		err = -errno;
 		goto out_socket;
@@ -499,7 +564,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	struct sockaddr_xdp sxdp = {};
 	struct xdp_mmap_offsets off;
 	struct xsk_socket *xsk;
-	socklen_t optlen;
 	int err;
 
 	if (!umem || !xsk_ptr || !rx || !tx)
@@ -558,8 +622,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		}
 	}
 
-	optlen = sizeof(off);
-	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (err) {
 		err = -errno;
 		goto out_socket;
@@ -645,7 +708,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 int xsk_umem__delete(struct xsk_umem *umem)
 {
 	struct xdp_mmap_offsets off;
-	socklen_t optlen;
 	int err;
 
 	if (!umem)
@@ -654,8 +716,7 @@ int xsk_umem__delete(struct xsk_umem *umem)
 	if (umem->refcount)
 		return -EBUSY;
 
-	optlen = sizeof(off);
-	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(umem->fd, &off);
 	if (!err) {
 		munmap(umem->fill->ring - off.fr.desc,
 		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
@@ -673,7 +734,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 {
 	size_t desc_sz = sizeof(struct xdp_desc);
 	struct xdp_mmap_offsets off;
-	socklen_t optlen;
 	int err;
 
 	if (!xsk)
@@ -684,8 +744,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		close(xsk->prog_fd);
 	}
 
-	optlen = sizeof(off);
-	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
+	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (!err) {
 		if (xsk->rx) {
 			munmap(xsk->rx->ring - off.rx.desc,
-- 
2.20.1

