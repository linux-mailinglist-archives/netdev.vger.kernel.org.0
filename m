Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68DF34F8EF
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhCaGoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:44:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:14630 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233780AbhCaGoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 02:44:02 -0400
IronPort-SDR: Qr2+YHvTcUEOSAFIjdweIBlxUFyIPf4CJdznZWkyvPc94Io8wm1EUvbSsPbmkyUGjnRtG4WCVS
 1Lbf2JnbTUAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277111333"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="277111333"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 23:44:02 -0700
IronPort-SDR: xmZkpm5nC4d0w9YtcRU3LWOWZunI5pRJ46SpyPWggYevHePjkuQ75Mt+PUw5YUiCXIZRu+up4Y
 C9UfZy/pTsow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="445523168"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2021 23:44:00 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        alexei.starovoitov@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v4 bpf 2/3] libbpf: restore umem state after socket create failure
Date:   Wed, 31 Mar 2021 06:12:17 +0000
Message-Id: <20210331061218.1647-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210331061218.1647-1-ciara.loftus@intel.com>
References: <20210331061218.1647-1-ciara.loftus@intel.com>
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
 tools/lib/bpf/xsk.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 443b0cfb45e8..5098d9e3b55a 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -743,26 +743,30 @@ static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
 	return NULL;
 }
 
-static void xsk_put_ctx(struct xsk_ctx *ctx)
+static void xsk_put_ctx(struct xsk_ctx *ctx, bool unmap)
 {
 	struct xsk_umem *umem = ctx->umem;
 	struct xdp_mmap_offsets off;
 	int err;
 
-	if (--ctx->refcount == 0) {
-		err = xsk_get_mmap_offsets(umem->fd, &off);
-		if (!err) {
-			munmap(ctx->fill->ring - off.fr.desc,
-			       off.fr.desc + umem->config.fill_size *
-			       sizeof(__u64));
-			munmap(ctx->comp->ring - off.cr.desc,
-			       off.cr.desc + umem->config.comp_size *
-			       sizeof(__u64));
-		}
+	if (--ctx->refcount)
+		return;
 
-		list_del(&ctx->list);
-		free(ctx);
-	}
+	if (!unmap)
+		goto out_free;
+
+	err = xsk_get_mmap_offsets(umem->fd, &off);
+	if (err)
+		goto out_free;
+
+	munmap(ctx->fill->ring - off.fr.desc, off.fr.desc + umem->config.fill_size *
+	       sizeof(__u64));
+	munmap(ctx->comp->ring - off.cr.desc, off.cr.desc + umem->config.comp_size *
+	       sizeof(__u64));
+
+out_free:
+	list_del(&ctx->list);
+	free(ctx);
 }
 
 static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
@@ -797,8 +801,6 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
 	ctx->ifname[IFNAMSIZ - 1] = '\0';
 
-	umem->fill_save = NULL;
-	umem->comp_save = NULL;
 	ctx->fill = fill;
 	ctx->comp = comp;
 	list_add(&ctx->list, &umem->ctx_list);
@@ -854,6 +856,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_socket *xsk;
 	struct xsk_ctx *ctx;
 	int err, ifindex;
+	bool unmap = umem->fill_save != fill;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -994,6 +997,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 
 	*xsk_ptr = xsk;
+	umem->fill_save = NULL;
+	umem->comp_save = NULL;
 	return 0;
 
 out_mmap_tx:
@@ -1005,7 +1010,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		munmap(rx_map, off.rx.desc +
 		       xsk->config.rx_size * sizeof(struct xdp_desc));
 out_put_ctx:
-	xsk_put_ctx(ctx);
+	xsk_put_ctx(ctx, unmap);
 out_socket:
 	if (--umem->refcount)
 		close(xsk->fd);
@@ -1071,7 +1076,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		}
 	}
 
-	xsk_put_ctx(ctx);
+	xsk_put_ctx(ctx, true);
 
 	umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
-- 
2.17.1

