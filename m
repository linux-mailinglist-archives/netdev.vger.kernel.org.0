Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0916C347B08
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhCXOpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:45:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:2051 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236208AbhCXOo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:44:57 -0400
IronPort-SDR: NGZ8b6m8Q9OA8JFmyrkUxetg/JQJyM5xEfT2JokGph4qElL02fFJSyqgW3C7VV08LHbbX0qtxt
 pW7FUq7Ibk/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="177834554"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="177834554"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 07:44:56 -0700
IronPort-SDR: 3Z5WjdL4vSeW6Dw8S/TO/2sIu+kCzedqmN08Vrkhn9ak9YkP2mUTxWpGvn6dcHGHvhxHJn1XpM
 h6oYyrz4zHsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="608127981"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2021 07:44:55 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf 2/3] libbpf: restore umem state after socket create failure
Date:   Wed, 24 Mar 2021 14:13:36 +0000
Message-Id: <20210324141337.29269-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324141337.29269-1-ciara.loftus@intel.com>
References: <20210324141337.29269-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the call to socket_create fails, the user may want to retry the
socket creation using the same umem. Ensure that the umem is in the
same state on exit if the call failed by restoring the _save pointers
and not unmapping the set of umem rings if those pointers are non NULL.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/lib/bpf/xsk.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 443b0cfb45e8..ec3c23299329 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -743,21 +743,23 @@ static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
 	return NULL;
 }
 
-static void xsk_put_ctx(struct xsk_ctx *ctx)
+static void xsk_put_ctx(struct xsk_ctx *ctx, bool unmap)
 {
 	struct xsk_umem *umem = ctx->umem;
 	struct xdp_mmap_offsets off;
 	int err;
 
 	if (--ctx->refcount == 0) {
-		err = xsk_get_mmap_offsets(umem->fd, &off);
-		if (!err) {
-			munmap(ctx->fill->ring - off.fr.desc,
-			       off.fr.desc + umem->config.fill_size *
-			       sizeof(__u64));
-			munmap(ctx->comp->ring - off.cr.desc,
-			       off.cr.desc + umem->config.comp_size *
-			       sizeof(__u64));
+		if (unmap) {
+			err = xsk_get_mmap_offsets(umem->fd, &off);
+			if (!err) {
+				munmap(ctx->fill->ring - off.fr.desc,
+				       off.fr.desc + umem->config.fill_size *
+				sizeof(__u64));
+				munmap(ctx->comp->ring - off.cr.desc,
+				       off.cr.desc + umem->config.comp_size *
+				sizeof(__u64));
+			}
 		}
 
 		list_del(&ctx->list);
@@ -854,6 +856,9 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_socket *xsk;
 	struct xsk_ctx *ctx;
 	int err, ifindex;
+	struct xsk_ring_prod *fsave = umem->fill_save;
+	struct xsk_ring_cons *csave = umem->comp_save;
+	bool unmap = !fsave;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -1005,7 +1010,9 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		munmap(rx_map, off.rx.desc +
 		       xsk->config.rx_size * sizeof(struct xdp_desc));
 out_put_ctx:
-	xsk_put_ctx(ctx);
+	umem->fill_save = fsave;
+	umem->comp_save = csave;
+	xsk_put_ctx(ctx, unmap);
 out_socket:
 	if (--umem->refcount)
 		close(xsk->fd);
@@ -1071,7 +1078,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		}
 	}
 
-	xsk_put_ctx(ctx);
+	xsk_put_ctx(ctx, true);
 
 	umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
-- 
2.17.1

