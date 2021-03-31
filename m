Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AFC34F8F3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhCaGoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:44:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:14630 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233817AbhCaGoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 02:44:04 -0400
IronPort-SDR: 0eZOBCSH/whwK/1qOqbWsdPsbKRA+ZmzBMudKeoeYz8WAicVBcLRRSvWTT45jvBOS0ezY6DjKv
 /ww/oxqwODSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277111342"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="277111342"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 23:44:04 -0700
IronPort-SDR: u4pZQBhQWR4I0uUz9+bQAnRJCZgwG1/U0GqD4iOKFkeF33i+cbik/XqY+j/TIcpIQ4BoHvuK6G
 KtflLnCv+NEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="445523209"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2021 23:44:02 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        alexei.starovoitov@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v4 bpf 3/3] libbpf: only create rx and tx XDP rings when necessary
Date:   Wed, 31 Mar 2021 06:12:18 +0000
Message-Id: <20210331061218.1647-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210331061218.1647-1-ciara.loftus@intel.com>
References: <20210331061218.1647-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this commit xsk_socket__create(_shared) always attempted to create
the rx and tx rings for the socket. However this causes an issue when the
socket being setup is that which shares the fd with the UMEM. If a
previous call to this function failed with this socket after the rings were
set up, a subsequent call would always fail because the rings are not torn
down after the first call and when we try to set them up again we encounter
an error because they already exist. Solve this by remembering whether the
rings were set up by introducing new bools to struct xsk_umem which
represent the ring setup status and using them to determine whether or
not to set up the rings.

Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/lib/bpf/xsk.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 5098d9e3b55a..d24b5cc720ec 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -59,6 +59,8 @@ struct xsk_umem {
 	int fd;
 	int refcount;
 	struct list_head ctx_list;
+	bool rx_ring_setup_done;
+	bool tx_ring_setup_done;
 };
 
 struct xsk_ctx {
@@ -857,6 +859,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_ctx *ctx;
 	int err, ifindex;
 	bool unmap = umem->fill_save != fill;
+	bool rx_setup_done = false, tx_setup_done = false;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -884,6 +887,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		}
 	} else {
 		xsk->fd = umem->fd;
+		rx_setup_done = umem->rx_ring_setup_done;
+		tx_setup_done = umem->tx_ring_setup_done;
 	}
 
 	ctx = xsk_get_ctx(umem, ifindex, queue_id);
@@ -902,7 +907,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 	xsk->ctx = ctx;
 
-	if (rx) {
+	if (rx && !rx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
 				 &xsk->config.rx_size,
 				 sizeof(xsk->config.rx_size));
@@ -910,8 +915,10 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->rx_ring_setup_done = true;
 	}
-	if (tx) {
+	if (tx && !tx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
 				 &xsk->config.tx_size,
 				 sizeof(xsk->config.tx_size));
@@ -919,6 +926,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->rx_ring_setup_done = true;
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
-- 
2.17.1

