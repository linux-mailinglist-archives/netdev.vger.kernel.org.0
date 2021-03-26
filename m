Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1979034AACE
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCZPCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:02:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:38767 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhCZPBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 11:01:46 -0400
IronPort-SDR: GZATCxbudq9GwNz9x9QheNsT10BlafXJebpTtaZKyoKMF973vmllyvBiyWZHNwJZjkZCyX9CTN
 ME10n+JL0Czw==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190602906"
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="190602906"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 08:01:20 -0700
IronPort-SDR: 5AAm7xrC5FFa2Oj6V1UdGoSxG3CNG01kwtzkJqqV8Gq1DRSJ3sJyIeEz1knvltPkCkMxbK8UR1
 naZeW4dX8sFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="382668322"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2021 08:01:18 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        magnus.karlsson@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v2 bpf 2/3] libbpf: restore umem state after socket create failure
Date:   Fri, 26 Mar 2021 14:29:45 +0000
Message-Id: <20210326142946.5263-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326142946.5263-1-ciara.loftus@intel.com>
References: <20210326142946.5263-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the call to xsk_socket__create fails, the user may want to retry the
socket creation using the same umem. Ensure that the umem is in the
same state on exit if the call fails by:
1. ensuring the umem _save pointers are unmodified.
2. not unmapping the set of umem rings that were set up with the umem
during xsk_umem__create, since those maps existed before the call to
xsk_socket__create and should remain in tact even in the event of
failure.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/lib/bpf/xsk.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 443b0cfb45e8..d4991ddff05a 100644
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
@@ -797,8 +799,6 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
 	ctx->ifname[IFNAMSIZ - 1] = '\0';
 
-	umem->fill_save = NULL;
-	umem->comp_save = NULL;
 	ctx->fill = fill;
 	ctx->comp = comp;
 	list_add(&ctx->list, &umem->ctx_list);
@@ -854,6 +854,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_socket *xsk;
 	struct xsk_ctx *ctx;
 	int err, ifindex;
+	bool unmap = umem->fill_save != fill;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -994,6 +995,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 
 	*xsk_ptr = xsk;
+	umem->fill_save = NULL;
+	umem->comp_save = NULL;
 	return 0;
 
 out_mmap_tx:
@@ -1005,7 +1008,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		munmap(rx_map, off.rx.desc +
 		       xsk->config.rx_size * sizeof(struct xdp_desc));
 out_put_ctx:
-	xsk_put_ctx(ctx);
+	xsk_put_ctx(ctx, unmap);
 out_socket:
 	if (--umem->refcount)
 		close(xsk->fd);
@@ -1071,7 +1074,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		}
 	}
 
-	xsk_put_ctx(ctx);
+	xsk_put_ctx(ctx, true);
 
 	umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
-- 
2.17.1

